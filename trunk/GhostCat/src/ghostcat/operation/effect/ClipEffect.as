package ghostcat.operation.effect
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	/**
	 * 裁切效果
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class ClipEffect extends TweenEffect
	{
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
		public var direction:String = DOWN;
		
		public var contentTarget:DisplayObject;
		
		public function get ease():Function
		{
			return params.ease;
		}

		public function set ease(v:Function):void
		{
			params.ease = v;
		}
		
		public function ClipEffect(target:*, duration:int, direction:String, ease:Function = null, invert:Boolean = false)
		{
			super(this, duration, {}, invert);
			
			this.contentTarget = target as DisplayObject;
			this.ease = ease;
			this.direction = direction;
		}
		
		private var baseRect:Rectangle;
		
		public function get scrollX():int
		{
			return contentTarget.scrollRect.x - baseRect.x;
		}

		public function set scrollX(v:int):void
		{
			var s:Rectangle = contentTarget.scrollRect.clone();
			s.x = v + baseRect.x;
			contentTarget.scrollRect = s;
		}
		
		public function get scrollY():int
		{
			return contentTarget.scrollRect.y - baseRect.y;
		}

		public function set scrollY(v:int):void
		{
			var s:Rectangle = contentTarget.scrollRect.clone();
			s.y = v + baseRect.y;
			contentTarget.scrollRect = s;
		}

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
		
		public override function result(event:* = null) : void
		{
			super.result(event);
			contentTarget.scrollRect = null;
		}
	}
}