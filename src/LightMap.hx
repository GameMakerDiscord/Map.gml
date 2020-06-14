package ;
import gml.NativeArray;

/**
 * A very simple wrapper around `variable_struct_` functions.
 * @author YellowAfterlife
 * @dmdPath LightMap
 */
@:keep @:nativeGen @:doc class LightMap {
	@:noDoc @:native("_struct") var obj:StructAccess = new StructAccess();
	public function new() {
		//
	}
	/**
	 * Returns a shallow copy of this structure.
	 */
	public function copy() {
		var result = new LightMap();
		var resObj = result.obj;
		var obj = obj;
		var keys = obj.keys();
		var keyCount = keys.length;
		var i = -1; while (++i < keyCount) {
			var key = keys[i];
			resObj[key] = obj[key];
		}
		return result;
	}
	
	/**
	 * @dmdPrefix ---
	 * Returns whether this structure contains no key-value pairs.
	 */
	public function empty():Bool {
		return obj.size() == 0;
	}
	/** Returns the number of key-value pairs in this structure. */
	public function size():Int {
		return obj.size();
	}
	
	/**
	 * @dmdPrefix ---
	 * Returns whether the given key exists in this structure.
	 */
	public function exists(key:String):Bool {
		return obj.exists(key);
	}
	
	/**
	 * Retrieves a value for the specified key, or `undefined` if it did not exist.
	 * @return ?value
	 */
	public function get(key:String):Any {
		return obj[key];
	}
	
	/**
	 * Adds a new key-value pair of replaces an existing one.
	 */
	public function set(key:String, val:Any):Void {
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
			obj[key] = val;
			return true;
		} else return false;
	}
	
	/**
	 * @dmdPrefix ---
	 * Returns an array of keys in this structure.\
	 * Not ordered in a specific way, but consistent with [values].
	 */
	public function keys():Array<String> {
		return obj.keys();
	}
	
	/**
	 * Returns an array of values in this structure.\
	 * Not ordered in a specific way, but consistent with [keys].
	 */
	public function values():Array<Any> {
		var obj = obj;
		var keys = obj.keys();
		var keyCount = keys.length;
		var values = NativeArray.createEmpty(keyCount);
		var i = -1; while (++i < keyCount) {
			values[i] = obj[keys[i]];
		}
		return values;
	}
	
	/**
	 * @dmdPrefix ---
	 * Returns a string representation of this structure.
	 */
	public function toString() {
		return gml.NativeType.toString(obj);
	}
	
	@:noDoc static inline function main() {}
}