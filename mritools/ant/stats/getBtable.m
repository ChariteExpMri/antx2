% extract b-table from bruker raw data and store is in ../"thisStudy"/DTI as mrtrix-readable txt-file
% run
% getBtable()
% out=getBtable()   ; % % output: cell  name, b-table and some info from the raw-data
function out=getBtable()
out=[];

% close all; clear;
warning off

clc
% ==============================================
%%
% ===============================================
ui=1;
if ui==1
    pax=pwd;
    
    [pas,sts] = spm_select(1,'dir','select a single(!) raw data set','',pax)
    if sts==0; return; end
else
    pas='F:\data4\ernst_DTImrtrix\raw_DTI';
end
% ==============================================
%%
% ===============================================


[files] = spm_select('FPListRec',pas,'method');
files=cellstr(files);


b={};

for n=1:length(files)
    %disp(n);
    try
        % [2 9 11 13]
        % n=13
        
        f1=files{n};
        
        % ==============================================
        %
        % ===============================================
        
        % 0	0	0	0
        % 119.231	0.298125	-0.135668	0.944836
        % 111.785	-0.61818	0.326095	0.715203
        % 107.214	-0.48421	-0.699431	0.525677
        % 115.853	0.97944	0.0950661	0.17793
        % 110.227	0.286406	0.817122	0.500284
        % 109.805	-0.503173	0.842215	-0.193625
        % pa='D:\Paul\dti_paul\1\20210713_142604_20210713PBS_ERANET_151_LR_1_1\11'
        % f1=fullfile(pa,'method');
        s=preadfile(f1);
        s=s.all;
        hash=find(~cellfun(@isempty,strfind(s,'##')));
        % ==============================================
        %   get DwDir (~line 56)
        % ===============================================
        w1=find(~cellfun(@isempty,strfind(s,'##$PVM_DwDir=')));
        w2=hash(min(find(hash>w1)));
        t1=str2num(strjoin(s(w1+1:w2-1),'  '));
        le=str2num(char(regexprep(s(w1),{'.*(' ,').*'  }   ,'')));
        t2=reshape(t1',[le(2) le(1)])';
        % ==============================================
        %  get PVM_DwEffBval (~line 140)
        % ===============================================
        
        w1=find(~cellfun(@isempty,strfind(s,'##$PVM_DwEffBval=')));
        w2=hash(min(find(hash>w1)));
        c1=str2num(strjoin(s(w1+1:w2-1),' '));
        % le=str2num(char(regexprep(s(w1),{'.*(' ,').*'  }   ,'')));
        c2=c1(end-size(t2,1)+1:end)';
        
        
        %get number of Number of images acquired without diffusion gradients.
        %Bruker Manual: https://cbbi.udel.edu/wp-content/uploads/2019/09/Bruker-Manual-Complete-.pdf
        %page-251
        %A0 Images (PVM_DwAoImages) – Number of images acquired without diffusion gradients.
        tag='##$PVM_DwAoImages=';
        w1=find(~cellfun(@isempty,strfind(s,tag)));
        num_a0image=str2num(char(strrep(s(w1),tag,'')));
        
        tb=[[zeros(num_a0image,size(t2,2)+1)];[c2 t2]];
        
        % ==============================================
        %   test: is it similar?
        % ===============================================
        
        % e=preadfile('b_table.txt'); e=str2num(char(e.all));
        
        % ==============================================
        %   name
        % ===============================================
        w1=find(~cellfun(@isempty,strfind(s,'##$PVM_DwBvalEach=')));
        w2=hash(min(find(hash>w1)));
        
        name0=(char(s(w1+1:w2-1)));
        %disp(['name: ' name0 ]);
        
        % ==============================================
        %   reorder
        % ===============================================
        tb2=tb(:,[2 3 4 1 ]);
        tb2(:,1:2)=tb2(:,1:2)*-1;
        % disp(tb2);
        
        %##### BUG#######
        %         if str2num(name0)==6000
        %             tb3=tb;
        %             'y'
        %         else
        %             tb3=tb2;
        %         end
        %
        %         drawnow
        tb3=tb2;
        
        % ==============================================
        % write to textfile
        % ===============================================
        %         if 0
        %             f2=fullfile(pwd,['grad_' name0 '.txt']);
        %             pwrite2file(f2, tb2);
        %             disp([' sfound in method-#' num2str(n) ': ' f1 ]);
        %         end
        
        % ==============================================
        %% add info
        % ===============================================
        
        ps.file   =f1;
        ps.scanNo =n;
        ps.name0       =name0;
        ps.num_a0image =num_a0image;
        b(end+1,:)={name0 tb2  ps };
        
        %save('dum.txt','tb3' ,'-ascii')
        % ==============================================
        % check
        % ===============================================
        %         if 0
        %             nameref=[ 'grad_b' name0  '.txt'];
        %             f2=fullfile(pwd,nameref);
        %             e=preadfile(f2);
        %             e=str2num(char(e.all));
        %
        %             COLSP=repmat({'|'},[size(e,1) 1]);
        %             % uhelp(plog([],[ num2cell(e) COLSP num2cell(tb) COLSP num2cell(e-tb)   ],0,['ww'],'d=10'),1);
        %
        %             x=[ num2cell(e) COLSP num2cell(tb3) COLSP num2cell(e-tb3)   ];
        %             hx=[...]
        %                 {'DSIc1' 'DSIc2' 'DSIc3' 'DSIc4' '-'} ...
        %                 {'BRc1' 'BRc2' 'BRc3' 'BRc4' '-'} ...
        %                 {'DSIc1-BRc1' 'DSIc2-BRc2' 'DSIc3-BRc3' 'DSIc4-BRc4'} ...
        %                 ];
        %
        %             tit=['comparison "' nameref '" via DSIstudio&Excel  AND direct BRUKER-readout of B-table '];
        %             uhelp(plog([],[ hx;x ],0,tit,'d=10'),1);
        %
        %             if 1
        %                 f3=fullfile(pwd,'test_GetBtable.xlsx');
        %                 pwrite2excel(f3,[  nameref '_vs_BRUKERdirect'], hx,[],x);
        %             end
        %         end
    end %try
    
end


% ==============================================
%%   write stuff
% ===============================================
if size(b,1)>0
    global an
    if isempty(an)
        err=0;
        hf=findobj(0,'tag','DTIprep');
        if ~isempty(hf)
            u=get(hf,'userdata');
            if isfield(u,'studypath') &&  exist(u.studypath)==7
                paout=fullfile(u.studypath,'DTI');
            else
                err=1;
            end
        else
            err=1;
        end
        
        if err==1
            paout=uigetdir(pwd,'select the studie''s "template"-folder..however B-table will be stored in the new "DTI"-dir');
            if isnumeric(paout); return, end
            paout= fullfile(fileparts(paout),'DTI');
        end
        
    else
        paout= fullfile(fileparts(an.datpath),'DTI');
    end
    mkdir(paout);
    
    % ==============================================
    %% check same Name
    % ===============================================
    if length(unique(b(:,1)))~=size(b,1)
        
        names  =  b(:,1);
        scannum=cellfun(@(a){[ num2str(a.scanNo) ]},  b(:,3));
        aquangle=cellfun(@(a){[ num2str(size(a,1)) ]},  b(:,2));
        
        %get counts
        asciinum=cell2mat(cellfun(@(a){[ str2num(regexprep(num2str(double(a)),'\s+','')) ]},  b(:,1)));
        uninum=unique(asciinum);
        uninames=unique(names);
        cnt=histc(asciinum,uninum);
        namedouplets=uninames(find(cnt>1));
        
        t  =   [ names scannum aquangle ];
        ht =   {'b-table NAME'  'scan-number' 'Num of aquis.angles' };
        
        
        ms={'<html><font color=black> <br> '
            'At least one b-table(s) was found more than once!'
            'Presumably, one of the first scans (see scan-number) was used as wharm up!'
            '<HTML> Please select this scan, i.e. select the scan(s) you do <b><u>NOT </b></u> want to use!'
            '<HTML>The here <b><u>selected </b></u> b-table(s) will <b><u>NOT </b></u> used for further DTI-analysis'
            ''
            '<HTML><font color=green><b> &#9654; SELECT THE SCAN WHICH SHOULD <font color=red><u>NOT</u><font color=green> BE USED !! '
            ''
            '---The following b-tables appear more than once: '
            };
        ms=[ms; [ cellfun(@(a){[ '   "' a '"' ]},  namedouplets) ]];
        id=selector2(t,ht,'title','delete files (selected files will be deleted)','note',ms);

        
     b(id,:)=[];
%         
%         % ==============================================
%         %%
%         % ===============================================
  
        
        
    end
    % ==============================================
    %%
    % ===============================================
    
    
    for i=1:size(b,1)
        name=b{i,1};
        tbl =b{i,2};
        p   =b{i,3};
        
        if size(b,1)==1  %SINGLE-SHELL
            f2=fullfile(paout,['grad'       '.txt']);
        else
            f2=fullfile(paout,['grad_b' name '.txt']);
        end
        p.fileout=f2;          b{i,3}=p;
        
        pwrite2file(f2, tbl);
        % ==============================================
        %%
        % ===============================================
        cprintf([0 .5 1], [ num2str(i) 'b-table "' name '" stored as ' strrep(f2,[filesep],[filesep filesep])  '\n']);
        disp(     ['    input file   : '  p.file ]);
        disp(     ['    scan-No      : ' num2str(p.scanNo) ]);
        disp(     ['    no directions: ' num2str(size(tbl,1))   ' (with '  num2str(p.num_a0image) ' images acquired without diffusion gradients)' ]);
        showinfo2(['    output file  :  '] ,f2  ,[],[], [ '>> ' f2 '' ]);
        % ==============================================
        %%
        % ===============================================
        
    end
    
    
else
    msgbox('no b-table found in Bruker raw data') ;
    
end

% ==============================================
%%   output
% ===============================================
if exist('b')==1
    out=b;
end














