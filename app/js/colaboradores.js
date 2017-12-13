import {get} from './modules/fetch.js';
import * as Cookie from 'js-cookie';
import {parseQueryString as parse} from './modules/utils.js';
import {map, merge, pick, modify, prepend} from './modules/utils.js';
import {run, tr, href} from './modules/dom.js';

function init() {
	const url = "/api/colaborador/search?searchterm=" + parse(location.search).searchterm;
	const data = get(url);

	data
		.then(map(pick(['id', 'colaborador', 'run'])))
		.then(map(modify('id', prepend('/colaborador/'))))
		.then(map(merge(['id', 'colaborador'], href)))
		.then(map(tr('colaboradores')))
		.then(run)
		.catch( e => console.error(e) );
}

document.addEventListener('DOMContentLoaded', init, false);
