package ;
import gml.NativeStruct;
/**
 * ...
 * @author YellowAfterlife
 */
abstract StructAccess(Dynamic) {
	public inline function new() {
		this = {};
	}
	@:arrayAccess public inline function get(key:String):Any {
		return NativeStruct.getField(this, key);
	}
	public inline function set(key:String, val:Any):Void {
		NativeStruct.setField(this, key, val);
	}
	@:arrayAccess public inline function chainset(key:String, val:Any):Any {
		NativeStruct.setField(this, key, val);
		return val;
	}
	public inline function keys():Array<String> {
		return NativeStruct.getFieldNames(this);
	}
	public inline function size():Int {
		return NativeStruct.getFieldCount(this);
	}
	public inline function exists(key:String):Bool {
		return NativeStruct.hasField(this, key);
	}
}