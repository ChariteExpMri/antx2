
%%  import existing NIFTI-files from Brukerdata. NIFTIS already exist in Bruker-RawData-structure
%  
% 
%     
% ==============================================
%%   examples GUI
% ===============================================
% 
%% simplest from, GUIs will open for raw-folder, files-selection and parameters..
% ximportBrukerNifti()
% 
%% import NIFTI from several Bruker-folders located in "RAW_main_study_protocol"
%% GUIs for files-selection and parameter-specs will open...
%   raw  ='F:\data7\AG_schmid_main_study_protocol_30nov23\RAW_main_study_protocol'
%   ximportBrukerNifti('raw',raw)
% 
%% import NIFTI from from single Bruker raw-folder "AK7147_TP1"
%% here NIFTIs of ExpNumber(e): 4 and 5 are imported,
%% dat/outputfolder is defined  , ..with file and parameter-GUIs open
%   raw='F:\data7\AG_schmid_main_study_protocol_30nov23\RAW_main_study_protocol\AK7147_TP1'
%   out=fullfile(pwd,'dat');
%   ximportBrukerNifti('raw',raw,'dat',out,'sel',{'e' [4 5]},'guiFile',0,'guiPara',0)
%     
%     
%% import NIFTI from several Bruker-folders located in "RAW_main_study_protocol"
%% here NIFTIs of ExpNumber(e): 4 and 5 are imported, ..no GUIs
%% dat/outputfolder: not needed to be specified if ant-project is loaded
%   raw  ='F:\data7\AG_schmid_main_study_protocol_30nov23\RAW_main_study_protocol'
%   ximportBrukerNifti('raw',raw,'sel',{'e' [4 5]},'guiFile',0,'guiPara',0)
%     
%% import NIFTI from several Bruker-folders located in "RAW_main_study_protocol"
%% here NIFTIs of ExpNumber(e): 4 and 5 are converted but only for animals (a) with names
%% containing the string 'AK714' or 'GH2716'
%%  ..no GUIs
%   raw  ='F:\data7\AG_schmid_main_study_protocol_30nov23\RAW_main_study_protocol'
%   ximportBrukerNifti('raw',raw,'sel',{'a'  'AK714|GH2716'  'e' [4 5]},'guiFile',0,'guiPara',0)
%     
%% import NIFTI from several Bruker-folders located in "RAW_main_study_protocol"
%% here NIFTIs with protocol(p) containing either 'DTI' or 'T2' are imported
%%  ..no GUIs
%   raw  ='F:\data7\AG_schmid_main_study_protocol_30nov23\RAW_main_study_protocol'
%   ximportBrukerNifti('raw',raw,'sel',{'p'  'DTI|T2'},'guiFile',0,'guiPara',0)
% 
%% import all NIFTI-files 
%    raw='F:\data7\AG_schmid_main_study_protocol_30nov23\RAW_main_study_protocol\AK7147_TP1'
%    ximportBrukerNifti('raw',raw,'sel','all','guiFile',0,'guiPara',0)
% 
% 

    
    %% ===============================================



% paraw  ='F:\data7\AG_schmid_main_study_protocol_30nov23\RAW_main_study_protocol'
% ===============================================
function ximportBrukerNifti(varargin)

warning off
%% ===============================================
v.raw=[];
v.dat=[];
v.sel=[];
v.guiFile=1;
v.guiPara=1;

if nargin>0
    vin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    v=catstruct(v,vin);
end

%% ===============================================


global an
if ~isempty(an)
    v.padat  =an.datpath;
    v.study  =fileparts(v.padat);
end

if ~isempty(v.dat)
    v.padat=char(v.dat);
end

%% ===============================================

if 0
  
    
    
end

% 'H:\Daten-2\Extern\AG_Schmid\test_13oct23\raw\20230918_142607_wmstrokepilot_QJ9977_TP4_1_4\4\pdata\1\nifti'
% 'H:\Daten-2\Extern\AG_Schmid\test_13oct23\raw\20230918_142607_wmstrokepilot_QJ9977_TP4_1_4\6\pdata\1\nifti'
% outmain='H:\Daten-2\Extern\AG_Schmid\test_13oct23';
% paraw='H:\Daten-2\Extern\AG_Schmid\test_13oct23\raw';

% outmain='F:\data7\AG_schmid_main_study_protocol_30nov23';
% paraw  ='F:\data7\AG_schmid_main_study_protocol_30nov23\RAW_main_study_protocol';
% % outdat='F:\data7\AG_schmid_main_study_protocol_30nov23'
%
% paraw={'F:\data7\AG_schmid_main_study_protocol_30nov23\RAW_main_study_protocol\AK7147_TP1'
%     'F:\data7\AG_schmid_main_study_protocol_30nov23\RAW_main_study_protocol\GH2716_TP1'};
%% ===============================================
%   raddata path
%% ===============================================
% paraw=[];

if isempty(v.raw)
    try;   prefdir=v.study;
    catch; prefdir=pwd;
    end
    
    msg={'BRUKER-IMPORT: IMPORT existing NIFTI files from BRUKER-FOLDER(s)',...
        'select the "main"-BRUKER Folder [such as "raw"-dir] that contains the import data'...
        'Note: this folder must contain a folder for each mouse',...
        'alternatively, select one or more mouse folders',...
        '    -use upper fields and lower left panel to navigate',...
        '    -select the "main"-BRUKER Folder or one/several mouse folders from the right panel',...
        '    >>folders in the lower panels will be processed..',...
        '  press [Done]'};
    [pain,sts] = cfg_getfile2(inf,'dir',msg,[],prefdir);
    pain=char(pain);
    if isempty(char(pain))
        return
    end
    v.raw=pain;
end


%% ===============================================




paraw=cellstr(v.raw);
fis={};
for i=1:length(paraw)
    [fi] = spm_select('FPListRec',paraw{i},'.*.nii$');
    fi=cellstr(fi);
    fis=[fis; fi];
end
%% ===============================================
fclose('all');
d={};
pas=fileparts2(fis);
pas=unique(pas);
idel=setdiff([1:length(pas)]' ,regexpi2(pas,[filesep 'pdata' filesep])); % non-'pdata-folders'
pas(idel)=[];
animalvec={};
maxsplit=max(cell2mat(cellfun(@(a){[ length(strsplit(a,filesep)) ]}, pas )));
for i=1:length(pas)
    ts= strsplit(pas{i},filesep);
    d(i,1:length(ts))=ts;
    animalvec(i,1)=ts(regexpi2(ts',['^pdata$'])-2);
    fclose('all');
end

animals=unique(animalvec);





% ==============================================
%%  obtain file-info
% ===============================================

g        ={};
niftis   ={};
visu_meth={};
path_2dseq={};
co=1;
disp('*** READ IN BRUKER DATA ***     ....            ');
for j=1:length(animals)
    ix=find(strcmp(animalvec,animals{j}));
    for i=1:length(ix)
        
        S = sprintf('reading file: %d',co);
        fprintf(repmat('\b',1,numel(S)));
        fprintf(S);
        co=co+1;
        
        px=d(ix(i),:);
        px(cellfun(@isempty,px))=[]; %remove empty space
        pani=strjoin(px,filesep);
        
         %adding beginning file-separator (for UNIX)
        if ~ispc
            if strcmp(pani(1),'filesep')==0
                pani=[filesep pani ];
            end
        end
        
        fis2= spm_select('FPList',pani,'^.*.nii');
        fis2=cellstr(fis2);
        
        Nniftis=length(fis2);
        
        pa2dseq=fileparts(pani);
        a=readBrukerParamFile(fullfile(pa2dseq,'visu_pars'));
        pa2meth=fullfile(fileparts(fileparts(fileparts(pani))));
        m=readBrukerParamFile(fullfile(pa2meth,'method'));
        
        rpe='No';
        if isfield(m ,'ReversedPhaseEncoding')
            rpe= m.ReversedPhaseEncoding;
        end
        [~, NIFTIName,ext]=fileparts(fis2{1});
        NIFTIName=[NIFTIName,ext];
        
        gd=[
            {j animals{j}   a.VisuAcquisitionProtocol a.VisuExperimentNumber  a.VisuProcessingNumber ...
            NIFTIName Nniftis   rpe a.VisuStudyId a.VisuSubjectId}           ]       ;
        g(end+1,:)=gd;
        
        visu_meth(end+1,:)  ={a m};
        niftis(end+1,1)     ={fis2};
        path_2dseq(end+1,1) ={pa2dseq};
        
        fclose('all');
    end
    
end
fclose('all');
fprintf('..done.\n ');
% other fields: a.VisuSubjectName a.VisuCoreDim


% ==============================================
%%   table
% ===============================================

gh={ '#' 'animal' 'protocol' 'Exp#' 'Proc#' ...
    '1stNiftiName' '#NIFTIs'  'RPE' 'StudyId' 'SubjectId'};
g=cellfun(@(a){[ num2str(a)]}, g );
preselect=[];


% v.sel={'e' [4 5],'a'  '.*AK714.*'}
% v.sel={'e' [4 5]}
% v.sel={'a'  '.*AK714.*'};
% v.sel={'p'  'T2'};
% v.sel={'p'  'DTI|T2'};
% v.sel={'p'  'DTI'};
%v.sel={'a'  'AK714|GH2716','e',[4 5]};

if ~isempty(v.sel)
    
    
    if ischar(v.sel) && strcmp(v.sel,'all')
        preselect=[1:size(g,1)]';
    else
        
        
        if length(v.sel)==1
            
        else
            [q1]=(ones(size(g,1)  ,5));
            w=cell2struct(v.sel(2:2:end),v.sel(1:2:end),2);
            if isfield(w,'e')
                vs= g(:,regexpi2(gh,'Exp#'));
                if ischar(w.e)
                    eval(['w.e=[' w.e '];']);
                end
                va=cellfun(@(a){[ num2str(a)]}, num2cell((w.e(:))));
                is1= ismember(vs,va);
                is2= ismember(g(:,regexpi2(gh,'Proc#')),'1');
                ps1=(sum([is1 is2],2)==2);
                q1(:,1)=ps1;
            end
            if isfield(w,'a')
                vs= g(:,regexpi2(gh,'animal'));
                iw=regexpi2(vs,w.a);
                is1=zeros(length(vs),1);
                is1(iw)=1;
                is2= ismember(g(:,regexpi2(gh,'Proc#')),'1');
                ps2=(sum([is1 is2],2)==2);
                q1(:,2)=ps2;
            end
            if isfield(w,'p')
                vs= g(:,regexpi2(gh,'protocol'));
                is1=~cellfun('isempty',regexpi(vs,w.p));
                is2= ismember(g(:,regexpi2(gh,'Proc#')),'1');
                ps2=(sum([is1 is2],2)==2);
                q1(:,2)=ps2;
            end
            
            if isfield(w,'a') || isfield(w,'e') || isfield(w,'p')
                preselect=find(sum(q1,2)==size(q1,2));
            end
        end
    end
end

% ==============================================
%  GUI-file-selection
% ===============================================
if isempty(preselect) || v.guiFile==1 && ~isempty(preselect)
    drawnow;
    pos=[0.078    0.077   0.78    0.86];
    tit='select NIFTIs to import';
    if isempty(preselect)
        id=selector2(g,gh,'iswait',1,'finder',1,'position',pos,'title',tit );
    else
        id=selector2(g,gh,'iswait',1,'finder',1,'position',pos,'title',tit,'preselect',preselect );
    end
    drawnow;
else
    id=preselect;
end

if  isempty(id) || id(1)==-1
    disp(' user abort..'); return;
end
% ==============================================
%%   GUI
% ===============================================


p={...
    'inf200'      [repmat('=',[1,100])]                                    ''  ''
    
    'inf101'      [repmat('=',[1,100])]                                    ''  ''
    'inf1'      '  [1] ANIMAL DIRECTORY NAME (added to "SubjectId")         '                                    ''  ''
    'inf102'      [repmat('=',[1,100])]                                    ''  ''
    'VisuSubjectId_Dir' 0     'add "VisuSubjectId_Dir"-NAME,  (bool)'  'b'
    'StudNo_Dir'        1     'add VisuStudyNumber as SUFFIX-STRING,  (bool)'  'b'
    'ExpNo_Dir'         0     'add VisuExperimentNumber (parent folder of "pdata") as SUFFIX-STRING,(bool)'  'b'
    'PrcNo_Dir'         0     'add VisuProcessingNumber/ReconstructionNumber(subfolder of "pdata") as SUFFIX-STRING,(bool)'  'b'
    'prefix_Dir'        ''    'add arbitrary string as PREFIX-STRING to the new animal directory '  {'' 'test_' 'other_'}
    
    
    'inf22'      ' [2] FILENAME definitions  (added to "protocoll-name")        '                                    ''  ''
    'inf201'      [repmat('=',[1,100])]                                    ''  ''
    'ExpNo_File'     1        'VisuExperimentNumber (parent folder of "pdata"),(bool)'  'b'
    'PrcNo_File'     1        'VisuProcessingNumber/ReconstructionNumber(subfolder of "pdata"),(bool)'  'b'
    'prefix'        ''   'add prefix to filename' {'NI_' [regexprep(datestr(now),{':' ' '},'_') '_'] ''}
    'suffix'        ''   'add suffix to filename' {'_NI' ['_' regexprep(datestr(now),{':' ' '},'_')] ''}
    %
    
    %     'inf300'      [repmat('=',[1,100])]                                    ''  ''
    'inf32'      ' [3] DWI-OPTIONS ____       '                                    ''  ''
    'exportBTable'             [1]     'export B-tables (for DWI-files) '           'b'
    'use_ACQGradientMatrix'    [0]     'use ACQ_GradientMatrix for calc. of DWI-angles: [0]no [1]yes; default: [0]'    'b'
    %     'origin'       'brukerOrigin'        'define center(origin) of volume'  {'brukerOrigin' 'volumeCenter'}
    };


x=struct();
showgui=v.guiPara;

p=paramadd(p,x);%add/replace parameter
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[0.1 0.26 0.6 0.4 ],...
        'title','ImportBrukerNIFTIs');
else
    z=param2struct(p);
end
if isempty(z);
    %     cprintf([0 .5 .8],[' ..user abort!  \n']);
    return
end


% ==============================================
%%   PROC
% ===============================================
if exist(v.padat)~=7; mkdir(v.padat); end



for i=1:length(id)
    ix=id(i);
    disp([num2str(i) ']' g{ix,2}  ': '  [g{ix,3} ' (' g{ix,4},',' g{ix,5} ')'  ' "' g{ix,6} '"']]);
    
    % make animalPath
    %% =============== ANIMAL-PATH ================================
    mdir='';
    if z.VisuSubjectId_Dir==1  %here it is "wmstroke_mainstudy"
        mdir=  visu_meth{ix,1}.VisuSubjectId;
    end
    %mdir=[  mdir '_' visu_meth{ix,1}.VisuStudyId ];    %example: "AK7147_TP1_4d"
    mdir=[  mdir '_' g{ix,2} ];    %example: "GH2716_TP1"
    
    if z.StudNo_Dir==1 %'StudNo_Dir':add VisuStudyNumber as SUFFIX-STRING
        mdir=[mdir '_' num2str(visu_meth{ix,1}.VisuStudyNumber)];
    end
    if z.ExpNo_Dir==1  %'ExpNo_Dir': add VisuExperimentNumber (parent folder of "pdata")
        mdir=[mdir '_' num2str(visu_meth{ix,1}.VisuExperimentNumber)];
    end
    if z.PrcNo_Dir==1  % 'PrcNo_Dir': add VisuProcessingNumber/ReconstructionNumber(subfolder of "pdata")
        mdir=[mdir '_' num2str(visu_meth{ix,1}.VisuProcessingNumber)];
    end
    
    if strcmp(mdir(1),'_')
        mdir(1)=[];
    end
    if ~isempty(z.prefix_Dir)
        mdir=[char(z.prefix_Dir)  mdir  ];
    end
    
    
    %% ===============================================
    
    
    
    paout=fullfile(v.padat, mdir);
    if exist(paout)~=7; mkdir(paout); end
    
    % get NIFTIS and sort them..
    nifile   =niftis{ix};
    nifile   =natsort(nifile);   %SORT NIFTI-FILES !!!!
    
    % outputNamen
    ExpNo_File='';
    PrcNo_File='';
    if z.ExpNo_File==1;   ExpNo_File= ['_' g{ix,4}]  ; end
    if z.PrcNo_File==1;   PrcNo_File= ['_' g{ix,5}]  ; end
    
    outname=[[z.prefix] g{ix,3}  ExpNo_File PrcNo_File  [z.suffix]  '.nii'];
    fp_nifti=fullfile(paout,outname);
    
    iswriteNIFTI=1;
    if iswriteNIFTI==1
        %write/concatenate NIFTIS
        clear mb
        mb{1}.spm.util.cat.vols = nifile;
        mb{1}.spm.util.cat.name = fp_nifti;
        mb{1}.spm.util.cat.dtype = 64;
        mb{1}.spm.util.cat.RT = NaN;
        evalc('spm_jobman(''run'',mb)');
        
        disp(['N-niftis: ' num2str(length(nifile)) '        (' outname  ')']);
        showinfo2('img',fp_nifti);
    end
    
    
    %% ===============================================
    visu       =visu_meth{ix,1};
    meth       =visu_meth{ix,2};
    pa2dseq    =path_2dseq{ix};
    
    if z.exportBTable==1
        tb=getBtable(pa2dseq,visu,meth,z);
        if ~isempty(tb)
            gradname=regexprep(outname,'.nii','.txt');
            fp_gradname=fullfile(paout,gradname);
            pwrite2file(fp_gradname, tb);
            disp(['Table-rows: ' num2str(size(tb,1))  '     (' gradname ')']);
            showinfo2('dwi-table',fp_gradname);
        end
    end
    
    
    
    % ===============================================
    %     if 0
    %         vi=visu_meth{ix,1};
    %         me=visu_meth{ix,2};
    %
    %         w=struct();
    %         w.bval=me.PVM_DwEffBval;
    %         w.dirs=vi.VisuAcqDiffusionGradOrient;
    %
    %         t=[w.dirs  w.bval(:)];
    %         izero=find(t(:,4)<50);
    %         t(izero,:)=0;
    %
    %         rpe='No';
    %         if isfield(me ,'ReversedPhaseEncoding')
    %             rpe= me.ReversedPhaseEncoding;
    %         end
    %
    %         if jj==2 %RPE: remove last table-row
    %             t(end,:)=[];
    %         end
    %
    %         gradname=regexprep(outname,'.nii','.txt');
    %         fp_gradname=fullfile(paout,gradname);
    %         pwrite2file(fp_gradname, t);
    %         disp(['Table-rows: ' num2str(size(t,1))  '     (' gradname ')']);
    %         showinfo2('dwi-table',fp_gradname);
    %     end
    % ===============================================
    
end



function tb2=getBtable(pa2dseq,visu,meth,z);


%% ===============================================
% f3=(fullfile(fileparts(f1),'pdata','1','2dseq'));
%         [ni bh  da]=getbruker(f3);
% f1=fullfile(path2dseq,'2dseq');
% [ni bh  da]=getbruker(f1);


%% ===============[get acqp-file]================================

acqpFile=fullfile(fileparts(fileparts((pa2dseq))), 'acqp');
acqp=readBrukerParamFile(acqpFile);
fclose('all');
%% ============[shorten vars (see getbruker.m)]===================================

v  = visu;           % v  =readBrukerParamFile(fullfile(pa,'visu_pars'));
% mpa=fileparts(fileparts(fileparts(pa)));
m  = meth;           % m  =readBrukerParamFile(fullfile(mpa,'method'));
a  = acqp;           % a=readBrukerParamFile(fullfile(mpa,'acqp'));

%% ===========[check if dwi-file]====================================

if isfield(m,'PVM_DwNDiffExpEach')==0
    tb2=[];
    return
end

%% ===============================================
pp.PVM_DwNDiffExpEach = m.PVM_DwNDiffExpEach ;
pp.PVM_DwNDiffDir     = m.PVM_DwNDiffDir     ;
pp.PVM_DwAoImages     = m.PVM_DwAoImages     ;
pp.PVM_DwDir          = m.PVM_DwDir          ;
pp.PVM_DwEffBval      = m.PVM_DwEffBval      ;

pp.ReversedPhaseEncoding=0;
if isfield(m,'ReversedPhaseEncoding')
    if strcmp(m.ReversedPhaseEncoding,'Yes')
        pp.ReversedPhaseEncoding=1;
    end
end


% make table
%% ===============================================
% if 0
%     %get number of Number of images acquired without diffusion gradients.
%     %Bruker Manual: https://cbbi.udel.edu/wp-content/uploads/2019/09/Bruker-Manual-Complete-.pdf
%     %page-251
%     %A0 Images (PVM_DwAoImages) – Number of images acquired without diffusion gradients.
%     tag='##$PVM_DwAoImages=';
%     w1=find(~cellfun(@isempty,strfind(s,tag)));
%     num_a0image=str2num(char(strrep(s(w1),tag,'')));
%     tb=[[zeros(num_a0image,size(t2,2)+1)];[c2 t2]];
% end

% tb=zeros(length(pp.PVM_DwEffBval),4);
% tb(:,1)                                               =pp.PVM_DwEffBval ;%set bvalues to 1st-column
% tb(1:length(pp.PVM_DwEffBval)-size(pp.PVM_DwDir,1),:) =0                ;%set Bval of B0-rows to ZERO
% tb(end+1-size(pp.PVM_DwDir,1):end,[2:4 ])             =pp.PVM_DwDir;

% direc=repmat(pp.PVM_DwDir,[pp.PVM_DwNDiffExpEach 1]); %repmat directions if pp.PVM_DwNDiffExpEach>1
% tb(end-size(direc,1)+1:end,2:end)=direc;% set directions to column2,3,4
% tb(1:pp.PVM_DwAoImages,:)=0  ;% set b0-values and directions to Zeros
% tb0=tb;


tb=[zeros(pp.PVM_DwAoImages,[3]) ; pp.PVM_DwDir];
tb(:,4)=[ pp.PVM_DwEffBval ];
tb(1:pp.PVM_DwAoImages,4)=0;


% ==============================================
%%  SCHMIDT-approach: PILOT
% ===============================================
%f3=(fullfile(fileparts(f1),'pdata','1','2dseq'));
%[ni bh  da]=getbruker(f3);
%% ===============================================
if z.use_ACQGradientMatrix==1
    ackgradmatrix= (a.ACQ_GradientMatrix);
    ackgradmatrix=squeeze(ackgradmatrix(1,:,:));
    
    tb_scanner=m.PVM_DwDir;
    tb_rps=zeros(size(tb_scanner));
    for i=1:size(tb_scanner,1)
        tb_rps(i,:) =[ackgradmatrix*tb_scanner( i,:)'];
    end
    nrm =sqrt(sum(tb_rps.^2,2))  ;%norm vector to 1
    tb_rps=tb_rps./repmat(nrm,[1 3]);
    
    tb=[zeros(pp.PVM_DwAoImages,[3]) ; pp.PVM_DwDir];
    tb(:,4)=[ pp.PVM_DwEffBval ];
    tb(1:pp.PVM_DwAoImages,4)=0;
    tb(end+1-size(tb_rps,1):end,[2:4 ])   = tb_rps;
    
    
    % tb=tb0;
    % tb(end+1-size(tb_rps,1):end,[2:4 ])   = tb_rps;
    % ---older---
    % tb    = zeros(length(pp.PVM_DwEffBval),4);
    % direc = repmat(tb_rps,[pp.PVM_DwNDiffExpEach 1]);
    % tb(end-size(direc,1)+1:end,1:3)=direc;% set directions to column2,3,4
    % tb(:,4)=pp.PVM_DwEffBval; %add B-values
    % tb(1:pp.PVM_DwAoImages,:) = 0  ;% set b0-values and directions to Zeros
    
    
    disp('use use_ACQGradientMatrix');
end

% ==============================================
%%   reorient
% ===============================================



% ===============================================
orient = m.PVM_SPackArrSliceOrient;
if strcmp(orient,'coronal')  %--> our "AXIAL"  (expno: 4&5 bei schmid)
    tb2=tb(:,[2 3 1 4]);
    %Bruker --> Mrtrix  when  using OUR as "AXIAL"-labeled orientation
    %------------------
    % col2  -->    col1
    % col3  -->    col2
    % col1  -->    col3       thus ---->> permute (,[ 2 3 1 ]) to come to MRtrix
elseif strcmp(orient,'axial')  %--> our "CORONAL"---> here NO permutations/no flips
    tb2=tb;
end
% ===============================================




return


if 0
    % ==============================================
    %%   old stuff: see "getBtable_schmid.m"
    %%     getBtable_schmid.m -   extract b-table from bruker raw data and store is in ../"thisStudy"/DTI as mrtrix-readable txt-file
    % 		F:\data7\AG_schmid_main_study_protocol_30nov23\getBtable_schmid.m
    % ===============================================
    
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
    %%  SCHMIDT
    % ===============================================
    %f3=(fullfile(fileparts(f1),'pdata','1','2dseq'));
    %[ni bh  da]=getbruker(f3);
    %% ===============================================
    ackgradmatrix= (a.ACQ_GradientMatrix);
    ackgradmatrix=squeeze(ackgradmatrix(1,:,:));
    
    tb_scanner=m.PVM_DwDir;
    tb_rps=zeros(size(tb_scanner));
    for i=1:size(tb_scanner,1)
        tb_rps(i,:) =[ackgradmatrix*tb_scanner( i,:)'];
    end
    nrm =sqrt(sum(tb_rps.^2,2))  ;%norm vector to 1
    tb_rps=tb_rps./repmat(nrm,[1 3]);
    
    tb    = zeros(length(pp.Bval),4);
    direc = repmat(tb_rps,[pp.PVM_DwNDiffExpEach 1]);
    tb(end-size(direc,1)+1:end,1:3)=direc;% set directions to column2,3,4
    tb(:,4)=pp.Bval; %add B-values
    tb(1:pp.PVM_DwAoImages,:) = 0  ;% set b0-values and directions to Zeros
    
    
    
    % ==============================================
    %%  orientation
    % ===============================================
    
    orient = m.PVM_SPackArrSliceOrient
    if strcmp(orient,'coronal')  %--> our "AXIAL"  (expno: 4&5 bei schmid)
        tb2=tb(:,[2 3 1 4]);
        
        %Bruker --> Mrtrix  when  using OUR as "AXIAL"-labeled orientation
        %------------------
        % col2  -->    col1
        % col3  -->    col2
        % col1  -->    col3       thus ---->> permute (,[ 2 3 1 ]) to come to MRtrix
        
    elseif strcmp(orient,'axial')  %--> our "CORONAL"---> here NO permutations/no flips
        tb2=tb;
    end
    % ===============================================
    disp(size(tbw));
    
    
    
end









