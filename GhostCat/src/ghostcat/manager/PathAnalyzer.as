package ghostcat.manager
{
	import flash.geom.Point;

	/**
	 * 鼠标手势解析类（用于配合InputManager）
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class PathAnalyzer
	{
		public static const UP:int = -1;
		public static const DOWN:int = 1;
		public static const LEFT:int = 2;
		public static const RIGHT:int = 0;
		
		private var directs:Array;
		private var lengths:Array;
		
		public function PathAnalyzer(source:Array)
		{
			this.source = source;
		}
		
		/**
		 * 解析源路径
		 * 
		 * @param v
		 * 
		 */
		public function set source(v:Array):void
		{
			getPathDirect(v);
		}
		
		/**
		 * 获得计算出的鼠标方向
		 * 0 右 1 下 2 左 -1 上
		 * 
		 * @return 
		 * 
		 */
		public function getDirects():Array
		{
			return directs.slice();
		}
		
		/**
		 * 获得计算出的每段路径的长度
		 * @return 
		 * 
		 */
		public function getLengths():Array
		{
			return lengths.slice();
		}
		
		
		/*根据鼠标路径判断路径方向*/
		private function getPathDirect(source:Array):void
		{
			var pre:Point;
			var sub:Point;
			var r:int;
			var i:int;
			
			if (source.length < 2) 
			{
				directs = [];
				lengths = [];
				return;
			}
			
			pre = source[0] as Point;
			for (i = 1;i< source.length;i++)
			{
				var now:Point = source[i] as Point;
				sub = now.subtract(pre);
				pre = now;
				r = Math.round(Math.atan2(sub.y,sub.x)/(Math.PI/2));
				if (r == -2)
					r = 2;
				
				if (directs.length > 0 && directs[directs.length - 1] == r)
					lengths[lengths.length - 1] += sub.length;
				else
				{
					directs.push(r);
					lengths.push(sub.length);
				}
			}
			//去掉过短的路径
			for (i = directs.length - 1;i >= 0;i--)
			{
				if (lengths[i] < 20)
				{
					directs.splice(i,1);
					lengths.splice(i,1);
				}
			}	
		}
		
		/**
		 * 判断是否是向右划（一般用于前进指令）
		 *  
		 * @param source
		 * @return 
		 * 
		 */
		public function isRight():Boolean
		{
			return (directs.length == 1 && directs[0] == RIGHT)
		}
		
		/**
		 * 判断是否是向左划（一般用于后退指令）
		 * 
		 * @param source
		 * @return 
		 * 
		 */
		public function isLeft():Boolean
		{
			return (directs.length == 1 && directs[0] == LEFT)
		}
		
		/**
		 * 判断是否是向下-向右划（一般用于关闭指令）
		 * 
		 * @param source
		 * @return 
		 * 
		 */
		public function isDownRight():Boolean
		{
			return (directs.length == 2 && directs[0] == DOWN && directs[1] == RIGHT)
		}
		
		/**
		 * 判断是否是向上-向下划（一般用于刷新指令）
		 * 
		 * @param source
		 * @return 
		 * 
		 */
		public function isUpDown():Boolean
		{
			return (directs.length == 2 && directs[0] == UP && directs[1] == DOWN)
		}
		
		/**
		 * 判断是否是逆时针圈
		 * 
		 * @param source
		 * @return 
		 * 
		 */	
		public function isCountClockwise():Boolean
		{
			if (directs.length < 4)
				return false;
			
			for (var i:int=1;i<directs.length;i++)
			{
				if (directs[i-1] == UP)
				{
					if (directs[i] != LEFT)
						return false;
				}
				else if (directs[i] - directs[i-1] != -1)
					return false;
			}
			return true;
		}
		/**
		 * 判断是否是顺时针圈
		 * 
		 * @param source
		 * @return 
		 * 
		 */		
		public function isClockwise():Boolean
		{
			if (directs.length < 4)
				return false;
			
			for (var i:int=1;i<directs.length;i++)
			{
				if (directs[i-1] == LEFT)
				{
					if (directs[i] != UP)
						return false;
				}
				else if (directs[i] - directs[i-1] != 1)
					return false;
			}
			return true;
		}
	}
}