package ghostcat.text
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	import ghostcat.ui.controls.GText;
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.Util;
	import ghostcat.util.easing.TweenEvent;
	import ghostcat.util.easing.TweenUtil;
	
	[Event(name="tween_start",type="ghostcat.util.easing.TweenEvent")]
	[Event(name="tween_end",type="ghostcat.util.easing.TweenEvent")]
	/**
	 * 文字缓动特效类
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class GTweenText extends GText
	{
		/**
		 * 打散的文字实例 
		 */
		public var separateTexts:Array = [];
		
		private var completeCount:int = 0;//未完成的Tween数量
		
		/**
		 * 是否在缓动过程中
		 * @return 
		 * 
		 */
		public function get isTweening():Boolean
		{
			return completeCount > 0;
		}
		
		public function GTweenText(skin:*=null, replace:Boolean=true, separateTextField:Boolean=false, textPadding:Padding=null)
		{
			super(skin, replace, separateTextField, textPadding);
		}
		
		//将文本打散成块
		private function separateText(container:DisplayObjectContainer = null,bitmap:Boolean = false):void
		{
			destoryAllTexts();
			separateTexts = TextFieldUtil.separate(textField,container,bitmap);
		
			textField.visible = false;
		}
		
		//销毁所有分散的文本
		private function destoryAllTexts():void
		{
			for each (var child:DisplayObject in separateTexts)
			{
				child.removeEventListener(TweenEvent.TWEEN_END,tweenEndHandler);
				TweenUtil.removeTween(child);
				
				if (child is Bitmap)
					(child as Bitmap).bitmapData.dispose();
				
				if (child.parent)
					child.parent.removeChild(child);
			}
			separateTexts = [];
			
			textField.visible = true;
		}
		
		/**
		 * 开始缓动
		 *  
		 * @param duration	每个字的动画持续时间
		 * @param params	缓动参数
		 * @param delay	每个字的缓动间隔
		 * @param invert	是否倒放
		 * @param container	放置打散字体的容器
		 * @param bitmap	是否转换为位图
		 * 
		 */
		public function tween(duration:int,params:Object,delay:int = 100,invert:Boolean = false,container:DisplayObjectContainer = null,bitmap:Boolean = false):void
		{
			separateText(container,bitmap);
			
			this.completeCount = separateTexts.length;
			var t:int = invert ? delay * separateTexts.length : 0;
			
			for (var i:int = 0; i < separateTexts.length;i++)
			{
				t += invert ? -delay : delay;
				
				var o:Object = Util.copy(params);
				o.delay = t;
				
				if (o.hasOwnProperty("alpha") && !bitmap)
					(separateTexts[i] as DisplayObject).blendMode = BlendMode.LAYER;
				
				var tween:TweenUtil = TweenUtil.to(separateTexts[i],duration,o);
				tween.addEventListener(TweenEvent.TWEEN_END,tweenEndHandler);
			}
			
			TweenUtil.update();
			
			dispatchEvent(new TweenEvent(TweenEvent.TWEEN_START));
			
			
		}
		
		private function tweenEndHandler(event:TweenEvent):void
		{
			(event.currentTarget as EventDispatcher).removeEventListener(TweenEvent.TWEEN_END,tweenEndHandler);
			
			completeCount--;
			if (completeCount == 0)
			{
				destoryAllTexts();
				dispatchEvent(new TweenEvent(TweenEvent.TWEEN_END));
			}
		}
	}
}