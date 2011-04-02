package ghostcat.util.display
{
	import ghostcat.ui.containers.SelectGroup;

	/**
	 * 兼容性保留
	 * @author flashyiyi
	 * 
	 */
	public class SelectGroup extends ghostcat.ui.containers.SelectGroup
	{
		public function SelectGroup(children:Array,clickToggle:Boolean = false,field:String = "selected")
		{
			super(children,clickToggle,field);
		}
	}
}