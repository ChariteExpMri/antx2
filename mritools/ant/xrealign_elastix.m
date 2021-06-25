
% #yk  Realign a 3d-(time)series/4Dvolume using ELASTIX and mutual information
%  --> MULTIMODAL APPROACH
%  --> usefulfor instance for DWI-data
%  #b Images are realigned to the first image.
% 
%
%  #r _______________________________________________________________________________
%  #r NOTE: The realignment routine uses ELASTIX and mutual Information (MI).
%  #r Use this function if the 4D-series contains abnormal intensity changes.
%  #r Using sum of sqared differences as metric to realign 3d images the
%  #r monomodal-approach (xrealign.m) coud fail
%  #r Alternatively, this proedure uses mutual information which can be more
%  #r successful for multi-modal images.
%  #r _______________________________________________________________________________
%   
% ==============================================
% #ka   EXAMPLE                                      
% ==============================================
% % =====================================================                                                                                                                                          
% % #b The 4D-timeseries is realigned using MI. The realigned output is "rshort.nii"  
% % #b Here, 2 pyramid levels are used, each with 500 iterations.
% % =====================================================                                                                                                                                          
% z=[];                                                                                                                                                                                              
% z.image3D            = { '' };                                                                % % SELECT: a 3D-volume series to realign (only 1st image is needed to select here)                  
% z.image4D            = { 'short.nii' };                                                       % % SELECT: a 4D-volume to realign                                                                   
% z.convertDataType    = [0];                                                                   % % converts dataType if 4D volume is to large: [0]no..keep dataType, [16] change to single precision
% z.merge4D            = [1];                                                                   % % merge 3D-series to 4D-volume: [0]no,keep 3D-volumes, [1]save as 4D-volume                        
% z.prefix             = 'r';                                                                   % % Filename Prefix:specify the string to be prepended to the filenames of the resliced image        
% z.outputname         = '';                                                                    % % optional: rename outputfile; if empty the output-filename is "prefix"+"inputfilename"            
% z.cleanup            = [1];                                                                   % % remove temporary files [0]no,[1]yes                                                              
% z.keepConvertedInput = [1];                                                                   % % if "convertDataType" is 16,the converted input will be kept(1) or deleted (0) afterwards         
% z.isparallel         = [1];                                                                   % % parallel-processing: [0]no,[1]yes                                                                
% z.paramfile          = 'f:\antx2\mritools\elastix\paramfiles\trafoeuler5_MutualInfo.txt';     % % registration parameterfile                                                                       
% z.numres             = [2];                                                                   % % number of pyramid resolutions. Larger is more precise & more time-consuming.                     
% z.niter              = [500];                                                                 % % number of iterations in each resolution level.Larger is more precise & more time-consuming.      
% z.interp             = [3];                                                                   % % Interpolation: [0]NN, [1]trilinear, [3] bslpine-order 3                                          
% xrealign_elastix(1,z);                                                                        % % execute this function, open paramter GUI before execution 
% ==============================================
% #wg   PARAMETER                     
% ===============================================
% images either list of 3d-files or a 4d volume:
% EITHER:
% 'image3D'          SELECT: a 3D-volume series to realign. If you yuse this, select only the 1st 
%                    image of the series in the GUI
% OR:
% 'image4D'          SELECT: a 4D-volume to realign
% 'convertDataType'        16 'converts dataType if 4D volume is to large: {0,16}
%              This might be an issue if the 4D file is really large (~>1.6GB). I this case an error
%              is produced when reading the image ("Mapping-Error"-->SPM-related).
%               [0]  no..keep SAME dataType, 
%               [16] change to single precision' 
% 'merge4D'    merge 3D-series to 4D-volume:{0,1}
%               [0] no,keep 3D-volumes, 
%               [1] save as 4D-volume' 
% ---------------------
% 'prefix'     Filename Prefix:specify the string to be prepended to the filenames of the resliced image
%               default: 'r'  
%              The output-filename is: "r"+INPUTFILENAME
% 'outputname'  OPTIONAL: rename outputfile
%               iI empty the output-filename is "prefix"+"inputfilename"  
%                default: ''  --> default is empty, thus output-filename is "r"+INPUTFILENAME
% 'cleanup'     remove temporary created files/subfolders {0,1}
%                [0] no ..keep temporary fles (used for debugging)
%                [1] yes ...clean up
%               default: 1
% 'keepConvertedInput'   If "convertDataType" is 16, a copy of the (super large) 4d-input is converted 
%              to single precision (filename: 'INPUTFILENAME+16.nii'). 
%               [0]  no, delete this file afterwards
%               [1] yes, keep this converted input. Reason: In some cases there is no way to display
%                   & compare the realigned time series with the original one, because the original
%                   4D input volume is to large (>1.5GB) to read into memory
% 'isparallel'  use parallel-processing:
%                [0]  no
%                [1]  yes  ...  use parallel-processing for multiple 4D volumes (for different animals)
%                default: 1
% 
% #wb __ ELASTIX OPTIONS __________
% 'paramfile' Parameter file used by ELASTIX to realign the timeseries
%                --> default: "trafoeuler5_MutualInfo.txt'" This paramter setting used mutual information
%                 as metric for registriation          
% 'numres'   Number of pyramid resolutions (levels). 
%            If the number of resolutions is increased, the registration precission is better but the 
%            processing-time increases as well.
%              default: 2
% 'niter'    Number of iterations within each resolution level. More iterations increase registration 
%           precission but also processing time.
%              default: 500
% 'interp'  'final output Interpolation: 
%              [0]NN, [1]trilinear, [3] bslpine-order 3 '  
%              default: 3  , which seems fine timecourse data
% 
% ==============================================
% #ka  GUI/batch                                   
% ==============================================
% After evaluation the 'anth'-struct contains the paramter and command for this function
% Type: char(anth) or click [anth]-BTN
% xrealign_elastix(showgui,x) wtih "showgui" (0,1) to hide/showgui the GUI and "x" the paramter struct
    



function xrealign_elastix(showgui,x,pa)


%===========================================
%%   PARAMS
%===========================================
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end

%===========================================
%%   %% test SOME INPUT
%===========================================
if 0
    pa={...
        'F:\data3\graham_ana4\dat\20190122GC_MPM_01'
        'F:\data3\graham_ana4\dat\20190122GC_MPM_02'};
    
    
end

%________________________________________________
%% fileList
[fl] =filelist(pa);


[fls] =filelist(pa,struct( 'NIIfile', 'firstImage'));


%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end

p={...
    'inf1'      'SECLECT EITHER "image3D"  OR  "image4D"          '                         '' ''
    'image3D'         {''}     'SELECT: a 3D-volume series to realign (only 1st image is needed to select here) '  {@selector2,fls.li,fls.hli,'out',[1 ],'selection','single'};
    'image4D'         {''}     'SELECT: a 4D-volume to realign'  {@selector2,fl.li,fl.hli,'out',[1 ],'selection','single'};
    'convertDataType'  16 'converts dataType if 4D volume is to large: [0]no..keep dataType, [16] change to single precision' {0,16}
    'merge4D'          1 'merge 3D-series to 4D-volume: [0]no,keep 3D-volumes, [1]save as 4D-volume' {0,1}
     
    'prefix'         'r'        'Filename Prefix:specify the string to be prepended to the filenames of the resliced image'  ''
    'outputname'     ''         'optional: rename outputfile; if empty the output-filename is "prefix"+"inputfilename"' ''
    'cleanup'        1          'remove temporary files [0]no,[1]yes'  'b'
    'keepConvertedInput'   1    'if "convertDataType" is 16,the converted input will be kept(1) or deleted (0) afterwards'  'b'
    
    'isparallel'     1  'parallel-processing: [0]no,[1]yes'  'b'
    'inf20' '%' '' ''
    
    'inf33' '___ OPTIONS __________' '' ''
    'paramfile'  fullfile(fileparts(fileparts(which('ant.m'))),'elastix','paramfiles' ,'trafoeuler5_MutualInfo.txt')      'registration parameterfile '  {@getparmfiles }
    'numres'    2    'number of pyramid resolutions. Larger is more precise & more time-consuming. ' {1:6}
    'niter'    500   'number of iterations in each resolution level.Larger is more precise & more time-consuming. '  {100 500 1000 1500 2000}
    'interp'     3      'Interpolation: [0]NN, [1]trilinear, [3] bslpine-order 3 '  ''
    };


p=paramadd(p,x);
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[0.2604    0.3833    0.5056    0.3511 ],...
        'title',[mfilename],'info',hlp);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end



xmakebatch(z,p, mfilename);


% ==============================================
%%   proceed
% ===============================================


if z.isparallel==1
    timex=tic;
    parfor i=1: length(pa)
        px=pa{i};
        f1=fullfile(px,num2str([char(z.image3D) char(z.image4D)]));
        try
            cprintf([1 .5 0],[ num2str(i) '/' num2str(length(pa)) '__REALIGNING: ' strrep(f1,[filesep],[filesep filesep]) '\n']);
        catch
            fprintf(  [ num2str(i) '/' num2str(length(pa)) '__REALIGNING: ' strrep(f1,[filesep],[filesep filesep]) '\n']);
        end
        proc(z,px);
    end
    cprintf(-[1 .5 0],sprintf(['DONE (dT=%2.2f min).\n'],toc(timex)/60));
else
    timex=tic;
    for i=1: length(pa)
        px=pa{i};
        f1=fullfile(px,num2str([char(z.image3D) char(z.image4D)]));
        try
            cprintf([1 .5 0],[ num2str(i) '/' num2str(length(pa)) '__REALIGNING: ' strrep(f1,[filesep],[filesep filesep]) '\n']);
        catch
            fprintf(  [ num2str(i) '/' num2str(length(pa)) '__REALIGNING: ' strrep(f1,[filesep],[filesep filesep]) '\n']);
        end
        proc(z,px);
    end
    cprintf(-[1 .5 0],sprintf(['DONE (dT=%2.2f min).\n'],toc(timex)/60));
end






function proc(z,px)

% ==============================================
%%   input file
% ===============================================
if isempty(char(z.image4D)) && isempty(char(z.image3D))
    disp(['3D or 4D image not specified: ' ]);
    return
end

flist={char(fullfile(px,z.image3D)) ; char(fullfile(px,z.image4D))};
existfiles=[exist(flist{1}) exist(flist{2})];
itype=find(existfiles==2);
if itype==1
    is4D=0;
    f1=char(fullfile(px,z.image3D)); %1st-image in 3D series
elseif itype==2
    is4D=1;
    f1=char(fullfile(px,z.image4D)); %4D-volume
end




if exist(f1)~=2
    disp(['image not found: '  f1]);
    return
end
 timx=tic;
% ==============================================
%%   convert DATATYPE if IMAGE IS TO LARGE
% ===============================================
[~, name, ext]=fileparts(f1);

if is4D==1 && z.convertDataType~=0
    % ==============================================
    %% split 4D to 3D
    % ===============================================
    
    pxtemp=fullfile(px,['temp3D__' name  ]);
    warning off;
    mkdir(pxtemp);
    
   
    fprintf('..splitting 4D-image..');
    spm_file_split(f1,pxtemp);
    fprintf(['done (dT=%2.2fmin)'],toc(timx)/60);
    
    
    % ==============================================
    %% change dataType and rewrite 4D volume
    % ===============================================
    fi= spm_select('FPList', pxtemp, ['^' name '_\d{5}.nii']);
    fi=cellstr(fi);
    
    dT=z.convertDataType;
    f2=fullfile(px, [ name num2str(dT) '.nii' ]);
    
    fprintf('..creating 4D-image with changed dataType..');
    V4 = spm_file_merge(fi,f2,dT);
    fprintf(['done (dT=%2.2fmin'],toc(timx)/60);
    
    mergedImage=f2;
    % ==============================================
    %% cleanUp temp-folder
    % ===============================================
    if exist(pxtemp)==7
        rmdir(pxtemp,'s');
    end
    
elseif is4D==1 && z.convertDataType==0
    f2=f1;
elseif is4D==0 %---------------------------------------3D-data
    
    
end


% ==============================================
%%   REALIGN-1: FILES
% ===============================================
if is4D==1
    [~,name2]=fileparts(f2);
    f3= spm_select('ExtFPList', px, ['^' name2 '.nii$']);
    
else
    [~ ,namex,ext]=fileparts(f1);
    namestem=regexprep(namex,'_00+1$','');
    f2= spm_select('FPList', px, ['^' namestem '_0\d+' '.nii$']);
    f2=cellstr(f2);
    f3=f2;    
    
    
    [~,name2]=fileparts(f3{1});
    name=namestem;
    
end

% ==============================================
%%   2a) some settings
% ===============================================
pxtemp=fullfile(px,['temp3D__' name  ]);


mkdir(pxtemp);
if is4D==1
    vo=spm_file_split(f1, pxtemp);  % distribute 3d files
    fis     = {vo(:).fname}'  ; %3D-files to realign
else  %single 3d-files
    fis=cellstr(f3);
end

paramfile=replacefilepath(z.paramfile,pxtemp);  %copy parameter file
copyfile(z.paramfile,paramfile,'f');


set_ix(paramfile,'NumberOfResolutions'              ,   z.numres   );
set_ix(paramfile,'MaximumNumberOfIterations'        ,   z.niter    );
set_ix(paramfile,'FinalBSplineInterpolationOrder'   ,   z.interp   );

% ==============================================
%%   2b run elastix
% ===============================================

fix     = fis{1}          ; %fixed image 
outfold = pxtemp;         ; %elastix-DIR

fis2=repmat({''},[length(fis) 1]);
fprintf('..realign Data..');
for i=1:length(fis)
    mov=fis{i};
    [arg,oim,os] = evalc('run_elastix(fix,mov,outfold,paramfile,[],[],[],[],[])');
    fis2{i,1}=oim;
end
fprintf(['done (dT=%2.2fmin)\n'],toc(timx)/60);



% ==============================================
%%   convert to 4D
% ===============================================
[~ ,namex,ext]=fileparts(f1);
namestem=regexprep(namex,'_00+1$','');
name=[ z.prefix namestem];
[~, animal]=fileparts(px);


dT=z.convertDataType;
f2=fullfile(px, [ name   '.nii' ]);

fprintf('..creating 4D-image ..');
V4 = spm_file_merge(fis2,f2,dT);
fprintf(['Done (dT=%2.2fmin)\n'],toc(timx)/60);


f4=f2;
if ~isempty(z.outputname)
    f5=fullfile(px,[strrep(z.outputname,'.nii','') '.nii']);
    movefile(f4,f5,'f');
    showinfo2(['alignedFile(4D)[' animal ']' ],f5);
else
    showinfo2(['alignedFile(4D)[' animal ']' ],f4);
end


% ==============================================
%%   cleanup
% ===============================================
if z.keepConvertedInput==0
    try; delete(mergedImage); end
end

if z.cleanup==1
    try
        if exist(mergedImage)==2
            matfile=strrep(mergedImage,'.nii','.mat');
            if exist(matfile)==2
                try; delete(matfile); end
            end
        end
    end
    try; rmdir(outfold,'s'); end
end














% ==============================================
%%   fileList
% ===============================================

function [fl] =filelist(pa,pp)

p0.NIIfile='all';
if exist('pp')~=0
   p0=catstruct(p0,pp); 
end

% -----FILTERType
if strcmp(p0.NIIfile,'all')
    flt=['.*.nii$'];
elseif strcmp(p0.NIIfile,'firstImage')
    flt=['.*_0+1.nii$'];
end


fi2={};
for i=1:length(pa)
    [files,~] = spm_select('FPList',pa{i},flt);
    if ischar(files); files=cellstr(files);   end;
    fi2=[fi2; files];
end
[px fis ext  ]=fileparts2(fi2);
namesLong=cellfun(@(a,b){[ a b ]},fis,ext);
names=unique(namesLong);

[r r2]=ismember(namesLong,names);
counts=histc(r2, unique(r2));
tx={};[names cellstr(num2str(counts))];
for i=1:length(names)
    ix=min(find(r2==i));
    firstfile=fi2{ix};
    h=spm_vol(firstfile);
    if ~isempty(h)
        h1=h(1);
        if length(h)>1
            dims=sprintf('%dx%dx%dx%d',h1.dim,length(h));
            ndims='4';
        else
            dims=sprintf('%dx%dx%d',h1.dim) ;
            ndims='3';
        end
        %----BYTE
        k=dir(firstfile);
        MB=sprintf('%8.2fMB', k.bytes/1e6);
        
        %---date
        %Date=k.date;
        Date=datestr(k.datenum,'yy/mm/dd HH:MM:SS');
        %#### agglom ###
        tx(end+1,:)={names{i} num2str(counts(i))   dims ndims  MB  Date};
    end
end


fl.hli={'file' 'counts' 'dims' 'Ndims' 'size(MB)'  'Date'};
if isempty(tx)
   tx=repmat({''},[1  length(fl.hli)]) ;
end
fl.li =tx;



%
% tx
% selector2(li,hli,'out','list','selection','single')


% ==============================================
%%
% ===============================================




function he=getparmfiles(li,lih)
%     'warpParamfile'  fullfile(fileparts(fileparts(which('ant.m'))),'elastix','paramfiles' ,'p33_bspline.txt')      'parameterfile used for warping'  @getparmfiles

he=[];
pap=fileparts(which('trafoeuler2.txt'));
msg='select one/more Parameter file for rigid/affine/bspline transformation (in that order)"';
[t,sts] = spm_select(inf,'any',msg,'',pap,'.*.txt','');
t=cellstr(t);
if isempty(t); return; end
% t=cellstr(t);
% [s ss]=paramgui('getdata')
% paramgui('setdata','x.wa.orientelxParamfile',[t ' % rem'])
he=t;
return









