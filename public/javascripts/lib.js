function filterObj(fields) {
	return function(obj) {
		if (!Array.isArray(fields)) throw new TypeError("filterObj() requiere un array", "lib.js");
		var o = {};
		fields.forEach(function(field) { 
			o[field] = obj[field];
		});
		return o;
	}
}

function modifyField(field, func) {
	return function(obj) {
		obj[field] = func(obj[field]);
		return obj;
	};
}

function text(obj) {
	return Object.keys(obj).map( function(field) {
		var textNode = document.createTextNode(obj[field]);
		textNode.fatherId = field; 
		return textNode;
	});
}

function tr(father) {
	return function(rowObj) {
		var tr = document.createElement("tr");
		tr.fatherId = father;
		return Object.keys(rowObj).map( function(col) {
			var td = document.createElement('td');
			td.textContent = row[col];
			return td;
		}).reduce ( function( ac, e ) { 
			ac.appendChild(e);
			return ac
		}, tr);
	}
}

function run(domElem) {
	$(domElem.fatherId).appendChild(domElem);
}

function $(id) {
	return document.getElementById(id);
}
