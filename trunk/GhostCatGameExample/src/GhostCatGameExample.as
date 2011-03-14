package
{
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	
	import ghostcat.community.sort.SortAllManager;
	import ghostcat.debug.Debug;
	import ghostcat.debug.FPS;
	import ghostcat.game.layer.BitmapGameLayer;
	import ghostcat.game.layer.GameLayer;
	import ghostcat.game.layer.GameLayerBase;
	import ghostcat.game.layer.sort.SortYManager;
	import ghostcat.util.display.BitmapSeparateUtil;
	import ghostcat.util.display.DisplayLayoutAnalyse;
	import ghostcat.util.display.MatrixUtil;
	
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
			var m:Matrix = new Matrix();
			m.scale(0.5,2);
			m.rotate(Math.PI / 2);
			m.translate(100,100);
			Debug.DEBUG = true;
			Debug.traceObject(null,MatrixUtil.toObject(m));
			return;
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