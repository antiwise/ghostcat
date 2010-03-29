package ghostcat.ui.controls
{
	import ghostcat.display.GBase;
	import ghostcat.events.TickEvent;
	import ghostcat.ui.UIBuilder;
	
	/**
	 * 自动执行UIBuilder的控件
	 * @author flashyiyi
	 * 
	 */
	public class GBuilderBase extends GBase
	{
		public function GBuilderBase(skin:*=null, replace:Boolean=true)
		{
			super(skin, replace);
		}
		
		public override function setContent(skin:*, replace:Boolean=true):void
		{
			if (contentInited)
				UIBuilder.destory(this);
			
			super.setContent(skin,replace);
			UIBuilder.buildAll(this);
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			UIBuilder.destory(this);
			
			super.destory();
		}
	}
}