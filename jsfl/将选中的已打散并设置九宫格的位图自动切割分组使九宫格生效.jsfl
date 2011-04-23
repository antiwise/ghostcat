var d = fl.getDocumentDOM();
var lib = d.library;
for each (var item in lib.getSelectedItems())
{
	if (item.scalingGrid)
	{
		lib.editItem(item.name);
		var rect = item.scalingGridRect;
		d.setSelectionRect({left:-1000, top:-1000, right:rect.left, bottom:rect.top});
		d.group();
		d.setSelectionRect({left:rect.left, top:-1000, right:rect.right, bottom:rect.top});
		d.group();
		d.setSelectionRect({left:rect.right, top:-1000, right:1000, bottom:rect.top});
		d.group();
		d.setSelectionRect({left:-1000, top:rect.top, right:rect.left, bottom:rect.bottom});
		d.group();
		d.setSelectionRect({left:rect.left, top:rect.top, right:rect.right, bottom:rect.bottom});
		d.group();
		d.setSelectionRect({left:rect.right, top:rect.top, right:1000, bottom:rect.bottom});
		d.group();
		d.setSelectionRect({left:-1000, top:rect.bottom, right:rect.left, bottom:1000});
		d.group();
		d.setSelectionRect({left:rect.left, top:rect.bottom, right:rect.right, bottom:1000});
		d.group();
		d.setSelectionRect({left:rect.right, top:rect.bottom, right:1000, bottom:1000});
		d.group();

	}
}