package org.ghostcat.display
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.ghostcat.core.ClassFactory;
	import org.ghostcat.events.RepeatEvent;
	import org.ghostcat.debug.Debug;
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
		
		private var contents:Dictionary;//当前显示出的对象
		private var unuseContents:Array;//已删除的对象，保存在这里供新建时回收，增加性能
		
		private var _rect:Rectangle;
		private var _contentRect:Rectangle;//格子的矩形
		
		public function get rect():Rectangle
		{
			return _rect;
		}

		public function get contentRect():Rectangle
		{
			return _contentRect;
		}
		
		public override function set width(value:Number) : void
		{
			rect.width = value;
		}
		
		public override function get width() : Number
		{
			return rect.width;
		}
		
		public override function set height(value:Number) : void
		{
			rect.height = value;
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
			
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
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
				var s:DisplayObject = this.ref.newInstance();
				_contentRect = s.getRect(s);
				
				addItem(0,0);//加入初始对象。否则边框大小为0，会无法渲染
				
				render();
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
		private function getLocalScrollRect():Rectangle
		{
			if (!scrollRectContainer)
				return null;
				
			var sRect:Rectangle; 
			if (viewRect)
			{
				sRect = viewRect;
			}
			else if (scrollRectContainer is Stage)
			{
				sRect = Geom.getRect(scrollRectContainer);
			}
			else
			{
				sRect = scrollRectContainer.scrollRect;
			}
			return Geom.localRectToContent(sRect,scrollRectContainer,this).intersection(this.rect);
			
		}
		
		public function clear():void
		{
			DisplayUtil.removeAllChildren(this);
			contents = new Dictionary();
			unuseContents = [];
		}
		
		private function enterFrameHandler(event:Event):void
		{
			if (stage)
				render();
		}
		
		private function render():void
		{
			var displayRect:Rectangle = getLocalScrollRect();
			if (!displayRect)
				return;
			var curRect:Rectangle;
			
			curRect = getRect(this);
			if (displayRect.left < curRect.left)
				addItems(new Rectangle(displayRect.left,curRect.top,curRect.left - displayRect.left,curRect.height))
			if (displayRect.right > curRect.right)
				addItems(new Rectangle(curRect.right,curRect.top,displayRect.right - curRect.right,curRect.height))
			curRect = getRect(this);
			if (displayRect.top < curRect.top)
				addItems(new Rectangle(curRect.left,displayRect.top,curRect.width,curRect.top - displayRect.top));
			if (displayRect.bottom > curRect.bottom)
				addItems(new Rectangle(curRect.left,curRect.bottom,curRect.width,displayRect.bottom - curRect.bottom));
			
			curRect = getRect(this);
			if (displayRect.left > curRect.left + contentRect.width)
				removeItems(new Rectangle(curRect.left,curRect.top,displayRect.left - curRect.left - contentRect.width,curRect.height))
			if (displayRect.right < curRect.right - contentRect.width)
				removeItems(new Rectangle(displayRect.right+contentRect.width,curRect.top,curRect.right - displayRect.right,curRect.height))
			curRect = getRect(this);
			if (displayRect.top > curRect.top + contentRect.height)
				removeItems(new Rectangle(curRect.left,curRect.top,curRect.width,displayRect.top - curRect.top - contentRect.height));
			if (displayRect.bottom < curRect.bottom - contentRect.height)
				removeItems(new Rectangle(curRect.left,displayRect.bottom+contentRect.height,curRect.width,curRect.bottom - displayRect.bottom));
		}
		
		/**
		 * 创建Item的方法，可以重载此方法来添加新功能
		 * 
		 * @param i	横坐标序号
		 * @param j	纵坐标序号
		 * 
		 */		
		protected function addItem(i:int,j:int):DisplayObject
		{
			if (contents[i + ":" +j])
				return contents[i + ":" +j];
			
			var s:DisplayObject = unuseContents.pop();
			if (!s)
				s = ref.newInstance();
			s.x = i * contentRect.width;
			s.y = j * contentRect.height;
			contents[i + ":" +j] = s;
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
		
		private function addItems(rect:Rectangle):void
		{
			//精度问题，这里的计算可能会多加一个导致空行。暂时+1解决表面问题
			for (var i:int = rect.left / contentRect.width;i < rect.right / contentRect.width;i++)
				for (var j:int = (rect.top + 1) / contentRect.height;j < rect.bottom / contentRect.height;j++)
					addItem(i,j);
		}
		
		private function removeItems(rect:Rectangle):void
		{
			for (var i:int = rect.left / contentRect.width;i < rect.right / contentRect.width;i++)
				for (var j:int = rect.top / contentRect.height;j < rect.bottom / contentRect.height;j++)
					removeItem(i,j);
		}
		
		public override function destory() : void
		{
			super.destory();
			clear();
			
			removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}

	}
}