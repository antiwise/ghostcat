package ghostcat.ui.controls
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import ghostcat.skin.RadioButtonIconSkin;
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.core.ClassFactory;
	
	/**
	 * 单选框
	 * 
	 * 标签规则：当作按钮转换
	 * 
	 * @author flashyiyi
	 *  
	 */
	public class GRadioButton extends GButton
	{
		public static var defaultSkin:* = RadioButtonIconSkin;
		
		private var _groupName:String;
		
		
		/**
		 * data中作为value的字段
		 */
		public var valueField:String;
		
		private var _value:*;
		
		public function GRadioButton(skin:*=null, replace:Boolean=true, separateTextField:Boolean = false, textPadding:Padding=null, autoRefreshLabelField:Boolean = true)
		{
			if (!skin)
				skin = defaultSkin;
			
			super(skin, replace,separateTextField,textPadding,autoRefreshLabelField);
			
			textStartPoint = new Point(15,0);
		}
		
		
		/**
		 * 值
		 */
		public function get value():*
		{
			return valueField ? data[valueField] :_value;
		}

		public function set value(v:*):void
		{
			if (valueField)
			{
				if (data == null)
					data = new Object();
					
				super.data[valueField] = v;
			}
			else
				_value = v;
		}

		/**
		 * 所属的组名
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
		/** @inheritDoc*/
		public override function set selected(v:Boolean) : void
		{
			if (super.selected == v)
				return;
			
			super.selected = v;
			
			if (groupName && v)
			{
				var g:GRadioButtonGroup = GRadioButtonGroup.getGroupByName(groupName);
				g.selectedItem = this;
			}
		} 
		/** @inheritDoc*/
		protected override function clickHandler(event:MouseEvent):void
		{
			super.clickHandler(event);
			
			this.selected = true;
		}
		/** @inheritDoc*/
		public override function destory():void
		{
			if (destoryed)
				return;
			
			if (groupName)
			{
				var g:GRadioButtonGroup = GRadioButtonGroup.getGroupByName(groupName);
				g.removeItem(this);
			}
			
			super.destory();
		}
	}
}