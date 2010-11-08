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
		
		/**
		 * 获得容器内的部位 
		 * @param v
		 * @return 
		 * 
		 */
		public function getPartFromContainer(v:DisplayObjectContainer):DisplayObject
		{
			if (v && v.numChildren > 0)
				return v.getChildAt(0)
			else
				return null;
		}
		
		/**
		 * 设置容器内的部位 
		 * @param cotainer
		 * @param 	部位实例，使用数字作为参数则是通过跳帧选择
		 * 
		 */
		public function setPartToContainer(cotainer:DisplayObjectContainer,skin:*):void
		{
			if (!cotainer)
				return;
			
			cotainer.visible = skin;
			
			if (skin)
			{
				if (skin is Number)
				{
					if (cotainer is MovieClip)
						(cotainer as MovieClip).gotoAndStop(skin as Number);
				}
				else
				{
					DisplayUtil.removeAllChildren(cotainer);
					
					if (skin is String)
						skin = getDefinitionByName(skin);
					
					if (skin is Class)
						skin = new skin();
					
					if (skin is BitmapData)
						skin = new Bitmap(skin);
					
					if (skin is DisplayObject)
						cotainer.addChild(skin);
				}
			}
		}
		
		/**
		 * 通过名称获得容器
		 * @param name
		 * @return 
		 * 
		 */
		public function getContainerByName(name:String):DisplayObjectContainer
		{
			return SearchUtil.findChildByProperty(this.content,"name",name) as DisplayObjectContainer;
		}
		
		/**
		 * 通过类获得容器 
		 * @param v
		 * @return 
		 * 
		 */
		public function getContainerByClass(v:Class):DisplayObjectContainer
		{
			return SearchUtil.findChildByClass(this.content,v) as DisplayObjectContainer;
		}
		
		/**
		 * 通过类获得多个容器 
		 * @param v
		 * @return 
		 * 
		 */
		public function getContainersByClass(v:Class):Array
		{
			return SearchUtil.findChildrenByClass(this.content,v);
		}
		
		/**
		 * 通过名称设置部位
		 * @param name
		 * @param skin	部位实例，使用数字作为参数则是通过跳帧选择
		 * 
		 */
		public function setPartByName(name:String,skin:*):void
		{
			var c:DisplayObjectContainer = getContainerByName(name);
			setPartToContainer(c,skin);
		}
		
		/**
		 * 通过类设置部位
		 * @param v
		 * @param skin	部位实例，使用数字作为参数则是通过跳帧选择
		 * 
		 */
		public function setPartByClass(v:Class,skin:*):void
		{
			var c:DisplayObjectContainer = getContainerByClass(v);
			setPartToContainer(c,skin);
		}
		
		/**
		 * 通过类设置多个部位
		 * @param v
		 * @param skin	部位实例，使用数字作为参数则是通过跳帧选择
		 * 
		 */
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