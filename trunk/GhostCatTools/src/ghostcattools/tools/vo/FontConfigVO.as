package ghostcattools.tools.vo
{
	import flash.display.DisplayObject;
	import flash.filesystem.File;
	
	import ghostcat.util.FontEmbedHelper;
	import ghostcat.util.ReflectUtil;
	import ghostcat.util.ReflectXMLUtil;
	
	import ghostcattools.components.GCAlert;
	import ghostcattools.util.AutoLengthArrayList;
	import ghostcattools.util.FileControl;
	import ghostcattools.util.ValueObject;
	
	import mx.utils.ObjectProxy;

	[Bindable]
	public class FontConfigVO
	{
		public var name:String = "";
		public var useFontFile:Boolean;
		public var fontName:String = "";
		public var systemFont:String = "";
		public var source:String = "";
		public var bold:Boolean;
		public var italic:Boolean;
		public var textFiles:AutoLengthArrayList = new AutoLengthArrayList(null,ValueObject,"value");
		public var template1:Boolean;
		public var template2:Boolean;
		public var template3:Boolean;
		public var extext:String = "";
		
		public function setXML(xml:XML):void
		{
			ReflectXMLUtil.parseXML(xml,this);
			
			textFiles.removeAll();
			for each (var child:XML in xml.textFiles.*)
				textFiles.addItem(new ValueObject(child.toString()));
			
			textFiles.createEmptyObject();
		}
		
		public function getXML():XML
		{
			var xml:XML = ReflectXMLUtil.objectToXML(this);
			xml.setName("Font");
			delete xml.@textFiles;
			
			var files:XML = <textFiles/>
			for (var i:int = 0;i < textFiles.source.length - 1;i++)
			{
				var child:ValueObject = textFiles.source[i];
				var childXml:XML = <String/>
				childXml.appendChild(child.value);
				files.appendChild(childXml);
			}
			xml.appendChild(files);
			return xml;
		}
		
		public function getRange():Array
		{
			var range:Array = [];
			if (this.template1)
				range.push(FontEmbedHelper.LETTER);
			if (this.template2)
				range.push(FontEmbedHelper.SBC_LETTER);
			if (this.template3)
				range.push(FontEmbedHelper.CHINESE_INTERPUNCTION);
			
			return range;
		}
		
		public function getText(alertContainer:DisplayObject):String
		{
			var text:String = "";
			for each (var child:ValueObject in this.textFiles.toArrayWithoutEmpty())
			{
				try
				{
					var file:File = new File(child.value);
				}
				catch (e:Error){};
				
				if (file && file.exists)
					text += FileControl.readFile(file).toString();
				else
					new GCAlert().show("文件" + child.value + "不存在！",alertContainer)
			}
			return text;
		}
	}
}