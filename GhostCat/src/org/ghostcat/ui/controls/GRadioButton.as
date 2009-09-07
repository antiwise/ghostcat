package org.ghostcat.ui.controls
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import org.ghostcat.skin.RadioButtonIconSkin;
	import org.ghostcat.util.ClassFactory;
	
	/**
	 * 单选框
	 * 
	 * @author flashyiyi
	 *  
	 */
	public class GRadioButton extends GButton
	{
		public static var defaultSkin:ClassFactory = new ClassFactory(RadioButtonIconSkin);
		
		private var _groupName:String;
		
		/**
		 * 值
		 */
		public var value:*;
		
		public function GRadioButton(skin:MovieClip=null, replace:Boolean=true)
		{
			if (!skin)
				skin = defaultSkin.newInstance();
				
			this.textPos = new Point(15,0);
			this.toggle = true;
			
			super(skin, replace);
		}
		
		/**
		 * 所属的组
		 */
		public function get groupName():String
		{
			return _groupName;
		}

		public function set groupName(v:String):void
		{
			_groupName = v;
			var g:GRadioButtonGroup = GRadioButtonGroup.getGroupByName(v);
			g.addItem(this);
		}

		public override function set selected(v:Boolean) : void
		{
			super.selected = v;
			
			if (groupName)
			{
				var g:GRadioButtonGroup = GRadioButtonGroup.getGroupByName(groupName);
				g.selectedItem = this;
			}
		} 
		
		public override function destory():void
		{
			if (groupName)
			{
				var g:GRadioButtonGroup = GRadioButtonGroup.getGroupByName(groupName);
				g.removeItem(this);
			}
		}
	}
}