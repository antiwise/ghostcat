package ghostcat.ui.html
{
	import ghostcat.ui.containers.GVBox;
	import ghostcat.ui.controls.GImage;
	import ghostcat.ui.controls.GText;
	
	/**
	 * 一个简单的HTML容器，仅支持图片定义都在底层的情况
	 *  
	 * @author flashyiyi
	 * 
	 */
	public class SimpleHTML extends GVBox
	{
		private var _htmlText:String;
		private var temp:String = "";
		
		public function SimpleHTML()
		{
			super();
		}

		/**
		 * 格式文本 
		 * @return 
		 * 
		 */
		public function get htmlText():String
		{
			return _htmlText;
		}

		public function set htmlText(value:String):void
		{
			_htmlText = value;
			removeAllChild();
			
			createObjectFromString(value);
		}
		
		/**
		 * 在尾部添加文本 
		 * @param value
		 * 
		 */
		public function appendText(value:String):void
		{
			_htmlText += value;
			createObjectFromString(value);
		}
		
		private function createObjectFromString(value:String):void
		{
			var xml:XML = new XML(value);
			for each (var child:XML in xml.*)
			{
				var name:String = child.localName();
				
				if (name.toLocaleLowerCase() == "image")
				{
					addTextBeforeEnd();
					
					var image:GImage = new GImage(child.@url.toString());
					var w:Number = child.@width;
					var h:Number = child.@height;
					if (w)
						image.width = w;
					if (h)
						image.height = h;
					
					addChild(image);
				}
				else
				{
					temp += child.toXMLString();
				}
			}
			
			addTextBeforeEnd();
		}
		
		private function addTextBeforeEnd():void
		{
			if (temp.length > 0)
			{
				var text:GText = new GText();
				text.htmlText = temp;
				addChild(text);
				
				temp = "";
			}
		}
	}
}