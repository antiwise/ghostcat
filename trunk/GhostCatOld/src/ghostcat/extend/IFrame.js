/**
 * 
 * 操作IFrame的管理类
 * 
 * @author flashyiyi
 */

var IFrameManager = {
	moveIFrame: function (id,x,y,w,h) {
	    var frameRef=document.getElementById(id);
	    frameRef.style.left=x;
	    frameRef.style.top=y;
	    var iFrameRef=frameRef.firstChild;	
	    if (iFrameRef)
	    {
			iFrameRef.width=w;
			iFrameRef.height=h;
		}
	},

	hideIFrame: function (id){
	    document.getElementById(id).style.visibility="hidden";
	},
	
	showIFrame: function (id){
	    document.getElementById(id).style.visibility="visible";
	},

	loadIFrame: function (id,url){
		document.getElementById(id).innerHTML = "<iframe src='" + url + "' frameborder='0'/>";
	},

	createIFrame: function (id){
		var oDiv = document.createElement("DIV");
		oDiv.id = id;
		oDiv.style.background = '#FFFFFF';
		oDiv.style.position = "absolute";
		oDiv.style.border = '0px';
		oDiv.style.visibility = 'hidden';
		document.body.appendChild(oDiv);
	},

	removeIFrame: function (id){
		var div = document.getElementById(id);
		div.parentNode.removeChild(div);
	}
}