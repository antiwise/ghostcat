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
	import ghostcat.display.bitmap.ShapeScreen;
	import ghostcat.debug.FPS;
	
	[SWF(width="600",height="600",frameRate="120")]
	
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
//		public function TestExample()
//		{	
//			stage.addChild(new FPS());
//			for (var i:int = 0;i < 500;i++)
//			{
//				var m:GBitmap = new GBitmap(DrawParse.createBitmap(new TestHuman()).bitmapData);
//				m.x = Math.random() * 600;
//				m.y = Math.random() * 600;
//				
//				addChild(m);
//			}
//			this.enabledTick = true;
//		}
//		
//		protected override function tickHandler(event:TickEvent) : void
//		{
//			for (var i:int = 0;i < numChildren;i++)
//			{
//				var m:GBitmap = getChildAt(i) as GBitmap
//				m.x = Math.random() * 600;
//				m.y = Math.random() * 600;
//			}
//		}
		
//copyPixel		
//		public var v:BitmapScreen;
//		public function TestExample()
//		{	
//			stage.addChild(new FPS());
//			
//			v = new BitmapScreen(600,600,false);
//			addChild(v);
//			for (var i:int = 0;i < 500;i++)
//			{
//				var m:GBitmap = new GBitmap(DrawParse.createBitmap(new TestHuman()).bitmapData);
//				m.x = Math.random() * 600;
//				m.y = Math.random() * 600;
//				
//				v.addChild(m);
//			}
//			this.enabledTick = true;
//		}
//		
//		
//		protected override function tickHandler(event:TickEvent) : void
//		{
//			for (var i:int = 0;i < v.children.length;i++)
//			{
//				var m:GBitmap = v.children[i] as GBitmap
//				m.x = Math.random() * 600;
//				m.y = Math.random() * 600;
//			}
//		}
//		
//beginBitmapFill
//		
		public var v:ShapeScreen;
		public function TestExample()
		{	
			stage.addChild(new FPS());
			
			v = new ShapeScreen();
			addChild(v);
			for (var i:int = 0;i < 500;i++)
			{
				var m:GBitmap = new GBitmap(DrawParse.createBitmap(new TestHuman()).bitmapData);
				m.x = Math.random() * 600;
				m.y = Math.random() * 600;
				
				v.addShapeChild(m);
			}
			this.enabledTick = true;
		}
		
		
		protected override function tickHandler(event:TickEvent) : void
		{
			for (var i:int = 0;i < v.children.length;i++)
			{
				var m:GBitmap = v.children[i] as GBitmap
				m.x = Math.random() * 600;
				m.y = Math.random() * 600;
			}
		}		

	}
}