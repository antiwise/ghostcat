var d = fl.getDocumentDOM();
d.convertToSymbol('movie clip', prompt("请输入元件名"), 'top left');
d.enterEditMode('inPlace');
d.selectAll();
d.breakApart();
d.distributeToLayers();
d.breakApart();
d.clipCut();
while (d.getTimeline().layerCount > 1)
	d.getTimeline().deleteLayer(0);
d.clipPaste(true);