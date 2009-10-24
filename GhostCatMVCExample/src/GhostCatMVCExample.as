package
{
	import flash.display.Sprite;
	
	import ghostcat.mvc.GhostCatMVC;
	
	public class GhostCatMVCExample extends Sprite
	{
		public function GhostCatMVCExample()
		{
			GhostCatMVC.instance.load(M2,V,V2,C,C2);
			addChild(new V());
			addChild(new V2());
		}
	}
}