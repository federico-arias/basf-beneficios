export function Form(form) {
	//searches elements by traversing the <form> tag picking only input forms
	var self = this;
	this.objs = [];
	this.elems = _traverse(form, _filter(['SELECT', 'INPUT']));
	this.elems.forEach( function (el) {
		const name = el.name; 
		let value = el.value; 
		let label = el.label === undefined ? el.value : el.label;	
		if (el.nodeName.toUpperCase() == 'SELECT') {
			value = el.options.item(el.options.selectedIndex).value
			label = el.options.item(el.options.selectedIndex).label
		}
		self.objs.push({
			name: name,
			value:value, 
			label: label
		});
	});
}

function _filter(allowed) {
	return function(el, acc) {
		if (!el.checked && el.type === 'radio') return acc;
		if (allowed.indexOf(el.nodeName.toUpperCase()) !== -1){
			return acc.concat(el);
		}
		return acc;
	}
}

function _traverse(root, func) {
	function iter(elem, acc) {
		acc = func(elem, acc)
		if (elem.children.length)
			acc = iter(elem.firstElementChild, acc)
		var next = elem.nextElementSibling;
		if (next)
			return iter(elem.nextElementSibling, acc);
		return acc;
	}
	
	return iter(root.firstElementChild, [])
}

Form.prototype.labels = function() {
	return this.objs
		.reduce( function(acc, obj) {
			acc[obj.name] = obj.label;	
			return acc;
		}, {});
}

Form.prototype.urlEncoded = function() {
	return this.objs.map( function (obj) {
		return escape(obj.name) + '=' + escape(obj.value);
	}).join('&');
}

Form.prototype.append = function(key, value, label) {
	this.objs.push({name:key, value:value, label:label});
}
