package ghostcat.ui
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.display.GBase;
	import ghostcat.manager.RootManager;
	import ghostcat.util.Singleton;
	import ghostcat.util.Util;
	
	public class PopupManager extends Singleton
	{
		static public function get instance():PopupManager
		{
			return Singleton.getInstanceOrCreate(PopupManager) as PopupManager;
		}
		
		private var _popupLayer:DisplayObjectContainer;
		private var _application:DisplayObjectContainer;
		public var popups:Array;
		
		public function get popupLayer():DisplayObjectContainer
		{
			return _popupLayer ? _popupLayer : RootManager.stage;
		}

		public function set popupLayer(v:DisplayObjectContainer):void
		{
			_popupLayer = v;
		}
		
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
			popups = [];
		}
		
		public function register(application:DisplayObjectContainer,popupLayer:DisplayObjectContainer):void
		{
			this.application = application;
			this.popupLayer = popupLayer;
		}
		
		public function showPopup(obj:DisplayObject):void
		{
			popups.push(obj);
			popupLayer.addChild(obj);
		}
		
		public function removePopup(obj:DisplayObject):void
		{
			Util.remove(popups,obj);
			
			if (obj is GBase)
				(obj as GBase).destory();
			else
				popupLayer.removeChild(obj);
		}
		
		public function removeAllPopup():void
		{
			for (var i:int = popups.length - 1;i >= 0;i--)
				removePopup(popups[i]);
		}
	}
}