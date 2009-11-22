package ghostcat.other
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import ghostcat.display.GNoScale;
	import ghostcat.events.TickEvent;
	
	/**
	 * 发光泡泡生成器
	 * @author flashyiyi
	 * 
	 */
	public class BubbleCreater extends GNoScale
	{
		public function BubbleCreater(width:Number,height:Number,radius:Number)
		{
			super();
			
			this.width = width;
			this.height = height;
			this.enabledTick = true;
			
			addChild(new CircleLight(radius));
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

import ghostcat.display.GBase;
import ghostcat.events.TickEvent;

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
		
		blendMode = BlendMode.ADD;
		alpha = 0.0;
		
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

import flash.display.BlendMode;
import flash.display.GradientType;
import flash.geom.Matrix;

import ghostcat.display.GBase;
import ghostcat.events.TickEvent;

/**
 * 跟随鼠标的光球
 * 
 * @author flashyiyi
 * 
 */
class CircleLight extends GBase
{
	public function CircleLight(radius:Number)
	{
		super();
		
		blendMode=BlendMode.ADD;
		
		var ma:Matrix=new Matrix();
		ma.createGradientBox(radius*2,radius*2,0,-radius,-radius);
		graphics.beginGradientFill(GradientType.RADIAL,[0xFFFFFF,0xFFFFFF],[0.8,0.0],[0,0xFF],ma);
		graphics.drawCircle(0,0,radius);
		graphics.endFill();
		
		this.enabledTick = true;
	}
	
	protected override function tickHandler(event:TickEvent):void
	{
		x += mouseX * event.interval / 300;
		y += mouseY * event.interval / 300;
	}
}