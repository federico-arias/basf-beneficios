//get cookie from store
const jwt = document.cookie.split("=").reduce((acc, item) => acc == "jwt" ? item : null); 
//send jwt to endpoint 
var hs = new Headers();
hs.append("Authorization", "Bearer " + jwt)
const opts = {method: 'GET', headers: hs}
const dataPromise = getJson('/api/solicitudes/area', opts)

dataPromise
	.then(plotTable);
	//.then(plotBarChart)
	//.then(plotPieChart)
	

function filter(o) {
	var keys = ['area', 'beneficio', 'nSolicitudes', 'porcentajeAprobacion', 'beneficioPorArea'];
	return Object.keys(o)
	  .filter(key => keys.includes(key))
	  .reduce((obj, key) => {
		obj[key] = o[key];
		return obj;
	  }, {});
}

function getJson(url, opts) {
	opts = opts || {};
	return fetch(url, opts).then( res => res.json())
}	

function plotTable(data) {
	let fragment = document.createDocumentFragment();
	console.log(data);
	data.map(filter)
		.map( o => Object.assign({}, o, {porcentajeAprobacion: Math.floor(o.porcentajeAprobacion * 100)}))
		.forEach( row => {
			var tr = document.createElement('tr');
			Object.keys(row).forEach( function(col) {
				var td = document.createElement('td');
				tr.appendChild(td);
				if (col == 'approved') {
					td.textContent = Math.floor(row[col] * 100);
					return;
				}
				if (row[col] > 0.7) 
					td.className = 'text-success';
				td.textContent = row[col];
			});
			fragment.appendChild(tr);
		})
	document.getElementById('tablita')
		.appendChild(fragment);
	return data;
}

Highcharts.chart('bubbleChart', {
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
        text: 'Popularidad v/s Efectividad v/s Aprobación'
    },

    xAxis: {
        gridLineWidth: 1,
        title: {
            text: 'Popularidad (número de solicitudes)'
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
            format: '{value} MM'
        },
        maxPadding: 0.2,
    },

    tooltip: {
        useHTML: true,
        headerFormat: '<table>',
        pointFormat: '<tr><th colspan="2"><h3>{point.country}</h3></th></tr>' +
            '<tr><th>Popularidad:</th><td>{point.x}</td></tr>' +
            '<tr><th>Costo:</th><td>{point.y} MM</td></tr>' +
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
