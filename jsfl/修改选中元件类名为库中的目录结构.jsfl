var lib = fl.getDocumentDOM().library;
for each (var item in lib.getSelectedItems())
{
	if (item.itemType == "movie clip")
	{
		var path = item.name.split("/");
		item.linkageExportForAS = true;
		item.linkageClassName = path.join(".");
		item.linkageExportInFirstFrame = true;
	}
}