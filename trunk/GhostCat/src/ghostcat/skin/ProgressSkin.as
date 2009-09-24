package ghostcat.skin
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import ghostcat.parse.DisplayParse;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.parse.graphics.GraphicsFill;
	import ghostcat.parse.graphics.GraphicsLineStyle;
	import ghostcat.parse.graphics.GraphicsRect;
	
	/**
	 * 滚动条皮肤 
	 * @author flashyiyi
	 * 
	 */
	public class ProgressSkin extends Sprite
	{
		public var thumb:DisplayObject;
		public var labelTextField:TextField;
		
		public function ProgressSkin(width:Number=100,height:Number=4,borderColor:uint=0x0,fillColor:uint=0xFFFFFF,backColor:uint=0x303030)
		{
			DisplayParse.create([new GraphicsLineStyle(1,borderColor),
								new GraphicsFill(backColor),
								new GraphicsRect(0,0,width,height)]).parse(this);
			
			thumb = DisplayParse.createShape([new GraphicsLineStyle(1,borderColor),
											new GraphicsFill(fillColor),
											new GraphicsRect(0,0,width,height)]);
			addChild(thumb);
			
			labelTextField = TextFieldParse.createTextField("",new Point(0,height));
			addChild(labelTextField);
		}
	}
}