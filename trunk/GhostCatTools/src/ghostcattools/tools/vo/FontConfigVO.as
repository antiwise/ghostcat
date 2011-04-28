package ghostcattools.tools.vo
{
	import ghostcat.util.ReflectUtil;
	import ghostcat.util.ReflectXMLUtil;
	
	import ghostcattools.util.AutoLengthArrayList;
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
	}
}