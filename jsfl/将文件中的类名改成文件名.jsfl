var folderURI = fl.browseForFolderURL("选择文件夹");
if (FLfile.exists(folderURI)) {
   var fileMask = "*.fla";
   var list = FLfile.listFolder(folderURI + "/" + fileMask, "files");
    for(var i in list)
    {
    	var doc = fl.openDocument(folderURI + "/"+list[i]);
    	var fileName = list[i].substr(0,list[i].length - 4);
		var c = 0;
		for each (var item in doc.library.items)
		{
			if (item.linkageClassName && item.linkageClassName!="Collision" && item.linkageClassName!=fileName)
			{
				item.linkageClassName = fileName;
				c++;
			}
		}
		if (c == 1)
		{
			doc.exportSWF(folderURI + "/" + fileName + ".swf",true);
			fl.saveDocument(doc , folderURI + "/"+list[i]);
			fl.trace(fileName+".fla的类名已修改为"+fileName);
		}
		else if (c > 1)
		{
			fl.trace("错误："+fileName+".fla中的非碰撞类超过1个！");
		}
		doc.close();
    }
}