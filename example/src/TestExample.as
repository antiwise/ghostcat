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
			var v:ProtectedVO = new ProtectedVO(new SimpleEncrypt());
			v.a = 12345;
			v.b = new Point(1,1);
			trace(v.a);
			trace(v.b);
		}
	}
}