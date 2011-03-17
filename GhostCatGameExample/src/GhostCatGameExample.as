package
{
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	
	import ghostcat.community.sort.SortAllManager;
	import ghostcat.debug.Debug;
	import ghostcat.debug.FPS;
	import ghostcat.events.TickEvent;
	import ghostcat.game.layer.BitmapGameLayer;
	import ghostcat.game.layer.GameLayer;
	import ghostcat.game.layer.GameLayerBase;
	import ghostcat.game.layer.position.Tile45PositionManager;
	import ghostcat.game.layer.sort.SortYManager;
	import ghostcat.game.util.GameMoveByPathOper;
	import ghostcat.gxml.conversion.ObjectToXMLSpec;
	import ghostcat.gxml.jsonspec.JSONDisplaySpec;
	import ghostcat.gxml.spec.Spec;
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.Tick;
	import ghostcat.util.data.Json;
	import ghostcat.util.display.BitmapSeparateUtil;
	import ghostcat.util.display.DisplayLayoutAnalyse;
	import ghostcat.util.display.MatrixUtil;
	import ghostcat.util.easing.Circ;
	
	[SWF(width="800",height="600",frameRate="60",backgroundColor="0xFFFFFF")]
	public class GhostCatGameExample extends Sprite
	{
		static public var instanse:GhostCatGameExample;
		
		public const STAGE_W:int = 800;
		public const STAGE_H:int = 600;
		public const viewportRect:Rectangle = new Rectangle(-33,-80,STAGE_W + 67 * 2,STAGE_H + 91 * 2);
		public const MAX_RUNNER:int = 500;
		public const RUNX:Array = [ 0,-1, 1, 0,-1, 1,-1, 1];
		public const RUNY:Array = [ 1, 0, 0,-1, 1, 1,-1,-1];
		
		[Embed(source="walk.png")]
		public var walk:Class;

		public var source:Array;
		
		public var layer:GameLayerBase;
		
		public function GhostCatGameExample()
		{
			instanse = this;
			source = BitmapSeparateUtil.separateBitmapData(new walk().bitmapData,67,91);
			
			layer = new GameLayer();
			layer.sort = new SortYManager(layer);
//			layer.position = new Tile45PositionManager(1,0.5,350,100);
			addChild(layer);
			
			for (var i:int = 0;i < MAX_RUNNER;i++)
			{
				var item:Runner = new Runner(int(Math.random() * 8));
				layer.addObject(item);
				
				item.position = new Point(Math.random() * viewportRect.width  + viewportRect.x,
										Math.random() * viewportRect.height + viewportRect.y);
				layer.setObjectPosition(item,item.position);
			}
			addChild(new FPS());
			
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
		}
		
		protected function tickHandler(event:TickEvent):void
		{	
			for each (var item:Runner in layer.children)
			{
				var position:Point = item.position;
				
				position.x += RUNX[item.type] * event.interval / 20;
				position.y += RUNY[item.type] * event.interval / 20;
				
				if (position.x < viewportRect.x)
					position.x = viewportRect.right;
				
				if (position.y < viewportRect.y)
					position.y = viewportRect.bottom;
				
				if (position.x > viewportRect.right)
					position.x = viewportRect.x;
				
				if (position.y > viewportRect.bottom)
					position.y = viewportRect.y;
				
				this.layer.setObjectPosition(item,position);
			}
		}
	}
}