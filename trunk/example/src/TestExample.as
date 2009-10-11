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
	import ghostcat.display.GBase;
	import ghostcat.display.bitmap.BitmapScreen;
	import ghostcat.display.bitmap.PixelItem;
	import ghostcat.display.bitmap.BitmapDataContainer;
	import ghostcat.manager.DragManager;
	import ghostcat.display.movieclip.GBitmapMovieClip;
	import ghostcat.skin.ScrolDownButtonSkin;
	import ghostcat.skin.AlertSkin;
	import ghostcat.util.Tick;
	
	[SWF(width="600",height="600")]
	
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			var v:BitmapScreen = new BitmapScreen(600,600,false);
			addChild(v);
//			v.addChild(new PixelItem(5,5,0xFF0000));
//			var o:BitmapDataContainer = new BitmapDataContainer(new TestCollision());
//			o.x = 50;
//			o.y = 50;
//			o.addChild(new BitmapDataContainer(new TestHuman()));
//			v.addChild(o);
//			GMovieClipBase.defaultFrameRate = 25;
//			var m:GBitmapMovieClip = new GBitmapMovieClip();
//			m.createFromMovieClip(new AlertSkin());
//			v.addChild(m);
		}
	}
}