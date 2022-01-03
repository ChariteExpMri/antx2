

%% mergexlsfiles: merge output files (excel-files) of GET-ANATOMICAL-labels (xgetlabels4)
% mergeXLSfilesGAL(fis, fiout)
% no input:--> user selection via GUI
% otherwise:
%   fis:  cell, list of excel-files
%   fiout: string, output-file
%% example: merge two result-files from 'GAL' save as test6.xlsx
% fis={    'H:\Daten-2\Imaging\AG_Mueller_Mainz\stat_regionwise\all_regs_round1.xlsx'
%         'H:\Daten-2\Imaging\AG_Mueller_Mainz\stat_regionwise\all_regs_round2.xlsx'}
% fiout='H:\Daten-2\Imaging\AG_Mueller_Mainz\stat_regionwise\test6.xlsx'
% mergeXLSfilesGAL(fis, fiout)
    



function mergeXLSfilesGAL(fis, fiout)
warning off;

if 0
    
    fis={    'H:\Daten-2\Imaging\AG_Mueller_Mainz\stat_regionwise\all_regs_round1.xlsx'
        'H:\Daten-2\Imaging\AG_Mueller_Mainz\stat_regionwise\all_regs_round2.xlsx'}
    fiout='H:\Daten-2\Imaging\AG_Mueller_Mainz\stat_regionwise\test6.xlsx'
    mergeXLSfilesGAL(fis, fiout)
end



%% ======in=========================================

if exist('fis')==0 || isempty(fis) || all(existn(fis)==2)==0
    [fi, pa] = uigetfile( '*.xls;*.xlsx', 'select excelfiles to merge',  'MultiSelect', 'on');
    fis=cellfun(@(a) {[ pa   a]},   fi'  );
end

%% ======out=========================================
if exist('fiout')==0 || isempty(fiout)
    [pout dum ext]=fileparts(fis{1});
    
    
    
    %s=input('type a name for the new merged excel-file: ' ,'s');
    [r r2]=uiputfile(fullfile(pout,'*.*'),'name for the new merged excel-file');
    if (r==0); disp('missing name of the new merged excel-file'); return;end
    
    s=regexprep(r,['\..*'],'');
    s=regexprep(s,'\s','');
    fiout=fullfile(r2, [  s ext] );
end

%% ============keep this sheets ===================================

[~,  sheets ]=xlsfinfo(fis{1});
sh2remove1=cellfun(@(a){[ 'Tabelle' num2str(a)   ]},num2cell(1:10));
sh2remove2=cellfun(@(a){[ 'Sheet' num2str(a)   ]},num2cell(1:10));
sh2remove=[sh2remove1 sh2remove2 'atlasTmp'];
sheets = setdiff(sheets,sh2remove,'stable');
% ==============================================
%%   loop
% ===============================================
disp('merge excel files');
% copyfile(fis{1},fiout,'f');


%% ===============================================
ncases={};
for i=1:length(sheets)
    disp(sheets(i));
    
    x={};
    tb={};
    for j=1:length(fis)
        [~,~,a]=xlsread(fis{j},sheets{i} );
        % x{j}=a;
        
        if strcmp(sheets(i),'INFO')
            ia=find(strcmp(cellfun(  @(a)  {num2str(a)}      ,a(:,1) ),'NaN')==0);
            tb=[tb; '-------------'; a(ia,1)  ];
        elseif strcmp(sheets(i),'atlas')
            %ia=find(strcmp(cellfun(  @(a)  {num2str(a)}      ,a(:,1) ),'NaN')==0);
            %...do nothing
        else
            if j==1
                ia=1:max(find(strcmp(cellfun(  @(a)  {num2str(a)}      ,a(1,:) ),'NaN')==0));
                if strcmp(sheets(i),'frequency')
                    [~,namex,extx]=fileparts(fis{j});
                    ncases(end+1,:)=  {  [namex,extx]   length(ia)-1  };
                end
            else
                ia=2:max(find(strcmp(cellfun(  @(a)  {num2str(a)}      ,a(1,:) ),'NaN')==0));
                if strcmp(sheets(i),'frequency')
                    [~,namex,extx]=fileparts(fis{j});
                    ncases(end+1,:)=  {  [namex,extx]   length(ia)  };
                end
            end
            tb=[tb  a(:,ia)  ];
        end
    end
    
    
    
    if ~isempty(tb)
        %xlswrite(fiout,  tb   ,sheets{i});
        
        pwrite2excel(fiout,{i sheets{i}}, tb(1,:),[],tb(2:end,:));
    end
    
end


% ==============================================
%%   remove sheets
% ===============================================
if 0
    [~, sheets] = xlsfinfo(fiout);
    sh2remove1=cellfun(@(a){[ 'Tabelle' num2str(a)   ]},num2cell(1:10))
    sh2remove2=cellfun(@(a){[ 'Sheet' num2str(a)   ]},num2cell(1:10))
    sh2remove=[sh2remove1 sh2remove2]
    sheetNames2remove = intersect(sheets,sh2remove);
    
    objExcel = actxserver('Excel.Application');
    objExcel.Workbooks.Open(fiout);
    
    for i = 1:numel(sheetNames2remove)
        objExcel.Worksheets.Item(sheetNames2remove{i}).Delete;
    end
    objExcel.ActiveWorkbook.Save;
    objExcel.ActiveWorkbook.Close;
    objExcel.Quit;
    objExcel.delete;
end
% ==============================================
%%   
% ===============================================

realized=length(tb(1,2:end));
expected = sum(cell2mat(ncases(:,2)));

[~,namex,extx]=fileparts(fiout);
ncases2=[{'IN or OUT' 'FILES '   'Ncases'};...
    [repmat({'input'}, [size(ncases,1) 1]) ncases];...
    {'output' [namex,extx]  [num2str(realized) ' (' num2str(expected) ' expected)'] }];
disp('  ');
disp([repmat('=',[1 3])   'MERGED EXCEL-FILES' repmat('=',[1 70])]);
disp(ncases2);
disp(repmat('=',[1 100]));

try
    disp(['merged xlsfile: <a href="matlab: explorerpreselect(''' fiout ''')">' fiout '</a>'  ]);
end


