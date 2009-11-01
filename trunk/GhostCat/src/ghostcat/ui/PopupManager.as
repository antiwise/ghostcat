package ghostcat.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import ghostcat.display.GBase;
	import ghostcat.events.OperationEvent;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.FilterProxyOper;
	import ghostcat.operation.GroupOper;
	import ghostcat.operation.Oper;
	import ghostcat.operation.PopupOper;
	import ghostcat.operation.Queue;
	import ghostcat.util.core.Singleton;
	import ghostcat.util.display.Geom;
	
	/**
	 * 弹出窗口管理类 
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class PopupManager extends Singleton
	{
		static public function get instance():PopupManager
		{
			return Singleton.getInstanceOrCreate(PopupManager) as PopupManager;
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
		
		private var _popupLayer:DisplayObjectContainer;
		private var _application:DisplayObjectContainer;
		private var _applicationEnabled:Boolean = true;
		
		private var popups:Dictionary;
		
		/**
		 * 弹出窗口指定的队列，为空则为全局队列
		 */
		public var queue:Queue = null;
		
		/**
		 * 定义非激活状态的Filter数组
		 */		
		public var applicationDisabledFilters:Array;
		
		/**
		 * 定义进入激活状态的Oper，用于显示过渡效果
		 */
		public var applicationEnabledOper:Oper;
		
		/**
		 * 定义进入非激活状态的Oper，用于显示过渡效果
		 */
		public var applicationDisabledOper:Oper;
		
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
			_applicationEnabled = v;
			
			application.mouseEnabled = application.mouseChildren = v;
			
			application.filters = v ? null : applicationDisabledFilters;
			
			if (v)
			{
				if (applicationEnabledOper)
				{
					applicationEnabledOper.addEventListener(OperationEvent.OPERATION_COMPLETE,enabledOperCompleteHandler);
					applicationEnabledOper.execute();
				}
			}
			else
			{
				if (applicationDisabledOper)
					applicationDisabledOper.execute();
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
			return _popupLayer ? _popupLayer : RootManager.stage;
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
			return _application ? _application : RootManager.root;
		}

		public function set application(v:DisplayObjectContainer):void
		{
			_application = v;
		}
		
		public function PopupManager()
		{
			super();
			
			popups = new Dictionary(true);
		
			applicationDisabledOper =new GroupOper([new FilterProxyOper(
														application,
														new BlurFilter(0,0),
														1000,
														{blurX:4,blurY:4}
													),
													new FilterProxyOper(
														application,
														new ColorMatrixFilter([1,0,0,0,0,
																				0,1,0,0,0,
																				0,0,1,0,0,
																				0,0,0,1,0]),
														1000,
														{matrix:[
															0.3086/2,0.6094/2,0.0820/2,0,0,
						 									0.3086/2,0.6094/2,0.0820/2,0,0,
						 									0.3086/2,0.6094/2,0.0820/2,0,0,
						 									0,0,0,1,0
														]}
													)
													]);
			applicationEnabledOper = new GroupOper([new FilterProxyOper(
														application,
														new BlurFilter(4,4),
														1000,
														{blurX:0,blurY:0}
													),
													new FilterProxyOper(
														application,
														new ColorMatrixFilter([
															0.3086/2,0.6094/2,0.0820/2,0,0,
						 									0.3086/2,0.6094/2,0.0820/2,0,0,
						 									0.3086/2,0.6094/2,0.0820/2,0,0,
						 									0,0,0,1,0
														]),
														500,
														{matrix:[1,0,0,0,0,
																0,1,0,0,0,
																0,0,1,0,0,
																0,0,0,1,0]}
													)
													]);
													
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
		}
		
		/**
		 * 获得窗口的调用者
		 * 
		 * @param v
		 * @return 
		 * 
		 */
		public function getOwner(v:DisplayObject):DisplayObject
		{
			return popups[v]
		}
		
		/**
		 * 显示一个窗口
		 * 
		 * @param obj	窗口实例
		 * @param owner	调用者
		 * @param modal	是否是模态窗口
		 * @param center	居中模式（CenterMode）
		 */
		public function showPopup(obj:DisplayObject,owner:DisplayObject=null,modal:Boolean = true,centerMode:String = "rect"):DisplayObject
		{
			if (!owner)
				owner = popupLayer;
				
			popups[obj] = owner;
			
			popupLayer.addChild(obj);
			
			if (centerMode == CenterMode.RECT)
			{
				Geom.centerIn(obj,obj.stage);
			}
			else if (centerMode == CenterMode.POINT)
			{
				var center:Point = popupLayer.globalToLocal(Geom.center(obj.stage));
				obj.x = center.x;
				obj.y = center.y;
			}
			
			if (modal && applicationEnabled)
			{
				applicationEnabled = false;
				obj.addEventListener(Event.REMOVED_FROM_STAGE,modulePopupCloseHandler);
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
		public function queuePopup(obj:DisplayObject,owner:DisplayObject=null,modal:Boolean = true,centerMode:String = "rect",queue:Queue = null):DisplayObject
		{
			var oper:PopupOper = new PopupOper(obj,owner,modal,centerMode);
			
			if (queue)
				oper.commit(queue);
			else
				oper.commit(this.queue);
				
			return obj;
		}
		
		/**
		 * 模式窗口关闭方法 
		 * @param event
		 * 
		 */
		protected function modulePopupCloseHandler(event:Event):void
		{
			applicationEnabled = true;
		}
		
		/**
		 * 删除一个窗口
		 * @param obj
		 * 
		 */
		public function removePopup(obj:DisplayObject):void
		{
			delete popups[obj];
			
			if (obj.parent == popupLayer)
			{
				if (obj is GBase)
					(obj as GBase).destory();
				else
					popupLayer.removeChild(obj);
			}
		}
		
		/**
		 * 删除所有 
		 * 
		 */
		public function removeAllPopup():void
		{
			for each (var item:DisplayObject in popups)
				removePopup(item);
		}
	}
}