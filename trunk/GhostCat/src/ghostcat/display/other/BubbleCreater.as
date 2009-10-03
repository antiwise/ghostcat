package ghostcat.display.other
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ghostcat.display.GNoScale;
	import ghostcat.events.TickEvent;
	
	/**
	 * 泡泡生成器
	 * @author flashyiyi
	 * 
	 */
	public class BubbleCreater extends GNoScale
	{
		public function BubbleCreater(width:Number,height:Number)
		{
			super();
			
			this.width = width;
			this.height = height;
			this.enabledTick = true;
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			if (Math.random() < 0.3)
				addChild(createBubble());
		}
		
		public function createBubble():Sprite
		{
			var bubble:Bubble=new Bubble();
			
			bubble.x=Math.random()*width;
			bubble.y=Math.random()*height;
			bubble.scaleX=bubble.scaleY=Math.random()+0.5;
			
			return bubble;
		}
	}
}

import flash.display.BlendMode;
import flash.display.GradientType;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import ghostcat.events.TickEvent;
import ghostcat.display.GBase;

class Bubble extends GBase
{
	public var life:Number;
	private var r:Number;
	public function Bubble()
	{
		super();
		
		life = 0;
		r = Math.random()*Math.PI*2;
		
		var ma:Matrix=new Matrix();
		ma.createGradientBox(100,100);
		graphics.beginGradientFill(GradientType.RADIAL,[0xFFFFFF,0xFFFFFF],[Math.random(),0.0],[0,0xFF],ma);
		graphics.drawCircle(50,50,50);
		graphics.endFill();	
		
		blendMode=BlendMode.ADD;
		alpha=0.0;	
		
		enabledTick = true;
	}
	
	protected override function tickHandler(event:TickEvent):void
	{
		life += event.interval / 25;
		r += Math.random() / 400 * event.interval;
		if (life>100)
			destory();
		else
		{
			y -= event.interval / 25;
			x += Math.cos(r);
			if (life < 20)
				alpha = life/20;
			else if (life > 80)
				alpha = (100-life)/20;
			
		}
	}
	
}