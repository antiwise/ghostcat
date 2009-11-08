package ghostcat.text
{
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.text.TextLineMetrics;
	
	import ghostcat.display.GSprite;
	import ghostcat.ui.controls.GText;
	import ghostcat.ui.layout.Padding;
	
	/**
	 * 上下渐变显示的文字（仍然可编辑）
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GradientText extends GText
	{
		private var _fromColor:uint = 0xFF0000;
		private var _toColor:uint = 0xFF00FF;
		
		private var gradientLayer:Shape;
		
		/**
		 * 开始颜色 
		 * @return 
		 * 
		 */
		public function get toColor():uint
		{
			return _toColor;
		}

		public function set toColor(value:uint):void
		{
			_toColor = value;
			renderGradient()
		}

		/**
		 * 结束颜色 
		 * @return 
		 * 
		 */
		public function get fromColor():uint
		{
			return _fromColor;
		}

		public function set fromColor(value:uint):void
		{
			_fromColor = value;
			renderGradient()
		}
		
		public function GradientText(skin:*=null, replace:Boolean=true, separateTextField:Boolean=false, textPadding:Padding=null)
		{
			super(skin, replace, separateTextField, textPadding);
		
			var container:GSprite = new GSprite(textField);
			textField.blendMode = BlendMode.ALPHA;
			container.blendMode = BlendMode.LAYER;
			
			this.gradientLayer = new Shape();
			container.addChildAt(this.gradientLayer,0)
			
			textField.addEventListener(Event.CHANGE,changeHandler);
			renderGradient();
		}
		
		private function changeHandler(event:Event):void
		{
			renderGradient();
		}
		
		/**
		 * 绘制底部渐变色 
		 * 
		 */
		public function renderGradient():void
		{
			gradientLayer.graphics.clear();
			for (var i:int = 0;i < textField.numLines;i++)
			{
				var lm:TextLineMetrics = textField.getLineMetrics(i);
				var lx:Number = lm.x;
				var ly:Number = lm.height * i + 2 + textField.y;
				var m:Matrix = new Matrix();
				m.createGradientBox(lm.width,lm.height,Math.PI / 2,lx,ly);
				gradientLayer.graphics.beginGradientFill(GradientType.LINEAR,[fromColor,toColor],[1,1],[0,255],m);
				gradientLayer.graphics.drawRect(lx,ly,lm.width,lm.height);
				gradientLayer.graphics.endFill();
			}
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			textField.removeEventListener(Event.CHANGE,changeHandler);
			
			super.destory();
		}
	}
}