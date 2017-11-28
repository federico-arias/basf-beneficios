function Dom() {};

Dom.div = function(children, className) {
	var div = $$('div');
	div.className = className || 'form-group';
	children.forEach( function(child) {
		div.appendChild(child);
	});
	return div;
}

Dom.number = function (id) {
	var el = $$('input');
	el.type = 'date';
	el.fatherId = id;
	el.className = "form-control form-control-line"
	return el;
}

Dom.label = function(text) {
	var el = $$('label');
	el.textContent = text;
	return el;
}

Dom.select = function () {
	return function(arr) {
		var el = $$('select');
		el.fatherId = "select-beneficios";
		el.name = "beneficio_id";
		el.className = "form-control form-control-line";
		arr.forEach( function( o ) {	
			var opt = $$('option');
			opt.value = o.id;
			opt.textContent = o.beneficio;
			el.appendChild(opt);
		});
		console.log(el);
		return el;
	}
}
