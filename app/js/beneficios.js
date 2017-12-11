import {get} from './modules/fetch.js';
import * as Cookie from 'js-cookie';
import {map, merge, modify} from './modules/utils.js';
import {runAll, href, elem, elems, reduce} from './modules/dom.js';
import * as r from 'ramda-lens';
import {prop, assoc} from './modules/lens.js';

const jwt = Cookie.get('jwt');
const url = "/api/beneficios"; 
const opts = {headers: [{k:'Authorization', v: 'Bearer ' + jwt}]};
const data = get(url, opts);
const lensBeneficios = r.lens(prop(['beneficios']), assoc(['beneficios']));
const li = elem('li'); 
const td = elem('td');
const tr = elem('tr');
const ul = elems('ul', 'beneficio');  
//start loader...
data
	.then(map(r.over(lensBeneficios, map(merge(['id', 'beneficio'], href)))))
	.then(map(r.over(lensBeneficios, map(modify('beneficio', li)))))
	.then(map(r.over(lensBeneficios, ul)))
	.then(map(modify('beneficios', td)))
	.then(map(modify('categoria', td)))
	.then(map(reduce(['categoria', 'beneficios'], tr)))
	.then(runAll('beneficios'))
	.catch(e=>console.error(e));
