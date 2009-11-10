package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	import ghostcat.display.GBase;
	import ghostcat.display.screenshot.ScreenShotUtil;

	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	[SWF(width="600",height="450")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		
		protected override function init():void
		{
			var t:DisplayObject = new TestCollision();
			addChild(t);
			
//			registerClassAlias("point",Point);
			var b:ByteArray = new ByteArray();
			b.writeObject(new Point(123,123));
			b.position = 0;
			var o:* = b.readObject();
			
			
//			var b:Bitmap = new Bitmap(ScreenShotUtil.shotObject(t,new Rectangle(10,10,200,200)))
//			addChild(b);
//			t.alpha = 0.3;
		}
	}
}