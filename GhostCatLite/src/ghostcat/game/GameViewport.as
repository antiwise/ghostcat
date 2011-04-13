package ghostcat.game
{
	import flash.display.Sprite;
	
	import ghostcat.events.TickEvent;
	import ghostcat.game.layer.GameLayer;
	import ghostcat.util.Tick;
	
	/**
	 * 场景 
	 * @author flashyiyi
	 * 
	 */
	public class GameViewport extends Sprite
	{
		public var layers:Array = [];
		public function GameViewport()
		{
			super();
			Tick.instance.addEventListener(TickEvent.TICK,tickHandler);
		}
		
		public function addLayer(layer:GameLayer):void
		{
			layers[layers.length] = layer;
			addChild(layer);
		}
		
		public function removeLayer(layer:GameLayer):void
		{
			var index:int = layers.indexOf(layer);
			if (index != -1)
				layers.splice(index, 1);
			
			removeChild(layer);
		}
		
		public function destory():void
		{
			Tick.instance.removeEventListener(TickEvent.TICK,tickHandler);
			
			for each (var layer:GameLayer in layers)
				layer.destory();
		}
		
		protected function tickHandler(event:TickEvent):void
		{
			//
		}
	}
}