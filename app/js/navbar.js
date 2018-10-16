import * as Cookie from 'js-cookie';

listenClick('profile-pic', toggle('mnu-profile'));
listenClick('mnu-profile-close-session', closeSession);
listenClick('mnu-profile-change-currency', changeCurrency);


function closeSession (_) {
	Cookie.remove('jwt');
	window.location.href = '/';
}
