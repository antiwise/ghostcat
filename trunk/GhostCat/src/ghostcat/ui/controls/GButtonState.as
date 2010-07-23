package ghostcat.ui.controls
{
	import flash.geom.ColorTransform;
	
	import ghostcat.operation.Oper;
	import ghostcat.operation.SoundOper;
	import ghostcat.operation.effect.IEffect;

	/**
	 * 按钮状态
	 * @author flashyiyi
	 * 
	 */
	public class GButtonState
	{
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
		
		public function parse(target:GButtonLite):void
		{
			if (skin)
				target.setPartContent(skin);
			
			target.content.transform.colorTransform = colorTransform ? colorTransform : new ColorTransform();
			target.content.filters = filters ? filters : [];
			
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