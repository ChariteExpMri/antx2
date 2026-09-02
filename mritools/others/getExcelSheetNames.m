function sheets = getExcelSheetNames(filename)

    tmp = tempname;
    mkdir(tmp);

    unzip(filename,tmp);

    workbookFile = fullfile(tmp,'xl','workbook.xml');

    doc = xmlread(workbookFile);

    nodes = doc.getElementsByTagName('sheet');

    sheets = cell(nodes.getLength,1);

    for k = 0:nodes.getLength-1
        node = nodes.item(k);
        sheets{k+1} = char(node.getAttribute('name'));
    end

    rmdir(tmp,'s');
end