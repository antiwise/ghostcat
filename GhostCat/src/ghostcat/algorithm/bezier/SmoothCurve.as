package ghostcat.algorithm.bezier
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import ghostcat.parse.DisplayParse;

	/**
	 * 由多点连接成的平滑曲线
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class SmoothCurve extends DisplayParse
	{
		/**
		 * 曲线段数组
		 */
		public var beziers:Array = [];
		
		private var _start:Point;

		/**
		 * 起始点
		 */
		public function get start():Point
		{
			return _start;
		}

		private var _end:Point;

		/**
		 * 结束点
		 */
		public function get end():Point
		{
			return _end;
		}

		
		/**
		 * 创建一条平滑曲线
		 * 
		 * @param startPoint	起始点
		 * @param endPoint	结束点
		 * @param seqNum	中间节点数
		 * 
		 */		
		public function SmoothCurve (startPoint:Point=null, endPoint:Point=null, seqNum:int = 0)
		{
			this._start = startPoint;
			this._end = endPoint;
			
			for (var i:int = seqNum - 1;i >= 0;i--)
				insert(Point.interpolate(startPoint,endPoint,1.0/(seqNum+1)*(i+1)))
		}
		
		/**
		 * 在末尾之前插入控制点（控制点不能是尾节点）
		 * 
		 * @param flashyiyi
		 * 
		 */
		public function insert(control:Point):void
		{
			var newBezier:Bezier;
			if (beziers.length > 0)
			{
				var lastBezier:Bezier = beziers[beziers.length - 1];
				lastBezier.end = new Point();
				newBezier = new Bezier(lastBezier.end, control, _end);
			}
			else
				newBezier = new Bezier(_start, control, _end);
			
			beziers.push(newBezier);
		}
		
		/**
		 * 修改节点的控制点，更改曲线形态
		 * 
		 * @param index
		 * @param x
		 * @param y
		 * 
		 */
		public function modifyControl(index:int,x:Number = NaN,y:Number = NaN):void
		{
			var bezier:Bezier = beziers[index];
			
			if (!isNaN(x))
				bezier.control.x = x;
		
			if (!isNaN(y))
				bezier.control.y = y;
		}
		
		/**
		 * 获得总长度
		 * 
		 * @return 
		 * 
		 */
		public function get length():Number
		{
			var len:Number;
			if (beziers.length > 0)
			{
				var curveLength:Number = 0;
				
				for (var i:uint=0; i < beziers.length; i++)
				{
					var bezier:Bezier = beziers[i];
					curveLength += bezier.length;
				}
				len = curveLength;
			}
			else
			{
				len = Point.distance(start, end);
			}
			return len;
		}
		
		/**
		 * 获得起点起经过一定长度的终点
		 *  
		 * @param distance	距离
		 * @return 
		 * 
		 */
		public function getPointByDistance(distance:Number):Point
		{
			if (distance <= 0)
				return _start.clone();
			
			var curveLength:Number = length;
			if (distance >= curveLength)
				return _end.clone();
			
			var distanceFromStart:Number=0;
			var len:uint = beziers.length;
			
			for (var i:uint = 0; i < len; i++)
			{
				var bezier:Bezier = beziers[i] as Bezier;
				var bezierLength:Number = bezier.length;
				
				if (distanceFromStart + bezierLength > distance)
				{
					var difference:Number = distance - distanceFromStart;
					var time:Number = bezier.getTimeByDistance(difference);
					var position:Point = bezier.getPoint(time); 
					return position;
				}
				distanceFromStart += bezierLength;
			}
			return null;
		}
		
		/**
		 * 更新曲线
		 * 
		 */
		public function refresh():void
		{
			var len:uint = beziers.length;
			if (!len)
				return;
			
			var prevBezier:Bezier = beziers[0] as Bezier;
			var currentBezier:Bezier;
			
			for (var i:uint=1; i<len; i++)
			{
				currentBezier = beziers[i];
				var mid:Point = Point.interpolate(prevBezier.control, currentBezier.control, 0.5);
				currentBezier.start.x = mid.x; 
				currentBezier.start.y = mid.y;
				prevBezier = currentBezier;
			}
		}
		/** @inheritDoc*/
		public override function parseGraphics(target:Graphics) : void
		{
			refresh();
			
			super.parseGraphics(target);
			
			target.moveTo(_start.x, _start.y);
			var len:uint = beziers.length;
			if (len == 0)
			{
				target.lineTo(_end.x, _end.y);
				return;
			}
			var bezier:Bezier = beziers[0] as Bezier;
			target.moveTo(bezier.start.x, bezier.start.y);
			target.curveTo(bezier.control.x, bezier.control.y, bezier.end.x, bezier.end.y);
			for (var i:int=1; i < len; i++)
			{
				bezier = beziers[i] as Bezier;
				target.curveTo(bezier.control.x, bezier.control.y, bezier.end.x, bezier.end.y);
			}
		}
		
	}
}




