package org.ghostcat.algorithm.bezier
{
	import flash.geom.Point;

	/**
	 * 统一直接和曲线类的接口
	 * 
	 */
	public interface IParametric
	{
		/**
		 * 起点
		 * @return 
		 * 
		 */
		function get start():Point;

		function set start(value:Point):void;

		/**
		 * 终点
		 * @return 
		 * 
		 */
		function get end():Point;

		function set end(value:Point):void;

		/**
		 * 获得线的长度
		 * 
		 * @return 
		 * 
		 */
		function get length():Number;

		/**
		 * 按位置比例获得线的长度
		 * 
		 * @param time	比例系数
		 * @return 
		 * 
		 */
		 
		function getSegmentLength(time:Number):Number;	

		/**
		 * 按长度获得线上某点的位置比例
		 * 
		 * @param time	在线上的比例	
		 */
		function getTimeByDistance(distance:Number):Number;

		/**
		 * 按比例获得线上某点的坐标
		 * 
		 * @param time	在线上的比例位置	
		 * 
		 **/
		function getPoint(time:Number):Point;
		
		/**
		 * 通过设置线上的点的方式调整线
		 * 
		 * @param time	点所在线的比例
		 * @param x	设置点的横坐标，默认值则不变
		 * @param y	设置点的纵坐标，默认值则不变
		 * 
		 */
		function setPoint(time:Number, x:Number = NaN, y:Number = NaN):void;
		
		/**
		 * 平移线
		 * 
		 * @param dx
		 * @param dx
		 * 
		 */
		function offset(dx : Number = 0, dy : Number = 0):void;
	}
}