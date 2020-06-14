// Generated at 2020-06-14 14:38:49 (250ms) for v2.3+

//{ HashMap

function HashMap(l_initialSize) constructor {
	/// HashMap(initialSize:int = 256)
	/// @param {int} initialSize=256
	static _size = undefined;
	static _capacity = undefined;
	static _hashes = undefined;
	static _keys = undefined;
	static _values = undefined;
	static copy = function() {
		var l_n = self._capacity;
		var l_m = new HashMap(l_n);
		l_m._size = self._size;
		array_copy(l_m._hashes, 0, self._hashes, 0, l_n);
		array_copy(l_m._values, 0, self._values, 0, l_n);
		array_copy(l_m._keys, 0, self._keys, 0, l_n);
		return l_m;
	}
	static clear = function() {
		var l_i = self._capacity;
		var l__hashes = self._hashes;
		var l__keys = self._keys;
		var l__values = self._values;
		while (--l_i >= 0) {
			l__hashes[@l_i] = undefined;
			l__keys[@l_i] = 0;
			l__values[@l_i] = 0;
		}
		self._size = 0;
	}
	static empty = function() {
		return self._size == 0;
	}
	static size = function() {
		return self._size;
	}
	static capacity = function() {
		return self._capacity;
	}
	static exists = function(l_key) {
		var l_b = HashMap_hashBuffer;
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
	static get = function(l_key) {
		var l_b = HashMap_hashBuffer;
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
	static _rehash = function() {
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
	static _setPre = function(l_hash, l_key) {
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
	static set = function(l_key, l_val) {
		var l_b = HashMap_hashBuffer;
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
	static replace = function(l_key, l_value) {
		var l_b = HashMap_hashBuffer;
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
	static remove = function(l_key) {
		var l_b = HashMap_hashBuffer;
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
	static iterator = function() {
		return new HashMapIterator(self);
	}
	static keys = function() {
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
	static values = function() {
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
	static toString = function() {
		var l_b = HashMap_hashBuffer;
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
	static toStruct = function() {
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
	if (l_initialSize == undefined) l_initialSize = 256;
	if (false) throw argument[0];
	self._size = 0;
	self._capacity = l_initialSize;
	self._hashes = array_create(l_initialSize, undefined);
	self._keys = array_create(l_initialSize);
	self._values = array_create(l_initialSize);
	//
}

//}

//{ HashMapIterator

function HashMapIterator(l_m) constructor {
	// HashMapIterator(m:HashMap)
	static key = undefined;
	static value = undefined;
	static map = undefined;
	static index = undefined;
	static count = undefined;
	static next = function() {
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
	self.index = 0;
	self.map = l_m;
	self.count = l_m._capacity;
	//
}

//}

// HashMap:
globalvar HashMap_hashBuffer; HashMap_hashBuffer = buffer_create(128, buffer_grow, 1);

