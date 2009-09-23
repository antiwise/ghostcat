package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ghostcat.display.GNoScale;
	import ghostcat.events.ResizeEvent;
	import ghostcat.ui.layout.Layout;
	
	public class GView extends GNoScale
	{
		public var contentPane:DisplayObjectContainer;
		
		public var layout:Layout;
		
		public function GView(skin:*=null, replace:Boolean=true)
		{
			if (!skin)
				skin = new Sprite();
			
			super(skin, replace);
			contentPane = content as DisplayObjectContainer;
		}
		
		public function addObject(child:DisplayObject) : DisplayObject
		{
			var v:DisplayObject = contentPane.addChild(child);
			addHandlers(v);
			invalidateLayout();
			
			return v;
		} 
		
		public function addObjectAt(child:DisplayObject, index:int) : DisplayObject
		{
			var v:DisplayObject = contentPane.addChildAt(child,index);
			addHandlers(v);
			invalidateLayout();
			
			return v;
		}
		
		public function removeObject(child:DisplayObject) : DisplayObject
		{
			var v:DisplayObject = contentPane.removeChild(child);
			removeHandlers(v);
			invalidateLayout();
			
			return v;
		}
		
		public function removeObjectAt(index:int) : DisplayObject
		{
			var v:DisplayObject = contentPane.removeChildAt(index);
			removeHandlers(v);
			invalidateLayout();
			
			return v;
		}
		
		public function removeAllObject():void
		{
			while (contentPane.numChildren) 
                removeHandlers(contentPane.removeChildAt(0));
                
			invalidateLayout();
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
		
		public function invalidateLayout():void
		{
			if (layout)
				layout.invalidateLayout();
		}
		
		private function invalidateLayoutHandler(event:Event):void
		{
			invalidateLayout();
		}
	}
}