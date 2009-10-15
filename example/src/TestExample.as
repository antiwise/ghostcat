package
{
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
	import ghostcat.display.bitmap.BitmapCacher;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.display.bitmap.GBitmap;
	import ghostcat.events.TickEvent;
	import ghostcat.debug.FPS;
	import flash.display.InteractiveObject;
	import ghostcat.ui.controls.GBitmapButton;
	import ghostcat.skin.ButtonSkin;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import ghostcat.display.bitmap.BitmapDataSource;
	import flash.display.Bitmap;
	import ghostcat.text.URL;
	
	[SWF(width="600",height="600")]
	
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		[Embed(source="back.jpg")]
		public var ImageSource:Class;
		public var s:BitmapDataSource;
		public function TestExample()
		{	
			trace(new URL(loaderInfo.url).pathname.extension)
		}

	}
}