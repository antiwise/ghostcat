package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import ghostcat.community.sort.SortAllManager;
	import ghostcat.display.GBase;
	import ghostcat.display.viewport.Display45Util;
	import ghostcat.display.viewport.Tile45;
	import ghostcat.events.RepeatEvent;
	import ghostcat.events.TickEvent;
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
		public var sort:SortAllManager;
		
		public function Sort45Example()
		{
			var v:TestRepeater45 = new TestRepeater45();
			
			var contentLayer:Sprite = new Sprite();
			addChild(contentLayer);
			
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
			Display45Util.setContentSize(v.width,v.height);
			sort = new SortAllManager(topLayer);
			
			DragManager.register(map,contentLayer);
			DragManager.register(man);
		
			this.enabledTick = true;
		}
		
		protected function addHandler(event:RepeatEvent):void
		{
			var d:int = (event.repeatPos.y < 4) ? mapData[event.repeatPos.y][event.repeatPos.x] : null;
			if (d)
			{
				var v:MovieClip = new TileObj();
				v.gotoAndStop(d);
				v.x = event.repeatObj.x;
				v.y = event.repeatObj.y + 50;
				if (event.addToLow)
					topLayer.addChildAt(new GBase(v),0);
				else
					topLayer.addChild(new GBase(v));
			}
		}
		
		protected function removeHandler(event:RepeatEvent):void
		{
			var v:DisplayObject = dict[event.repeatPos.x + ":" + event.repeatPos.y];
			if (v)
				topLayer.removeChild(v);
		}
		
		protected override function tickHandler(event:TickEvent) : void
		{
//			sort.calculate(SortAllManager.SORT_45);
		}

	}
}