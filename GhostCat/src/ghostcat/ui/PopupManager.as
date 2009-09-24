package ghostcat.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;
	
	import ghostcat.display.GBase;
	import ghostcat.manager.RootManager;
	import ghostcat.operation.PopupOper;
	import ghostcat.operation.Queue;
	import ghostcat.util.Singleton;
	
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
		
		private var _popupLayer:DisplayObjectContainer;
		private var _application:DisplayObjectContainer;
		private var _applicationEnabled:Boolean = true;
		
		private var popups:Dictionary;
		
		/**
		 * 弹出窗口指定的队列，为空则为全局队列
		 */
		public var queue:Queue = null;
		
		public var applicationDisabledFilters:Array;
		
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
			
			if (v)
				application.filters = null;
			else
				application.filters = applicationDisabledFilters;
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
			applicationDisabledFilters = [new BlurFilter(9,9),
										new ColorMatrixFilter([0.3086/2,0.6094/2,0.0820/2,0,0,
						 										0.3086/2,0.6094/2,0.0820/2,0,0,
						 										0.3086/2,0.6094/2,0.0820/2,0,0,
						 										0,0,0,1,0])
						 				];
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
		 * 
		 */
		public function showPopup(obj:DisplayObject,owner:DisplayObject=null,modal:Boolean = true):DisplayObject
		{
			if (!owner)
				owner = popupLayer;
				
			popups[obj] = owner;
			
			popupLayer.addChild(obj);
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
		public function queuePopup(obj:DisplayObject,owner:DisplayObject=null,modal:Boolean = true,queue:Queue = null):DisplayObject
		{
			var oper:PopupOper = new PopupOper(obj,owner,modal);
			
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
			
			if (obj is GBase)
				(obj as GBase).destory();
			else
				popupLayer.removeChild(obj);
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