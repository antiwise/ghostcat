package ghostcat.manager
{
	import flash.utils.Dictionary;
	
	import ghostcat.util.ReflectUtil;
	import ghostcat.util.core.Singleton;
	
	public class InjectManager extends Singleton
	{
		static public function get instance():InjectManager
		{
			return Singleton.getInstanceOrCreate(InjectManager) as InjectManager;
		}
		
		protected var dict:Dictionary;
		
		public function InjectManager()
		{
			super();
			
			dict = new Dictionary();
		}
		
		public function register(...reg):void
		{
			for (var i:int = 0;i < reg.length;i++)
			{
				var target:* = reg[i];
				var cls:* = target["constructor"];
				if (cls)
				{
					var list:Array = dict[cls];
					if (!list)
						dict[cls] = list = [];
						
					list.push(target);
				}
			}
		}
		
		public function inject(target:*):void
		{
			var pList:Object = ReflectUtil.getPropertyTypeList(target,true);
			for (var p:String in pList)
			{
				var o:Object = ReflectUtil.getMetaDataObject(target,p,"Inject");
				if (o)
					target[p] = retrieve(pList[p],o);
			}
		}
		
		public function retrieve(cls:Class,filter:Object = null):*
		{
			var list:Array = dict[cls];
			if (!list)
			{
				var vm:ViewManager = Singleton.getInstance(ViewManager);
				return vm ? vm.getView(cls,filter) : null;
			}
			
			if (filter)
			{
				for each (var v:Object in list)
				{
					var match:Boolean = true;
					for (var p:String in filter)
					{
						if (!(v.hasOwnProperty(p) && v[p] == filter[p]))
						{
							match = false;
							break;
						}
					}
					if (match)
						return v;
				}
			}
			else
			{
				return list[0];
			}
			return null;
		}
	}
}