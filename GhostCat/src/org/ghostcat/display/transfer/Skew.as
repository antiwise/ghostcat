package org.ghostcat.display.transfer
{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class Skew extends GTransfer
	{
		private var _w:Number;
		private var _h:Number;
		private var _sMat:Matrix;
		private var _tMat:Matrix;
		private var _xMin:Number;
		private var _xMax:Number;
		private var _yMin:Number;
		private var _yMax:Number;
		private var _hP:Number;
		private var _vP:Number;
		private var _hsLen:Number;
		private var _vsLen:Number;
		private var _dotList:Array;
		private var _pieceList:Array;
		
		public function Skew(target:DisplayObject, vP:Number, hP:Number)
		{
			_vP = vP > 20 || vP <0 ? 2 : vP;
			_hP = hP > 20 || hP <0 ? 2 : hP;
			super(target);
		}
		protected override function render():void
		{
			var rect: Rectangle = _target.getBounds(_target);
			var m:Matrix = new Matrix();
			m.translate(-rect.x, -rect.y);
			bitmapData.fillRect(bitmapData.rect,0);
			bitmapData.draw(_target,m);
			
			_w = bitmapData.width;
			_h = bitmapData.height;
			_dotList = [];
			_pieceList = [];
			var ix:Number;
			var iy:Number;
			var w2:Number = _w/2;
			var h2:Number = _h/2;
			_xMin = _yMin=0;
			_xMax = _w;
			_yMax = _h;
			_hsLen = _w/(_hP+1);
			//纵向每块的高
			_vsLen = _h/(_vP+1);
			//横向每块的宽（根据精度来分割三角形）
			var x:Number, y:Number;
			for (ix=0; ix<_vP+2; ix++)
			{
				//分割的顶点集合
				for (iy=0; iy<_hP+2; iy++)
				{
					x = ix*_hsLen;
					y = iy*_vsLen;
					_dotList.push({x:x, y:y, sx:x, sy:y});
				}
			}
			for (ix=0; ix<_vP+1; ix++)
			{
				//分割成的三角形的顶点集合
				for (iy=0; iy<_hP+1; iy++)
				{
					_pieceList.push([_dotList[iy+ix*(_hP+2)], _dotList[iy+ix*(_hP+2)+1], _dotList[iy+(ix+1)*(_hP+2)]]);
					_pieceList.push([_dotList[iy+(ix+1)*(_hP+2)+1], _dotList[iy+(ix+1)*(_hP+2)], _dotList[iy+ix*(_hP+2)+1]]);
				}
			}
			renderTransform();
			//渲染
		}
		public function setTransform(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):void
		{
			var w:Number = _w;
			var h:Number = _h;
			var dx30:Number = x3-x0;
			var dy30:Number = y3-y0;
			var dx21:Number = x2-x1;
			var dy21:Number = y2-y1;
			var l:Number = _dotList.length;
			while (--l>-1)
			{
				var point:Object = _dotList[l];
				var gx:Number = (point.x-_xMin)/w;
				var gy:Number = (point.y-_yMin)/h;
				var bx:Number = x0+gy*(dx30);
				var by:Number = y0+gy*(dy30);
				point.sx = bx+gx*((x1+gy*(dx21))-bx);
				point.sy = by+gx*((y1+gy*(dy21))-by);
			}
			renderTransform();
		}
		
		protected function renderTransform():void
		{
			var t:Number;
			var p0:Object;
			var p1:Object;
			var p2:Object;
			var a:Array;
			graphics.clear();
			_sMat = new Matrix();
			_tMat = new Matrix();
			var l:Number = _pieceList.length;
			while (--l>-1)
			{
				a = _pieceList[l];
				p0 = a[0];
				p1 = a[1];
				p2 = a[2];
				var x0:Number = p0.sx;
				var y0:Number = p0.sy;
				var x1:Number = p1.sx;
				var y1:Number = p1.sy;
				var x2:Number = p2.sx;
				var y2:Number = p2.sy;
				var u0:Number = p0.x;
				var v0:Number = p0.y;
				var u1:Number = p1.x;
				var v1:Number = p1.y;
				var u2:Number = p2.x;
				var v2:Number = p2.y;
				_tMat.tx = u0;
				_tMat.ty = v0;
				_tMat.a = (u1-u0)/_w;
				_tMat.b = (v1-v0)/_w;
				_tMat.c = (u2-u0)/_h;
				_tMat.d = (v2-v0)/_h;
				_sMat.a = (x1-x0)/_w;
				_sMat.b = (y1-y0)/_w;
				_sMat.c = (x2-x0)/_h;
				_sMat.d = (y2-y0)/_h;
				_sMat.tx = x0;
				_sMat.ty = y0;
				_tMat.invert();
				_tMat.concat(_sMat);
				graphics.beginBitmapFill(bitmapData, _tMat, false, false);
				graphics.moveTo(x0, y0);
				graphics.lineTo(x1, y1);
				graphics.lineTo(x2, y2);
				graphics.endFill();
			}
		}
	}
}
import flash.geom.Point;

class Dot
{
	public var normal:Point;
	public var current:Point;
}