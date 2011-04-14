package ghostcat.debug
{
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	import ghostcat.parse.display.RectParse;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.parse.graphics.GraphicsRect;
	
	/**
	 * 用于占位显示的图元，在没有皮肤的时候代替皮肤使用
	 * @author tangwei
	 * 
	 */
	public class DebugRect extends Sprite
	{
		public function DebugRect(width:Number,height:Number,color:uint = 0xFFFFFF,title:String=null,titleColor:uint=0x0)
		{
			super();
			new RectParse(new GraphicsRect(0,0,width,height),null,new GraphicsFill(color)).parse(this);
			if (title)
				new TextFieldParse(title,null,new TextFormat(null,null,titleColor)).parse(this);
		}
	}
}