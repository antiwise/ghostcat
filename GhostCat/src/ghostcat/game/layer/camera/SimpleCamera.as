package ghostcat.game.layer.camera
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import ghostcat.game.layer.GameLayer;
	
	public class SimpleCamera implements ICamera
	{
		public var layer:GameLayer;
		public var position:Point;
		
		public function SimpleCamera(layer:GameLayer)
		{
			this.layer = layer;
			this.position = new Point();
		}
		
		public function render():void
		{
			this.layer.x = -this.position.x;
			this.layer.y = -this.position.y;
		}
		
		public function setPosition(x:Number,y:Number):void
		{
			this.position.x = x;
			this.position.y = y;
		}
		
		public function refreshItem(item:DisplayObject):void
		{
		}
	}
}