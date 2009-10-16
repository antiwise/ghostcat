package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import ghostcat.community.CommunityManager;
	import ghostcat.community.command.DrawPriority45Command;
	import ghostcat.community.sort.SortAllManager;
	import ghostcat.display.GBase;
	import ghostcat.display.viewport.Display45Util;
	import ghostcat.display.viewport.Tile45;
	import ghostcat.events.RepeatEvent;
	import ghostcat.events.TickEvent;
	import ghostcat.manager.CommandManager;
	import ghostcat.manager.DragManager;
	

	
	[SWF(width="600",height="600")]
	
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Sort45Example extends GBase
	{
		public var map:Tile45;
		public var topLayer:Sprite;
		
		public var mapData:Array = 
				[[1,1,1,1],
				[0,0,1,0],
				[1,2,0,1],
				[1,0,0,1]]
		public var dict:Dictionary = new Dictionary();
		
		public var man:GBase;
		public var sort:CommunityManager;
		
		public function Sort45Example()
		{
			var v:TestRepeater45 = new TestRepeater45();
			var contentLayer:Sprite = new Sprite();
			addChild(contentLayer);
			
			Display45Util.setContentSize(v.width,v.height);
			sort = new CommunityManager(DrawPriority45Command.SORT45);
			
			topLayer = new Sprite();
			contentLayer.addChild(topLayer);
			
			map = new Tile45(TestRepeater45);
			map.width = v.width * 4;
			map.height = v.height * 4;
			map.addEventListener(RepeatEvent.ADD_REPEAT_ITEM,addHandler);
			map.addEventListener(RepeatEvent.REMOVE_REPEAT_ITEM,removeHandler);
			contentLayer.addChildAt(map,0);
			
			man = new GBase(new TestHuman())
			topLayer.addChild(man);
			
			DragManager.register(map,contentLayer);
			DragManager.register(man);
		
			this.enabledTick = true;
		}
		
		protected function addHandler(event:RepeatEvent):void
		{
			var d:int = (event.repeatPos.y < 4) ? mapData[event.repeatPos.y][event.repeatPos.x] : null;
			if (d)
			{
				var v:GBase = new GBase(new TileObj());
				(v.content as MovieClip).gotoAndStop(d);
				v.content.y = 50;
				v.x = event.repeatObj.x;
				v.y = event.repeatObj.y;
				if (event.addToLow)
					topLayer.addChildAt(v,0);
				else
					topLayer.addChild(v);
				
				sort.add(v);
			}
		}
		
		protected function removeHandler(event:RepeatEvent):void
		{
			var v:DisplayObject = dict[event.repeatPos.x + ":" + event.repeatPos.y];
			if (v)
				topLayer.removeChild(v);
			
			sort.remove(v);
		}
		
		protected override function tickHandler(event:TickEvent) : void
		{
			sort.calculate(man);
		}

	}
}