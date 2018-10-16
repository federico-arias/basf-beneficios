export function duplicate(f1,f2) {
	return function(o) {
		o[f2] = o[f1];
		return o;
	}
}

export function where(key, value) {
	return function(arr) {
		return arr.filter( function(o) {
			return o[key] === value;
		});
	}
}

export function rename(fieldFrom, fieldTo) {
	return function(o) {
		if (o.hasOwnProperty(fieldFrom)) {
			o[fieldTo] = o[fieldFrom];
			delete o[fieldFrom];
		}
		return o
	}
}

export function ifTrueElse(text, otherwise) {
	return function(bool) {
		return bool ? text : otherwise;
	}
}

export function dateDiff(d2) {
	return function(d1) {
		var d = new Date();
		d.setYear(d1.split("-")[0]);
		d.setMonth(d1.split("-")[1], d1.split("-")[2]);
		var diff= d2 - d.getTime();
		var ageDate = new Date(diff); // miliseconds from epoch
		return Math.abs(ageDate.getUTCFullYear() - 1970);
	}
}

export function log(e) {console.error(e);}

export function tap (func) {
	return function (obj) {
		func(obj);
		return obj;
	}
}

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
		if (obj.hasOwnProperty(field))
			obj[field] = func(obj[field]);
		return obj;
	};
}

export function bulkModify(fields, func) {
	return function(obj) {
		fields.forEach( function (field) {
			obj = modify(field, func)(obj);
		});
		return obj;
	};
}

export function prepend(str) {
	return function(val) {
		return str + val;
	}
}

//calls 'mergeFunc' with every field as arg
export function merge(fields, mergeFunc) {
	var last = fields.length - 1;
	return function(obj) {
		obj[fields[last]] = mergeFunc.apply(this, fields.map(f=>obj[f]));
		//removes every 'field' in 'obj' but last one
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
