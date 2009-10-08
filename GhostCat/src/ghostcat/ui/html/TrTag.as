package ghostcat.ui.html
{
	import ghostcat.ui.UIConst;
	import ghostcat.ui.layout.LinearLayout;

	/**
	 * 表格列
	 * @author flashyiyi
	 * 
	 */
	public class TrTag extends GFrameView
	{
		public function TrTag()
		{
			super();
			
			var layout:LinearLayout = new LinearLayout();
			layout.type = UIConst.HORIZONTAL;
			setLayout(layout);
		}
		/** @inheritDoc*/
		protected override function init() : void
		{
			var table:TableTag = (parent.parent) ? (parent.parent as TableTag) : null;
			if (table && table.width)
				this.width = table.width;
			
			super.init();
		}
	}
}