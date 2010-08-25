package ghostcat.ui.controls
{
	import flash.geom.ColorTransform;
	import flash.text.TextFormat;
	
	import ghostcat.operation.Oper;
	import ghostcat.operation.SoundOper;
	import ghostcat.operation.effect.IEffect;
	import ghostcat.util.Util;

	/**
	 * 按钮状态
	 * @author flashyiyi
	 * 
	 */
	public class GButtonState
	{
		/**
		 * 将未设置的状态置为默认值
		 */
		public static var resetToDefault:Boolean = true;
		
		/**
		 * 鼠标状态对应的颜色变化 
		 */
		public var colorTransform:ColorTransform;
		
		/**
		 * 鼠标状态对应的filters变化
		 */		
		public var filters:Array;
		
		/**
		 * 鼠标状态对应的skin变化
		 */		
		public var skin:*;
		
		/**
		 * 鼠标状态对应的Oper
		 */
		public var oper:Oper;
		
		/**
		 * 鼠标状态对应的声音
		 */
		public var sound:*;
		
		/**
		 * 文字样式
		 */
		public var textFormat:*;
		
		/**
		 * 是否重置默认文字样式。设置后中途修改文字将不会恢复原本的颜色。
		 */
		public var overrideDefaultTextFormat:Boolean = false;
		
		public function parse(target:GButtonLite):void
		{
			if (skin)
				target.setPartContent(skin);
			
			if (colorTransform != null)
				target.content.transform.colorTransform = colorTransform;
			else if (resetToDefault)
				target.content.transform.colorTransform = new ColorTransform();
				
			if (filters != null)
				target.content.filters = filters;
			else if (resetToDefault)
				target.content.filters = [];
			
			if (oper)
			{
				if (oper is IEffect && !(oper as IEffect).target)
					(oper as IEffect).target = target.content;
				
				oper.execute();
			}
			
			if (sound)
			{
				if (!(sound is SoundOper))
					sound = new SoundOper(sound);
				
				(sound as SoundOper).execute();
			}
			
			if (target is GButtonBase && (target as GButtonBase).labelTextField)
			{
				var textField:GText = (target as GButtonBase).labelTextField;
				if (textFormat)
				{
					var t:TextFormat;
					if (textFormat is TextFormat)
						t = textFormat as TextFormat;
					else
						t = Util.createObject(TextFormat,textFormat);
					
					textField.applyTextFormat(t,overrideDefaultTextFormat);
				}
//				else if (resetToDefault)
//				{
//					textField.applyTextFormat();
//				}
			}
		}
		
		/**
		 * 复制 
		 * @return 
		 * 
		 */
		public function clone():GButtonState
		{
			var v:GButtonState = new GButtonState();
			v.colorTransform = this.colorTransform;
			v.filters = this.filters;
			v.skin = this.skin;
			v.oper = this.oper;
			return v;
		}
	}
}