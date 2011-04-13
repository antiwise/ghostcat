var Browser={ie:/msie/.test(window.navigator.userAgent.toLowerCase()),moz:/gecko/.test(window.navigator.userAgent.toLowerCase()),opera:/opera/.test(window.navigator.userAgent.toLowerCase()),safari:/safari/.test(window.navigator.userAgent.toLowerCase())};

function createActiveXObject($){
	var A,_=null;
	try{
		if(window.ActiveXObject)
			_=new ActiveXObject($);
		else if(window.GeckoActiveXObject)
			_=new GeckoActiveXObject($)
	}catch(A){}
	return _
}
var myObject,nowType
var ieplayer6=createActiveXObject("MediaPlayer.MediaPlayer.1")?true:false
var ieplayer7=createActiveXObject("WMPlayer.OCX.7")?true:false;
if (!Browser.ie) var nsplayer=(navigator.mimeTypes["application/x-mplayer2"].enabledPlugin)?true:false;
function G($){
	return document.getElementById($)
}
function insertAfter($,_){
	_.appendChild($);
}
function IEmPlay(_,$){
	if (nowType=="realPlay"){
		if(G("rpl")) G("rpl").SRC="";
		if(G("rpl")) G("rpl").removeNode(true);
		if(G("myObject")) G("myObject").removeNode(true)
	}
	if (G("myObject")) 
		myObject=G("myObject");
	else if(ieplayer6){
		myObject=document.createElement("object");
		myObject.id="myObject";
		myObject.classid="clsid:22D6F312-B0F6-11D0-94AB-0080C74C7E95";
		myObject.AudioStream="0";
		myObject.autoStart="1";
		myObject.showpositioncontrols="0";
		myObject.showcontrols="0";
		myObject.ShowStatusBar="0";
		myObject.ShowDisplay="0";
		myObject.InvokeURLs="-1";
		myObject.style.display="none";
	}else{
		myObject=document.createElement("object");
		myObject.id="myObject";
		myObject.classid="clsid:6BF52A52-394A-11D3-B153-00C04F79FAA6";
		myObject.autoStart="1";
		myObject.showpositioncontrols="0";
		myObject.showcontrols="0";
		myObject.ShowAudioControls="0";
		myObject.ShowStatusBar="0";
		myObject.enabled="1";
		myObject.windowlessVideo="0";
		myObject.InvokeURLs="-1";
		myObject.Visualizations="0";
		myObject.ShowTracker="0";
		myObject.style.display="none";
	}
	insertAfter(myObject,$);
	if(ieplayer6) 
		myObject.Filename = _;
	else 
		myObject.url = _;
	nowType="mediaPlay"
}
function NSmPlay(_,$){
	if(nowType=="realPlay"){
		if(G("rpl")) G("rpl").SRC="";
		if(G("rpl")) G("rpl").removeNode(true);
		if(G("myObject")) G("myObject").removeNode(true)
	}
	if(G("myObject")) 
		myObject=G("myObject");
	else{
		myObject=document.createElement("EMBED");
		myObject.id="myObject";
		myObject.type="application/x-mplayer2";
		myObject.autostart="1";
		myObject.quality="high";
		myObject.showcontrols="0";
		myObject.showpositioncontrols="0";
		myObject.InvokeURLs="-1";
		myObject.width="0";
		myObject.height="0";
	}
	myObject.src= _;
	insertAfter(myObject,$);
	nowType="mediaPlay";
}
function remove($){
	G($).parentNode.removeChild(G($))
}
function realplay(_,$){
	if(nowType=="mediaPlay"){
		if(ieplayer6){
			if(G("myObject")) G("myObject").Filename=""
		}else if (G("myObject")) {
			G("myObject").src="";
			G("myObject").parentNode.removeChild(G("myObject"))
		}
		if(G("myObject")) 
			myrealpObject=G("myObject");
		else{
			myrealpObject=document.createElement("div");
			myrealpObject.id="myObject";
			myrealpObject.innerHTML='<object id="rpl" classid="clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA"><param name="AUTOSTART" value="-1"><param name="src" value="'+_+'"><param name="CONSOLE" value="Clip1"></object>'
		}
		insertAfter(myrealpObject,$);
		G("rpl").SetSource(_);
		G("rpl").DoPlay();
		nowType="realPlay";
	};
};
function mediaRadio(_,$){
	if(Browser.ie){
		IEmPlay(_,$)
	}else if(!Browser.ie&&nsplayer){
		NSmPlay(_,$)
	}
}
function realRadio(_,$){
	if(RealMode){
		realplay(_,$)
	}
}
function radioPlay(_){
	var A=_,B=A.lastIndexOf("."),$=A.substring(0,4).toLowerCase();
	if(($=="rtsp")||(A.substring(B).toLowerCase()==".rm")||($=="rstp"))
		realRadio(_,document.body)
	else 
		mediaRadio(_,document.body);
}
function radioStop(){
	if(nowType=="realPlay"){
		if(G("rpl")) G("rpl").SRC="";
		if(G("rpl")) G("rpl").removeNode(true);
		if(G("myObject")) G("myObject").removeNode(true)
	};
	if(nowType=="mediaPlay"){
		if(ieplayer6){
			if(G("myObject")) G("myObject").Filename=""
		}else if(G("myObject")){
			G("myObject").src="";
			G("myObject").parentNode.removeChild(G("myObject"))
		}
	}
}
function setVolume(_){
	if(nowType=="realPlay"){
		if(G("rpl")) G("rpl").Volume=_;
	};
	if(nowType=="mediaPlay"){
		if(G("myObject")) G("myObject").Volume=_;
	}
}