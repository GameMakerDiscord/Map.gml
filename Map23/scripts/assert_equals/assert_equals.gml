// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function assert_equals(a, b, text){
	if (a == b) return;
	throw "Assertion failed for " + text + ": " + string(a) + "(" + typeof(a) + " != " + string(b) + "(" + typeof(b) + ")";
}