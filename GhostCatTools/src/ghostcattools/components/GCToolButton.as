package ghostcattools.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import ghostcat.util.ReflectUtil;
	
	import ghostcattools.skin.SmallButtonSkin;
	import ghostcattools.util.FileControl;
	
	import mx.core.Window;
	import mx.events.AIREvent;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.mediaClasses.VolumeBar;
	
	public class GCToolButton extends Button
	{
		public var cmd:Class;
		public var fileFilter:Array = null;
		
		public var windowResizable:Boolean = true;
		public var windowMaximizable:Boolean = true;
		
		public function GCToolButton()
		{
			super();
			
			this.setStyle("skinClass",SmallButtonSkin);
			
			this.addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
			this.addEventListener(MouseEvent.CLICK,mouseClickHandler);
		}
		
		private function mouseClickHandler(event:MouseEvent):void
		{
			if (cmd)
				openWindow();
		}
		
		private function creationCompleteHandler(event:FlexEvent):void
		{
			FileControl.dragFileIn(dragInHandler,this,fileFilter);
		}
		
		private function dragInHandler(files:Array):void
		{
			if (cmd)
				openWindow().openFileHandler(files);
		}
		
		private function openWindow():GCToolWindow
		{
			var window:GCToolWindow;
			if (GCToolWindow.openDict[cmd])
			{
				window = GCToolWindow.openDict[cmd];
				window.orderToFront();
				GhostCatTools.instance.minimize();
			}
			else
			{
				window = new cmd() as GCToolWindow;
				window.resizable = windowResizable;
				window.maximizable = windowMaximizable;
				window.open();
				window.addEventListener(FlexEvent.CREATION_COMPLETE,h);
				function h(e:Event):void
				{
					GhostCatTools.instance.minimize();
				}
			}
			return window;
		}
	}
}