package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.layout.LinearLayout;

	[Event(name="item_click",type="ghostcat.events.ItemClickEvent")]
	/**
	 * 按钮条
	 * 
	 * 标签规则：子对象的render将会被作为子对象的默认skin
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GButtonBar extends GRepeater
	{
		private var _labelField:String;
		
		public function GButtonBar(skin:*=null, replace:Boolean=true,ref:* = null,fields:Object = null)
		{
			if (!ref)
				ref = GButton;
			
			super(skin, replace,ref);
		}
		
		/**
		 * 按钮条的label字段
		 * @return 
		 * 
		 */
		public function get labelField():String
		{
			return _labelField;
		}

		public function set labelField(v:String):void
		{
			_labelField = v;
			for (var i:int = 0;i < contentPane.numChildren;i++)
			{
				var obj:GButton = contentPane.getChildAt(i) as GButton;
				if (obj)
				{
					obj.labelField = labelField;
					obj.data = obj.data;
				}
			}
		}
		/** @inheritDoc*/
		public override function set data(v:*) : void
		{
			super.data = v;
			
			this.labelField = labelField;
			layout.invalidateLayout();
		}
	}
}