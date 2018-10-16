import * as Highcharts from 'highcharts';

export function Column(id, prop) {
	this.chart = Highcharts.chart(id, {
		chart: {
			type: 'column'
		},
		title: {
			text: prop.title
		},
		subtitle: {
			text: prop.subtitle
		},
		xAxis: {
			type: 'category',
			labels: {
				rotation: -45,
				style: {
					fontSize: '13px',
					fontFamily: 'Verdana, sans-serif'
				}
			}
		},
		yAxis: {
			min: 0,
			title: {
				text: prop.yAxis
			}
		},
		legend: {
			enabled: false
		},
		tooltip: {
			pointFormat: prop.tooltip
		},
		credits: false,
		series: [{
			name: prop.xAxis,
			data: [
				['', 0]
			],
			dataLabels: {
				enabled: true,
				rotation: -90,
				color: '#FFFFFF',
				align: 'right',
				format: '{point.y:.1f}', 
				y: 10, 
				style: {
					fontSize: '13px',
					fontFamily: 'Verdana, sans-serif'
				}
			}
		}]
	});
}

Column.prototype.update = function (data) {
	this.chart.series[0].update({data: data});
};

