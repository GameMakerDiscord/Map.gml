# Map(s).gml

Maintained by: YellowAfterlife

Quick links: [Documentation](https://yal.cc/r/20/map-gml/)

This repository contains several hashtable implementations for GameMaker Studio 2.3+:

- LightMap: A simple wrapper around `variable_struct_*` functions.
- StructMap: A slightly fancier wrapper around `variable_struct_*` functions that supports pair removal.
- HashMap: A custom implementation based on [c_hashmap](https://github.com/petewarden/c_hashmap). Supports non-string keys, but is (as of writing this) slower.

I hope this to be of use for anyone doing larger-scale work with structs.

Small example:
```js
var h = new HashMap();

h.set("hi", "hello!");
h.set(4, "four");
trace(h.get("hi")); // "hello!"
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

## Feature comparison

| Criteria | `ds_map_*` | `variable_*` | LightMap | StructMap | HashMap
| -------: | :----: | :----: | :---: | :----: | :----:
| Memory management | explicit | GC | GC | GC | GC
| Key types | just about anything | string | string | string | string, number, undefined
| Key-value pair removal | ✔ | ❌ | ❌ | ✔ | ✔

(... is there anything else of interest?)

## Compiling

1. Set up [haxe](https://haxe.org/), install [sfhx](https://github.com/YellowAfterlife/sfhx) and [sfgml](https://github.com/YellowAfterlife/sfgml) via `haxelib git`
2. Do `haxe build.hxml`

## Performance

In general, `ds_map_*` <=> structs > LightMap > StructMap > HashMap.

Structs can out-perform `ds_map` by utilizing `obj.field` syntax for known-to-exist fields.

HashMap generally pays for being written in GML (and having more logic to it), but still can perform well for its areas of use.

StructMap/LightMap have comparable performance to `variable_struct_*` functions as they have minimal amount of logic on top.