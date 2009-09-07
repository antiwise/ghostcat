package org.ghostcat.display.viewport
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.ghostcat.algorithm.bezier.Line;
	import org.ghostcat.display.GBase;
	import org.ghostcat.display.DisplayUtil;

	/**
	 * 场景墙壁类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Wall extends GBase
	{
		private var _line:Line;
		
		private var _startPoint:Point;
		private var _endPoint:Point;
		private var _wallHeight:Number;
		
		public function Wall(skin:DisplayObject,startPoint:Point,endPoint:Point,wallHeight:Number)
		{
			this.acceptContentPosition = false;
			
			super(skin);
			
			this.startPoint = startPoint;
			this.endPoint = endPoint;
			this.wallHeight = wallHeight;
		}

		/**
		 * 获得底边直线
		 *  
		 * @return 
		 * 
		 */
		public function get line():Line
		{
			return _line;
		}

		/**
		 * 墙高
		 * @return 
		 * 
		 */
		public function get wallHeight():Number
		{
			return _wallHeight;
		}

		public function set wallHeight(v:Number):void
		{
			_wallHeight = v;
			invalidateDisplayList();
		}

		/**
		 * 起始点
		 * @return 
		 * 
		 */
		public function get startPoint():Point
		{
			return _startPoint;
		}

		public function set startPoint(v:Point):void
		{
			_startPoint = v;
			invalidateDisplayList();
		}

		/**
		 * 结束点
		 * @return 
		 * 
		 */
		public function get endPoint():Point
		{
			return _endPoint;
		}

		public function set endPoint(v:Point):void
		{
			_endPoint = v;
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList() : void
		{
			_line = new Line(_startPoint,_endPoint);
			var sp:Point = globalToLocal(_startPoint);
			var ep:Point = globalToLocal(_endPoint);
			var wh:Number = wallHeight;
			var rect:Rectangle = content.getRect(content);
			
			var m:Matrix = new Matrix();
			m.tx = sp.x;
			m.ty = sp.y - wh;
			m.a = (ep.x - sp.x) / rect.width;
			m.d = wh / rect.height;
			content.transform.matrix = m;
			
			DisplayUtil.chamfer(content,0,ep.y - sp.y);
		} 
	}
}