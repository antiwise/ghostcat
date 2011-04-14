package ghostcat.ui.containers
{
	import flash.events.Event;

	[Event(name="change",type="flash.events.Event")]
	/**
	 * 可按下的按钮条
	 * 
	 * 标签规则：子对象的render将会被作为子对象的默认skin
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GToggleButtonBar extends GButtonBar
	{
		public function GToggleButtonBar(skin:*= null, replace:Boolean=true, ref:*=null)
		{
			super(skin, replace, ref);
			this.toggleOnClick = true;
		}
	}
}