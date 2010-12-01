package ghostcat.filter
{
	import flash.filters.BitmapFilter;
	import flash.filters.DisplacementMapFilter;
	
	public class WaveFilterProxy extends FilterProxy
	{
		public function WaveFilterProxy(filter:BitmapFilter=null)
		{
			super(new DisplacementMapFilter());
		}
	}
}