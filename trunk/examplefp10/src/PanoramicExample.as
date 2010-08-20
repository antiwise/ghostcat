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
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import ghostcat.display.g3d.GBitmapSphere;
	import ghostcat.display.g3d.Panoramic;
	

	[SWF(width="750",height="500",backgroundColor="0")]
	public class PanoramicExample extends Sprite
	{
		public var sphere:Panoramic;
		
		public function PanoramicExample()
		{
			sphere = new Panoramic(null,500);
			sphere.x = 375;
			sphere.y = 250;
			
			addChild(sphere);
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.load(new URLRequest("1.jpg"));
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			sphere.material = ((event.currentTarget as LoaderInfo).content as Bitmap).bitmapData;
			
			var p:Point = new Point(0,0);
			sphere.addHotSpot(p,createPot(p.toString()));
			p = new Point(0,1000);
			sphere.addHotSpot(p,createPot(p.toString()));
			p = new Point(200,1000);
			sphere.addHotSpot(p,createPot(p.toString()));
			
			sphere.render();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
		}
		
		private function createPot(s:String):Sprite
		{
			var p:Sprite = new Sprite();
			p.graphics.beginFill(0xFF0000);
			p.graphics.drawCircle(0,0,5);
			p.graphics.endFill();
			
			var t:TextField = new TextField();
			t.defaultTextFormat = new TextFormat(null,null,0xFF0000);
			t.text = s;
			p.addChild(t);
			
			addChild(p);
			return p;
		}
		
		private function mouseMoveHandler(event:MouseEvent):void
		{
			var sw:Number = stage.stageWidth;
			var sh:Number = stage.stageHeight;
			sphere.reset();
			sphere.rotate(0,(stage.mouseX - sw / 2) / sw * 360,0);
			sphere.rotate(-(stage.mouseY - sh / 2) / sh * 180,0,0);
			sphere.render();
			
			event.updateAfterEvent();
		}
	}
}