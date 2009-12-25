package ghostcat.ui.controls
{
	import ghostcat.display.GBase;
	import ghostcat.ui.UIBuilder;
	
	/**
	 * 自动执行UIBuilder的控件（无法设置参数，只能重写）
	 * @author flashyiyi
	 * 
	 */
	public class GBuilderBase extends GBase
	{
		public function GBuilderBase(skin:*=null, replace:Boolean=true)
		{
			super(skin, replace);
			this.autoBuild();
		}
		
		/**
		 * 自动创建UI方法 
		 * 
		 */
		protected function autoBuild():void
		{
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