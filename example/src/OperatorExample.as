package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import ghostcat.events.MoveEvent;
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.controls.GText;
	import ghostcat.util.OperatorUtil;

	public class OperatorExample extends Sprite
	{
		private var input:GText;
		private var output:GText;
		private var bn:GButton;

		public function OperatorExample()
		{
			input = new GText();
			input.editable = true;
			input.textField.border = true;
			addChild(input);
			
			output = new GText();
			output.y = 16;
			addChild(output);
			
			bn = new GButton();
			bn.label = "确定";
			bn.y = 32;
			bn.addEventListener(MouseEvent.CLICK,clickHandler);
			addChild(bn);	
				
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			output.text = OperatorUtil.exec(input.text);
		}
		
	}
}