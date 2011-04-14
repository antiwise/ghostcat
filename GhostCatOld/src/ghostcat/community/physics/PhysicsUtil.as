package ghostcat.community.physics
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * 物理管理器，提供一些控制物理属性的方法
	 * @author flashyiyi
	 * 
	 */
	public final class PhysicsUtil
	{
		/**
		 * 爆炸 
		 * @param p	起爆点
		 * @param power
		 * 
		 */
		public static function bomb(physics:PhysicsManager,p:Point,power:Number = 5,spin:Number = 10):void
		{
			for each (var item:PhysicsItem in physics.data)
			{
				var offest:Point = new Point(item.x,item.y).subtract(p);
				
				item.velocity = new Point(power * offest.x,power * offest.y);
				item.spin = (Math.random() - 0.5) * spin * 2;
				item.scaleSpeed = Math.pow(0.5, offest.length / 50) / 50;
				
				item.friction = 0.95;
				item.spinFriction = 0.99;
			}
		}
		
		/**
		 * 向点的吸引力 
		 * @param physics
		 * @param p
		 * @param power
		 * @param baseRadius
		 */
		public static function attract(physics:PhysicsManager,p:Point,power:Number = 1.0,baseRadius:Number = 0):void
		{
			for each (var item:PhysicsItem in physics.data)
			{
				var offest:Point = p.subtract(new Point(item.x,item.y));
				var len:Number = offest.length;
				if (baseRadius != 0)
					offest.normalize(len - baseRadius);
				
				item.velocity.x += 1 / offest.x * Math.abs(offest.x) * power;
				item.velocity.y += 1 / offest.y * Math.abs(offest.y) * power;
			}
		}
		
		/**
		 * 根据位图的颜色提供力场（红色为x轴，绿色为y轴）
		 * @param physics
		 * @param bitmapData
		 * 
		 */
		public static function field(physics:PhysicsManager,bitmapData:BitmapData,power:Number = 1.0):void
		{
			const t:Number = power / 0xFF;
			for each (var item:PhysicsItem in physics.data)
			{
				var c:uint = bitmapData.getPixel(item.x,item.y);
				item.velocity.x += t * (((c >> 16) & 0xFF) - 0x80);
				item.velocity.y += t * (((c >> 8) & 0xFF) - 0x80);
			}
		}
	}
}