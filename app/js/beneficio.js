import {get, post} from './modules/fetch.js';
import * as Cookie from 'js-cookie';
import {prepend, map, pick, modify, log} from './modules/utils.js';
import {runAll, runWithKeys, elem, reduce} from './modules/dom.js';
import {prop} from './modules/lens.js';

const jwt = Cookie.get('jwt');
const bid = window.location.href.split("/").pop();
const url = '/api/beneficio/' + bid;
const opts = {headers: [{k:'Authorization', v: 'Bearer ' + jwt}]};
const data = get(url, opts);
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

// Plot presupuesto data
const td = elem('td');
const tr = elem('tr');
data
	.then(prop(['presupuesto']))
	.then(map(pick(['monto', 'asignacion'])))
	.then(map(modify('monto', prepend('$') )))
	.then(map(modify('monto', td)))
	.then(map(modify('asignacion', td)))
	.then(map(reduce(['monto', 'asignacion'], tr)))
	.then(runAll('presupuestos'))
	.catch(log);

/* 
 *
 *
 * HANDLE FORM SUBMISSION
 *
 *
 */

function submitForm() {
	const form = new Form('put-presupuesto');
		  form.append('beneficio_id', bid);
	const opts = {
		form: form.value, 
		headers: [{k:'Authorization', v: 'Bearer ' + jwt}]
	};
	var sent = post('/api/presupuesto', opts)
	
	sent
		.then(form.namedValues)
		.then(pick(['presupuesto', 'monto']))
		.then(run)
		.then(tap(hide('presupuesto-modal')))
		.catch(log);
}

/* 
 *
 *
 * EVENT LISTENERS
 *
 *
 */

$("btn-open-modal").addEventListener("click", function() {
	$("presupuesto-modal").style.display = "inherit";
});

$("btn-close-modal").addEventListener("click", function() {
	$("presupuesto-modal").style.display = "none";
});

$('btn-submit-modal').addEventListener('click', submitForm);
