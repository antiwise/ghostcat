package ghostcat.ui.html
{
	import ghostcat.ui.UIConst;
	import ghostcat.ui.layout.LinearLayout;

	/**
	 * 表格列
	 * @author flashyiyi
	 * 
	 */
	public class TdTag extends GFrameView
	{
		public function TdTag()
		{
			super();
			
			var layout:LinearLayout = new LinearLayout();
			layout.type = UIConst.VERTICAL;
			layout.enabledMeasureChildren = false;//TD暂时不根据内容变化
			setLayout(layout);
		}
		/** @inheritDoc*/
		protected override function init() : void
		{
			var tr:TrTag = (parent.parent) ? (parent.parent as TrTag) : null;
			if (tr && tr.height)
				this.height = tr.height;
			
			super.init();
		}
	}
}