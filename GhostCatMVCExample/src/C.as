package
{
	import ghostcat.mvc.GhostCatMVC;

	[C(name="test")]
	public class C
	{
		public function execute(v:String):void
		{
			result(String(int(v) + 1));
		}
		
		public function result(v:String):void
		{
			GhostCatMVC.instance.call("test","v","setText",v);
		}
	}
}