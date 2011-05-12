package ghostcattools.tools.vo
{
	import ghostcat.util.ReflectUtil;
	import ghostcat.util.ReflectXMLUtil;

	[Bindable]
	public class EmbedVO
	{
		public var source:String = "";
		public var className:String = "";
		public var type:String = "";
		public var compression:Boolean;
		public var quality:int;
		public var symbol:String = "";
		public var smoothing:Boolean;
		public var scaleGrid:String = "";
		public function EmbedVO(v:Object = null):void
		{
			if (v)
			{
				for (var p:String in v)
					ReflectXMLUtil.setProperty(this,p,v[p]);
			}
		}
		public function toObject():Object
		{
			return ReflectUtil.getPropertyList(this);
		}
	}
}