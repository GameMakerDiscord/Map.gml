package ;
import gml.Lib;
import gml.NativeArray;
import gml.NativeStruct;
import gml.NativeType;
import gml.io.Buffer;

/**
 * 
 * @author YellowAfterlife
 * @dmdPath HashMap
 */
@:nativeGen @:keep class HashMap {
	// A vague port of https://github.com/petewarden/c_hashmap
	extern private static inline var maxChainLen:Int = 8;
	@:native("hashBuffer")
	private static var buffer = new Buffer(128, Grow, 1);
	
	private var _size:Int = 0;
	/** size of hashes/keys/values */
	private var _capacity:Int;
	private var _hashes:Array<Null<Int>>;
	private var _keys:Array<Any>;
	private var _values:Array<Any>;
	
	/**
	 * Creates a new map with specified initial capacity.
	 * 
	 * Default is 256, but you may make it lower if you know the approximate number of keys
	 * (check whether the map expands using [capacity]).
	 */
	@:doc public function new(initialSize:Int = 256) {
		_capacity = initialSize;
		_hashes = NativeArray.create(initialSize, null);
		_keys = NativeArray.createEmpty(initialSize);
		_values = NativeArray.createEmpty(initialSize);
	}
	
	/**
	 * Returns a shallow copy of this map.
	 */
	@:doc public function copy():HashMap {
		var n = _capacity;
		var m = new HashMap(n);
		m._size = _size;
		NativeArray.copyPart(m._hashes, 0, _hashes, 0, n);
		NativeArray.copyPart(m._values, 0, _values, 0, n);
		NativeArray.copyPart(m._keys, 0, _keys, 0, n);
		return m;
	}
	
	/**
	 * Removes all key-value pairs from this map.
	 * @dmdSuffix ---
	 */
	@:doc public function clear():Void {
		var i = _capacity;
		var _hashes = _hashes;
		var _keys = _keys;
		var _values = _values;
		while (--i >= 0) {
			_hashes[i] = null;
			_keys[i] = 0;
			_values[i] = 0;
		}
		_size = 0;
	}
	
	/** Returns whether this map contains no key-value pairs. */
	@:doc public function empty():Bool {
		return _size == 0;
	}
	
	/** Returns the current number of key-value pairs in the map. */
	@:doc public function size():Int {
		return _size;
	}
	
	/**
	 * Returns the current map capacity - that is,
	 * how many entries do the internal arrays hold.
	 * A map is resized whenever size reaches half of capacity
	 * or if a key-value pair cannot be fit due to a sufficient number of collisions.
	 * @dmdSuffix ---
	 */
	@:doc public function capacity():Int {
		return _capacity;
	}
	
	extern inline function getImpl<T>(hash:Int, key:Any):Int {
		var _capacity = _capacity;
		var _hashes = _hashes;
		var _keys = _keys;
		var curr = hash % _capacity;
		var index = -1;
		for (_ in 0 ... maxChainLen) {
			var h = _hashes[curr];
			if (_hashes[curr] == hash && _keys[curr] == key) {
				index = curr;
				break;
			}
			curr = (curr + 1) % _capacity;
		}
		return index;
	}
	
	extern static inline function hashOf(val:Any):Int {
		var b = buffer;
		if (NativeType.isString(val)) {
			b.rewind();
			b.writeChars(val);
			return b.crc32(0, b.position);
		} else if (NativeType.isReal(val)) {
			b.pokeDouble(0, val);
			return b.crc32(0, 8);
		} else if (NativeType.isNumber(val)) {
			b.pokeInt64(0, val);
			return b.crc32(0, 8);
		} else if (val == null) {
			return b.crc32(0, 0); // ah, the good ol' hash of nothing
		} else {
			Lib.error(NativeType.typeof(val) + " cannot be used as a key.", true);
			return 0;
		}
	}
	
	/**
	 * Returns whether a key-value exists for the given key.
	 */
	@:doc public function exists(key:Any):Any {
		var i = getImpl(hashOf(key), key);
		return i >= 0;
	}
	
	/**
	 * Returns a value for the given key, or,
	 * if there is no such key-value pair,
	 */
	@:doc public function get(key:Any):Any {
		var i = getImpl(hashOf(key), key);
		return i >= 0 ? _values[i] : null;
	}
	
	/** Doubles the capacity of the map and rearranges key-value pairs. */
	function _rehash():Void {
		var _oldCap = _capacity;
		var _oldHashes = _hashes;
		var _oldKeys = _keys;
		var _oldValues = _values;
		var _newCap = _oldCap * 2;
		var _newHashes = NativeArray.create(_newCap, null);
		var _newKeys = NativeArray.createEmpty(_newCap);
		var _newValues = NativeArray.createEmpty(_newCap);
		for (pass in 0 ... 8) {
			var _oldInd = -1;
			while (++_oldInd < _oldCap) {
				var hash = _oldHashes[_oldInd];
				if (hash == null) continue;
				var curr = hash % _newCap;
				var _attempt = -1;
				while (++_attempt < maxChainLen) {
					if (_newHashes[curr] == null) break;
					curr = (curr + 1) % _newCap;
				}
				if (_attempt >= maxChainLen) {
					#if hashmap_debug
					Lib.trace('Couldn\'t fit '
						+ NativeType.toString(hash)
						+ ' in resized hash array, resizing again...');
					#end
					break;
				}
				_newHashes[curr] = hash;
				_newKeys[curr] = _oldKeys[_oldInd];
				_newValues[curr] = _oldValues[_oldInd];
			}
			//
			if (_oldInd < _oldCap) {
				_newCap *= 2;
				_newHashes = NativeArray.create(_newCap, null);
				_newKeys = NativeArray.createEmpty(_newCap);
				_newValues = NativeArray.createEmpty(_newCap);
			} else break;
		}
		//
		_hashes = _newHashes;
		_keys = _newKeys;
		_values = _newValues;
		_capacity = _newCap;
	}
	
	/** Attempts to find a spot for a new key-value pair. */
	private function _setPre(hash:Int, key:Any):Int {
		var _capacity = _capacity;
		if (_size >= _capacity / 2) {
			#if hashmap_debug
			trace('$_size >= $_capacity/2, resizing');
			#end
			return -1;
		}
		var curr = hash % _capacity;
		var _hashes = _hashes;
		var _keys = _keys;
		for (_ in 0 ... maxChainLen) {
			var h = _hashes[curr];
			if (h == hash) return curr;
			if (h == null) {
				_hashes[curr] = hash;
				_keys[curr] = key;
				_size += 1;
				return curr;
			}
			curr = (curr + 1) % _capacity;
		}
		return -1;
	}
	
	/**
	 * Adds a new key-value pair to the map or updates the value of an existing one.
	 * 
	 * As per [capacity], this may trigger a reallocation of the map.
	 */
	@:doc public function set(key:Any, val:Any):Void {
		var hash = hashOf(key);
		var index = _setPre(hash, key);
		while (index < 0) {
			_rehash();
			index = _setPre(hash, key);
		}
		_values[index] = val;
	}
	
	/**
	 * Finds a key-value pair for the given key and replaces the value with a new one.
	 * 
	 * Returns `true` if the value was replaced,
	 * or `false` if the pair was not found.
	 */
	@:doc public function replace(key:Any, value:Any):Bool {
		var i = getImpl(hashOf(key), key);
		if (i >= 0) {
			_values[i] = value;
			return true;
		} else return false;
	}
	
	/**
	 * Removes a key-value pair, returns whether successful
	 * (`false` if no pair with the given key existed).
	 * @dmdSuffix ---
	 */
	@:doc public function remove(key:Any):Bool {
		var i = getImpl(hashOf(key), key);
		if (i >= 0) {
			_hashes[i] = null;
			_keys[i] = 0;
			_values[i] = 0;
			_size -= 1;
			return true;
		} else return false;
	}
	
	/**
	Creates and returns a new iterator for this map.
	
	The iterator has a single method called `next`,
	which will pull out the next key-value pair and store it in its `key`/`value` fields,
	subsequently returning `true`, or will return `false` if it has reached the end of the map.
	
	You would usually use it like so:
	```gml
	var map = new Map();
	map.set("one", 1);
	map.set(2, "two");
	var it = map.iterator();
	while (it.next()) {
		trace("iter", it.key, "=>", it.value);
	}
	// shorter: for (var it = map.iterator(); it.next();) {...}
	```
	**/
	@:doc public function iterator() {
		return new HashMapIterator(this);
	}
	
	/**
	 * Returns an array containing all keys in the map.\
	 * Not ordered in a specific way, but consistent with [values].
	 */
	@:doc public function keys():Array<Any> {
		var result = NativeArray.createEmpty(_size);
		var _hashes = _hashes;
		var _keys = _keys;
		var k = -1;
		for (i in 0 ... _capacity) {
			if (_hashes[i] == null) continue;
			result[++k] = _keys[i];
		}
		return result;
	}
	
	/**
	 * Returns an array containing all values in the map.\
	 * Not ordered in a specific way, but consistent with [keys].
	 * @dmdSuffix ---
	 */
	@:doc public function values():Array<Any> {
		var result = NativeArray.createEmpty(_size);
		var _hashes = _hashes;
		var _values = _values;
		var k = -1;
		for (i in 0 ... _capacity) {
			if (_hashes[i] == null) continue;
			result[++k] = _values[i];
		}
		return result;
	}
	
	/**
	 * Returns a string representation of this map, in a somewhat JSON-looking
	 * (but not valid JSON) format - `Map({ key1: value1, key2: value2, ... })`
	 */
	@:doc public function toString():String {
		var b = buffer;
		b.rewind();
		b.writeChars("Map({");
		var sep = false;
		var _keys = _keys;
		var _values = _values;
		var _hashes = _hashes;
		for (i in 0 ... _capacity) {
			if (_hashes[i] == null) continue;
			if (sep) b.writeByte(",".code); else sep = true;
			b.writeByte(" ".code);
			var key = _keys[i];
			if (Std.is(key, String)) {
				b.writeByte('"'.code);
				b.writeChars(key);
				b.writeByte('"'.code);
			} else b.writeChars(NativeType.toString(key));
			b.writeChars(": ");
			b.writeChars(NativeType.toString(_values[i]));
		}
		b.writeString(" })");
		b.rewind();
		return b.readString();
	}
	
	/**
	 * Returns a new struct containing key-value pairs from this map.
	 * @return struct
	 */
	@:doc public function toStruct():Dynamic {
		var obj:Dynamic = {};
		var _keys = _keys;
		var _values = _values;
		var _hashes = _hashes;
		for (i in 0 ... _capacity) {
			if (_hashes[i] == null) continue;
			NativeStruct.setField(obj, _keys[i], _values[i]);
		}
		return obj;
	}
	
	public static inline function main() {}
}

@:nativeGen @:keep class HashMapIterator {
	public var key:Any;
	public var value:Any;
	public var map:HashMap;
	public var index:Int = 0;
	public var count:Int;
	public function new(m:HashMap) {
		map = m;
		count = @:privateAccess m._capacity;
	}
	public function next():Bool @:privateAccess {
		var i = index;
		var n = count;
		var _hashes = map._hashes;
		while (i < n) {
			if (_hashes[i] != null) {
				key = map._keys[i];
				value = map._values[i];
				index = i + 1;
				return true;
			} else i++;
		}
		index = i;
		return false;
	}
}