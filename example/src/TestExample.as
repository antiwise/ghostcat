package
{
	import flash.display.Sprite;
	
	import ghostcat.events.PropertyChangeEvent;
	import ghostcat.skin.ScrolDownButtonSkin;
	import ghostcat.ui.controls.GButton;
	
	[SWF(width="600",height="600")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			var t:GButton = new GButton(new ScrolDownButtonSkin());
			addChild(t);
		}
		
		private function r(event:PropertyChangeEvent):void
		{
			trace(event.property);
		}
	}
}