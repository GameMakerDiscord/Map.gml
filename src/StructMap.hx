package ;
import gml.NativeArray;
import gml.NativeStruct;
import gml.NativeType;
import gml.io.Buffer;

/**
 * A wrapper around `variable_struct_` functions that supports key-value pair "removal"
 * (by storing a special value in "unused" pairs and accounting for these).
 * @dmdPath StructMap
 * @author YellowAfterlife
 */
@:nativeGen @:doc @:keep class StructMap {
	/** A unique value to indicate a "hole" */
	@:noDoc static var blank:Dynamic = [];
	
	/** The underlying struct */
	@:noDoc @:native("_struct") var obj:StructAccess = new StructAccess();
	
	/** Number of "holes" (removed pairs) in this structure */
	@:noDoc @:native("_blanks") var blanks:Int = 0;
	
	@:noDoc @:native("_cachedKeys") var cachedKeys:Array<String> = null;
	
	public function new() {
		
	}
	
	/**
	 * Returns a shallow copy of this structure.
	 * The copy will only contain the fields that have not been marked as "unused".
	 */
	public function copy():StructMap {
		var obj = obj;
		var blank = blank;
		var result = new StructMap();
		var resObj = result.obj;
		//
		var keys = obj.keys();
		var keyCount = keys.length;
		var i = -1;
		var key:String;
		if (blanks > 0) while (++i < keyCount) {
			key = keys[i];
			var val = obj[key];
			if (val != blank) resObj[key] = val;
		}
		else while (++i < keyCount) {
			key = keys[i];
			resObj[key] = obj[key];
		}
		return result;
	}
	
	/**
	 * Marks all key-value pairs in this structure as "unused".
	 * @dmdSuffix ---
	 */
	public function clear():Void {
		var obj = obj;
		var keys = obj.keys();
		var keyCount = keys.length;
		var blank = blank;
		var i = -1; while (++i < keyCount) {
			obj[keys[i]] = blank;
		}
		blanks = keyCount;
	}
	
	/**
	 * Returns whether this structure contains no used key-value pairs.
	 */
	public function empty():Bool {
		return obj.size() - blanks == 0;
	}
	
	/**
	 * Returns the number of key-value pairs in this structure, excluding ones marked as unused.
	 */
	public function size():Int {
		return obj.size() - blanks;
	}
	
	/**
	 * @dmdPrefix ---
	 * Returns whether the given key exists in this structure.
	 */
	public function exists(key:String):Bool {
		return obj.exists(key) && (blanks <= 0 || obj[key] != blank);
	}
	
	/**
	 * Retrieves a value for the specified key, or `undefined` if it did not exist.
	 * @return ?value
	 */
	public function get(key:String):Any {
		var val = obj[key];
		return val != blank ? val : null;
	}
	
	/**
	 * Adds a new key-value pair of replaces an existing one.
	 */
	public function set(key:String, val:Any):Void {
		if (blanks > 0) {
			var cachedKeys = cachedKeys;
			if (cachedKeys != null) {
				if (obj.exists(key)) {
					if (obj[key] == blank) blanks--;
				} else {
					cachedKeys[cachedKeys.length] = key;
				}
			} else {
				if (obj[key] == blank) blanks--;
			}
		}
		obj[key] = val;
	}
	
	/**
	 * Attempts to replace a value by a new one.
	 * 
	 * Returns `true` if the value was replaced
	 * or `false` if the key did not exist in this structure.
	 * @return replaced?
	 */
	public function replace(key:String, val:Any):Bool {
		if (obj.exists(key)) {
			if (blanks > 0 && obj[key] == blank) return false;
			obj[key] = val;
			return true;
		} else return false;
	}
	
	/**
	 * Attempts to remove a value from the structure, marking it as "unused".
	 * 
	 * Returns whether the value was present (and thus was removed).
	 * @return removed?
	 * @dmdSuffix ---
	 */
	public function remove(key:String):Bool {
		if (obj.exists(key)) {
			if (blanks > 0) {
				if (obj[key] == blank) return false;
				cachedKeys = null;
			}
			obj[key] = blank;
			blanks++;
			return true;
		} else return false;
	}
	
	@:noDoc extern inline function cacheKeys(copy:Bool, obj:StructAccess) {
		var keys = obj.keys();
		var keyCount = keys.length;
		var resKeys = NativeArray.createEmpty(keyCount - blanks);
		var resCount = -1;
		var i = -1; while (++i < keyCount) {
			var key = keys[i];
			if (obj[key] != blank) {
				resKeys[++resCount] = key;
			}
		}
		cachedKeys = resKeys;
		if (copy) {
			keys = NativeArray.createEmpty(resCount);
			NativeArray.copyPart(keys, 0, resKeys, 0, resCount);
			return keys;
		} else return resKeys;
	}
	
	/**
	 * Returns an array of keys in this structure.\
	 * Not ordered in a specific way, but consistent with [values].
	 * 
	 * If the optional `copy` parameter is set to `false` (default is `true`),
	 * the function will return a cached array where possible
	 * - good if you don't intend to modify the array!
	 */
	public function keys(copy:Bool = true):Array<String> {
		var keys = cachedKeys;
		if (keys != null) {
			if (copy) {
				var keyCount = keys.length;
				var resKeys = NativeArray.createEmpty(keyCount);
				NativeArray.copyPart(resKeys, 0, keys, 0, keyCount);
				return resKeys;
			} else return keys;
		}
		if (blanks > 0) {
			return cacheKeys(copy, obj);
		} else {
			return obj.keys(); // apparently this is really fast
		}
	}
	
	/**
	 * Returns an array of values in this structure.\
	 * Not ordered in a specific way, but consistent with [keys].
	 */
	public function values():Array<Any> {
		var keys:Array<String>;
		var obj = obj;
		if (blanks > 0) {
			keys = cachedKeys;
			if (keys == null) {
				keys = cacheKeys(false, obj);
			}
		} else keys = obj.keys();
		//
		var keyCount = keys.length;
		var values = NativeArray.createEmpty(keyCount);
		var i = -1; while (++i < keyCount) {
			values[i] = obj[keys[i]];
		}
		return values;
	}
	
	/**
	 * @dmdPrefix ---
	 * Returns a string representation of this structure, excluding unused key-value pairs.
	 */
	public function toString() {
		if (blanks <= 0) return NativeType.toString(obj);
		var obj = obj;
		var keys = obj.keys();
		var keyCount = keys.length;
		var tmp = new StructAccess();
		var i = -1;
		while (++i < keyCount) {
			var key = keys[i];
			var val = obj[key];
			if (val != blank) tmp[key] = obj[key];
		}
		return NativeType.toString(tmp);
	}
	
	@:noDoc static inline function main() {}
}
