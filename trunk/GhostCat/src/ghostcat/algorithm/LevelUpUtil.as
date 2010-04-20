package ghostcat.algorithm
{
	/**
	 * 级别经验值计算
	 * @author flashyiyi
	 * 
	 */
	public class LevelUpUtil
	{
		/**
		 * 累计每级需要的经验，级别从0开始，0级的值是0 
		 */
		public var levelXPs:Array = [];
		
		public function LevelUpUtil(levelXPs:Array):void
		{
			if (levelXPs)
				this.levelXPs = levelXPs;
		}
		
		/**
		 * 最大级别 
		 * @return 
		 * 
		 */
		public function get maxLevel():int
		{
			return levelXPs.length;
		}
		
		/**
		 * 从级别换算经验
		 * @param lv
		 * @return 
		 * 
		 */
		public function getExpFromLevel(lv:int):int
		{
			return levelXPs[lv];
		}
		
		/**
		 * 从经验换算级别 
		 * @param exp
		 * @return 
		 * 
		 */
		public function getLevelFromExp(exp:int):int
		{
			var lv:int = maxLevel - 1;
			while (exp < levelXPs[lv] && lv > 0)
				lv--;
			return lv;
		}
		
		/**
		 * 在本级别的经验 
		 * @param exp
		 * @param lv
		 * @return 
		 * 
		 */
		public function getLevelXP(exp:int,lv:int):int
		{
			return exp - levelXPs[lv];
		}
		
		/**
		 * 本级别升级需要经验 
		 * @param lv
		 * @return 
		 * 
		 */
		public function getLevelNeedXP(lv:int):int
		{
			if (lv >= maxLevel)
				return 0;
			else
				return levelXPs[lv + 1] - levelXPs[lv];	
		}
		
		/**
		 * 本级别升级百分率 
		 * @param exp
		 * @return 
		 * 
		 */
		public function getLevelPerentFromExp(exp:int):Number
		{
			var lv:int = getLevelFromExp(exp);
			
			if (lv >= maxLevel)
				return 0;
			else
				return getLevelXP(exp,lv) / getLevelNeedXP(lv);	
		}
	}
}