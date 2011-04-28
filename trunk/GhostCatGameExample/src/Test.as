package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.display.particle.CloudCreater;
	import ghostcat.display.particle.SakuraCreater;
	import ghostcat.display.particle.SnowCreater;
	import ghostcat.display.transfer.GBitmapEffect;
	import ghostcat.manager.RootManager;
	import ghostcat.skin.AlertSkin;
	import ghostcat.skin.cursor.CursorGroup;
	import ghostcat.util.FontEmbedHelper;
	import ghostcat.util.code.CodeColor;
	import ghostcat.util.code.CodeCreater;
	import ghostcat.util.data.BigNumberUtil;
	import ghostcat.util.display.ColorContant;
	import ghostcat.util.easing.TweenUtil;
	
	[SWF(frameRate="30",width="1000",height="1000",backgroundColor="0xFFFFFF")]
	public class Test extends Sprite 
	{
		[Embed(source="p6.jpg")]
		public var cls:Class;
		
		public var p:flash.geom.Point;
		public function Test()
		{
//			0x3001,0x3002,0x3008,0x3009,0x3010,0x3011
			for (var i:int = 0x3008;i < 0x3012;i++)
				trace(String.fromCharCode(i))
			for (var i:int = 0x3014;i < 0x3018;i++)
				trace(String.fromCharCode(i))
		}
		
	}
}