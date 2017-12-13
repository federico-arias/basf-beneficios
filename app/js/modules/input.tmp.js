function Dom() {};

Dom.div = function(children, className) {
	var div = $$('div');
	div.fatherId = 'beneficio-form';
	div.className = className || 'form-group';
	children.forEach( function(child) {
		div.appendChild(child);
	});
	return div;
}

Dom.number = function (id) {
	var el = $$('input');
	el.type = 'number';
	el.name = id;
	el.id = id;
	el.className = "form-control form-control-line"
	return el;
}

Dom.date = function (id) {
	var el = $$('input');
	el.type = 'date';
	el.name = id;
	el.id = id;
	el.className = "form-control form-control-line"
	return el;
}

Dom.label = function(text) {
	var el = $$('label');
	el.textContent = text;
	el.className = 'col-sm-12';
	return el;
}

Dom.select = function (id) {
	return function(arr) {
		var el = $$('select');
		el.name = id;
		el.fatherId = 'beneficio-select';
		el.className = "form-control form-control-line";
		arr.forEach( function( o ) {	
			var opt = $$('option');
			opt.value = o.id;
			opt.textContent = o.beneficio;
			el.appendChild(opt);
		});
		return el;
	}
}

function clearDom(obj) {
	var p = $('beneficio-form');
	var ch = p.children;
	var i = 1; var l= ch.length;
	for (;i<l;i++) {
		p.removeChild(ch.item(i))
	}
	return obj;
}

function keepTrue(o) {
	var o2 = {};
	for (k in o) {
		if (o[k]) o2[k] = o[k];
	}
	return o2;
}

function containerize(labelText, type) {
	return function(id) {
		var div = Dom.div([Dom.label(labelText), Dom.div([Dom[type](id)], "col-md-12")]);
		return div;
	}
}


function sendForm() {
	var f = new FormData($("beneficio-form"));
	f.append("colaborador_id", uid);
	var sent = put("/api/solicitud", hs, f);

	sent.then((new Form('beneficio-form').map()))
		.then(tr("solicitudes"))
		.then(hide('beneficio-modal'))
		.then(run)
		.catch(log);
}
