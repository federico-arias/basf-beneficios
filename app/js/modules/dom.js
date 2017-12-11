import {$$, $} from './modules/utils.js';

export function reduce(fields, func) {
	return function (obj) {
		return func(
			fields.reduce( function(acc, field) {
				acc.appendChild(obj[field]);
				return acc;
			}, document.createDocumentFragment())
		);
	}
}

export function elem(elType) {
	return function(child) {
		var el = $$(elType);
		if (typeof child !== 'object' || typeof child == 'undefined')
			child = document.createTextNode(child);
		el.appendChild(child);	
		return el;
	}
}

// nest arrays of object[field]
export function elems(elType, field) {
	return function(children) {
		var el = $$(elType);
		children.forEach( function (child) {
			child = child[field];
			if (typeof child !== 'object' || typeof child == 'undefined')
				child = document.createTextNode(child);
			el.appendChild(child);	
		});
		return el;
	}
}

export function tr(father) {
	return function(rowObj) {
		var tr = $$("tr");
		tr.fatherId = father;
		return Object.keys(rowObj).map( function(col) {
			var td = $$('td');
			if (typeof rowObj[col] !== 'object') 
				rowObj[col] = document.createTextNode(rowObj[col]);
			td.appendChild(rowObj[col]);
			return td;
		}).reduce ( function( ac, e ) { 
			ac.appendChild(e);
			return ac
		}, tr);
	}
}

export function runAll(fatherId) {
	return function(els) {
		if (Array.isArray(els))
			return els.map( function (el) {
				$(fatherId).appendChild(el);
				return el;
			});
		return $(fatherId).appendChild(els);
	}
}

export function runWithKeys(obj) {
	Object.keys(obj).forEach( function (k) {
		$(k).appendChild(obj[k]);
	});
}


export function run(els) {
	if (Array.isArray(els))
		return els.map( function (el) {
			$(el.fatherId).appendChild(el);
			return el;
		});
	return $(els.fatherId).appendChild(els);
}

export function href(src, text) {
	var a = $$('a');
	a.href = src;
	a.textContent = text;
	return a;
}
