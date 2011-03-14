package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.events.TickEvent;
	import ghostcat.game.item.BitmapMovieGameItem;
	import ghostcat.util.Tick;
	
	public class Runner extends BitmapMovieGameItem
	{
		static public const RUNX:Array = [ 0,-1, 1, 0,-1, 1,-1, 1];
		static public const RUNY:Array = [ 1, 0, 0,-1, 1, 1,-1,-1];
		public var type:int;
		public var position:Point;
		public function Runner(type:int)
		{
			super(null, 10);
			
			this.setType(type);
			this.randomFrameTimer();
			this.position = new Point(Math.random() * (GhostCatGameExample.instanse.STAGE_W + width) - width,
										Math.random() * (GhostCatGameExample.instanse.STAGE_H + height) - height);
			
			GhostCatGameExample.instanse.layer.setObjectPosition(this,position);
		}
		
		public function setType(type:int):void
		{
			this.type = type;
			this.bitmapDatas = GhostCatGameExample.instanse.source.slice(type * 8,type * 8 + 8);
			this.currentFrame = 0;
		}
		
		protected override function tickHandler(event:TickEvent):void
		{
			super.tickHandler(event);
			
			position.x += RUNX[type] * event.interval / 20;
			position.y += RUNY[type] * event.interval / 20;
			
			if (position.x < -width)
				position.x = GhostCatGameExample.instanse.STAGE_W;
			
			if (position.y < -height)
				position.y = GhostCatGameExample.instanse.STAGE_H;
			
			if (position.x > GhostCatGameExample.instanse.STAGE_W)
				position.x = -width;
			
			if (position.y > GhostCatGameExample.instanse.STAGE_H)
				position.y = -height;
			
			GhostCatGameExample.instanse.layer.setObjectPosition(this,position);
		}
		
	}
}