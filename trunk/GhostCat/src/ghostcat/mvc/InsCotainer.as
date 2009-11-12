package ghostcat.mvc
{
	import ghostcat.util.ReflectUtil;

	/**
	 * 保存类实例引用
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class InsCotainer
	{
		/**
		 * 立即创建
		 */
		static public const CREATE:String = "create";
		/**
		 * 单例
		 */
		static public const SINGLE:String = "single";
		/**
		 * 不做处理
		 */
		static public const NONE:String = "none";
		
		/**
		 * 类型(m,v,c) 
		 */
		public var type:String;
		
		/**
		 * 实例化模式 
		 */
		public var mode:String;
		
		/**
		 * 名称标示 
		 */
		public var name:String;
		
		/**
		 * 实例 
		 */
		public var ins:*;

		private var _ref:Class;
		
		/**
		 * 类 
		 * @return 
		 * 
		 */
		public function get ref():Class
		{
			return _ref;
		}

		public function set ref(value:Class):void
		{
			_ref = value;
			parseMetaData(value);
		}

		public function InsCotainer(ref:Class)
		{
			this.ref = ref;
		}
		
		private function parseMetaData(ref:Class):void
		{
			this.name = ReflectUtil.getQName(ref).localName;
			
			var d:XML;
			d = ReflectUtil.getMetaData(ref,null,"M");
			if (d)
			{
				this.type = "m";
				this.mode = SINGLE;
				parseXML(d);
				return;
			}
			d = ReflectUtil.getMetaData(ref,null,"V");
			if (d)
			{
				this.type = "v";
				this.mode = NONE;
				parseXML(d);
				return;
			}
			d = ReflectUtil.getMetaData(ref,null,"C");
			if (d)
			{
				this.type = "c";
				this.mode = CREATE;
				parseXML(d);
				return;
			}
		}
		
		private function parseXML(xml:XML):void
		{
			for each (var child:XML in xml.*)
				this[child.@key.toString()] = child.@value.toString();
		}
		
		/**
		 * 获得实例
		 * @return 
		 * 
		 */
		public function getIns():*
		{
			switch (this.mode)
			{
				case SINGLE:
					if (!ins)
						ins = new ref();
					return ins;
					break;
				case CREATE:
					return new ref();
					break;
				case NONE:
					return ins;
					break;
			}
		}
		
		/**
		 * 销毁
		 * 
		 */
		public function destory():void
		{
			delete GhostCatMVC.instance[this.type][this.name];
			delete GhostCatMVC.instance.classDict[ref];
		}
	}
}