/**
 * 修改自开源项目：http://code.google.com/p/bezier/
 */
package ghostcat.algorithm.bezier
{
	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * 直线类
	 * 
	 */
	public class Line implements IParametric
	{
		protected const PRECISION : Number = 1e-10;
		private var _start : Point;
		private var _end : Point;
		public function Line(start : Point, end : Point) 
		{
			this.start = start;
			this.end = end;
		}
		/**
		 * 终点
		 * @return 
		 * 
		 */
		public function get end():Point
		{
			return _end;
		}

		public function set end(v:Point):void
		{
			_end = v;
		}

		/**
		 * 起点
		 * @return 
		 * 
		 */
		public function get start():Point
		{
			return _start;
		}

		public function set start(v:Point):void
		{
			_start = v;
		}

		/**
		 * 复制线
		 * 
		 * @return 
		 * 
		 */
		public function clone() : Line
		{
			return new Line(start.clone(), end.clone());
		}
		/**
		 * 设置斜角
		 * 
		 * @return 
		 * 
		 */
		public function get angle() : Number 
		{
			return Math.atan2(end.y - start.y, end.x - start.x);
		}
		public function set angle(rad : Number) : void 
		{
			const distance : Number = Point.distance(start, end);
			const polar : Point = Point.polar(distance, rad);
			end.x = start.x + polar.x;
			end.y = start.y + polar.y; 
		}
		/**
		 * 平移线
		 * 
		 * @param dx
		 * @param dx
		 * 
		 */
		public function offset(dx : Number = 0, dy : Number = 0) : void
		{
			start.offset(dx, dy);
			end.offset(dx, dy);
		}
		/**
		 * 获得线的长度
		 * 
		 * @return 
		 * 
		 */
		public function get length() : Number 
		{
			return Point.distance(start, end); 
		}
		/**
		 * 按比例获得线上某点的坐标
		 * 
		 * @param time	在线上的比例位置	
		 * 
		 **/
		public function getPoint(time : Number) : Point
		{
			var point:Point = new Point();
			point.x = start.x + (end.x - start.x) * time;
			point.y = start.y + (end.y - start.y) * time;
			return point;
		}
		/**
		 * 按长度获得线上某点的位置比例
		 * 
		 * @param time	在线上的比例	
		 */
		public function getTimeByDistance(distance : Number) : Number
		{
			return distance / Point.distance(start, end);
		}
		/**
		 * 通过设置线上的点的方式调整线
		 * 
		 * @param time	点所在线的比例
		 * @param x	设置点的横坐标，默认值则不变
		 * @param y	设置点的纵坐标，默认值则不变
		 * 
		 */
		public function setPoint(time : Number, x : Number = NaN, y : Number = NaN) : void
		{
			if (isNaN(x) && isNaN(y))
				return;
			
			const point : Point = getPoint(time);
			if (!isNaN(x))
				point.x = x;
			
			if (!isNaN(y))
				point.y = y;
			
			end.x = point.x + (point.x - start.x) * ((1 - time) / time);
			end.y = point.y + (point.y - start.y) * ((1 - time) / time);
		}
		public function getSegment(fromTime : Number = 0, toTime : Number = 1) : Line 
		{
			return new Line(getPoint(fromTime), getPoint(toTime));
		}
		/**
		 * 按位置比例获得线的长度
		 * 
		 * @param time	比例系数
		 * @return 
		 * 
		 */
		 
		public function getSegmentLength(time : Number) : Number
		{
			return Point.distance(start, getPoint(time));
		}
		/**
		 * 计算两条线的交点
		 *  
		 */
		public function intersectionLine(targetLine : Line) :Point
		{
			const fxMax : Number = Math.max(start.x, end.x);
			const fyMax : Number = Math.max(start.y, end.y);
			const fxMin : Number = Math.min(start.x, end.x);
			const fyMin : Number = Math.min(start.y, end.y);
			
			const sxMax : Number = Math.max(targetLine.start.x, targetLine.end.x);
			const syMax : Number = Math.max(targetLine.start.y, targetLine.end.y);
			const sxMin : Number = Math.min(targetLine.start.x, targetLine.end.x);
			const syMin : Number = Math.min(targetLine.start.y, targetLine.end.y);
		
			if (fxMax < sxMin || sxMax < fxMin || fyMax < syMin || syMax < fyMin)
				return null;  
			
			var solve : Point = new Point();

			const	a1 : Number = end.y - start.y,
					b1 : Number = start.x - end.x,
					c1 : Number = -a1 * start.x - b1 * start.y,
					a2 : Number = targetLine.end.y - targetLine.start.y,
					b2 : Number = targetLine.start.x - targetLine.end.x,
					c2 : Number = -a2 * targetLine.start.x - b2 * targetLine.start.y;
			
			var determinant : Number = a1 * b2 - a2 * b1;
			if (!determinant)
				return null;
			
			solve.x = -(c1 * b2 - c2 * b1) / determinant;
			solve.y = -(a1 * c2 - a2 * c1) / determinant;
			
			const time : Number = (b1 > 0) ? (start.x - solve.x) / b1 : (solve.y - start.y) / a1;
			const targetTime : Number = (b2 > 0) ? (targetLine.start.x - solve.x) / b2 : (solve.y - targetLine.start.y) / a2;
			
			if (time < 0 || time > 1 || targetTime < 0 || targetTime > 1)
				return null;				
			
			return solve;
		}
		/**
		 * 获得点在直线上的投影
		 * 
		 * @param fromPoint
		 * @return	在线上的比例，超出范围则返回NaN
		 * 
		 */
		public function getClosest(fromPoint : Point) : Number 
		{
			const	a1 : Number = end.y - start.y,
					b1 : Number = start.x - end.x,
					c1 : Number = -a1 * start.x - b1 * start.y;
			
			if (!a1 && !b1) 
				return NaN;
			
			const k : Number = (a1 * fromPoint.x + b1 * fromPoint.y + c1) / (a1 * a1 + b1 * b1);
			const p : Point = new Point(fromPoint.x - a1 * k, fromPoint.y - b1 * k);
			
			const time : Number = b1 ? (start.x - p.x) / b1 : (p.y - start.y) / a1;
		
			if (time < 0)
				return 0;
			
			if (time > 1) 
				return 1;
			
			return time;
		}
		
		/**
		 * 绘制
		 * @param g
		 * 
		 */
		public function parse(g:Graphics,dash:Number = NaN,dashStart:Number = 0.0):void
		{
			if (!isNaN(dash))
			{
				var len:Number = this.length / (dash + dash);
				var dl:Number = 1 / len;
				var sl:Number = dl * dashStart;
				for (var i:int = 0;i < len;i++)
					getSegment(i * dl + sl,i * dl + dl / 2 + sl).parse(g);
			}
			else
			{
				g.moveTo(start.x,start.y);
				g.lineTo(end.x,end.y);
			}
		}
	}
}