package ghostcat.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ghostcat.util.core.ClassFactory;

	/**
	 * 基类，用于对图元进行包装。replace参数为false时将不会对源图元产生影响，可作为单独的控制类使用
	 * replace参数为true时，将会将Skin替换成此类。
	 * 
	 * 增加嵌套而不使用逻辑类是考虑到实际应用时更方便，而且可以更容易实现更替内容和旋转等操作，在它的派生类里可充分体现这一点。
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GSprite extends Sprite implements IDisplayObjectContainer
	{
		private var _content:DisplayObject;
		
		private var _replace:Boolean = true;
		
		/**
		 * 是否在移出显示列表的时候删除自身
		 */		
		public var destoryWhenRemove:Boolean = false;
		
		/**
		 * 是否已经被销毁
		 */
		public var destoryed:Boolean = false;
		
		/**
		 * 是否在第一次设置content时接受content的坐标 
		 */		
		public var acceptContentPosition:Boolean = true;
		
		/**
		 * 参数与setContent方法相同
		 * 
		 */		
		public function GSprite(skin:*=null,replace:Boolean=true)
		{
			super();
			
			setContent(skin,replace);
				
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
		}
		
		/**
		 * 设置替换方式。此属性务必在设置skin之前设置，否则会导致源图像被破坏，达不到replace为false时的效果。 
		 * @return 
		 * 
		 */		
		public function get replace():Boolean
		{
			return _replace;
		}
		
		public function set replace(v:Boolean):void
		{
			_replace = v;
			setContent(_content,v);
		}
		/**
		 * 设置皮肤 
		 * @return 
		 * 
		 */		
		public function get skin():*
		{
			return _content;
		}
		
		public function set skin(v:*):void
		{
			setContent(v,replace);
		}
		
		/**
		 *
		 * 当前容纳的内容
		 * @return 
		 * 
		 */		
		
		public function get content():DisplayObject
		{
			return _content;
		}
		
		public function set content(v:DisplayObject):void
		{
			_content = v;
		}
		
		/**
		 * 设置皮肤。
		 * 
		 * @param skin		皮肤	
		 * @param replace	是否替换原图元
		 * 
		 */		
		public function setContent(skin:*,replace:Boolean=true):void
		{
			if (skin is Class)
				skin = new ClassFactory(skin);
			
			if (skin is ClassFactory)
				skin = (skin as ClassFactory).newInstance();
			
			if (_content == skin)
				return;
			
			if (_content && _content.parent == this)
				removeChild(_content);
			
			
			if (replace && skin)
			{
				if (_content == null)
				{
					//新设置内容的时候，获取内容的坐标
					if (skin.parent)
						skin.parent.addChildAt(this,skin.parent.getChildIndex(skin));
						
					if (acceptContentPosition)
					{
						this.x = skin.x;
						this.y = skin.y;
					}
				}
				skin.x = skin.y = 0;
				addChild(skin);
				
				this.name = skin.name;
			}
			_content = skin;
		}
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler)
			
			init();
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			if (destoryWhenRemove)
				destory();
		}
		
		/**
		 *
		 * 初始化方法，在第一次被加入显示列表时调用 
		 * 
		 */		
		protected function init():void
		{
		}
		
		/**
		 * 销毁方法
		 * 
		 */
		public function destory():void
		{
			if (destoryed)
				return;
			
			if (content is GSprite)
				(content as GSprite).destory();
			
			if (parent)
				parent.removeChild(this);
			
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
			
			destoryed = true;
		}
	}
}