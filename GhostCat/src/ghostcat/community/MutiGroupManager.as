package ghostcat.community
{
	import flash.utils.Dictionary;

	/**
	 * 合并GroupManager
	 * @author flashyiyi
	 * 
	 */
	public class MutiGroupManager extends GroupManager
	{
		public var engines:Array;
		public function MutiGroupManager(...engines)
		{
			super(command);
			this.engines = engines;
			for each (var e:GroupManager in engines)
				e.data = this.data;
		}
		
		/** @inheritDoc*/			
		public override function calculate(v:*):void
		{
			for each (var e:GroupManager in engines)
				e.calculate(v);
		}
		
		/** @inheritDoc*/	
		public override function calculateAll(onlyFilter:Boolean = false):void
		{
			for (var i:int = 0; i < data.length;i++)
			{
				var v:* = data[i];
				if ((!onlyFilter || dirtys[v]) && !(filter!=null && filter(v)==false))
					calculate(v);
				
			}
			dirtys = new Dictionary();
		}
	}
}