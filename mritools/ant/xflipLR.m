
% flip left/right image in native or standard space
% For flipping image in native space, the basic registration to standard space has to be done once!
% #b function-name: #lk [xflipLR]
% ______________________________________________________________________________________________
%
%% #lk PARAMETER:
% 'file'        IMAGE(S) to flip
%               -select one or more images
% 'space'       image space of the image to flip
%               -options: 'standard'  -image is in standard space
%               -         'native'    -image is in native space
%               -         'nativePOB' -image is in native space, preserve-outer-brain information
%               -         'nativeMat' -image is in native space, but HDR-matrix of rigid trafo is used
%                                     - 'nativeMat' leads to suboptimal results
% 'add_suffix'  add suffix to resulting output filename (prefered)
%               -defailt: '_flipped'
% ______________________________________________________________________________________________
%% #lk RUN-def:
% xflipLR(showgui,x)
% with inputs:
% showgui: (optional)  :  0/1   :no gui/open gui
% x      : (optional)  : struct with one/more specified parameters from above:
%
% xflipLR(1);     % ... open PARAMETER_GUI with defaults
% xflipLR(0,z);   % ...run without GUI with specified parametes (z-struct)
% xflipLR(1,z);   % ...run with opening GUI with specified parametes (z-struct)
% ______________________________________________________________________________________________
%% #lk EXAMPLES
%% ================================================================================
%%  flip image 't2.nii' in native space,output: 't2_flipped.nii'
% z=[];
% z.file       = { 't2.nii' };     % % IMAGE(S) to flip (example: "x_t2.nii"
% z.space      = 'native';         % % image space of the image {"standard"}
% z.add_suffix = '_flipped';       % % add suffix to output name (prefered)
% xflipLR(1,z);
%% ================================================================================
%%  flip image 't2.nii' in native space using rigid-mat (suboptimal result)
%%  output: 't2_flipped.nii'
% z=[];
% z.file       = { 't2.nii' };     % % SELECT IMAGE(S) to flip (example: "x_t2.nii"
% z.space      = 'nativeMat';      % % image space of the image {"standard"}
% z.add_suffix = '_flipped';       % % add suffix to output name (prefered)
% xflipLR(1,z);
%% ================================================================================
%%  flip image 't2.nii' in native space, preserve-outer-brain information
%%  output: 't2_flipped.nii'
% z=[];
% z.file       = { 't2.nii' };     % % SELECT IMAGE(S) to flip (example: "x_t2.nii"
% z.space      = 'nativePOB';      % % image space of the image {"standard"}
% z.add_suffix = '_flipped';       % % add suffix to output name (prefered)
% xflipLR(1,z);
%% ================================================================================
%%  flip two images in standard space, output files with  prefix '_mir'
% z=[];
% z.file       = { 'ANO.nii'             % % SELECT IMAGE(S) to flip (example: "x_t2.nii"
%                  'AVGTmask.nii' };
% z.space      = 'standard';             % % image space of the image {"standard"}
% z.add_suffix = '_mir';                 % % add suffix to output name (prefered)
% xflipLR(1,z);
% ______________________________________________________________________________________________
%
%% #r RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace
%
%


function xflipLR(showgui,x,pa)

%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                           ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end

%% get unique-files from all data
% pa=antcb('getsubjects'); %path
% v=getuniquefiles(pa);
[tb tbh v]=antcb('getuniquefiles',pa);

% ==============================================
%%   PARAMETER-gui
% ===============================================
% outname_opt={...
%     '<html>[filename]+"_slice"+[sliceNo] <font color=fuchsia>; tag:"_slice$s"<font color=green>; example: "t2_slice001.nii"'      , '_slice$s';...
%     '<html>[filename]+[_sliceNo]<font color=fuchsia>; tag:"_$s"<font color=green>example: "t2_001.nii">                        [_$s]'           , '_$s';...
%     '<html>[filename]+"_vol"+[volNo]+"_slice"+[sliceNo] <font color=fuchsia>; tag:"_vol$v_slice$s"<font color=green>; example: "t2_vol01_slice001.nii"', '_vol$v_slice$s';...
%     '<html>[filename]+[volumeNo]+[sliceNo]<font color=fuchsia>; tag:"_$v_$s"<font color=green>; example: "t2_01_001.nii"'        , '_$v_$s';...
%     '<html>use my own name [please modify filename here]                            '        , '_test.nii' ;...
%     };


opt_addsuffix={...
    'add suffix: example: add suffix ''_flipped''' '_flipped';
    'add suffix: example: add suffix ''_mirror'''  '_mirror';
    %     'specific: change individual filenames' @specificOutputfileNames
    };
opt_logfile={...
    'no logfile        '  0
    'show logfile [1]  '  1
    'save logfile to "checks"-folder [2]'  2
    'show logfile and save logfile to "checks"-folder [3]'  3
    };

opt_space={
    'input in standard space [standard]' 'standard';
    'input in native space , use forward&backward registration [native]'       'native';
    'input in native space , same as "native" but preserve outer brain information '   'nativePOB';
    'input in native space , use rotationmatrix [nativeMat]'                   'nativeMat';
    };



if exist('x')~=1;        x=[]; end
p={...
    'inf0'      '*** flip image(s) left-right  ****     '         '' ''
    'file'          ''             '(<<) SELECT IMAGE(S) to flip (example: "x_t2.nii"'  {@selectfile,v,'multi'}
    'space'         'standard'     'image space of the image {"standard"}'              opt_space % {'standard' 'native'}
    'add_suffix'    '_flipped'     'add suffix to output name (prefered) '             opt_addsuffix
    %     'logfile'            1      'logfile(LF): [0]no LF;[1]show LF;[2]write LF to "check"-dir [3]show and LF to "check"-dir (see options)' opt_logfile
    };
p=paramadd(p,x);%add/replace parameter
if showgui==1%% show GUI
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .45 .17 ],...
        'title',['flip image left-right (' mfilename '.m)' ],'info',{@uhelp, [mfilename '.m']});
    if isempty(m);    return ;    end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end
% ==============================================
%%   batch
% ===============================================
xmakebatch(z,p, mfilename);

% ==============================================
%%   SUB  PROCESS
% ===============================================
% 2501]??????????????
% 2261]??????????
% 2579]??????????
% 2580]??????????
% 2581]??????????
% 2582]??????????
% 2583]??????????
% 2584]??????????
% 2585]??????????
% 2586]??????????
% 2587]??????????
% 2588]??????????
% 2589]??????????
% 2590]??????????
% 2591]??????????
% 2592]??????????
% 2593]??????????
% '02192'
linesym='2261';

cprintf('[0 0 1]',[ repmat(char(hex2dec(linesym)),[1 200]) '\n'] );
cprintf('*[0 0 1]',[ ' flip image (LR)... \n'] );
mdirs=cellstr(pa);
if isempty(z.add_suffix),
    z.add_suffix='_flipped';
    disp(['...suffix is empty [z.add_suffix] ' char(hex2dec('02192'))  'using "' z.add_suffix '" as suffix!'  ]);
end


for i=1:length(mdirs)
    z.mdir    =mdirs{i};
    z.ianimal =i;
    
    %cprintf('[0 .5 0]',[ ' [' num2str(i) '/'  num2str(length(mdirs)) ']: ' strrep(z.mdir,filesep,[filesep filesep])  '\n'] );
    %cprintf('[0 .5 0]',[ repmat(char(hex2dec('2580')),[1 2000]) 'eeee\n'] );
    %clc; for i=2000:4000; disp([char(hex2dec(num2str(i))) ', ' num2str(i) ]); end
    
    showinfo2([  repmat([char(hex2dec('02192' )) ' '],[1 3]) ' [' num2str(i) '/'  num2str(length(mdirs)) ']:' ],z.mdir);
    flipLR(z);
end
cprintf('*[0 0 1]',[ ' Done\n'] );

% ==============================================
%%   extract slice
% ===============================================
function flipLR(z)



z.file=cellstr(z.file);

log={};
for i=1:length(z.file)
    f1=fullfile(z.mdir,z.file{i}  );
    %   f1=stradd(f1,'bla',2);
    if exist(f1)==2
        %% ===============================================
        
        %         q1=[];
        %         try
        %
        %         catch
        %
        %
        %         end
        
        if strcmp(z.space, 'standard')
            flip_standardSpace(z,f1);
        elseif strcmp(z.space, 'native') || strcmp(z.space, 'nativePOB')
            flip_nativeSpace(z,f1);
        elseif strcmp(z.space, 'nativeMat')
            flip_nativeSpace_via_rotMat(z,f1);
        end
        
        %% ===============================================
        
        
    end
end


% ==============================================
%%   trafoNative
% ===============================================

function flip_nativeSpace(z,f1)

%% ====[interp]===========================================
%auto
interp=1;
[ha a]=rgetnii(f1);
if sum(((round(unique(a)*10))/10)==unique(a))==length(unique(a))
    interp=0 ;
end
%% ======[trafo:SS]=========================================
% files = {'F:\data5\nogui\dat\1001_a1\AVGThemi.nii'};
if strcmp(z.space,'native')
    pp.source     =  'intern';
    pp.showbatch  =  0;
    pp.fileNameSuffix ='_temp';
    fis=doelastix(1, [],f1,interp,'local',pp );
    f2=fis{1};
elseif strcmp(z.space,'nativePOB')
    
    pp.source         =  'intern';
    pp.showbatch      =  0;
    pp.fileNameSuffix ='_temp';
    pp.imgSize        =[300 300 300];
    pp.imgOrigin      ='auto';
    
    fis=doelastix(1, [],f1,interp,'local',pp );
    f2=fis{1};
    
    
    %% DEFORM VIA ELASTIX
    % files = {'F:\data5\nogui\dat\1001_a1\t2_copy.nii'};
    % pp.source         =  'intern';
    % pp.imgSize        =  [300  300  300];
    % pp.imgOrigin      =  'auto';
    % pp.fileNameSuffix =  '_klaus';
    % fis=doelastix(1, [],files,4,'local' ,pp);
    
end


%% =========[flip image]======================================
q1=[];
clear mb;
mb{1}.spm.util.reorient.srcfiles = {f2};
mb{1}.spm.util.reorient.transform.transM =...
    [-1 0 0 0
    0 1 0 0
    0 0 1 0
    0 0 0 1];
mb{1}.spm.util.reorient.prefix = 'flipped_';
[msg,q1,q2 ]=evalc('spm_jobman(''run'',mb)');


if ~isempty(q1)
    fname=char(q1{1}.files);
    [pth,nam,ext,num] = spm_fileparts(fname);
    f3=fullfile(pth,[nam ext]);
    [pth,nam,ext,num]=spm_fileparts(f1);
    f4=stradd(f3,'_flipped',2);
    movefile(f3,f4,'f');
    %showinfo2(['flip image' ],f2,f4);
end

%% ======[trafo:NS]=========================================
% files = {'F:\data5\nogui\dat\1001_a1\AVGThemi.nii'};
pp=[];
pp.source     =  'intern';
pp.showbatch  =  0;
pp.fileNameSuffix ='_temp';
fis=doelastix(-1, [],f4,interp,'local',pp );
f5=fis{1};
%% =========[rename image]======================================
[pas name ext]=fileparts(f1);
f6=fullfile(pas, [name z.add_suffix  ext]);

movefile(f5,f6,'f');
showinfo2(['flip image' ],f1,f6,0);

%% ======[clean up]=========================================
try; delete(f2); end
try; delete(f3); end
try; delete(f4); end
try; delete(f5); end
%% ===============================================




function flip_nativeSpace_via_rotMat(z,f1)
% ==============================================
%%   native2
% ===============================================
[ha a]=rgetnii(f1);
mdir=z.mdir;
ff=fullfile(mdir,'reorient.mat');
w=load(ff);
M=w.M;

f2=fullfile(mdir,'test.nii');

%% ===============================================

hb=ha;
hb.mat=ha.mat;%*w.M;
rsavenii(f2,hb,a,64);

v=  spm_vol(f2); %reorient IMAGW
spm_get_space(f2,      inv(M) * v.mat);
% showinfo2(['tests' ],f2);

% [hb b]=rgetnii(f2);
%% ===============================================

q1=[];
clear mb;
mb{1}.spm.util.reorient.srcfiles = {f2};
mb{1}.spm.util.reorient.transform.transM =...
    [-1 0 0 0
    0 1 0 0
    0 0 1 0
    0 0 0 1];
mb{1}.spm.util.reorient.prefix = 'flipped_';
[msg,q1,q2 ]=evalc('spm_jobman(''run'',mb)');


fname=char(q1{1}.files);
[pth,nam,ext,num] = spm_fileparts(fname);
f3=fullfile(pth,[nam ext]);

%% ===============================================
[pth,nam,ext,num] = spm_fileparts(f1);
f4=fullfile(pth,[nam z.add_suffix ext]);
copyfile(f3,f4,'f');

v=  spm_vol(f4); %reorient IMAGW
spm_get_space(f4,      (M) * v.mat);
showinfo2(['tests' ],f1,f4,0);


%% ===============================================
try; delete(f2); end
try; delete(f3); end


%
% if ~isempty(q1)
%     fname=char(q1{1}.files);
%     [pth,nam,ext,num] = spm_fileparts(fname);
%     f3=fullfile(pth,[nam ext]);
%     [pth,nam,ext,num]=spm_fileparts(f1);
%     f4=fullfile(pth,[nam z.add_suffix ext ]);
%     movefile(f3,f4,'f');
%     showinfo2(['flip image' ],f1,f3,0);
% end
%



%% ===============================================


%% ======[trafo:NS]=========================================
% files = {'F:\data5\nogui\dat\1001_a1\AVGThemi.nii'};
% pp.source =  'intern';
% fis2=doelastix(1, [],f1,interp,'local' );


% files = {'F:\data5\nogui\dat\1001_a1\AVGThemi.nii'};
% pp.source =  'intern';
% fis=doelastix(-1, [],files,0,'local' ,pp);


function flip_standardSpace(z,f1)

q1=[];
clear mb;
mb{1}.spm.util.reorient.srcfiles = {f1};
mb{1}.spm.util.reorient.transform.transM =...
    [-1 0 0 0
    0 1 0 0
    0 0 1 0
    0 0 0 1];
mb{1}.spm.util.reorient.prefix = 'flipped_';
[msg,q1,q2 ]=evalc('spm_jobman(''run'',mb)');


if ~isempty(q1)
    fname=char(q1{1}.files);
    [pth,nam,ext,num] = spm_fileparts(fname);
    f2=fullfile(pth,[nam ext]);
    [pth,nam,ext,num]=spm_fileparts(f1);
    f3=fullfile(pth,[nam z.add_suffix ext ]);
    movefile(f2,f3,'f');
    showinfo2(['flip image' ],f1,f3,0);
end






% ==============================================
%%   xflipLR
% ===============================================
% return
%
% mb{1}.spm.util.reorient.srcfiles = {'ddd'};
% mb{1}.spm.util.reorient.transform.transM =...
%     [-1 0 0 0
%     0 1 0 0
%     0 0 1 0
%     0 0 0 1];
% mb{1}.spm.util.reorient.prefix = 'flipped_';
% [q1 q2 ]=spm_jobman('interactive',mb);


function he=selectfile(v,selectiontype)
he=selector2(v.tb,v.tbh,...
    'out','col-1','selection',selectiontype);


function examples(notused)
% ==============================================
%%
% ===============================================
if 1
    z=[];
    z.file      = { 'AVGThemi.nii' };     % % (<<) SELECT IMAGE to flip (example: "x_t2.nii"
    z.space     = 'standard';         % % flipp image from which space {"standard"}
    z.add_suffix = '_flipped1';         % % add suffix to output name (see options)
    %     z.logfile   = [1];                % % logfile(LF): [0]no LF;[1]show LF;[2]write LF to "check"-dir [3]show and LF to "check"-dir (see options)
    xflipLR(0,z);
end

if 1
    z=[];
    z.file      = { 't2.nii' };     % % (<<) SELECT IMAGE to flip (example: "x_t2.nii"
    z.space     = 'native';         % % flipp image from which space {"standard"}
    z.add_suffix = '_flipped2';         % % add suffix to output name (see options)
    z.logfile   = [1];                % % logfile(LF): [0]no LF;[1]show LF;[2]write LF to "check"-dir [3]show and LF to "check"-dir (see options)
    xflipLR(0,z);
end

if 1
    z=[];
    z.file      = { 't2.nii' };     % % (<<) SELECT IMAGE to flip (example: "x_t2.nii"
    z.space     = 'nativeMat';         % % flipp image from which space {"standard"}
    z.add_suffix = '_flipped3';         % % add suffix to output name (see options)
    %     z.logfile   = [1];                % % logfile(LF): [0]no LF;[1]show LF;[2]write LF to "check"-dir [3]show and LF to "check"-dir (see options)
    xflipLR(0,z);
end

if 1
    z=[];
    z.file      = { 't2.nii' };     % % (<<) SELECT IMAGE to flip (example: "x_t2.nii"
    z.space     = 'nativePOB';      % % flipp image from which space {"standard"}
    z.add_suffix = '_flipped4';         % % add suffix to output name (see options)
    %     z.logfile   = [1];                % % logfile(LF): [0]no LF;[1]show LF;[2]write LF to "check"-dir [3]show and LF to "check"-dir (see options)
    xflipLR(0,z);
end

% ==============================================
%%
% ===============================================

z=[];
z.file       = { 'ANO.nii'             % % (<<) SELECT IMAGE to flip (example: "x_t2.nii"
    'AVGTmask.nii' };
z.space      = 'standard';             % % flipp image from which space {"standard"}
z.add_suffix = '_flippedmir';          % % add suffix to output name (see options)
xflipLR(0,z);