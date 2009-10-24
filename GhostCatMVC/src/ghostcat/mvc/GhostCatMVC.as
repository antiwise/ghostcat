package ghostcat.mvc
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import ghostcat.debug.Debug;
	import ghostcat.util.core.Singleton;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.events.PropertyChangeEvent;
	
	/**
	 * [M][V][C]
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GhostCatMVC extends Singleton
	{
		static public function get instance():GhostCatMVC
		{
			return Singleton.getInstanceOrCreate(GhostCatMVC) as GhostCatMVC;
		}
		
		public var m:Dictionary;
		public var v:Dictionary;
		public var c:Dictionary;
		
		/**
		 * 类的对应字典
		 */
		public var classDict:Dictionary;
		
		public function GhostCatMVC()
		{
			super();
			
			this.m = new Dictionary(true);
			this.v = new Dictionary(true);
			this.c = new Dictionary(true);
			
			this.classDict = new Dictionary(true);
		}
		
		/**
		 * 注册类 
		 * @param params
		 * 
		 */
		public function load(...params):void
		{
			for (var i:int = 0;i < params.length;i++)
			{
				var v:Class = params[i] as Class;
				var ins:InsCotainer = new InsCotainer(v);
				var dict:Dictionary = this[ins.type];
				if (dict[ins.name])
					throw new Error("不允许重复注册！")
				else
				{
					dict[ins.name] = ins;
					classDict[v] = ins;
				}
			}
		}
		
		/**
		 * 取消类的注册 
		 * @param params
		 * 
		 */
		public function unLoad(...params):void
		{
			for (var i:int = 0;i < params.length;i++)
			{
				var o:InsCotainer;
				o = getIns(params[i],"m");
				if (o)
					o.destory();
				o = getIns(params[i],"v");
				if (o)
					o.destory();
				o = getIns(params[i],"c");
				if (o)
					o.destory();
			}
		}
		
		/**
		 * 获取一个M的实例 
		 * @param v
		 * @return 
		 * 
		 */
		public function getM(v:*):*
		{
			var o:InsCotainer = getIns(v,"m");
			return o ? o.getIns() : null;
		}
		
		/**
		 * 获取一个V的实例 
		 * @param v
		 * @return 
		 * 
		 */
		public function getV(v:*):*
		{
			var o:InsCotainer = getIns(v,"v");
			return o ? o.getIns() : null;
		}
		
		/**
		 * 获取一个C的实例 
		 * @param v
		 * @return 
		 * 
		 */
		public function getC(v:*):*
		{
			var o:InsCotainer = getIns(v,"c");
			return o ? o.getIns() : null;
		}
		
		/**
		 * 注册一个对象实例使得它可以被外部访问
		 * @param v	目标标示
		 * @param type	目标类型（m,v,c）为空则不做限制
		 * 
		 */
		public function register(v:*):InsCotainer
		{
			var o:InsCotainer = getIns(v);
			if (o)
				o.ins = v;
			return o;
		}
		
		/**
		 * 解除注册
		 * @param v	目标标示
		 * @param type	目标类型（m,v,c）为空则不做限制
		 * 
		 */
		public function unregister(v:*):InsCotainer
		{
			var o:InsCotainer = getIns(v);
			if (o)
				o.ins = null;
			return o;
		}
		
		/**
		 * 发送事件
		 *  
		 * @param e	事件对象
		 * @param target	目标标示，为空则是全局事件
		 * @param type	目标类型（m,v,c）为空则不做限制
		 * 
		 */
		public function send(e:Event, target:* = null, type:String = null):void
		{
			if (target)
			{
				var o:InsCotainer = getIns(target,type);
				var dispatcher:IEventDispatcher = o.getIns() as IEventDispatcher;
				if (dispatcher)
					dispatcher.dispatchEvent(e);
			}
			else
				dispatchEvent(e);
		}
		
		/**
		 * 接收事件
		 * 
		 * @param e	事件类型
		 * @param handler	事件函数
		 * @param target	目标标示，为空则是全局事件
		 * @param type	目标类型（m,v,c）为空则不做限制
		 * 
		 */
		public function recive(e:String, handler:Function, target:* = null, type:String = null):void
		{
			if (target)
			{
				var o:InsCotainer = getIns(target,type);
				var dispatcher:IEventDispatcher = o.getIns() as IEventDispatcher;
				if (dispatcher)
					addEventListener(e,handler,false,0,true);
			}
			else
				addEventListener(e,handler,false,0,true);
		}
		
		/**
		 * 调用一个对象的方法
		 * 
		 * @param target	对象的标示
		 * @param type	对象的类型（m,v,c）为空则不做限制
		 * @param metrod	执行的方法
		 * @param param	参数列表
		 * @return 
		 * 
		 */
		public function call(target:*,type:String,metrod:String,...param):*
		{
			var o:InsCotainer = getIns(target,type);
			if (!o)
				return null;
			var ins:Object = o.getIns();
			if (ins.hasOwnProperty(metrod) && ins[metrod] is Function)
				(ins[metrod] as Function).apply(ins,param);
			else
				Debug.trace("MVC","方法"+metrod+"(在类"+getQualifiedClassName(ins)+"上)不存在")
		}
		
		/**
		 * 当属性变化时，同步一个数据
		 *  
		 * @param site	需要被同步的对象
		 * @param prop	需要同步的属性
		 * @param host	M的标示，若此项为空，则是和site标示相同的M
		 * @param chain	需要绑定的属性
		 * @return 
		 * 
		 */
		public function bindProperty(site:Object,prop:String,target:Object,type:String,chain:Object):ChangeWatcher
		{
			var o:InsCotainer = getIns(target ? target : site,type);
			var host:Object = o.getIns();
			return BindingUtils.bindProperty(site,prop,host,chain);
		}
		
		/**
		 * 当属性变化时触发事件
		 *  
		 * @param setter	绑定的事件
		 * @param host	M的标示
		 * @param chain	需要绑定的属性
		 * @return 
		 * 
		 */
		public function bindSetter(setter:Function,target:Object,type:String,chain:Object):ChangeWatcher
		{
			var o:InsCotainer = getIns(target,type);
			var host:Object = o.getIns();
			return BindingUtils.bindSetter(setter,host,chain);
		}
		
		/**
		 * 手动发布属性变化事件
		 * 
		 * @param site	对象标示
		 * @param prop	属性
		 * 
		 */
		public function dispatchChangeEvent(site:Object, prop:String):void
		{
			site = getM(site) as IEventDispatcher;
			(site as IEventDispatcher).dispatchEvent(PropertyChangeEvent.createUpdateEvent(site,prop,site[prop],site[prop]));
		}
		
		/**
		 * 获得InsCotainer对象
		 *  
		 * @param v	标示符或者类
		 * @param type	类型(m,v,c)为空则不做限制
		 * @return 
		 * 
		 */
		public function getIns(v:*,type:String=null):InsCotainer
		{
			if (!v)
				return null;
			
			if (!(v is Class) && !(v is String))
				v = v["constructor"];
			
			if (!type)
			{
				if (v is Class)
				{
					return classDict[v];
				}
				else
				{
					var o:InsCotainer;
					o = getIns(v,"m");
					if (o)
						return o;
					o = getIns(v,"v");
					if (o)
						return o;
					o = getIns(v,"c");
					if (o)
						return o;
					return null;
				}
			}
			else
			{
				type = type.toLowerCase();
				var dict:Dictionary = this[type] as Dictionary;
				
				if (dict)
				{
					if (v is Class)
						v = classDict[v].name;
					
					if (v is String)
						return dict[v];
				}
			}
			return null;
		}
		
	}
}