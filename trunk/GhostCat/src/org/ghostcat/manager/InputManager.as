package org.ghostcat.manager
{
    import flash.display.DisplayObject;
    import flash.display.InteractiveObject;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.external.ExternalInterface;
    import flash.geom.Point;
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;
    
    import org.ghostcat.events.InputEvent;
    import org.ghostcat.util.Singleton;
    
    /**
     * 输入设备管理类，附加功能为：
     * 
     * 检测暂离，检测按钮是否按下，检测单独按键的一次点击（非组合键），鼠标手势，鼠标右键，连续按键
     * 实现方式是向外部发布InputEvent事件
     * 
     * 启用鼠标右键时，为了禁止FLASH自己的右键菜单，必须将FLASH的wmode改为opaque
     *  
     * @author flashyiyi
     * 
     */    
    public class InputManager extends Singleton
    {
    	public static var MUTLI_INTERVAL:int = 300;
    	
		private var keyBuffer:int = 0;
		
		private var lastTime:int = getTimer();
		private var lastMouseTime:int;
		private var lastRightMouseTime:int;
		private var lastKeyTime:int;
		
		private var mousePath:Array = [];
		
		private var _mutliMouse:int;
		private var _mutliRightMouse:int;
		private var _mutliKey:int;
		private var _mouseDown:Boolean = false;
		private var _keyDownCode:int = 0;
		private var _mouseLeave:Boolean = false;
		private var _objAtMouse:DisplayObject;
		
		[Embed(source = "rightClick.js",mimeType="application/octet-stream")]
		private static var rightClickJSCode:Class;
		
		/**
		 * 触发鼠标手势的最低速度
		 */		
		public var handMinSpeed:Number = 0.2;
		
		/**
		 * 连续按了几次鼠标
		 */		
		public function get mutliMouse():int
		{
			return _mutliMouse;
		}
		
		/**
		 * 连续按了几次鼠标右键
		 */		
		public function get mutliRightMouse():int
		{
			return _mutliRightMouse;
		}
		
		/**
		 * 同一个键连续按下次数
		 */		
		public function get mutliKey():int
		{
			return _mutliKey;
		}
		/**
		 * 鼠标是否按下 
		 */
		public function get mouseDown():Boolean
		{
			return _mouseDown;
		}
		/**
		 * 上一次按下的键盘码
		 */		
		public function get keyDownCode():int
		{
			return _keyDownCode;
		}
		/**
		 * 鼠标是否在播放器之外
		 */
		
		public function get mouseLeave():Boolean
		{
			return _mouseLeave;
		}
		/**
		 * 当前在鼠标之下的物品
		 */		
		public function get objAtMouse():DisplayObject
		{
			return _objAtMouse;
		}
		/**
		 * 暂离需要的时间
		 */		
		public var inactiveTime:int = 60000;
		
    	/**
    	 * 注册并开始使用，必须首先执行这个方法
    	 * 
    	 * @param source	舞台对象
    	 * 
    	 */    	
    	public static function register(source:DisplayObject):void
        {
        	var ins:InputManager = Singleton.getInstanceOrCreate(InputManager) as InputManager;
        	ins._objAtMouse = ins.stage = source.stage;
        	
        	if (ExternalInterface.available)//鼠标右键
        	{
        		var jsCode:String = new rightClickJSCode().toString();
        		ExternalInterface.call("eval",jsCode);
        		ExternalInterface.call("RightClick.init",getQualifiedClassName(source.root));
        		ExternalInterface.addCallback("openRightClick", ins.rightClickHandler);
        	}
        }
        
        private function rightClickHandler():void 
		{ 
			if (objAtMouse)
			{
				if (lastRightMouseTime > 0 && getTimer() - lastRightMouseTime < MUTLI_INTERVAL)
        			_mutliRightMouse ++;
        		else
        			_mutliRightMouse = 1;
        		lastRightMouseTime = getTimer();
				
				var e:InputEvent = new InputEvent(InputEvent.MOUSE_RIGHT, true, false, objAtMouse.mouseX, objAtMouse.mouseY); 
				objAtMouse.dispatchEvent(e);
			}
		}
        
        public static function get instance():InputManager
        {
        	return Singleton.getInstance(InputManager) as InputManager;
        }
		
		private var _stage:Stage;
		
		/**
		 * 注册的对象
		 */		
		public function get stage():Stage
		{
			return _stage;
		}
		
		public function set stage(v:Stage):void
    	{
    		if (_stage == v)
    			return;
    		
    		_stage = v;
    		
    		_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            _stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
    		_stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            _stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
            _stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
            _stage.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
            _stage.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
            _stage.addEventListener(Event.MOUSE_LEAVE,mouseLeaveHandler);
    	}
    	
    	/**
		 * 设置焦点
		 * @param obj
		 * 
		 */
		public function setFocus(obj:InteractiveObject):void
		{
            stage.focus = obj;
        } 
    	
        /**
         * 判断某个键是否按下
         * 
         * @param code	键盘码
         * @return 
         * 
         */
        public function isKeyPressed(code:int):Boolean
        {
            return (keyBuffer & code) != 0;
        }

        /**
         * 判断是否有键已经按下
         * 
         */
        public function get keyDown():Boolean
        {
            return keyBuffer != 0;
        }
		
        /**
         * 清空按键
         * 
         */		
        public function resetKeys():void
        {
            keyBuffer = 0;
        }
        
        /**
         * 用户是否暂离
         * 
         */        
        public function get inactive():Boolean
        {
        	return getTimer() - lastTime > inactiveTime;
        }
        
        private function refreshLastTime():void
        {
        	lastTime = getTimer();
        }
        
        private function keyUpHandler(event:KeyboardEvent):void
        {
        	keyBuffer = keyBuffer & ~(event.keyCode);
        	
        	if (event.keyCode == keyDownCode)
            {
            	var evt:InputEvent = new InputEvent(InputEvent.KEY_DOWN_UP);
            	evt.keyCode = keyDownCode;
            	event.target.dispatchEvent(evt);
            }
            
            refreshLastTime();
        }

        private function keyDownHandler(event:KeyboardEvent):void
        {
        	if (keyDownCode == event.keyCode && lastKeyTime > 0 && getTimer() - lastKeyTime < MUTLI_INTERVAL)
        		_mutliKey ++;
        	else
        		_mutliKey = 1;
        		
        	lastKeyTime = getTimer();
        	
        	keyBuffer = keyBuffer | (event.keyCode);
        	_keyDownCode = event.keyCode;
        	
        	refreshLastTime();
        }
        
        private function mouseUpHandler(event:MouseEvent):void
        {
        	_mouseDown = false;
        	
        	if (getPathLength(mousePath) /(getTimer() - lastMouseTime) > handMinSpeed)
        	{
        		var e:InputEvent = new InputEvent(InputEvent.MOUSE_MOVE_PATH)
        		e.mousePath = mousePath.slice();
        		(event.target as EventDispatcher).dispatchEvent(e);
			}
			
			mousePath = [];
        	
        	refreshLastTime();
        }
        
        //获得路径的总长度
		private function getPathLength(source:Array):Number
		{
			if (source.length < 2) return 0;
			
			var result:Number=0;
			var pre:Point = source[0] as Point;
			for (var i:int = 1;i<source.length;i++)
			{
				var now:Point = source[i] as Point;
				var sub:Point = now.subtract(pre);
				result += now.length;
				
				pre = now;
			}
			return result;
		}

        private function mouseDownHandler(event:MouseEvent):void
        {
        	if (lastMouseTime > 0 && getTimer() - lastMouseTime < MUTLI_INTERVAL)
        		_mutliMouse ++;
        	else
        		_mutliMouse = 1;
        		
        	lastMouseTime = getTimer();
        	_mouseDown = true;
        	
        	refreshLastTime();
        }
        
        private function mouseMoveHandler(event:MouseEvent):void
        {
        	_objAtMouse = event.target as DisplayObject;
        	refreshLastTime();
        	
        	if (mouseDown)
        		mousePath.push(new Point(event.stageX,event.stageY));
        }
        
        private function mouseOverHandler(event:MouseEvent):void
        {
        	_objAtMouse = event.target as DisplayObject;
        	_mouseLeave = false;
        }
        
        private function mouseOutHandler(event:MouseEvent):void
        {
        	_objAtMouse = null;
        }
        
        private function mouseLeaveHandler(event:Event):void
        {
        	_mouseLeave = true;
        }
    }
}
