package ghostcat.util.display
{
	import ghostcat.ui.controls.SelectGroup;

	public class SelectGroup extends ghostcat.ui.controls.SelectGroup
	{
		public function SelectGroup(children:Array,clickToggle:Boolean = false,field:String = "selected")
		{
			super(children,clickToggle,field);
		}
	}
}