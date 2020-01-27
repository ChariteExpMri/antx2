
% sub_write2excel_nopc: write to excelfile for linux and max
% sub_write2excel_nopc(fileout,sheetname, header,data)
% fileout  : ouputfile name
% data     : data (cell) or numeric
% header   : data header (cell), or empty 
% sheetname: name of the sheet or numeric (index of the sheet)
%% EXAMPLE
%     fileout=fullfile(pwd,'_test2.xlsx');
%     data  =rand(3,2);
%     header={'size' 'age'};
%     sheetname='hallo';
%     sub_write2excel_nopc(fileout,sheetname, header,data)


% ==============================================
%%   excel-application does not exist
% ===============================================
% % allenTemplateExcelFile = which('template_results_Allen.xls');
% excelfileSource=z.atlaslabelsource;
% if exist(excelfileSource)~=2
%     keyboard
% end
% [~,sheets,infoXls]=xlsfinfo(excelfileSource);
% if ~isempty(infoXls)
%     isexcel=1;
% else
%     isexcel=0;
% end

function sub_write2excel_nopc(fileout,sheetname, header,data)
warning off;

if 0
    
    fileout=fullfile(pwd,'_test2.xlsx');
    data  =rand(3,2);
    header={'size' 'age'};
    sheetname='hallo';
    sub_write2excel_nopc(fileout,data,header,sheetname);
end



% ==============================================
%%   [1b] EXCEL DOES NOT EXIST
% ===============================================

global an
bkan5=an;
clear an;

%clear an ;% cler global here, because an as global  is destroyed using javaddoath
%%  EXCEL not available
try
%     disp('..excel is not available..using package excelpackage from Alec de Zegher ');
    pa2excel=fullfile(fileparts(which('xlwrite.m')),'poi_library');
    addpath(genpath(pa2excel))
    javaaddpath(fullfile(pa2excel,'poi-3.8-20120326.jar'));
    javaaddpath(fullfile(pa2excel,'poi-ooxml-3.8-20120326.jar'));
    javaaddpath(fullfile(pa2excel,'poi-ooxml-schemas-3.8-20120326.jar'));
    javaaddpath(fullfile(pa2excel,'xmlbeans-2.3.0.jar'));
    javaaddpath(fullfile(pa2excel,'dom4j-1.6.1.jar'));
    javaaddpath(fullfile(pa2excel,'stax-api-1.0.1.jar'));
    
    
%     kk=dir(fullfile(pa2excel,'*.jar'));
%     %     kk=kk(find([kk.isdir]==0));
%     for i=1:length(kk)
%          javaaddpath(fullfile(pa2excel,kk(i).name));
%     end
%     
%     
%     addpath('/dir/20130227_xlwrite/poi_library')
%     javaaddpath('poi_library/poi-3.8-20120326.jar');
%     javaaddpath('poi_library/poi-ooxml-3.8-20120326.jar');
%     javaaddpath('poi_library/poi-ooxml-schemas-3.8-20120326.jar');
%     javaaddpath('poi_library/xmlbeans-2.3.0.jar');
%     javaaddpath('poi_library/dom4j-1.6.1.jar');
%     javaaddpath('poi_library/stax-api-1.0.1.jar');
    
    if iscell(data)==0;          data=num2cell(data);      end        %convert numeric to cell
    if isempty(header)
        xlwrite(fileout, data,  sheetname  )  ;
    else
        xlwrite(fileout, [header(:)';data ],  sheetname  )  ;
    end
    
catch
%     disp('..excel is not available..using "writetable" ');

    
    if iscell(data)==0;          data=num2cell(data);      end        %convert numeric to cell
    
    if isempty(header)
        T=cell2table(data);
        writetable(T,fileout,'Sheet',sheetname,'WriteVariableNames',0 );
    else
        T=cell2table(data,'VariableNames',header(:)');
        writetable(T,fileout,'Sheet',sheetname );
    end
    
    %
    %     end
end

global an
an=bkan5;
