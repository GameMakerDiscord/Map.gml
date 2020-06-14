// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function array_find_index(arr, val){
	var i = array_length(arr);
	while (--i >= 0) if (arr[i] == val) return i;
	return -1;
}