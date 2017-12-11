import "babel-polyfill";
import "whatwg-fetch"; 

const Headers = require('fetch-headers/headers-es5.min.js');

function $(id) {return document.getElementById(id); }

$("btn-modal").addEventListener("click", function() {
	$("presupuesto-modal").style.display = "inherit";
});

$("close-modal").addEventListener("click", function() {
	$("presupuesto-modal").style.display = "none";
});


	const jwt = document.cookie.split("=").reduce((acc, item) => acc == "jwt" ? item : null); 
	var hs = new Headers();
	hs.append("Authorization", "Bearer " + jwt);
	const bid = window.location.href.split("/").pop();
	const url = "/api/beneficio/" + bid;
	const opts = {method: 'GET', headers: hs};
	const dataPromise = getJson(url, opts);


	var allowed = ["beneficio", "categoria", "subcategoria", "pais"];

	dataPromise.then( beneficio => {
			Object.keys(beneficio)
				.filter(x => allowed.indexOf(x) !== -1)
				.map($)
				.forEach( elem => createP(elem, beneficio[elem.id]))
			return beneficio;
	}
	).then( b => b.presupuesto.map(plotRow))
	.catch( e => console.error(e) );

	dataPromise
		.then(prop('presupuesto'))
		.then(map(filterObj(["monto", "asignacion"])))
		.then(map(modifyField("monto", prepend("$") )))
		.then(map(tr("presupuestos")))
		.then(run)
		.catch( e => console.error(e) );
		
function map(func) {
	return function(array) {
		return array.map( function(value) { return func(value) })
	}
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

function modifyField(field, func) {
	return function(obj) {
		obj[field] = func(obj[field]);
		return obj;
	};
}

function prop(p) {
	return function(o) {
		return o[p];
	}
}

function createP(elem, text) {
	let p = document.createElement("p");
	p.textContent = text;
	elem.appendChild(p);
}

function getJson(url, opts) {
	opts = opts || {};
	return fetch(url, opts).then( res => res.json())
}	

function plotRow(row) {
	var tr = document.createElement('tr');
	Object.keys(row).forEach( function(col) {
		var td = document.createElement('td');
		tr.appendChild(td);
		td.textContent = row[col];
	})
	return tr;
}

$('btn-put-presupuesto').addEventListener('click', sendForm);

function sendForm() {
	var f = new FormData($("put-presupuesto"));
	var $f = new Form($('put-presupuesto'));
	f.append("beneficio_id", window.location.href.split("/").pop());
	hs.append('Content-Type', 'application/x-www-form-urlencoded');
	var urlEncoded = urlencodeFormData(f);
	var opts = { 
		method: "PUT",
		body:urlEncoded,
		headers: hs
	}
	var sent = fetch("/api/presupuesto", opts)
	sent
		.then($f.map())
		.then(tr('presupuestos'))
		.then(run)
		.then(function(d) {$('presupuesto-modal').style.display = "none"; return d})
		.catch( e => console.error(e) );
}

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

