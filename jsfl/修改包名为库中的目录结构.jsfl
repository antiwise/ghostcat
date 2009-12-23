var lib = fl.getDocumentDOM().library;
for each (var item in lib.items)
{
	var path = item.name.split("/");
	item.linkageExportForAS = true;
	item.linkageClassName = path.join(".");
}