package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ghostcat.algorithm.maze.BlockModel;
	import ghostcat.algorithm.maze.MazeCreater;

	[SWF(width="600",height="600")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends Sprite
	{
		[Embed("p3.jpg")]
		public var c:Class;
		public function TestExample()
		{
			var s:MazeCreater = new MazeCreater(100,100);
			s.find(new Point(0,0),new Point(99,99));
			var screen:DisplayObject = new BlockModel(s.result).toShape(4);
			addChild(screen);
			
		}
	}
}