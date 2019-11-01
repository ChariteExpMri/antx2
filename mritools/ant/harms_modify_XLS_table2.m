

cf;clear
warning off

pathres='O:\harms1\harmsStaircaseTrial\results'
tpl     =fullfile(pathres,'harms_targetregions.xls')
infile=fullfile(pathres,'labels_Both_10May2016_164041.xls')
outfile=fullfile(pathres, 'lesion.xls')      

infile_sheets={'vol'  'NvoxBR' 'perBR' }
tpl_sheet     ='Übersicht ausgewählte Regionen'

%•••••••••••c•••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% modify each table/sheet..write sheet
siztab=[];
for j=1:length(infile_sheets)
    [aaa aa a]=xlsread(infile,infile_sheets{j});
    [bbb bb b]=xlsread(tpl,'Übersicht ausgewählte Regionen');
    
    id=[];
    for i=1:size(b,1)
        id(i,1)=  regexpi2(a(:,1), [ '^' b{i,1} '$' ],'match');
    end;
    a2=a(id,:); 
     siztab(j,:)  =size(a2); %SIZE of NEWTAB
     xlswrite(   outfile        ,a2,   infile_sheets{j});%WRITE TO SHEETS
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% get INFO FROM TEMPLATE
t = actxserver('Excel.Application');
twb = t.Workbooks.Open(tpl); %# open the file
set(t, 'Visible', 1);   
 sheet0 = get(t.Worksheets,'Item', tpl_sheet);
 invoke(sheet0, 'Activate');

 % GET PARAMETER
 tb={};
 for i=1:size(b,1)
     myCell = ['A' num2str(i)];%'A3';
     Range = sheet0.Range(myCell);
     tb(i,:)={Range.Interior.Color   Range.ColumnWidth             Range.Font.Size...
                 Range.Font.Bold         Range.Font.Name};
 end
 
 %columWidth of 2nd col --> used for all columns except for col1
 Range = sheet0.Range('B2');
 tb2=Range.ColumnWidth;
 %OTHER PARAMS
 aux.ActiveWindow_Zoom=t.ActiveWindow.Zoom;%
 
twb.Close(false);
t.Quit
t.delete;

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% apply parameters for all sheets

e = actxserver('Excel.Application');
ewb = e.Workbooks.Open(outfile); %# open the file
% E.Workbooks.Open(file);
% set(e, 'Visible', 1);   

for j=1:length(infile_sheets) %FOR EACH SHEET
    
    sheet = get(e.Worksheets,'Item',     infile_sheets{j}    );
    invoke(sheet, 'Activate');
     e.ActiveWindow.Zoom=aux.ActiveWindow_Zoom;
    
    for i=1:  siztab(j,1)
        myCell = ['A' num2str(i) ':'  xlsindex(  siztab(j,2)     ) num2str(i)];
        Range = sheet.Range(myCell);
        Range.Interior.Color  =tb(i,1)  ;
        Range.ColumnWidth =tb2  ;
        Range.Font.Size =tb(i,3)  ;
        Range.Font.Bold =tb(i,4)  ;
        Range.Font.Name=tb(i,5) ;
        Range.Borders.Linestyle=1;
    end
    %set widht of 1st col
    for i=1:  siztab(j,2)  
        myCell = ['A' num2str(i) ];
        Range = sheet.Range(myCell);
        Range.ColumnWidth =tb(i,2)  ;
    end
    
end %j-sheet

 ewb.Save;
ewb.Close(false)
e.Quit
e.delete;




