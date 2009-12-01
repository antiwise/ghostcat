package
{
	import flash.geom.Rectangle;
	
	import ghostcat.debug.DebugRect;
	import ghostcat.debug.EnabledSWFScreen;
	import ghostcat.display.GSprite;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.effect.ColorFlashEffect;
	import ghostcat.operation.effect.FlashEffect;
	import ghostcat.ui.containers.GDrawerPanel;
	import ghostcat.ui.containers.GToggleButtonBar;
	import ghostcat.ui.containers.GVBox;
	import ghostcat.ui.controls.GNumbericStepper;
	import ghostcat.ui.controls.GRadioButton;
	import ghostcat.ui.controls.GRadioButtonGroup;
	import ghostcat.ui.layout.LayoutUtil;
	import ghostcat.util.Util;
	import ghostcat.util.easing.TweenUtil;
	
	[SWF(width="500",height="500")]
	[Frame(factoryClass="ghostcat.ui.RootLoader")]
	
	/**
	 * 此类稍微演示了下VBox布局和RadioButton的用法。
	 * 布局并不是ghostcat的重点。
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class UIBoxExample extends GSprite
	{
		protected override function init():void
		{
			new EnabledSWFScreen(stage);
			
			RootManager.register(this);
			
			//单选框
			var box:GVBox = new GVBox();
			addChild(box);
			
			box.addChild(Util.createObject(new GRadioButton(),{label:"1",value:1,groupName:"a"}));
			box.addChild(Util.createObject(new GRadioButton(),{label:"2",value:2,groupName:"a"}));
			box.addChild(Util.createObject(new GRadioButton(),{label:"3",value:3,groupName:"a"}));
			
			var g:GRadioButtonGroup = GRadioButtonGroup.getGroupByName("a");
			g.selectedValue = 1;
			
			new ColorFlashEffect(box,1000,0xFF0000).execute();
			
			//按钮
			var b:GToggleButtonBar = new GToggleButtonBar();
			b.x = 200;
			b.data = ["1","2","3"];
			addChild(b);
			
			new FlashEffect(b,1000).execute();
			
			//数字
			var t:GNumbericStepper = new GNumbericStepper();
			t.prefix = "$";
			t.setValue(100);
			t.editable = true;
			t.autoSelect = true;
			t.maxValue = 100;
			addChild(t);
			
			LayoutUtil.center(t,stage,0,0);//同样可以像这样直接布局
			
			//抽屉
			var vbox:GVBox = new GVBox();
			vbox.y = 200;
			addChild(vbox);
			
			vbox.addChild(new GDrawerPanel(new DebugRect(100,100,0xFF0000,"抽屉1"),true,new Rectangle(0,0,100,20)));
			vbox.addChild(new GDrawerPanel(new DebugRect(100,100,0x00FF00,"抽屉2"),true,new Rectangle(0,0,100,20)));
			vbox.addChild(new GDrawerPanel(new DebugRect(100,100,0x0000FF,"抽屉3"),true,new Rectangle(0,0,100,20)));
		}
	}
}