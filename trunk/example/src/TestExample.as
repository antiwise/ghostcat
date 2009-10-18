package
{
	import flash.text.TextField;
	
	import ghostcat.debug.DebugRect;
	import ghostcat.display.GBase;
	import ghostcat.events.TickEvent;
	import ghostcat.manager.DragManager;
	import ghostcat.util.display.Geom;
	

	
	[SWF(width="600",height="600")]
	
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		public var v1:DebugRect;
		public var v2:DebugRect;
		public var t:TextField;
		
		public function TestExample()
		{
			v1 = new DebugRect(100,100);
			v1.x = 100;
			v1.y = 100;
			addChild(v1);
			
			v2 = new DebugRect(50,50);
			addChild(v2);
			
			DragManager.register(v2);
			
			t = new TextField();
			t.mouseEnabled = false;
			addChild(t);
			
			this.enabledTick = true;
		}
		
		protected override function tickHandler(event:TickEvent) : void
		{
			t.text = Geom.getRelativeLocation(v2,v1).toString();
		}
	}
}