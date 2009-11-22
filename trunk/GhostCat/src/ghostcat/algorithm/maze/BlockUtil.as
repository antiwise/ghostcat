package ghostcat.algorithm.maze
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;

	/**
	 * 地图阻碍辅助类 
	 * @author flashyiyi
	 * 
	 */
	public final class BlockUtil
	{
		/**
		 * 从阻碍对象数组转换为布尔数组 
		 * @param source
		 * @return 
		 * 
		 */
		public static function blockToBoolMap(source:Array):Array
		{
			var i:int;
			var j:int;
			var il:int;
			var jl:int;
			var r:Array = [];
			jl = source.length;
			
			for (j = 0;j < jl * 2 + 1;j++)
				r.push([]);
			
			for (j = 0;j < jl;j++)
			{
				il = source[j].length;
				for (i = 0;i < il;i++)
				{
					var block:Block4 = source[j][i];
					r[j*2][i*2] = r[j*2][i*2] || block.top || block.left;//左上
					r[j*2][i*2+1] = block.top;//上
					r[j*2][i*2+2] = block.top || block.right;//右上
					r[j*2+1][i*2] = r[j*2+1][i*2] || block.left;//左
					r[j*2+1][i*2+1] = false;//中
					r[j*2+1][i*2+2] = r[j*2+1][i*2+2] || block.right;//右
					r[j*2+2][i*2] = r[j*2+2][i*2] || block.bottom || block.left;//左下
					r[j*2+2][i*2+1] = block.bottom;//下
					r[j*2+2][i*2+2] =r[j*2+2][i*2+2] ||  block.right || block.bottom;//右下
				}
			}
			return r;
		};
		
		/**
		 * 显示阻碍对象为图形
		 * @param source
		 * @param space
		 * @return 
		 * 
		 */
		public static function blockMapToShape(source:Array,space:Number = 10):Shape
		{
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(0);
			for (var j:int = 0;j < source.length;j++)
			{
				for (var i:int = 0;i < source[j].length;i++)
				{
					var item:Block4 = source[j][i];
					if (item.left)
					{
						shape.graphics.moveTo(i * space,j * space);
						shape.graphics.lineTo(i * space,(j + 1) * space);
					}
					if (item.right)
					{
						shape.graphics.moveTo((i + 1) * space,j * space);
						shape.graphics.lineTo((i + 1) * space,(j + 1) * space);
					}
					if (item.top)
					{
						shape.graphics.moveTo(i * space,j * space);
						shape.graphics.lineTo((i + 1) * space,j * space);
					}
					if (item.bottom)
					{
						shape.graphics.moveTo(i * space,(j + 1) * space);
						shape.graphics.lineTo((i + 1) * space,(j + 1) * space);
					}
				}
			}
			return shape;
		}
		
		/**
		 * 显示布尔对象数组为位图
		 * @param source
		 * @return 
		 * 
		 */
		public static function boolMapToBitmap(source:Array):Bitmap
		{
			var bitmap:Bitmap =  new Bitmap(new BitmapData(source[0].length,source.length))
			for (var j:int = 0;j < source.length;j++)
			{
				for (var i:int = 0;i < source[j].length;i++)
				{
					if (source[j][i])
						bitmap.bitmapData.setPixel(i,j,0x0);
				}
			}
			return bitmap;
		}
		
		/**
		 * 创建阻碍地图
		 * @param width
		 * @param height
		 * @return 
		 * 
		 */
		public static function createBlockMap(width:int,height:int,hasWall:Boolean = false):Array
		{
			var r:Array = [];
			for (var j:int = 0;j < height;j++)
			{
				r.push([]);
				for (var i:int = 0;i < width;i++)
				{
					if (hasWall)
						r[j][i] = new Block4(i == 0,i == width - 1,j == 0,j == height - 1);
					else
						r[j][i] = new Block4(false,false,false,false);
				}
			}
			return r;
		}
		
		/**
		 * 创建数组地图 
		 * @param width
		 * @param height
		 * @return 
		 * 
		 */
		public static function createBoolMap(width:int,height:int,hasWall:Boolean = false):Array
		{
			var r:Array = [];
			for (var j:int = 0;j < height * 2 + 1;j++)
			{
				r.push([]);
				for (var i:int = 0;i < width * 2 + 1;i++)
				{
					if (hasWall)
						r[j][i] = (i == 0 || i == width * 2 || j == 0 || j == height * 2);
					else
						r[j][i] = false;
				}
			}
			return r;
		}
	}
}