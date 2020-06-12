// Generated at 2020-06-13 00:27:23 (321ms) for v2.3+

//{ Map

function Map(l_initialSize) constructor {
	/// Map(initialSize:int = 256)
	/// @param {int} initialSize=256
	static _size = undefined;
	static _capacity = undefined;
	static _hashes = undefined;
	static _keys = undefined;
	static _values = undefined;
	static clear = method(undefined, Map_clear);
	static size = method(undefined, Map_size);
	static capacity = method(undefined, Map_capacity);
	static copy = method(undefined, Map_copy);
	static get = method(undefined, Map_get);
	static exists = method(undefined, Map_exists);
	static replace = method(undefined, Map_replace);
	static remove = method(undefined, Map_remove);
	static _rehash = method(undefined, Map__rehash);
	static _setPre = method(undefined, Map__setPre);
	static set = method(undefined, Map_set);
	static iterator = method(undefined, Map_iterator);
	static keys = method(undefined, Map_keys);
	static values = method(undefined, Map_values);
	static toString = method(undefined, Map_toString);
	static toStruct = method(undefined, Map_toStruct);
	if (l_initialSize == undefined) l_initialSize = 256;
	if (false) throw argument[0];
	self._size = 0;
	self._capacity = l_initialSize;
	self._hashes = array_create(l_initialSize, undefined);
	self._keys = array_create(l_initialSize);
	self._values = array_create(l_initialSize);
	//
}

function Map_clear() {
	/// Map_clear()
	var l_i = self._capacity;
	var l__hashes = self._hashes;
	var l__keys = self._keys;
	var l__values = self._values;
	while (--l_i >= 0) {
		l__hashes[@l_i] = -1;
		l__keys[@l_i] = 0;
		l__values[@l_i] = 0;
	}
	self._size = 0;
}

function Map_size() {
	/// Map_size()->int
	return self._size;
}

function Map_capacity() {
	/// Map_capacity()->int
	return self._capacity;
}

function Map_copy() {
	/// Map_copy()->Map
	var l_n = self._capacity;
	var l_m = new Map(l_n);
	l_m._size = self._size;
	array_copy(l_m._hashes, 0, self._hashes, 0, l_n);
	array_copy(l_m._values, 0, self._values, 0, l_n);
	array_copy(l_m._keys, 0, self._keys, 0, l_n);
	return l_m;
}

function Map_get(l_key) {
	/// Map_get(key:any)->any
	/// @param {any} key
	var l_b = Map_hashBuffer;
	var l_hash;
	if (is_string(l_key)) {
		buffer_seek(l_b, buffer_seek_start, 0);
		buffer_write(l_b, buffer_text, l_key);
		l_hash = buffer_crc32(l_b, 0, buffer_tell(l_b));
	} else if (is_real(l_key)) {
		buffer_poke(l_b, 0, buffer_f64, l_key);
		l_hash = buffer_crc32(l_b, 0, 8);
	} else if (is_numeric(l_key)) {
		buffer_poke(l_b, 0, buffer_u64, l_key);
		l_hash = buffer_crc32(l_b, 0, 8);
	} else if (l_key == undefined) {
		l_hash = buffer_crc32(l_b, 0, 0);
	} else {
		show_error(typeof(l_key) + " cannot be used as a key.", true);
		l_hash = 0;
	}
	var l__capacity = self._capacity;
	var l__hashes = self._hashes;
	var l__keys = self._keys;
	var l_curr = l_hash % l__capacity;
	var l_i = -1;
	repeat (8) {
		if (l__hashes[l_curr] == l_hash && l__keys[l_curr] == l_key) {
			l_i = l_curr;
			break;
		}
		l_curr = (l_curr + 1) % l__capacity;
	}
	if (l_i >= 0) return self._values[l_i]; else return undefined;
}

function Map_exists(l_key) {
	/// Map_exists(key:any)->any
	/// @param {any} key
	var l_b = Map_hashBuffer;
	var l_hash;
	if (is_string(l_key)) {
		buffer_seek(l_b, buffer_seek_start, 0);
		buffer_write(l_b, buffer_text, l_key);
		l_hash = buffer_crc32(l_b, 0, buffer_tell(l_b));
	} else if (is_real(l_key)) {
		buffer_poke(l_b, 0, buffer_f64, l_key);
		l_hash = buffer_crc32(l_b, 0, 8);
	} else if (is_numeric(l_key)) {
		buffer_poke(l_b, 0, buffer_u64, l_key);
		l_hash = buffer_crc32(l_b, 0, 8);
	} else if (l_key == undefined) {
		l_hash = buffer_crc32(l_b, 0, 0);
	} else {
		show_error(typeof(l_key) + " cannot be used as a key.", true);
		l_hash = 0;
	}
	var l__capacity = self._capacity;
	var l__hashes = self._hashes;
	var l__keys = self._keys;
	var l_curr = l_hash % l__capacity;
	var l_index = -1;
	repeat (8) {
		if (l__hashes[l_curr] == l_hash && l__keys[l_curr] == l_key) {
			l_index = l_curr;
			break;
		}
		l_curr = (l_curr + 1) % l__capacity;
	}
	return l_index >= 0;
}

function Map_replace(l_key, l_value) {
	/// Map_replace(key:any, value:any)->bool
	/// @param {any} key
	/// @param {any} value
	var l_b = Map_hashBuffer;
	var l_hash;
	if (is_string(l_key)) {
		buffer_seek(l_b, buffer_seek_start, 0);
		buffer_write(l_b, buffer_text, l_key);
		l_hash = buffer_crc32(l_b, 0, buffer_tell(l_b));
	} else if (is_real(l_key)) {
		buffer_poke(l_b, 0, buffer_f64, l_key);
		l_hash = buffer_crc32(l_b, 0, 8);
	} else if (is_numeric(l_key)) {
		buffer_poke(l_b, 0, buffer_u64, l_key);
		l_hash = buffer_crc32(l_b, 0, 8);
	} else if (l_key == undefined) {
		l_hash = buffer_crc32(l_b, 0, 0);
	} else {
		show_error(typeof(l_key) + " cannot be used as a key.", true);
		l_hash = 0;
	}
	var l__capacity = self._capacity;
	var l__hashes = self._hashes;
	var l__keys = self._keys;
	var l_curr = l_hash % l__capacity;
	var l_i = -1;
	repeat (8) {
		if (l__hashes[l_curr] == l_hash && l__keys[l_curr] == l_key) {
			l_i = l_curr;
			break;
		}
		l_curr = (l_curr + 1) % l__capacity;
	}
	if (l_i >= 0) {
		self._values[@l_i] = l_value;
		return true;
	} else return false;
}

function Map_remove(l_key) {
	/// Map_remove(key:any)->any
	/// @param {any} key
	var l_b = Map_hashBuffer;
	var l_hash;
	if (is_string(l_key)) {
		buffer_seek(l_b, buffer_seek_start, 0);
		buffer_write(l_b, buffer_text, l_key);
		l_hash = buffer_crc32(l_b, 0, buffer_tell(l_b));
	} else if (is_real(l_key)) {
		buffer_poke(l_b, 0, buffer_f64, l_key);
		l_hash = buffer_crc32(l_b, 0, 8);
	} else if (is_numeric(l_key)) {
		buffer_poke(l_b, 0, buffer_u64, l_key);
		l_hash = buffer_crc32(l_b, 0, 8);
	} else if (l_key == undefined) {
		l_hash = buffer_crc32(l_b, 0, 0);
	} else {
		show_error(typeof(l_key) + " cannot be used as a key.", true);
		l_hash = 0;
	}
	var l__capacity = self._capacity;
	var l__hashes = self._hashes;
	var l__keys = self._keys;
	var l_curr = l_hash % l__capacity;
	var l_i = -1;
	repeat (8) {
		if (l__hashes[l_curr] == l_hash && l__keys[l_curr] == l_key) {
			l_i = l_curr;
			break;
		}
		l_curr = (l_curr + 1) % l__capacity;
	}
	if (l_i >= 0) {
		self._hashes[@l_i] = undefined;
		self._keys[@l_i] = 0;
		self._values[@l_i] = 0;
		self._size -= 1;
		return true;
	} else return false;
}

function Map__rehash() {
	// Map__rehash()
	var l__oldCap = self._capacity;
	var l__oldHashes = self._hashes;
	var l__oldKeys = self._keys;
	var l__oldValues = self._values;
	var l__newCap = l__oldCap * 2;
	var l__newHashes = array_create(l__newCap, undefined);
	var l__newKeys = array_create(l__newCap);
	var l__newValues = array_create(l__newCap);
	repeat (8) {
		var l__oldInd = -1;
		while (++l__oldInd < l__oldCap) {
			var l_hash = l__oldHashes[l__oldInd];
			if (l_hash == undefined) continue;
			var l_curr = l_hash % l__newCap;
			for (var l__attempt = -1; ++l__attempt < 8; l_curr = (l_curr + 1) % l__newCap) {
				if (l__newHashes[l_curr] == undefined) break;
			}
			if (l__attempt >= 8) break;
			l__newHashes[@l_curr] = l_hash;
			l__newKeys[@l_curr] = l__oldKeys[l__oldInd];
			l__newValues[@l_curr] = l__oldValues[l__oldInd];
		}
		if (l__oldInd < l__oldCap) {
			l__newCap *= 2;
			l__newHashes = array_create(l__newCap, undefined);
			l__newKeys = array_create(l__newCap);
			l__newValues = array_create(l__newCap);
		} else break;
	}
	self._hashes = l__newHashes;
	self._keys = l__newKeys;
	self._values = l__newValues;
	self._capacity = l__newCap;
}

function Map__setPre(l_hash, l_key) {
	// Map__setPre(hash:int, key:any)->int
	var l__capacity = self._capacity;
	if (self._size >= l__capacity / 2) return -1;
	var l_curr = l_hash % l__capacity;
	var l__hashes = self._hashes;
	var l__keys = self._keys;
	repeat (8) {
		var l_h = l__hashes[l_curr];
		if (l_h == l_hash) return l_curr;
		if (l_h == undefined) {
			l__hashes[@l_curr] = l_hash;
			l__keys[@l_curr] = l_key;
			self._size += 1;
			return l_curr;
		}
		l_curr = (l_curr + 1) % l__capacity;
	}
	return -1;
}

function Map_set(l_key, l_val) {
	/// Map_set(key:any, val:any)
	/// @param {any} key
	/// @param {any} val
	var l_b = Map_hashBuffer;
	var l_hash;
	if (is_string(l_key)) {
		buffer_seek(l_b, buffer_seek_start, 0);
		buffer_write(l_b, buffer_text, l_key);
		l_hash = buffer_crc32(l_b, 0, buffer_tell(l_b));
	} else if (is_real(l_key)) {
		buffer_poke(l_b, 0, buffer_f64, l_key);
		l_hash = buffer_crc32(l_b, 0, 8);
	} else if (is_numeric(l_key)) {
		buffer_poke(l_b, 0, buffer_u64, l_key);
		l_hash = buffer_crc32(l_b, 0, 8);
	} else if (l_key == undefined) {
		l_hash = buffer_crc32(l_b, 0, 0);
	} else {
		show_error(typeof(l_key) + " cannot be used as a key.", true);
		l_hash = 0;
	}
	for (var l_index = self._setPre(l_hash, l_key); l_index < 0; l_index = self._setPre(l_hash, l_key)) {
		self._rehash();
	}
	self._values[@l_index] = l_val;
}

function Map_iterator() {
	/// Map_iterator()->MapIterator
	return new MapIterator(self);
}

function Map_keys() {
	/// Map_keys()->array<any>
	var l_result = array_create(self._size);
	var l__hashes = self._hashes;
	var l__keys = self._keys;
	var l_k = -1;
	var l_i = 0;
	for (var l__g1 = self._capacity; l_i < l__g1; l_i++) {
		if (l__hashes[l_i] == undefined) continue;
		l_result[@++l_k] = l__keys[l_i];
	}
	return l_result;
}

function Map_values() {
	/// Map_values()->array<any>
	var l_result = array_create(self._size);
	var l__hashes = self._hashes;
	var l__values = self._values;
	var l_k = -1;
	var l_i = 0;
	for (var l__g1 = self._capacity; l_i < l__g1; l_i++) {
		if (l__hashes[l_i] == undefined) continue;
		l_result[@++l_k] = l__values[l_i];
	}
	return l_result;
}

function Map_toString() {
	/// Map_toString()->string
	var l_b = Map_hashBuffer;
	buffer_seek(l_b, buffer_seek_start, 0);
	buffer_write(l_b, buffer_text, "Map({");
	var l_sep = false;
	var l__keys = self._keys;
	var l__values = self._values;
	var l__hashes = self._hashes;
	var l_i = 0;
	for (var l__g1 = self._capacity; l_i < l__g1; l_i++) {
		if (l__hashes[l_i] == undefined) continue;
		if (l_sep) buffer_write(l_b, buffer_u8, 44); else l_sep = true;
		buffer_write(l_b, buffer_u8, 32);
		var l_key = l__keys[l_i];
		if (is_string(l_key)) {
			buffer_write(l_b, buffer_u8, 34);
			buffer_write(l_b, buffer_text, l_key);
			buffer_write(l_b, buffer_u8, 34);
		} else buffer_write(l_b, buffer_text, string(l_key));
		buffer_write(l_b, buffer_text, ": ");
		buffer_write(l_b, buffer_text, string(l__values[l_i]));
	}
	buffer_write(l_b, buffer_string, " })");
	buffer_seek(l_b, buffer_seek_start, 0);
	return buffer_read(l_b, buffer_string);
}

function Map_toStruct() {
	/// Map_toStruct()->dynamic
	var l_obj = {};
	var l__keys = self._keys;
	var l__values = self._values;
	var l__hashes = self._hashes;
	var l_i = 0;
	for (var l__g1 = self._capacity; l_i < l__g1; l_i++) {
		if (l__hashes[l_i] == undefined) continue;
		variable_struct_set(l_obj, l__keys[l_i], l__values[l_i]);
	}
	return l_obj;
}

//}

//{ MapIterator

function MapIterator(l_m) constructor {
	// MapIterator(m:Map)
	static key = undefined;
	static value = undefined;
	static map = undefined;
	static index = undefined;
	static count = undefined;
	static next = method(undefined, MapIterator_next);
	self.index = 0;
	self.map = l_m;
	self.count = l_m._capacity;
	//
}

function MapIterator_next() {
	// MapIterator_next()->bool
	var l_i = self.index;
	var l_n = self.count;
	var l__hashes = self.map._hashes;
	while (l_i < l_n) {
		if (l__hashes[l_i] != undefined) {
			self.key = self.map._keys[l_i];
			self.value = self.map._values[l_i];
			self.index = l_i + 1;
			return true;
		} else l_i++;
	}
	self.index = l_i;
	return false;
}

//}

// Map:
globalvar Map_hashBuffer; Map_hashBuffer = buffer_create(32, buffer_grow, 1);

