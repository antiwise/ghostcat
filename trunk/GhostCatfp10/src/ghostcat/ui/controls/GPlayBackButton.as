package ghostcat.ui.controls
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.easing.TweenUtil;
	
	[Event(name="complete",type="flash.events.Event")]
	
	/**
	 * 用动画正放和倒放表示变化状态的按钮
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GPlayBackButton extends GButtonBase
	{
		public var duration:int = 1000;
		public var easing:Function
		public function GPlayBackButton(skin:*=null, replace:Boolean=true, separateTextField:Boolean = false, textPadding:Padding=null)
		{
			super(skin, replace,separateTextField,textPadding);
		}
		
		protected override function tweenTo(n:int) : void
		{
			super.tweenTo(n);
			
			if (content && content is MovieClip)
			{
				var mc:MovieClip = content as MovieClip;
				TweenUtil.removeTween(content);
				switch (n)
				{
					case 0: 
						TweenUtil.to(content,duration,{frame:1,ease:easing}) 
						break;
					case 1: 
						TweenUtil.to(content,duration,{frame:mc.totalFrames,ease:easing}) 
						break;
					case 2: 
						TweenUtil.to(content,duration,{frame:1,ease:easing}) 
						break;
					case 3: 
						TweenUtil.to(content,duration,{frame:1,ease:easing}) 
						break;
				}
			}
		}
	}
}