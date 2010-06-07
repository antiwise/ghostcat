package ghostcat.ui.controls
{
	import ghostcat.ui.UIConst;
	import ghostcat.ui.containers.GRepeater;
	import ghostcat.util.core.ClassFactory;

	/**
	 * 提供一个新方法实现分页滚动
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GListGroupBase extends GListBase
	{
		public function GListGroupBase(skin:*=null, replace:Boolean=true, type:String=UIConst.VERTICAL, itemRender:*=null)
		{
			super(skin, replace, type, itemRender);
		}
		
		/**
		 * 建立一个分页Render 
		 * @param itemRender
		 * @param type
		 * @param w
		 * @param h
		 * @return 
		 * 
		 */
		public function createPage(itemRender:*, type:String = "tile" ,w:Number = NaN,h:Number = NaN):void
		{
			this.itemRender = new ClassFactory(GRepeater,{
				type : type,
				toggleOnClick : false,
				itemRender : itemRender,
				width : w,
				height : h
			})
		}
	}
}