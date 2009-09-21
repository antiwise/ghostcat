package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import ghostcat.display.DisplayUtil;
	import ghostcat.display.GNoScale;
	
	public class GView extends GNoScale
	{
		public var contentPane:Sprite;
		
		public function GView(skin:*=null, replace:Boolean=true)
		{
			super(skin, replace);
			
			contentPane = new Sprite();
			addChild(contentPane);
		}
		
		public function addObject(child:DisplayObject) : DisplayObject
		{
			return contentPane.addChild(child);
		} 
		
		public function addObjectAt(child:DisplayObject, index:int) : DisplayObject
		{
			return contentPane.addChildAt(child,index);
		}
		
		public function removeObject(child:DisplayObject) : DisplayObject
		{
			return contentPane.removeChild(child);
		}
		
		public function removeObjectAt(index:int) : DisplayObject
		{
			return contentPane.removeChildAt(index);
		}
		
		public function removeAllObject():void
		{
			DisplayUtil.removeAllChildren(contentPane);
		}
	}
}