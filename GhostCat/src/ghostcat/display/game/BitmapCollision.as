package ghostcat.display.game
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class BitmapCollision extends EventDispatcher
	{
		public var x:int = 0;
		public var y:int = 0;
		public var width:int;
		public var height:int;
		
		public var hP:Array;
		public function BitmapCollision(bmd:BitmapData)
		{
			if (bmd)
				createFromBitmapData(bmd);
		}
		
		public function createFromBitmapData(bmd:BitmapData):void
		{
			var i:int;
			var j:int;
			var start:int;
			
			this.width = bmd.width;
			this.height = bmd.height;
			
			hP = new Array(height);
			
			for (j = 0;j < height;j++)
			{
				i = 0;
				var p:Array = [];
				while (i < width)
				{
					while (bmd.getPixel32(i,j) == 0 && i < width)
						i++;
					
					if (i == width)
						break;
					
					p[p.length] = i;
					
					while (bmd.getPixel32(i,j) > 0 && i < width)
						i++;
					p[p.length] = i;
				}
				hP[j] = p;
			}
		}
		
		public function hitTestPoint(x:int,y:int):Boolean
		{
			var dx:int = x - this.x;
			var dy:int = y - this.y;
			if (dx < 0 || dx >= width || dy < 0 || dy >= height)
				return false;
			
			var ps:Array = hP[y];
			var l:int = ps.length;
			for (var i:int = 0;i < l; i += 2)
			{
				if (ps[i] < x && x < ps[i + 1])
					return true;
			}
			return false;
		}
		
		public function hitTestObject(obj:BitmapCollision):Boolean
		{
			var l:int = hP.length;
			for (var i:int = 0;i < l; i++)
			{
				var p1:Array = hP[i];
				var i2:int = i + y - obj.y;
				if (i2 >= 0 && i2 < obj.height)
				{
					var p2:Array = obj.hP[i2];
					if (p1.length && p2.length)
					{
						var a1:int = p1[0];
						var a2:int = p1[1];
						var dx:int = obj.x - x;
						var b1:int = p2[0] + dx;
						var b2:int = p2[1] + dx;
						if (!(a2 < b1 || b2 < a1))
							return true;
					}
				}
			}
			return false;
		}
		
	}
}