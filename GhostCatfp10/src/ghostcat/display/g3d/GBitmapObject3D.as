package ghostcat.display.g3d
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class GBitmapObject3D extends Sprite
	{
		/**
		 * 贴图
		 */
		public var material:BitmapData;
		
		/**
		 * 转换矩阵 
		 */
		public var matrix3D:Matrix3D;
		
		/**
		 * 显示内部/外部
		 */
		public var culling:String;
		
		/**
		 * 贴图平滑
		 */
		public var smooth:Boolean;
		
		protected var vertsVec:Vector.<Vector.<Vector3D>>;
		protected var nMesh:Number;
		protected var indices:Vector.<int>;
		protected var uvtData:Vector.<Number>;
		
		public function GBitmapObject3D(material:BitmapData)
		{
			this.material = material;
			this.matrix3D = new Matrix3D();
			this.culling = TriangleCulling.POSITIVE;
			
			setVertsVec();
			render();
		}
		
		/**
		 * 创建多边形
		 * 
		 */
		protected function setVertsVec():void
		{

		}
		
		/**
		 * 旋转矩阵并渲染 
		 * @param rotx
		 * @param roty
		 * @param rotz
		 * 
		 */
		public function rotate(rotx:Number,roty:Number,rotz:Number):void
		{
			matrix3D.appendRotation(rotx,Vector3D.X_AXIS);
			matrix3D.appendRotation(roty,Vector3D.Y_AXIS);
			matrix3D.appendRotation(rotz,Vector3D.Z_AXIS);
		}
		
		/**
		 * 重置旋转
		 * 
		 */
		public function reset():void
		{
			matrix3D = new Matrix3D();
		}
		
		/**
		 * 根据矩阵渲染图像 
		 * 
		 */
		public function render():void
		{
			var vertices:Vector.<Number> = new Vector.<Number>();
			for(var i:int = 0;i<nMesh;i++)
			{
				for(var j:int = 0;j<nMesh;j++)
				{
					var curv0:Vector3D = matrix3D.deltaTransformVector(vertsVec[i][j]);
					var curv1:Vector3D = matrix3D.deltaTransformVector(vertsVec[i+1][j]);
					var curv2:Vector3D = matrix3D.deltaTransformVector(vertsVec[i+1][j+1]);
					var curv3:Vector3D = matrix3D.deltaTransformVector(vertsVec[i][j+1]);
					
					vertices.push(curv0.x,curv0.y,curv1.x,curv1.y,curv2.x,curv2.y,curv3.x,curv3.y);
				}
			}
			
			graphics.clear();
			
			if (material)
				graphics.beginBitmapFill(material,null,false,smooth);
			
			graphics.drawTriangles(vertices,indices,uvtData,culling);
			graphics.endFill();
		}
	}
}