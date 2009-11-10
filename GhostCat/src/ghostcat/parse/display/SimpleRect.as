package ghostcat.parse.display
{
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	import ghostcat.parse.display.RectParse;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.parse.graphics.GraphicsRect;
	
	public class SimpleRect extends Sprite
	{
		public function SimpleRect(width:Number,height:Number,color:uint = 0xFFFFFF,title:String=null,titleColor:uint=0x0)
		{
			super();
			new RectParse(new GraphicsRect(0,0,width,height),null,new GraphicsFill(color)).parse(this);
			if (title)
				new TextFieldParse(title,null,new TextFormat(null,null,titleColor)).parse(this);
		}
	}
}