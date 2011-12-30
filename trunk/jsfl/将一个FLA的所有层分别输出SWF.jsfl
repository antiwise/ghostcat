var folderURI = fl.browseForFolderURL("选择文件夹");
if (FLfile.exists(folderURI)) {
	var doc = fl.getDocumentDOM();
	var timeline = doc.getTimeline();
	var arr = timeline.layers;
	for(var i=0;i<arr.length;i++)
	{
		for (var j=0;j<arr.length;j++)
			arr[j].visible = i == j;
		
		var fileName = arr[i].name;
		doc.exportSWF(folderURI + "/" + fileName + ".swf",true);
	}
}