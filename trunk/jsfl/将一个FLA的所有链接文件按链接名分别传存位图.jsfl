var folderURI = fl.browseForFolderURL("选择文件夹");
if (FLfile.exists(folderURI)) {
	var lib = fl.getDocumentDOM().library;
	var arr = lib.items;
	for(var i=0;i<arr.length;i++)
	{
		if(arr[i].linkageExportForAS)
	    {
	        var doc = fl.createDocument("timeline");
			fl.trace(arr[i].width)
			doc.width = 100;
			doc.height = 100;
			doc.addItem({x:0,y:0},arr[i]);
			doc.align("vertical center", true);
			doc.align("horizontal center", true);
			
			var path = arr[i].linkageClassName.split(".");
			var folder = folderURI + "/" + path.slice(0,path.length - 1).join("/");
			var fileName = path[path.length - 1];
			var url = folderURI + "/" + path.join("/") + ".fla";
			if (!FLfile.exists(folder))
				FLfile.createFolder(folder);
			doc.exportPNG(folder + "/" + fileName + ".png",false,true);
			doc.close(false)
		}
	}
}