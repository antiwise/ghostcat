package
{
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.text.GradientText;
	import ghostcat.ui.containers.GScrollPanel;
	import ghostcat.ui.html.SimpleHTML;

	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	[SWF(width="600",height="450")]
	/**
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class TestExample extends GBase
	{
		
		protected override function init():void
		{
			super.init();
			
			var v:GradientText = new GradientText();
			v.filters = [new DropShadowFilter()];
			v.editable = true;
			v.multiline = true;
//			addChild(v);
			v.text = "123asdfasdfasdfasdfsdf\nsdfsd";
			v.renderGradient();
			
			var p:SimpleHTML = new SimpleHTML();
			p.htmlText = "<html><font color='#FF0000'>123213</font><image width='300' height='300' url='dance.gif'/><font color='#FFFF00'>aaaa</font></html>";
			p.appendText(p.htmlText);
			var s:GScrollPanel = new GScrollPanel(new TestCollision(),true);
			s.addVScrollBar();
			addChild(s);
		}
	}
}