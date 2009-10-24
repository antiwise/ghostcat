package ghostcat.mvc
{
	import ghostcat.util.ReflectUtil;

	/**
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class InsCotainer
	{
		static public const CREATE:String = "create";
		static public const SINGLE:String = "single";
		static public const NONE:String = "none";
		
		public var type:String;
		
		public var mode:String;
		
		private var _ref:Class;
		
		public var name:String;
		
		public var ins:*;

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
		
		public function destory():void
		{
			delete GhostCatMVC.instance[this.type][this.name];
			delete GhostCatMVC.instance.classDict[ref];
		}
	}
}