package
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Transform;
	
	import ghostcat.community.sort.SortAllManager;
	import ghostcat.debug.Debug;
	import ghostcat.debug.FPS;
	import ghostcat.game.layer.BitmapGameLayer;
	import ghostcat.game.layer.GameLayer;
	import ghostcat.game.layer.GameLayerBase;
	import ghostcat.game.layer.position.Tile45PositionManager;
	import ghostcat.game.layer.sort.SortYManager;
	import ghostcat.gxml.spec.Spec;
	import ghostcat.util.data.Json;
	import ghostcat.util.display.BitmapSeparateUtil;
	import ghostcat.util.display.DisplayLayoutAnalyse;
	import ghostcat.util.display.MatrixUtil;
	
	[SWF(width="800",height="600",frameRate="60",backgroundColor="0xFFFFFF")]
	public class GhostCatGameExample extends Sprite
	{
		static public var instanse:GhostCatGameExample;
		public const STAGE_W:int = 800;
		public const STAGE_H:int = 600;
		public const MAX_RUNNER:int = 500;
		
		[Embed(source="walk.png")]
		public var walk:Class;

		public var source:Array;
		
		public var layer:GameLayerBase;
		
		public function GhostCatGameExample()
		{
			instanse = this;
			source = BitmapSeparateUtil.separateBitmapData(new walk().bitmapData,67,91);
			
			layer = new BitmapGameLayer(800,600);
			layer.sort = new SortYManager(layer);
//			layer.position = new Tile45PositionManager(layer,1,1,400);
			addChild(layer);
			
			for (var i:int = 0;i < MAX_RUNNER;i++)
				layer.addObject(new Runner(int(Math.random() * 8)));
			
			addChild(new FPS());
		}
	}
}