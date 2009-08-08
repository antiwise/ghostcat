package org.ghostcat.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import org.ghostcat.util.Geom;
	import org.ghostcat.display.GNoScale;

	/**
	 * 缩略图显示
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class MiniMap extends GNoScale
	{
		private var bitmap:Bitmap;
		
		private var scrollShape:Shape;
		
		private var matrix:Matrix;
		
		private var _target:DisplayObject;
		
		public function MiniMap(width:Number,height:Number,target:DisplayObject = null)
		{
			super();
			
			this.width = width;
			this.height = height;
			
			var bitmapData:BitmapData = new BitmapData(width,height);
			bitmap = new Bitmap(bitmapData);
			addChild(bitmap);
			
			scrollShape = new Shape();
			addChild(scrollShape);
			
			this.target = target;
		}

		/**
		 * 渲染目标
		 * 
		 * @return 
		 * 
		 */
		public function get target():DisplayObject
		{
			return _target;
		}

		public function set target(v:DisplayObject):void
		{
			_target = v;
			if (v)
				invalidateDisplayList();
		}

		protected override function init():void
		{
			super.init();
			
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			invalidateDisplayList()
			scrollShapeRenfer();
			
			stage.addEventListener(Event.RESIZE,_resizeEvt);
			addEventListener(MouseEvent.MOUSE_DOWN,shapeMouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,shapeMouseUpHandler);
		}
		
		public override function updateSize() : void
		{
			bitmap.bitmapData = new BitmapData(width,height);
			super.updateSize();
		} 
		
		public override function updateDisplayList() : void
		{
			matrix=new Matrix();
			
			if (!bitmap)
				updateSize();
			bitmap.bitmapData.fillRect(new Rectangle(0,0,width,height),0x00FFFFFF);
			var scale:Number;
			if (target.width/target.height>this.width/this.height)
			{
				//以宽度为准
				scale = this.width/target.width;
				matrix.scale(scale,scale);
				matrix.ty = (this.height-target.height*scale)/2;
			}
			else
			{
				//以高度为准
				scale = this.height/target.height;
				matrix.scale(scale,scale);
				matrix.tx = (this.width-target.width*scale)/2;
			};
			drawContext(target,matrix);
			
			scrollShapeRenfer();
			
			super.updateDisplayList();
		}
		
		/**
		 * 绘制地图的方法，可以重载此类修改显示的内容。
		 * 
		 * @param target
		 * @param matrix
		 * 
		 */
		protected function drawContext(target:DisplayObject,matrix:Matrix):void
		{
			bitmap.bitmapData.draw(target,matrix);
		}
		
		public function scrollShapeRenfer():void
		{
			if (!stage)
				return;
			
			var localRect:Rectangle;
			if (target.parent.scrollRect)
				//以父层次框架为框
				localRect = Geom.localRectToContent(target.parent.scrollRect,target.parent,target);
			else
				//以场景为框
				localRect = Geom.localRectToContent(new Rectangle(0,0,stage.stageWidth,stage.stageHeight),target.parent,target);
			
			localRect = localRect.intersection(target.getRect(target));
			
			drawScrollShape(localRect);
			
			var scale:Number;
			if (target.width/target.height > this.width/this.height)
			{
				//以宽度为准
				scale = this.width/target.width;
				scrollShape.scaleX = scrollShape.scaleY = scale;
				scrollShape.y = (this.height-target.height*scale)/2;
				scrollShape.x = 0;
			}
			else
			{
				//以高度为准
				scale = this.height/target.height;
				scrollShape.scaleX = scrollShape.scaleY = scale;
				scrollShape.x = (this.width - target.width * scale)/2;
				scrollShape.y = 0;
			};
		}
		
		protected function drawScrollShape(localRect:Rectangle):void
		{
			scrollShape.graphics.clear();
			scrollShape.graphics.beginFill(0,0.3);
			scrollShape.graphics.lineStyle(0,0,1);
			scrollShape.graphics.drawRect(1,1,target.width,target.height);
			scrollShape.graphics.lineStyle(0,0,0.8);
			scrollShape.graphics.drawRect(localRect.x,localRect.y,localRect.width,localRect.height);
			scrollShape.graphics.endFill();
		}
		
		private function shapeMouseDownHandler(event:MouseEvent):void
		{
			if (!enabled)
				return;
				
			addEventListener(MouseEvent.MOUSE_MOVE,shapeMouseMoveHandler);
			shapeMouseMoveHandler(event);
		};
		
		private function shapeMouseUpHandler(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE,shapeMouseMoveHandler);
		};
		
		private function shapeMouseMoveHandler(event:MouseEvent):void
		{
			var cWidth:Number;
			var cHeight:Number;
			if (target.parent.scrollRect)
			{
				cWidth=target.parent.scrollRect.width;
				cHeight=target.parent.scrollRect.height;
			}
			else
			{
				cWidth=stage.stageWidth;
				cHeight=stage.stageHeight;
			}
			target.x=cWidth / 2 - (bitmap.mouseX - matrix.tx) / matrix.a * target.scaleX;
			target.y=cHeight / 2 - (bitmap.mouseY - matrix.ty) / matrix.d * target.scaleY;
		};
		
		private function _resizeEvt(event:Event):void
		{
			scrollShapeRenfer();
		}
		
		public override function destory() : void
		{
			stage.removeEventListener(Event.RESIZE,_resizeEvt);
			removeEventListener(MouseEvent.MOUSE_DOWN,shapeMouseDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,shapeMouseUpHandler);
		
			super.destory();
		}
		
	}
}