

%% mergexlsfiles: merge excelfiles (result files) of anatomical regions 
% user is guided to select the xls-files and type the name of the merged excel file
% (no input) 

% 
% 'labels_c_ADC_native_group1.xls'
% 'labels_c_ADC_native_group2.xls'
% 'labels_c_FA_native_group1.xls'
% 'labels_c_FA_native_group2.xls'
% 'labels_c_axialDif_native_group1.xls'
% 'labels_c_axialDif_native_group2.xls'
% 'labels_c_radialDif_native_group1.xls'
% 'labels_c_radialDif_native_group2.xls'


function mergexlsfiles

[fi, pa] = uigetfile( '*.xls;*.xlsx', 'select excelfiles to merge',  'MultiSelect', 'on');
fis=cellfun(@(a) {[ pa   a]},   fi'  );



[~,  sheets ]=xlsfinfo(fis{1});

% fi2=strrep(fis{1},'_group1','_ALL');

fi2=regexprep(fis{1},['group\d*|gruppe\d*'],'ALL','ignorecase');
if strcmp(fis{1},fi2)
    [pout dum ext]=fileparts(fis{1});
    %s=input('type a name for the new merged excel-file: ' ,'s');
     [r r2]=uiputfile(fullfile(pout,'*.*'),'name for the new merged excel-file');
    if (r==0); disp('missing name of the new merged excel-file'); return;end
   
    s=regexprep(r,['\..*'],'');
    s=regexprep(s,'\s','');
    fi2=fullfile(r2, [  s ext] );
end

disp('merge excel files');
copyfile(fis{1},fi2,'f');

fis{1}=fi2;
ncases={};
for i=1:length(sheets)
    disp(sheets(i));
    
    x={};
    tb={};
    for j=1:length(fis)
        [~,~,a]=xlsread(fis{j},sheets{i} );
       % x{j}=a;
        
        if i==1
            ia=find(strcmp(cellfun(  @(a)  {num2str(a)}      ,a(:,1) ),'NaN')==0);
            tb=[tb; '-------------'; a(ia,1)  ];
        else
            if j==1
                ia=1:max(find(strcmp(cellfun(  @(a)  {num2str(a)}      ,a(1,:) ),'NaN')==0));
                if i==2
                    [~,namex,extx]=fileparts(fis{j});
                    ncases(end+1,:)=  {  [namex,extx]   length(ia)-1  };
                end
            else
                ia=2:max(find(strcmp(cellfun(  @(a)  {num2str(a)}      ,a(1,:) ),'NaN')==0));
                if i==2
                    [~,namex,extx]=fileparts(fis{j});
                    ncases(end+1,:)=  {  [namex,extx]   length(ia)  };
                end
            end
            tb=[tb  a(:,ia)  ];
        end 
    end
    
    
%     [~,~,a]=xlsread(fi2,sheets{i} );
%     [~,~,b]=xlsread(fis{2},sheets{i} );
%     
%     if i==1 % info sheet
%         ia=find(strcmp(cellfun(  @(a)  {num2str(a)}      ,a(:,1) ),'NaN')==0);
%         ib=find(strcmp(cellfun(  @(a)  {num2str(a)}      ,b(:,1) ),'NaN')==0);
%         tb=[a(ia,1) ;'################'; b(ib,1)];
%     else
%         ia=1:max(find(strcmp(cellfun(  @(a)  {num2str(a)}      ,a(1,:) ),'NaN')==0));
%         ib=2:max(find(strcmp(cellfun(  @(a)  {num2str(a)}      ,b(1,:) ),'NaN')==0));
%         tb=[a(:,ia) b(:,ib)];
%     end
    
    xlswrite(fi2,  tb   ,sheets{i});

end


realized=length(tb(1,2:end));
expected = sum(cell2mat(ncases(:,2)));

[~,namex,extx]=fileparts(fi2);
ncases2=[{'IN or OUT' 'FILES '   'Ncases'};...
    [repmat({'input'}, [size(ncases,1) 1]) ncases];...
    {'output' [namex,extx]  [num2str(realized) ' (' num2str(expected) ' expected)'] }];
disp('  ');
disp([repmat('=',[1 3])   'MERGED EXCEL-FILES' repmat('=',[1 70])]);
disp(ncases2);
disp(repmat('=',[1 100]));

try
    disp(['merged xlsfile: <a href="matlab: explorerpreselect(''' fi2 ''')">' fi2 '</a>'  ]);
end


