% extract b-table from bruker raw data and store is in ../"thisStudy"/DTI as mrtrix-readable txt-file
% run
% getBtable()
% out=getBtable()   ; % % output: cell  name, b-table and some info from the raw-data
% 
% varargin: additional pairwise inputs args:
%     write   : write btables to DTI-folder, [0|1], default: [1]
%     verbose : print messages to screen, [0|1], default: [1]
%     wfi     : wait for input (selection window appears in case of identical btables (names), [0|1], default: [1]
%% --examples: 
% o=getBtable_mod([],'verbose',0,'write',0);
% o=getBtable_mod('H:\Daten-2\Extern\AG_Schmid\testSets_25sep23\raw\20230918_153050_wmstrokepilot_VV1074_TP4_1_5','verbose',0,'write',0);
% o=getBtable_mod('H:\Daten-2\Extern\AG_Schmid\testSets_25sep23\raw\20230918_153050_wmstrokepilot_VV1074_TP4_1_5','verbose',0,'write',0);
% o=getBtable_mod('H:\Daten-2\Extern\AG_Schmid\testSets_25sep23\raw\20230918_153050_wmstrokepilot_VV1074_TP4_1_5','verbose',1,'write',1,'wfi',0);


function out=getBtable(brukerdata,varargin)
out=[];
isGUI=1;
if exist('brukerdata')==1 && ~isempty(brukerdata)
    brukerdata=char(brukerdata);
    if exist(brukerdata)==7
        pas=brukerdata;
        isGUI=0;
    else
       error('brucker data do not exist'); 
    end
end

% close all; clear;
warning off;

%% ======[config & addit input arguments]===========================
par.write  =1; %write btables to DTI-folder, [0|1], default: [1]
par.verbose=1; %print messages to screen, [0|1], default: [1]
par.wfi    =1; %wait for input (if identical btale-names appread...show message), [0|1], default: [1]
par.fom    =1; %file-out(name)-mode: [1] outname is Bruker's "ACQ_protocol_name"_"ScanNo"_"expNo", where expNo is set to "1" 
               % [2] old style   ; using (default:[1])
if ~isempty(varargin)
    try
        parin= cell2struct(varargin(2:2:end),varargin(1:2:end),2);
        par  = catstruct(par,parin);
    end
end
%% ===============================================



if isGUI==1
    pax=pwd;
    cprintf('*[1 0 1]', [ 'Please select one(!) raw data set via GUI' '\n' ]);
    [pas,sts] = spm_select(1,'dir','select a single(!) raw data set','',pax);
    if sts==0; return; end
% else
%     pas='F:\data4\ernst_DTImrtrix\raw_DTI';
end
% ==============================================
%%
% ===============================================


[files] = spm_select('FPListRec',pas,'method');
files=cellstr(files);


b={};

for n=1:length(files)
    %disp(n);
    pp=struct();
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
      
        %% ===============================================
         str='##$PVM_DwNDiffExpEach='; %NUMBER OF REPETItIONS
        w1=find(~cellfun(@isempty,strfind(s,str)));
        pp.PVM_DwNDiffExpEach= str2num(strrep(s{w1},str,''));
        
         
         str='##$PVM_DwNDiffDir='; %NUMBER OF DIRECTIONS
         w1=find(~cellfun(@isempty,strfind(s,str)));
        pp.PVM_DwNDiffDir= str2num(strrep(s{w1},str,''));
         
        
         str='##$PVM_DwAoImages='; %NUMBER OF B0-images
          w1=find(~cellfun(@isempty,strfind(s,str)));
        pp.PVM_DwAoImages= str2num(strrep(s{w1},str,''));
         
        
        %% REVESE PHASE ENCODING
        %         ##$ReversedPhaseEncoding=Yes
        % ##$ReversedPEMethod=Standard
         str='##$ReversedPhaseEncoding='; %NUMBER OF DIRECTIONS
         w1=find(~cellfun(@isempty,strfind(s,str)));
         pp.ReversedPhaseEncoding=0;
         if ~isempty(w1)
             if ~isempty(strfind(strrep(s{w1},str,''),'Yes'))
                 pp.ReversedPhaseEncoding=1;
             end
         end
        
        
         %% ===============================================
         
        % ==============================================
        %%   get DwDir (~line 56)
        % ===============================================
        w1=find(~cellfun(@isempty,strfind(s,'##$PVM_DwDir=')));
        w2=hash(min(find(hash>w1)));
        t1=str2num(strjoin(s(w1+1:w2-1),'  '));
        le=str2num(char(regexprep(s(w1),{'.*(' ,').*'  }   ,'')));
        %t2=reshape(t1',[le(2) le(1)])';
        DwDir=reshape(t1',[le(2) le(1)])';
        pp.DwDir=DwDir;
        % ==============================================
        %%  get PVM_DwEffBval (~line 140)
        % ===============================================
        
        w1=find(~cellfun(@isempty,strfind(s,'##$PVM_DwEffBval=')));
        w2=hash(min(find(hash>w1)));
        c1=str2num(strjoin(s(w1+1:w2-1),' '));
        pp.Bval=c1(:);
        % le=str2num(char(regexprep(s(w1),{'.*(' ,').*'  }   ,'')));
        %c2=c1(end-size(t2,1)+1:end)';
        
        % ==============================================
        %% make table
        % ===============================================

        %% ===============================================
        if 0
            %get number of Number of images acquired without diffusion gradients.
            %Bruker Manual: https://cbbi.udel.edu/wp-content/uploads/2019/09/Bruker-Manual-Complete-.pdf
            %page-251
            %A0 Images (PVM_DwAoImages) – Number of images acquired without diffusion gradients.
            tag='##$PVM_DwAoImages=';
            w1=find(~cellfun(@isempty,strfind(s,tag)));
            num_a0image=str2num(char(strrep(s(w1),tag,'')));
            tb=[[zeros(num_a0image,size(t2,2)+1)];[c2 t2]];
        end
        tb=zeros(length(pp.Bval),4);
        tb(:,1)=pp.Bval ;%set bvalues to 1st-column
        direc=repmat(pp.DwDir,[pp.PVM_DwNDiffExpEach 1]); %repmat directions if pp.PVM_DwNDiffExpEach>1
        tb(end-size(direc,1)+1:end,2:end)=direc;% set directions to column2,3,4
        tb(1:pp.PVM_DwAoImages,:)=0  ;% set b0-values and directions to Zeros
        % ==============================================
        %%
        % ===============================================

        
        
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
        name0=regexprep(name0,'\s','_');
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
        %% read acqp-file
        % ===============================================
        f_acqp=fullfile(fileparts(f1),'acqp');
        a=preadfile(f_acqp);         a=a.all;
        ahash=find(~cellfun(@isempty,strfind(a,'##')));
        %% ===============================================
          str='##$ACQ_protocol_name'; %NUMBER OF B0-images
          w1=find(~cellfun(@isempty,strfind(a,str)));
          pp.ACQ_protocol_name= regexprep(a{w1+1},'^<|>$','');
        
        
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
        ps=pp;
        
        ps.file   =f1;
        ps.scanNo =n;
        
        %final output-filename
        if par.fom  ==1
            ps.name0=ps.ACQ_protocol_name;  %use protocol-name
        elseif par.fom  ==2
            ps.name0       =name0;
        end
        
        
        ps.num_a0image =pp.PVM_DwAoImages;
        b(end+1,:)={ps.name0 tb2  ps };
        
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
    if par.write==1
        mkdir(paout);
    else
        disp('files not written to disk (simulation mode)');
    end
    
    
    
    
    %% ========[ add filename suffix for replicant files ]=======
    if par.fom==1
        % do nothing
    else
        names=b(:,1);
        unifiles=unique(names);
        for i=1:length(unifiles)
            ix=find(strcmp(names,unifiles{i}));
            for j=2:length(ix)
                names{ix(j)}=[names{ix(j)} '__' num2str(j)];
            end
        end
        b(:,1)=names;
    end
    %% ========[define output_file-Names]========================
    for i=1:size(b,1)
        name=b{i,1};
        tbl =b{i,2};
        p   =b{i,3};
        
        if par.fom==1
            expNo=1;
            outname=['grad_' name  '_' num2str(b{i,3}.scanNo)  '_' num2str(expNo)  '.txt'];
        else
            if size(b,1)==1  %SINGLE-SHELL
                outname=['grad'       '.txt'];
            else
                outname=['grad_b' name '.txt'];
            end
        end
        p.fileout    =fullfile(paout,outname);
        p.fileoutName=outname;
        b{i,3}=p;
    end
    
    
    
    
    
    
    
    % ==============================================
    %% check same Name
    % ===============================================
    if length(unique(b(:,1)))~=size(b,1)  && par.wfi==1
        
        names                =b(:,1);
        scannum              =cellfun(@(a){[ num2str(a.scanNo) ]},  b(:,3));
        aquangle             =cellfun(@(a){[ num2str(size(a,1)) ]},  b(:,2));
        ACQ_protocol_name    =cellfun(@(a){[ (a.ACQ_protocol_name) ]},  b(:,3));
        RAW_file             =cellfun(@(a){[ (a.file) ]},  b(:,3));
        File_outName         =cellfun(@(a){[ (a.fileoutName) ]},  b(:,3));
        ReversedPhaseEncoding=cellfun(@(a){[ num2str(a.ReversedPhaseEncoding) ]},  b(:,3));
        
        %get counts
        asciinum=cell2mat(cellfun(@(a){[ str2num(regexprep(num2str(double(a)),'\s+','')) ]},  b(:,1)));
        uninum=unique(asciinum);
        uninames=unique(names);
        cnt=histc(asciinum,uninum);
        namedouplets=uninames(find(cnt>1));
        
        t  =   [ names scannum aquangle ...
            ACQ_protocol_name File_outName ...
            ReversedPhaseEncoding ...
            RAW_file];
        ht =   {'b-table NAME'  'scanNo' 'NoDirs' ...
            'protocolName'  'outputFileName (proposed)'...
            'ReversedPhaseEncoding' ...
            'RAWfile'};
        
        %% ===============================================
        
        ms={'<html><font color=black> <br> '
            'At least one b-table was found more than once!'
            'Presumably, one of the first scans (see scan-number) was used as wharm up!'
            '<HTML> Please select this scan, i.e. select the scan(s) you do <b><u>NOT </b></u> want to use!'
            '<HTML>The here <b><u>selected </b></u> b-table(s) will <b><u>NOT </b></u> used for further DTI-analysis'
            '<HTML><font color=green><b> &#9654; SELECT THE SCAN WHICH SHOULD <font color=red><u>NOT</u><font color=green> BE USED !! '
            '---The following b-tables appear more than once: '
            };
        ms=[ms; [ cellfun(@(a){[ '   "' a '"' ]},  namedouplets) ]];
        ms{end+1,1}='   ';
        
        if 1
            hl={['<HTML><font color=blue><b>' 'Below is the CONTENT OF all B-tables' '</font></b>']};
            for i=1:size(b,1)
                hl{end+1,1}=[repmat('-',[1 50 ])];
                hl{end+1,1}=['<HTML><font color=green><b> &#9654;' [ ' [' num2str(i) '] '  b{i,1}]   '</font></b>'];
                hl{end+1,1}=[repmat('-',[1 50 ])];
                [~,hl ]=plog(hl,[ b{i,2}],0,'','al=1;plotlines=0' );
            end
            ms=[ms; hl];
        end
        
        
        id=selector2(t,ht,'title','delete files (selected files will be deleted)','note',ms);
        %% ===============================================

        
        %abort
     if length(id)==1 && id==-1
         return
     end
        
     b(id,:)=[];

        
end
    % ==============================================
    %%
    % ===============================================

    
    %% ========[write FILES]========================
    
    for i=1:size(b,1)
        name=b{i,1};
        tbl =b{i,2};
        p   =b{i,3};
        
       
        f2=p.fileout;          
        if par.write==1
            pwrite2file(f2, tbl);
        end
        % ==============================================
        %%
        % ===============================================
        if 0
            cprintf([0 .5 1], [ num2str(i) 'b-table "' name '" stored as ' strrep(f2,[filesep],[filesep filesep])  '\n']);
            disp(     ['    input file   : '  p.file ]);
            disp(     ['    scan-No      : ' num2str(p.scanNo) ]);
            disp(     ['    no directions: ' num2str(size(tbl,1))   ' (with '  num2str(p.num_a0image) ' images acquired without diffusion gradients)' ]);
            showinfo2(['    output file  :  '] ,f2  ,[],[], [ '>> ' f2 '' ]);
        end
        % ==============================================
        %%
        % ===============================================
        
    end
    %% ============ write logfile ===================================
    l2={};
    for i=1:size(b,1)
        [~, animal]=fileparts(fileparts(fileparts(b{i,3}.file)));
        [~,filenameOut,ext]=fileparts(b{i,3}.fileout);
        filenameOut=[filenameOut ext];
        l={animal b{i,3}.scanNo b{i,3}.ACQ_protocol_name ...
            size(b{i,3}.Bval,1) ...
            b{i,3}.PVM_DwNDiffExpEach b{i,3}.PVM_DwNDiffDir b{i,3}.PVM_DwAoImages ...
            b{i,3}.file     b{i,3}.fileout filenameOut...
            };
        l2=[l2;l];
    end
    hl2={'animal' 'scanNo' 'ACQprotocolName' ...
        'NoDirs' ...
        'PVM_DwNDiffExpEach' 'PVM_DwNDiffDir' 'PVM_DwAoImages' ...
        'fileRaw' 'fileOut' 'fileNameOut'};
    %writetable(cell2table(l2,'variablenames',hl2),'dum.csv')
    
    %% =========write log file Json ======================================
    hl3={};
    for i=1:size(l2,1)
       hl3{i,1}= cell2struct(l2(i,:)',hl2(:),1);
    end
    logfile=fullfile(paout,['_log_Btables_' datestr(now,'dd-mmm-yy_HH-MM-SS') '.log']);
    if par.write==1
        spm_jsonwrite(logfile, hl3, struct('indent','\t'));
        showinfo2('logfile',logfile);
    end
     %q= spm_jsonread(logfile);
    
    %% ===============================================
    
    
%         PVM_DwNDiffExpEach: 2
%         PVM_DwNDiffDir: 25
%         PVM_DwAoImages: 5
%                  DwDir: [25x3 double]
%                   Bval: [55x1 double]
%      ACQ_protocol_name: 'DTI_EPI_seg_30dir_sat'
%                   file: 'H:\Daten-2\Extern\AG_Schmid\testSets_25sep23\raw\2…'
%                 scanNo: 4
%                  name0: '1000_2000'
%            num_a0image: 5
%                fileout: 'H:\Daten-2\Extern\AG_Schmid\testSets_25sep23\DTI\g…'
% l={
    %% ===============================================
    
else
    msgbox('no b-table found in Bruker raw data') ;
    
end

% ==============================================
%%   output
% ===============================================
if exist('b')==1
    
    [~,isort]=sort(cell2mat(cellfun(@(a){[ size(a,1) ]} ,b(:,2))));
    c=b(isort,:);
    
    for i=1:size(c,1)
        name=c{i,1};
        f2=c{i,3}.fileout;
        % ===============================================
        if par.verbose==1;
            cprintf([0 .5 1], [ num2str(i) 'b-table "' name '" stored as ' strrep(f2,[filesep],[filesep filesep])  '\n']);
            fprintf(         ['    no directions   : ']);
            cprintf('*[1 0 0]', [ num2str(size(c{i,2},1)) ' ']);
            cprintf([0 0 0], [ '(with '  num2str(c{i,3}.num_a0image) ' image(s) acquired without diffusion gradients)' '\n']);
            
            %         disp(     ['    no directions   : ' num2str(size(c{i,2},1))   ' (with '  num2str(c{i,3}.num_a0image) ' images acquired without diffusion gradients)' ]);
            showinfo2(['    output file     :  '] ,f2  ,[],[], [ '>> ' f2 '' ]);
            disp(     ['        ..input file: '  c{i,3}.file ]);
            disp(     ['        ..scan-No   : ' num2str(c{i,3}.scanNo) ]);
        end
        % ==============================================
        
    end
    
    
    out=c;
end














