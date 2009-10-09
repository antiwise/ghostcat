package ghostcat.text
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	import ghostcat.ui.controls.GText;
	
	/**
	 * 文字缓动特效类
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class StringTween extends GText
	{
		/**
		 * 打散的文字实例 
		 */
		public var separateTexts:Array = [];
		
		public function StringTween(skin:*=null, replace:Boolean=true, separateTextField:Boolean=false, textPos:Point=null)
		{
			super(skin, replace, separateTextField, textPos);
		}
		
		/**
		 * 将文本打散成块，此后text属性将会无效化
		 * @param container
		 * 
		 */
		public function separateText(container:DisplayObjectContainer = null):void
		{
			destoryAllTexts();
			TextFieldUtil.separate(textField,container);
		}
		
		//销毁所有分散的文本
		private function destoryAllTexts():void
		{
			for each (var child:DisplayObject in separateTexts)
				child.parent.removeChild(child);
			
			separateTexts = [];
		}
	}
}