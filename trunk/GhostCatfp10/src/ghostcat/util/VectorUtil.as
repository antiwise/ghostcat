package ghostcat.util
{
	public final class VectorUtil
	{
		static public function vectorToArray(vector:Vector,array:Array):void
		{
			var l:int = vector.length;
			array.length = 0;
			for (var i:int = 0;i < l;i++)
				array[i] = vector[i];
		}
		
		static public function arrayToVector(array:Array,vector:Vector):void
		{
			vector.length = 0;
			vector.push.apply(null,array);
		}
	}
}