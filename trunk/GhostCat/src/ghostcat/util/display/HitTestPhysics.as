package ghostcat.util.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.parse.display.DrawParse;

	/**
	 * 检测一个对象和位图图形之间重叠区域，并返回一个物体重叠相对位置的矢量，可用来处理位图碰撞 
	 * @author flashyiyi
	 * 
	 */
	public final class HitTestPhysics
	{
		public static const ALPHA:String = "alpha";
		public static const BRIGHTNESS:String = "brightness";
		
		/**
		 * 检测显示对象（显示对象会先被转换为位图） 
		 * @param cotainer
		 * @param obj
		 * @param type
		 * @return 
		 * 
		 */
		public static function hitTest(cotainer:DisplayObject,obj:DisplayObject,type:String = "alpha"):Point
		{
			var b:Bitmap = new DrawParse(cotainer).createBitmap();
			var p:Point =  hitTestBitmap(b,obj,type);
			b.bitmapData.dispose();
			return p;
		}
		
		/**
		 * 检测位图 
		 * @param bitmap
		 * @param obj
		 * @param type
		 * @return 
		 * 
		 */
		public static function hitTestBitmap(bitmap:Bitmap,obj:DisplayObject,type:String = "alpha"):Point
		{
			//获得碰撞范围
			var ct:ColorTransform=new ColorTransform()			
			ct.color=0xFF00000F;
			
			var rect:Rectangle = obj.getBounds(bitmap);
			var sRect:Rectangle = obj.getBounds(obj);
			var temp:BitmapData = new BitmapData(rect.width,rect.height,true,0);
			temp.copyPixels(bitmap.bitmapData,rect,new Point());
			temp.colorTransform(temp.rect,ct);
			var mat:Matrix = MatrixUtil.getMatrixAt(obj,bitmap);
			mat.translate(-rect.x,-rect.y);
			temp.draw(obj,mat,ct,BlendMode.ADD);
			temp.threshold(temp,temp.rect,new Point(),">",0xFF00000F,0xFFFF0000);
			
			var mid:Point = new Point(0.5,0.5);
			var total:Point = new Point();
			//在碰撞范围内计算矢量
			for (var i:int = 0;i < temp.width;i++)
			{
				for (var j:int = 0;j < temp.height;j++)
				{
					if (temp.getPixel32(i,j) == 0xFFFF0000)
					{
						var c:uint = bitmap.bitmapData.getPixel32(rect.x + i,rect.y + j);
						var m:Number;
						switch (type)
						{
							case ALPHA:
								m = (c >> 24)/0xFF;
								break;
							case BRIGHTNESS:
								c = ColorConvertUtil.toHSL(c);
								m = 1 - (c & 0xFF)/0xFF;
								break;
						}
						var p:Point = new Point(i / temp.width,j / temp.width).subtract(mid);
						p.normalize(1/p.length)
						p.x *= m;
						p.y *= m;
						total = total.add(p);
					}
				}
			}
			temp.dispose();
			return total;
		}
	}
}