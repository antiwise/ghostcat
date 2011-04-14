package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	
	import ghostcat.ui.UIConst;
	import ghostcat.util.core.ClassFactory;

	/**
	 * 提供多项分页列表
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GListGroupBase extends GListBase
	{
		public function GListGroupBase(skin:*=null, replace:Boolean=true, type:String=UIConst.HORIZONTAL, itemRender:*=null)
		{
			super(skin, replace, type, itemRender);
		}
		
		/**
		 * 建立一个分页Render，原本的itemRender属性失效
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
		 * 执行createPage后，需要用它来设置分页设置数据
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
		
		/**
		 * 执行createPage后，需要用它来来由数据获得元素
		 * @param v
		 * 
		 */
		public function getRenderInPage(v:*):DisplayObject
		{
			if (data)
			{
				for each (var child:Array in data)
				{
					if (child.indexOf(v) != -1)
					{
						var rep:GRepeater = getRender(child) as GRepeater;
						return rep ? rep.getRender(v) : null;
					}
				}
			}
			return null;
		}
	}
}