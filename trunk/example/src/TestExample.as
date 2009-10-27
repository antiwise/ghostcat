package
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import ghostcat.display.GBase;
	import ghostcat.display.movieclip.GScriptMovieClip;
	import ghostcat.display.movieclip.maskmovie.AlphaMaskHandler;
	import ghostcat.display.transfer.GBitmapEffect;
	import ghostcat.display.transfer.effect.DissolveHandler;
	import ghostcat.display.transfer.effect.MosaicHandler;
	import ghostcat.display.transfer.effect.ThresholdHandler;
	import ghostcat.display.transition.TransitionLayerBase;
	import ghostcat.display.transition.TransitionObjectLayer;
	import ghostcat.display.transition.TransitionTransferLayer;
	import ghostcat.display.viewport.BackgroundLayer;
	import ghostcat.ui.controls.GImage;
	import ghostcat.util.display.GraphicsUtil;
	
	[SWF(width="600",height="450",backgroundColor="0xFFFFFF")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		public function TestExample()
		{
			var v:GScriptMovieClip = new GScriptMovieClip(new AlphaMaskHandler(0),25,null,new Rectangle(0,0,600,450))
			v.setLoop(1);
			addChild(v);
		}
	}
}