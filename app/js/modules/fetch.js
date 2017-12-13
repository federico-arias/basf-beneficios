import Promise from 'promise-polyfill'; 
import {Form} from './Form.js';
import * as Cookie from 'js-cookie';
 
// To add to window
if (!window.Promise) {
  window.Promise = Promise;
}

function fetch(method) {
	return function(url, opts) {
		opts = opts || {};
		var p = new Promise(function(resolve, reject) {
			var xhr = new XMLHttpRequest()
			xhr.open(method, url)	
			opts.headers ? opts.headers.forEach( function(h) {
				xhr.setRequestHeader(h.k, h.v);
				}
			) : null;
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.setRequestHeader('Authorization', 'Bearer ' + Cookie.get('jwt'));
			var send = opts.form ? opts.form.urlEncoded() : null;
			xhr.send(send);

			xhr.onreadystatechange = function () {
			  if(xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
				  if (send === null)
					return resolve(JSON.parse(xhr.responseText));
				  resolve(opts.form.labels())
			  }
			};
		});
		return p;
	}
}

export const get = fetch('GET');
export const post = fetch('POST');
export const put = fetch('PUT');

