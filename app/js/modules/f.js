
export function groupBy(field) {
	return function(arr) {
			return arr.reduce( function(acc, obj) {
				acc.appendChild(obj[field]);
				return acc;
			}, document.createDocumentFragment());
}
