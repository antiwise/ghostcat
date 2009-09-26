package ghostcat.operation.effect
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * 透明渐变裁切
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class AlphaClipEffect extends TweenEffect
	{
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
		/**
		 * 方向
		 */
		public var direction:String = DOWN;
		
		/**
		 * 目标 
		 */
		public var contentTarget:DisplayObject;
		
		private var oldBlendMode:String;
		private var mask:Shape;
		
		/**
		 * 缓动函数 
		 * @return 
		 * 
		 */
		public function get ease():Function
		{
			return params.ease;
		}

		public function set ease(v:Function):void
		{
			params.ease = v;
		}
		/** @inheritDoc*/
		public override function get target():*
		{
			return contentTarget;
		}
		
		public override function set target(v:*):void
		{
			contentTarget = v;
		}
		
		public function AlphaClipEffect(target:*=null, duration:int=1000, direction:String="up", ease:Function = null, invert:Boolean = false)
		{
			super(this, duration, {}, invert);
			
			this.contentTarget = target as DisplayObject;
			this.ease = ease;
			this.direction = direction;
		}
		
		private var baseRect:Rectangle;
		
		/**
		 * 滚动x 
		 * @return 
		 * 
		 */
		public function get scrollX():Number
		{
			return mask.x;
		}

		public function set scrollX(v:Number):void
		{
			mask.x = v;
		}
		
		/**
		 * 滚动y
		 * @return 
		 * 
		 */
		public function get scrollY():Number
		{
			return mask.y;
		}

		public function set scrollY(v:Number):void
		{
			mask.y = v;
		}
		/** @inheritDoc*/
		public override function execute() : void
		{
			baseRect = contentTarget.getBounds(contentTarget);
			
			mask = new Shape();
			(contentTarget as DisplayObjectContainer).addChild(mask);
			
			oldBlendMode = contentTarget.blendMode;
			contentTarget.blendMode = BlendMode.LAYER;
			
			var m:Matrix = new Matrix();
			
			mask.graphics.clear();
			mask.graphics.lineStyle(1,0xFF0000);
			switch (direction)
			{
				case UP:
					m.createGradientBox(baseRect.width,baseRect.height,-Math.PI/2,baseRect.x,baseRect.y + baseRect.height);
					mask.graphics.beginGradientFill(GradientType.LINEAR,[0,0],[0,1],[0,255],m);
					mask.graphics.drawRect(baseRect.x - 1,baseRect.y - 1,baseRect.width + 2,baseRect.height * 3 + 2);
					params.scrollY = -baseRect.height * 2;
					break;
				case DOWN:
					m.createGradientBox(baseRect.width,baseRect.height,Math.PI/2,baseRect.x,baseRect.y - baseRect.height);
					mask.graphics.beginGradientFill(GradientType.LINEAR,[0,0],[0,1],[0,255],m);
					mask.graphics.drawRect(baseRect.x - 1,baseRect.y - baseRect.height * 2 - 1,baseRect.width + 2,baseRect.height * 3 + 2);
					params.scrollY = baseRect.height * 2;
					break;
				case LEFT:
					m.createGradientBox(baseRect.width,baseRect.height,Math.PI,baseRect.x + baseRect.width,baseRect.y);
					mask.graphics.beginGradientFill(GradientType.LINEAR,[0,0],[0,1],[0,255],m);
					mask.graphics.drawRect(baseRect.x - 1,baseRect.y - 1,baseRect.width * 3 + 2,baseRect.height + 2);
					params.scrollX = -baseRect.width * 2;
					break;
				case RIGHT:
					m.createGradientBox(baseRect.width,baseRect.height,0,baseRect.x - baseRect.width,baseRect.y);
					mask.graphics.beginGradientFill(GradientType.LINEAR,[0,0],[0,1],[0,255],m);
					mask.graphics.drawRect(baseRect.x - baseRect.width * 2 - 1,baseRect.y - 1,baseRect.width * 3 + 2,baseRect.height + 2);
					params.scrollX = baseRect.width * 2;
					break;
			}
			
			mask.graphics.endFill();
			mask.blendMode = BlendMode.ALPHA;
			
			super.execute();
		}
		/** @inheritDoc*/
		public override function result(event:* = null) : void
		{
			super.result(event);
			
			(contentTarget as DisplayObjectContainer).removeChild(mask);
			contentTarget.blendMode = oldBlendMode;
		}
	}
}