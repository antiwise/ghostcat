package ghostcat.ui.html
{
	import ghostcat.ui.UIConst;
	import ghostcat.ui.layout.LinearLayout;
	
	
	/**
	 * 表格
	 * @author flashyiyi
	 * 
	 */
	public class TableTag extends GFrameView
	{
		public function TableTag()
		{
			super();
			
			var layout:LinearLayout = new LinearLayout();
			layout.type = UIConst.VERTICAL;
			setLayout(layout);
		}
	}
}