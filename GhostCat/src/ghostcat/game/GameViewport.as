package ghostcat.game
{
	import flash.display.Sprite;
	
	import ghostcat.events.TickEvent;
	import ghostcat.game.layer.GameLayer;
	import ghostcat.game.util.GameTick;
	import ghostcat.util.Tick;
	
	/**
	 * 场景 
	 * @author flashyiyi
	 * 
	 */
	public class GameViewport extends Sprite
	{
		public var layers:Array = [];
		private var _enabledTick:Boolean;

		public function get enabledTick():Boolean
		{
			return _enabledTick;
		}

		public function set enabledTick(value:Boolean):void
		{
			if (_enabledTick == value)
				return;
			
			_enabledTick = value;
			if (value)
				GameTick.instance.addEventListener(TickEvent.TICK,tickHandler);
			else
				GameTick.instance.removeEventListener(TickEvent.TICK,tickHandler);
		}

		public function GameViewport()
		{
			super();
			this.enabledTick = true;
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
			GameTick.instance.removeEventListener(TickEvent.TICK,tickHandler);
			
			for each (var layer:GameLayer in layers)
				layer.destory();
		}
		
		protected function tickHandler(event:TickEvent):void
		{
			render();
		}
		
		public function render():void
		{
			//
		}
	}
}