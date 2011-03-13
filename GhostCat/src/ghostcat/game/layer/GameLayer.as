package ghostcat.game.layer
{
	import flash.display.DisplayObject;

	public class GameLayer extends GameLayerBase
	{
		public function GameLayer()
		{
			super();
		}
		
		override public function addObject(v:*):void
		{
			if (v is DisplayObject)
				this.addChild(DisplayObject(v));
			
			super.addObject(v);
		}
		
		override public function removeObject(v:*):void
		{
			if (v is DisplayObject)
				this.removeChild(DisplayObject(v));
			
			super.removeObject(v);
		}
		
	}
}