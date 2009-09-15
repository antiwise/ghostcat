package ghostcat.ui
{
	import flash.display.DisplayObjectContainer;
	
	import ghostcat.manager.RootManager;
	import ghostcat.util.Singleton;
	
	public class PopupManager extends Singleton
	{
		static public function get instance():PopupManager
		{
			return Singleton.getInstanceOrCreate(PopupManager) as PopupManager;
		}
		
		private var _popupLayer:DisplayObjectContainer;
		
		private var _application:DisplayObjectContainer;
		
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
		}
		
		public function register(application:DisplayObjectContainer,popupLayer:DisplayObjectContainer):void
		{
			this.application = application;
			this.popupLayer = popupLayer;
		}
	}
}