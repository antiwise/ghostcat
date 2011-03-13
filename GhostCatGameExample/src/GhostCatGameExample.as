package
{
	import flash.display.Sprite;
	
	import ghostcat.community.sort.SortAllManager;
	import ghostcat.debug.FPS;
	import ghostcat.game.layer.BitmapGameLayer;
	import ghostcat.game.layer.GameLayer;
	import ghostcat.game.layer.GameLayerBase;
	import ghostcat.game.layer.sort.SortYManager;
	import ghostcat.util.display.BitmapSeparateUtil;
	
	[SWF(width="800",height="600",frameRate="60",backgroundColor="0xFFFFFF")]
	public class GhostCatGameExample extends Sprite
	{
		static public var instanse:GhostCatGameExample;
		public const STAGE_W:int = 800;
		public const STAGE_H:int = 600;
		public const MAX_RUNNER:int = 1000;
		
		[Embed(source="walk.png")]
		public var walk:Class;

		public var source:Array;
		
		public var layer:GameLayerBase;
		
		public function GhostCatGameExample()
		{
			instanse = this;
			source = BitmapSeparateUtil.separateBitmapData(new walk().bitmapData,67,91);
			
			layer = new BitmapGameLayer(800,600);
			layer.sort = new SortYManager();
			addChild(layer);
			
			for (var i:int = 0;i < MAX_RUNNER;i++)
				layer.addObject(new Runner(int(Math.random() * 8)));
			
			addChild(new FPS());
		}
	}
}