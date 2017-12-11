export function coalesce(elseVal, nullable) {}
export function log(e) {console.error(e);}
export function parseQueryString(url) {
  var urlParams = {};
  url.replace(
    new RegExp("([^?=&]+)(=([^&]*))?", "g"),
    function($0, $1, $2, $3) {
      urlParams[$1] = $3;
    }
  );
  
  return urlParams;
}

export function map(func) {
	return function(array) {
		return array.map( function(value) { return func(value) })
	}
}

export function modify(field, func) {
	return function(obj) {
		obj[field] = func(obj[field]);
		return obj;
	};
}

export function prepend(str) {
	return function(val) {
		return str + val;
	}
}

export function merge(fields, mergeFunc) {
	var last = fields.length - 1;
	return function(obj) {
		obj[fields[last]] = mergeFunc.apply(this, fields.map(f=>obj[f]));
		fields.forEach( function(field, i) {
			if (i === last) return;
			delete obj[field];
		});
		return obj;
	}
}

export function pick(fields) {
	return function(obj) {
		if (!Array.isArray(fields)) 
			throw new TypeError("filterObj() requiere un array", "lib.js");
		var o = {};
		fields.forEach(function(field) { 
			o[field] = obj[field];
		});
		return o;
	}
}
