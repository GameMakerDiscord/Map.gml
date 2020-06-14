// Generated at 2020-06-14 14:38:50 (191ms) for v2.3+

//{ StructMap

function StructMap() constructor {
	/// StructMap()
	static _struct = undefined;
	static _blanks = undefined;
	static _cachedKeys = undefined;
	static copy = function() {
		var l_obj = self._struct;
		var l_blank = StructMap_blank;
		var l_result = new StructMap();
		var l_resObj = l_result._struct;
		var l_keys = variable_struct_get_names(l_obj);
		var l_keyCount = array_length(l_keys);
		var l_i = -1;
		var l_key;
		if (self._blanks > 0) {
			while (++l_i < l_keyCount) {
				l_key = l_keys[l_i];
				var l_val = variable_struct_get(l_obj, l_key);
				if (l_val != l_blank) variable_struct_set(l_resObj, l_key, l_val);
			}
		} else while (++l_i < l_keyCount) {
			l_key = l_keys[l_i];
			variable_struct_set(l_resObj, l_key, variable_struct_get(l_obj, l_key));
		}
		return l_result;
	}
	static clear = function() {
		var l_obj = self._struct;
		var l_keys = variable_struct_get_names(l_obj);
		var l_keyCount = array_length(l_keys);
		var l_blank = StructMap_blank;
		var l_i = -1;
		while (++l_i < l_keyCount) {
			variable_struct_set(l_obj, l_keys[l_i], l_blank);
		}
		self._blanks = l_keyCount;
	}
	static empty = function() {
		return variable_struct_names_count(self._struct) - self._blanks == 0;
	}
	static size = function() {
		return variable_struct_names_count(self._struct) - self._blanks;
	}
	static exists = function(l_key) {
		if (variable_struct_exists(self._struct, l_key)) {
			if (self._blanks > 0) return variable_struct_get(self._struct, l_key) != StructMap_blank; else return true;
		} else return false;
	}
	static get = function(l_key) {
		var l_val = variable_struct_get(self._struct, l_key);
		if (l_val != StructMap_blank) return l_val; else return undefined;
	}
	static set = function(l_key, l_val) {
		if (self._blanks > 0) {
			var l_cachedKeys = self._cachedKeys;
			if (l_cachedKeys != undefined) {
				if (variable_struct_exists(self._struct, l_key)) {
					if (variable_struct_get(self._struct, l_key) == StructMap_blank) self._blanks--;
				} else l_cachedKeys[@array_length(l_cachedKeys)] = l_key;
			} else if (variable_struct_get(self._struct, l_key) == StructMap_blank) {
				self._blanks--;
			}
		}
		variable_struct_set(self._struct, l_key, l_val);
	}
	static replace = function(l_key, l_val) {
		if (variable_struct_exists(self._struct, l_key)) {
			if (self._blanks > 0 && variable_struct_get(self._struct, l_key) == StructMap_blank) return false;
			variable_struct_set(self._struct, l_key, l_val);
			return true;
		} else return false;
	}
	static remove = function(l_key) {
		if (variable_struct_exists(self._struct, l_key)) {
			if (self._blanks > 0) {
				if (variable_struct_get(self._struct, l_key) == StructMap_blank) return false;
				self._cachedKeys = undefined;
			}
			variable_struct_set(self._struct, l_key, StructMap_blank);
			self._blanks++;
			return true;
		} else return false;
	}
	static keys = function(l_copy) {
		if (l_copy == undefined) l_copy = true;
		if (false) throw argument[0];
		var l_keys = self._cachedKeys;
		if (l_keys != undefined) {
			if (l_copy) {
				var l_keyCount = array_length(l_keys);
				var l_resKeys = array_create(l_keyCount);
				array_copy(l_resKeys, 0, l_keys, 0, l_keyCount);
				return l_resKeys;
			} else return l_keys;
		}
		if (self._blanks > 0) {
			var l_obj = self._struct;
			var l_keys = variable_struct_get_names(l_obj);
			var l_keyCount = array_length(l_keys);
			var l_resKeys = array_create(l_keyCount - self._blanks);
			var l_resCount = -1;
			var l_i = -1;
			while (++l_i < l_keyCount) {
				var l_key = l_keys[l_i];
				if (variable_struct_get(l_obj, l_key) != StructMap_blank) l_resKeys[@++l_resCount] = l_key;
			}
			self._cachedKeys = l_resKeys;
			if (l_copy) {
				l_keys = array_create(l_resCount);
				array_copy(l_keys, 0, l_resKeys, 0, l_resCount);
				return l_keys;
			} else return l_resKeys;
		} else return variable_struct_get_names(self._struct);
	}
	static values = function() {
		var l_keys;
		var l_obj = self._struct;
		if (self._blanks > 0) {
			l_keys = self._cachedKeys;
			if (l_keys == undefined) {
				var l_keys1 = variable_struct_get_names(l_obj);
				var l_keyCount = array_length(l_keys1);
				var l_resKeys = array_create(l_keyCount - self._blanks);
				var l_resCount = -1;
				var l_i = -1;
				while (++l_i < l_keyCount) {
					var l_key = l_keys1[l_i];
					if (variable_struct_get(l_obj, l_key) != StructMap_blank) l_resKeys[@++l_resCount] = l_key;
				}
				self._cachedKeys = l_resKeys;
				l_keys = l_resKeys;
			}
		} else l_keys = variable_struct_get_names(l_obj);
		var l_keyCount = array_length(l_keys);
		var l_values = array_create(l_keyCount);
		var l_i = -1;
		while (++l_i < l_keyCount) {
			l_values[@l_i] = variable_struct_get(l_obj, l_keys[l_i]);
		}
		return l_values;
	}
	static toString = function() {
		if (self._blanks <= 0) return string(self._struct);
		var l_obj = self._struct;
		var l_keys = variable_struct_get_names(l_obj);
		var l_keyCount = array_length(l_keys);
		var l_tmp = {};
		var l_i = -1;
		while (++l_i < l_keyCount) {
			var l_key = l_keys[l_i];
			if (variable_struct_get(l_obj, l_key) != StructMap_blank) variable_struct_set(l_tmp, l_key, variable_struct_get(l_obj, l_key));
		}
		return string(l_tmp);
	}
	self._cachedKeys = undefined;
	self._blanks = 0;
	self._struct = {};
	//
}

//}

// StructMap:
globalvar StructMap_blank; StructMap_blank = [];

