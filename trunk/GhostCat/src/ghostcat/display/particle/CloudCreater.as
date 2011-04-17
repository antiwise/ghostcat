package ghostcat.display.particle
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	/**
	 * 云雾效果
	 * @author flashyiyi
	 * 
	 */
	public class CloudCreater extends ParticleCreaterBase
	{
		public var speed:Number;
		public var direct:Number;
		public function CloudCreater(contentWidth:Number,contentHeight:Number,layerNum:int = 3,direct:Number = 0.5,speed:Number = 30,alpha:Number = 0.2)
		{
			super(contentWidth,contentHeight);
			
			this.alpha = alpha;
			this.direct = direct;
			this.speed = speed;
			
			for (var i:int = 0;i < layerNum;i++)
				this.add();
			
			for (i = 0;i < layerNum;i++)
				Cloud(children[i]).life = 100 / layerNum * i;
		}
		
		override protected function createNewChild():DisplayObject
		{
			return new Cloud(contentWidth * 3,contentHeight * 3);
		}
		
		override protected function destoryChild(child:DisplayObject):void
		{
			(child as Cloud).bitmapData.dispose()
		}
		
		override protected function placeNewChild(child:DisplayObject):void
		{
			child.x = 0;
			child.y = 0;
			(child as Cloud).life = 0;
			(child as Cloud).speed = this.speed * (0.2 + Math.random() * 0.8);
		}
		
		override public function tick(interval:int):void
		{
			while (children.length < 3)
				add();
			
			for (var i:int = children.length - 1;i >= 0;i--)
			{
				var child:Cloud = children[i] as Cloud;
				child.life += interval / 1000 * this.speed;
				if (child.life > 100)
				{
					remove(child);
				}
				else
				{
					child.x -= interval / 1000 * child.speed * Math.cos(direct);
					child.y -= interval / 1000 * child.speed * Math.sin(direct);
					if (child.life < 50)
						child.alpha = child.life / 50;
					else if (child.life > 50)
						child.alpha = (100 - child.life) / 50;
				}
			}
		}
		
	}
}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.utils.getTimer;

class Cloud extends Bitmap
{
	public var life:int;
	public var speed:Number;
	public function Cloud(contentWidth:int,contentHeight:int):void
	{
		super(new BitmapData(contentWidth,contentHeight));
		this.bitmapData.perlinNoise(100,100,4,getTimer(),false,true,3,true);
		this.blendMode = BlendMode.ADD;
	}
}