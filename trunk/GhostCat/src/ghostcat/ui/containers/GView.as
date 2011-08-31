package ghostcat.ui.containers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import ghostcat.display.GNoScale;
	import ghostcat.ui.UIConst;
	import ghostcat.ui.layout.Layout;
	import ghostcat.util.core.ClassFactory;
	import ghostcat.util.display.Geom;
	
	/**
	 * 容器
	 * 
	 * 子容器应该加到content内而不是自身，否则无法布局。skin也会在content内，无法作为背景存在。
	 * 这个容器的大小是由layout控制的
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GView extends GNoScale
	{
		/**
		 * 布局器
		 */
		public var layout:Layout;
		
		private var background:DisplayObject;
		
		/**
		 * 对象容器 
		 */
		public function get contentPane():DisplayObjectContainer
		{
			return content as DisplayObjectContainer;
		}
		
		public function GView(skin:*=null, replace:Boolean=true)
		{
			if (!skin)
				skin = new Sprite();
			
			super(skin, replace);
		}
		
		/**
		 * 设置背景 
		 * @param skin
		 * 
		 */
		public function setBackgroundSkin(skin:*):void
		{
			if (background)
				$removeChild(background);
			
			if (skin)
			{
				if (skin is String)
					skin = getDefinitionByName(skin as String);
				
				if (skin is Class)
					skin = new ClassFactory(skin);
				
				if (skin is ClassFactory)
					skin = (skin as ClassFactory).newInstance();
				
				if (skin is BitmapData)
					skin = new Bitmap(skin as BitmapData)
						
				background = skin as DisplayObject;
				
				$addChildAt(background,0);
			}
				
		}
		
		/**
		 * 设置布局对象
		 * @param layout
		 * 
		 */
		public function setLayout(layout:Layout,isRoot:Boolean = false):void
		{
			this.layout = layout;
			this.layout.setTarget(this,isRoot);
		}
		
		/**
		 * 增加对象 
		 * @param child
		 * @return 
		 * 
		 */
		public override function addChild(child:DisplayObject) : DisplayObject
		{
			var v:DisplayObject = contentPane.addChild(child);
			addHandlers(v);
			invalidateLayout();
			
			return v;
		} 
		
		/**
		 * 增加对象在某个索引处 
		 * @param child
		 * @param index
		 * @return 
		 * 
		 */
		public override function addChildAt(child:DisplayObject, index:int) : DisplayObject
		{
			var v:DisplayObject = contentPane.addChildAt(child,index);
			addHandlers(v);
			invalidateLayout();
			
			return v;
		}
		
		/**
		 * 删除对象
		 * @param child
		 * @return 
		 * 
		 */
		public override function removeChild(child:DisplayObject) : DisplayObject
		{
			var v:DisplayObject = contentPane.removeChild(child);
			removeHandlers(v);
			invalidateLayout();
			
			return v;
		}
		
		/**
		 * 删除索引处的对象 
		 * @param index
		 * @return 
		 * 
		 */
		public override function removeChildAt(index:int) : DisplayObject
		{
			var v:DisplayObject = contentPane.removeChildAt(index);
			removeHandlers(v);
			invalidateLayout();
			
			return v;
		}
		
		/**
		 * 删除所有子对象 
		 * 
		 */
		public function removeAllChild():void
		{
			while (contentPane.numChildren) 
                removeHandlers(contentPane.removeChildAt(0));
                
			invalidateLayout();
		}
		
		/**
		 * 获得索引处的对象
		 * @param index
		 * @return 
		 * 
		 */
		public override function getChildAt(index:int):DisplayObject
		{
			return contentPane.getChildAt(index);
		}
		
		/**
		 * 根据对象名获得对象
		 * @param name
		 * @return 
		 * 
		 */
		public override function getChildByName(name:String):DisplayObject
		{
			return contentPane.getChildByName(name);
		}
		
		/**
		 * 获得对象的索引
		 * @param child
		 * @return 
		 * 
		 */
		public override function getChildIndex(child:DisplayObject):int
		{
			return contentPane.getChildIndex(child);
		}
		
		/**
		 * 子对象数量 
		 * @return 
		 * 
		 */
		public override function get numChildren() : int
		{
			return contentPane.numChildren;
		}
		
		
		private function addHandlers(target:DisplayObject):void
		{
//			target.addEventListener(ResizeEvent.RESIZE,invalidateLayoutHandler,false,0,true);
			target.addEventListener(Event.REMOVED_FROM_STAGE,invalidateLayoutHandler,false,0,true);
			target.addEventListener(Event.ADDED_TO_STAGE,invalidateLayoutHandler,false,0,true);
		}
		
		private function removeHandlers(target:DisplayObject):void
		{
//			target.removeEventListener(ResizeEvent.RESIZE,invalidateLayoutHandler);
			target.removeEventListener(Event.REMOVED_FROM_STAGE,invalidateLayoutHandler);
			target.removeEventListener(Event.ADDED_TO_STAGE,invalidateLayoutHandler);
		}
		/** @inheritDoc*/
		protected override function updateSize() : void
		{
			super.updateSize();
			
			if (background)
				Geom.scaleToFit(background,this,UIConst.FILL);
		}
		
		/**
		 * 之后更新布局
		 * 
		 */
		public function invalidateLayout():void
		{
			if (layout)
				layout.invalidateLayout();
		}
		
		private function invalidateLayoutHandler(event:Event):void
		{
			invalidateLayout();
		}
		
		/**
		 * 立即更新布局 
		 * 
		 */
		public function vaildLayout():void
		{
			layout.vaildLayout();
		}
		
		public override function destory():void
		{
			if (layout)
				layout.destory();
		
			super.destory();
		}
	}
}