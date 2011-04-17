package ghostcat.display.particle
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	/**
	 * 雪生成器
	 * @author flashyiyi
	 * 
	 */
	public class SnowCreater extends ParticleCreaterBase
	{
		public var radius:int;
		public var speed:Number;
		public var density:Number;
		
		public function SnowCreater(contentWidth:Number,contentHeight:Number,density:Number = 20,radius:int = 5,speed:Number = 300,startTick:int = 150)
		{
			super(contentWidth,contentHeight);
			
			this.radius = radius;
			this.speed = speed;
			this.density = density;
			
			for (var i:int = 0;i < startTick;i++)
				tick(60);
		}
		
		public override function tick(interval:int):void
		{
			var d:Number = density / 60 * interval;
			var l:int = int(d);
			for (var k:int = 0;k < l + 1;k++)
			{
				if (k < l || Math.random() < d - l)
					this.add();
			}
			
			for (var i:int = children.length - 1;i >= 0;i--)
			{
				var child:Snow = children[i] as Snow;
				if (child)
				{
					if (child.x < -child.width || child.x > contentWidth || child.y < -child.height || child.y > contentHeight)
					{
						this.remove(child);
					}
					else
					{
						child.y += interval / 1000 * child.speed * Math.sin(child.r);
						child.x += interval / 1000 * child.speed * Math.cos(child.r);
					}
				}
			}
		}
		
		protected override function createNewChild():DisplayObject
		{
			return new Snow(radius,speed);
		}
		
		protected override function placeNewChild(child:DisplayObject):void
		{
			var pos:int = Math.random() * (contentWidth + contentHeight);
			if (pos < contentWidth)
			{
				child.x = pos - child.width;
				child.y = -child.height;
			}
			else
			{
				child.x = -child.width;
				child.y = pos - contentWidth - child.height;
			}
		}
		
		protected override function destoryChild(child:DisplayObject):void
		{
			(child as Snow).bitmapData.dispose()
		}
	}
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Matrix;

class Snow extends Bitmap
{
	public var speed:Number;
	public var r:Number;
	public function Snow(radius:int,speed:Number)
	{
		var rad:Number = Math.random();
		radius = radius * rad + 1;
		super(new BitmapData(radius * 2,radius * 2,true,0));
		
		this.speed = speed * (rad + 0.5);
		
		this.r = (Math.random() + 0.25) * Math.PI / 4;
		
		var ma:Matrix = new Matrix();
		ma.createGradientBox(radius * 2,radius * 2);
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0xFFFFFF);
		shape.graphics.drawCircle(radius,radius,radius);
		shape.graphics.endFill();	
		this.bitmapData.draw(shape);
	}
}