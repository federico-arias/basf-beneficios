import {Column} from './modules/highchart.js';
import {get} from './modules/fetch.js';
import {log} from './modules/utils.js';
import {Kpi} from './modules/Kpi.js';

var top5rechazo = new Column('aprobacion-por-area', {
    title:'Porcentaje de aprobación de solicitudes',
    subtitle: 'Áreas con mayor rechazo de solicitudes',
    yAxis: 'Porcentaje de aprobación(%)',
    tooltip: 'Aprobación de <b>{point.y:.1f} </b>',
	xAxis: 'Menor aprobación por área'
});

var avgDiasDemora = new Kpi('avg-demora');

var top5demora = new Column('top-5-respuesta', {
	title:'Demora en tiempo de respuesta a solicitudes',
	subtitle: 'Beneficios con solicitudes con mayor demora de respuesta',
	yAxis: 'Tiempo de respuesta (días)',
	xAxis:'Beneficios',
	tooltip: 'Respuesta de <b>{point.y:.1f} días</b>'
});

function $(id) {return document.getElementById(id);}

$("pais").onchange = (function() {
	var demora = get('/api/solicitud/demora');
	demora.then(paisF('BCW'))
		.then(d => d.map(d => [d.beneficio, d.respuesta]))
		.then( top5demora.update.bind(top5demora) )
		.catch(log);

	var aprobacion = get('/api/solicitud/aprobacion');
	  aprobacion.then(paisF('BCW'))
		.then(d => d.map(d => [d.beneficio, d.aprobacion]))
		.then( top5rechazo.update.bind(top5rechazo) )

	var demoraAvgData = get('/api/solicitud/demoraavg');
	demoraAvgData.then(paisF('BCW'))
		     .then( data => data[0])
		     .then(avgDiasDemora.update({data))
	 
	function paisF(p) {
		return arr => arr.filter(d => d.pais == p)
	}
	
	return function(ev) {
		var pais = ev.target.options.item(ev.target.options.selectedIndex).label;
		demora.then(d => d.filter(d => d.pais == pais))
			.then(d => d.map(d => [d.beneficio, d.respuesta]))
			.then(top5demora.update.bind(top5demora))
			.catch(log);
		demoraAvgData.then( data => demoraAvgData.update(data))
				.catch(log);
		//avgAprobacion.update({data: d}); new Kpi('elem-1')
		//ratioAprobacion.update({data: d});
	}
})();
