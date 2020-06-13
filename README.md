# Map.gml

Maintained by: YellowAfterlife

[Documentation](https://yal.cc/r/20/map-gml/)

This is a simple Map/hashtable implementation for GameMaker Studio 2.3+.  
It uses arrays and `buffer_crc32` to be garbage collector compatible, unlike legacy `ds_map`.  
Keys can be strings, numbers, or `undefined`.  
Implementation is vaguely based on [c_hashmap](https://github.com/petewarden/c_hashmap).  
The code is written in [Haxe](https://haxe.org/)+[sfgml](https://github.com/YellowAfterlife/sfgml/) and is generally inlined to best available extent.

I hope this to be of use for anyone doing larger-scale work with structs.

Small example:
```js
var h = new Map();
	
h.set("hi", "hello!");
h.set(4, "four");
trace(h); // Map({ "hi": "hello!", 4: "four" })
trace("toObject", h.toObject());
trace("keys", h.keys());
trace("values", h.values());

h.set(5, "?");
h.remove(5);
// h.get(5) => undefined
// h.exists(5) => false

var it = h.iterator();
while (it.next()) {
	trace("iter", it.key, "=>", it.value);
}

for (var i = 0; i < 200; i++) h.set(i, "$" + string(i));
// h.size() => 201
```

License: MIT

## Performance

It is hard to reliably measure performance since 2.3 is still in beta, but the general intent is to offer a slightly nicer alternative to `variable_struct_` functions, which only support string keys and are not openly intended for use as hashtables.
