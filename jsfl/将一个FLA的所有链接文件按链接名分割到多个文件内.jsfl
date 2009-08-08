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
			
			var path = arr[i].linkageClassName.split(".");
			var folder = folderURI + "/" + path.slice(0,path.length - 1).join("/");
			var fileName = path[path.length - 1];
			var url = folderURI + "/" + path.join("/") + ".fla";
			if (!FLfile.exists(folder))
				FLfile.createFolder(folder);
			doc.exportSWF(folder + "/" + fileName + ".swf",true);
			fl.trace(fileName+"发布成功！")
			fl.saveDocument(doc , folder + "/" + fileName + ".fla");
			doc.close();
		}
	}
}