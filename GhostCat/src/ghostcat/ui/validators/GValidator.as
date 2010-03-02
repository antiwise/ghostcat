package ghostcat.ui.validators
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import ghostcat.ui.controls.GText;
	import ghostcat.ui.layout.Padding;
	import ghostcat.util.core.AbstractUtil;
	
	/**
	 * 数据验证器基类
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class GValidator extends GText
	{
		/**
		 * 默认未填显示信息
		 */
		public static var defaultRequiredFieldError:String = "此项类容不能为空";
		
		/**
		 * 默认触发事件
		 */
		public static var defaultTriggerEvent:String = Event.CHANGE;
		
		/**
		 * 数据源
		 */
		public var source:Object;
		
		/**
		 * 检测的属性 
		 */
		public var property:String; 
		
		/**
		 * 是否必填 
		 */
		public var required:Boolean; 
		
		private var _requiredFieldError:String;

		/**
		 * 未填显示信息 
		 */
		public function get requiredFieldError():String
		{
			return _requiredFieldError ? _requiredFieldError : defaultRequiredFieldError;
		}

		public function set requiredFieldError(value:String):void
		{
			_requiredFieldError = value;
		}
		
		private var _trigger:IEventDispatcher;

		/**
		 * 监听目标
		 */
		public function get trigger():IEventDispatcher
		{
			return _trigger ? _trigger : source as IEventDispatcher;
		}

		public function set trigger(value:IEventDispatcher):void
		{
			_trigger = value;
		}

		/**
		 * 监听事件 
		 */
		private var _triggerEvent:String;
		
		/** @inheritDoc*/
		public function get triggerEvent():String
		{
			return _triggerEvent ? _triggerEvent : defaultTriggerEvent;
		}

		public function set triggerEvent(value:String):void
		{
			_triggerEvent = value;
		}

		
		public function GValidator(skin:*=null, source:Object=null, property:String=null, replace:Boolean=true, separateTextField:Boolean=false, textPadding:Padding=null)
		{
			AbstractUtil.preventConstructor(this,GValidator);
			
			this.source = source;
			this.property = property;
			
			super(skin, replace, separateTextField, textPadding);
			
			trigger.addEventListener(triggerEvent,triggerHandler);
		}
		
		/** @inheritDoc*/
		public override function set enabled(v:Boolean) : void
		{
			if (super.enabled == v)
				return;
			
			super.enabled = v;
			
			if (v)
				trigger.addEventListener(triggerEvent,triggerHandler);
			else
				trigger.removeEventListener(triggerEvent,triggerHandler);
		}
		
		/**
		 * 变化事件
		 * @param event
		 * 
		 */
		protected function triggerHandler(event:Event):void
		{
			var v:* = source[property];
			if (!v && required)
				this.data = requiredFieldError;
			else
				this.data = null;
		}
		
		/** @inheritDoc*/
		public override function set data(v:*) : void
		{
			if (super.data == v)
				return;
			
			this.visible = super.data = v;
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			this.enabled = false;
			
			super.destory();
		}
		
	}
}