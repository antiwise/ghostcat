package 
{
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.display.GSprite;
	import ghostcat.display.residual.FireScreen;
	import ghostcat.events.InputEvent;
	import ghostcat.manager.InputManager;
	import ghostcat.manager.RootManager;
	import ghostcat.ui.containers.GAlert;
	import ghostcat.util.Util;
	
	[SWF(width="350",height="350")]
	
	/**
	 * 右键演示
	 * 
	 * 不需要做多余的事情，但必须设置SWF为透明显示来禁用原来的播放器右键
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class RightClickExample extends GSprite
	{
		public var shape:Shape;
		protected override function init():void
		{
			RootManager.register(this);
			InputManager.register(this);
			stage.addEventListener(InputEvent.MOUSE_RIGHT,h);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,f);
			
			shape = new Shape();
			shape.cacheAsBitmap = true;
			addChild(shape);
			
			//对舞台增加一个火焰效果
			addChild(Util.createObject(new FireScreen(350,350,20),{children:[shape]}));
		
			GAlert.show("点击右键看看吧\n可以连续点击","嘿嘿")
		}
		
		private function f(event:MouseEvent):void
		{
			trace (event.localX, event.localY ,InputManager.instance.mutliMouse)
			
			shape.graphics.beginFill(0xFF0000);
			shape.graphics.drawCircle(event.stageX,event.stageY,3 * InputManager.instance.mutliMouse);
		}
		
		private function h(event:InputEvent):void
		{
			trace (event.localX, event.localY ,InputManager.instance.mutliRightMouse)
			
			shape.graphics.beginFill(0xFF0000);
			shape.graphics.drawCircle(event.localX,event.localY,3 * InputManager.instance.mutliRightMouse);
		}
	}
}