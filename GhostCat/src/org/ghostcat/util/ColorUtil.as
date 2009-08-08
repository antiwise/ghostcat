package org.ghostcat.util
{
	import flash.geom.ColorTransform;
	
	/**
	 * 
	 * 颜色处理类
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public final class ColorUtil
	{
		public static const RED:uint = 0xFF0000;
		
		public static const GREEN:uint = 0x00FF00;
		
		public static const BLUE:uint = 0x0000FF;
		
		/**
		 * 合并颜色值
		 * 
		 * @param r	红
		 * @param g	绿
		 * @param b	蓝
		 * @return	返回一个新的颜色值
		 * 
		 */		
		public static function RGB(r:uint,g:uint,b:uint):uint
		{
			return (r << 16) | (g << 8) | b;
		}
		
		/**
		 * 通过色度的方法合并颜色值。
		 * 我也一直无法熟练混合光度三原色，毕竟调色的时候用的不是这种，这个方法就算图个方便了。
		 * 仍然采用Red,Blue这种缩写，是因为这是针对程序员的
		 * 
		 * @param r	红（品红 Magenta）
		 * @param y	黄（黄 Yellow）
		 * @param b 蓝（青 Cyan）
		 * @return	返回一个新的颜色值
		 * 
		 */		
		public static function RYB(r:uint,y:uint,b:uint):uint
		{
			return ((0xFF - b) << 16) | ((0xFF - r) << 8) | (0xFF - y);
		}
		
		/**
		 * 获得单个通道的颜色
		 * 
		 * @param rgb	颜色值
		 * @param channel	颜色通道，数值为RED,GREEN,BLUE常量之一
		 * @return 返回颜色
		 * 
		 */		
		public static function getChannel(rgb:uint,channel:uint):uint
		{
			switch (channel)
			{
				case RED:
					return (rgb >> 16) & 0xFF;
					break;
				case GREEN:
					return (rgb >> 8) & 0xFF;
					break;
				case BLUE:
					return rgb & 0xFF;
					break;
			}
			return 0;
		}
		
		/**
		 * 从一个24位颜色值创建对应的ColorTransform对象，方法为过滤
		 * 注意，此对象并不包含alpha
		 * 
		 * @param rgb	颜色值
		 */
		public static function getColorTransform(rgb:uint):ColorTransform
		{
			var r:Number = (rgb >> 16) & 0xFF;
			var g:Number = (rgb >> 8) & 0xFF;
			var b:Number = rgb & 0xFF;
				
			return new ColorTransform(r/0xFF,g/0xFF,b/0xFF);
		}
		
		/**
		 * 从一个24位颜色值创建对应的ColorTransform对象，方法为附加
		 * 注意，此对象并不包含alpha
		 * 
		 * @param rgb	颜色值
		 */
		public static function getColorTransform2(rgb:uint):ColorTransform
		{
			var r:Number = (rgb >> 16) & 0xFF;
			var g:Number = (rgb >> 8) & 0xFF;
			var b:Number = rgb & 0xFF;
				
			return new ColorTransform(1.0,1.0,1.0,1.0,r,g,b);
		}

			
		/**
		 * 单独调整某个颜色通道
		 * 
		 * @param channel	颜色通道，数值为RED,GREEN,BLUE常量之一，可以用 | 符号多选
		 * @param rgb	颜色值
		 * @param brite	颜色变化量
		 * 这个值表示的是颜色的数值增加量，数值由-255至255，为0则不改变。
		 * @return	返回一个新的颜色值
		 */
		public static function adjustColor(channel:uint,rgb:uint,brite:uint):uint
		{
			var r:Number;
			var g:Number;
			var b:Number;
			
			if ((RED & channel) == channel){
				r = Math.max(Math.min(((rgb >> 16) & 0xFF)  + brite, 255), 0);
			}else{
				r = (rgb >> 16) & 0xFF;
			}
			
			if ((GREEN & channel) == channel){
				g = Math.max(Math.min(((rgb >> 8) & 0xFF) + brite, 255), 0);
			}else{
				g = (rgb >> 8) & 0xFF;
			}
			
			if ((BLUE & channel) == channel){
				b = Math.max(Math.min((rgb & 0xFF) + brite, 255), 0);
			}else{
				b = rgb & 0xFF;
			}
			return RGB(r,g,b);
		}
		
		/**
		 * 调整亮度
		 *
		 * @param rgb	颜色值
		 * @param brite	颜色变化量
		 * 这个值表示的是颜色的数值增加量，数值由-255至255，为0则不改变。
		 * @return	返回一个新的颜色值
		 */
		public static function adjustBrightness(rgb:uint, brite:Number):uint
		{
			var r:Number = Math.max(Math.min(((rgb >> 16) & 0xFF) + brite, 255), 0);
			var g:Number = Math.max(Math.min(((rgb >> 8) & 0xFF) + brite, 255), 0);
			var b:Number = Math.max(Math.min((rgb & 0xFF) + brite, 255), 0);
			
			return RGB(r,g,b);
		} 
	
		/**
		 * 按比例调整亮度的方式
		 *
		 * @param rgb	颜色值
		 * @param brite	颜色变化量
		 * 这个值表示的是颜色的比例系数，数值由-100至100，为0则不改变。
		 * @return	返回一个新的颜色值
		 */
		public static function adjustBrightness2(rgb:uint, brite:Number):uint
		{
			var r:Number;
			var g:Number;
			var b:Number;
			
			if (brite == 0)
				return rgb;
			
			if (brite < 0)
			{
				brite = (100 + brite) / 100;
				r = ((rgb >> 16) & 0xFF) * brite;
				g = ((rgb >> 8) & 0xFF) * brite;
				b = (rgb & 0xFF) * brite;
			}
			else 
			{
				brite /= 100;
				r = ((rgb >> 16) & 0xFF);
				g = ((rgb >> 8) & 0xFF);
				b = (rgb & 0xFF);
				
				r += ((0xFF - r) * brite);
				g += ((0xFF - g) * brite);
				b += ((0xFF - b) * brite);
				
				r = Math.min(r, 255);
				g = Math.min(g, 255);
				b = Math.min(b, 255);
			}
		
			return RGB(r,g,b);
		}

		/**
		 *  用正片叠底的方式合并两个颜色值
		 *  用这种方法合并的颜色值纯度将会降低
		 *
		 *  @param rgb1 第一个颜色值
		 *  @param rgb2 第二个颜色值
		 *  @return 合并结果
		 */
		public static function rgbMultiply(rgb1:uint, rgb2:uint):uint
		{
			var r1:Number = (rgb1 >> 16) & 0xFF;
			var g1:Number = (rgb1 >> 8) & 0xFF;
			var b1:Number = rgb1 & 0xFF;
			
			var r2:Number = (rgb2 >> 16) & 0xFF;
			var g2:Number = (rgb2 >> 8) & 0xFF;
			var b2:Number = rgb2 & 0xFF;
			
			return ((r1 * r2 / 255) << 16) |
				   ((g1 * g2 / 255) << 8) |
				    (b1 * b2 / 255);
		} 
	}
}