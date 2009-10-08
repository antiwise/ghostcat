package ghostcat.ui.html
{
	import ghostcat.ui.UIConst;
	import ghostcat.ui.layout.LinearLayout;

	public class TdTag extends GFrameView
	{
		public function TdTag()
		{
			super();
			
			var layout:LinearLayout = new LinearLayout();
			layout.type = UIConst.VERTICAL;
			setLayout(layout);
		}
	}
}