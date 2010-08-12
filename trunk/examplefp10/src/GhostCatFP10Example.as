package 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	
	import ghostcat.display.g3d.GBitmapSphere;
	

	[SWF(width="500",height="500",backgroundColor="0")]
	public class GhostCatFP10Example extends Sprite
	{
		public var sphere:GBitmapSphere;
		
		public function GhostCatFP10Example()
		{
			addEventListener(Event.ADDED_TO_STAGE,initHandler);
		}
		
		private function initHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,initHandler);	
			
			sphere = new GBitmapSphere(null,500);
			sphere.culling = TriangleCulling.NEGATIVE;
			sphere.x = 250;
			sphere.y = 250;
			
			addChild(sphere);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.load(new URLRequest("1.jpg"));
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			sphere.material = ((event.currentTarget as LoaderInfo).content as Bitmap).bitmapData;
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			var sw:Number = stage.stageWidth;
			var sh:Number = stage.stageHeight;
			
			var m:Matrix3D = new Matrix3D();
			m.appendRotation((stage.mouseX - sw / 2) / sw * 360,Vector3D.Y_AXIS);
			m.appendRotation(-(stage.mouseY - sh / 2) / sw * 180,Vector3D.X_AXIS);
			
			sphere.matrix3D = m;
			sphere.render();
		}
	}
}