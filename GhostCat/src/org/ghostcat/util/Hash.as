package org.ghostcat.util
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

    /**
     * 32位散列算法。由于只有32位，它的碰撞几率较高，使用时需要特别注意。
     * 
     * @author flashyiyi
     * 
     */
    public final class Hash
    {
    	private static var hashDict:Dictionary = new Dictionary();
    	
    	/**
		 * 计算一个字符串的Hash码。可以用来标识各个字符串
		 * 
		 * @param s	要转换的字符串
		 * @param startValue	起始值，一般为0
		 * 
		 * @param checkDup	是否检测Hash碰撞
		 * 它需要将所有计算出来的Hash码保存起来，会占用大量的内存资源。请只在检测hash碰撞的时候使用。
		 * @return 
		 * 
		 */		
		public static function fromString(s:String, startValue:uint=0,checkDup:Boolean = false):uint
        {
        	var bytes:ByteArray = new ByteArray();
        	bytes.writeUTFBytes(s);
            var returnValue:uint = fromByteArray(bytes,startValue)
            
            if (checkDup)
            {
            	if (hashDict[returnValue] && hashDict[returnValue]!=s)
            		throw new Error("Hash碰撞发生！'" + s + "'与'" +  hashDict[returnValue] + "'的hash码都是" + returnValue)
            	else
            		hashDict[returnValue] = s;
            }
            
            return returnValue;
        }

        /**
         * 计算一个ByteArray的Hash码。可以用来辨别两个文件是否相同。
         * 
         * @param byteArray	要计算的数据
         * @param startValue	起始值，一般为0
         * @return 
         * 
         */
        public static function fromByteArray(byteArray:ByteArray, startValue:uint=0):uint
        {
            var seed:uint = 2654435769;
            var value:uint = seed;
            var returnValue:uint = startValue;
            byteArray.position = 0;
            while (byteArray.bytesAvailable >= 12) 
            {
                seed += uint(byteArray.readUnsignedByte() + (byteArray.readUnsignedByte() << 8) 
                	+ (byteArray.readUnsignedByte() << 16) + (byteArray.readUnsignedByte() << 24));
                value += uint(byteArray.readUnsignedByte() + (byteArray.readUnsignedByte() << 8) 
                	+ (byteArray.readUnsignedByte() << 16) + (byteArray.readUnsignedByte() << 24));
                returnValue += uint(byteArray.readUnsignedByte() + (byteArray.readUnsignedByte() << 8) 
                	+ (byteArray.readUnsignedByte() << 16) + (byteArray.readUnsignedByte() << 24));
                
                seed = (seed - value - returnValue) ^ returnValue >> 13;
                value = (value - returnValue - seed) ^ seed << 8;
                returnValue = (returnValue - seed - value) ^ value >> 13;
               
                seed = (seed - value - returnValue) ^ returnValue >> 12;
                value = (value - returnValue - seed) ^ seed << 16;
                returnValue = (returnValue - seed - value) ^ value >> 5;
               
                seed = (seed - value - returnValue) ^ returnValue >> 3;
                value = (value - returnValue - seed) ^ seed << 10;
                returnValue = (returnValue - seed - value) ^ value >> 15;
            }
            returnValue += byteArray.length;
            switch (byteArray.bytesAvailable) 
            {
                case 11:
                    returnValue += (byteArray.readUnsignedByte() << 24);
                case 10:
                    returnValue += (byteArray.readUnsignedByte() << 16);
                case 9:
                    returnValue += (byteArray.readUnsignedByte() << 8);
                case 8:
                    value += (byteArray.readUnsignedByte() << 24);
                case 7:
                    value += (byteArray.readUnsignedByte() << 16);
                case 6:
                    value += (byteArray.readUnsignedByte() << 8);
                case 5:
                    value += byteArray.readUnsignedByte();
                case 4:
                    seed += (byteArray.readUnsignedByte() << 24);
                case 3:
                    seed += (byteArray.readUnsignedByte() << 16);
                case 2:
                    seed += (byteArray.readUnsignedByte() << 8);
                case 1:
                    seed += byteArray.readUnsignedByte();
            }
            
            seed = (seed - value - returnValue) ^ returnValue >> 13;
            value = (value - returnValue - seed) ^ seed << 8;
            returnValue = (returnValue - seed - value) ^ value >> 13;
            
            seed = (seed - value - returnValue) ^ returnValue >> 12;
            value = (value - returnValue - seed) ^ seed << 16;
            returnValue = (returnValue - seed - value) ^ value >> 5;
            
            seed = (seed - value - returnValue) ^ returnValue >> 3;
            value = (value  - returnValue - seed) ^ seed << 10;
            returnValue = (returnValue - seed - value) ^ value >> 15;
            return returnValue;
        }
    }
}


