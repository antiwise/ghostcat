package ghostcat.parse.graphics
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import ghostcat.parse.DisplayParse;

	/**
	 * 绘制三角形 
	 * @author flashyiyi
	 * 
	 */
	public class GraphicsTriangles extends DisplayParse
	{
		/**
		 * 点坐标（2个一组为一个点） 
		 */
		public var vertices:Vector.<Number>;
		/**
		 * 组成三角形的点的序号（3个一组） 
		 */
		public var indices:Vector.<int>;
		/**
		 * 贴图源的坐标（3x2或者3x3，前者是组成三角形，后者点会增加一个权重值） 
		 */
		public var uvtData:Vector.<Number>;
		/**
		 * 贴图模式（none：双面，negative：正面，positive：反面） 
		 */
		public var culling:String;
		
		public function GraphicsTriangles(indices:Vector.<int>, vertices:Vector.<Number> = null, uvtData:Vector.<Number> = null,culling:String = "none")
		{
			this.vertices = vertices;
			this.indices = indices;
			this.uvtData = uvtData;
		
			this.culling = culling;
		}
		/** @inheritDoc*/
		public override function parseGraphics(target:Graphics) : void
		{
			super.parseGraphics(target);
			target.drawTriangles(vertices,indices,uvtData,culling);
		}
		
		/**
		 * 增加一个点
		 * @param x
		 * @param y
		 * 
		 */
		public function addPoint(x:Number,y:Number):void
		{
			if (!vertices)
				vertices = new Vector.<Number>();
			
			vertices.push(x,y);
		}
		
		/**
		 * 增加一个三角形
		 * 
		 * @param p1	第一个点的序号
		 * @param p2	第二个点的序号
		 * @param p3	第三个点的序号
		 * （序号是点在数组里的顺序号)
		 * @param uvt1	第一个点的贴图对应位置
		 * @param uvt2	第二个点的贴图对应位置
		 * @param uvt3	第三个点的贴图对应位置
		 * (贴图位置是一个数组，x,y都是占图像高宽的百分比而不是像素值）
		 * 
		 */
		public function addTriangle(p1:int,p2:int,p3:int,uvt1:Array,uvt2:Array,uvt3:Array):void
		{
			if (!indices)
				indices = new Vector.<int>();
			
			if (!uvtData)
				uvtData = new Vector.<Number>();
			
			indices.push(p1,p2,p3);
			uvtData.push.apply(null,uvt1);
			uvtData.push.apply(null,uvt2);
			uvtData.push.apply(null,uvt3);
		}
	}
}