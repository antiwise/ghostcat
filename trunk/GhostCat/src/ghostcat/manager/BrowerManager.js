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
	setUrlVariables:function (url)
	{
		window.location.replace(url);
	},
	addFavorite:function (url,title)
	{
		if (document.all)
			window.external.addFavorite(url,title);
		else if (window.sidebar)
			window.sidebar.addPanel(title, url, "");
		else
			alert("抱歉！您的浏览器不支持添加收藏。");  
	},
	setHomePage:function (url){
		try
		{
			document.body.style.behavior='url(#default#homepage)';
			document.body.setHomePage(url);
		}
		catch(e)
		{
			if(window.netscape)
			{
				try 
				{
					netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");  
				}  
				catch (e) 
				{ 
					alert("抱歉！您的浏览器不支持直接设为首页。请在浏览器地址栏输入“about:config”并回车然后将[signed.applets.codebase_principal_support]设置为“true”，点击“加入收藏”后忽略安全提示，即可设置成功。");  
				}
				var prefs = Components.classes['@mozilla.org/preferences-service;1'].getService(Components.interfaces.nsIPrefBranch);
				prefs.setCharPref('browser.startup.homepage',vrl);
			}
		}
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
	},
	confirmClose:function (text) {
		if (text != null)
		{
			window.onbeforeunload = onbeforeunload_handler;
			function onbeforeunload_handler() 
			{
				var warning = text;
				return warning;
			}
		}
		else
			window.onbeforeunload = null;
	},
	disableScroll:function (objId) {
		var obj = document;
		if (objId != null) 
			obj = document.getElementById(objId);   
               
		if (obj.addEventListener)
			obj.addEventListener('DOMMouseScroll', preventDefault, true);   
		else if (obj.attachEvent)  
			obj.attachEvent('onmousewheel', preventDefault, true);   
		else  
			obj['onmousewheel'] = preventDefault;
                
		function preventDefault(e)
		{   
			if (window.event)  
				window.event.returnValue = false;   
                  
			if (e && e.preventDefault)  
				e.preventDefault(); 
		}   
 	}
}