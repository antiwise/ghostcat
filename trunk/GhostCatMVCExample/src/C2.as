package
{
	import ghostcat.mvc.GhostCatMVC;

	[C(name="test2")]
	public class C2
	{
		public function execute(v:String):void
		{
			(GhostCatMVC.instance.getM(this) as M2).value = String(int(v) + 1);
		}
	}
}