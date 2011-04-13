package ghostcat.ui
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * 焦点管理类 
	 * @author flashyiyi
	 * 
	 */
	public class Focus extends EventDispatcher
	{
		/**
		 * 组件的二维数组 
		 */
		public var controls:Array = [];
		
		/**
		 * 是否激活方向控制 
		 */
		public var enabledDirection:Boolean = true;
		
		/**
		 * 是否激活回车 
		 */
		public var enabledEnterTab:Boolean = false;
		
		/**
		 * 当前行 
		 */
		public var rowIndex:int;
		
		/**
		 * 当前列
		 */
		public var columnIndex:int;
		
		/**
		 * 目标
		 */
		private var _target:InteractiveObject;
		
		public function get target():InteractiveObject
		{
			return _target;
		}

		public function set target(value:InteractiveObject):void
		{
			if (_target)
				_target.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			
			_target = value;
			
			if (_target)
				_target.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
		}

		/**
		 * 当前焦点 
		 */
		public function get currentFocus():InteractiveObject
		{
			return controls[rowIndex][columnIndex];
		};
		
		public function set currentFocus(v:InteractiveObject):void
		{
			for (var i:int = 0; i < controls.length;i++)
			{
				var index:int = (controls[i] as Array).indexOf(v);
				if (index != -1)
				{
					rowIndex = i;
					columnIndex = index;
					return;
				}
			}
			
			if (target.stage)
				target.stage.focus = v;
		}
		
		public function Focus(target:InteractiveObject = null)
		{
			this.target = target;
		}
		
		/**
		 * 添加一行组件 
		 * @param params
		 * 
		 */
		public function addLine(...params):void
		{
			controls.push(params);
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.UP:
					if (enabledDirection)
						up();
					break;
				case Keyboard.DOWN:
					if (enabledDirection)
						down();
					break;
				case Keyboard.LEFT:
					if (enabledDirection)
						prev();
					break;
				case Keyboard.RIGHT:
					if (enabledDirection)
						next();
					break;
				case Keyboard.TAB:
					next();
					break;
				case Keyboard.ENTER:
					if (enabledEnterTab)
						next();
					break;
			}
		}
		
		private function setFocus(v:InteractiveObject):void
		{
			if (target.stage)
				target.stage.focus = v;
		}
		
		private function getNextLine():int
		{
			if (rowIndex < controls.length - 1)
				return rowIndex + 1;
			else
				return 0;
		}
		
		private function getPrevLine():int
		{
			if (rowIndex > 0)
				return rowIndex - 1;
			else
				return controls.length - 1;
		}
		
		/**
		 * 下一个 
		 * 
		 */
		public function next():void
		{
			if (columnIndex < controls[rowIndex].length - 1)
				columnIndex ++;
			else
			{
				rowIndex = getNextLine();
				columnIndex = 0;
			}
			setFocus(currentFocus);
		}
		
		/**
		 * 上一个 
		 * 
		 */
		public function prev():void
		{
			if (columnIndex > 0)
				columnIndex --;
			else
			{
				rowIndex = getPrevLine();
				columnIndex = controls[rowIndex].length - 1;
			}
			setFocus(currentFocus);
		}
		
		/**
		 * 上一行 
		 * 
		 */
		public function up():void
		{
			var line:int = getPrevLine();
			if (controls[line].length <= columnIndex)
				columnIndex = controls[line].length - 1;
			rowIndex = line;
			setFocus(currentFocus);
		}
		
		/**
		 * 下一行 
		 * 
		 */
		public function down():void
		{
			var line:int = getNextLine();
			if (controls[line].length <= columnIndex)
				columnIndex = controls[line].length - 1;
			rowIndex = line;
			setFocus(currentFocus);
		}
		
		/**
		 * 销毁 
		 * 
		 */
		public function destory():void
		{
			target = null;
		}
		
	}
}