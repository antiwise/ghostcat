package ghostcattools.util
{
	import mx.utils.ObjectProxy;
	
	public class ValueObject
	{
		[Bindable]
		public var value:*;
		
		public function ValueObject(value:Object = null)
		{
			super();
			if (value)
				this.value = value;
				
		}		
	}
}