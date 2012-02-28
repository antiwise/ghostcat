package ghostcat.display.particle
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class StarCreater extends ParticleCreaterBase
	{
		public var bitmapData:BitmapData;
		public var speed:int;
		public var flash:int;
		public var density:Number;
		public var screenOffest:Number = 100;
		public function StarCreater(contentWidth:Number, contentHeight:Number,speed:int = 100,flash:int = 1000,density:Number = 0.1)
		{
			this.speed = speed;
			this.density = density;
			this.flash = flash;
			
			super(contentWidth, contentHeight);
			
			createBitmapData();
		}
		
		protected function createBitmapData():void
		{
			var shape:Shape = new Shape();
			
			var m:Matrix = new Matrix();
			m.createGradientBox(8,8);
			shape.graphics.beginGradientFill(GradientType.RADIAL,[0xFFFFFF,0xFFFFFF],[0.2,0.0],[0,255],m);
			shape.graphics.drawCircle(4,4,4);
			shape.graphics.endFill();
			
			shape.graphics.beginFill(0xFFFFFF,0.5);
			shape.graphics.drawCircle(4,4,1);
			shape.graphics.endFill();
			
			this.bitmapData = new BitmapData(8,8,true,0);
			this.bitmapData.draw(shape);
		}
		
		public override function tick(interval:int):void
		{
			if (Math.random() < density)
				add();
			
			for (var i:int = children.length - 1;i >= 0;i--)
			{
				var child:Star = children[i] as Star;
				if (child)
				{
					if (child.life > child.flash * Math.PI)
					{
						this.remove(child);
					}
					else
					{
						child.y += interval / 1000 * child.speed * Math.sin(child.r);
						child.x += interval / 1000 * child.speed * Math.cos(child.r);
						child.life += interval;
						child.alpha = Math.abs(Math.sin(child.life / child.flash));
					}
				}
			}
		}
		
		protected override function createNewChild():DisplayObject
		{
			return new Star(bitmapData);
		}
		
		protected override function placeNewChild(child:DisplayObject):void
		{
			child.x = Math.random() * (contentWidth + screenOffest) - screenOffest - child.width;
			child.y = Math.random() * (contentHeight + child.height * 2) - child.height;
			Star(child).speed = (Math.random() + 0.5) * speed;
			Star(child).flash = (Math.random() + 0.5) * flash;
			Star(child).r = (Math.random() - 0.5) * Math.PI / 4;
			Star(child).life = 0;
			child.alpha = 0.0;
			child.blendMode = BlendMode.ADD;
		}
		
		public override function destory():void
		{
			super.destory();
			bitmapData.dispose();
		}
	}
}
import flash.display.Bitmap;
import flash.display.BitmapData;

class Star extends Bitmap
{
	public var speed:Number;
	public var flash:Number;
	public var r:Number;
	public var life:int;
	public function Star(bitmapData:BitmapData):void
	{
		super(bitmapData);
	}
}