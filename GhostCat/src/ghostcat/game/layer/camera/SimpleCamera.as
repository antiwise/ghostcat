package ghostcat.game.layer.camera
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.game.layer.GameLayer;
	
	public class SimpleCamera implements ICamera
	{
		public var layer:GameLayer;
		
		/**
		 * 当前左上角坐标 
		 */
		public var position:Point;
		
		/**
		 * 追踪目标
		 */
		public var target:*;
		
		/**
		 * 屏幕大小 
		 */
		public var screenRect:Rectangle;
		
		/**
		 * 场景大小 
		 */
		public var rect:Rectangle;
		
		public function SimpleCamera(layer:GameLayer,screenRect:Rectangle = null,rect:Rectangle = null)
		{
			this.layer = layer;
			this.position = new Point();
			this.screenRect = screenRect;
			this.rect = rect;
		}
		
		public function render():void
		{
			if (target)
				updateTargetPosition();
			
			this.layer.x = -this.position.x;
			this.layer.y = -this.position.y;
		}
		
		public function updateTargetPosition():void
		{
			var x:Number = target.x;
			var y:Number = target.y;
			if (screenRect)
			{
				x -= screenRect.width / 2;
				y -= screenRect.height / 2;
			}
			if (rect)
			{
				var w:Number = rect.right - screenRect.width;
				var h:Number = rect.bottom - screenRect.height;
				x = x < rect.x ? rect.x : x > w ? w : x;
				y = y < rect.y ? rect.y : y > h ? h : y;
			}
			this.setPosition(x,y);
		}
		
		public function setPosition(x:Number,y:Number):void
		{
			this.position.x = x;
			this.position.y = y;
		}
		
		public function refreshItem(item:DisplayObject):void
		{
			//
		}
	}
}