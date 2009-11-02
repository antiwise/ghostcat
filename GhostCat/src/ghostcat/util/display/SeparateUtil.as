package ghostcat.util.display
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.parse.display.DrawParse;

	/**
	 * 程序分离素材
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class SeparateUtil
	{
		/**
		 * 分割图形
		 * 
		 * @param v
		 * @param width	格子宽度
		 * @param height	格子高度
		 * @return 
		 * 
		 */
		public static function separateShape(v:DisplayObject,width:Number,height:Number):Array
		{
			var cRect:Rectangle = v.getRect(v);
			var w:int = Math.ceil(cRect.width / width);
			var h:int = Math.ceil(cRect.height / height);
			var startPoint:Point = new Point(cRect.left,cRect.top);
			
			var result:Array = [];
			
			for (var j:int = 0;j < h;j++)
			{
				result.push([]);
				for (var i:int = 0;i < w;i++)
				{
					var p:Point = new Point(startPoint.x + i * width,startPoint.y + j * height);
					result[j].push(getSeparateShape(v,p,width,height))
				}
			}
			return result;
		}
		
		/**
		 * 获得一个分离的图形
		 * 
		 * @param v	图形源
		 * @param p	取样起点（相对与注册点）
		 * @param width	格子宽度
		 * @param height	格子高度
		 * @return 
		 * 
		 */
		private static function getSeparateShape(v:DisplayObject,p:Point,width:Number,height:Number):Sprite
		{
			var container:Sprite = new Sprite();
			var shape:DisplayObject = new v["constructor"]() as DisplayObject;
			var cRect:Rectangle = shape.getRect(shape);
			shape.x = -p.x;
			shape.y = -p.y;
			container.addChild(shape);
			var mask:Shape = new Shape();
			mask.graphics.beginFill(0);
			mask.graphics.drawRect(0,0,width,height);
			mask.graphics.endFill();
			container.addChild(mask);
			shape.mask = mask;
			
			container.x = p.x;
			container.y = p.y;
			return container;
		}
	}
}