package ghostcat.operation
{
	import flash.events.Event;
	import flash.media.SoundChannel;
	
	import ghostcat.util.media.SoundUtil;

	/**
	 * 正弦声波
	 * @author flashyiyi
	 * 
	 */
	public class BeepOper extends Oper
	{
		/**
		 * 频率 
		 */
		public var mhz:Number;
		/**
		 * 长度 
		 */
		public var len:int;
		/**
		 * 声道 
		 */
		public var channel:SoundChannel;
		
		public function BeepOper(mhz:Number = 44.1,len:int = 1000)
		{
			this.mhz = mhz;
			this.len = len;
			
			super();
		}
		
		/** @inheritDoc*/
		public override function execute() : void
		{
			super.execute();
			channel = SoundUtil.beep(mhz,len);
			channel.addEventListener(Event.SOUND_COMPLETE,result);
		}
		
		/** @inheritDoc*/
		protected override function end(event:*=null) : void
		{
			super.end(event);
			channel.removeEventListener(Event.SOUND_COMPLETE,result);
		}
	}
}