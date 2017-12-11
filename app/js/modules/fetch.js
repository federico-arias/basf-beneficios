import Promise from 'promise-polyfill'; 
 
// To add to window
if (!window.Promise) {
  window.Promise = Promise;
}

function fetch(method) {
	return function(url, opts) {
		var p = new Promise(function(resolve, reject) {
			var xhr = new XMLHttpRequest()
			xhr.open(method, url)	
			opts.headers.forEach( function(h) {
				xhr.setRequestHeader(h.k, h.v);
				}
			);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			var send = opts.formId ? parseForm(opts.formId).join('&') : null;
			xhr.send(send);
			xhr.onreadystatechange = function () {
			  if(xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
				resolve(JSON.parse(xhr.responseText));
			  } 
			};
		});
		return p;
	}
}

function parseForm(sFormId) {
	var oField;
	var segments = [];
	var oTarget = document.getElementById(sFormId);
	for (var nItem = 0; nItem < oTarget.elements.length; nItem++) {
		oField = oTarget.elements[nItem];
		if (!oField.hasAttribute("name")) { continue; }
		if (oField.nodeName === 'SELECT') {
			var idx = oField.options.selectedIndex;
			segments.push(escape(oField.name) + "=" + escape(String(oField.options.item(idx).value)));
			continue;
		}
		segments.push(escape(oField.name) + "=" + escape(String(oField.value)));
	}
	return segments;
}

export const get = fetch('GET');
export const post = fetch('POST');
