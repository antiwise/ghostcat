package
{
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import ghostcat.display.GBase;
	import ghostcat.display.transfer.GBitmapEffect;
	import ghostcat.display.transfer.effect.DissolveHandler;
	import ghostcat.display.transfer.effect.MosaicHandler;
	import ghostcat.display.transfer.effect.ThresholdHandler;
	import ghostcat.display.transition.TransitionFadeLayer;
	import ghostcat.display.transition.TransitionLayerBase;
	import ghostcat.display.transition.TransitionObjectLayer;
	import ghostcat.display.transition.TransitionTransferLayer;
	import ghostcat.display.viewport.BackgroundLayer;
	import ghostcat.ui.controls.GImage;
	
	[SWF(width="600",height="450",backgroundColor="0xFFFFFF")]
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
			s = new GImage();
			addChild(s);
			s.source = p1;
			
			this.refreshInterval = 3000;
			invalidateDisplayList();
		}
		
		protected override function updateDisplayList() : void
		{
			switch (int(Math.random() * 5))
			{
				case 0:
					new TransitionTransferLayer(f,new GBitmapEffect(s,new ThresholdHandler())).createTo(this);
					break;
				case 1:
					new TransitionTransferLayer(f,new GBitmapEffect(s,new DissolveHandler(getTimer()))).createTo(this);
					break;
				case 2:
					new TransitionObjectLayer(f,new GBitmapEffect(s,new MosaicHandler()),s,500,500).createTo(this);
					break;
				case 3:
					var r:BackgroundLayer = new BackgroundLayer(600,450);
					r.addLayer(new TestRepeater(),1,null,true);
					r.autoMove = new Point(50,50);
					new TransitionObjectLayer(f,r).createTo(this);
					break;
				case 4:
					new TransitionFadeLayer(f,s).createTo(this);
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