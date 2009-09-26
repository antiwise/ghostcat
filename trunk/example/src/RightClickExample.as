package 
{
	import ghostcat.display.GSprite;
	import ghostcat.display.residual.FireScreen;
	import ghostcat.events.InputEvent;
	import ghostcat.manager.InputManager;
	import ghostcat.manager.RootManager;
	import ghostcat.ui.containers.GAlert;
	import ghostcat.util.Util;
	
	[SWF(width="500",height="500")]
	
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
		protected override function init():void
		{
			RootManager.register(this);
			InputManager.register(this);
			stage.addEventListener(InputEvent.MOUSE_RIGHT,h);
			
			//对舞台增加一个火焰效果
			stage.addChild(Util.createObject(new FireScreen(500,500),{items:[this]}));
		
			GAlert.show("点击右键看看吧\n可以连续点击","嘿嘿")
		}
		
		private function h(event:InputEvent):void
		{
			trace (event.localX, event.localY ,InputManager.instance.mutliRightMouse)
			
			graphics.beginFill(0xFF0000);
			graphics.drawCircle(event.localX,event.localY,3 * InputManager.instance.mutliRightMouse);
		}
	}
}