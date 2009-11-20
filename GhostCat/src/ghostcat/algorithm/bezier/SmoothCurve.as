package ghostcat.algorithm.bezier
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import ghostcat.debug.Debug;
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
		 * 是否过点
		 */
		public var though:Boolean;
		
		/**
		 * 路径点
		 */
		public var path:Array;
		
		/**
		 * 起始点
		 */
		public function get start():Point
		{
			return path[0];
		}

		/**
		 * 结束点
		 */
		public function get end():Point
		{
			return path[path.length - 1];
		}

		/**
		 * 曲线数组 
		 */
		protected var beziers:Array = [];
		
		/**
		 * 创建一条平滑曲线
		 * 
		 * @param startPoint	起始点
		 * @param endPoint	结束点
		 * @param seqNum	中间节点数
		 * 
		 */		
		public function SmoothCurve (though:Boolean = false)
		{
			this.though = though;
		}
		
		/**
		 * 根据起点终点创建并分段
		 *  
		 * @param startPoint
		 * @param endPoint
		 * @param seqNum
		 * 
		 */
		public function createFromSeqNum(startPoint:Point, endPoint:Point, seqNum:int):void
		{
			var path:Array = [];
			path.push(startPoint);
			for (var i:int = 1;i < seqNum - 1;i++)
				path.push(Point.interpolate(startPoint,endPoint,1.0 / (seqNum + 1) * (i + 1)));
			path.push(endPoint);
			
			createFromPath(path);
		}
		
		/**
		 * 从路径创建 
		 * 
		 */
		public function createFromPath(path:Array):void
		{
			this.path = path;
			refresh();
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
				
				for (var i:int = 0; i < beziers.length; i++)
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
		 * 获得起点起经过一定长度的Bezier曲线和余下的曲线长度
		 * 
		 * @param distance
		 * @return 
		 * 
		 */
		public function getBezierByDistance(distance:Number):Array
		{
			if (distance <= 0)
				distance = 0;
			
			var curveLength:Number = length;
			if (distance >= curveLength)
				distance = curveLength;
			
			var distanceFromStart:Number = 0;
			var len:uint = beziers.length;
			
			for (var i:uint = 0; i < len; i++)
			{
				var bezier:Bezier = beziers[i] as Bezier;
				var bezierLength:Number = bezier.length;
				
				if (distanceFromStart + bezierLength >= distance)
					return [bezier,distance - distanceFromStart];
				
				distanceFromStart += bezierLength;
			}
			return null;
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
			var result:Array = getBezierByDistance(distance);
			var bezier:Bezier = result[0];
			var difference:Number = result[1];
			var time:Number = bezier.getTimeByDistance(difference);
			return bezier.getPoint(time); 
		}
		
		/**
		 * 获得起点起经过一定长度的点的切线
		 *  
		 * @param distance	距离
		 * @return 
		 * 
		 */
		public function getTangentAngleByDistance(distance:Number):Number
		{
			var result:Array = getBezierByDistance(distance);
			var bezier:Bezier = result[0];
			var difference:Number = result[1];
			var time:Number = bezier.getTimeByDistance(difference);
			return bezier.getTangentAngle(time); 
		}
		
		/**
		 * 更新曲线。如果不执行此操作，曲线的各个方法就无法得到正确的结果。
		 * <br>会在显示和创建的时候自动更新。
		 * 
		 */
		public function refresh():void
		{
			beziers = [];
			
			var i:int;
			var currentBezier:Bezier;
			var prevBezier:Bezier;
			if (though)
			{
				var p:Point = path[2].subtract(path[0]);
				p.x /= 4;
				p.y /= 4;
				prevBezier = new Bezier(start,path[1].subtract(p),new Point());
				beziers.push(prevBezier);
				for (i = 1; i < path.length - 1; i++)
				{
					currentBezier = new Bezier(prevBezier.end,path[i].add(path[i].subtract(prevBezier.control)),new Point())
					currentBezier.start.x = path[i].x;
					currentBezier.start.y = path[i].y;
					beziers.push(currentBezier);
					prevBezier = currentBezier;
				}
				prevBezier.end = end;
			}
			else
			{
				prevBezier = new Bezier(start,path[1].clone(),new Point());
				beziers.push(prevBezier);
				for (i = 1; i < path.length - 2; i++)
				{
					currentBezier = new Bezier(prevBezier.end,path[i+1].clone(),new Point());
					var mid:Point = Point.interpolate(prevBezier.control, currentBezier.control, 0.5);
					currentBezier.start.x = mid.x; 
					currentBezier.start.y = mid.y;
					beziers.push(currentBezier);
					prevBezier = currentBezier;
				}
				prevBezier.end = end;
			}
		}
		
		/** @inheritDoc*/
		public override function parseGraphics(target:Graphics) : void
		{
			refresh();
			
			super.parseGraphics(target);
			
			target.moveTo(start.x, start.y);
			var len:uint = beziers.length;
			if (len == 0)
			{
				target.lineTo(end.x, end.y);
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