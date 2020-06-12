// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_test(){
	var h = new Map();
	
	h.set("hi", "hello!");
	assert_equals(h.get("hi"), "hello!", @'h.get("hi")');
	
	h.set(4, "four");
	assert_equals(h.get(4), "four", @'h.get(4)');
	trace("toObject", h.toObject());
	trace("keys", h.keys());
	trace("values", h.values());
	
	h.set(5, "?");
	assert_equals(h.get(5), "?", @'h.get(5)');
	h.remove(5);
	assert_equals(h.get(5), undefined, @'h.get(5) - empty');
	assert_equals(h.exists(5), false, @'h.exists(5) - empty');
	
	var it = h.iterator();
	while (it.next()) {
		trace("iter", it.key, "=>", it.value);
	}
	
	for (var i = 0; i < 200; i++) h.set(i, "$" + string(i));
	assert_equals(h.get(190), "$190", "h.get(190)");
	assert_equals(h.get(210), undefined, "h.get(210)");
	assert_equals(h.size(), 201, "h.size()");
	trace(h);
}