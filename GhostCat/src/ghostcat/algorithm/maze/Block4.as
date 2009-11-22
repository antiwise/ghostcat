package ghostcat.algorithm.maze
{
	/**
	 * 保存与四周格子的阻碍关系
	 * @author flashyiyi
	 * 
	 */
	public class Block4
	{
		public var value:uint = 0;
		public function Block4(left:Boolean,right:Boolean,top:Boolean,bottom:Boolean)
		{
			this.left = left;
			this.right = right;
			this.top = top;
			this.bottom = bottom;
		}
		
		public function get left():Boolean
		{
			return (value | 1) == value;
		}
		
		public function set left(v:Boolean):void
		{
			if (v)
				value = value | 1;
			else 
				value = value & ~1;
		}
		
		public function get right():Boolean
		{
			return (value | (1 << 2)) == value;
		}
		
		public function set right(v:Boolean):void
		{
			if (v)
				value = value | (1 << 2);
			else 
				value = value & ~(1 << 2);
		}
		
		public function get top():Boolean
		{
			return (value | (1 << 3)) == value;
		}
		
		public function set top(v:Boolean):void
		{
			if (v)
				value = value | (1 << 3);
			else 
				value = value & ~(1 << 3);
		}

		public function get bottom():Boolean
		{
			return (value | (1 << 4)) == value;
		}

		public function set bottom(v:Boolean):void
		{
			if (v)
				value = value | (1 << 4);
			else 
				value = value & ~(1 << 4);
		}
		
		public function toString():String
		{
			return [left,right,top,bottom].toString();
		}

	}
}