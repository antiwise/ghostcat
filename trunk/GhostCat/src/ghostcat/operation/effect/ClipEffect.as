package ghostcat.operation.effect
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import ghostcat.operation.TweenOper;

	/**
	 * 裁切效果
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ClipEffect extends TweenOper
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
		
		public function ClipEffect(target:*=null, duration:int=1000, direction:String="up", ease:Function = null, invert:Boolean = false)
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
			return contentTarget.scrollRect.x - baseRect.x;
		}

		public function set scrollX(v:Number):void
		{
			var s:Rectangle = contentTarget.scrollRect.clone();
			s.x = v + baseRect.x;
			contentTarget.scrollRect = s;
		}
		
		/**
		 * 滚动y 
		 * @return 
		 * 
		 */
		public function get scrollY():Number
		{
			return contentTarget.scrollRect.y - baseRect.y;
		}

		public function set scrollY(v:Number):void
		{
			var s:Rectangle = contentTarget.scrollRect.clone();
			s.y = v + baseRect.y;
			contentTarget.scrollRect = s;
		}
		/** @inheritDoc*/
		public override function execute() : void
		{
			baseRect = contentTarget.getRect(contentTarget);
			contentTarget.scrollRect = new Rectangle(0,0,baseRect.right,baseRect.bottom);
			switch (direction)
			{
				case UP:
					params.scrollY = baseRect.height;
					break;
				case DOWN:
					params.scrollY = -baseRect.height;
					break;
				case LEFT:
					params.scrollX = baseRect.width;
					break;
				case RIGHT:
					params.scrollX = -baseRect.width;
					break;
			} 
			super.execute();
		}
		/** @inheritDoc*/
		public override function result(event:* = null) : void
		{
			super.result(event);
			contentTarget.scrollRect = null;
		}
	}
}