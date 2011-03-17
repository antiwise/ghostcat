package ghostcat.game.layer.camera
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import ghostcat.game.layer.GameLayerBase;
	
	public class SimpleCamera implements ICamera
	{
		public var layer:GameLayerBase;
		public var position:Point;
		
		public function SimpleCamera(layer:GameLayerBase)
		{
			this.layer = layer;
			this.position = new Point();
		}
		
		public function render():void
		{
			this.layer.x = -position.x;
			this.layer.y = -position.y;
		}
		
		public function refreshItem(item:DisplayObject):void
		{
		}
	}
}