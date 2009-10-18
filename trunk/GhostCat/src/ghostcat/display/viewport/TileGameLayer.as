package ghostcat.display.viewport
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import ghostcat.community.GroupManager;
	import ghostcat.community.filter.OnlyCheckScreenFilter;
	import ghostcat.display.GBase;
	import ghostcat.display.GNoScale;
	import ghostcat.display.IGBase;
	import ghostcat.events.MoveEvent;
	import ghostcat.events.RepeatEvent;
	import ghostcat.events.TickEvent;
	import ghostcat.util.Util;
	
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
		public var gameLayer:Sprite;
		
		/**
		 * 当前存在的游戏物品实例
		 */
		public var gameItems:Array = [];
		
		/**
		 * 当前存在的地图物品实例
		 */
		public var mapItems:Dictionary = new Dictionary();
		
		/**
		 * 排序引型
		 */
		public var sortEngine:GroupManager;
		
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
		 * @param tileLayer	Tile对象
		 * @param createTileItemHandler	根据数据创建Item的方法
		 * @param sortEngine	排序引型
		 * @param engines	其他引型
		 * 
		 */
		public function TileGameLayer(mapData:Array,tileLayer:Tile,createTileItemHandler:Function,sortEngine:GroupManager,engines:Array = null)
		{
			super(new Sprite());
			
			this.mapData = mapData;
			this.tileLayer = tileLayer;
			this.createTileItemHandler = createTileItemHandler;
			this.sortEngine = sortEngine;
			this.engines = engines;
		}
		
		/** @inheritDoc*/
		protected override function init():void
		{
			gameLayer = new Sprite();
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
			
			this.enabledTick = true;
		}
		
		/**
		 * 处理排序的物体
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
		public function addItem(v:GBase,sort:Boolean = true):void
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
		public function removeItem(v:GBase):void
		{
			Util.remove(gameItems,v);
			Util.remove(sortOnlyItems,v);
		}
		
		/**
		 * 添加重复区域
		 * @param event
		 * 
		 */
		protected function addHandler(event:RepeatEvent):void
		{
			var d:int = mapData[event.repeatPos.y][event.repeatPos.x];
			var v:GBase = createTileItemHandler(d);
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
			//处理游戏物品隐藏
			var localScreen:Rectangle = tileLayer.getLocalScreen();
			for each (var item:GBase in gameItems)
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