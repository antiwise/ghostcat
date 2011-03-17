package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import ghostcat.display.residual.FireScreen;
	import ghostcat.display.residual.ResidualScreen;
	import ghostcat.filter.ConvolutionFilterProxy;
	import ghostcat.filter.DisplacementMapFilterProxy;
	import ghostcat.filter.PerlinNoiseCacher;
	import ghostcat.parse.display.DrawParse;
	import ghostcat.parse.display.TextFieldParse;
	import ghostcat.ui.controls.GText;
	import ghostcat.util.MathUtil;
	import ghostcat.util.data.ConversionUtil;
	import ghostcat.util.data.Json;
	import ghostcat.util.display.MatrixUtil;
	
	public class Test extends Sprite
	{
		private var t:TextField;

		private var p1:PerlinNoiseCacher;

		private var p2:PerlinNoiseCacher;

		public function Test()
		{
			t = new TextField();
			t.text = "剑";
			t.scaleX = 20;
			t.scaleY = 20;
			
			p1 = new PerlinNoiseCacher(1000,500,20);
			p1.create(8,8,1,getTimer());
			
			p2 = new PerlinNoiseCacher(1000,500,20);
			p2.create(36,36,1,getTimer());
		
			addChild(t);
		
			addEventListener(Event.ENTER_FRAME,tickHandler);
		}
		
		protected function tickHandler(event:Event):void
		{
			var mask1:BitmapData = p1.getBitmapData(getTimer() / 1000);
			var mask2:BitmapData = p2.getBitmapData(getTimer() / 1000);;
			
			t.filters = [new DisplacementMapFilter(mask1,new Point(),BitmapDataChannel.RED,BitmapDataChannel.GREEN,10,10),new DisplacementMapFilter(mask2,new Point(),BitmapDataChannel.RED,BitmapDataChannel.GREEN,40,40)]
		}
		
	}
}