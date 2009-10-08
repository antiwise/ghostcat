package ghostcat.ui.html
{
	import ghostcat.ui.UIConst;
	import ghostcat.ui.layout.LinearLayout;

	public class TrTag extends GFrameView
	{
		public function TrTag()
		{
			super();
			
			var layout:LinearLayout = new LinearLayout();
			layout.type = UIConst.HORIZONTAL;
			setLayout(layout);
		}
	}
}