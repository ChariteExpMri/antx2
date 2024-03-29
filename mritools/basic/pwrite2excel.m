function pwrite2excel(filename,sheet,header,subheader,data)
% function pwrite2excel(filename,sheet,header,subheader,data)
% ..freezes header (1st row) or header+subheader (1st+2nd row if subheader is not empty)
% pwrite2excel(filename,sheet,header,subheader,data)
% write data to styled excelfile 
% 
% ## example 1:
% pwrite2excel('_text.xlsx',{1 'RT'},{'time1' 'time2'},{'ms' 's'},rand(5,2))
% 
% ## example 2:
% filename='__muell3.xls';
% header={'TrialNo' 'Condition' 'IMG_HighProb' 'IMG_LowProb' 'POS_HighProb'...
%     'POS_LowProb' 'OUT_HighProb' 'OUT_LowProb'...
%     'Key' 'Time' 'selecedPOS' 'selectedIMG' 'Outcome' };
% 
% subheader={'' ['[1]condition1' char(10) '[2]condition2' char(10) '[3]condition3 (neutral)'] ...
%     ['image-name: HIGH probability outcome' char(10)],[ 'image-name: LOW probability outcome' char(10)]...
%     ['image-position: HIGH probability condition' char(10) '[1]topleft, [2]topright,'  char(10) '[3]bottomleft, [4]bottomright' ],...
%     ['image-position: LOW probability condition'  char(10) '[1]topleft, [2]topright,'  char(10) '[3]bottomleft, [4]bottomright' ],...
%     ['potential outcome: HIGH probability condition:' char(10) '[1]condition1' char(10) '[2]condition2' char(10) '[3]condition3' char(10) '[4]neutral']...
%     ['potential outcome: LOW probability condition:'  char(10) '[1]condition1' char(10) '[2]condition2' char(10) '[3]condition3' char(10) '[4]neutral']...
%     ['keyboard Number & ID' char(10) 'Nr:' ]...
%     ['selected screen position:' char(10) '[1]topleft, [2]topright' char(10) '[3]bottomleft, [4]bottomright' ],...
%     ['..which image was selected' char(10) '[1] HIGH probability outcome' char(10) '[2] LOW probability outcome'],...
%     ['realized outcome:'   char(10) '[0]nothing' char(10) '[1]condition1' char(10) '[2]condition2' char(10) '[3]condition3' char(10) '[4]neutral'  char(10) '[-33]nothing BLANK position selected']...
%     };
% data=[...
%     1     1    14     4     4     3     1     0     6   915     4     1     1
%     2     1    14     4     4     3     4     4     4  1066     3     2     4
%     3     1    14     4     4     3     1     0     4   948     3     2     0
%     4     2    13     8     3     1     0     0     4   764     3     1     0
%     5     1    14     4     4     3     1     0     4  1005     3     2     0
%     6     2    13     8     3     1     0     0     4   631     3     1     0
%     7     3    15     9     3     2     3     3     4  1045     3     1     3
%     8     1    14     4     4     3     0     0     4   786     3     2     0
%     9     2    13     8     3     1     2     0     4   772     3     1     2
%     10     1    14     4     4     3     1     0     4   615     3     2     0
%     11     3    15     9     3     2     0     0     4   676     3     1     0
%     12     1    14     4     4     3     4     4     5   516     1   -33   -33
%     13     1    14     4     4     3     4     4     5   956     1   -33   -33
%     14     1    14     4     4     3     4     4     6   827     4     1     4
%     15     2    13     8     3     1     4     4    18   657     2   -33   -33
%     16     1    14     4     4     3     1     0   NaN   NaN   NaN   NaN   NaN
%     17     3    15     9     3     2     3     0     5   774     1   -33   -33
%     18     3    15     9     3     2     0     0   NaN   NaN   NaN   NaN   NaN
%     19     3    15     9     3     2     0     0   NaN   NaN   NaN   NaN   NaN
%     20     2    13     8     3     1     0     0     5   883     1     2     0];
% pwrite2excel(filename,header,subheader,data);

% ==============================================
%%   
% ===============================================
if iscell(sheet)
    sheetname_old=sheet{1};
    sheetname_new=sheet{2};
    sheet=sheetname_old;
end
%% ==========[test xls-capability]=====================================
[pa,name,ext] = fileparts(filename);
if isempty(pa); 
    pa=pwd; 
end
tempname='001122334455667788991011121314151617181920';
f1=fullfile(pa,[tempname '.xlsx']);
[status,message]=xlswrite(f1,'1');
if isempty(message.message);
    isexcel=1;
else
    isexcel=0;
end
delete(fullfile(pa,[tempname '*']));

% isexcel=0
%% ===============================================

if isexcel==0;
    %% ===============================================
    %%   [1a] EXCEL DOES NOT EXIST
    %% ===============================================
    
    global an
    bkan5=an;
    clear an;
    
    %clear an ;% cler global here, because an as global  is destroyed using javaddoath
    %%  EXCEL not available
    try
        
        pa2excel=fullfile(fileparts(which('xlwrite.m')),'poi_library');
        javaaddpath(fullfile(pa2excel,'poi-3.8-20120326.jar'));
        javaaddpath(fullfile(pa2excel,'poi-ooxml-3.8-20120326.jar'));
        javaaddpath(fullfile(pa2excel,'poi-ooxml-schemas-3.8-20120326.jar'));
        javaaddpath(fullfile(pa2excel,'xmlbeans-2.3.0.jar'));
        javaaddpath(fullfile(pa2excel,'dom4j-1.6.1.jar'));
        javaaddpath(fullfile(pa2excel,'stax-api-1.0.1.jar'));
      
        s = xlwrite(filename, header   , sheet, 'A1');
        if ~isempty(subheader)
            s = xlwrite(filename, subheader, sheet, 'A2');
            s = xlwrite(filename, data,   sheet, 'A3');
        else %no subheader
            s = xlwrite(filename, data,   sheet, 'A2');
        end
        
        %disp('..excel is not available..using package excelpackage from Alec de Zegher ');
    catch
       
        %% ===============================================
        
        if iscell(data)==0
            data2=num2cell(data);
        else
            data2=data;
        end
%         if ~isempty(subheader)
%             data=[subheader(:)'; data]
%         end
         T=cell2table(data2,'VariableNames',header);
         writetable(T,filename,'Sheet',sheet);
         
         %% ====[change xlssheetname]===========================================
         try
             [pa,name,ext] = fileparts(filename);
             if isempty(pa); pa=pwd; end
             
             fzip=fullfile(pa,[name '.zip']);
             movefile(filename,fzip);
             pa_unzip=fullfile(pa,name);
             filesZip=unzip(fzip,pa_unzip);
             
             f1=filesZip{regexpi2(filesZip,'workbook.xml$')};
             a=preadfile(f1); a=a.all;
             iline=regexpi2(a,[ 'sheetId="' num2str(sheet) '"']);
             l=a{iline};
             
             isheet=regexpi(l,[ 'sheetId="' num2str(sheet) '"']);
             isheetname=regexpi(l,[ '<sheet name="']);
             isheetname=isheetname(max(find(isheetname<isheet)));
             s1=l(1:isheetname-1) ;
             s3=l(isheet:end) ;
             inSheetName=regexprep([l(isheetname:isheet-1) '_lor'],{'<sheet name="' '".*'},{''});
             s2=[regexprep(l(isheetname:isheet-1),'".*"',['"' sheetname_new  '"'])];
             l2=[s1 s2 s3];
             
             a(iline)={l2};
             pwrite2file(f1,a);
             %-----
             f1=filesZip{regexpi2(filesZip,'app.xml$')};
             a=preadfile(f1); a=a.all;
             a2=regexprep(a,inSheetName, sheetname_new);
             pwrite2file(f1,a2);
             
             zip( fzip  ,'.',pa_unzip);
             movefile(fzip,filename);
             
             try; rmdir(pa_unzip,'s'); end
         end
         
         
         
      %% ===============================================

        
         %% ===============================================
%          
%         writetable(table(infox),fileout,'Sheet','INFO')
%         for i=1:length(pp.paramname)
%             tbx=[...
%                 pp.Eheader
%                 [pp.Elabel num2cell(squeeze(pp.tb(:,i,:)))]
%                 ];
%             try
%                 T=cell2table(tbx(2:end,:),'VariableNames',tbx(1,:));
%             catch
%                 %issue with VariableNames 'first character must be char')
%                 i_numeric=regexpi2(tbx(1,:),'^\d|_') ;%indicate if 1st letter is numeric or 'underscore'
%                 tbx(1,i_numeric)=cellfun(@(a){['s' a ]},tbx(1,i_numeric));
%                 T=cell2table(tbx(2:end,:),'VariableNames',tbx(1,:));
%             end
%             writetable(T,fileout,'Sheet',pp.paramname{i} );
%         end
%         % add SHEEET "atlas" WITH:  'Region'  'colHex'  'colRGB'  'ID'  'Children'
%         try
%             T=cell2table(z.atlasTB,'VariableNames',z.atlasTBH);
%             writetable(T,fileout,'Sheet','atlas' );
%         end
%         disp('..excel is not available..using "writetable" ');

    end
    
    global an
    an=bkan5;
    %% ===============================================
    return
end


s = xlswrite(filename, header   , sheet, 'A1');
if ~isempty(subheader)
    nline2color=2;
    s = xlswrite(filename, subheader, sheet, 'A2');
    s = xlswrite(filename, data,   sheet, 'A3');
else %no subheader
    s = xlswrite(filename, data,   sheet, 'A2');
    nline2color=1;
end





% ==============================================
%%   actxserver
% ===============================================
try
exc=actxserver('excel.application');
catch
   return 
end

numLines = size(data,1)+size(subheader,1)+size(header,1); %number of lines

[PATHSTR,NAME,EXT] = fileparts(filename);
if isempty(PATHSTR)
    try
   wb=exc.Workbooks.Open([pwd '\' filename]);
    catch
    wb=exc.Workbooks.Open( filename);     
    end
else 
wb=exc.Workbooks.Open(filename);
end

% get(wb.Activesheet)
beg=strfind(char(1:100),'A')-1;
col=[beg+1:beg+26]';

col2=cellstr(char(col));
for i=1:10
    col2=[col2;  cellstr( char([ repmat(col(i),[size(col,1) 1])  col ]) ) ];
end

for i=1:2:length(header)
    wb.Worksheets.Item(sheet).Range([col2{i} ...
        num2str(1) ':' col2{i}  num2str(nline2color)   ]).Interior.ColorIndex=6;
    if i+1<=length(header)
        wb.Worksheets.Item(sheet).Range([col2{i+1}  num2str(1) ':' ...
            col2{i+1}   num2str(nline2color)   ]).Interior.ColorIndex=15;
    end
end

% for i=1:2:length(header)
%     wb.Worksheets.Item(sheet).Range([char(beg+i) ...
%         num2str(1) ':' char(beg+i)  num2str(2)   ]).Interior.ColorIndex=6;
%     if i+1<=length(header)
%         wb.Worksheets.Item(sheet).Range([char(beg+i+1)  num2str(1) ':' char(beg+i+1)  num2str(2)   ]).Interior.ColorIndex=15;
%     end
% end
es=wb.Activesheet;
% es.Range('A:V').EntireColumn.AutoFit;
% es.Range('A1:V1').Cell.Font.Bold=1;
% es.Range('A1:V300').Cell.Font.Size=8;
% es.Range('A2:V2').Cell.Font.Size=8;

es.Range(['A1:' col2{length(header)}  '1']).Cell.Font.Bold=1;
% es.Range(['A1:' col2{length(header)}  '1000']).Cell.Font.Size=8;
es.Range(['A1:' col2{length(header)}  num2str(numLines)]).Cell.Font.Size=8;

% range=invoke(es,'Range',['A1:' char(beg+i) num2str(2) ]);
range=invoke(es,'Range',['A1:' col2{length(header)}  num2str(1) ]);
borders=get(range,'Borders');
borderspec=get(borders,'Item',4);
set(borderspec,'ColorIndex',1);
set(borderspec,'Linestyle',1);

% %es.Range("A1:A1").Select
es.Range('A1').Activate;

invoke(es.Columns,'AutoFit');
if exist('sheetname_new')
    wb.Worksheets.Item(sheetname_old).Name= sheetname_new;
end

% -- freeze first row ---------
try
    ncolfreeze=1;
    if ~isempty(subheader)
        ncolfreeze=2;
    end
    es.Activate();
    es.Application.ActiveWindow.SplitRow = ncolfreeze;
    es.Application.ActiveWindow.FreezePanes = true;
end

% 
wb.Worksheets.Item(1).Activate; %activate first sheet
%---------------------------
wb.Save();
wb.Close();
exc.Quit();


try;
      xlsremovdefaultsheets(filename);
end

