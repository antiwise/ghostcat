package ghostcat.util
{
	import flash.utils.getTimer;

	/**
	 * 服务器时间
	 * @author flashyiyi
	 * 
	 */
	public class ServiceDate
	{
		static private var _instance:ServiceDate;
		
		/**
		 * 获取时间模式 0:用Date计算偏移 1:用getTimer偏移
		 */
		public var mode:int;
		
		//时间偏移量 
		private var offest:Number = 0;
		
		//上次的服务器时间与getTimer的偏移
		private var prevServiceOffest:Number;
		
		
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
		public function ServiceDate(serviceTime:Number = NaN,mode:int = 0)
		{
			_instance = this;
			
			this.mode = mode;
			
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
			prevServiceOffest = serviceTime - getTimer();
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
			if (mode == 0)
				return new Date().getTime() - offest;
			else
				return isNaN(prevServiceOffest) ? new Date().getTime() : prevServiceOffest + getTimer();
		}
	}
}