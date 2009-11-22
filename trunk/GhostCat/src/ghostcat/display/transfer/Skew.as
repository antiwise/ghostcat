package ghostcat.display.transfer
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.util.core.UniqueCall;

	/**
	 * 任意变形
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class Skew extends GTransfer
	{
		private var w:Number;
		private var h:Number;
		
		private var dotList:Array;
		private var pieceList:Array;
		
		public var hP:Number;
		public var vP:Number;
		
		private var _topLeft:Point;
		private var _topRight:Point;
		private var _bottomLeft:Point;
		private var _bottomRight:Point;
		
		protected var setTransformCall:UniqueCall = new UniqueCall(setTransform);
		
		/**
		 * 
		 * @param target	目标
		 * @param vP	横向精度
		 * @param hP	纵向精度
		 * 
		 */
		public function Skew(target:DisplayObject, vP:Number = 4, hP:Number = 4)
		{
			this.vP = vP;
			this.hP = hP;
			super(target);
		}
		/** @inheritDoc*/
		public override function set target(value:DisplayObject) : void
		{
			super.target = value;
			var rect: Rectangle = _target.getBounds(_target);
			
			_topLeft = new Point(rect.left,rect.top)
			_topRight = new Point(rect.right,rect.top)
			_bottomLeft = new Point(rect.left,rect.bottom)
			_bottomRight = new Point(rect.right,rect.bottom)
		}
		
		/**
		 * 右下控制点
		 * @return 
		 * 
		 */
		public function get bottomRight():Point
		{
			return _bottomRight;
		}

		public function set bottomRight(v:Point):void
		{
			_bottomRight = v;
			invalidateTransform()
		}

		/**
		 * 左下控制点
		 * @return 
		 * 
		 */
		public function get bottomLeft():Point
		{
			return _bottomLeft;
		}

		public function set bottomLeft(v:Point):void
		{
			_bottomLeft = v;
			invalidateTransform()
		}

		/**
		 * 右上控制点
		 * @return 
		 * 
		 */
		public function get topRight():Point
		{
			return _topRight;
		}

		public function set topRight(v:Point):void
		{
			_topRight = v;
			invalidateTransform()
		}

		/**
		 * 左上控制点
		 * @return 
		 * 
		 */
		public function get topLeft():Point
		{
			return _topLeft;
		}

		public function set topLeft(v:Point):void
		{
			_topLeft = v;
			invalidateTransform()
		}
		/** @inheritDoc*/
		protected override function createBitmapData():void
		{
			super.createBitmapData();
			
			w = bitmapData.width;
			h = bitmapData.height;
			
			dotList = [];
			pieceList = [];
			
			var _hsLen:Number = w/(hP+1);//纵向每块的高
			var _vsLen:Number = h/(vP+1);//横向每块的宽（根据精度来分割三角形）
			
			var i:Number;
			var j:Number;
			
			for (i=0; i<vP+2; i++)
			{
				//分割的顶点集合
				for (j=0; j<hP+2; j++)
				{
					dotList.push(new Dot(i*_hsLen, j*_vsLen));
				}
			}
			for (i=0; i<vP+1; i++)
			{
				//分割成的三角形的顶点集合
				for (j=0; j<hP+1; j++)
				{
					pieceList.push([dotList[j+i*(hP+2)], dotList[j+i*(hP+2)+1], dotList[j+(i+1)*(hP+2)]],
									[dotList[j+(i+1)*(hP+2)+1], dotList[j+(i+1)*(hP+2)], dotList[j+i*(hP+2)+1]]);
				}
			}
		}
		
		/**
		 * 更新变形
		 * 
		 */
		public function invalidateTransform():void
		{
			setTransformCall.invalidate(_topLeft,_topRight,_bottomLeft,_bottomRight);
		}
		
		/**
		 * 设置变形控制点
		 * 
		 * @param topL
		 * @param topR
		 * @param bottomL
		 * @param bottomR
		 * 
		 */
		public function setTransform(topL:Point, topR:Point, bottomL:Point, bottomR:Point):void
		{
			_topLeft = topL;
			_topRight = topR;
			_bottomLeft = bottomL;
			_bottomRight = bottomR;
 			
			if (!dotList)
				renderTarget();
			
			var leftV:Point = bottomL.subtract(topL);
			var rightV:Point = bottomR.subtract(topR);
			
			for (var i:int = dotList.length - 1;i>=0;i--)
			{
				var point:Dot = dotList[i];
				var gx:Number = point.x / w;
				var gy:Number = point.y / h;
				var bx:Number = topL.x + gy * leftV.x;
				var by:Number = topL.y + gy * leftV.y;
				point.sx = bx + gx * (topR.x + gy * rightV.x - bx);
				point.sy = by + gx * (topR.y + gy * rightV.y - by);
			}
			showBitmapData();
		}
		/** @inheritDoc*/
		protected override function showBitmapData() : void
		{
			graphics.clear();
			for (var i:int = pieceList.length - 1;i>=0;i--)
			{
				var a:Array = pieceList[i];
				var p0:Dot = a[0];
				var p1:Dot = a[1];
				var p2:Dot = a[2];
				
				var _tMat:Matrix = new Matrix((p1.x - p0.x)/w,(p1.y - p0.y)/w,(p2.x - p0.x)/h,(p2.y - p0.y)/h, p0.x, p0.y);
				var _sMat:Matrix = new Matrix((p1.sx - p0.sx)/w,(p1.sy - p0.sy)/w,(p2.sx - p0.sx)/h,(p2.sy - p0.sy)/h, p0.sx, p0.sy);
				_tMat.invert();
				_tMat.concat(_sMat);
				
				graphics.beginBitmapFill(bitmapData, _tMat, false, false);
				graphics.moveTo(p0.sx, p0.sy);
				graphics.lineTo(p1.sx, p1.sy);
				graphics.lineTo(p2.sx, p2.sy);
				graphics.endFill();
			}
		}
	}
}
import flash.geom.Point;

class Dot
{
	public var x:Number;
	public var y:Number;
	public var sx:Number;
	public var sy:Number;
	
	public function Dot(x:Number,y:Number)
	{
		this.sx = this.x = x;
		this.sy = this.y = y;
	}
}