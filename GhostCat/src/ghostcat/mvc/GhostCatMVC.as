//这是一个GhostCat的衍生品，可以导入下面的SWC独立使用。
//http://code.google.com/p/ghostcat/source/browse/trunk/GhostCatMVC/bin/GhostCatMVC.swc
//
//需要Flex SDK 3.4或者以上版本编译。放心，只是需要编译环境支持[Bindable]标签，体积并不会增加。
//
//GhostCatMVC的使用成本非常低，它基本上只完成了通信方面的辅助，并没有任何强制性的措施。
//使用方法很简单：首先，你需要为Model,Command,View分别建立不同的类（起码的……）
//然后，在他们Class定义的上面标记上元标签，诸如Model就标上[M(name="test")]，Command就标记上[C(name="test")]，View就标记上[V(name="test")]
//最后，在文档类（或者任何一个地方）用GhostCatMVC.instance.load(ClassName1,ClassName2,ClassName3,ClassName4...)将所有需要关心的类一次性注册，至此配置即告完成。
//	
//	之后，你可以在任何地方用下面的方法进行通信：
//	
//	getM(target:*):*
//	获得一个Model的实例。
//
//send(e:Event, target:* = null, type:String = null):void
//发送事件e
//
//receive(e:String, handler:Function, target:* = null, type:String = null):void
//添加接收事件监听e
//
//call(target:*,type:String,metrod:String,...param):*
//	调用其他实例的方法metrod
//
//bindProperty(site:Object,prop:String,target:Object,type:String,chain:Object):ChangeWatcher
//当目标的chain属性变化时候，自动同步site[prop]属性
//
//bindSetter(setter:Function,target:Object,type:String,chain:Object):ChangeWatcher
//当目标的chain属性变化时候，自动执行setter方法（参数是变化的值）
//
//这里的target属性可以是定义的名称（如"test"），也可以是定义的类，或者一个类的实例（诸如this），而type属性则在必要时用来区分三者（值分别为："m","v","c"）。
//有趣的时，同一组的M,V,C是可以重名的，你可以将相关的M,V,C都定义成同一个名字。于是，当你执行call(this,"c","metrod")时，执行的就是和当前view同名的Command的metrod方法，当你执行getM(this)时，得到的也是和自己View同名的Module。当M,V,C大部分时候处于一对一关系的时候，这样会获得很大的便利。
//
//
//默认情况下，Model会被当做单例处理，而Command的每次调用都会重新创建一个实例，View则只是记录name。如果你不手动执行register(this)将View注册，它是无法被外部访问的，这三种情况分别对应single,create,none模式。模式也可以通过元标签定义修改。诸如[C(name="test",mode="single")]即可将这个Command当做单例处理。
//
//View默认是none模式，因此如果希望外部能够访问到它，就一定要先执行一次register方法（并在销毁的时候执行unregister方法）。当然，你也可以选择不让外界访问到它（就像烟水晶），用bindProperty将它和一个M的属性绑定，一样可以达到通信的目的。
//
//
//下面是一个示例文件：创建了两个文本框，用两种不同的方法让Command将当前值+1并回馈到View上。
//http://ghostcat.googlecode.com/files/GhostCatMVCExample.rar
//
//
//GhostCat项目地址：http://ghostcat.googlecode.com/
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
		 * @param target
		 * @return 
		 * 
		 */
		public function getM(target:*):*
		{
			var o:InsCotainer = getIns(target,"m");
			return o ? o.getIns() : null;
		}
		
		/**
		 * 获取一个V的实例 
		 * @param target
		 * @return 
		 * 
		 */
		public function getV(target:*):*
		{
			var o:InsCotainer = getIns(target,"v");
			return o ? o.getIns() : null;
		}
		
		/**
		 * 获取一个C的实例 
		 * @param target
		 * @return 
		 * 
		 */
		public function getC(target:*):*
		{
			var o:InsCotainer = getIns(target,"c");
			return o ? o.getIns() : null;
		}
		
		/**
		 * 注册一个对象实例使得它可以被外部访问
		 * @param v	目标标示
		 * @param type	目标类型（m,v,c）为空则不做限制
		 * 
		 */
		public function register(target:*):InsCotainer
		{
			var o:InsCotainer = getIns(target);
			if (o)
				o.ins = target;
			return o;
		}
		
		/**
		 * 解除注册
		 * @param v	目标标示
		 * @param type	目标类型（m,v,c）为空则不做限制
		 * 
		 */
		public function unregister(target:*):InsCotainer
		{
			var o:InsCotainer = getIns(target);
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
		public function receive(e:String, handler:Function, target:* = null, type:String = null):void
		{
			if (target)
			{
				var o:InsCotainer = getIns(target,type);
				var dispatcher:IEventDispatcher = o.getIns() as IEventDispatcher;
				if (dispatcher)
					dispatcher.addEventListener(e,handler,false,0,true);
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
		public function bindProperty(site:Object,prop:String,target:*,type:String,chain:Object):ChangeWatcher
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
		public function bindSetter(setter:Function,target:*,type:String,chain:Object):ChangeWatcher
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