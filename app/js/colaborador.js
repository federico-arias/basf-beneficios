import {$} from './modules/modules/utils.js';
import {get, put} from './modules/fetch.js';
import {log, ifTrueElse, where, dateDiff, duplicate, pick, rename, bulkModify, map, merge, modify, prepend} from './modules/utils.js';
import {tap} from './modules/utils.js';
import {attr, named, valued, typed, classed, hide} from './modules/dom.js';
import {runAll, href, elem, clear, runWithKeys, reduce} from './modules/dom.js';
import {Form} from './modules/Form.js';
import * as r from 'ramda-lens';
import {prop} from './modules/lens.js';
import {groupBy} from '.modules/f.js';

const uid = window.location.href.split("/").pop();
const data = get('/api/colaborador/' + uid);
const allowed = ["colaborador", "telefono", "mail", "nacimiento_en", "run", "sucursal", "nacionalidad", "direccion", "cargo", "centro_costo", "supervisor_id"];
const p = elem('p');

/*
 *
 * Datos básicos del colaborador
 *
 *
 */

data
	.then(pick(allowed))
	.then(modify('supervisor_id', prepend('/colaborador/')))
	.then(duplicate('supervisor_id', 'supervisor'))
	.then(modify('supervisor', (_) => 'Ver supervisor'))
	.then(merge(['supervisor_id', 'supervisor'], href))	
	.then(bulkModify(allowed.slice(0,-1).concat('supervisor'), p))
	.then(runWithKeys)
	.catch(log);

data
	.then(function (run) {
		$("colaborador-pic").src = "/assets/images/colaboradores/" + run.run + ".jpg";
	})
	.catch(log) ;

/*
 *
 * Solicitudes del colaborador
 *
 *
 */

const keysBeneficios = ["beneficio", "solicitado_en", "estado", "monto"];
const tr = elem('tr');
const td = elem('td');

data
	.then(prop(['json_agg']))
	.then(map(pick(keysBeneficios)))
	.then(map(modify("monto", prepend("$"))))
	.then(map(bulkModify(keysBeneficios, td)))
	.then(map(reduce(keysBeneficios, tr)))
	.then(runAll('solicitudes'))
	.catch(log);

/*
 *
 * Cargas del colaborador
 *
 */

const keysCargas = ["carga", "nacido_en", "es_hijo"];

data
	.then(prop(['cargas']))
	.then(map(pick(keysCargas)))
	.then(map(duplicate("nacido_en", "edad")))
	.then(map(modify("edad", dateDiff(Date.now()))))
	.then(map(modify("es_hijo", ifTrueElse('Hijo', 'Cónyuge'))))
	.then(map(bulkModify(keysCargas.concat('edad'), td)))
	.then(map(reduce(keysCargas.concat('edad'), tr)))
	.then(runAll('cargas'))
	.catch(log);

populate(); 

/*
 *
 *
 * EVENT HANDLING
 *
 *
 */


$("btn-open-modal").addEventListener("click", function() {
	$("beneficio-modal").style.display = "inherit";
});

$("btn-close-modal").addEventListener("click", function() {
	$("beneficio-modal").style.display = "none";
});

$("btn-submit-modal").addEventListener("click", submit);

// TODO$('resuelto-en').addEventListener('change', d);

/*
 *
 *
 * ON SELECT CHANGE
 *
 *
 */

function populate() {
	const data = get("/api/beneficios?individuales=true");
	const input = typed(elem('input'));
	const option = valued(elem('option'));
	const select = named(elem('select'));
	const mergeOpt = (value, name) => option(value)(name);

	data.then(map(merge(['id', 'beneficio'], mergeOpt)))
		.then(groupBy('beneficio'))
		.then(select('beneficio_id'))
		.then(runAll('beneficio_id-select'))
		.then(tap(on('beneficio_id', 'change', change())))
		.catch(log);

	function on(id, event, listener) {
		return function() {
			document.getElementById(id).addEventListener(event, listener, false);
		}
	}

	function change() {
		const div = classed(elem('div'));
		const label = elem('label');
		const fecha = attr(input('text')); //not 'date' bc of ie11
		const number = attr(input('number')) 
		const monto = {name: 'monto', placeholder:'Ingresa el monto'};
		const resuelto = {name: 'resuelto_en', placeholder:'Ingresa la fecha de resolucióń'};

		return function(ev) {
			var os = ev.target.options;
			var id = parseInt(os.item(os.selectedIndex).value);
			data
				.then(tap(clear('dynamic-form')))
				.then(where('id', id))
				.then(pick(['es_costeable', 'es_aprobado']))
				.then(rename('es_costeable', 'monto'))
				.then(rename('es_aprobado', 'resuelto_en'))
				.then(modify('monto', number(monto)))
				.then(modify('monto', div('col-md-12 dynamic-form')))
				.then(duplicate('resuelto_en', 'estado'))
				.then(modify('resuelto_en', fecha(resuelto)))
				.then(modify('resuelto_en', div('col-md-12 dynamic-form')))
				.then(runWithKeys)
				.catch(log);
		}
	}
}

function submit(ev) {
	var solicitud = new Form(ev.target.form);
	solicitud.append('colaborador_id', uid, uid);
	const opts = {
		form: solicitud
	};
	var sent = put('/api/solicitud', opts); 
	var keys = ['beneficio_id', 'resuelto_en', 'monto'];

	sent.then(pick(keys))
		.then(bulkModify(keys, td))
		.then(reduce(keys, tr))
		.then(tap(hide(ev.target.form.parentElement.parentElement.parentElement.parentElement)))
		.then(runAll('solicitudes'))
		.catch(log);
}

/*
<div class="form-group">
	<div class="col-sm-12">
		<div class="switch-field">
			  <div class="switch-title">¿Está aprobado?</div>
			  <input type="radio" id="switch_left" name="esta_aprobado" value="true"/>
			  <label for="switch_left">Sí</label>
			  <input type="radio" id="switch_right" name="esta_aprobado" value="false" checked/>
			  <label for="switch_right">No</label>
		</div>
	</div>
</div>
*/
