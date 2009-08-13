package org.ghostcat.display
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;

	/**
	 * 45度角重复场景
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GRepeater45 extends GRepeater
	{
		public function GRepeater45(base:*)
		{
			super(base);
		}
		
		public static function to45(p:DisplayObject):void
		{
			var m:Matrix = p.transform.matrix.clone();
            m.b = Math.tan(1/3);
            m.c = Math.tan(1/3);
            m.rotate(Math.PI/4);
            p.transform.matrix = m;
		}
	}
}