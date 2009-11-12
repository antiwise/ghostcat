package
{
	import ghostcat.mvc.GhostCatMVC;

	[C(name="test2")]
	public class C2
	{
		public function execute(v:String):void
		{
			var m:M2 = GhostCatMVC.instance.getM(this) as M2;
			m.value = String(int(v) + 1);
		}
	}
}