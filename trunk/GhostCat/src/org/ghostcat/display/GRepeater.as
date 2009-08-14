package org.ghostcat.display
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.ghostcat.core.ClassFactory;
	import org.ghostcat.debug.Debug;
	import org.ghostcat.events.RepeatEvent;
	import org.ghostcat.util.DisplayUtil;
	import org.ghostcat.util.Geom;
	import org.ghostcat.util.ReflectUtil;
	import org.ghostcat.util.Util;
	
	[Event(name="add_repeat_item",type="org.ghostcat.events.RepeatEvent")]
	
	[Event(name="remove_repeat_item",type="org.ghostcat.events.RepeatEvent")]
	
	/**
	 * 无限重复区域，游戏背景的常用伎俩。
	 * 
	 * 同时，它也是ASGameUI的List实现的基础
	 * 
	 */		
	public class GRepeater extends GBase
	{
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
		
		protected var contents:Dictionary;//当前显示出的对象
		protected var unuseContents:Array;//已删除的对象，保存在这里供新建时回收，增加性能
		
		protected var _rect:Rectangle;//本图元的逻辑大小
		protected var _contentRect:Rectangle;//单个格子的矩形
		protected var curRect:Rectangle;//目前所有格子的矩形
		
		public function get rect():Rectangle
		{
			return _rect;
		}

		/**
		 * 单个格子的矩形
		 * @return 
		 * 
		 */
		public function get contentRect():Rectangle
		{
			return _contentRect;
		}
		
		public override function set width(value:Number) : void
		{
			rect.width = value;
			invalidateSize();
		}
		
		public override function get width() : Number
		{
			return rect.width;
		}
		
		public override function set height(value:Number) : void
		{
			rect.height = value;
			invalidateSize();
		}
		
		public override function get height() : Number
		{
			return rect.height;
		}
		
		public function GRepeater(base:*)
		{
			super(null);
			_rect = new Rectangle();
			contents = new Dictionary();
			unuseContents = [];
			
			setContentClass(base);
			
			delayUpatePosition = true;//激活此属性坐标更新将会被延迟
		}
		
		public override function setContent(skin:DisplayObject, replace:Boolean=true):void
		{
			setContentClass(ReflectUtil.getClass(skin));
		}
		
		public function setContentClass(ref:*):void
		{
			Debug.restriction(ref,[Class,ClassFactory]);
			if (ref is Class)
				this.ref = new ClassFactory(ref);
			else 
				this.ref = ref;
							
			clear();
			
			if (this.ref)
			{
				//加入初始对象。否则边框大小为0，会无法渲染
				graphics.beginFill(0,0);
				graphics.drawRect(0,0,10,10);
				graphics.endFill();
				
				var s:DisplayObject = this.ref.newInstance();
				_contentRect = s.getRect(s);
			}
		}

		public function getItem(i:int,j:int):*
		{
			return contents[i + ":" + j];
		}
		
		protected override function init():void
		{
			super.init();
			if (scrollRectContainer == null)
				scrollRectContainer = findScrollRectContainer();
				
			render();
			graphics.clear();//清除初始对象
		
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
		
		//获得可显示范围（本坐标系内）
		private function getLocalScreen():Rectangle
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
			
			return Geom.localRectToContent(sRect,scrollRectContainer,this).intersection(this.rect);
			
		}
		
		public function clear():void
		{
			DisplayUtil.removeAllChildren(this);
			contents = new Dictionary();
			unuseContents = [];
		}
		
		override public function updatePosition() : void
		{
			super.updatePosition();
			render();
		}
		
		override public function updateSize() : void
		{
			super.updateSize();
			render();
		}
		
		private function render():void
		{
			var screen:Rectangle = getLocalScreen();
			if (!screen)
				return;
			
			curRect = getRect(this);
			
			if (screen.x < curRect.x)
				addItems(new Rectangle(screen.x,curRect.y,curRect.x - screen.x,curRect.height),true)
			if (screen.right > curRect.right)
				addItems(new Rectangle(curRect.right,curRect.y,screen.right - curRect.right,curRect.height),false)
			curRect = getRect(this);
			if (screen.y < curRect.y)
				addItems(new Rectangle(curRect.x,screen.y,curRect.width,curRect.y - screen.y),true);
			if (screen.bottom > curRect.bottom)
				addItems(new Rectangle(curRect.x,curRect.bottom,curRect.width,screen.bottom - curRect.bottom),false);
			
			curRect = getRect(this);
			if (screen.x > curRect.x + contentRect.width)
				removeItems(new Rectangle(curRect.x,curRect.y,screen.x - curRect.x - contentRect.width,curRect.height))
			if (screen.right < curRect.right - contentRect.width)
				removeItems(new Rectangle(screen.right+contentRect.width,curRect.y,curRect.right - screen.right,curRect.height))
			curRect = getRect(this);
			if (screen.y > curRect.y + contentRect.height)
				removeItems(new Rectangle(curRect.x,curRect.y,curRect.width,screen.y - curRect.y - contentRect.height));
			if (screen.bottom < curRect.bottom - contentRect.height)
				removeItems(new Rectangle(curRect.x,screen.bottom+contentRect.height,curRect.width,curRect.bottom - screen.bottom));
		}
		
		/**
		 * 创建Item的方法，可以重载此方法来添加新功能
		 * 
		 * @param i	横坐标序号
		 * @param j	纵坐标序号
		 * @param lowest 是否加在底层
		 * 
		 */		
		protected function addItem(i:int,j:int,lowest:Boolean=false):DisplayObject
		{
			if (contents[i + ":" +j])
				return contents[i + ":" +j];
			
			var s:DisplayObject = unuseContents.pop();
			if (!s)
				s = ref.newInstance();
			s.x = i * contentRect.width;
			s.y = j * contentRect.height;
			contents[i + ":" +j] = s;
			
			if (lowest)
				addChildAt(s,0);
			else
				addChild(s);
			dispatchEvent(Util.createObject(new RepeatEvent(RepeatEvent.ADD_REPEAT_ITEM),{repeatObj:s,repeatPos:new Point(i,j)}));
		
			return s;
		}
		
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
		
		private function addItems(rect:Rectangle,lowest:Boolean=false):void
		{
			var fi:int = (rect.x + 1) / contentRect.width;
			var fj:int = (rect.y + 1) / contentRect.height;
			var ei:int = (rect.right - 1) / contentRect.width;
			var ej:int = (rect.bottom - 1) / contentRect.height;
			var i:int;
			var j:int;
			if (lowest)
			{
				for (i = ei;i >=fi;i--)
					for (j = ej;j >=fj;j--)
						addItem(i,j,true);
			}
			else
			{
				for (i = fi;i <= ei;i++)
					for (j = fj;j <= ej;j++)
						addItem(i,j,false);
			}
		}
		
		private function removeItems(rect:Rectangle):void
		{
			var fi:Number = rect.x / contentRect.width;
			var fj:Number = rect.y / contentRect.height;
			var ei:Number = rect.right / contentRect.width;
			var ej:Number = rect.bottom / contentRect.height;
			for (var i:int = fi;i < ei;i++)
				for (var j:int = fj;j < ej;j++)
					removeItem(i,j);
		}
		
		public override function destory() : void
		{
			super.destory();
			clear();
		}

	}
}