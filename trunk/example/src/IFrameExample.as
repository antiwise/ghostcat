package 
{
	import flash.display.Sprite;
	
	import ghostcat.extend.IFrame;
	import ghostcat.operation.RepeatOper;
	import ghostcat.operation.TweenOper;
	import ghostcat.operation.effect.RepeatEffect;

	[SWF(width="500",height="400")]
	/**
	 * 你不需要做任何额外的事情，只要使用此类就可以通过加入HTML的IFRAME来显示网页
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class IFrameExample extends Sprite
	{
		public var iframe:IFrame;
		public function IFrameExample()
		{
			iframe = new IFrame("iframe1");
			iframe.y = 25;
			iframe.width = 500;
			iframe.height = 350;
			iframe.url = "http://www.google.com";
			
			new RepeatOper([new TweenOper(iframe,5000,{y:"10"}),new TweenOper(iframe,5000,{y:"-10"})]).execute();
		}
	}
}