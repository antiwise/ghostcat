var lib = fl.getDocumentDOM().library;
for each (var item in lib.items)
{
	if(item.linkageExportForAS)
	{
		var path = item.linkageClassName.split(".");
		var fileName = path[path.length - 1];
		
		var path = item.name.split("/");
		path[path.length - 1] = fileName;
		
		item.name = fileName;
		item.linkageClassName = path.join(".");
	}
}