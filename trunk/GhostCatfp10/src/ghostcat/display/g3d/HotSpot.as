package ghostcat.display.g3d
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	/**
	 * 热点 
	 * @author Administrator
	 * 
	 */
	public class HotSpot
	{
		public var panoramic:Panoramic;
		public var point:Point;
		public var vector:Vector3D;
		public var userObject:DisplayObject;
		public function HotSpot(panoramic:Panoramic,point:Point,userObject:DisplayObject = null)
		{
			this.panoramic = panoramic;
			this.point = point;
			this.userObject = userObject;
		
			this.caluteVector();
		}
		
		/**
		 * 计算贴图坐标对应的3D位置 
		 * 
		 */
		public function caluteVector():void
		{
			var w:Number = Math.PI * 2 * point.x / panoramic.material.width;
			var h:Number = Math.PI * point.y / panoramic.material.height;
			var r:Number = panoramic.radius;
			
			this.vector = new Vector3D(r * Math.sin(w) * Math.sin(h),-r * Math.cos(h),-r * Math.cos(w) * Math.sin(h));
		}
		
		/**
		 * 取得屏幕上的点 
		 * @return 
		 * 
		 */
		public function getScreenPoint():Vector3D
		{
			return panoramic.matrix3D.deltaTransformVector(vector);
		}
		
		/**
		 * 同步图形 
		 * 
		 */
		public function render():void
		{
			if (!userObject)
				return;
			
			var v:Vector3D = getScreenPoint();
			if (v.z < 0)
			{
				userObject.visible = true;
				
				var p:Point = panoramic.localToGlobal(new Point(v.x,v.y));
				if (userObject.parent)
					p = userObject.parent.globalToLocal(p);
				
				userObject.x = p.x;
				userObject.y = p.y;
			}
			else
			{
				userObject.visible = false;
			}
		}
	}
}