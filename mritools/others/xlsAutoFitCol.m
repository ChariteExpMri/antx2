function xlsAutoFitCol(filename,sheetnames,varargin)
%% set excelfile columns to auto fit
% filename: excelfile
% sheetnames: name of the sheet (as string) or cell with sheetnames (this is faster than looping this function) 
% range:  autofit this column, excel style format
%% EXAMPLES
% xlsAutoFitCol(filename,sheetname,range)
% Examples:
% xlsAutoFitCol('filename','Sheet1','A:F')
% xlsAutoFitCol('filename',{'Sheet1' 'Sheet2'},'A:F')

options = varargin;

range = varargin{1};
    
[fpath,file,ext] = fileparts(char(filename));
if isempty(fpath)
    fpath = pwd;
end
Excel = actxserver('Excel.Application');
set(Excel,'Visible',0);
Workbook = invoke(Excel.Workbooks, 'open', [fpath filesep file ext]);


if ~iscell(sheetnames)
    sheetnames=cellstr(sheetnames);
end

for i=1:length(sheetnames)
    sheet = get(Excel.Worksheets, 'Item',sheetnames{i});
    invoke(sheet,'Activate');
    
    ExAct = Excel.Activesheet;
    
    ExActRange = get(ExAct,'Range',range);
    ExActRange.Select;
    
    
    invoke(Excel.Selection.Columns,'Autofit');
    
     ExAct.Range('A1').Select; %select first item
end

invoke(Workbook, 'Save');
invoke(Excel, 'Quit');
delete(Excel);