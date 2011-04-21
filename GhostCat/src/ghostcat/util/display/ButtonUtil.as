package ghostcat.util.display
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	import ghostcat.util.sleep.SleepCheck;

	/**
	 * 按钮简易类，用静态方法将显示对象转换为按钮。
	 * 如果遇到有标签的按钮，可以对标签执行单独的方法，并将参数eventDispatcher指定为按钮。
	 * 按钮是否选中可以通过按钮目前的状况来判断，诸如currentFrame
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class ButtonUtil
	{
		/**
		 * 包装一个电影剪辑成为按钮 
		 * @param skin
		 * @param toggle
		 * @param clickHandler
		 * @param eventDispatcher	指定监听事件的对象
		 * 
		 */
		static public function packFrameButton(skin:MovieClip,toggle:Boolean = false,clickHandler:Function = null,eventDispatcher:IEventDispatcher = null):void
		{
			if (!eventDispatcher)
				eventDispatcher = skin;
			
			packButton(eventDispatcher,toggle,setButtonStateHandler,clickHandler);
			
			function setButtonStateHandler(state:int):void
			{
				skin.gotoAndStop(state + 1);
			}
		}
		
		/**
		 * 包装一个位图为位图按钮 
		 * @param skin
		 * @param bitmapDatas
		 * @param clickHandler
		 * @param eventDispatcher	指定监听事件的对象
		 * 
		 */
		static public function packBitmapButton(skin:Bitmap,bitmapDatas:Array,clickHandler:Function = null,eventDispatcher:IEventDispatcher = null):void
		{
			if (!eventDispatcher)
				eventDispatcher = skin;
			
			packButton(eventDispatcher,bitmapDatas.length > 3,setButtonStateHandler,clickHandler);
			
			function setButtonStateHandler(state:int):void
			{
				skin.bitmapData = bitmapDatas[state];
			}
		}
		
		/**
		 * 包装一个显示对象成为按钮，用颜色变换区分状态 
		 * @param skin
		 * @param states
		 * @param clickHandler
		 * @param eventDispatcher	指定监听事件的对象
		 * 
		 */
		static public function packColorTranferButton(skin:DisplayObject,states:Array,clickHandler:Function = null,eventDispatcher:IEventDispatcher = null):void
		{
			if (!eventDispatcher)
				eventDispatcher = skin;
			
			packButton(eventDispatcher,states.length > 3,setButtonStateHandler,clickHandler);
			
			function setButtonStateHandler(state:int):void
			{
				if (states[state] is Number)
				{
					var ctf:ColorTransform = new ColorTransform();
					ctf.color = states[state];
					skin.transform.colorTransform = ctf;
				}
				else
				{
					skin.transform.colorTransform = states[state] as ColorTransform;
				}
			}
		}
		
		/**
		 * 包装一个显示对象成为按钮，用滤镜区分状态 
		 * @param skin
		 * @param states
		 * @param clickHandler
		 * @param eventDispatcher	指定监听事件的对象
		 * 
		 */
		static public function packFilterButton(skin:DisplayObject,states:Array,clickHandler:Function = null,eventDispatcher:IEventDispatcher = null):void
		{
			if (!eventDispatcher)
				eventDispatcher = skin;
			
			packButton(eventDispatcher,states.length > 3,setButtonStateHandler,clickHandler);
			
			function setButtonStateHandler(state:int):void
			{
				skin.filters = states[state] is Array ? states[state] : [states[state]];
			}
		}
		
		/**
		 * 包装一个显示对象成为按钮，用变换矩阵区分状态 
		 * @param skin
		 * @param states
		 * @param clickHandler
		 * @param eventDispatcher	指定监听事件的对象
		 * 
		 */
		static public function packMatrixButton(skin:DisplayObject,states:Array,clickHandler:Function = null,eventDispatcher:IEventDispatcher = null):void
		{
			if (!eventDispatcher)
				eventDispatcher = skin;
			
			packButton(eventDispatcher,states.length > 3,setButtonStateHandler,clickHandler);
			
			function setButtonStateHandler(state:int):void
			{
				skin.transform.matrix = states[state] as Matrix;
			}
		}
		
		static public function packButton(eventDispatcher:IEventDispatcher,toggle:Boolean,setButtonStateHandler:Function,clickHandler:Function = null):void
		{
			var mouseOver:Boolean;
			var mouseDown:Boolean;
			var selected:Boolean;
			
			eventDispatcher.addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			eventDispatcher.addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			eventDispatcher.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			eventDispatcher.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			eventDispatcher.addEventListener(MouseEvent.CLICK,mcClickHandler);
			
			refreshButtonState(mouseOver,mouseDown,selected);
			
			function mouseUpHandler(event:MouseEvent):void
			{
				mouseDown = true;
				refreshButtonState(mouseOver,mouseDown,selected);
			}
			
			function mouseDownHandler(event:MouseEvent):void
			{
				mouseDown = false;
				refreshButtonState(mouseOver,mouseDown,selected);
			}
			
			function rollOverHandler(event:MouseEvent):void
			{
				mouseOver = true;
				refreshButtonState(mouseOver,mouseDown,selected);
			}
			
			function rollOutHandler(event:MouseEvent):void
			{
				mouseOver = false;
				refreshButtonState(mouseOver,mouseDown,selected);
			}
			
			function mcClickHandler(event:MouseEvent):void
			{
				if (toggle)
				{
					selected = !selected;
					refreshButtonState(mouseOver,mouseDown,selected);
				}
				
				if (clickHandler != null)
					clickHandler(event);
			}
			
			function refreshButtonState():void
			{
				var offest:int = selected ? 3 : 0;
				if (mouseDown && mouseOver)
				{
					setButtonStateHandler(2 + offest);
				}
				else
				{
					if (mouseOver)
						setButtonStateHandler(1 + offest);
					else
						setButtonStateHandler(0 + offest);
				}
			}
		}
		
	}
}