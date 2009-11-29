package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	
	import ghostcat.parse.display.SimpleRectParse;
	import ghostcat.text.fte.GRichText;
	
	public class GhostCatFP10Example extends Sprite
	{
		public function GhostCatFP10Example():void
		{
			var str1:String = "这里是一段文本。。。。。";
			var str2:String = "。。。。";
			
			var t:GRichText = new GRichText();
			t.textWidth = 200;
			addChild(t);
			t.addText(str1);
			t.addGraphics(new SimpleRectParse(100,100,0xFF0000,0xFFFF00).createShape());
			t.addGraphics(new SimpleRectParse(100,100,0xFF0000,0xFFFF00).createShape());
			t.addGraphics(new SimpleRectParse(100,100,0xFF0000,0xFFFF00).createShape());
			t.addText(str2);
			t.refresh();
		}
	}
	
}
