package ghostcat.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	import ghostcat.events.OperationEvent;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.FilterProxyOper;
	import ghostcat.operation.PopupOper;
	import ghostcat.operation.Queue;
	import ghostcat.operation.effect.IEffect;
	import ghostcat.util.Util;
	import ghostcat.util.display.Geom;
	
	/**
	 * 弹出窗口管理类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class PopupManager extends EventDispatcher
	{
		static private var _instance:PopupManager;
		static public function get instance():PopupManager
		{
			if (!_instance)
				_instance = new PopupManager();
			
			return _instance;
		}
		
		/**
		 * 显示一个临时的背景遮罩在对象后面作为遮挡，并会和对象一起被删除
		 * 
		 * @param v - 目标
		 * @param color	- 颜色
		 * @param alpha	- 透明度
		 * @param mouseEnabled	- 是否遮挡下面的鼠标事件
		 * 
		 */
		static public function createTempCover(v:DisplayObject,color:uint = 0x0,alpha:Number = 0.5,mouseEnabled:Boolean = false):void
		{
			var parent:DisplayObjectContainer = v.parent;
			//背景遮罩
			var back:Sprite = new Sprite();
			var rect:Rectangle = Geom.localRectToContent(new Rectangle(0,0,parent.stage.stageWidth,parent.stage.stageHeight),parent.stage,parent);
			back.graphics.beginFill(color,alpha);
			back.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
			back.graphics.endFill();
			back.mouseEnabled = mouseEnabled;
			parent.addChildAt(back,parent.getChildIndex(v));
			
			v.addEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
			function removeHandler(event:Event):void
			{
				parent.removeEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
				parent.removeChild(back);	
			}
		}
		
		/**
		 * 在窗口存在期间禁用父窗口
		 * @param v
		 * @param owner
		 * 
		 */
		static public function lockOwner(v:DisplayObject,owner:Sprite,asBitmap:Boolean = false):void
		{
			v.addEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
			owner.mouseChildren = owner.mouseEnabled = false;
			if (owner is GBase && asBitmap)
				(owner as GBase).asBitmap = true;
			
			function removeHandler(event:Event):void
			{
				v.removeEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
				owner.mouseChildren = owner.mouseEnabled = true;
				if (owner is GBase && asBitmap)
					(owner as GBase).asBitmap = false;
			}
		}
		
		private var _popupLayer:DisplayObjectContainer;
		private var _application:DisplayObjectContainer;
		private var _applicationEnabled:Boolean = true;

		/**
		 * 打开的模式窗口数量 
		 * @return 
		 * 
		 */
		public function get popupUpCount():int
		{
			return popups.length;
		}

		
		/**
		 * 弹出窗口指定的队列，为空则为全局队列
		 */
		public var queue:Queue = null;
		
		/**
		 * 模式窗口數組
		 */
		public var popups:Array = [];
		
		/**
		 * 定义非激活状态的Filter数组
		 */		
		public var applicationDisabledFilters:Array;
		
		/**
		 * 定义进入激活状态的Oper，用于显示过渡效果
		 */
		public var applicationEnabledOper:IEffect;
		
		/**
		 * 定义进入非激活状态的Oper，用于显示过渡效果
		 */
		public var applicationDisabledOper:IEffect;
		
		/**
		 * 是否自動禁用非活动窗口
		 */
		public var autoDisibledBackgroundPopup:Boolean;
		
		/**
		 * 是否在addChild子窗口后设置坐标
		 */
		public var setPositionAfterAdd:Boolean;
		
		/**
		 * 主程序是否激活 
		 * @return 
		 * 
		 */
		public function get applicationEnabled():Boolean
		{
			return _applicationEnabled;
		}

		public function set applicationEnabled(v:Boolean):void
		{
			if (_applicationEnabled == v)
				return;
			
			_applicationEnabled = v;
			
			application.mouseEnabled = application.mouseChildren = v;
			application.filters = v ? null : applicationDisabledFilters;
			
			if (applicationEnabledOper)
				applicationEnabledOper.halt()
					
			if (applicationDisabledOper)
				applicationDisabledOper.halt()
					
			if (v)
			{
				if (applicationEnabledOper)
				{
					if (!applicationEnabledOper.target)
						applicationEnabledOper.target = effectTarget;
					applicationEnabledOper.addEventListener(OperationEvent.OPERATION_COMPLETE,enabledOperCompleteHandler);
					applicationEnabledOper.execute();
				}
			}
			else
			{
				if (applicationDisabledOper)
				{
					if (!applicationDisabledOper.target)
						applicationDisabledOper.target = effectTarget;
					applicationDisabledOper.execute();
				}
			}
		}
		
		private function enabledOperCompleteHandler(event:Event):void
		{
			application.filters = null;
			event.currentTarget.removeEventListener(OperationEvent.OPERATION_COMPLETE,enabledOperCompleteHandler);
		}

		/**
		 * 弹出窗口容器 
		 * @return 
		 * 
		 */
		public function get popupLayer():DisplayObjectContainer
		{
			return _popupLayer;
		}

		public function set popupLayer(v:DisplayObjectContainer):void
		{
			_popupLayer = v;
		}
		
		/**
		 * 主程序（模态弹出时将被禁用） 
		 * @return 
		 * 
		 */
		public function get application():DisplayObjectContainer
		{
			return _application;
		}

		public function set application(v:DisplayObjectContainer):void
		{
			_application = v;
		}
		
		/**
		 * 效果的目标 
		 */
		public var effectTarget:DisplayObject;
		
		public function PopupManager()
		{
			super();
			
			const normalMatrix:Array = [
				1,0,0,0,0,
				0,1,0,0,0,
				0,0,1,0,0,
				0,0,0,1,0
			]
			const n:Number = 0.0;
			const d:Number = 0.2;
			const gredMatrix:Array = [
				0.3086*(1-n)+ n - d,	0.6094*(1-n) - d,	0.0820*(1-n) - d,	0,	0,
				0.3086*(1-n) - d,	0.6094*(1-n) + n - d,	0.0820*(1-n) - d,	0,	0,
				0.3086*(1-n) - d,	0.6094*(1-n) - d    ,	0.0820*(1-n) + n - d,	0,	0,
				0,	0,	0,	1,	0
			]
				
			applicationDisabledOper = new FilterProxyOper(null,new ColorMatrixFilter(normalMatrix),300,{matrix:gredMatrix})
			applicationEnabledOper = new FilterProxyOper(null,new ColorMatrixFilter(gredMatrix),300,{matrix:normalMatrix});
			
			if (RootManager.initialized)
				register(RootManager.root,RootManager.stage);
		
		}
		
		/**
		 * 最好手动执行此方法，如果不执行，将会以RootManager的属性为准。RootManager也没有初始化则无法使用。
		 * 
		 * @param application	主程序
		 * @param popupLayer	弹出窗口层
		 * 
		 */
		public function register(application:DisplayObjectContainer,popupLayer:DisplayObjectContainer):void
		{
			this.application = application;
			this.popupLayer = popupLayer;
			
			this.effectTarget = this.application;
		}
		
		/**
		 * 显示一个窗口
		 * 
		 * @param obj	窗口实例
		 * @param owner	调用者
		 * @param modal	是否是模态窗口
		 * @param center	居中模式（CenterMode）
		 */
		public function showPopup(obj:DisplayObject,owner:DisplayObject=null,modal:Boolean = true,centerMode:String = "rect",offest:Point = null):DisplayObject
		{
			if (setPositionAfterAdd)
				popupLayer.addChild(obj);
			
			if (centerMode == CenterMode.RECT)
			{
				Geom.centerIn(obj,popupLayer.stage);
			}
			else if (centerMode == CenterMode.POINT)
			{
				var center:Point = popupLayer.globalToLocal(Geom.center(popupLayer.stage));
				obj.x = center.x;
				obj.y = center.y;
			}
			
			if (offest)
			{
				obj.x += offest.x;
				obj.y += offest.y;
			}
			
			if (!setPositionAfterAdd)
				popupLayer.addChild(obj);
			
			if (owner && obj is GBase)
				(obj as GBase).owner = owner;
			
			obj.addEventListener(Event.REMOVED_FROM_STAGE,popupCloseHandler);
			if (modal)
			{
				popups.push(obj);
				if (popups.length > 0)
					applicationEnabled = false;
				obj.addEventListener(Event.REMOVED_FROM_STAGE,modulePopupCloseHandler);
				
				if (autoDisibledBackgroundPopup)
					disibledBackgoundPopup();
			}
			return obj;
		}
		
		/**
		 * 队列显示一个窗口
		 * 
		 * @param obj	窗口实例
		 * @param owner	调用者
		 * @param modal	是否是模态窗口
		 * @param queue	使用的队列。默认使用PopupManager指定的队列。
		 * 
		 */
		public function queuePopup(obj:DisplayObject,owner:DisplayObject=null,modal:Boolean = true,centerMode:String = "rect",offest:Point = null,queue:Queue = null):DisplayObject
		{
			var oper:PopupOper = new PopupOper(obj,owner,modal,centerMode,offest);
			
			if (!queue)
				queue = this.queue;
			
			oper.commit(queue);
				
			return obj;
		}
		
		/**
		 * 窗口关闭
		 * @param event
		 * 
		 */
		protected function popupCloseHandler(event:Event):void
		{
			var obj:DisplayObject = event.currentTarget as DisplayObject;
			if (obj is GBase)
				(obj as GBase).owner = null;
			
			event.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE,popupCloseHandler);
		}
		
		/**
		 * 模式窗口关闭方法 
		 * @param event
		 * 
		 */
		protected function modulePopupCloseHandler(event:Event):void
		{
			Util.remove(popups,event.currentTarget);
			
			if (popups.length <= 0)
				applicationEnabled = true;
			
			event.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE,modulePopupCloseHandler);
			
			if (autoDisibledBackgroundPopup)
				disibledBackgoundPopup();
		}
		
		/**
		 * 禁用最高層之外的窗體
		 * 
		 */
		protected function disibledBackgoundPopup():void
		{
			for (var i:int = 0;i < popups.length;i++)
			{
				var w:Sprite = popups[i] as Sprite;
				if (w)
					w.mouseEnabled = w.mouseChildren = (i == popups.length - 1);
			}
		}
		
		/**
		 * 删除一个窗口
		 * @param obj
		 * @param destoryGBase	是否自动销毁GBase对象
		 * 
		 */
		public function removePopup(obj:DisplayObject,destoryGBase:Boolean = true):void
		{
			if (obj.parent == popupLayer)
			{
				if (destoryGBase && obj is GBase)
					(obj as GBase).destory();
				else
					popupLayer.removeChild(obj);
			}
		}
		
		/**
		 * 删除所有窗口
		 * @param obj
		 * 
		 */
		public function removeAllPopup():void
		{
			while (popupLayer.numChildren)
			{
				removePopup(popupLayer.getChildAt(0));
			}
		}
	}
}