(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
'use strict';

var _fetch = require('./modules/fetch.js');

var _jsCookie = require('js-cookie');

var Cookie = _interopRequireWildcard(_jsCookie);

var _utils = require('./modules/utils.js');

var _dom = require('./modules/dom.js');

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj.default = obj; return newObj; } }

function init() {
	var url = "/api/colaborador/search?searchterm=" + (0, _utils.parseQueryString)(location.search).searchterm;
	var data = (0, _fetch.get)(url);

	data.then((0, _utils.map)((0, _utils.pick)(['id', 'colaborador', 'run']))).then((0, _utils.map)((0, _utils.modify)('id', (0, _utils.prepend)('/colaborador/')))).then((0, _utils.map)((0, _utils.merge)(['id', 'colaborador'], _dom.href))).then((0, _utils.map)((0, _dom.tr)('colaboradores'))).then(_dom.run).catch(function (e) {
		return console.error(e);
	});
}

document.addEventListener('DOMContentLoaded', init, false);

},{"./modules/dom.js":3,"./modules/fetch.js":4,"./modules/utils.js":6,"js-cookie":7}],2:[function(require,module,exports){
'use strict';

Object.defineProperty(exports, "__esModule", {
	value: true
});
exports.Form = Form;
function Form(form) {
	//searches elements by traversing the <form> tag picking only input forms
	var self = this;
	this.objs = [];
	this.elems = _traverse(form, _filter(['SELECT', 'INPUT']));
	this.elems.forEach(function (el) {
		var name = el.name;
		var value = el.value;
		var label = el.label === undefined ? el.value : el.label;
		if (el.nodeName.toUpperCase() == 'SELECT') {
			value = el.options.item(el.options.selectedIndex).value;
			label = el.options.item(el.options.selectedIndex).label;
		}
		self.objs.push({
			name: name,
			value: value,
			label: label
		});
	});
}

function _filter(allowed) {
	return function (el, acc) {
		if (!el.checked && el.type === 'radio') return acc;
		if (allowed.indexOf(el.nodeName.toUpperCase()) !== -1) {
			return acc.concat(el);
		}
		return acc;
	};
}

function _traverse(root, func) {
	function iter(elem, acc) {
		acc = func(elem, acc);
		if (elem.children.length) acc = iter(elem.firstElementChild, acc);
		var next = elem.nextElementSibling;
		if (next) return iter(elem.nextElementSibling, acc);
		return acc;
	}

	return iter(root.firstElementChild, []);
}

Form.prototype.labels = function () {
	return this.objs.reduce(function (acc, obj) {
		acc[obj.name] = obj.label;
		return acc;
	}, {});
};

Form.prototype.urlEncoded = function () {
	return this.objs.map(function (obj) {
		return escape(obj.name) + '=' + escape(obj.value);
	}).join('&');
};

Form.prototype.append = function (key, value, label) {
	this.objs.push({ name: key, value: value, label: label });
};

},{}],3:[function(require,module,exports){
'use strict';

Object.defineProperty(exports, "__esModule", {
	value: true
});

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; };

exports.hide = hide;
exports.sibling = sibling;
exports.reduce = reduce;
exports.clear = clear;
exports.elem = elem;
exports.classed = classed;
exports.valued = valued;
exports.typed = typed;
exports.named = named;
exports.elems = elems;
exports.tr = tr;
exports.runAll = runAll;
exports.runWithKeys = runWithKeys;
exports.run = run;
exports.href = href;

var _utils = require('./modules/utils.js');

function hide(el) {
	return function (_) {
		el.style.display = "none";
		return _;
	};
}

function sibling(elemName) {
	return function (el) {
		var el2 = elem(elemName)('');
		var frag = document.createElementFragment();
		frag.apppendChild(el);
		frag.apppendChild(el2);
		return frag;
	};
}

function reduce(fields, func) {
	return function (obj) {
		return func(fields.reduce(function (acc, field) {
			acc.appendChild(obj[field]);
			return acc;
		}, document.createDocumentFragment()));
	};
}

function clear(className) {
	return function (_) {
		var els = document.getElementsByClassName(className);
		var l = els.length;
		for (var i = 0; i < l; i++) {
			els.item(0).parentElement.removeChild(els.item(0));
		}
	};
}

function elem(elType) {
	return function (child) {
		var el = (0, _utils.$$)(elType);
		if ((typeof child === 'undefined' ? 'undefined' : _typeof(child)) !== 'object' || typeof child == 'undefined' || child === null) child = document.createTextNode(child);
		el.appendChild(child);
		return el;
	};
}

function classed(elem) {
	return function (className) {
		return function (child) {
			var el = elem(child);
			el.className = className;
			return el;
		};
	};
}

function valued(func) {
	return function (value) {
		return function (child) {
			var el = func(child);
			el.value = value;
			return el;
		};
	};
}

function typed(func) {
	// func :: String || DomNode -> DomNode
	return function (typeName) {
		return function (child) {
			var el = func(child);
			el.type = typeName;
			return el;
		};
	};
}

function named(func) {
	// func :: String || DomNode -> DomNode
	return function (name) {
		return function (child) {
			var el = func(child);
			el.id = name;
			el.name = name;
			return el;
		};
	};
}

// nest arrays of object[field]
function elems(elType, field) {
	return function (children) {
		var el = (0, _utils.$$)(elType);
		children.forEach(function (child) {
			child = child[field];
			if ((typeof child === 'undefined' ? 'undefined' : _typeof(child)) !== 'object' || typeof child == 'undefined') child = document.createTextNode(child);
			el.appendChild(child);
		});
		return el;
	};
}

function tr(father) {
	return function (rowObj) {
		var tr = (0, _utils.$$)("tr");
		tr.fatherId = father;
		return Object.keys(rowObj).map(function (col) {
			var td = (0, _utils.$$)('td');
			if (_typeof(rowObj[col]) !== 'object') rowObj[col] = document.createTextNode(rowObj[col]);
			td.appendChild(rowObj[col]);
			return td;
		}).reduce(function (ac, e) {
			ac.appendChild(e);
			return ac;
		}, tr);
	};
}

function runAll(fatherId) {
	return function (els) {
		if (Array.isArray(els)) return els.map(function (el) {
			(0, _utils.$)(fatherId).appendChild(el);
			return el;
		});
		return (0, _utils.$)(fatherId).appendChild(els);
	};
}

function runWithKeys(obj) {
	Object.keys(obj).forEach(function (k) {
		(0, _utils.$)(k).appendChild(obj[k]);
	});
}

function run(els) {
	if (Array.isArray(els)) return els.map(function (el) {
		(0, _utils.$)(el.fatherId).appendChild(el);
		return el;
	});
	return (0, _utils.$)(els.fatherId).appendChild(els);
}

function href(src, text) {
	var a = (0, _utils.$$)('a');
	a.href = src;
	a.textContent = text;
	return a;
}

},{"./modules/utils.js":5}],4:[function(require,module,exports){
'use strict';

Object.defineProperty(exports, "__esModule", {
	value: true
});
exports.put = exports.post = exports.get = undefined;

var _promisePolyfill = require('promise-polyfill');

var _promisePolyfill2 = _interopRequireDefault(_promisePolyfill);

var _Form = require('./Form.js');

var _jsCookie = require('js-cookie');

var Cookie = _interopRequireWildcard(_jsCookie);

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } else { var newObj = {}; if (obj != null) { for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) newObj[key] = obj[key]; } } newObj.default = obj; return newObj; } }

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

// To add to window
if (!window.Promise) {
	window.Promise = _promisePolyfill2.default;
}

function fetch(method) {
	return function (url, opts) {
		opts = opts || {};
		var p = new _promisePolyfill2.default(function (resolve, reject) {
			var xhr = new XMLHttpRequest();
			xhr.open(method, url);
			opts.headers ? opts.headers.forEach(function (h) {
				xhr.setRequestHeader(h.k, h.v);
			}) : null;
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.setRequestHeader('Authorization', 'Bearer ' + Cookie.get('jwt'));
			var send = opts.form ? opts.form.urlEncoded() : null;
			xhr.send(send);

			xhr.onreadystatechange = function () {
				if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
					if (send === null) return resolve(JSON.parse(xhr.responseText));
					resolve(opts.form.labels());
				}
			};
		});
		return p;
	};
}

var get = exports.get = fetch('GET');
var post = exports.post = fetch('POST');
var put = exports.put = fetch('PUT');

},{"./Form.js":2,"js-cookie":7,"promise-polyfill":8}],5:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
	value: true
});
exports.$ = $;
exports.$$ = $$;
function $(id) {
	return document.getElementById(id);
}

function $$(name) {
	return document.createElement(name);
}

},{}],6:[function(require,module,exports){
"use strict";

Object.defineProperty(exports, "__esModule", {
	value: true
});
exports.duplicate = duplicate;
exports.where = where;
exports.rename = rename;
exports.ifTrueElse = ifTrueElse;
exports.dateDiff = dateDiff;
exports.log = log;
exports.tap = tap;
exports.parseQueryString = parseQueryString;
exports.map = map;
exports.modify = modify;
exports.bulkModify = bulkModify;
exports.prepend = prepend;
exports.merge = merge;
exports.pick = pick;
function duplicate(f1, f2) {
	return function (o) {
		o[f2] = o[f1];
		return o;
	};
}

function where(key, value) {
	return function (arr) {
		return arr.filter(function (o) {
			return o[key] === value;
		});
	};
}

function rename(fieldFrom, fieldTo) {
	return function (o) {
		if (o.hasOwnProperty(fieldFrom)) {
			o[fieldTo] = o[fieldFrom];
			delete o[fieldFrom];
		}
		return o;
	};
}

function ifTrueElse(text, otherwise) {
	return function (bool) {
		return bool ? text : otherwise;
	};
}

function dateDiff(d2) {
	return function (d1) {
		var d = new Date();
		d.setYear(d1.split("-")[0]);
		d.setMonth(d1.split("-")[1], d1.split("-")[2]);
		var diff = d2 - d.getTime();
		var ageDate = new Date(diff); // miliseconds from epoch
		return Math.abs(ageDate.getUTCFullYear() - 1970);
	};
}

function log(e) {
	console.error(e);
}

function tap(func) {
	return function (obj) {
		func(obj);
		return obj;
	};
}

function parseQueryString(url) {
	var urlParams = {};
	url.replace(new RegExp("([^?=&]+)(=([^&]*))?", "g"), function ($0, $1, $2, $3) {
		urlParams[$1] = $3;
	});

	return urlParams;
}

function map(func) {
	return function (array) {
		return array.map(function (value) {
			return func(value);
		});
	};
}

function modify(field, func) {
	return function (obj) {
		if (obj.hasOwnProperty(field)) obj[field] = func(obj[field]);
		return obj;
	};
}

function bulkModify(fields, func) {
	return function (obj) {
		fields.forEach(function (field) {
			obj = modify(field, func)(obj);
		});
		return obj;
	};
}

function prepend(str) {
	return function (val) {
		return str + val;
	};
}

function merge(fields, mergeFunc) {
	var last = fields.length - 1;
	return function (obj) {
		obj[fields[last]] = mergeFunc.apply(this, fields.map(function (f) {
			return obj[f];
		}));
		fields.forEach(function (field, i) {
			if (i === last) return;
			delete obj[field];
		});
		return obj;
	};
}

function pick(fields) {
	return function (obj) {
		if (!Array.isArray(fields)) throw new TypeError("filterObj() requiere un array", "lib.js");
		var o = {};
		fields.forEach(function (field) {
			o[field] = obj[field];
		});
		return o;
	};
}

},{}],7:[function(require,module,exports){
/*!
 * JavaScript Cookie v2.2.0
 * https://github.com/js-cookie/js-cookie
 *
 * Copyright 2006, 2015 Klaus Hartl & Fagner Brack
 * Released under the MIT license
 */
;(function (factory) {
	var registeredInModuleLoader = false;
	if (typeof define === 'function' && define.amd) {
		define(factory);
		registeredInModuleLoader = true;
	}
	if (typeof exports === 'object') {
		module.exports = factory();
		registeredInModuleLoader = true;
	}
	if (!registeredInModuleLoader) {
		var OldCookies = window.Cookies;
		var api = window.Cookies = factory();
		api.noConflict = function () {
			window.Cookies = OldCookies;
			return api;
		};
	}
}(function () {
	function extend () {
		var i = 0;
		var result = {};
		for (; i < arguments.length; i++) {
			var attributes = arguments[ i ];
			for (var key in attributes) {
				result[key] = attributes[key];
			}
		}
		return result;
	}

	function init (converter) {
		function api (key, value, attributes) {
			var result;
			if (typeof document === 'undefined') {
				return;
			}

			// Write

			if (arguments.length > 1) {
				attributes = extend({
					path: '/'
				}, api.defaults, attributes);

				if (typeof attributes.expires === 'number') {
					var expires = new Date();
					expires.setMilliseconds(expires.getMilliseconds() + attributes.expires * 864e+5);
					attributes.expires = expires;
				}

				// We're using "expires" because "max-age" is not supported by IE
				attributes.expires = attributes.expires ? attributes.expires.toUTCString() : '';

				try {
					result = JSON.stringify(value);
					if (/^[\{\[]/.test(result)) {
						value = result;
					}
				} catch (e) {}

				if (!converter.write) {
					value = encodeURIComponent(String(value))
						.replace(/%(23|24|26|2B|3A|3C|3E|3D|2F|3F|40|5B|5D|5E|60|7B|7D|7C)/g, decodeURIComponent);
				} else {
					value = converter.write(value, key);
				}

				key = encodeURIComponent(String(key));
				key = key.replace(/%(23|24|26|2B|5E|60|7C)/g, decodeURIComponent);
				key = key.replace(/[\(\)]/g, escape);

				var stringifiedAttributes = '';

				for (var attributeName in attributes) {
					if (!attributes[attributeName]) {
						continue;
					}
					stringifiedAttributes += '; ' + attributeName;
					if (attributes[attributeName] === true) {
						continue;
					}
					stringifiedAttributes += '=' + attributes[attributeName];
				}
				return (document.cookie = key + '=' + value + stringifiedAttributes);
			}

			// Read

			if (!key) {
				result = {};
			}

			// To prevent the for loop in the first place assign an empty array
			// in case there are no cookies at all. Also prevents odd result when
			// calling "get()"
			var cookies = document.cookie ? document.cookie.split('; ') : [];
			var rdecode = /(%[0-9A-Z]{2})+/g;
			var i = 0;

			for (; i < cookies.length; i++) {
				var parts = cookies[i].split('=');
				var cookie = parts.slice(1).join('=');

				if (!this.json && cookie.charAt(0) === '"') {
					cookie = cookie.slice(1, -1);
				}

				try {
					var name = parts[0].replace(rdecode, decodeURIComponent);
					cookie = converter.read ?
						converter.read(cookie, name) : converter(cookie, name) ||
						cookie.replace(rdecode, decodeURIComponent);

					if (this.json) {
						try {
							cookie = JSON.parse(cookie);
						} catch (e) {}
					}

					if (key === name) {
						result = cookie;
						break;
					}

					if (!key) {
						result[name] = cookie;
					}
				} catch (e) {}
			}

			return result;
		}

		api.set = api;
		api.get = function (key) {
			return api.call(api, key);
		};
		api.getJSON = function () {
			return api.apply({
				json: true
			}, [].slice.call(arguments));
		};
		api.defaults = {};

		api.remove = function (key, attributes) {
			api(key, '', extend(attributes, {
				expires: -1
			}));
		};

		api.withConverter = init;

		return api;
	}

	return init(function () {});
}));

},{}],8:[function(require,module,exports){
(function (root) {

  // Store setTimeout reference so promise-polyfill will be unaffected by
  // other code modifying setTimeout (like sinon.useFakeTimers())
  var setTimeoutFunc = setTimeout;

  function noop() {}
  
  // Polyfill for Function.prototype.bind
  function bind(fn, thisArg) {
    return function () {
      fn.apply(thisArg, arguments);
    };
  }

  function Promise(fn) {
    if (!(this instanceof Promise)) throw new TypeError('Promises must be constructed via new');
    if (typeof fn !== 'function') throw new TypeError('not a function');
    this._state = 0;
    this._handled = false;
    this._value = undefined;
    this._deferreds = [];

    doResolve(fn, this);
  }

  function handle(self, deferred) {
    while (self._state === 3) {
      self = self._value;
    }
    if (self._state === 0) {
      self._deferreds.push(deferred);
      return;
    }
    self._handled = true;
    Promise._immediateFn(function () {
      var cb = self._state === 1 ? deferred.onFulfilled : deferred.onRejected;
      if (cb === null) {
        (self._state === 1 ? resolve : reject)(deferred.promise, self._value);
        return;
      }
      var ret;
      try {
        ret = cb(self._value);
      } catch (e) {
        reject(deferred.promise, e);
        return;
      }
      resolve(deferred.promise, ret);
    });
  }

  function resolve(self, newValue) {
    try {
      // Promise Resolution Procedure: https://github.com/promises-aplus/promises-spec#the-promise-resolution-procedure
      if (newValue === self) throw new TypeError('A promise cannot be resolved with itself.');
      if (newValue && (typeof newValue === 'object' || typeof newValue === 'function')) {
        var then = newValue.then;
        if (newValue instanceof Promise) {
          self._state = 3;
          self._value = newValue;
          finale(self);
          return;
        } else if (typeof then === 'function') {
          doResolve(bind(then, newValue), self);
          return;
        }
      }
      self._state = 1;
      self._value = newValue;
      finale(self);
    } catch (e) {
      reject(self, e);
    }
  }

  function reject(self, newValue) {
    self._state = 2;
    self._value = newValue;
    finale(self);
  }

  function finale(self) {
    if (self._state === 2 && self._deferreds.length === 0) {
      Promise._immediateFn(function() {
        if (!self._handled) {
          Promise._unhandledRejectionFn(self._value);
        }
      });
    }

    for (var i = 0, len = self._deferreds.length; i < len; i++) {
      handle(self, self._deferreds[i]);
    }
    self._deferreds = null;
  }

  function Handler(onFulfilled, onRejected, promise) {
    this.onFulfilled = typeof onFulfilled === 'function' ? onFulfilled : null;
    this.onRejected = typeof onRejected === 'function' ? onRejected : null;
    this.promise = promise;
  }

  /**
   * Take a potentially misbehaving resolver function and make sure
   * onFulfilled and onRejected are only called once.
   *
   * Makes no guarantees about asynchrony.
   */
  function doResolve(fn, self) {
    var done = false;
    try {
      fn(function (value) {
        if (done) return;
        done = true;
        resolve(self, value);
      }, function (reason) {
        if (done) return;
        done = true;
        reject(self, reason);
      });
    } catch (ex) {
      if (done) return;
      done = true;
      reject(self, ex);
    }
  }

  Promise.prototype['catch'] = function (onRejected) {
    return this.then(null, onRejected);
  };

  Promise.prototype.then = function (onFulfilled, onRejected) {
    var prom = new (this.constructor)(noop);

    handle(this, new Handler(onFulfilled, onRejected, prom));
    return prom;
  };

  Promise.all = function (arr) {
    return new Promise(function (resolve, reject) {
      if (!arr || typeof arr.length === 'undefined') throw new TypeError('Promise.all accepts an array');
      var args = Array.prototype.slice.call(arr);
      if (args.length === 0) return resolve([]);
      var remaining = args.length;

      function res(i, val) {
        try {
          if (val && (typeof val === 'object' || typeof val === 'function')) {
            var then = val.then;
            if (typeof then === 'function') {
              then.call(val, function (val) {
                res(i, val);
              }, reject);
              return;
            }
          }
          args[i] = val;
          if (--remaining === 0) {
            resolve(args);
          }
        } catch (ex) {
          reject(ex);
        }
      }

      for (var i = 0; i < args.length; i++) {
        res(i, args[i]);
      }
    });
  };

  Promise.resolve = function (value) {
    if (value && typeof value === 'object' && value.constructor === Promise) {
      return value;
    }

    return new Promise(function (resolve) {
      resolve(value);
    });
  };

  Promise.reject = function (value) {
    return new Promise(function (resolve, reject) {
      reject(value);
    });
  };

  Promise.race = function (values) {
    return new Promise(function (resolve, reject) {
      for (var i = 0, len = values.length; i < len; i++) {
        values[i].then(resolve, reject);
      }
    });
  };

  // Use polyfill for setImmediate for performance gains
  Promise._immediateFn = (typeof setImmediate === 'function' && function (fn) { setImmediate(fn); }) ||
    function (fn) {
      setTimeoutFunc(fn, 0);
    };

  Promise._unhandledRejectionFn = function _unhandledRejectionFn(err) {
    if (typeof console !== 'undefined' && console) {
      console.warn('Possible Unhandled Promise Rejection:', err); // eslint-disable-line no-console
    }
  };

  /**
   * Set the immediate function to execute callbacks
   * @param fn {function} Function to execute
   * @deprecated
   */
  Promise._setImmediateFn = function _setImmediateFn(fn) {
    Promise._immediateFn = fn;
  };

  /**
   * Change the function to execute on unhandled rejection
   * @param {function} fn Function to execute on unhandled rejection
   * @deprecated
   */
  Promise._setUnhandledRejectionFn = function _setUnhandledRejectionFn(fn) {
    Promise._unhandledRejectionFn = fn;
  };
  
  if (typeof module !== 'undefined' && module.exports) {
    module.exports = Promise;
  } else if (!root.Promise) {
    root.Promise = Promise;
  }

})(this);

},{}]},{},[1]);
