package ghostcat.display.viewport
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import ghostcat.debug.Debug;
	import ghostcat.util.display.DisplayUtil;
	import ghostcat.display.GBase;
	import ghostcat.events.RepeatEvent;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.display.Geom;
	import ghostcat.util.Util;
	
	[Event(name="add_repeat_item",type="ghostcat.events.RepeatEvent")]
	
	[Event(name="remove_repeat_item",type="ghostcat.events.RepeatEvent")]
	
	/**
	 * 无限重复区域，游戏背景的常用伎俩。
	 * 
	 * 同时，它也是List实现的基础
	 * 
	 */		
	public class Tile extends GBase
	{
		protected const LEFT:int = 0;
		protected const RIGHT:int = 1;
		protected const UP:int = 2;
		protected const DOWN:int = 3;
		
		/**
		 * 图形
		 */		
		public var ref:ClassFactory;
		
		/**
		 * 限制范围的容器
		 */		
		public var scrollRectContainer:DisplayObject;
		
		/**
		 * 相对与scrollRectContainer的限定范围的矩形，为空则是scrollRect的值
		 */		
		public var viewRect:Rectangle;
		
		/**
		 * 当前显示出的对象
		 */
		protected var contents:Dictionary;
		
		/**
		 * 已删除的对象，保存在这里供新建时回收，增加性能
		 */
		protected var unuseContents:Array;
		
		/**
		 * 本图元的逻辑大小
		 */
		protected var _rect:Rectangle;
		
		/**
		 * 单个格子的矩形
		 */
		protected var _contentRect:Rectangle;
		
		/**
		 * 目前所有格子的矩形
		 */
		protected var curRect:Rectangle;
		
		
		/**
		 * 全部内容的矩形
		 * @return 
		 * 
		 */
		public function get rect():Rectangle
		{
			return _rect;
		}

		/**
		 * 单个格子的矩形
		 * @return 
		 * 
		 */
		protected function get contentRect():Rectangle
		{
			return _contentRect;
		}
		/** @inheritDoc*/
		public override function set width(value:Number) : void
		{
			rect.width = value;
			invalidateSize();
		}
		
		public override function get width() : Number
		{
			return rect.width;
		}
		/**
		 * @inheritDoc
		 */
		public override function set height(value:Number) : void
		{
			rect.height = value;
			invalidateSize();
		}
		/**
		 * @inheritDoc
		 */
		public override function get height() : Number
		{
			return rect.height;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function getRect(targetCoordinateSpace:DisplayObject) : Rectangle
		{
			return Geom.localRectToContent(rect,this,targetCoordinateSpace);
		}
		
		public function Tile(itemClass:*)
		{
			super(null);
			
			_rect = new Rectangle();
			contents = new Dictionary();
			unuseContents = [];
			
			setContentClass(itemClass);
			
			delayUpatePosition = true;//激活此属性坐标更新将会被延迟
		}
		
		/**
		 * 设置重复块的类
		 * @param ref
		 * 
		 */
		public function setContentClass(ref:*):void
		{
			if (ref is Class)
				this.ref = new ClassFactory(ref);
			else 
				this.ref = ref;
							
			clear();
			
			if (this.ref)
			{
				curRect = new Rectangle();
				
				var s:DisplayObject = this.ref.newInstance();
				_contentRect = s.getRect(s);
			}
		}

		/**
		 * 获得方块
		 * 
		 * @param i
		 * @param j
		 * @return 
		 * 
		 */
		public function getItemAt(i:int,j:int):*
		{
			return contents[i + ":" + j];
		}
		
				
		/**
		 * 获得屏幕上点所在的方块索引坐标
		 * 
		 * @param p
		 * 
		 */
		public function getItemPointAtPoint(p:Point):Point
		{
			p = displayToItem(p);
			return new Point(int(p.x / contentRect.width), int(p.y / contentRect.height)); 
		}
		
		/**
		 * 由显示坐标转换为内部坐标
		 * 
		 * @param p
		 * @return 
		 * 
		 */
		public function displayToItem(p:Point):Point
		{
			return p.clone();
		}
		
		/**
		 * 由内部坐标转换为显示坐标
		 * 
		 * @param p
		 * @return 
		 * 
		 */
		public function itemToDisplay(p:Point):Point
		{
			return p.clone();
		}
		
		protected override function init():void
		{
			super.init();
			if (scrollRectContainer == null)
				scrollRectContainer = findScrollRectContainer();
				
			render();
			
			stage.addEventListener(Event.RESIZE,resizeHandler);
		}
		
		private function resizeHandler(event:Event):void
		{
			render();
		}
		
		private function findScrollRectContainer():DisplayObject
		{
			var contain:DisplayObject = parent;
			while (contain && contain.stage != contain)
			{
				if (contain.scrollRect)
					break;
				contain = contain.parent;
			}
			return contain;
		}
		
		/**
		 * 
		 * @return 获得可显示范围（本坐标系内）
		 * 
		 */
		protected function getLocalScreen():Rectangle
		{
			if (!scrollRectContainer)
				return null;
				
			var sRect:Rectangle; 
			if (viewRect)
				sRect = viewRect;
			else if (scrollRectContainer is Stage)
				sRect = Geom.getRect(scrollRectContainer);
			else
				sRect = scrollRectContainer.scrollRect;
			
			return Geom.localRectToContent(sRect,scrollRectContainer,this);
			
		}
		
		public function clear():void
		{
			DisplayUtil.removeAllChildren(this);
			contents = new Dictionary();
			unuseContents = [];
		}
		
		override protected function updatePosition() : void
		{
			super.updatePosition();
			render();
		}
		
		override protected function updateSize() : void
		{
			super.updateSize();
			render();
		}
		
		/**
		 * 通过范围获得需要显示的方块
		 * 
		 * @param viewport
		 * @return 
		 * 
		 */
		protected function getItemRect(viewport:Rectangle):Rectangle
		{
			if (!viewport)
				return null;
			
			var screen:Rectangle = new Rectangle();
			screen.x = Math.floor(viewport.x / contentRect.width);
			screen.y = Math.floor(viewport.y / contentRect.height);
			screen.width = Math.ceil(viewport.right / contentRect.width) - screen.x;
			screen.height = Math.ceil(viewport.bottom / contentRect.height) - screen.y;
			
			return screen;
		}
		
		private function render():void
		{
			//获得屏幕内应当显示的格子
			var screen:Rectangle = getItemRect(getLocalScreen());
			
			if (!screen)
				return;
			
			//过滤显示范围	
			var cRect:Rectangle = new Rectangle(0,0,Math.ceil(width/contentRect.width),Math.ceil(height/contentRect.height));
			screen = screen.intersection(cRect);
			
			//增删格子
			if (curRect.x != screen.x)//左
			{
				if (curRect.x > screen.x)
					addItems(new Rectangle(screen.x,curRect.y,Math.min(screen.width,curRect.x - screen.x),curRect.height),LEFT)
					//这里增加元素时，如果跨屏较多，在向回卷的时候体积将会很大，删除时很费时间，因此要在下面进行补偿处理
					//形成这个问题是原因是向回跨屏时是先增加再删除，会同时存在两块分离的区域，暂时先这样解决
					//实际上，就算不做任何处理，这种拖慢也要等到百万级的数据集才能体现出来
				else
					removeItems(new Rectangle(curRect.x,curRect.y,Math.min(curRect.width,screen.x - curRect.x),curRect.height));
					
				curRect.width += curRect.x - screen.x;
				curRect.width = Math.max(curRect.width,0);
				curRect.x = screen.x;
			}
			if (screen.right != curRect.right)//右
			{
				if (screen.right > curRect.right)
					addItems(new Rectangle(curRect.right,curRect.y,Math.min(screen.width,screen.right - curRect.right),curRect.height),RIGHT)
				else
				{
					//当屏幕向回卷有大跨度时，只删除最下面的一部分，暂时先这样特殊处理一下
					if (curRect.width > 5000)
						removeItems(new Rectangle(screen.x + curRect.width - screen.width - 1,curRect.y,screen.width + 1,curRect.height));
					else
						removeItems(new Rectangle(screen.right,curRect.y,Math.min(curRect.width,curRect.right - screen.right),curRect.height))
				}
				curRect.width = screen.width;
			}
			if (curRect.y != screen.y)//上
			{
				if (curRect.y > screen.y)
					addItems(new Rectangle(curRect.x,screen.y,curRect.width,Math.min(screen.height,curRect.y - screen.y)),UP);
				else
					removeItems(new Rectangle(curRect.x,curRect.y,curRect.width,Math.min(curRect.height,screen.y - curRect.y)));
					
				curRect.height += curRect.y - screen.y;
				curRect.height = Math.max(curRect.height,0);
				curRect.y = screen.y;
			}
			if (screen.bottom != curRect.bottom)//下
			{
				if (screen.bottom > curRect.bottom)
					addItems(new Rectangle(curRect.x,curRect.bottom,curRect.width,Math.min(screen.height,screen.bottom - curRect.bottom)),DOWN);
				else
				{
					if (curRect.height > 5000)
						removeItems(new Rectangle(curRect.x,screen.y + curRect.height - screen.height - 1,curRect.width,screen.height + 1));
					else
						removeItems(new Rectangle(curRect.x,screen.bottom,curRect.width,Math.min(curRect.height,curRect.bottom - screen.bottom)));
				}
				curRect.height = screen.height;
			}
		}
		
		/**
		 * 物品总量
		 */
		protected var itemCount:int = 0;
		
		/**
		 * 创建Item的方法，可以重载此方法来添加新功能
		 * 
		 * @param i	横坐标序号
		 * @param j	纵坐标序号
		 * @param lowest 是否加在底层
		 * 
		 */		
		protected function addItem(i:int,j:int,low:Boolean=false):DisplayObject
		{
			if (contents[i + ":" +j])
				return contents[i + ":" +j];
			
			var s:DisplayObject = unuseContents.pop();
			if (!s)
				s = ref.newInstance();
			s.x = i * contentRect.width;
			s.y = j * contentRect.height;
			contents[i + ":" +j] = s;
			
			if (low)
				addChildAt(s,0);
			else
				addChild(s);
				
			dispatchEvent(Util.createObject(new RepeatEvent(RepeatEvent.ADD_REPEAT_ITEM),{repeatObj:s,repeatPos:new Point(i,j),addToLow:low}));
		
			return s;
		}
		
		/**
		 * 删除物品
		 * 
		 * @param i
		 * @param j
		 * @return 
		 * 
		 */
		protected function removeItem(i:int,j:int):DisplayObject
		{
			var s:DisplayObject = contents[i + ":" +j];
			if (s)
			{
				delete contents[i + ":" +j];
				removeChild(s);
				unuseContents.push(s);
				dispatchEvent(Util.createObject(new RepeatEvent(RepeatEvent.REMOVE_REPEAT_ITEM),{repeatObj:s,repeatPos:new Point(i,j)}));
			}
			return s;
		}
		
		/**
		 * 增加一组格子
		 *  
		 * @param rect	格子区域
		 * @param direct	方向	
		 * 
		 */
		protected function addItems(rect:Rectangle,direct:int):void
		{
			var fi:int = rect.x;
			var fj:int = rect.y;
			var ei:int = rect.right;
			var ej:int = rect.bottom;
			var i:int;
			var j:int;
			switch (direct)
			{
				case LEFT:
					for (i = ei - 1;i >= fi;i--)
						for (j = ej - 1;j >= fj;j--)
							addItem(i,j,true);
					break;
				case RIGHT:
					for (i = fi;i < ei;i++)
						for (j = fj;j < ej;j++)
							addItem(i,j,false);
					break;
				case UP:
					for (j = ej - 1;j >= fj;j--)
						for (i = ei - 1;i >= fi;i--)
							addItem(i,j,true);
					break;
				case DOWN:
					for (j = fj;j < ej;j++)
						for (i = fi;i < ei;i++)
							addItem(i,j,false);
					break;
			}			
		}
		
		/**
		 * 删除一组物品
		 * @param rect
		 * 
		 */
		protected function removeItems(rect:Rectangle):void
		{
			var fi:int = rect.x;
			var fj:int = rect.y;
			var ei:int = rect.right;
			var ej:int = rect.bottom;
			for (var i:int = fi;i < ei;i++)
				for (var j:int = fj;j < ej;j++)
					removeItem(i,j);
		}
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			clear();
			ref = null;
		
			super.destory();
		}

	}
}