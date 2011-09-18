package ghostcat.util.core
{
	import flash.net.LocalConnection;

	public final class GC
	{
		static public function gc():void
		{
			try
			{
				(new LocalConnection).connect("foo");
				(new LocalConnection).connect("foo");
			}
			catch(e:Error)	{}
		}
	}
}