package
{
	import flash.display.Sprite;
	
	import ghostcat.events.PropertyChangeEvent;
	import ghostcat.util.ObjectProxy;
	
	[SWF(width="600",height="600")]
	public class TestExample extends Sprite
	{
		public function TestExample()
		{	
			var data:ObjectProxy = new ObjectProxy(new Array());
			data[0] = new ObjectProxy({x:0,y:0});
			data.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,r);
			data[0].x = 1;
		}
		
		private function r(event:PropertyChangeEvent):void
		{
			trace(event.property);
		}
	}
}