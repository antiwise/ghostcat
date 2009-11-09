package ghostcat.display.screenshot
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.parse.display.DrawParse;
	import ghostcat.util.display.BitmapUtil;

	/**
	 * 截屏方法
	 * @author flashyiyi
	 * 
	 */
	public final class ScreenShotUtil
	{
		/**
		 * 截取一个对象的图形 
		 * 
		 * @param v
		 * @param withOut	排除的对象
		 * 
		 */
		public static function shotObject(v:DisplayObject,clipRect:Rectangle = null,withOut:Array = null):BitmapData
		{
			if (!withOut)
				withOut = [];
			
			var oldVisible:Array = [];
			for (var i:int = 0;i < withOut.length;i++)
			{
				oldVisible.push(withOut[i].visible);
				withOut[i].visible = false;
			}
			
			var p:DrawParse = new DrawParse(v);
			p.clipRect = clipRect;
			var bitmap:BitmapData = p.createBitmapData();
			
			if (clipRect)
				bitmap = BitmapUtil.clip(bitmap,clipRect,true);
			
			for (i = 0;i < withOut.length;i++)
				withOut[i].visible = oldVisible[i].visible;
			
			return bitmap;
		}
	}
}