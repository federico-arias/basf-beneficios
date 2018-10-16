import {$, $$} from './modules/utils.js';

export class Kpi {
	constructor(parent) {
		this.parent = $(parent);
		this.elem = $$('span');
		this.elem.className = 'counter text-success';
		this.parent.addChild(this.elem);
	}

	update(data) {
		this.elem.textContent = data.value;
	}

}
