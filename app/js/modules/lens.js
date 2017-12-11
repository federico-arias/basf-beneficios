export function prop(paths) {
	return function(obj) {
		var val = obj;
		var idx = 0;
		while (idx < paths.length) {
			if (val == null) {
				return;
			}
			val = val[paths[idx]];
			idx += 1;
		}
		return val;
	}
}

//focus == value
export function assoc(paths) {
	return function(val,obj) {
		var idx = paths[0];
		if (paths.length > 1) {
			var nextObj = obj[idx];
			val = assoc(Array.prototype.slice.call(paths, 1), val, nextObj);
		}
		return _assoc(idx, val, obj);
	}
}

function _assoc(prop, val, obj) {
	var result = {};
	for (var p in obj) {
		result[p] = obj[p];
	}
	result[prop] = val;
	return result;
}
