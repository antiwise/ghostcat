package ghostcat.display.game
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import ghostcat.community.GBaseCommunityManager;
	import ghostcat.community.GroupManager;
	import ghostcat.community.command.DrawPriority45Command;
	import ghostcat.community.filter.OnlyCheckScreenFilter;
	import ghostcat.community.sort.SortAllManager;
	import ghostcat.display.GBase;
	import ghostcat.display.GNoScale;
	import ghostcat.display.IGBase;
	import ghostcat.display.bitmap.BitmapScreen;
	import ghostcat.events.MoveEvent;
	import ghostcat.events.RepeatEvent;
	import ghostcat.events.TickEvent;
	import ghostcat.util.Util;
	import ghostcat.util.core.UniqueCall;
	
	/**
	 * 动态双层游戏场景类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TileGameLayer extends GNoScale
	{
		/**
		 * 地图数据
		 */
		public var mapData:Array = [];
		
		/**
		 * 地图背景层
		 */
		public var tileLayer:Tile;
		
		/**
		 * 游戏层
		 */
		public var gameLayer:DisplayObjectContainer;
		
		/**
		 * 当前存在的游戏物品实例
		 */
		public var gameItems:Array = [];
		
		/**
		 * 当前存在的地图物品实例
		 */
		public var mapItems:Dictionary = new Dictionary();
		
		/**
		 * 排序器，将在物品移动位置的时候对单个物品排序。
		 */
		public var sortEngine:GroupManager;
		
		/**
		 * 屏幕滚动添加物品时的特殊排序器，每次滚动屏幕时将会所有物品执行一次全排
		 */
		public var tileSortEngine:SortAllManager;
		
		/**
		 * 引型数组
		 */
		public var engines:Array;
		
		/**
		 * 创建场景块的函数，参数是data，返回GBase对象
		 */
		public var createTileItemHandler:Function;
		
		/**
		 * 
		 * @param mapData	地图数据
		 * @param tileLayer	Tile对象（Tile或者Tile45）
		 * @param createTileItemHandler	根据数据创建Item的方法
		 * @param gameLayer	游戏物品层（Sprite或者BitmapScreen）
		 * @param sortEngine	物品移动后的单物品排序器（默认是GBaseCommunityManager）
		 * @param tileSortEngine	屏幕滚动后的全排器（必须是SortAllManager）
		 * @param engines	其他引擎
		 * 
		 */
		public function TileGameLayer(mapData:Array,tileLayer:Tile,createTileItemHandler:Function,gameLayer:DisplayObjectContainer=null,sortEngine:GroupManager=null,tileSortEngine:SortAllManager=null,engines:Array = null)
		{
			super(new Sprite());
		
			if (!gameLayer)
				gameLayer = new Sprite();
			
			if (!sortEngine)
				sortEngine = new GBaseCommunityManager(DrawPriority45Command.SORT_45)
			
			if (!tileSortEngine)
				tileSortEngine = new SortAllManager(Display45Util.SORT_45);
			
			this.mapData = mapData;
			this.tileLayer = tileLayer;
			this.gameLayer = gameLayer;
			this.createTileItemHandler = createTileItemHandler;
			this.sortEngine = sortEngine;
			this.tileSortEngine = tileSortEngine;
			this.engines = engines;
		}
		
		/** @inheritDoc*/
		protected override function init():void
		{
			contentLayer.addChild(gameLayer);
			
			tileLayer.width = mapWidth * tileLayer.contentRect.width;
			tileLayer.height = mapHeight * tileLayer.contentRect.height;
			tileLayer.addEventListener(RepeatEvent.ADD_REPEAT_ITEM,addHandler);
			tileLayer.addEventListener(RepeatEvent.REMOVE_REPEAT_ITEM,removeHandler);
			contentLayer.addChildAt(tileLayer,0);
			
			sortEngine.onlyCheckValues = [];
			sortEngine.container = gameLayer;
//			sortEngine.filter = OnlyCheckScreenFilter.onlyCheckScreenHandler;
			if (!sortEngine.setDirtyWhenEvent)
				sortEngine.setDirtyWhenEvent = MoveEvent.MOVE;
			
			tileSortEngine.container = gameLayer;
			
			this.enabledTick = true;
		}
		
		/**
		 * 需要处理排序的物体
		 * @return 
		 * 
		 */
		public function get sortOnlyItems():Array
		{
			return sortEngine.onlyCheckValues;
		}

		public function set sortOnlyItems(value:Array):void
		{
			sortEngine.onlyCheckValues = value;
		}
		
		/**
		 * 层集合
		 * @return 
		 * 
		 */
		public function get contentLayer():DisplayObjectContainer
		{
			return content as DisplayObjectContainer;
		}
		
		/**
		 * 地图数据宽度
		 * @return 
		 * 
		 */
		public function get mapWidth():int
		{
			return (mapData.length > 0) ? mapData[0].length : 0;
		}
		
		/**
		 * 地图数据高度
		 * @return 
		 * 
		 */
		public function get mapHeight():int
		{
			return mapData.length;
		}

		/**
		 * 增加物体
		 * @param v
		 * @param sort	是否排序
		 * 
		 */
		public function addItem(v:IGBase,sort:Boolean = true):void
		{
			gameItems.push(v);
			if (sort)
				sortOnlyItems.push(v);
		}
		
		/**
		 * 删除物体
		 * @param v
		 * 
		 */
		public function removeItem(v:IGBase):void
		{
			Util.remove(gameItems,v);
			Util.remove(sortOnlyItems,v);
		}
		
		//延迟排序
		private var sortBeforeAddItemCall:UniqueCall = new UniqueCall(sortBeforeAddItem);
		private function sortBeforeAddItem():void
		{
			tileSortEngine.data = sortEngine.data;
			tileSortEngine.calculateAll(false);
		}
		
		/**
		 * 添加重复区域
		 * @param event
		 * 
		 */
		protected function addHandler(event:RepeatEvent):void
		{
			var d:int = mapData[event.repeatPos.y][event.repeatPos.x];
			var v:DisplayObject = createTileItemHandler(d);
			if (v)
			{
				mapItems[event.repeatPos.x + ":" + event.repeatPos.y] = v;
				v.x = event.repeatObj.x;
				v.y = event.repeatObj.y;
				if (event.addToLow)
					gameLayer.addChildAt(v,0);
				else
					gameLayer.addChild(v);
				
				sortEngine.add(v);
				if (engines)
				{
					for each (var e:GroupManager in engines)
						e.add(v);
				}
				sortBeforeAddItemCall.invalidate();
			}
		}
		
		/**
		 * 删除重复区域
		 * @param event
		 * 
		 */
		protected function removeHandler(event:RepeatEvent):void
		{
			var v:DisplayObject = mapItems[event.repeatPos.x + ":" + event.repeatPos.y];
			if (v)
			{
				gameLayer.removeChild(v);
				if (v is IGBase)
					(v as IGBase).destory();
				
				sortEngine.remove(v);
				if (engines)
				{
					for each (var e:GroupManager in engines)
						e.remove(v);
				}
			}
		}
		
		/** @inheritDoc*/
		protected override function tickHandler(event:TickEvent) : void
		{
			//同步层间坐标
			if (gameLayer is BitmapScreen)
			{
				var bs:BitmapScreen = gameLayer as BitmapScreen; 
				bs.drawOffest.x = tileLayer.x;
				bs.drawOffest.y = tileLayer.y;
			}
			else
			{
				gameLayer.x = tileLayer.x;
				gameLayer.y = tileLayer.y;
			}
			
			//处理游戏物品隐藏
			var localScreen:Rectangle = tileLayer.getLocalScreen();
			for each (var item:DisplayObject in gameItems)
			{
				var itemRect:Rectangle = item.getBounds(item);
				itemRect.x += item.x;
				itemRect.y += item.y;
				if (itemRect.intersects(localScreen))
				{
					if (item.parent != gameLayer)
					{
						gameLayer.addChild(item);
						sortEngine.add(item);
						
						sortBeforeAddItemCall.invalidate();//如果这里不重排似乎会出有问题
					}
				}
				else
				{
					if (item.parent == gameLayer)
					{
						gameLayer.removeChild(item);	
						sortEngine.remove(item);	
					}
				}	
			}
			
			sortEngine.calculateAll();
			if (engines)
			{
				for each (var e:GroupManager in engines)
					e.calculateAll();
			}
		}
		
		/** @inheritDoc*/
		override protected function updatePosition() : void
		{
			super.updatePosition();
			tileLayer.render();
		}
		
		/** @inheritDoc*/
		override protected function updateSize() : void
		{
			super.updateSize();
			tileLayer.render();
		}
		/** @inheritDoc*/
		public override function destory():void
		{
			if (destoryed)
				return;
			
			tileLayer.destory();
			sortEngine.destory();
			tileSortEngine.destory();
			
			if (engines)
			{
				for each (var e:GroupManager in engines)
					e.destory();
			}
			
			for each (var v:GBase in gameItems)
			{
				if (v is IGBase)
					IGBase(v).destory();
			}
				
			for each (v in mapItems)
			{
				if (v is IGBase)
					IGBase(v).destory();
			}
			
			super.destory();
		}
	}
}