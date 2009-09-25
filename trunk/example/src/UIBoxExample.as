package
{
	import flash.display.Sprite;
	
	import ghostcat.manager.RootManager;
	import ghostcat.operation.effect.ColorFlashEffect;
	import ghostcat.operation.effect.FlashEffect;
	import ghostcat.ui.containers.GAlert;
	import ghostcat.ui.containers.GButtonBar;
	import ghostcat.ui.containers.GVBox;
	import ghostcat.ui.controls.GRadioButton;
	import ghostcat.ui.controls.GRadioButtonGroup;
	import ghostcat.util.Util;
	
	/**
	 * 此类稍微演示了下VBox布局和RadioButton的用法。
	 * 布局并不是ghostcat的重点。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class UIBoxExample extends Sprite
	{
		public function UIBoxExample()
		{
			RootManager.register(this);
			
			var box:GVBox = new GVBox();
			addChild(box);
			
			box.addObject(Util.createObject(new GRadioButton(),{label:"1",value:1,groupName:"a"}));
			box.addObject(Util.createObject(new GRadioButton(),{label:"2",value:2,groupName:"a"}));
			box.addObject(Util.createObject(new GRadioButton(),{label:"3",value:3,groupName:"a"}));
			
			var g:GRadioButtonGroup = GRadioButtonGroup.getGroupByName("a");
			g.selectedValue = 1;
			
			new ColorFlashEffect(box,1000,0xFF0000).execute();
			
			var b:GButtonBar = new GButtonBar();
//			b.width = 100;
			b.x = 200;
			b.data = ["1","2","3"];
			addChild(b);
			
			new FlashEffect(b,1000).execute();
			
			GAlert.show("测试","测试",b.data)
			
		}
	}
}