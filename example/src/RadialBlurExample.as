package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ghostcat.display.transfer.RadialBlur;

	[SWF(width="600",height="480",frameRate="60",backgroundColor="0xFFFFFF")]
	/**
	 * 径向模糊 
	 * @author flashyiyi
	 * 
	 */
	public class RadialBlurExample extends Sprite
	{
		[Embed(source="p6.jpg")]
		public var cls:Class;
		
		public var r:RadialBlur;
		
		public function RadialBlurExample()
		{
			clickHandler(null);
			stage.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			if (r)
				r.destory();
				
			r = new RadialBlur(new cls());
			addChild(r);
		}
		
	}
}