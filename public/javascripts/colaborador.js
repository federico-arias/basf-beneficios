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

const jwt = document.cookie.split("=")
	.reduce((acc, item) => acc == "jwt" ? item : null); 
var hs = new Headers();
hs.append("Authorization", "Bearer " + jwt);
const uid = window.location.href.split("/").pop();
const url = "/api/colaborador/" + uid;
const opts = {method: 'GET', headers: hs};
const dataPromise = getJson(url, opts);

dataPromise
	.then(filterObj(["colaborador", "telefono", "mail", "nacimiento_en", "run", "sucursal", "nacionalidad", "direccion", "cargo", "centro_costo", "supervisor_id"]))
	.then(toTextNode)
	.then(run);

dataPromise
	.then(filterObj(["run"]))
	.then(function (run) {
		if (run)
		$("colaborador-pic").src = "/assets/images/colaboradores/" + run.run + ".jpg";
	});


dataPromise
	.then(prop("json_agg"))
	.then(map(filterObj(["beneficio", "solicitado_en", "estado", "monto"])))
	.then(map(modifyField("monto", prepend("$") )))
	.then(map(tr("solicitudes")))
	.then(run);

	function $$(el) {return document.createElement(el);}
	function link(value) {
		var a = $$('a');	
		a.textContent='Ver supervisor';
		a.href = value;
		return a;
	}

dataPromise
	.then(prop("cargas"))
	.then(map(filterObj(["carga", "nacido_en"])))
	.then(map(tr("cargas")))
	.then(run);

$("btn-modal").addEventListener("click", function() {
	$("beneficio-modal").style.display = "inherit";
});

$("close-modal").addEventListener("click", function() {
	$("beneficio-modal").style.display = "none";
});

$("btn-send").addEventListener("click", sendForm);

function runO(o) {
	for (var k in o) {
		if (o.hasOwnProperty(k)) {
			$(o[k].fatherId).appendChild(o[k]);	
		}
	}
}

function put(url, hs, fData) {
	hs.append('Content-Type', 'application/x-www-form-urlencoded');
	var opts = { 
		method: "PUT",
		body:urlencodeFormData(fData),
		headers: hs
	};
	return fetch(url, opts);
}

function get(url, hs) {
	var opts = { 
		method: "GET",
		headers: hs
	};
	return fetch(url, opts).then( function (r) { return r.json()});
}

dataI = get("/api/beneficios?individuales=true");

dataI.then(Dom.select("beneficio_id")).then(run);	

function filter(id) {
	return function (ar) {
		return ar.filter( function(obj) {
			return obj.id === id;
		})[0];
	}
}

function hide(el) {
	return function(_){
		el.style.display = "none";
		return _;
	}
}

function Form($form) {
	var o = {};
	var els = $form.elements
	var l = els.length;
	var i = 0;
	for(i;i<l;i++) {
		var el = els.item(i);
		if (el.type == 'hidden') continue;
		if (el.nodeName === 'SELECT') {
			o[el.id] = el.options.item(el.options.selectedIndex).label;
			continue;
		}
		o[el.id] = [el.value]	
	}
	this.obj = o;
}

Form.prototype.map = function() {
	var self = this;
	return function (_) {
		return self.obj;
	}
}

function sendForm() {
	var f = new FormData($("beneficio-form"));
	f.append("colaborador_id", uid);
	var sent = put("/api/solicitud", hs, f);

	sent.then((new Form('beneficio-form').map()))
		.then(tr("solicitudes"))
		.then(hide('beneficio-modal'))
		.then(run);
}

function prepend(char) {
	return function(str) {
		return str == null ? 'N/A' : char + str;	
	}
}

function prop(p) {
	return function(o) {
		return o[p];
	}
}


function getJson(url, opts) {
	opts = opts || {};
	return fetch(url, opts).then( res => res.json())
}	

function filterObj(fields) {
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

function map(func) {
	return function(array) {
		return array.map( function(value) { return func(value) })
	}
}

function modifyField(field, func) {
	return function(obj) {
		obj[field] = func(obj[field]);
		return obj;
	};
}

function modify(field, func) {
	return function(obj) {
		obj[field] = func(field, obj[field]);
		return obj;
	};
}

function toTextNode(obj) {
	return Object.keys(obj).map( function(field) {
		if (!obj[field]) {
			var textNode = document.createTextNode("N/A");
			textNode.fatherId = field; 
			return textNode;
		}
		var o = obj[field];
		if (o.nodeName) {
			o.fatherId = field;
			return obj[field];
		}
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
			td.textContent = rowObj[col];
			return td;
		}).reduce ( function( ac, e ) { 
			ac.appendChild(e);
			return ac
		}, tr);
	}
}

function run(els) {
	if (Array.isArray(els))
		return els.map( function (el) {
			$(el.fatherId).appendChild(el);
			return el;
		});
	return $(els.fatherId).appendChild(els);
}

function $(id) {
	return document.getElementById(id);
}

//https://stackoverflow.com/questions/7542586/new-formdata-application-x-www-form-urlencoded/38931547#38931547
function urlencodeFormData(fd){
    var s = '';
    function encode(s){ return encodeURIComponent(s).replace(/%20/g,'+'); }
    for(var pair of fd.entries()){
        if(typeof pair[1]=='string'){
            s += (s?'&':'') + encode(pair[0])+'='+encode(pair[1]);
        }
    }
    return s;
}

function delPropOrElse(field, el) {
	return function(obj) {
		if (obj[field]) {
			//obj[field] = Dom[el](field, obj[field]);
			return obj;
		}
	}
}


$('beneficio-select').addEventListener('change', c);
$('resuelto_en').addEventListener('change', d);

function d() {
	/*
	 *  <div class="switch-field">
      <div class="switch-title">Is this awesome?</div>
      <input type="radio" id="switch_left" name="switch_2" value="yes" checked/>
      <label for="switch_left">Yes</label>
      <input type="radio" id="switch_right" name="switch_2" value="no" />
      <label for="switch_right">No</label>
    </div>
	 *
	 */
}


function c(ev) {
	var id = parseInt(ev.target.options.item(ev.target.options.selectedIndex).value);
	dataI.then(filter(id))
		 .then(filterObj(['es_costeable', 'es_aprobado']))
		 .then(keepTrue)
		 .then(rename('es_costeable', 'monto'))
		 .then(rename('es_aprobado', 'resuelto_en'))
		 .then(modifyField('monto', containerize('Monto', 'number')))
		 .then(modifyField('resuelto_en', containerize('Fecha resolución', 'date')))
		 .then(clearDom)
		 .then(runO);
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

function merge(field1, field2) {
	return function (obj) {
		obj[field1] = [field1, field2];
		return obj;
	}
}

function rename(fieldFrom, fieldTo) {
	return function(o) {
		console.log(o);
		o[fieldTo] = o[fieldFrom];
		delete o[fieldFrom];
		return o
	}
}
