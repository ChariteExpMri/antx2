

% #wg [xregisterCT] this function registers a CT image to a t2.nii-image
% the t2.nii-image has to be warped to AllenSpace before running this function because ix_AVGT.nii is
% used as reference for CT-to-t2.nii-registration
%
% #wg PARAMETER
% CTimg     :  The CT-image that should be registered into "t2.nii"-space  ,
%              - example: 'ct.nii'
% APPimg    :  <optional> other images (0,1 or n-images) which should be registered using the
%              estimated transformation rule
%              - example: { 'spect.nii' ,'spect2.nii'};
%              - (default: '')
% prefix    : output name prefix for the registered images (default: 'R')
% interp    : interpolation order ('auto',0,1,2,3..)
%             - "auto": autodetect the interpolation order. Usefull if several images should be registered
%               at once but different interp-order should be used (default)
%             - 0: should be used for masks and atlases
%             - otherwise use higher order interpolation 1,2,3
% direction : transformation direction:
%              -[1]  forward direction: refers to the --> t2w.nii image space   (default: [1])
%              -[-1] backward direction refers to the --> CT image space
%              -NOTE: forward direction [1] must be allways initially selected to estimate the forward
%               and backward registration. When calling the function a 2nd. time, other images can be
%               registered using the the backward direction (into CT space)
% paramfile : Elastix parameter file for registration. (default: '..antx\mritools\elastix\paramfiles\trafoeulerCT.txt')
% approach  : registration approach: currently only approach-1 available   (default:[1]);
% dimspace  : change output image size/resolution via DIM or SPACING information
%             - default is '': In this way the size & spacing of the output image is that of the target image
%             - DIMS: type a 3 element vector such as [250 250 30], refering to the number of slices in each direction
%               Hence, the output image has the dims [250 250 30].
%             - Spacing: type a 3 element vector such as [.1 .1 .3], refering to the voxelsize
%               Hence, the output image has the spacing [.1 .1 .3].
% =========================================================================================================
% #wr PROCEDURE -IMPORTANT NOTE
% #r STEP-I: Estimate the forward and backward transformation.
% #k For this, the "CTimg" must be defined and the direction is [1].
% #k Additionally other images can be selected to bring these images into the 't2.nii'-space, (i.e.
% #k forward direction)
% #k note the step-I saves the transformation paramerts, thus step-I has to be performed only once
% #r STEP-II: <optional> Transform Images
% #k After STEP-I, re-run this function to register other images either to the 't2.nii'-space
% #k (forward) or to CT.nii-space (backward). Note, that the forward direction allready allows to register
% #k other images in STEP-I (i.e ideally STEP-II is not necessary for the forward direction)
% #k set the CTimg parameter to '' (empty) to prevent a re-calculation of the transformation and only
% transform the images
% =========================================================================================================
%
% #wg RUN function
% -runs with an open ANTX-project
% -mouse dir(s) must be selecteed fro ANT gui in advance
% use
% xregisterCT  or xregisterCT(1); % open gui
% xregisterCT(1,z);               % open gui with parameter settings
% xmergedirs(0,z);                % silent mode
%
% #wg History/batch
%  after running type anth or char(anth) or uhelp(anth) to get the parameter
% ==============================================================================================================================
% #wg EXAMPLES
%% SIMPLE EXAMPLE, registering 'ct.nii' to 't2.nii'
%% xregisterCT(1,struct('CTimg','ct.nii'));
%
%% EXAMPLE-1 register 'ct.nii' to 't2.nii', apply trafo to 'spect.nii', add Prefix 'R' to output image file
%% autodetect interp. order,..dimspace of the output image matches that of the target image ('t2.nii')
% z=[];
% z.CTimg     = { 'ct.nii' };                                               % %  << select the CT-image
% z.APPimg    = { 'spect.nii' };                                            % %  << select other images (0,1 or n-images) for which the transformation should be applied
% z.prefix    = 'R';                                                        % % name prefix for the registered images
% z.interp    = 'auto';                                                     % % interpolation order ("auto": autodetect)
% z.direction = [1];                                                        % % transformation direction: [1]foward (--> t2w.nii) or [-1] backward (-->ct-image), initially [1] has be selected to estimate f/b transformation
% z.paramfile = 'o:\antx\mritools\elastix\paramfiles\trafoeulerCT.txt';     % % Elastix parameter file for registration
% z.approach  = [1];                                                        % % registration approach: currently only approach-"1" available
% z.dimspace  = '';                                                         % % change resulting image size/resolution via DIM or SPACING, such as [250 250 30] or [.1 .1 .3]), or leave empty to use target size
% xregisterCT(1,z);
%
%% EXAMPLE-2 apply forward-registration (! trafo-estimation has been done before !)
% register 'spect.nii' and 'CT.nii'  to 't2.nii'-image space (thus z.direction = [11]), ..dimspace of the output image matches that of the target image ('t2.nii')
% z=[];
% z.CTimg     = '';                                                         % %  << select the CT-image
% z.APPimg    = {	'spect.nii' 'ct2.nii' };                                % %  << select other images (0,1 or n-images) for which the transformation should be applied
% z.prefix    = 'R';                                                        % % name prefix for the registered images
% z.interp    = 'auto';                                                     % % interpolation order ("auto": autodetect)
% z.direction = [1];                                                        % % transformation direction: [1]foward: to t2w.nii [-1] backward: to ct-image, always us [1] in initial step to estimate to estimate the transformation
% z.paramfile = 'o:\antx\mritools\elastix\paramfiles\trafoeulerCT.txt';     % % Elastix parameter file for registration
% z.approach  = [1];                                                        % % registration approach: currently only approach-"1" available
% z.dimspace  = '';	% change resulting image size/resolution via DIM or SPACING, such as [250 250 30] or [.1 .1 .3]), or leave empty to use target size
% xregisterCT(0,z);
%
%% EXAMPLE-3 apply BACKWARD-registration (! trafo-estimation has been done before !)
% register 't2.nii' to CT-image space (thus z.direction = [-1]), ..dimspace of the output image matches that of the target image ('CT.nii')
% z=[];
% z.CTimg     = '';                                                         % %  << select the CT-image
% z.APPimg    = {	't2.nii' };                                             % %  << select other images (0,1 or n-images) for which the transformation should be applied
% z.prefix    = 'R';                                                        % % name prefix for the registered images
% z.interp    = 'auto';                                                     % % interpolation order ("auto": autodetect)
% z.direction = [-1];                                                       % % transformation direction: [1]foward: to t2w.nii [-1] backward: to ct-image, always us [1] in initial step to estimate to estimate the transformation
% z.paramfile = 'o:\antx\mritools\elastix\paramfiles\trafoeulerCT.txt';     % % Elastix parameter file for registration
% z.approach  = [1];                                                        % % registration approach: currently only approach-"1" available
% z.dimspace  = '';	% change resulting image size/resolution via DIM or SPACING, such as [250 250 30] or [.1 .1 .3]), or leave empty to use target size
% xregisterCT(0,z);
%
%% EXAMPLE-4 same as example-3, but output image spacing is [120 120 100]
% register 't2.nii' to CT-image space (thus z.direction = [-1]), ..dimspace of the output image matches that of the target image ('CT.nii')
% z=[];
% z.CTimg     = '';                                                         % %  << select the CT-image
% z.APPimg    = {	't2.nii' };                                             % %  << select other images (0,1 or n-images) for which the transformation should be applied
% z.prefix    = 'R';                                                        % % name prefix for the registered images
% z.interp    = 'auto';                                                     % % interpolation order ("auto": autodetect)
% z.direction = [-1];                                                       % % transformation direction: [1]foward: to t2w.nii [-1] backward: to ct-image, always us [1] in initial step to estimate to estimate the transformation
% z.paramfile = 'o:\antx\mritools\elastix\paramfiles\trafoeulerCT.txt';     % % Elastix parameter file for registration
% z.approach  = [1];                                                        % % registration approach: currently only approach-"1" available
% z.dimspace  = [120 120 100];	% change resulting image size/resolution via DIM or SPACING, such as [250 250 30] or [.1 .1 .3]), or leave empty to use target size
% xregisterCT(0,z);



function bla(showgui,x,pa)


%============================================================================================================================================
%%   example
%============================================================================================================================================
if 0
    
    z=[];
    z.CTimg     = { 'ct.nii' };                                                          % %  << select the CT-image
    z.APPimg    = { 'spect.nii' };                                                       % %  << select other images (0,1 or n-images) for which the transformation should be applied
    z.prefix    = 'R';                                                                   % %  name prefix for the registered images
    z.interp    = 'auto';                                                                % %  interpolation order ("auto": autodetect)
    z.paramfile = { 'C:\MATLAB\antx\mritools\elastix\paramfiles\trafoeulerCT.txt' };     % % Elastix parameter file for registration
    z.approach  = [1];                                                                   % % registration approach: currently only approach-"1" available
    xregisterCT(1,z);
    
    %PC
    z=[];
    z.CTimg     = { 'ct.nii' };                                               % %  << select the CT-image
    z.APPimg    = { 'spect.nii' };                                            % %  << select other images (0,1 or n-images) for which the transformation should be applied
    z.prefix    = 'R';                                                        % % name prefix for the registered images
    z.interp    = 'auto';                                                     % % interpolation order ("auto": autodetect)
    z.direction = [1];                                                        % % transformation direction: [1]foward: to t2w.nii [-1] backward: to ct-image, always us [1] in initial step to estimate to estimate the transformation
    z.paramfile = 'o:\antx\mritools\elastix\paramfiles\trafoeulerCT.txt';     % % Elastix parameter file for registration
    z.approach  = [1];                                                        % % registration approach: currently only approach-"1" available
    xregisterCT(1,z);
    
    
    z=[];
    z.CTimg     = { '' };                                               % %  << select the CT-image
    z.APPimg    = { 'spect.nii' };                                            % %  << select other images (0,1 or n-images) for which the transformation should be applied
    z.prefix    = 'R';                                                        % % name prefix for the registered images
    z.interp    = 'auto';                                                     % % interpolation order ("auto": autodetect)
    z.direction = [1];                                                        % % transformation direction: [1]foward: to t2w.nii [-1] backward: to ct-image, always us [1] in initial step to estimate to estimate the transformation
    z.paramfile = 'o:\antx\mritools\elastix\paramfiles\trafoeulerCT.txt';     % % Elastix parameter file for registration
    z.approach  = [1];                                                        % % registration approach: currently only approach-"1" available
    xregisterCT(1,z);
    
    
    z=[];
    z.CTimg     = { '' };                                               % %  << select the CT-image
    z.APPimg    = { 'ix_AVGT.nii' };                                            % %  << select other images (0,1 or n-images) for which the transformation should be applied
    z.prefix    = 'R';                                                        % % name prefix for the registered images
    z.interp    = 'auto';                                                     % % interpolation order ("auto": autodetect)
    z.direction = [-1];                                                        % % transformation direction: [1]foward: to t2w.nii [-1] backward: to ct-image, always us [1] in initial step to estimate to estimate the transformation
    z.paramfile = 'o:\antx\mritools\elastix\paramfiles\trafoeulerCT.txt';     % % Elastix parameter file for registration
    z.approach  = [1];                                                        % % registration approach: currently only approach-"1" available
    xregisterCT(1,z);
    
    
    z=[];
    z.CTimg     = '';                                                         % %  << select the CT-image
    z.APPimg    = { 'spect.nii' 	'ct.nii' };                                  % %  << select other images (0,1 or n-images) for which the transformation should be applied
    z.prefix    = 'R';                                                        % % name prefix for the registered images
    z.interp    = 'auto';                                                     % % interpolation order ("auto": autodetect)
    z.direction = [1];                                                        % % transformation direction: [1]foward: to t2w.nii [-1] backward: to ct-image, always us [1] in initial step to estimate to estimate the transformation
    z.paramfile = 'o:\antx\mritools\elastix\paramfiles\trafoeulerCT.txt';     % % Elastix parameter file for registration
    z.approach  = [1];                                                        % % registration approach: currently only approach-"1" available
    xregisterCT(1,z);
    
    
    z=[];
    z.CTimg     = '';                                                         % %  << select the CT-image
    z.APPimg    = {	'ct.nii' };                                  % %  << select other images (0,1 or n-images) for which the transformation should be applied
    z.prefix    = 'R';                                                        % % name prefix for the registered images
    z.interp    = 'auto';                                                     % % interpolation order ("auto": autodetect)
    z.direction = [1];                                                        % % transformation direction: [1]foward: to t2w.nii [-1] backward: to ct-image, always us [1] in initial step to estimate to estimate the transformation
    z.paramfile = 'o:\antx\mritools\elastix\paramfiles\trafoeulerCT.txt';     % % Elastix parameter file for registration
    z.approach  = [1];                                                        % % registration approach: currently only approach-"1" available
    z.dimspace  =  [100 100 30];	% change resulting image size/resolution via DIM or SPACING, such as [250 250 30] or [.1 .1 .3]), or leave empty to use target size
    xregisterCT(1,z);
    
    
    z=[];
    z.CTimg     = '';                                                         % %  << select the CT-image
    z.APPimg    = {	'ct.nii' };                                  % %  << select other images (0,1 or n-images) for which the transformation should be applied
    z.prefix    = 'R';                                                        % % name prefix for the registered images
    z.interp    = 'auto';                                                     % % interpolation order ("auto": autodetect)
    z.direction = [1];                                                        % % transformation direction: [1]foward: to t2w.nii [-1] backward: to ct-image, always us [1] in initial step to estimate to estimate the transformation
    z.paramfile = 'o:\antx\mritools\elastix\paramfiles\trafoeulerCT.txt';     % % Elastix parameter file for registration
    z.approach  = [1];                                                        % % registration approach: currently only approach-"1" available
    z.dimspace  =  [.1 .1 .1];	% change resulting image size/resolution via DIM or SPACING, such as [250 250 30] or [.1 .1 .3]), or leave empty to use target size
    xregisterCT(1,z);
    
    %% BACKW
    z=[];
    z.CTimg     = '';                                                         % %  << select the CT-image
    z.APPimg    = {	't2.nii' };                                  % %  << select other images (0,1 or n-images) for which the transformation should be applied
    z.prefix    = 'R';                                                        % % name prefix for the registered images
    z.interp    = 'auto';                                                     % % interpolation order ("auto": autodetect)
    z.direction = [-1];                                                        % % transformation direction: [1]foward: to t2w.nii [-1] backward: to ct-image, always us [1] in initial step to estimate to estimate the transformation
    z.paramfile = 'o:\antx\mritools\elastix\paramfiles\trafoeulerCT.txt';     % % Elastix parameter file for registration
    z.approach  = [1];                                                        % % registration approach: currently only approach-"1" available
    z.dimspace  =  [.1 .1 .1];	% change resulting image size/resolution via DIM or SPACING, such as [250 250 30] or [.1 .1 .3]), or leave empty to use target size
    xregisterCT(1,z);
    
    z=[];
    z.CTimg     = '';                                                         % %  << select the CT-image
    z.APPimg    = {	't2.nii' };                                  % %  << select other images (0,1 or n-images) for which the transformation should be applied
    z.prefix    = 'R';                                                        % % name prefix for the registered images
    z.interp    = 'auto';                                                     % % interpolation order ("auto": autodetect)
    z.direction = [-1];                                                        % % transformation direction: [1]foward: to t2w.nii [-1] backward: to ct-image, always us [1] in initial step to estimate to estimate the transformation
    z.paramfile = 'o:\antx\mritools\elastix\paramfiles\trafoeulerCT.txt';     % % Elastix parameter file for registration
    z.approach  = [1];                                                        % % registration approach: currently only approach-"1" available
    z.dimspace  =  [];	% change resulting image size/resolution via DIM or SPACING, such as [250 250 30] or [.1 .1 .3]), or leave empty to use target size
    xregisterCT(0,z);
    
end

%============================================================================================================================================
%%   INPUT-PARAMS
%============================================================================================================================================
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                           ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end

% v=getuniquefiles(pa);
[tb tbh v]=antcb('getuniquefiles',pa);

if ~isfield(x,'paramfile')
    x.paramfile=which('trafoeulerCT.txt');
end

%============================================================================================================================================
%%  PARAMETER-gui
%============================================================================================================================================
if exist('x')~=1;        x=[]; end
p={...
    'inf0'      ['*** ' mfilename ' ***   ']                '' ''
    'inf7'     repmat('-',[1 length(mfilename)+8  ])        '' ''
    
    'CTimg'          ''           ' << select the CT-image'  {@selectfile,v,'single'}
    'APPimg'         ''           ' << select other images (0,1 or n-images) for which the transformation should be applied'  {@selectfile,v,'multi'}
    'prefix'         'R'          'name prefix for the registered images '  ''
    'interp'         'auto'       'interpolation order ("auto": autodetect)'  {'auto' '0' '1'  '2' '3'}
    'direction'      1            'transformation direction: [1]foward (--> t2w.nii) or [-1] backward (-->ct-image), initially [1] has be selected to estimate f/b transformation '  {'1' '-1'}
    
    'inf8'     ' '        '' ''
    'inf9'     '__ other parameters __'        '' ''
    
    'paramfile'     x.paramfile                 'Elastix parameter file for registration'  {@getparamfile}
    'approach'     1                            'registration approach: currently only approach-"1" available '    ''
    'dimspace'   ''      'change resulting image size/resolution via DIM or SPACING, such as [250 250 30] or [.1 .1 .3]), or leave empty to use target size '  {'' '100 100 100'  '.1 .2 .15' }
    
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .75 .35 ],...
        'title',['***'  mfilename '***'],'info',{@uhelp,[ mfilename '.m']});
    try; fn=fieldnames(z); catch; return; end
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end



xmakebatch(z,p, mfilename);
processloop(z, pa);





return

%=======================================================
function out=getparamfile
out='';
[v v2]=paramgui('getdata');
x=v2;
pa=fullfile(fileparts(fileparts(which('ant.m'))),'elastix','paramfiles');
if isfield(x,'paramfile')
    x=cellstr(x.paramfile);
    pu=fileparts(x{1});
    if isdir(pu)
        pa=pu;
    end
end
[t,sts] = spm_select(inf,'mat','select an elastix parameter file','', pa,'.*.txt','');
if isempty(t); return; end
out=cellstr(t);
%=======================================================
function he=selectfile(v,selectiontype)
he=selector2(v.tb,v.tbh,...
    'out','col-1','selection',selectiontype);



%=======================================================
% loop
%=======================================================
function processloop(z,pa)
atic=tic;
mdir=cellstr(pa);

for i=1:length(mdir)
    z.mdir=mdir{i};
    [~, name]=fileparts(z.mdir);
    try
        cprintf([0 .5 0], [ num2str(i) '/' num2str(length(mdir)) ' [' name ']   dt: ' ...
            sprintf('%3.2f' ,toc(atic)/60)  ' min ****************************************' '\n']);
    catch
        disp([ num2str(i) '/' num2str(length(mdir)) ' [' name ']   dt: ' ...
            sprintf('%3.2f' ,toc(atic)/60)  ' min ****************************************' ]);
    end
    process(z);
end
disp(['[DONE] dt:' sprintf('%3.2f' ,toc(atic)/60)  ' min' ]);

%=======================================================
% process
%=======================================================
function process(z)

if z.approach==1
    approach_brainmatch(z)
end
return


function approach_brainmatch(z)
warning off;


pa       =char(z.mdir);
[~, name]=fileparts(pa);
outforw  =fullfile(pa,'forwCT');
outback  =fullfile(pa,'bacwCT');
z.CTimg  =char(z.CTimg);

z.estimate =0;
if isempty(z.prefix); z.prefix='R'; end
if ischar(z.dimspace); z.dimspace=str2num(z.dimspace); end





%% ESTIMATE TRAFO
if ~isempty(z.CTimg)
    
    check=fullfile(pa, z.CTimg );
    if exist(check)~=2
        try
            cprintf([1 0 1],[ ' * for [' name '] inputfile [' z.CTimg '] does not exist !!! --> skipped..\n' ]);
        catch
            disp([ ' * for [' name '] inputfile [' z.CTimg '] does not exist !!! --> skipped..' ]);
        end
        return
        %else
        %disp([ ' *   for [' name '] registering image [' z.CTimg ']'  ]);
    end
    
    z.estimate =1;
    
    %============================================================================================================================================
    %% necessary unspecified parameters
    %============================================================================================================================================
    z.fix= 'ix_AVGT.nii';
    z.estimate =1;
    
    mkdir(outforw );
    mkdir(outback );
    %============================================================================================================================================
    %% getting CT image
    %============================================================================================================================================
    
    try
        cprintf([.87 .490 0], [ '.. reading image [' z.CTimg ']'  ]);
    catch
        fprintf(['.. reading image [' z.CTimg ']']);
    end
    
    [ha a]=rgetnii(fullfile(pa, z.CTimg ));
    si=size(a);
    a2=a(:);
    a3=reshape((otsu(a2,3)),si);
    a4=a3==3;
    
    % a3=reshape((otsu(a2,4)),si);
    % a4=a3>3;
    %============================================================================================================================================
    %%   S1: extracting brain: axial
    %============================================================================================================================================
    
    fprintf(['.. get brain from skull: steps 1']);
    do=1;
    jj=0;
    while do==1
        no=6+jj;
        jj=jj+1;
        nv=-no:no;
        x=zeros(size(a4));
        for i=1:size(a4,3)
            vc=nv+i;
            vc(vc<1)=[];
            vc(vc>size(a4,3))=[];
            
            r=mean(a4(:,:,vc),3);
            r=r>0;
            r1=imdilate(r,ones(4));
            r2=imfill(r1,'holes');
            r3=imerode(r,ones(4));
            r4=imdilate(r2-r1,ones(5));
            
            x(:,:,i)=r4>0;
            
            if 0
                figure(10)
                subplot(2,2,1);imagesc(r)
                subplot(2,2,2);imagesc(a4(:,:,i))
                subplot(2,2,3);imagesc(r4*3+r); title(i);
                subplot(2,2,4);imagesc(r4*3+a4(:,:,i)); title(i);
                pause; drawnow
            end
        end
        
        
        % missing slice
        
        %     fg,imagesc(squeeze(mean(x,2)))
        wm=squeeze(mean(mean(x,2),1));
        ix=find(wm==0);
        ix(  find(ix<  round(size(x,3)*.2)  )   )=[];
        ix(  find(ix>  size(x,3)-round(size(x,3)*.2)  )   )=[];
        if isempty(ix)
            do=0;
        end
        
    end
    
    
    %============================================================================================================================================
    %%   S2: extracting brain: topdown
    %============================================================================================================================================
    
    fprintf(['.2']);
    lim=4;
    vc=[-lim:lim];
    xv=zeros(size(x));
    for i=1:size(x,2)
        ix=vc+i;
        ix(ix<1)=[];
        ix(ix>size(x,2))=[];
        
        ar  =squeeze(a4(:,i,:));
        ar2 =squeeze(a4(:,ix,:));
        ar2 =squeeze(mean(a4(:,ix,:),2))>0;
        
        br=squeeze( x(:,i,:));
        rd  =imfill(ar+br,'holes')-ar;
        rd2 =imfill(ar2+br,'holes')-ar2;
        rd3=(rd2+rd)>0;
        xv(:,i,:)=rd3;
        
        if 0
            figure(10)
            subplot(2,2,1); imagesc(ar); title(i);
            subplot(2,2,2); imagesc(br);
            subplot(2,2,3); imagesc(ar+2*rd);
            subplot(2,2,4); imagesc(ar+2*rd3);
            drawnow; pause
        end
    end
    
    %============================================================================================================================================
    %%   S3: extracting brain: sagittal
    %============================================================================================================================================
    
    fprintf(['.3']);
    lim=8;
    vc=[-lim:lim];
    xh=zeros(size(x));
    for i=1:size(x,1)
        ix=vc+i;
        ix(ix<1)=[];
        ix(ix>size(x,1))=[];
        
        ar  =squeeze(a4(i,:,:));
        ar2 =squeeze(a4(ix,:,:));
        ar2 =squeeze(mean(a4(ix,:,:),1))>0;
        
        br=squeeze( x(i,:,:));
        rd  =imfill(ar+br,'holes')-ar;
        rd2 =imfill(ar2+br,'holes')-ar2;
        rd3=(rd2+rd)>0;
        xh(i,:,:)=rd3;
        
        if 0
            figure(10)
            subplot(2,2,1); imagesc(ar); title(i);
            subplot(2,2,2); imagesc(br);
            subplot(2,2,3); imagesc(ar+2*rd);
            subplot(2,2,4); imagesc(ar+2*rd3);
            drawnow; pause
        end
    end
    
    
    
    %============================================================================================================================================
    %%  updating skull
    %============================================================================================================================================
    
    x=xh;
    
    
    %============================================================================================================================================
    %%   cluster image
    %============================================================================================================================================
    fprintf(['..clustering']);
    %% remove other cluster
    [b2 n]=bwlabeln(double(x),6);
    uni=[1:(n)]';
    nx=histc(b2(:),uni);
    tb=sortrows([nx uni],1);
    x2=(b2==tb(end,2));
    
    %============================================================================================================================================
    %%   find connected clusters
    %============================================================================================================================================
    fprintf(['..connectedness']);
    x3=x2;
    mid=round(size(x3,3)/2);
    mx=x3(:,:,mid );
    [b2 n2]=bwlabeln(mx);
    uni=[1:n2]';
    if n2>1
        nr=histc(b2(:),uni);
        nuni=sortrows([nr uni],1);
        b2lab=nuni(end,2);
    else
        b2lab=1;
    end
    x3(:,:,mid) = b2==b2lab;
    
    
    i1=[round(size(x3,3)/2)-1:-1:1 round(size(x3,3)/2)+1: size(x3,3) ];
    i2=[[[round(size(x3,3)/2)-1:-1:1]+1] [[round(size(x3,3)/2)+1: size(x3,3)]-1] ];
    for i=1:length(i1)
        r1=x3(:,:,i2(i));
        e1=x3(:,:,i1(i));
        
        [b1 n1]=bwlabeln(e1);
        [b2 n2]=bwlabeln(r1);
        
        uni=[1:n2]';
        if n2>1
            nr=histc(b2(:),uni);
            nuni=sortrows([nr uni],1);
            b2lab=nuni(end,2)
        else
            b2lab=1;
        end
        
        
        uni=unique(b1(b2==b2lab));
        uni(uni==0)=[];
        
        if 0
            figure(11);
            imagesc([e1 r1]), title(i1(i));
        end
        
        
        if length(uni)==1
            x3(:,:,i1(i))=(b1==uni);
        elseif length(uni)>1
            
            
            me=b1(b2==1);
            nr=histc(me,uni);
            nuni=sortrows([nr uni],1);
            uni=nuni(end,2);
            x3(:,:,i1(i))=(b1==uni);
        else
            %          keyboard
            x3(:,:,i1(i))=0;
        end
        
        
        
        
        
        if 0
            %     figure(11);
            %    imagesc([e1 r1]), title(i1(i));
            drawnow;pause
        end
    end
    
    %============================================================================================================================================
    %%   remove tail
    %============================================================================================================================================
    fprintf(['..remove tail']);
    
    df=abs(diff(squeeze(sum(sum(x3,1),2))));
    dr=df<median(df);
    t1=min(find(dr~=1));
    t2=max(find(dr~=1));
    if t1~=1; t1=t1-1; end
    if t2~=size(x3,3); t2=t2+1; end
    
    x4=x3;
    x4(:,:,1:t1)  =0;
    x4(:,:,t2:end)=0;
    
    
    if 0
        fg,imagesc(squeeze(mean(x4,1)))
        %%
    end
    
    %============================================================================================================================================
    %%   write CTbrain image
    %============================================================================================================================================
    % keyboard
    fprintf(['..write vol']);
    
    hv  =ha;
    hv  =rmfield(hv,'private');
    hv  =rmfield(hv,'pinfo');
    hv.descrip =['source: ' z.CTimg];
    mov =fullfile(pa,'_brainCT.nii');
    rsavenii(mov,[hv],uint8(x4),[2 0]);
    
    fprintf(['.[done]\n']);
    
    %============================================================================================================================================
    %%   write ref image (ix_AVGT)
    %============================================================================================================================================
    fprintf(['.. write REFvol']);
    [hb b]=rgetnii(fullfile(pa,z.fix)); % fix: 'ix_AVGT.nii'
    fix=fullfile(pa,'_brainAllen.nii');
    rsavenii(fix,[hb],uint8(b>50),[2 0]);
    %rmricron([],mov,fix, 2,[20 -1])
    
    
    %============================================================================================================================================
    %%  elastix forward
    %============================================================================================================================================
    fprintf(['..running Elastix forward']);
    try; rmdir(outforw,'s'); end;
    mkdir(outforw);
    
    pf0=cellstr(z.paramfile);
    for i=1:length(pf0)
        [~ ,fi, ext]=fileparts(pf0{i});
        pf{i,1}=fullfile(outforw,[fi ext]);
    end
    copyfilem(pf0,pf);
    
    
    
    % [im,trfile] = run_elastix(fix,mov,    outforw  ,pf,   [],[]       ,[],[],[]);
    [arg,im,trfile] =evalc('run_elastix(fix,mov,    outforw  ,pf,   [],[]       ,[],[],[])');
    
    
    % rmricron([],im,fix, 2,[20 -1])
    %     O:\data4\CT_Oelschlegel3\dat\Max_SP18_075M_wt\forwCT\elx__brainCT-0.nii
    %     trfile
    %     trfile =
    %     O:\data4\CT_Oelschlegel3\dat\Max_SP18_075M_wt\forwCT\TransformParameters.0.txt
    
    % % % %     if 0
    % % % %         %% end
    % % % %         trfile2=cellstr(trfile);
    % % % %         for j=1:length(z.app)
    % % % %             app=fullfile(pa,z.app{j});
    % % % %             appout=fullfile(pa,['V' z.app{j}]);
    % % % %
    % % % %             [im4,tr4] =        run_transformix(  app ,[],trfile2{end},   out ,'');
    % % % %             copyfile(im4,appout );
    % % % %
    % % % %         end
    % % % %
    % % % %         t2=fullfile(pa,'t2.nii' );
    % % % %         rmricron([],t2,appout, 2,[20 -3])
    % % % %     end
    
    
    %============================================================================================================================================
    %%  elastix backward
    %============================================================================================================================================
    
    fprintf([' & backward']);
    try; rmdir(outback,'s'); end;
    mkdir(outback);
    
    
    
    %% copy PARAMfiles
    pfinv=stradd(pf,'inv',1);
    pfinv=strrep(pfinv,outforw,outback);
    for i=1:length(pfinv)
        copyfile(pf{i},pfinv{i},'f');
        pause(.01)
        rm_ix(pfinv{i},'Metric'); pause(.1) ;
        set_ix(pfinv{i},'Metric','DisplacementMagnitudePenalty'); %SET DisplacementMagnitudePenalty
    end
    
    trafofile=dir(fullfile(outforw,'TransformParameters*.txt')); %get Forward TRAFOfile
    trafofile=fullfile(outforw,trafofile(end).name);
    
    %[im3,trfile3  ]=run_elastix(mov,mov,   outback  ,pfinv,[], []       ,   trafofile   ,[],[])
    [~,im3,trfile3]=evalc('run_elastix(mov,mov,   outback  ,pfinv,[], []       ,   trafofile   ,[],[])');
    
    
    
    %% [im3,trfile3] = run_elastix(z.movimg,z.movimg,    z.outbackw  , (parafilesinv), [],[]   ,   trafofile   ,[],[]);
    trfile3=cellstr(trfile3);
    %set "NoInitialTransform" in TransformParameters.0.txt.
    set_ix(trfile3{1},'InitialTransformParametersFileName','NoInitialTransform');%% orig
    %set_ix(trfile3{2},'InitialTransformParametersFileName','NoInitialTransform');
    
    
    %% test backward
    if 0
        app=fullfile(pa,'t2.nii');
        [imb,tb] =        run_transformix(  app ,[],trfile3{end},   outback ,'');
        
        rmricron([],fullfile(pa,'ct.nii'),imb, 2,[20 -3]);
        
        %     trfile3{end}
        %     ans =
        %     O:\data4\CT_Oelschlegel3\dat\Max_SP18_075M_wt\bacwCT\TransformParameters.0.txt
        
    end
    
end %estimate


%============================================================================================================================================
%%   transform other images
%============================================================================================================================================
disp([' ..transform images' ]);
z.APPimg=cellstr(z.APPimg);
if ~isfield(z,'direction')
    z.direction = 1;
end


if z.estimate ==1
    z.APPimg= [z.CTimg; z.APPimg];
    z.direction = 1;
end
z.APPimg(find(cellfun(@isempty,z.APPimg)))=[];   %remove empty cells

if isempty(char(z.APPimg))
    return
end

if z.direction==1 %forward direction
    out    = outforw;
    prefix = [z.prefix];
    testimg =fullfile(pa,'t2.nii');
    tag='forward-transform';
    try
        ref =fullfile(pa,'t2.nii');
    end
else
    out    = outback;
    prefix = ['i' z.prefix];
    testimg =fullfile(pa,'ct.nii');
    tag='back-transform';
    try
        href=spm_vol(fullfile(pa,'_brainCT.nii'));
        ref=fullfile(pa,strrep(href.descrip,'source: ',''));
    end
    
end


trafofile=dir(fullfile(out,'TransformParameters*.txt')); %get Forward TRAFOfile
if isempty(trafofile);
    try
        cprintf([1 0 1], [ '.. skipped trafo in [' name '] because transformation parameter is missing' '\n']);
    catch
        disp([ '.. skipped trafo in [' name '] because transformation parameter is missing']);
    end
    disp([ '        ->  solution: calculate transformation before applying transformation to other images']);
    
    return
end
trafofile=fullfile(out,trafofile(end).name);
trafofile=cellstr(trafofile);
trafofile=trafofile{end};


for j=1:length(z.APPimg)
    app=fullfile(pa,z.APPimg{j});
    if exist(app)==2
        disp([' ..' tag  ': ' z.APPimg{j} '' ]);
        if isnumeric(z.interp)==1; z.interp=num2str(z.interp); end
        if strcmp(z.interp,'auto')
            [hu u]=rgetnii(app);
            u=u(:);
            if all(u==round(u)) == 1
                interp=0;%NN
            else
                interp=1;%lin
            end
        else
            interp=num2str(z.interp);
        end
        set_ix(trafofile, 'FinalBSplineInterpolationOrder',interp);
        
        %*******************************************************
        % CHANGE DIM/SPACE
        if ~isempty(z.dimspace)
            
            res={};
            res.size  = get_ix(trafofile,'Size');
            res.space = get_ix(trafofile,'Spacing');
            res.input=z.dimspace;
            if sum(z.dimspace>2)==3  % DIMS where given
                res.spaceNew =(res.size./res.input).*res.space;
                res.sizeNew =res.input;
            else  %voxelsize/SPACING
                res.sizeNew =round((res.space./res.input).*res.size);
                res.spaceNew =res.input;
            end
            
            set_ix(trafofile,'Size'   , res.sizeNew );
            set_ix(trafofile,'Spacing', res.spaceNew );
            
        end
        %*******************************************************
        
        
        % [im4,tr4] =        run_transformix(  app ,[],trafofile,   out ,'');
        [arg im4,tr4] =  evalc('run_transformix(  app ,[],trafofile,   out ,'''')');
        %t2=fullfile(pa,'t2.nii' );     rmricron([],t2,im4, 2,[20 -3])
        
        appout=fullfile(pa,[ prefix z.APPimg{j}]);
        movefile(im4,appout ,'f');
        set_ix(trafofile, 'FinalBSplineInterpolationOrder',3);
        %rmricron([],testimg ,appout, 0,[20 -3]);
        %rmricron([],appout,testimg, 0,[20 -3]);
        
        
        %*******************************************************
        % RESET DIM/SPACE in TRAFOFILE
        if ~isempty(z.dimspace)
            set_ix(trafofile,'Size'   , res.size   );
            set_ix(trafofile,'Spacing', res.space  );
        end
        %*******************************************************
        
        
        
        [~, fil,ext]=fileparts(appout);
        disp(['    [' [fil ext] '] created in [' name ']'  ': <a href="matlab: explorerpreselect(''' appout ''')">' 'Explorer' '</a>' ...
            ' or <a href="matlab: rmricron([],''' appout ''' ,''' ref ''', 0,[30 -3])">' 'MRicron' '</a>'   ]);
        
        
        
    end
end









