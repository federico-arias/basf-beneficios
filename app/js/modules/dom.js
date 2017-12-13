import {$$, $} from './modules/utils.js';

export function hide(el) {
	if (typeof el === 'string') el = $(el);
	return function(_){
		el.style.display = "none";
		return _;
	}
}

export function show(el) {
	if (typeof el === 'string') el = $(el);
	return function(_){
		el.style.display = "inherit";
		return _;
	}
}

function listen(event) {
	return function(elem, func) {
		if (typeof elem === 'string') elem = $(elem);
		elem.addEventListener(event,func,false);
	}
}


export function sibling(elemName) {
	return function(el) {
		var el2 = elem(elemName)('');
		var frag = document.createElementFragment()
		frag.apppendChild(el);
		frag.apppendChild(el2);
		return frag;
	}
}

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

export function clear(className) {
	return function(_) {
		var els = document.getElementsByClassName(className);
		var l = els.length;
		for (var i = 0; i<l;i++) {
			els.item(0).parentElement.removeChild(els.item(0));
		}
	}
}

export function elem(elType) {
	return function(child) {
		var el = $$(elType);
		if (typeof child !== 'object' || typeof child == 'undefined' || child === null)
			child = document.createTextNode(child);
		el.appendChild(child);	
		return el;
	}
}

export function attr(elem) {
	return function(attrs) {
		return function(child) {
			var el = elem(child);
			Object.keys(attrs).forEach( function(a) {
				el[a] = attrs[a];
			});
			return el;
		}
	}
}

export function classed(elem) {
	return function(className) {
		return function(child) {
			var el = elem(child);
			el.className = className;
			return el;
		}
	}
}

export function valued(func) {
	return function(value) {
		return function(child) {
			var el = func(child);
			el.value = value;
			return el;
		}
	}
}

export function typed(func) { // func :: String || DomNode -> DomNode
	return function(typeName) {
		return function(child) {
			var el = func(child);
			el.type = typeName;
			return el;
		}
	}
}

export function named(func) { // func :: String || DomNode -> DomNode
	return function(name) {
		return function(child) {
			var el = func(child);
			el.id = name;
			el.name = name;
			return el;
		}
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

export const listenClick = listen('click');
