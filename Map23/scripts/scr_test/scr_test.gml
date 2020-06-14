// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_test() {
	var classes = [LightMap, StructMap, HashMap];
	for (var pass = 0; pass < 3; pass++) {
		var m; switch (pass) {
			case 0: m = new LightMap(); break;
			case 1: m = new StructMap(); break;
			case 2: m = new HashMap(); break;
		}
		assert_equals(m.empty(), true, "empty by default");
		m.set("hi!", "hello!");
		assert_equals(m.empty(), false, "not empty after adding a key");
		assert_equals(m.size(), 1, "size=1 adding a key");
		assert_equals(m.exists("hi!"), true, "contains added key");
		assert_equals(m.get("hi!"), "hello!", "added key value");
		//
		if (pass != 0) {
			m.remove("hi!");
			assert_equals(m.empty(), true, "empty after removing a key");
			assert_equals(m.exists("hi!"), false, "does not contain removed key");
			assert_equals(m.get("hi!"), undefined, "removed value is undefined");
			m.set("hi!", "hello!");
			assert_equals(m.get("hi!"), "hello!", "re-added key value");
		}
		//
		assert_equals(m.get("bye!"), undefined, "missing value is undefined");
		//
		m.set("second", "pair");
		assert_equals(m.size(), 2, "size is 2 with 2 pairs");
		//
		var keys = m.keys();
		assert_equals(array_find_index(keys, "hi!") >= 0, true, "keys contain hi!");
		assert_equals(array_find_index(keys, "second") >= 0, true, "keys contain second");
		var values = m.values();
		assert_equals(array_find_index(values, "hello!") >= 0, true, "values contain hello!");
		assert_equals(array_find_index(values, "pair") >= 0, true, "values contain pair");
		//
		if (pass == 2) {
			var keyStr = "";
			var valStr = "";
			for (var it = m.iterator(); it.next();) {
				keyStr += it.key + ",";
				valStr += it.value + ",";
			}
			assert_equals(string_pos("hi!,", keyStr) > 0, true, "keyStr contains hi!");
			assert_equals(string_pos("second,", keyStr) > 0, true, "keyStr contains second");
			assert_equals(string_pos("hello!,", valStr) > 0, true, "valStr contains hello!")
			assert_equals(string_pos("pair,", valStr) > 0, true, "valStr contains pair")
		}
	}
	trace("All good!");
}