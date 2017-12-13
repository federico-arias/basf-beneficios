import {Form} from './modules/Form.js';
import {get, put} from './modules/fetch.js';
import * as Cookie from 'js-cookie';
import {prepend, map, pick, modify, log, bulkModify, tap} from './modules/utils.js';
import {listenClick, runAll, show, runWithKeys, elem, reduce, hide} from './modules/dom.js';
import {prop} from './modules/lens.js';

const currency = '$';
const bid = window.location.href.split("/").pop();
const data = get('/api/beneficio/' + bid);
const allowed = ["beneficio", "categoria", "subcategoria", "pais"];
const p = elem('p');
// Plot beneficios data
data
	.then(pick(allowed))
	.then(modify('beneficio', p))
	.then(modify('categoria', p))
	.then(modify('subcategoria', p))
	.then(modify('pais', p))
	.then(runWithKeys)
	.catch(log);


/* 
 *
 *
 * HANDLE FORM SUBMISSION
 *
 *
 */

function submit(ev) {
	var presupuesto = new Form(ev.target.form);
	presupuesto.append('beneficio_id', bid, bid);
	const opts = {
		form: presupuesto
	};
	var sent = put('/api/presupuesto', opts)
	var keys = ['solicitado_en', 'monto'];
	sent.then(pick(keys))
		.then(modify('monto', prepend(currency)))
		.then(bulkModify(keys, td))
		.then(reduce(keys, tr))
		.then(tap(hide(ev.target.form.parentElement.parentElement.parentElement)))
		.then(runAll('presupuestos'))
		.catch(log);
}

/* 
 *
 *
 * EVENT LISTENERS
 *
 *
 */

listenClick('btn-open-modal', show('presupuesto-modal'));
listenClick('btn-close-modal', hide('presupuesto-modal'));
listenClick('btn-submit-modal', submit);

// Plot presupuesto data
const td = elem('td');
const tr = elem('tr');
data
	.then(prop(['presupuesto']))
	.then(map(pick(['monto', 'asignacion'])))
	.then(map(modify('monto', prepend(currency) )))
	.then(map(modify('monto', td)))
	.then(map(modify('asignacion', td)))
	.then(map(reduce(['asignacion', 'monto'], tr)))
	.then(runAll('presupuestos'))
	.catch(log);
