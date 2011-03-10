package ghostcat.display.g3d
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.TriangleCulling;
	import flash.geom.Point;
	
	/**
	 * 全景 
	 * @author flashyiyi
	 * 
	 */
	public class Panoramic extends GBitmapSphere
	{
		public var hotSpots:Array = [];
		public function Panoramic(material:BitmapData, radius:Number=100, nMesh:int=30)
		{
			super(material, radius, nMesh);
			this.culling = TriangleCulling.NEGATIVE;
		}
		
		/**
		 * 添加热点 
		 * @param p
		 * @param userObject
		 * 
		 */
		public function addHotSpot(p:Point,userObject:DisplayObject):void
		{
			var hotSpot:HotSpot = new HotSpot(this,p,userObject);
			hotSpots.push(hotSpot);
		}
		
		/**
		 * 同步所有热点图形 
		 * 
		 */
		public function renderHotSpots():void
		{
			for each (var spot:HotSpot in hotSpots)
				spot.render();
		}
		
		public override function render():void
		{
			super.render();
			renderHotSpots();
		}
	}
}