package ghostcat.ui.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import ghostcat.display.GBase;
	import ghostcat.display.movieclip.GBitmapMovieClip;
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.display.movieclip.GMovieClipBase;
	import ghostcat.events.ActionEvent;
	import ghostcat.skin.ButtonSkin;
	import ghostcat.util.Util;
	import ghostcat.util.core.ClassFactory;
	
	/**
	 * 位图按钮
	 * 
	 * 标签规则：为一整动画，up,over,down,disabled,selectedUp,selectedOver,selectedDown,selectedDisabled是按钮的八个状态，
	 * 状态间的过滤为两个标签中间加-，末尾加:start。比如up和over的过滤即为up-over:start
	 * 
	 * 皮肤同时也会当作文本框再次处理一次
	 * 
	 * @author flashyiyi
	 * 
	 */	
	public class GBitmapButton extends GButtonBase
	{
		public var bitmaps:Array;
		public var labels:Array;
		public function GBitmapButton(bitmaps:Array=null,labels:Array=null,textPos:Point=null)
		{
			this.bitmaps = bitmaps;
			this.labels = labels;
			
			super(null, false, false,textPos);
		}
		
		/** @inheritDoc*/
		protected override function createMovieClip() : void
		{
			movie = new GBitmapMovieClip(bitmaps,labels);
		}
	}
}