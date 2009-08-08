package org.ghostcat.algorithm.bezier
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 贝尔法曲线
	 * 
	 */
	public class Bezier implements IParametric
	{
		protected static const PRECISION : Number = 1e-10;

		private var _start : Point;
		public var control : Point;
		private var _end : Point;
		public var isSegment : Boolean = true;

		/** 
		 * @param start	起点
		 * @param control	曲线控制点
		 * @param end	结束点
		 **/
		public function Bezier(start : Point, control : Point, end : Point)
		{
			this.start = start;
			this.control = control;
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
		 * 复制曲线
		 *  
		 * @return 
		 * 
		 */

		public function clone() : Bezier
		{
			return new Bezier(start.clone(), control.clone(), end.clone());
		}

		/**
		 * 获得线的长度
		 * 
		 * @return 
		 * 
		 */
		public function get length() : Number
		{
			return getSegmentLength(1.0);
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
			const csX : Number = control.x - start.x;
			const csY : Number = control.y - start.y;
			const nvX : Number = end.x - control.x - csX;
			const nvY : Number = end.y - control.y - csY;
			
			// vectors: c0 = 4*(cs,cs), с1 = 8*(cs, ec-cs), c2 = 4*(ec-cs,ec-cs)
			const c0 : Number = 4 * (csX * csX + csY * csY);
			const c1 : Number = 8 * (csX * nvX + csY * nvY);
			const c2 : Number = 4 * (nvX * nvX + nvY * nvY);
			
			var ft : Number;
			var f0 : Number;
			
			if (c2 == 0)
			{
				if (c1 == 0)
				{
					ft = Math.sqrt(c0) * time;
					return ft;
				}
				else
				{
					ft = (2 / 3) * (c1 * time + c0) * Math.sqrt(c1 * time + c0) / c1;
					f0 = (2 / 3) * c0 * Math.sqrt(c0) / c1;
					return (ft - f0);
				}
			}
			else
			{
				const sqrt_0 : Number = Math.sqrt(c2 * time * time + c1 * time + c0);
				const sqrt_c0 : Number = Math.sqrt(c0);
				const sqrt_c2 : Number = Math.sqrt(c2);
						
				ft = 0.25 * (2 * c2 * time + c1) * sqrt_0 / c2;
				if ((0.5 * c1 + c2 * time) / sqrt_c2 + sqrt_0 >= PRECISION)
					ft +=0.5 * Math.log((0.5 * c1 + c2 * time) / sqrt_c2 + sqrt_0) / sqrt_c2 * (c0 - 0.25 * c1 * c1 / c2);
				
				f0 = 0.25 * (c1) * sqrt_c0 / c2;
				if ((0.5 * c1) / sqrt_c2 + sqrt_c0 >= PRECISION)
					f0 += 0.5 * Math.log((0.5 * c1) / sqrt_c2 + sqrt_c0) / sqrt_c2 * (c0 - 0.25 * c1 * c1 / c2);
				
				return ft - f0;
			}
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
			const f : Number = 1 - time;
			point.x = start.x * f * f + control.x * 2 * time * f + end.x * time * time;
			point.y = start.y * f * f + control.y * 2 * time * f + end.y * time * time;
			return point;
		}

		/**
		 * 按长度获得线上某点的位置比例
		 * 
		 * @param time	在线上的比例	
		 */
		public function getTimeByDistance(distance : Number) : Number
		{
			if (isNaN(distance))
				return 0;
			
			var arcLength : Number;
			var diffArcLength : Number;
			const curveLength : Number = length;
			var time : Number = distance / curveLength;
			
			if (distance <= 0) 
				return 0;
			
			if (distance >= curveLength)
				return 1;
			
			const csX : Number = control.x - start.x;
			const csY : Number = control.y - start.y;
			const ecX : Number = end.x - control.x;
			const ecY : Number = end.y - control.y;
			const nvX : Number = ecX - csX;
			const nvY : Number = ecY - csY;
	
			// vectors: c0 = 4*(cs,cs), с1 = 8*(cs, ec-cs), c2 = 4*(ec-cs,ec-cs)
			const c0 : Number = 4 * (csX * csX + csY * csY);
			const c1 : Number = 8 * (csX * nvX + csY * nvY);
			const c2 : Number = 4 * (nvX * nvX + nvY * nvY);
			
			const c025 : Number = c0 - 0.25 * c1 * c1 / c2;
			const f0Base : Number = 0.25 * c1 * Math.sqrt(c0) / c2;
			const exp2 : Number = 0.5 * c1 / Math.sqrt(c2) + Math.sqrt(c0);
	
			const c00sqrt : Number = Math.sqrt(c0);
			const c20sqrt : Number = Math.sqrt(c2);
			var c22sqrt : Number;
			
			var exp1 : Number;
			var ft : Number;
			var ftBase : Number;
			
			var f0 : Number;
			const maxIterations : Number = 100;
	
			if (c2 == 0)
			{
				if (c1 == 0)
				{
					do {
						arcLength = c00sqrt * time;
						diffArcLength = Math.sqrt(Math.abs((c2 * time * time + c1 * time + c0))) || PRECISION; 
						time = time - (arcLength - distance) / diffArcLength;
					} while (Math.abs(arcLength - distance) > PRECISION && maxIterations--);
				}
				else
				{
					do {
						arcLength = (2 / 3) * (c1 * time + c0) * Math.sqrt(c1 * time + c0) / c1 - (2 / 3) * c0 * c00sqrt / c1; 
						diffArcLength = Math.sqrt(Math.abs((c2 * time * time + c1 * time + c0))) || PRECISION;
						time = time - (arcLength - distance) / diffArcLength;
					} while (Math.abs(arcLength - distance) > PRECISION && maxIterations--);
				}
			}
			else
			{
				do {
					c22sqrt = Math.sqrt(Math.abs(c2 * time * time + c1 * time + c0));
					exp1 = (0.5 * c1 + c2 * time) / c20sqrt + c22sqrt;
					ftBase = 0.25 * (2 * c2 * time + c1) * c22sqrt / c2;
					if (exp1 < PRECISION)
						ft = ftBase;
					else
						ft = ftBase + 0.5 * Math.log((0.5 * c1 + c2 * time) / c20sqrt + c22sqrt) / c20sqrt * c025;
					
					if (exp2 < PRECISION)
						f0 = f0Base;
					else
						f0 = f0Base + 0.5 * Math.log((0.5 * c1) / c20sqrt + c00sqrt) / c20sqrt * c025;
					
					arcLength = ft - f0;
					diffArcLength = c22sqrt || PRECISION; 
					time = time - (arcLength - distance) / diffArcLength;
				} while (Math.abs(arcLength - distance) > PRECISION && maxIterations--);
			}
			
			return time;
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
			if ((isNaN(x) && isNaN(y))) 
				return;
			
			const f : Number = 1 - time;
			const tSquared : Number = time * time;
			const fSquared : Number = f * f;
			const tf : Number = 2 * time * f;
			
			if (isNaN(x))
				x = start.x * fSquared + control.x * 2 * tf + end.x * tSquared;
			
			if (isNaN(y))
				y = start.y * fSquared + control.y * 2 * tf + end.y * tSquared;
			
			switch (time)
			{
				case 0.0:
					start.x = x;
					start.y = y; 
					break;
				case 1.0:
					end.x = x; 
					end.y = y; 
					break;
				default: 
					control.x = (x - end.x * tSquared - start.x * fSquared) / tf;
					control.y = (y - end.y * tSquared - start.y * fSquared) / tf;
			}
		}


		/**
		 * 平移线
		 * 
		 * @param dx
		 * @param dx
		 * 
		 */
		public function offset(dX : Number = 0, dY : Number = 0) : void
		{
			start.offset(dX, dY);
			control.offset(dX, dY);
			end.offset(dX, dY);
		}
		
		/**
		 * 按比例截取一段曲线
		 */		
		public function getSegment(fromTime : Number = 0, toTime : Number = 1) : Bezier
		{
			const segmentStart : Point = getPoint(fromTime);
			const segmentEnd : Point = getPoint(toTime);
			const segmentVertex : Point = getPoint((fromTime + toTime) / 2);
			const baseMiddle : Point = Point.interpolate(segmentStart, segmentEnd, 1 / 2);
			const segmentControl : Point = Point.interpolate(segmentVertex, baseMiddle, 2);
			return new Bezier(segmentStart, segmentControl, segmentEnd);
		}

		
		/**
		 * 获得某点的切线角度
		 */

		public function getTangentAngle(time : Number = 0) : Number
		{
			const t0X : Number = start.x + (control.x - start.x) * time;
			const t0Y : Number = start.y + (control.y - start.y) * time;
			const t1X : Number = control.x + (end.x - control.x) * time;
			const t1Y : Number = control.y + (end.y - control.y) * time;
			
			const distanceX : Number = t1X - t0X;
			const distanceY : Number = t1Y - t0Y;
			return Math.atan2(distanceY, distanceX);
		}
	}
}


