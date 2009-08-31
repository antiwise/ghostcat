package org.ghostcat.display.viewport
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import org.ghostcat.util.CallLater;

	/**
	 * 场景灯光类
	 * 
	 * 能够对物品生成投影，而且投影还可以在Wall对象上偏转
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Light extends Sprite
	{
		private var _radius:Number = 0;
		private var _color:uint = 0xFFFFFF;
		
		private var items:Array = [];
		private var walls:Array = [];
		
		private var lightSprite:Shape;
		private var maskSprite:Sprite;
		
		public function Light(radius:Number,color:uint=0xFFFFFF,alpha:Number=0.5)
		{
			this.lightSprite = new Shape();
			this.lightSprite.blendMode = BlendMode.SCREEN;
			this.addChild(lightSprite);
		
			this.maskSprite = new Sprite();
			this.maskSprite.blendMode = BlendMode.ERASE;
			this.addChild(maskSprite);
			
			this.blendMode = BlendMode.LAYER;
		
			this.radius = radius;
			this.color = color;
			this.alpha = alpha;
		}
		
		
		public function get color():uint
		{
			return _color;
		}

		public function set color(v:uint):void
		{
			_color = v;
			CallLater.callLater(render,null,true);
		}

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(v:Number):void
		{
			_radius = v;
			CallLater.callLater(render,null,true);
		}
		
		protected function render():void
		{
			var m:Matrix = new Matrix();
			m.createGradientBox(_radius*2,_radius*2,0,-_radius,-_radius);
			
			lightSprite.graphics.clear();
			lightSprite.graphics.beginGradientFill(GradientType.RADIAL,[_color,_color],[1,0],[200,255],m);
			lightSprite.graphics.drawCircle(0,0,_radius);
			lightSprite.graphics.endFill();
		}
		
		public function addWall(v:Wall):void
		{
			walls.push(v);
		}
		
		public function addItem(v:DisplayObject):void
		{
			items.push(v);
			maskSprite.graphics.beginFill(0);
			maskSprite.graphics.drawRect(0,0,111,111);
		}

	}
}