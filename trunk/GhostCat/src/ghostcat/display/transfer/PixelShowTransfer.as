package ghostcat.display.transfer
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.ui.UIConst;
	
	/**
	 * 以像素线（未显示部分以最末的像素进行复制）的方式呈现图像
	 * @author flashyiyi
	 * 
	 */
	public class PixelShowTransfer extends GTransfer
	{
		private var _direct:String;

		/**
		 * 方向
		 */
		public function get direct():String
		{
			return _direct;
		}

		/**
		 * @private
		 */
		public function set direct(value:String):void
		{
			_direct = value;
			renderTarget();
		}

		private var pieceBitmapData:BitmapData;
		
		private var _step:Number = 1;
		
		/**
		 * 比例
		 * @return 
		 * 
		 */
		public function get step():Number
		{
			return _step;
		}
		
		public function set step(value:Number):void
		{
			_step = value;
			showBitmapData();
		}
		
		/**
		 * 线长
		 */
		public var lineLength:int;
		
		public function PixelShowTransfer(target:DisplayObject=null,direct:String="right")
		{
			super(target);
			this.direct = direct;
		}
		
		/** @inheritDoc*/
		protected override function showBitmapData() : void
		{
			var rect: Rectangle = _target.getBounds(_target);
			
			graphics.clear();
			graphics.beginBitmapFill(bitmapData);
			
			switch (direct)
			{
				case UIConst.LEFT:
					graphics.drawRect(bitmapData.width * (1 - step),0,bitmapData.width * step,bitmapData.height);
					graphics.endFill();
					if (step != 1.0)
					{
						pieceBitmapData.copyPixels(bitmapData,new Rectangle(bitmapData.width * (1 - step),0,1,bitmapData.height),new Point());
						graphics.beginBitmapFill(pieceBitmapData,null,true);
						graphics.drawRect(-lineLength,0,lineLength + bitmapData.width * (1 - step),height);
						graphics.endFill();
					}
					break;
				case UIConst.RIGHT:
					graphics.drawRect(0,0,bitmapData.width * step,bitmapData.height);
					graphics.endFill();
					if (step != 1.0)
					{
						pieceBitmapData.copyPixels(bitmapData,new Rectangle(bitmapData.width * step,0,1,bitmapData.height),new Point());
						graphics.beginBitmapFill(pieceBitmapData,null,true);
						graphics.drawRect(bitmapData.width * step,0,lineLength + bitmapData.width * (1 - step),height);
						graphics.endFill();
					}
					break;
				case UIConst.UP:
					graphics.drawRect(0,bitmapData.height * (1 - step),bitmapData.width,bitmapData.height * step);
					graphics.endFill();
					if (step != 1.0)
					{
						pieceBitmapData.copyPixels(bitmapData,new Rectangle(0,bitmapData.height * (1 - step),bitmapData.width,1),new Point());
						graphics.beginBitmapFill(pieceBitmapData,null,true);
						graphics.drawRect(0,-lineLength,width,lineLength + bitmapData.height * (1 - step));
						graphics.endFill();
					}
					break;
				case UIConst.DOWN:
					graphics.drawRect(0,0,bitmapData.width,bitmapData.height * step);
					graphics.endFill();
					if (step != 1.0)
					{
						pieceBitmapData.copyPixels(bitmapData,new Rectangle(0,bitmapData.height * step,bitmapData.width,1),new Point());
						graphics.beginBitmapFill(pieceBitmapData,null,true);
						graphics.drawRect(0,bitmapData.height * step,width,lineLength + bitmapData.height * (1 - step));
						graphics.endFill();
					}
					break;
			}
		}
		
		protected override function renderTarget():void
		{
			var rect: Rectangle = _target.getBounds(_target);
			var m:Matrix = new Matrix();
			m.translate(-rect.x, -rect.y);
			bitmapData.fillRect(bitmapData.rect,0);
			bitmapData.draw(_target,m);
			
			if (pieceBitmapData)
				pieceBitmapData.dispose();
			
			if (direct == UIConst.LEFT || direct == UIConst.RIGHT)
				pieceBitmapData = new BitmapData(1,bitmapData.height);
			else
				pieceBitmapData = new BitmapData(bitmapData.width,1);
					
			showBitmapData();
		}
		
		public override function destory():void
		{
			if (pieceBitmapData)
				pieceBitmapData.dispose();
			
			super.destory();
		}
	}
}