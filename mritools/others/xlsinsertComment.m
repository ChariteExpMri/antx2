
% insert comment in xlsfile
% xlsinsertComment(file, msg, sheetNumber, startingRow, startingColumn)
% file     : fullfileName of excelFile
% msg,   : cell or string
% sheetNumber: numeric
% startingRow: which row
% startingColumn: which column
% <optional> comment color  either as:
%            - as character, examples:  'm','k','r','b','g','y','w' or 'c'
%            - as RGB-triplet, example [0.8706 0.4902 0]  for orange
%% -------------------------
%%  example:
% xlsinsertComment(f1,{'vel: 1000','hor: 100' }, 1, 2, 2);
%% using comment-color (magenta) as character 'm'
% xlsinsertComment(f1,{'bla'; 'blabla'}, 1, 8, 2,'m');
%% using comment-color (orange) as  RGB-triplet
% xlsinsertComment(f1,{'bla2'; 'blabla2'}, 1, 8, 2,[0.8706 0.4902 0]);

function xlsinsertComment(file, msg, sheetNumber, startingRow, startingColumn,rgb)
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
    
    v=theCell.Comment;
    
    try; v.Shape.TextFrame.Characters.Font.Name='Courier New'; end
    
    %colore
    %14811135
    %___autoSize comment
    try; v.Shape.TextFrame.AutoSize=true; end
    
    %v.Shape.Fill.BackColor.SchemeColor=5;
%     v.Shape.Fill.ForeColor.SchemeColor = 31
    %% ==============[ comment color ]=================================
    if exist('rgb')==1
        try
            if ischar(rgb)
                tcol= {...
                    'm'  [1     0     1]
                    'k'  [0     0     0]
                    'r'  [1     0     0]
                    'b'  [ 0     0     1]
                    'g'  [0     1     0]
                    'y'  [1     1     0]
                    'w'  [1 1 1]
                    'c'  [0 1 1]
                    'o' [0.8706 0.4902 0]
                    };
                rgb=cell2mat(tcol(strcmp(tcol(:,1),rgb),2));
            end
            %rgb=[1 0 1]
            xcol=[];
            rgb(find(rgb>1))=1;
            rgb2=round(rgb.*255);
            rgb2(rgb2<0)=0;
            rgb2(rgb2>255)=255;
            binar=[dec2bin(rgb2(3),8)   dec2bin(rgb2(2),8) dec2bin(rgb2(1),8)];
            xcol=bin2dec(binar);
            v.Shape.Fill.ForeColor.RGB=xcol;
        end
    end
    
    %% ===============================================
    
    %try; v.Shape.TextFrame.Characters.Font.Size = 10; end
    
  end
  
  WB.Save();% Save Workbook
  WB.Close();% Close Workbook
  Excel.Quit();% Quit Excel
  
  %% ===============================================
  
  
catch ME
%   errorMessage = sprintf('Error in function InsertComments.\n\nError Message:\n%s', ME.message);
%   fprintf(errorMessage);
%   uiwait(warndlg((errorMessage)));
end
return; % from InsertComments