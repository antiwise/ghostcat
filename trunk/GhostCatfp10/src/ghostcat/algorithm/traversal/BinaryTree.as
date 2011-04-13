package ghostcat.algorithm.traversal
{
	/**
	 * 顺序结构2叉树
	 * 
	 * （首位空出，左子树：i*2，右子树：i*2+1，父节点：i/2）
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class BinaryTree
	{
		private var data:Array;
		
		public function BinaryTree()
		{
			clear();
		}
		
		public function getRootIndex():int
		{
			return 1;
		}
		
		public function getValue(index:int):*
		{
			return index < data.length ? data[index] : null; 
		}
		
		public function setValue(index:int,v:*):void
		{
			data[index] = v;
		}
		
		public function indexOf(v:*):int
		{
			return data.indexOf(v);
		}
		
		public function clear():void
		{
			data = [null];
		}
		
		public function getLeftChildIndex(index:int):int
		{
			return index << 1;
		}
		
		public function getRightChildIndex(index:int):int
		{
			return (index << 1) + 1;
		}
		
		public function getParentIndex(index:int):int
		{
			return index >> 1;
		}
		
		public function getLeftChild(index:int):*
		{
			var n:int = index << 1;
			return n < data.length ? data[n] : null; 
		}
		
		public function getRightChild(index:int):*
		{
			var n:int = (index << 1) + 1;
			return n < data.length ? data[n] : null; 
		}
		
		public function getParent(index:int):*
		{
			var n:int = index >> 1;
			return n < data.length ? data[n] : null; 
		}
		
		public function setLeftChild(index:int,v:*):int
		{
			var n:int = index << 1;
			data[n] = v;
			return n;
		}
		
		public function setRightChild(index:int,v:*):int
		{
			var n:int = (index << 1) + 1;
			data[n] = v;
			return n;
		}
		
		public function setParent(index:int,v:*):int
		{
			var n:int = index >> 1;
			data[n] = v;
			return n;
		}
		
		public function getDeep(index:int):int
		{
			return Math.log(index) / Math.LN2;
		}
		
		private function getArraySub(index:int):Array
		{
			if (index >= data.length || !data[index])
				return null;
			
			return [data[index],[getArraySub(index << 1),getArraySub((index << 1) + 1)]];
		}
		
		public function toArray():Array
		{
			return getArraySub(1);
		}
		
		private function getArrayString(index:int):String
		{
			if (index >= data.length || !data[index])
				return null;
			
			return "["+data[index]+","+getArrayString(index << 1)+","+getArrayString((index << 1) + 1)+"]";
		}
		
		public function toString():String
		{
			return getArrayString(1);
		}
	}
}