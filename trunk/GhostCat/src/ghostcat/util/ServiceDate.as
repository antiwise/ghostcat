package ghostcat.util
{
	/**
	 * 服务器时间
	 * @author flashyiyi
	 * 
	 */
	public class ServiceDate
	{
		static private var _instance:ServiceDate;
		/**
		 * 时间偏移量 
		 */
		public var offest:Number = 0;
		static public function get instance():ServiceDate
		{
			if (!_instance)
				_instance = new ServiceDate();
			
			return _instance;
		}
		
		/**
		 * 
		 * @param serviceTime 服务器时间
		 * 
		 */
		public function ServiceDate(serviceTime:Number = NaN)
		{
			_instance = this;
			if (!isNaN(serviceTime))
				this.setServiceTime(serviceTime);
		}
		
		/**
		 * 设置服务器时间 
		 * @param serviceTime
		 * 
		 */
		public function setServiceTime(serviceTime:Number):void
		{
			offest = new Date().getTime() - serviceTime;
		}
		
		/**
		 * 返回服务器时间
		 * @return 返回一个Date对象
		 * 
		 */
		public function getDate():Date
		{
			return new Date(getTime());
		}
		
		/**
		 * 返回服务器时间 
		 * @return 返回一个Number
		 * 
		 */
		public function getTime():Number
		{
			return new Date().getTime() - offest;
		}
	}
}