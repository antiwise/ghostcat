var folderURI = fl.browseForFolderURL("选择文件夹");
if (FLfile.exists(folderURI)) {
	var lib = fl.getDocumentDOM().library;
	var arr = lib.items;
	for(var i=0;i<arr.length;i++)
	{
		if(arr[i].linkageExportForAS && arr[i].linkageClassName!="Collision")
	    {
	        var doc = fl.createDocument("timeline");
			doc.addItem({x:doc.width/2,y:doc.height/2},arr[i]);
			var url = folderURI + "/" + arr[i].name + ".fla";
			doc.exportSWF(folderURI + "/" + arr[i].name + ".swf",true);
			fl.trace(url+"发布成功！")
			fl.saveDocument(doc , url);
			doc.close();
		}
	}
}