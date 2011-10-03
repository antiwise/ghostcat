package ghostcat.game.item
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import ghostcat.display.bitmap.IBitmapDataDrawer;
	import ghostcat.game.item.collision.ICollision;
	import ghostcat.game.item.sort.ISortCalculater;
	import ghostcat.game.layer.camera.ICamera;
	import ghostcat.game.layer.collision.client.ICollisionClient;

	public class BitmapGameItem extends Bitmap implements ICollisionClient,IBitmapDataDrawer
	{
		/**
		 * 设置了摄像机后，会自动调用其refreshItem方法
		 */
		public var camera:ICamera;
		/**
		 * 设置了排序器后，会自动计算排序深度，并赋值给priority
		 */
		public var sortCalculater:ISortCalculater;
		/**
		 * 排序深度 
		 */
		public var priority:Number;
		
		private var _oldX:Number;
		private var _oldY:Number;
		
		private var _x:Number = 0.0;
		private var _y:Number = 0.0;
		private var _rotation:Number = 0.0;
		private var _scaleX:Number = 1.0;
		private var _scaleY:Number = 1.0;
		
		private var _collision:ICollision;
		public function get collision():ICollision
		{
			return _collision;
		}
		
		public var regX:Number = 0.0;
		public var regY:Number = 0.0;
		
		public var rotationCenter:Boolean;
		public var enabledRotation:Boolean;
		
		public override function set x(v:Number):void
		{	
			if (_x == v)
				return;
			
			_oldX = _x;
			_x = v;
			applyRegPosition();
			
			updatePosition();
		}
		
		public override function set y(v:Number):void
		{
			if (_y == v)
				return;
			
			_oldY = _y;
			_y = v;
			applyRegPosition();
			
			updatePosition();
		}
		
		
		public override function get x():Number
		{
			return _x;
		}
		
		public override function get y():Number
		{
			return _y;
		}
		
		public function get $x():Number
		{
			return super.x;
		}
		
		public function get $y():Number
		{
			return super.y;
		}
		
		public function get oldX():Number
		{
			return _oldX;
		}
		
		public function get oldY():Number
		{
			return _oldY;
		}
		
		public override function set rotation(value:Number):void
		{
			_rotation = value;
			applyRegPosition();
		}
		
		public override function get rotation():Number
		{
			return _rotation;
		}
		
		public function set $rotation(value:Number):void
		{
			super.rotation = value;
		}
		
		public override function set scaleX(value:Number):void
		{
			_scaleX = value;
			applyRegPosition();
		}
		
		public override function get scaleX():Number
		{
			return _scaleX;
		}
		
		public override function set scaleY(value:Number):void
		{
			_scaleY = value;
			applyRegPosition();
		}
		
		public override function get scaleY():Number
		{
			return _scaleY;
		}
		
		public function setPosition(x:Number,y:Number,updatePos:Boolean = true):void
		{
			if (_x == x && _y == y)
				return;
			
			_oldX = _x;
			_oldY = _y;
			_x = x;
			_y = y;
			applyRegPosition();
						
			if (updatePos)
				updatePosition();
		}
		
		public function applyRegPosition():void
		{
			if (!enabledRotation)
			{
				super.x = _x - regX;
				super.y = _y - regY;
			}
			else
			{
				var m:Matrix = new Matrix();
				if (rotationCenter)
				{
					var hh:int = height / 2;
					m.translate(-regX,-hh);
					m.scale(_scaleX,_scaleY);
					m.rotate(_rotation / 180 * Math.PI);
					m.translate(_x,_y - regY +hh);
				}
				else
				{
					m.translate(-regX,-regY);
					m.scale(_scaleX,_scaleY);
					m.rotate(_rotation / 180 * Math.PI);
					m.translate(_x,_y);
				}
				super.transform.matrix = m;
			}
		}
		
		protected function updatePosition():void
		{
			if (sortCalculater)
				priority = sortCalculater.calculate();
		
			if (camera)
				camera.refreshItem(this);
		}
		
		public function BitmapGameItem(bitmapData:BitmapData) 
		{
			super(bitmapData);
			updatePosition();
		}
		
		/** @inheritDoc*/
		public function drawToBitmapData(target:BitmapData,offest:Point):void
		{
			if (bitmapData)
				target.copyPixels(bitmapData,bitmapData.rect,new Point(_x - regX + offest.x,_y - regY + offest.y),null,null,bitmapData.transparent);
		}		
		
		/** @inheritDoc*/
		public function getBitmapUnderMouse(mouseX:Number,mouseY:Number):Array
		{
			return (uint(bitmapData.getPixel32(mouseX - x - regX,mouseY - y - regY) >> 24) > 0) ? [this] : null;
		}
	}
}