package ghostcat.display.movieclip
{
	import flash.display.Sprite;

	/**
	 * 使用切换各个DisplayObject的方法模拟动画
	 * 
	 * @author flashyiyi
	 * 
	 */	
	
	public class GMutiMovieClip extends GScriptMovieClip
	{
		
		/**
		 * 对象数组
		 */
		public var displayObjects:Array;
		
		/**
		 * 
		 * @param displayObjects	对象数组
		 * @param labels	标签数组，内容为FrameLabel类型
		 * @param paused	是否暂停
		 * 
		 */
		public function GMutiMovieClip(displayObjects:Array,labels:Array=null,paused:Boolean=false)
		{
			if (!displayObjects)
				displayObjects = [];
			
			this.displayObjects = displayObjects;
			
			super(changeContent,0,labels,paused);
			if (displayObjects && displayObjects.length > 0)
				setContent(displayObjects[0]);
		}
		
		/** @inheritDoc*/
		protected function changeContent(v:GScriptMovieClip):void
		{
			super.setContent(displayObjects[v.currentFrame - 1]);
		}
		
		/** @inheritDoc*/
		public override function get totalFrames():int
		{
			return displayObjects.length;
		}

	}
}