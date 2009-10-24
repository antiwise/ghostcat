package ghostcat.text
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import ghostcat.display.IGBase;
	import ghostcat.util.ArrayUtil;
	import ghostcat.util.core.CallLater;
	import ghostcat.util.display.Geom;

	/**
	 * 自制输入法系统
	 * Shift键切换中英文
	 * 
	 * 处理输入法问题也可以通过JS，请参考：
	 * http://blog.sebastian-martens.de/2009/05/swfinputs-solving-mozilla-transparent-mode-win-special-chars-within-inputs/
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class IME
	{
		public static var ERROR_TEXT:String = "<html><font color='#990000'>(录入错误)</font></html>";
		
		private var data:Array;
		
		private var m1:Boolean = true;
		
		private var m2:Boolean = true;
		
		/**
		 * 显示输入法内容的容器
		 */
		public var skin:IGBase;
		
		/**
		 * 是否激活 
		 */
		public var enabled:Boolean = true;
		
		/**
		 * 一次显示几个词
		 */
		public var charNum:int = 5;
		
		/**
		 * 输入框与录入提示的间距
		 */
		public var offest:Point = new Point(5,5);
		
		private var text:String = "";
		private var list:Array;
		private var page:int = 0;
		private var inputBeginIndex:int;
		private var inputEndIndex:int;
		
		/**
		 * 
		 * @param str	输入法词库
		 * 在GameUIExample内就有一个现成的词库：pinyin.txt
		 * 
		 */		
		public function IME(str:String,skin:IGBase=null) 
		{
			data = str.split("\n");
			for (var i:int = 0;i<data.length;i++)
			{
				var text:String = data[i];
				text = text.replace("\r","");
				var key:String = text.match(/^[\x00-\xFF]*/)[0];
				data[i] = new IMEItem(key,text.slice(key.length).split(","));
			}
			
			this.skin = skin;
			skin.visible = false;
		}		
		
		/**
		 * 获得词的列表
		 * 
		 */
		public function getString(str:String):Array
		{
			var result:Array = [];
			for (var i:int = 0;i< data.length;i++)
			{
				var imeItem:IMEItem = data[i] as IMEItem;
				if (imeItem.key.substr(0,str.length)==str)
					result = result.concat(imeItem.list);
			}
			return result;
		}
		
		/**
		 * 注册一个文本框，激活输入法
		 * 
		 * @param input	用来输入的文本框
		 * 
		 */
		public function register(input:TextField):void
		{
			input.addEventListener(TextEvent.TEXT_INPUT,textInputHandler);
			input.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			input.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			input.addEventListener(FocusEvent.FOCUS_OUT,resetHandler);
			input.addEventListener(MouseEvent.MOUSE_DOWN,resetHandler);
		}
		
		/**
		 * 取消注册
		 * 
		 * @param input
		 * 
		 */
		public function unregister(input:TextField):void
		{
			input.removeEventListener(TextEvent.TEXT_INPUT,textInputHandler);
			input.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			input.removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			input.removeEventListener(FocusEvent.FOCUS_OUT,resetHandler);
			input.removeEventListener(MouseEvent.MOUSE_DOWN,resetHandler);
		}
		
		private function textInputHandler(event:TextEvent):void
		{
			if (!enabled)
				return;
			
			var textField:TextField = event.currentTarget as TextField;
			var char:String = event.text;
			
			if (char >="a" && char <="z" || char == "'")
			{
				if (text == "")
				{
					inputBeginIndex = textField.caretIndex;
					inputEndIndex = textField.caretIndex + 1;
				}
				else
					inputEndIndex = textField.caretIndex + 1;
				
				text += char;
				
				list = getString(text);
				
				skin.visible = true;
				page = 0;
				refreshSkin(textField,list.slice(0,charNum))
			}
			else if (list)
			{
				if (char == "=")
				{
					if (skin && page < Math.ceil(list.length / charNum))
					{
						page ++;
						refreshSkin(textField,list.slice(page * charNum,(page + 1) * charNum));
					}
					event.preventDefault();
				}
				else if (char == "-")
				{
					if (skin && page > 0)
					{
						page --;
						refreshSkin(textField,list.slice(page * charNum,(page + 1) * charNum))
					}
					event.preventDefault();
				}
				else if (char >="0" && char <= charNum.toString() || char == " ")
				{
					var n:int;
					if (char == " ")
						n = 0;
					else if (char == "0")
						n = 9;
					else
						n = int(char) - 1;
					
					event.preventDefault();
					acceptText(textField,list[page * charNum + n]);
				}
			}
			else
			{
				event.preventDefault();
				
				if (char == "'")
					m1 = !m1;
				if (char == "\"")
					m2 = !m2;
					
				textField.setSelection(textField.caretIndex,textField.caretIndex);
				textField.replaceSelectedText(NumberUtil.toChinesePunctuation(char,m1,m2));
			}
		};
		
		private var shiftDown:Boolean = false;
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
			var textField:TextField = event.currentTarget as TextField;
			if (shiftDown && event.keyCode == Keyboard.SHIFT)
			{
				if (enabled)
					acceptText(textField,null);
				enabled = !enabled;
			}	
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{	
			shiftDown =  (event.keyCode == Keyboard.SHIFT);//记录上一个键是不是Shfit，用来判断是否切换中英文
			
			if (!enabled)
				return;
			
			var textField:TextField = event.currentTarget as TextField;
			if (([Keyboard.ESCAPE,Keyboard.ENTER,Keyboard.LEFT,Keyboard.RIGHT]).indexOf(event.keyCode) != -1)
			{
				acceptText(textField,null);
			}
			else if (event.keyCode == Keyboard.BACKSPACE)
			{
				text = text.slice(0, text.length - 1);
				if (text!="")
				{
					list = getString(text);
					page = 0;
					refreshSkin(textField,list.slice(0,charNum))
				}
				else
					acceptText(textField,null);
			}
		}
		
		private function resetHandler(event:Event):void
		{
			var textField:TextField = event.currentTarget as TextField;
			acceptText(textField,null);
		}
		
		private function acceptText(textField:TextField,str:String):void
		{
			skin.visible = false;
			text = "";
			list = null;
			
			if (str)
			{
				textField.setSelection(inputBeginIndex,inputEndIndex);
				textField.replaceSelectedText(str);
			}
		}
		
		private function refreshSkin(textField:TextField,data:Array):void
		{
			if (skin)
			{
				var text:String = ""; 
				for (var i:int = 0;i < data.length;i++)
				{	
					if (i != 0)
						text += " ";
					text += (i+1).toString()+"."+data[i];
				}
				if (text =="")
					text = ERROR_TEXT;
					
				skin.data = text;
				CallLater.callLater(refresh);
				
				function refresh():void
				{
					var rect:Rectangle = textField.getCharBoundaries(textField.caretIndex - 1);
					if (rect)
					{
						var pos:Point = Geom.localToContent(rect.bottomRight,textField,skin.parent);
						skin.x = pos.x + offest.x;
						skin.y = pos.y + offest.y;
					}
				}
			}
		}
	}
}
class IMEItem
{
	public var key:String;
	public var list:Array;
	public function IMEItem(key:String,list:Array)
	{
		this.key = key;
		this.list = list;
	}
}