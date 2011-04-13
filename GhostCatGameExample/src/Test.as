package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import ghostcat.algorithm.traversal.FindNearPoint;
	import ghostcat.display.loader.StreamLoader;
	import ghostcat.display.loader.StreamTextLoader;
	import ghostcat.events.OperationEvent;
	import ghostcat.operation.LoadTextOper;
	import ghostcat.operation.server.SocketDataCreater;
	import ghostcat.ui.UIBuilder;
	import ghostcat.ui.containers.Group;
	import ghostcat.util.data.ByteArrayUtil;
	import ghostcat.util.display.DisplayLayoutAnalyse;
	import ghostcat.util.text.ANSI;
	import ghostcat.util.text.PinYin;
	
	public class Test extends Sprite
	{
		public function Test()
		{
			var bytes:ByteArray = new ByteArray();
			ByteArrayUtil.write7BitEncodeInt(bytes,100000);
			bytes.position = 0;
			trace(ByteArrayUtil.read7BitEncodeInt(bytes))
		}
	}
}