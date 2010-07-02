package ghostcat.ui.controls
{
	import ghostcat.ui.UIConst;
	import ghostcat.ui.containers.GRepeater;
	import ghostcat.util.core.ClassFactory;

	/**
	 * 提供一个新方法实现多项分页列表
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
		 * 
		 * @param itemRender	渲染器
		 * @param type	布局类型
		 * @param w		宽度
		 * @param h		高度
		 * @return 
		 * 
		 */
		public function createPage(itemRender:*, type:String = "tile" ,w:Number = NaN,h:Number = NaN, initObj:Object = null):void
		{
			var o:Object = {
				type : type,
				toggleOnClick : false,
				itemRender : itemRender,
				width : w,
				height : h
			};
			
			if (initObj)
			{
				for (var p:String in initObj)
					o[p] = initObj[p];
			}
			
			this.autoReszieItemContent = false;
			this.itemRender = new ClassFactory(GRepeater,o);
		}
		
		/**
		 * 分页设置数据 
		 * @param source
		 * @param pageLen	每页数据个数
		 * 
		 */
		public function setPageData(source:Array,pageLen:int = 1):void
		{
			var len:int = Math.ceil(source.length / pageLen);
			var result:Array = [];
			for (var i:int = 0;i < len;i++)
			{
				result[i] = source.slice(i * pageLen,(i + 1) * pageLen);
			}
			this.data = result;
		}
	}
}