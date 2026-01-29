

% #yk merge 3D NIFTIS to 4D-NIFTI (xmergenifti4D)
%
% #ko PARAMETER
% file         <selectable> list of 3D-NIFTIs or a file-filter, those files will be merged to 4D NIFTI file
%              list of file or file-filter can be selected
%             -advantage of file-filter (dynamical, does not clutter the batch)
%             -disadvantage: in case a file is missing...
% fileout     {''}    'output filename of 4D-NIFTI'     ''
% sortfiles   sort 3D-NIFTIs/filtered NIFTI-files {0|1}
%             using natsort.m: Natural-order / alphanumeric sort the elements of a text array
%             default: 1
% dt          datatype (see spm_type) of 4Dnifti
%             default:[0], 0 means same datatype as input'   , options: {0,16,64}
% writelist   write textfile with listed 3D-NIFTIs;
%             outputname is identical with 'fileout' but of format '.txt' instead of '.nii'
%             default:[1]
% isparallel  use parallel processing over animals
%             default:[0]
%
%
% #ko CMD
% xmergenifti4D(1)  : % open GUI, without input parameters + specify paramters via GUI
% xmergenifti4D(1,z); % open GUI, with defined parameters, you can specify paramters via GUI
% xmergenifti4D(0,z); % execute with predefiend paramters defined in z without GUI
%
% #ko EXAMPLE
% z=[];
% z.file      = '.*2_T1_FLASHax_p2xp2_FA30_.*.nii';   % % [SELECT] 3D-NIFTIs to convert to 4D-NIFTI
% z.fileout   =  'flash4d.nii' ;                      % % output filename of 4D-NIFTI
% z.sortfiles = [1];                                  % % sort 3D-NIFTIs/filtered NIFTI-files {0|1}; default:[1]
% z.dt        = [0];                                  % % datatype (see spm_type); default:[0], 0 means sane datatype as input
% z.writelist = [1];                                  % % write textfile with listed merged NIFTIs;  default:[1]
% z.isparallel= [0];                                  % % use parallel processing over animals;  default:[0]
% xmergenifti4D(0,z);




function xmergenifti4D(showgui,x,pa)


if 0
    %%--
    
    z=[];
    z.file      = '.*2_T1_FLASHax_p2xp2_FA30_.*.nii';   % % [SELECT] 3D-NIFTIs to convert to 4D-NIFTI
    z.fileout   =  'flash4d.nii' ;                      % % output filename of 4D-NIFTI
    z.sortfiles = [1];                                    % % sort 3D-NIFTIs/filtered NIFTI-files {0|1}; default:[1]
    z.dt        = [0];                                    % % datatype (see spm_type); default:[0], 0 means sane datatype as input
    z.writelist = [1];                                    % % write textfile with listed merged NIFTIs;  default:[1]
    z.isparallel = [1];                                    % % use parallel processing over animals;  default:[0]
    xmergenifti4D(0,z);
    
    %%---
end

%===========================================
%%   PARAMS
%===========================================
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;   try pa=antcb('getsubjects') ;catch; pa=[];end ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end



%===========================================
%%   %% test SOME INPUT
%===========================================


%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
if isempty(pa)
    msg='select one/multiple animal folders';
    [t,sts] = spm_select(inf,'dir',msg,'',pwd,'[^\.]'); % do not include 'upper' dir
    if isempty(t); return; end
    pa=cellstr(t);
end

% ==============================================
%%
% ===============================================

% %% fileList
% if 1
%     fi2={};
%     for i=1:length(pa)
%         [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
%         if ischar(files); files=cellstr(files);   end;
%         fis=strrep(files,[pa{i} filesep],'');
%         fi2=[fi2; fis];
%     end
%     li=unique(fi2);
% end
%
% checkspath=fullfile(fileparts(fileparts(pa{1})),'checks');

%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end
%     'file0'            {''}  '[SELECT] image to convert to SNR-image (multiple files possible)'    {@selector2,li,{'Image'},'out','list','selection','multi'}

p={...
    'file'       {''}  '[SELECT] 3D-NIFTIs to convert to 4D-NIFTI'   {@fileget, pa}
    'fileout'     {''}    'output filename of 4D-NIFTI'     ''
    %     'suffix'   ''           '<optional> instead of "fileoutname" append a suffix-string to the input file name as output name. '  {'_SNR' ''}
    'inf1' ''  '____PARAMETER____'  ''
    'sortfiles'   1  'sort 3D-NIFTIs/filtered NIFTI-files {0|1}; default:[1]'      'b'
    'dt'          0  'datatype (see spm_type); default:[0], 0 means sane datatype as input' {0 16 64}
    'writelist'   1  'write textfile with listed merged NIFTIs;  default:[1]'  'b'
    'isparallel'  0  'use parallel processing over animals;  default:[0]'      'b'
    };


p=paramadd(p,x);%add/replace parameter
% %% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[0.0840    0.2711    0.62    0.3056 ],...
        'title',['***merge to 4D-NIFTI*** ('  mfilename ')' ],'info',hlp);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

%===========================================
%%   history
%===========================================
xmakebatch(z,p, mfilename);

% ==============================================
%%   proc
% ===============================================
pa=cellstr(pa);
if z.isparallel==1
    parfor i=1:length(pa)
        mdir=pa{i};
        proc(z,mdir,i);
    end
    
else
    for i=1:length(pa)
        mdir=pa{i};
        proc(z,mdir,i);
    end
end


function proc(z,mdir,ix_animal)
%% ===============================================

% --file filter
if size(char(z.file),1) ==1  %regexp('*sss','*|\^|\$')
    [fis] = spm_select('List',mdir,z.file);
    fis=cellstr(fis);
else
    fis=cellstr(z.file) ;
    fis=fis(find(existn(stradd(fis,[mdir filesep  ],1))==2)) ;%check if files exist...use only those
end
% --natsort
if z.sortfiles==1
    fis=natsort(fis);
end
% --fileout
fileout=char(z.fileout);
if isempty(fileout)
    c=cellfun(@(f) {double(f)}, fis);
    minlen=min(cellfun(@(f) length(f),c));
    cm=cell2mat(cellfun(@(f) {f(1:minlen)},c)); %identmat
    w=fis{1}(1:find(var(cm,1)>0)-1);
    if strcmp(w(end),'_');    suffix= '4D';
    else                 ;    suffix='_4D';
    end
    fileout=[fis{1}(1:find(var(cm,1)>0)-1) suffix '.nii' ];
end


% ==============================================
%%  write 4D file
% ===============================================
fisFP   =stradd(fis,[mdir filesep  ],1);
fisoutFP=fullfile(mdir,fileout);
[~,animal]=fileparts(mdir);
meth=2;
if meth==1
    for j=1:length(fisFP)
        [ha a]=rgetnii(fisFP{j});
        if j==1;          a2=zeros([size(a) length(fisFP)]) ;    end; %prealloc
        a2(:,:,:,j)=a;
    end
    if z.dt==0;    rsavenii(fisoutFP,ha,a2);
    else      ;    rsavenii(fisoutFP,ha,a2,z.dt);
    end
elseif meth==2
    %% ===============================================
    %   Concatenate 3D volumes into a single 4D volume
    %   FUNCTION V4 = spm_file_merge(V,fname,dt)
    %   V      - images to concatenate (char array or spm_vol struct)
    %   fname  - filename for output 4D volume [defaults: '4D.nii']
    %            Unless explicit, output folder is the one containing first image
    %   dt     - datatype (see spm_type) [defaults: 0]
    %            0 means same datatype than first input volume
    %   RT     - Interscan interval {seconds} [defaults: NaN]
    %
    %   V4     - spm_vol struct of the 4D volume
    V4 = spm_file_merge(fisFP,fisoutFP,z.dt);
end

disp([ pnum(ix_animal,3) ']: ' animal]);
showinfo2(['...4D-NIFTI  '],fisoutFP);

%% make list ===============================================
if z.writelist==1
    filelistname=strrep(fisoutFP,'.nii','.txt');
    pwrite2file(filelistname,fis);
    showinfo2(['...3D-filelist'],filelistname);
end
%% ===============================================







function w=fileget(pa)
w='';
%% ===============================================
answer = questdlg('use file-filter or explicit fileNames?', ...
    'FileSelection', ...
    'file-filter','explicit fileNames','abort','file-filter');
switch answer
    case 'file-filter'          ; isfilefilt=1;
    case 'explicit fileNames'   ; isfilefilt=0;
    case 'abort'                ;          w='';       return;
        
end
%% ===============================================
% pa= {'F:\data10\ag_agelovskii_timeseries\dat\GORAN_NA0712023_2025120102_20251216a'}
fi2={};
for i=1:length(pa)
    [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
    if ischar(files); files=cellstr(files);   end
    fis=strrep(files,[pa{i} filesep],'');
    fi2=[fi2; fis];
end
li=unique(fi2);
[fis ]=selector2(li,{'Image'},'out','list','selection','multi', 'title','select files to merge(order does not matter)');
if ~iscell(fis); return; end
% fis=natsort(fis);
if isfilefilt==1
    c=cellfun(@(f) {double(f)}, fis);
    minlen=min(cellfun(@(f) length(f),c));
    cm=cell2mat(cellfun(@(f) {f(1:minlen)},c)); %identmat
    w=['.*' fis{1}(1:find(var(cm,1)>0)-1) '.*' '.nii' ];
    
elseif isfilefilt==0
    w=fis;
end


%% ===============================================








