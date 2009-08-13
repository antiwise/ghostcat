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
		
		protected var _rect:Rectangle;
		protected var _contentRect:Rectangle;//格子的矩形
		
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
				graphics.drawRect(0,0,1,1);
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
		private function getLocalScrollRect():Rectangle
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
			var displayRect:Rectangle = getLocalScrollRect();
			if (!displayRect)
				return;
			var curRect:Rectangle;
			
			curRect = getRect(this);
			
			if (displayRect.x < curRect.x)
				addItems(new Rectangle(displayRect.x,curRect.y,curRect.x - displayRect.x,curRect.height))
			if (displayRect.right > curRect.right)
				addItems(new Rectangle(curRect.right,curRect.y,displayRect.right - curRect.right,curRect.height))
			curRect = getRect(this);
			if (displayRect.y < curRect.y)
				addItems(new Rectangle(curRect.x,displayRect.y,curRect.width,curRect.y - displayRect.y));
			if (displayRect.bottom > curRect.bottom)
				addItems(new Rectangle(curRect.x,curRect.bottom,curRect.width,displayRect.bottom - curRect.bottom));
			
			curRect = getRect(this);
			if (displayRect.x > curRect.x + contentRect.width)
				removeItems(new Rectangle(curRect.x,curRect.y,displayRect.x - curRect.x - contentRect.width,curRect.height))
			if (displayRect.right < curRect.right - contentRect.width)
				removeItems(new Rectangle(displayRect.right+contentRect.width,curRect.y,curRect.right - displayRect.right,curRect.height))
			curRect = getRect(this);
			if (displayRect.y > curRect.y + contentRect.height)
				removeItems(new Rectangle(curRect.x,curRect.y,curRect.width,displayRect.y - curRect.y - contentRect.height));
			if (displayRect.bottom < curRect.bottom - contentRect.height)
				removeItems(new Rectangle(curRect.x,displayRect.bottom+contentRect.height,curRect.width,curRect.bottom - displayRect.bottom));
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
			var fi:Number = rect.x / contentRect.width;
			var fj:Number = (rect.y + 1) / contentRect.height;//精度问题，这里的计算可能会多加一个导致空行。暂时+1解决表面问题
			var ei:Number = rect.right / contentRect.width;
			var ej:Number = rect.bottom / contentRect.height;
			for (var i:int = fi;i < ei;i++)
				for (var j:int = fj;j < ej;j++)
					addItem(i,j);
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