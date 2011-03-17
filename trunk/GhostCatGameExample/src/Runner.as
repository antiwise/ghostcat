package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.events.TickEvent;
	import ghostcat.game.item.BitmapMovieGameItem;
	import ghostcat.game.layer.position.IPositionManager;
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
			
			this.regX = 33;
			this.regY = 80;
			this.setType(type);
			this.randomFrameTimer();
		}
		
		public function setType(type:int):void
		{
			this.type = type;
			this.bitmapDatas = GhostCatGameExample.instanse.source.slice(type * 8,type * 8 + 8);
			this.currentFrame = 0;
		}
	}
}