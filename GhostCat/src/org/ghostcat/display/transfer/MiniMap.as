package org.ghostcat.display.transfer
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import org.ghostcat.util.Geom;

	/**
	 * 缩略图显示
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class MiniMap extends GTransfer
	{
		private var bitmap:Bitmap;
		
		private var scrollShape:Shape;
		
		private var matrix:Matrix;
		
		public function MiniMap(width:Number,height:Number,target:DisplayObject = null)
		{
			super(target);
			
			this.width = width;
			this.height = height;
			
			bitmap = new Bitmap();
			addChild(bitmap);
			
			scrollShape = new Shape();
			addChild(scrollShape);
		}

		protected override function init():void
		{
			super.init();
			
			invalidateDisplayList()
			scrollShapeRenfer();
			
			stage.addEventListener(Event.RESIZE,_resizeEvt);
			addEventListener(MouseEvent.MOUSE_DOWN,shapeMouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,shapeMouseUpHandler);
		}
		
		protected override function updateSize() : void
		{
			if (bitmap.bitmapData)
				bitmap.bitmapData.dispose();
				
			bitmap.bitmapData = new BitmapData(width,height);
			super.updateSize();
		} 
		
		protected override function createBitmapData() : void
		{
			//取消原来根据目标修改位图大小的操作。位图大小将由updateSize控制
		}
		
		protected override function render() : void
		{
			if (!bitmap.bitmapData)
				updateSize();
				
			var rect:Rectangle = _target.getBounds(_target);
			
			matrix=new Matrix();
			matrix.translate(-rect.x,-rect.y);//将坐标调整到0,0
			
			bitmap.bitmapData.fillRect(new Rectangle(0,0,width,height),0x00FFFFFF);
			var scale:Number;
			if (target.width/target.height>this.width/this.height)
			{
				//以宽度为准
				scale = this.width/target.width;
				matrix.scale(scale,scale);
				matrix.ty += (this.height-target.height*scale)/2;
			}
			else
			{
				//以高度为准
				scale = this.height/target.height;
				matrix.scale(scale,scale);
				matrix.tx += (this.width-target.width*scale)/2;
			};
			drawContext(target,matrix);
			
			scrollShapeRenfer();
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
		
		/**
		 * 更新范围显示框
		 * 
		 */
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
			
			localRect = localRect.intersection(new Rectangle(0,0,target.width,target.height));
			
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
			
			scrollShapeRenfer();
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