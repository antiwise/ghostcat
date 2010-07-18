package ghostcat.manager
{
	import flash.utils.Dictionary;
	
	import ghostcat.util.ReflectUtil;
	import ghostcat.util.core.Singleton;

/**
*提供了单独的依赖注入功能，与MVC无关。
*先用register方法将多个实例注册
*InjectManager.instance.register(new Model(1),new Model(2));
*
*然后在需要注入的显示类里添加属性，并加上Inject元标签
*[Inject(id="1")]
*public var m1:Model;
*        
*[Inject(id="2")]
*public var m2:Model;
*
*并在构造函数中显式调用InjectManager.instance.inject(this)来完成注入，调用此方法后类的m1,m2属性将会被立即赋值成之前注册过的实例。
*[Inject]标签的参数是为了区分同类型的不同实例，[Inject(id="1")]表示只有属性id的值为1的对象才会被注入这个属性，如果依然有多个满足条件的对象则取第一个，如果对象只存在一个，则不需要参数。
*
*当调用过ViewManager.register(stage)注册过舞台后，InjectManager还能通过同样的方法立即注入屏幕中存在的显示对象。
*ViewManager.register(stage,false)第2个参数表示是否允许保存同类型的不同实例，设置为true将会消耗更多性能。
*
*
*InjectManager是允许多次实例化的。
*/
	
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