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
	
	[SWF(width="600",height="600",frameRate="60",backgroundColor="0x0")]
	
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			RootManager.register(this);
			
			createChildren()
			
			stage.addChild(Util.createObject(new ResidualScreen(600,600),{enabledTick:true,fadeSpeed:0.98,blurSpeed:2,items:[this]}));
		}
		
		private function createChildren():void
		{
			var v:Shape = new EllipseParse(new GraphicsEllipse(0,0,50,50),null,new GraphicsGradientFillParse(GradientType.RADIAL,[0xFFFFFF,0xFFFFFF],[1.0,0],[0,255],MatrixUtil.createGradientBox(50,50,0,-25,-25))).createShape();
			addChild(v);
			
			v.y = 300;
			new RepeatEffect([new TweenOper(v,1000,{x:600}),new TweenOper(v,1000,{x:0})]).commit();
		}
	}
}