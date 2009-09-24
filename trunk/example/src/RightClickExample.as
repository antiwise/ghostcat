package 
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	import ghostcat.events.InputEvent;
	import ghostcat.manager.InputManager;
	
	/**
	 * 右键演示
	 * 
	 * 不需要做多余的事情，但必须设置SWF为透明显示来禁用原来的播放器右键
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class RightClickExample extends Sprite
	{
		public function RightClickExample()
		{
			InputManager.register(this);
			stage.addEventListener(InputEvent.MOUSE_RIGHT,h);
		}
		
		private function h(event:InputEvent):void
		{
			trace (event.localX, event.localY ,InputManager.instance.mutliRightMouse)
			graphics.beginFill(0);
			graphics.drawCircle(event.localX,event.localY,3 * InputManager.instance.mutliRightMouse);
		}
	}
}