package ghostcat.display.particle
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import ghostcat.skin.BoxSkin;
	import ghostcat.skin.PointSkin;
	import ghostcat.skin.ProgressSkin;
	import ghostcat.util.easing.TweenCacher;

	/**
	 * 花瓣生成器 
	 * @author flashyiyi
	 * 
	 */
	public class SakuraCreater extends ParticleCreaterBase
	{
		public var bitmapDatas:Array;
		public var frameRate:Number;
		public var density:Number;
		public var speed:Number;
		
		public function SakuraCreater(contentWidth:Number, contentHeight:Number, density:Number = 0.3, speed:Number = 100,frameRate:Number = 30)
		{
			super(contentWidth, contentHeight);
			
			this.density = density;
			this.speed = speed;
			this.frameRate = frameRate;
		
			this.createBitmapDatas();
		}
		
		protected function createBitmapDatas():void
		{
			var s:Shape = new Shape();
			s.graphics.beginFill(0xFF0000);
			s.graphics.moveTo(0,-15);
			s.graphics.curveTo(-35,-25,-25,0);
			s.graphics.lineTo(0,25);
			s.graphics.lineTo(25,0);
			s.graphics.curveTo(35,-25,0,-15);
			s.graphics.endFill();
			s.x = 50;
			s.y = 50;
			
			var cacher:TweenCacher;
			var cacher2:TweenCacher;
			cacher = new TweenCacher(s,2000,{rotation:360,scaleX:0.1},frameRate,new Rectangle(0,0,150,150));
			cacher.addEventListener(Event.COMPLETE,cacherCompleteHandler);
			function cacherCompleteHandler(e:Event):void
			{
				cacher2 = new TweenCacher(s,2000,{rotation:360,scaleX:1.0},frameRate,new Rectangle(0,0,150,150));
				cacher2.addEventListener(Event.COMPLETE,cacherCompleteHandler2);
			}
			
			function cacherCompleteHandler2(e:Event):void
			{
				bitmapDatas = cacher.result.concat(cacher2.result);
			}
		}
		
		
		override protected function createNewChild():DisplayObject
		{
			return new Sakura();
		}
		
		override protected function placeNewChild(child:DisplayObject):void
		{
			child.x = Math.random() * (contentWidth + child.width * 2) - child.width;
			child.y = Math.random() * (contentHeight + child.height * 2) - child.height;
			child.scaleX = child.scaleY = Math.random();
			child.alpha = 0.0;
			
			Sakura(child).life = 0;
			Sakura(child).r = Math.random() * Math.PI * 2;
		}
		
		override public function tick(interval:int):void
		{
			if (!bitmapDatas)
				return;
			
			if (Math.random() < density)
				add();
			
			for (var i:int = children.length - 1;i >= 0;i--)
			{
				var child:Sakura = children[i] as Sakura;
				child.life += interval / 1000 * speed * 0.5;
				if (child.life > 100 || child.x < -child.width || child.x > contentWidth || child.y < -child.height || child.y > contentHeight)
				{
					remove(child);
				}
				else
				{
					child.x += interval / 1000 * speed * Math.cos(child.r) * child.scaleX;
					child.y += interval / 1000 * speed * Math.sin(child.r) * child.scaleX;
					if (child.life < 20)
						child.alpha = child.life / 20;
					else if (child.life > 80)
						child.alpha = (100 - child.life)/20;
					
					child.frameTimer -= interval;
					while (child.frameTimer < 0) 
					{
						if (child.currentFrame == bitmapDatas.length - 1)
							child.currentFrame = 0;
						else
							child.currentFrame++;
						
						child.bitmapData = bitmapDatas[child.currentFrame];
						child.frameTimer += 1000 / frameRate;
					}
				}
			}
		}
		
		override public function destory():void
		{
			super.destory();
			for each (var bmd:BitmapData in bitmapDatas)
				bmd.dispose();
		}
		
	}
}
import flash.display.Bitmap;

class Sakura extends Bitmap
{
	public var currentFrame:int;
	public var frameTimer:int;
	public var life:int;
	public var r:Number;
}