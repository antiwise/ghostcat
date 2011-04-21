package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.display.particle.CloudCreater;
	import ghostcat.display.particle.SakuraCreater;
	import ghostcat.display.particle.SnowCreater;
	import ghostcat.display.transfer.GBitmapEffect;
	import ghostcat.skin.AlertSkin;
	import ghostcat.skin.cursor.CursorGroup;
	import ghostcat.util.code.CodeColor;
	import ghostcat.util.code.CodeCreater;
	import ghostcat.util.data.BigNumberUtil;
	import ghostcat.util.display.ColorContant;
	import ghostcat.util.easing.TweenUtil;
	
	[SWF(frameRate="30",width="1000",height="1000")]
	public class Test extends Sprite 
	{
		[Embed(source="p6.jpg")]
		public var cls:Class;
		
		public var p:flash.geom.Point;
		public function Test()
		{
			var t:String = CodeCreater.createByObject({x:1},"UI");
			ColorContant
			var text:TextField = new TextField();
			text.autoSize = TextFieldAutoSize.LEFT;
			addChild(text);
			
			text.text = t;
			
			new CodeColor().parse(text);
		}
		
	}
}