package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	
	import ghostcat.manager.RootManager;
	import ghostcat.operation.FilterProxyOper;
	import ghostcat.text.controls.GTweenText;
	import ghostcat.util.easing.Circ;
	import ghostcat.util.easing.TweenEvent;
	import ghostcat.util.easing.TweenUtil;

	
	[SWF(width="600",height="600")]
	
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class StringTweenExample extends Sprite
	{
		public var t:GTweenText;
		public function StringTweenExample()
		{	
			RootManager.register(this);
			
			t = new GTweenText();
			t.editable = true;
			t.multiline = true;
			t.text = "<html>这是一个文本Tween实例，点击舞台可以重放。\n" + 
					"它依然可以保持文本框的基本属性，在非tween状态并不会消耗多余的性能。\n" + 
					"核心方法：<font color='#AA0000'>tween()</font>\n" + 
					"<b>参数：</b>\n" + 
					"duration 每个字的动画持续时间\n" + 
					"params 缓动参数\n" + 
					"delay 每个字的缓动间隔\n" + 
					"invert 是否倒放\n" + 
		 			"container 放置打散字体的容器\n" + 
		 			"bitmap 是否转换为位图\n\n" + 
		 			"<i>单纯打字效果使用此类性能并不好，应当使用简化版的TextTweenUtil.tween()</i>\n" +
					"<b>注意：这段说明文本是可以编辑的。</b>" + 
					"</html>";
			addChild(t);
			
			showHandler();
			
			stage.addEventListener(MouseEvent.CLICK,mouseClickHandler);
		}
		
		private function showHandler(event:Event = null):void
		{
			t.removeEventListener(TweenEvent.TWEEN_END,showHandler);
			t.tween(1000,{x:"50",y:"50",rotation:"180",scaleX:2,scaleY:2,autoAlpha:0,ease:Circ.easeOut,invert:true,renderOnStart:true},50,false,null,true);
		}
		
		private function mouseClickHandler(event:Event = null):void
		{
			if (t.isTweening || event.target != stage)
				return;
			
			t.tween(1000,{autoAlpha:0,onStartHandler:blurHandler},10,true,null,true);
			t.addEventListener(TweenEvent.TWEEN_END,showHandler);
		}
		
		private function blurHandler(event:TweenEvent):void
		{
			//由于TweenUtil不支持滤镜缓动，因此只能用这种变通的方法
			new FilterProxyOper((event.currentTarget as TweenUtil).target,new BlurFilter(0,0),1000,{blurX:25,blurY:25}).execute();
		}
	}
}