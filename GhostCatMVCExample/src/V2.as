package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import ghostcat.mvc.GhostCatMVC;
	
	[V(name="test2")]
	public class V2 extends Sprite
	{
		public var textField:TextField;
		public function V2()
		{
			textField = new TextField();
			textField.text = "0";
			textField.y = 20;
			addChild(textField);
			
			addEventListener(MouseEvent.CLICK,clickHandler);
			
			GhostCatMVC.instance.bindSetter(setText,this,"m","value");
		}
		
		public function clickHandler(event:MouseEvent):void
		{
			GhostCatMVC.instance.call(this,"c","execute",textField.text);
		}
		
		public function setText(v:String):void
		{
			if (v)
				textField.text = v;
		}
	}
}