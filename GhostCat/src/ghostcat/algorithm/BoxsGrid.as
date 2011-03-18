package ghostcat.algorithm
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import ghostcat.util.Util;

	public class BoxsGrid
	{
		public var rect:Rectangle;
		public var boxWidth:Number;
		public var boxHeight:Number;
		
		protected var dict:Dictionary;
		protected var boxs:Array;
		
		private var w:int;
		private var h:int;
		
		public function BoxsGrid(rect:Rectangle,boxWidth:Number,boxHeight:Number):void
		{
			this.rect = rect;
			this.boxWidth = boxWidth;
			this.boxHeight = boxHeight;
			
			this.dict = new Dictionary(true);
			this.boxs = [];
			
			this.w = Math.ceil(rect.width / boxWidth);
			this.h = Math.ceil(rect.height / boxHeight);
			
			var l:int = w * h;
			for (var i:int = 0;i < l;i++)
				this.boxs[i] = [];
		}
		
		public function isIn(item:DisplayObject):Array
		{
			var x:int = int((item.x - rect.x) / boxWidth);
			var y:int = int((item.y - rect.y) / boxHeight);
			x = x < 0 ? 0 : x > w ? w : x;
			y = y < 0 ? 0 : y > h ? h : y;
			return boxs[y * w + x];
		}
		
		public function add(item:DisplayObject):void
		{
			var box:Array = isIn(item);
			box[box.length] = item;
			
			this.dict[item] = box;
		}
		
		public function remove(item:DisplayObject):void
		{
			var list:Array = this.dict[item];
			if (list)
			{
				var index:int = list.indexOf(item);
				if (index != -1)
					list.splice(index,1);
			}
		}
		
		public function reinsert(item:DisplayObject):void
		{
			var list:Array = isIn(item);
			var oldlist:Array = this.dict[item];
			if (list != oldlist)
			{
				var index:int = oldlist.indexOf(item);
				if (index != -1)
					oldlist.splice(index,1);
			
				list.push(item);
				this.dict[item] = list;
			}
		}
		
		/**
		 * 获得一个范围内的所有数据
		 * 
		 * @param rect
		 * 
		 */
		public function getDataInRect(p:Rectangle):Array
		{
			var x:int = int((p.x - rect.x) / boxWidth);
			var y:int = int((p.y - rect.y) / boxHeight);
			var l:int = y * w + x;
			var il:int = Math.ceil(p.width / boxWidth);
			var jl:int = Math.ceil(p.height / boxHeight);
			var result:Array = [];
			for (var j:int = 0;j < jl;j++)
			{
				for (var i:int = 0;i < il;i++)
				{
					result.push.apply(null,boxs[(y + j) * w + x + i]);
				}
			}
			return result;	
		}
	}
}