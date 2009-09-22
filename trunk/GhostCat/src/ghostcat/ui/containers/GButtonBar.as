package ghostcat.ui.containers
{
	import ghostcat.ui.controls.GButton;

	[Event(name="item_click",type="ghostcat.events.ItemClickEvent")]
	public class GButtonBar extends GRepeater
	{
		private var _labelField:String;
		
		public function GButtonBar(skin:*=null, replace:Boolean=true,ref:* = null)
		{
			if (!ref)
				ref = GButton;
			
			super(skin, replace,ref);
		}
		
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
					obj.labelField = labelField;
			}
		}

		public override function set data(v:*) : void
		{
			super.data = v;
			
			labelField = labelField;
		}
	}
}