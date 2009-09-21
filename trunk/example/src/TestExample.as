package
{
	import flash.display.Sprite;
	
	import ghostcat.util.PropertyHistory;
	
	[SWF(width="600",height="600")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			var v:PropertyHistory = new PropertyHistory({x:0,y:0},["x","y"]);
			v.x = 1;
			v.y = 2;
			v.undo();
			trace(v.x,v.y)
			v.undo();
			trace(v.x,v.y)
		}
	}
}