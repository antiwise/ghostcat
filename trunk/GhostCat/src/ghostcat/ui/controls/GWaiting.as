package com.kunlun.appceo.ui.popup
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	import ghostcat.util.display.Geom;
	
	public class GWaiting extends GText
	{
		private var _target:EventDispatcher;
		
		public function GWaiting(skin:* = null, target:EventDispatcher = null)
		{
			super(skin);
		
			this.target = target;
		}
		
		public function get target():EventDispatcher
		{
			return _target;
		}

		public function set target(value:EventDispatcher):void
		{
			if (_target == value)
				return;
			
			if (_target)
			{
				_target.removeEventListener(Event.COMPLETE,completeHandler);
				_target.removeEventListener(IOErrorEvent.IO_ERROR,completeHandler);
			}
			
			_target = value;
			
			if (_target)
			{
				_target.addEventListener(Event.COMPLETE,completeHandler);
				_target.addEventListener(IOErrorEvent.IO_ERROR,completeHandler);
			}
		}

		protected function completeHandler(event:Event):void
		{
			destory();
		}
		
		public function addTo(target:DisplayObjectContainer = null,rect:DisplayObjectContainer = null):void
		{
			if (!rect)
				rect = target;
			
			target.addChild(this);
			Geom.centerIn(this,rect);
		}
		
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			this.target = null;
			
			super.destory();
		}
		
	}
}