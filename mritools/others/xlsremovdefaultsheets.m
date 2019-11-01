% function xlsremovdefaultsheets(excelfile)
% removes deafault sheets (english {'Sheet1,Sheet1,Sheet3'} and german {Tabelle1,Tabelle2,Tabell3}
% ..language dependent
function xlsremovdefaultsheets(excelfile)

[ excelFilePath name ext]=fileparts(excelfile) ;

excelFileName = [name ext ];%'Test.xls';
% excelFilePath = pwd; % Current working directory.
sheetName ={'Sheet' 'Tabelle'}; % EN: Sheet, DE: Tabelle, etc. (Lang. dependent)
% Open Excel file.
objExcel = actxserver('Excel.Application');
objExcel.Workbooks.Open(fullfile(excelFilePath, excelFileName)); % Full path is necessary!
% Delete sheets.
for i=1:length(sheetName)
      % Throws an error if the sheets do not exist.
     try; objExcel.ActiveWorkbook.Worksheets.Item([sheetName{i} '1']).Delete; end
     try; objExcel.ActiveWorkbook.Worksheets.Item([sheetName{i} '2']).Delete; end
     try; objExcel.ActiveWorkbook.Worksheets.Item([sheetName{i} '3']).Delete; end
end
% Save, close and clean up.
objExcel.ActiveWorkbook.Save;
objExcel.ActiveWorkbook.Close;
objExcel.Quit;
objExcel.delete;