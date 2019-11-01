%% #b select files via GUI from defined/selected mouse-folders
% pa: cell with paths
% use
% pa=antcb('getsubjects');
% pa=antcb('getallsubjects');
% files=xselectfiles(pa)

function files=xselectfiles(pa)

% if exist('pa')~=1
%     clip2clipcell; %make matlabCell
%     pa=clipboard('paste');
%     
%     
% end

files=getuniquefiles(pa);


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

% function he=getdirs()
% global an;
% pa=antcb('getsubjects');
% 
% [t,sts] = cfg_getfile2(inf,'dir',{'SELECT MOUSE-FOLDER(S)',''},'',pa);
% if isempty(isempty(char(t)))
%    he='';
%    return;
% end
% he=strrep(strrep(t,[an.datpath filesep],''),filesep,'')


function he=getuniquefiles(pa)
% keyboard
% global an
% pa=antcb('getallsubjects'); %path
%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
%% fileList
li={};
if 1
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*..*$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=unique(fi2);
    [li dum ncountid]=unique(fi2);
    %% count files
    ncount=zeros(size(li,1),1);
    for i=1:size(li,1)
       ncount(i,1) =length(find(ncountid==i));
    end
end
tb=[li cellstr(num2str(ncount))];
he=selector2(tb,{'Unique-Files-In-Study', 'Ntimes-In-Study'},'out','col-1','selection','multi');
