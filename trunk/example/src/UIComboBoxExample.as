package
{
	import ghostcat.display.GSprite;
	import ghostcat.display.residual.ResidualScreen;
	import ghostcat.ui.controls.GComboBox;
	import ghostcat.ui.controls.GVSilder;
	import ghostcat.util.Util;
	
	[SWF(width="600",height="600")]
	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	/**
	 * 演示了ComboBox的效果，顺便放了Slider上来。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class UIComboBoxExample extends GSprite
	{
		protected override function init():void
		{	
			var b:GComboBox = new GComboBox();
			b.data = 10;
			b.x = 100;
			b.y = 50;
			
			var arr:Array = [];
			for (var i:int = 0;i < 1000000;i++)
				arr.push(i.toString());
			b.listData = arr;
			addChild(b)
			
			var s:GVSilder = new GVSilder();
			s.x = 50;
			s.y = 50;
			addChild(s);
			
			addChild(Util.createObject(new ResidualScreen(s.width + 10,s.height + 10),{x:45,y:45,refreshInterval:30,fadeSpeed:0.8,blurSpeed:3,items:[s.thumb]}));
		}
	}
}