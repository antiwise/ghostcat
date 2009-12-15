package ghostcat.display.game
{
	import flash.display.Sprite;
	
	import ghostcat.display.GNoScale;
	
	public class AbilityGraphic extends GNoScale
	{
		public var graphicsLayer:Sprite;
		public function AbilityGraphic(skin:*=null, replace:Boolean=true)
		{
			super(skin, replace);
			
			this.graphicsLayer = new Sprite();
		}
		
		public override function set data(v:*) : void
		{
			super.data = v;
			vaildDisplayList();
		}
		
		
		
		protected override function updateDisplayList() : void
		{
			super.updateDisplayList();
			
		}
	}
}