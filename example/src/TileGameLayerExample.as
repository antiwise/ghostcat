package
{
	import flash.display.MovieClip;
	
	import ghostcat.community.CommunityManager;
	import ghostcat.community.command.DrawPriority45Command;
	import ghostcat.display.GBase;
	import ghostcat.display.viewport.Tile45;
	import ghostcat.display.viewport.TileGameLayer;
	import ghostcat.manager.DragManager;
	

	
	[SWF(width="600",height="600")]
	
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TileGameLayerExample extends GBase
	{
		public var mapData:Array = 
					[[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
					[0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0],
					[1,2,0,1,1,2,0,1,1,2,0,1,1,2,0,1],
					[1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1],
					[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
					[0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0],
					[1,2,0,1,1,2,0,1,1,2,0,1,1,2,0,1],
					[1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1]]
		
		public var man:GBase;
		public var game:TileGameLayer;
		
		public function TileGameLayerExample()
		{
			game = new TileGameLayer(mapData,new Tile45(TestRepeater45),createTileItemHandler,new CommunityManager(DrawPriority45Command.SORT45));
			addChild(game);
			
			man = new GBase(new TestHuman())
			game.addItem(man);
			
			DragManager.register(game.tileLayer,game);
			DragManager.register(man);
		}
		
		protected function createTileItemHandler(d:*):GBase
		{
			if (d)
			{
				var v:GBase = new GBase(new TileObj());
				(v.content as MovieClip).gotoAndStop(d);
				v.content.y = 50;
			}
			return v;
		}

	}
}