package 
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	import org.ghostcat.events.InputEvent;
	import org.ghostcat.manager.InputManager;
	
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