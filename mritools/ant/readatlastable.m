


% read atlas table (xls-file)
% options:
% readatlastable()           % determine from global object
% readatlastable('select')   %select atlas via gui
% readatlastable('O:\data5\ant2_hikish_win\templates\ANO.xls'); %specify


function [tb tbh filename  ] =readatlastable(atlasfile)

if exist('atlasfile')==0
    global an
    tpa  =  fullfile(fileparts(an.datpath),'templates');
    if exist(fullfile(tpa,'ANO.xlsx'))==2
        fi=(fullfile(tpa,'ANO.xlsx'));
    else
        error([fullfile(tpa,'ANO.xlsx') '..not found']);
    end
else
    if strcmp(atlasfile,'select')
        [t,sts] = spm_select(1,'any','select atlas table (*.xlsfile)','',pwd,'.*.xlsx','');
       
        if isempty(t); return; end
         fi=char(cellstr(t));
    else
        fi=char(cellstr(atlasfile));
    end
end

%% ________________________________________________________________________________________________

if exist(fi)~=2
    error('alas table does not exist');
end


[pas fis ext]=fileparts(fi);

if strcmp(ext,'.xlsx')
    [~,~,tb]=xlsread(fi);
    tb(:,regexpi2(cellfun(@(a){num2str(a)},  tb(1,:)),'NaN'))=[]; %remove NAN-cols
    tb(regexpi2(cellfun(@(a){num2str(a)},  tb(:,1)),'NaN'),:)=[]; %remove NAN-rows
    tbh=tb(1,:);
    tb =tb(2:end,:);
    filename=fi;
    
    tb(:,5)=cellfun(@(a){str2num(num2str(a))},  tb(:,5)); %make chidren numeric
    
else
    error(' no other format supported jet');
end


