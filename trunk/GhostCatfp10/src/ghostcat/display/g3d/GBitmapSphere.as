package ghostcat.display.g3d
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * 位图贴图球体
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class GBitmapSphere extends Sprite
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
		 * 半径
		 */
		public var radius:Number;
		
		/**
		 * 显示内部/外部
		 */
		public var culling:String;
		
		/**
		 * 贴图平滑
		 */
		public var smooth:Boolean;
		
		protected var nMesh:int;
		protected var mMesh:int;
		
		protected var vertices:Vector.<Vector.<Vector3D>>;
		protected var indices:Vector.<int>;
		protected var uvtData:Vector.<Number>;
		
		public function GBitmapSphere(material:BitmapData,radius:Number = 100, nMesh:int = 30, mMesh:int = 30)
		{
			this.material = material;
			this.radius = radius;
			this.nMesh = nMesh;
			this.mMesh = mMesh;
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
			var i:int;
			var j:int;
			var istep:Number;
			var jstep:Number;
			
			istep=2*Math.PI/nMesh;
			jstep=Math.PI/nMesh;
			
			this.vertices=new Vector.<Vector.<Vector3D>>();
			
			for(i=0;i<=nMesh;i++)
			{
				var vector:Vector.<Vector3D> = new Vector.<Vector3D>();
				for(j=0;j<=nMesh;j++)
				{
					vector[j]=new Vector3D(radius*Math.sin(istep*i)*Math.sin(jstep*j),-radius*Math.cos(jstep*j),-radius*Math.cos(istep*i)*Math.sin(jstep*j));
				}
			
				vertices[i] = vector;
			}
			
			indices = new Vector.<int>();
			uvtData = new Vector.<Number>();
			
			var curVertsNum:int=0;
			for(i=0;i<nMesh;i++)
			{
				for(j=0;j<nMesh;j++)
				{
					indices.push(curVertsNum,curVertsNum+1,curVertsNum+3,curVertsNum+1,curVertsNum+2,curVertsNum+3);
					uvtData.push(i/nMesh,j/nMesh,(i+1)/nMesh,j/nMesh,(i+1)/nMesh,(j+1)/nMesh,i/nMesh,(j+1)/nMesh);
					curVertsNum += 4;
				}
			}
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
			var transformVertices:Vector.<Number> = new Vector.<Number>();
			for(var i:int = 0;i<nMesh;i++)
			{
				for(var j:int = 0;j<nMesh;j++)
				{
					var curv0:Vector3D = matrix3D.deltaTransformVector(vertices[i][j]);
					var curv1:Vector3D = matrix3D.deltaTransformVector(vertices[i+1][j]);
					var curv2:Vector3D = matrix3D.deltaTransformVector(vertices[i+1][j+1]);
					var curv3:Vector3D = matrix3D.deltaTransformVector(vertices[i][j+1]);
					
					transformVertices.push(curv0.x,curv0.y,curv1.x,curv1.y,curv2.x,curv2.y,curv3.x,curv3.y);
				}
			}
			
			graphics.clear();
			
			if (material)
				graphics.beginBitmapFill(material,null,false,smooth);
			
			graphics.drawTriangles(transformVertices,indices,uvtData,culling);
			graphics.endFill();
		}
	}
}