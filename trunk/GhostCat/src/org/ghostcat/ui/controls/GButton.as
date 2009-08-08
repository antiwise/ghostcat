package org.ghostcat.ui.controls
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	import org.ghostcat.display.movieclip.GMovieClip;
	
	/**
	 * 
	 * 按钮
	 * @author flashyiyi
	 * 
	 */	
	public class GButton extends GMovieClip
	{
		private const LABELS:Array = [["up","selectedUp"],
										["over","selectedOver"],
										["down","selectedDown"],
										["disabled","selectedDisabled"]];
		private const UP:int = 0;
		private const OVER:int = 1;
		private const DOWN:int = 2;
		private const DISABLED:int = 3;
		
		private var defaultSkin:DisplayObject;//默认skin
		
		private var _toggle:Boolean;
		
		private var _selected:Boolean;
		
		private var _mouseDown:Boolean = false;
		
		private var _mouseOver:Boolean = false;
		
		/**
		 * 鼠标按下时移过是否转换焦点
		 */		
		public var trackAsMenu:Boolean;
		
		/**
		 * 鼠标状态对应的colorTransform变化
		 */		
		public var colorTransforms:Object;
		
		/**
		 * 鼠标状态对应的matrix变化
		 */	
		public var matrixs:Object;
		
		/**
		 * 鼠标状态对应的filters变化
		 */		
		public var filterses:Object;
		
		/**
		 * 鼠标状态对应的skin变化
		 */		
		public var skins:Object;
		
		
		
		private var _label:String;
		private var labelField:GText;
		
		
		public function GButton(skin:MovieClip, replace:Boolean=true, paused:Boolean=false)
		{
			super(skin, replace, paused);
		}
		
		public function get label():String
		{
			return _label;
		}

		public function set label(v:String):void
		{
			_label = v;
			if (labelField)
				labelField.text = _label;
			else
				refreshLabelField();
		}
		
		public function refreshLabelField():void
		{
			if (!_label)
				return;
			
			if (labelField)
				labelField.destory();
			
			labelField = new GText(content,false);
			labelField.text = _label;
			addChild(labelField)
		}

		public override function setContent(skin:DisplayObject, replace:Boolean=true):void
		{
			defaultSkin = skin;
			setPartConetent(skin,replace);
		}
		
		public function setPartConetent(skin:DisplayObject, replace:Boolean=true):void
		{
			super.setContent(skin,replace);
			refreshLabelField();
		}
		
		public function set toggle(v:Boolean):void
		{
			_toggle = v;
			if (v){
				addEventListener(MouseEvent.CLICK,clickHandler);
			}else{
				removeEventListener(MouseEvent.CLICK,clickHandler);
			}
		}
		
		public function get toggle():Boolean
		{
			return _toggle;
		}
		
		public function set selected(v:Boolean):void
		{
			_selected = v;
			tweenTo(UP);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		protected override function init():void
		{
			super.init();
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			addEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
		
			tweenTo(UP);
		}
		
		private function tweenTo(n:int):void
		{
			var next:String = LABELS[n][int(selected)];
			
			if (replace && skins)
			{
				if (skins[next]){
					setPartConetent(skin[next],replace);
				}else{
					setPartConetent(defaultSkin,replace);
				}
			}
			
			if (replace && matrixs) 
			{
				if (matrixs[next]){
					content.transform.matrix = matrixs[next];
				}else{
					content.transform.matrix = new Matrix();
				}
			}
			
			if (colorTransforms)
			{
				if (colorTransforms[next]){
					content.transform.colorTransform = colorTransforms[next];
				}else{
					content.transform.colorTransform = new ColorTransform();
				}
			}
			
			if (filterses)
			{
				if (filterses[next]){
					content.filters = filterses[next];
				}else{
					content.filters = [];
				}
			}
			
			if (content)
			{
				var trans:String = curLabelName+"-"+next+":start";
				setLabel(curLabelName+"-"+next+":start");
				queueLabel(next);
			}
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			tweenTo(DOWN);
			_mouseDown = true;
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			tweenTo(_mouseOver ? OVER : UP);
			_mouseDown = false;
			
			if (trackAsMenu)
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		protected function rollOverHandler(event:MouseEvent):void
		{	
			if (event.buttonDown)
			{
				if (trackAsMenu || _mouseDown)
					tweenTo(DOWN);
			}
			else
			{
				tweenTo(OVER);
			}
			
			_mouseOver = true;
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			tweenTo(UP);
			_mouseOver = false;
		}
		
		protected function clickHandler(event:MouseEvent):void
		{
			selected = !selected;
		}
		
		public override function destory() : void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			removeEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
			removeEventListener(MouseEvent.CLICK,clickHandler);
			super.destory();
		}
	}
}