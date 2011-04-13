package ghostcat.display
{
	/**
	 * 取消掉事件发布的GBase对象，不需要事件的情况最好继承自此类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GSimpleBase extends GBase
	{
		public function GSimpleBase(skin:*=null, replace:Boolean=true)
		{
			super(skin, replace);
			
			this.delayUpatePosition = this.enabledDelayUpdate = false;
		}
	}
}