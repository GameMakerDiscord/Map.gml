// Generated at 2020-06-14 14:38:49 (184ms) for v2.3+

//{ LightMap

function LightMap() constructor {
	/// LightMap()
	static _struct = undefined;
	static copy = function() {
		var l_result = new LightMap();
		var l_resObj = l_result._struct;
		var l_obj = self._struct;
		var l_keys = variable_struct_get_names(l_obj);
		var l_keyCount = array_length(l_keys);
		var l_i = -1;
		while (++l_i < l_keyCount) {
			var l_key = l_keys[l_i];
			variable_struct_set(l_resObj, l_key, variable_struct_get(l_obj, l_key));
		}
		return l_result;
	}
	static empty = function() {
		return variable_struct_names_count(self._struct) == 0;
	}
	static size = function() {
		return variable_struct_names_count(self._struct);
	}
	static exists = function(l_key) {
		return variable_struct_exists(self._struct, l_key);
	}
	static get = function(l_key) {
		return variable_struct_get(self._struct, l_key);
	}
	static set = function(l_key, l_val) {
		variable_struct_set(self._struct, l_key, l_val);
	}
	static replace = function(l_key, l_val) {
		if (variable_struct_exists(self._struct, l_key)) {
			variable_struct_set(self._struct, l_key, l_val);
			return true;
		} else return false;
	}
	static keys = function() {
		return variable_struct_get_names(self._struct);
	}
	static values = function() {
		var l_obj = self._struct;
		var l_keys = variable_struct_get_names(l_obj);
		var l_keyCount = array_length(l_keys);
		var l_values = array_create(l_keyCount);
		var l_i = -1;
		while (++l_i < l_keyCount) {
			l_values[@l_i] = variable_struct_get(l_obj, l_keys[l_i]);
		}
		return l_values;
	}
	static toString = function() {
		return string(self._struct);
	}
	self._struct = {};
	//
}

//}


