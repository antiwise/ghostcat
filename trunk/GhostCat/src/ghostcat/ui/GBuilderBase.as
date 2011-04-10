package ghostcat.ui
{
	import ghostcat.display.GBase;
	import ghostcat.ui.UIBuilder;
	
	/**
	 * 自动执行UIBuilder的控件
	 * 会根据自己的公开属性来自动查询Skin内的同名元件并自动创建。
	 * 
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