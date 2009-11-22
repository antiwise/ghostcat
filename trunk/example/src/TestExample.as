package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.display.residual.ResidualScreen;
	import ghostcat.display.transfer.Cataclasm;
	import ghostcat.util.Util;

	[SWF(width="600",height="450",frameRate="60",backgroundColor="0xFFFFFF")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends Sprite
	{
		[Embed("p6.jpg")]
		public var c:Class;
		public var s:Cataclasm;
		private var step:int = 1;
		public function TestExample()
		{
			s = new Cataclasm(new c());
			addChild(Util.createObject(new ResidualScreen(600,600),{fadeSpeed:0.6,children:[s]}));
		
			stage.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(event:Event):void
		{
			if (step == 0)
				s.createTris();//重置三角形
			else
				s.bomb(new Point(mouseX,mouseY));//爆炸
			
			step = (++step) % 2;
		}
	}
}