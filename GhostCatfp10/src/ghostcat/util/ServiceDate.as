package ghostcat.util
{
	/**
	 * 服务器时间
	 * @author flashyiyi
	 * 
	 */
	public class ServiceDate
	{
		private var offest:Number = 0;
		public function ServiceDate(serviceTime:Number = NaN)
		{
			if (!isNaN(serviceTime))
				setServiceTime(serviceTime);
		}
		
		public function setServiceTime(serviceTime:Number):void
		{
			this.offest = new Date().getTime() - serviceTime;
		}
		
		public function getDate():Date
		{
			return new Date(getTime());
		}
		
		public function getTime():Number
		{
			return new Date().getTime() - offest;
		}
	}
}