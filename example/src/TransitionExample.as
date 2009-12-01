package
{
	import flash.display.BlendMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.display.GBase;
	import ghostcat.display.movieclip.GScriptMovieClip;
	import ghostcat.display.transfer.GBitmapEffect;
	import ghostcat.display.transfer.effect.DissolveHandler;
	import ghostcat.display.transfer.effect.MosaicHandler;
	import ghostcat.display.transfer.effect.SegmentHandler;
	import ghostcat.display.transfer.effect.ThresholdHandler;
	import ghostcat.display.transition.TransitionCacheLayer;
	import ghostcat.display.transition.TransitionLayerBase;
	import ghostcat.display.transition.TransitionMaskLayer;
	import ghostcat.display.transition.TransitionObjectLayer;
	import ghostcat.display.transition.TransitionSimpleLayer;
	import ghostcat.display.transition.TransitionTransferLayer;
	import ghostcat.display.transition.maskmovie.DissolveMaskHandler;
	import ghostcat.display.transition.maskmovie.GradientAlphaMaskHandler;
	import ghostcat.display.transition.maskmovie.ShutterDirectMaskHandler;
	import ghostcat.display.transition.maskmovie.ShutterMaskHandler;
	import ghostcat.display.viewport.BackgroundLayer;
	import ghostcat.ui.controls.GImage;
	import ghostcat.util.RandomUtil;
	import ghostcat.util.easing.Circ;
	
	[SWF(width="600",height="450",backgroundColor="0xFFFFFF",frameRate="60")]
	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TransitionExample extends GBase
	{
		[Embed(source="p1.jpg")]
		public var p1:Class;
		[Embed(source="p2.jpg")]
		public var p2:Class;
		
		public var t:TransitionLayerBase;
		public var s:GImage;
		
		public var step:int = 0;
		
		protected override function init() : void
		{
			new EnabledSWFScreen(stage,function ():void{refreshInterval = 3000},function ():void{refreshInterval = 0});
			
			s = new GImage();
			addChild(s);
			s.source = p1;
			
			this.refreshInterval = 3000;
			invalidateDisplayList();
		}
		
		protected override function updateDisplayList() : void
		{
			var v:int =  12 * Math.random();
			switch (v)
			{
				case 0://差异值渐变
					new TransitionTransferLayer(f,new GBitmapEffect(s,new ThresholdHandler())).createTo(this);
					break;
				case 1://溶解渐变
					new TransitionTransferLayer(f,new GBitmapEffect(s,new DissolveHandler(getTimer()))).createTo(this);
					break;
				case 2://切割渐变
					new TransitionTransferLayer(f,new GBitmapEffect(s,new SegmentHandler(int(Math.random() * 2)))).createTo(this);
					break;
				case 3://马赛克渐变
					new TransitionObjectLayer(f,new GBitmapEffect(s,new MosaicHandler()),s,500,500).createTo(this);
					break;
				case 4://循环图元渐变
					var r:BackgroundLayer = new BackgroundLayer(600,450);
					var mat:Matrix = new Matrix();
					mat.scale(0.5,0.5);
					r.addLayer((step % 2 == 0)? new p1() : new p2(),mat);
					r.autoMove = new Point(50,50);
					new TransitionObjectLayer(f,r,null,500,500).createTo(this);
					break;
				case 5://过渡渐变
					new TransitionCacheLayer(f,s).createTo(this);
					break;
				case 6://滑动渐变
					new TransitionCacheLayer(f,s,1000,{x:600 * ((Math.random() < 0.5)? 1 : -1),y:450 * ((Math.random() < 0.5)? 1 : -1),ease:Circ.easeIn}).createTo(this);
					break;
				case 7://方格渐变
					new TransitionMaskLayer(f,s,new GScriptMovieClip(new DissolveMaskHandler(20),s.getBounds(s.parent))).createTo(this);
					break;
				case 8://百叶窗渐变
					new TransitionMaskLayer(f,s,new GScriptMovieClip(new ShutterMaskHandler(),s.getBounds(s.parent))).createTo(this);
					break;
				case 9://百叶窗打开渐变
					new TransitionMaskLayer(f,s,new GScriptMovieClip(new ShutterDirectMaskHandler(50,Math.random() * 4),s.getBounds(s.parent))).createTo(this);
					break;
				case 10://方向性过度渐变
					new TransitionMaskLayer(f,s,new GScriptMovieClip(new GradientAlphaMaskHandler(Math.random() * 360),s.getBounds(s.parent))).createTo(this);
					break;
				case 11://白屏过渡渐变
					new TransitionSimpleLayer(f,600,450,0xFFFFFF,RandomUtil.choose(BlendMode.NORMAL,BlendMode.ADD,BlendMode.SUBTRACT)).createTo(this);
					break; 
			}
		}
		
		protected function f():void
		{
			step++;
			s.source = (step % 2 == 0)? p1 : p2;
		}
	}
}