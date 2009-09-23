package
{
	import flash.display.Sprite;
	
	import ghostcat.manager.RootManager;
	import ghostcat.operation.effect.ColorFlashEffect;
	import ghostcat.ui.containers.GVBox;
	import ghostcat.ui.controls.GRadioButton;
	import ghostcat.ui.controls.GRadioButtonGroup;
	import ghostcat.util.Util;
	
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
			
		}
	}
}