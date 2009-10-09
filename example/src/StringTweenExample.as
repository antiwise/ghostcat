package
{
	import flash.display.Sprite;
	
	import ghostcat.util.easing.Elastic;Elastic;
	
	import ghostcat.util.ReflectUtil;
	import ghostcat.ui.containers.GAlert;
	import ghostcat.ui.CursorSprite;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.util.RandomUtil;
	import ghostcat.display.movieclip.GMovieClipBase;
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.operation.Oper;
	import ghostcat.manager.BrowerManager;
	import ghostcat.transfer.LightSweep;
	import ghostcat.util.easing.TweenUtil;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	import ghostcat.util.encrypt.SimpleEncrypt;
	import ghostcat.util.encrypt.ProtectedVO;
	import ghostcat.debug.DebugPanel;
	import ghostcat.debug.DebugRect;
	import ghostcat.ui.PopupManager;
	import ghostcat.manager.RootManager;
	import ghostcat.ui.CenterMode;
	import ghostcat.ui.containers.GDrawerPanel;
	import flash.geom.Rectangle;
	import ghostcat.ui.containers.GVBox;
	import ghostcat.display.residual.ResidualScreen;
	import ghostcat.util.Util;
	import ghostcat.parse.display.EllipseParse;
	import ghostcat.parse.graphics.GraphicsEllipse;
	import ghostcat.parse.graphics.GraphicsFill;
	import flash.display.Shape;
	import ghostcat.operation.effect.RepeatEffect;
	import ghostcat.operation.TweenOper;
	import ghostcat.parse.graphics.GraphicsGradientFillParse;
	import flash.display.GradientType;
	import ghostcat.util.display.MatrixUtil;
	import ghostcat.debug.Debug;
	import ghostcat.ui.controls.GImage;
	import ghostcat.ui.html.GFrameView;
	import ghostcat.ui.html.TableCreater;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import ghostcat.text.TextFieldUtil;
	import ghostcat.util.easing.Circ;
	import ghostcat.ui.controls.GText;
	import ghostcat.text.StringTween;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import ghostcat.util.easing.TweenEvent;
	import ghostcat.operation.effect.TweenEffect;
	import ghostcat.operation.FilterProxyOper;
	import flash.filters.BlurFilter;
	
	[SWF(width="600",height="600")]
	
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class StringTweenExample extends Sprite
	{
		public var t:StringTween;
		public function StringTweenExample()
		{	
			t = new StringTween();
			t.text = "<html>这是一个文本Tween实例，点击舞台可以重放。\n" + 
					"它依然可以保持文本框的基本属性，在非tween状态并不会消耗多余的性能。\n" + 
					"核心方法：<font color='#AA0000'>tween()</font>\n" + 
					"<b>参数：</b>\n" + 
					"duration 每个字的动画持续时间\n" + 
					"params 缓动参数\n" + 
					"delay 每个字的缓动间隔\n" + 
					"invert 是否倒放，默认为true\n" + 
		 			"container 放置打散字体的容器\n" + 
		 			"bitmap 是否转换为位图\n\n" + 
		 			"<i>单纯打字效果使用此类性能并不好，应当使用简化版的TextFieldUtil.tween()</i>" + 
					"</html>";
			addChild(t);
			
			showHandler();
			
			stage.addEventListener(MouseEvent.CLICK,mouseClickHandler);
		}
		
		private function showHandler(event:Event = null):void
		{
			t.removeEventListener(TweenEvent.TWEEN_END,showHandler);
			t.tween(1000,{x:"50",y:"50",rotation:"180",scaleX:2,scaleY:2,alpha:0,ease:Circ.easeOut},100,true,null,true);
		}
		
		private function mouseClickHandler(event:Event = null):void
		{
			if (t.isTweening || event.target == t)
				return;
			
			t.tween(1000,{alpha:0,onStartHandler:blurHandler},10,false,null,true);
			t.addEventListener(TweenEvent.TWEEN_END,showHandler);
		}
		
		private function blurHandler(event:TweenEvent):void
		{
			//由于TweenUtil不支持滤镜缓动，因此只能用这种变通的方法
			new FilterProxyOper((event.currentTarget as TweenUtil).target,new BlurFilter(0,0),1000,{blurX:25,blurY:25}).execute();
		}
	}
}