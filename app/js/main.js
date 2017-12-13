import {get} from './modules/fetch.js';
import * as Cookie from 'js-cookie';
import {pick} from './modules/utils.js';
import {runAll, href, elem, elems, reduce} from './modules/dom.js';
import * as r from 'ramda-lens';
import {prop, assoc} from './modules/lens.js';

const opts = {};
const data = get('/api/solicitudes/area', opts);
const keys = ['area', 'beneficio', 'nSolicitudes', 'porcentajeAprobacion', 'beneficioPorArea'];
const td = elem('td');

data
	.then(map(pick(keys)))
	.then(map(bulkModify(keys, td)))
	.then(map(reduce(keys, tr)))
	.then(runAll('tablita'))
	.catch(log);

var bubble = Highcharts.chart('bubbleChart', {
    bubble: {
    	color:  '#FF0000'
    },
    
    chart: {
        type: 'bubble',
        plotBorderWidth: 1,
        zoomType: 'xy'
    },
    
    credits: false,

    legend: {
        enabled: false
    },

    title: {
        text: 'Recurrencia v/s Costo v/s Aprobación'
    },

    xAxis: {
        gridLineWidth: 1,
        title: {
            text: 'Recurrencia (número de solicitudes)'
        },
        labels: {
            format: '{value}'
        }
    },

    yAxis: {
        startOnTick: false,
        endOnTick: false,
        title: {
            text: 'Efectividad (Costo per cápita)'
        },
        labels: {
            format: '{value} M'
        },
        maxPadding: 0.2,
    },

    tooltip: {
        useHTML: true,
        headerFormat: '<table>',
        pointFormat: '<tr><th colspan="2"><h3>{point.country}</h3></th></tr>' +
            '<tr><th>Popularidad:</th><td>{point.x}</td></tr>' +
            '<tr><th>Costo:</th><td>{point.y} M</td></tr>' +
            '<tr><th>Aprobación:</th><td>{point.z}%</td></tr>',
        footerFormat: '</table>',
        followPointer: true
    },

    plotOptions: {
        series: {
            dataLabels: {
                enabled: false,
                format: '{point.name}'
            }
        }
    },

    series: [{
        data: [
            { x: 95, y: 95, z: 13.8, name: 'BE', country: 'Categoría 1' },
            { x: 86.5, y: 102.9, z: 14.7, name: 'DE', country: 'Categoría 2' },
            { x: 80.8, y: 91.5, z: 15.8, name: 'FI', country: 'Categoría 3' },
            { x: 80.4, y: 102.5, z: 12, name: 'NL', country: 'Categoría 4' },
            { x: 80.3, y: 86.1, z: 11.8, name: 'SE', country: 'Categoría 5' },
            { x: 78.4, y: 70.1, z: 16.6, name: 'ES', country: 'Categoría 6' },
            { x: 74.2, y: 68.5, z: 14.5, name: 'FR', country: 'Categoría 7' },
            { x: 73.5, y: 83.1, z: 10, name: 'NO', country: 'Categoría 8' }
        ]
    }]

});

var data = [
	{ x: 95, y: 95, z: 13.5, name: 'BE', country: 'Categoría 1' },
	{ x: 56.5, y: 102.9, z: 14.7, name: 'DE', country: 'Categoría 2' },
	{ x: 50.5, y: 91.5, z: 15.5, name: 'FI', country: 'Categoría 3' },
	{ x: 50.4, y: 102.5, z: 12, name: 'NL', country: 'Categoría 4' },
	{ x: 50.3, y: 56.1, z: 11.5, name: 'SE', country: 'Categoría 5' },
	{ x: 75.4, y: 70.1, z: 16.6, name: 'ES', country: 'Categoría 6' },
	{ x: 74.2, y: 65.5, z: 14.5, name: 'FR', country: 'Categoría 7' },
	{ x: 73.5, y: 53.1, z: 10, name: 'NO', country: 'Categoría 5' }
];

$("bubble-select").onchange = function(ev) {
	//this == ev.target.options.item(ev.target.options.selectedIndex)	
	//this.value && this.label
	d = data.map( function(row) {
		return {
			name: row.name,
			country: row.country,
			x: row.x * Math.random() * 1.5, 
			y: row.y * Math.random() * 1.5, 
			z: row.z * Math.random() * 1.5 
		}
	});
	bubble.series[0].update({data:d})
};

