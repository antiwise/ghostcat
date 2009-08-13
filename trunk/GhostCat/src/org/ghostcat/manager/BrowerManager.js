var BrowerManager={
	getURL:function (){
		return document.location.href;
	},
	setTitle:function (title){
		document.title = title;
	},
	getTitle:function (){
		return document.title;
	},
	setUrlVariables:function (url){
		window.location.replace(url);
	},
	addFavorite:function (url,title){
		window.external.AddFavorite(url, title);
	},
	setHomePage:function (url){
		this.style.behavior='url(#default#homepage)';
        	this.setHomePage(url);
	},
	setCookie:function (name, value, expires, security) {
		var str = name + '=' + escape(value);
		if (expires != null) str += ';expires=' + expires;
		if (security == true) str += ';secure';
		document.cookie = str;
	},
	getCookie:function (name) {
		var arr = document.cookie.match(new RegExp(';?' +name + '=([^;]*)'));
		if(arr != null) return unescape(arr[1]);
		return null;
	}
}