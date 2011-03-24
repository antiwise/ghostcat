package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import ghostcat.events.MoveEvent;
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.controls.GText;
	import ghostcat.util.OperatorUtil;
	import ghostcat.util.data.E4XUtil;

	public class OperatorExample extends Sprite
	{
		private var input:GText;
		private var output:GText;
		private var bn:GButton;

		public function OperatorExample()
		{
			trace(E4XUtil.exec([[1,2],[2,3],[3,4],[4,5]],".([0] == 3).*[1]"));
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			output.text = OperatorUtil.exec(input.text);
		}
		
	}
}