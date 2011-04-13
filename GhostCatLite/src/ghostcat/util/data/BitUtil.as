package ghostcat.util.data
{
	/**
	 * 位处理类
	 * 
	 * @author flashyiyi
	 * 
	 */
	public final class BitUtil
	{
		/**
		 * 设置uint型中某位的值
		 * 
		 * @param v	数值
		 * @param index	位置
		 * @param bool	设置值
		 * @return 
		 * 
		 */
		public static function setBit(v:uint,index:int,bool:Boolean):uint
		{
			if (bool)
                v = v | (1 << index);
            else 
                v = v & ~(1 << index);
            
            return v;
		}
		
		/**
		 * 从uint型中取某位的值
		 * 
		 * @param v	数值
		 * @param index	位置
		 * @return
		 * 
		 */
		public static function getBit(v:uint,index:int):Boolean
		{
			return v == (v | (1 << index));
		}
		
		/**
		 * 替换一段Bit区域为设置的数值
		 * 
		 * @param v	原数据
		 * @param v2	用来替换的数据
		 * @param startIndex	起始位置（从个位起）
		 * @param endIndex	结束位置
		 * @return 
		 * 
		 */
		public static function setShiftedValue(v:uint, v2:uint, startIndex:uint, endIndex:uint):uint
        {
            var mask:uint = (1 << endIndex) - 1;
            v = v & ~ (mask << startIndex);
            v = v | ((v2 & mask) << startIndex);
            return v;
        }
        
        /**
         * 替换一段Bit区域为设置的数值
         * 
         * @param v	原数据
         * @param v2	用来替换的数据
         * @param size	位数
         * @param startIndex	起始位置（从最大位起）
         * @param endIndex	结束位置
         * @return 
         * 
         */
        public static function setShiftedValue2(v:uint, v2:uint, size:uint, startIndex:uint, endIndex:uint):uint
        {
        	return setShiftedValue(v,v2,size - endIndex,size - startIndex);
        }
		
        /**
         * 截取一段Bit，返回其组成的数值
         *  
         * @param v	原数据
         * @param startIndex	起始位置（从个位起）
         * @param endIndex	结束位置
         * @return 
         * 
         */
        public static function getShiftedValue(v:uint, startIndex:uint, endIndex:uint):uint
        {
            var mask:uint= (1 << endIndex) - 1;
            return (v >> startIndex) & mask;
        }
        
        /**
        * 截取一段Bit，返回其组成的数值
        *  
        * @param v	原数据
        * @param size	位数
        * @param startIndex	起始位置（从最大位起）
        * @param endIndex	结束位置
        * @return 
        * 
        */
        public static function getShiftedValue2(v:uint, size:uint, startIndex:uint, endIndex:uint):uint
        {
        	return getShiftedValue(v,size - endIndex,size - startIndex);
        }
        
        /**
         * 由uint转换为布尔数组
         * 
         * @param v
         * @return	返回的数组（个位在最后）
         * 
         */
        public static function toBitArray(v:uint):Array
        {
        	var arr:Array = [];
        	while (v)
        	{
        		arr.unshift(Boolean(v & 0x1));
        		v = v >> 1;
        	}
        	return arr;
        }
        
        /**
         * 从布尔数组中转换为uint
         * 
         * @param arr	长度不要超过32
         * @return	返回的数组（个位在最后）
         * 
         */
        public static function fromBitArray(arr:Array):uint
        {
        	var v:uint = 0;
        	for (var i:int = arr.length;i >= 0;i--)
        	{
        		v = v << 1;
        		v = v | arr[i];
        	}
        	return v;
        }
	}
}