
% insert comment in xlsfile
% xlsinsertComment(file, msg, sheetNumber, startingRow, startingColumn)
% file     : fullfileName of excelFile
% msg,   : cell or string
% sheetNumber: numeric
% startingRow: which row
% startingColumn: which column
%%  example:
% xlsinsertComment(f1,{'vel: 1000','hor: 100' }, 1, 2, 2);

function xlsinsertComment(file, msg, sheetNumber, startingRow, startingColumn)
try
    
    %% xls-cell-locations
    ab={};
    for i=65:90
        ab(end+1,1)={char(i)};
    end
    for i=1:6
        ab(:,end+1)=cellfun(@(a){[ ab{i,1} a  ]} , ab(:,1)  );
    end
    head=ab(:);
    %% ________________________________________________________________________________________________
    
    
    Excel = actxserver('excel.application');
    Excel.DisplayAlerts = 0;
    WB = Excel.Workbooks.Open(file,0,false);
    
    worksheets = WB.sheets;
    thisSheet = get(worksheets, 'Item', sheetNumber);
    invoke(thisSheet, 'Activate');
    thisSheetsName = Excel.ActiveSheet.Name;  % For info only.
 
 
 %   thisSheet      = get(worksheets, 'Item', sheetNumber);
%   thisSheet      = Excel.ActiveSheet(sheetNumber);
 
  
  msg=cellstr(msg);
  
  numberOfComments = size(msg, 1);  % # rows
  for columnNumber = 1 : numberOfComments
      %columnLetterCode = cell2mat(ExcelCol(startingColumn + columnNumber - 1));
      % Get the comment for this row.
    %myComment = sprintf('%s', msg{columnNumber});
    myComment =strjoin(msg,char(10));
    
    % Get a reference to the cell at this row in column A.
    cellReference = sprintf('%s%d', head{startingColumn}, startingRow);
    theCell = thisSheet.Range(cellReference);
    % You need to clear any existing comment or else the AddComment method will throw an exception.
    theCell.ClearComments();
    % Add the comment to the cell.
    theCell.AddComment(myComment);
    
    
    
    
  end
  
  WB.Save();% Save Workbook
  WB.Close();% Close Workbook
  Excel.Quit();% Quit Excel
  
  %% ===============================================
  
  
catch ME
  errorMessage = sprintf('Error in function InsertComments.\n\nError Message:\n%s', ME.message);
  fprintf(errorMessage);
  uiwait(warndlg((errorMessage)));
end
return; % from InsertComments