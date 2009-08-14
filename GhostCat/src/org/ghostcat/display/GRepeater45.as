package org.ghostcat.display
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.ghostcat.events.RepeatEvent;
	import org.ghostcat.util.Util;

	/**
	 * 45度角重复场景
	 * 源数据如果是菱形，长宽比必须是2:1，如果是由矩形转换，则必须是正方形。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GRepeater45 extends GRepeater
	{
		/**
		 * 是否将源图像由矩形转换成菱形
		 */
		public var tranSourceTo45:Boolean = false;
		public function GRepeater45(base:*,tranSourceTo45:Boolean = false)
		{
			this.tranSourceTo45 = tranSourceTo45;
			super(base);
		}
		
		public static function shapeTo45(p:DisplayObject):void
		{
			var m:Matrix = p.transform.matrix.clone();
            m.b = m.c = -Math.tan(1/3);
            m.rotate(Math.PI/4);
            p.transform.matrix = m;
		}
		
		private static const SQRT5:Number = Math.sqrt(5);
		
		
		public static function pointTo45(p:Point):Point
		{
			return new Point(p.x - p.y,p.x / 2 + p.y / 2);
		}
		
		override public function setContentClass(ref:*) : void
		{
			super.setContentClass(ref);
			if (this.ref && tranSourceTo45)//使用经过变换后的大小
			{
				var len:Number = _contentRect.width;
				_contentRect = new Rectangle(_contentRect.x - len,_contentRect.y,len + len,len);
			}
		}
		
		override protected function addItem(i:int,j:int,lowest:Boolean=false):DisplayObject
		{
			if (contents[i + ":" +j])
				return contents[i + ":" +j];
			
			var s:DisplayObject = unuseContents.pop();
			if (!s)
				s = ref.newInstance();
			
			var p:Point;
			p = new Point(i * contentRect.width/2, j * contentRect.height);
			p = pointTo45(p);
			s.x = p.x;
			s.y = p.y;
			contents[i + ":" +j] = s;
			
			if (tranSourceTo45)
				shapeTo45(s);
				
			if (lowest)
				addChildAt(s,0);
			else
				addChild(s);
			dispatchEvent(Util.createObject(new RepeatEvent(RepeatEvent.ADD_REPEAT_ITEM),{repeatObj:s,repeatPos:new Point(i,j)}));
		
			return s;
		}
	}
}