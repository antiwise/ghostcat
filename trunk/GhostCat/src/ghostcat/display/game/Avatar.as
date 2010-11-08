package ghostcat.display.game
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.util.display.DisplayUtil;
	import ghostcat.util.display.SearchUtil;
	
	/**
	 * 换装人物 
	 * @author flashyiyi
	 * 
	 */
	public class Avatar extends GMovieClip
	{
		public function Avatar(mc:*=null, replace:Boolean=true, paused:Boolean=false)
		{
			super(mc, replace, paused);
		}
		
		public function getPartFromContainer(v:DisplayObjectContainer):DisplayObject
		{
			if (v && v.numChildren > 0)
				return v.getChildAt(0)
			else
				return null;
		}
		
		public function setPartToContainer(cotainer:DisplayObjectContainer,v:*):void
		{
			if (!cotainer)
				return;
			
			cotainer.visible = v;
			
			if (v)
			{
				if (v is Number)
				{
					if (cotainer is MovieClip)
						(cotainer as MovieClip).gotoAndStop(v as Number);
				}
				else
				{
					DisplayUtil.removeAllChildren(cotainer);
					
					if (v is String)
						v = getDefinitionByName(v);
					
					if (v is Class)
						v = new v();
					
					if (v is BitmapData)
						v = new Bitmap(v);
					
					if (v is DisplayObject)
						cotainer.addChild(v);
				}
			}
		}
		
		public function getContainerByName(name:String):DisplayObjectContainer
		{
			return SearchUtil.findChildByProperty(this.content,"name",name) as DisplayObjectContainer;
		}
		
		public function getContainerByClass(v:Class):DisplayObjectContainer
		{
			return SearchUtil.findChildByClass(this.content,v) as DisplayObjectContainer;
		}
		
		public function getContainersByClass(v:Class):Array
		{
			return SearchUtil.findChildrenByClass(this.content,v);
		}
		
		public function setPartByName(name:String,skin:*):void
		{
			var c:DisplayObjectContainer = getContainerByName(name);
			setPartToContainer(c,skin);
		}
		
		public function setPartByClass(v:Class,skin:*):void
		{
			var c:DisplayObjectContainer = getContainerByClass(v);
			setPartToContainer(c,skin);
		}
		
		public function setPartsByClass(v:Class,skin:*):void
		{
			var list:Array = getContainersByClass(v);
			if (list)
			{
				for each (var child:DisplayObject in list)
					setPartToContainer(child as DisplayObjectContainer,skin);
			}
		}
		
	}
}