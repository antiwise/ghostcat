package ghostcat.ui.containers
{
	import flash.display.MovieClip;
	
	import ghostcat.ui.PopupManager;
	
	public class GAlert extends GMovieClipPanel
	{
		public static function show(text:String,title:String = null):GAlert
		{
			var alert:GAlert = new GAlert();
			alert.title = title;
			alert.text = text;
			
			PopupManager.instance.showPopup(alert);
			
			return alert;
		}
		
		public var title:String;
		public var text:String;
		
		public function GAlert(mc:MovieClip=null, replace:Boolean=true, paused:Boolean=false, fields:Object=null)
		{
			super(mc, replace, paused, fields);
		}
	}
}