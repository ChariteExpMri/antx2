% function register_dual(z)
% register image affine and bspline in two separate steps
% step1: affine reg:  skullstripped t2-image is registered to AVGT.nii
% step2: bspline reg: t2w-image (not skullstripped version) is registered to AVGT.nii
% step3: both transformations are added and can be used to transform other images via doelastix command
function register_dual(z)

warning off;

%% INPUTS




if 0
    parmf0=s.elxParamfile
    parmf0{1}=fullfile(fileparts(parmf0{1}),'parm038_affine.txt')
    
    
    z=[]
    z.parafiles= parmf0;
    z.path     = s.pa;
    z.fix1     = tpmMASK
    z.mov1     = mouseMASK
    z.M   =M;
    z.cleanup  =s.cleanup;
    
    register_dual(z);
    
end

%———————————————————————————————————————————————
%%   set up
%———————————————————————————————————————————————

z.folder={'elastixForward' 'elastixBackward'};
M=z.M;




parafiles2=replacefilepath(stradd(z.parafiles,'x',1),z.path);
for i=1:length(parafiles2)
    copyfile(z.parafiles{i},parafiles2{i},'f');
end
parafiles=parafiles2;

% ####################################################################################################
%% run Elastix : ForWardDirection
% ####################################################################################################

fprintf('..register images forwardDIR..');

%———————————————————————————————————————————————
%%   forward-1
%———————————————————————————————————————————————
forw1=fullfile(z.path,'forw1'); mkdir(forw1);
try; delete(fullfile(forw1, '*.txt' )) ;end
try; delete(fullfile(forw1, '*.log' )) ;end
try; delete(fullfile(forw1, '*.nii' )) ;end


if 0 %% RESIZE
    % ..........resize TARGET
    f1=fullfile(z.path,'AVGTmask.nii');
    [ha a c ci]=rgetnii(f1);
    [bb vox]=world_bb(f1);    vox=abs(vox);
    % a2=reshape(otsu(a(:),20),[ha.dim])>1;
    a2=a>0;
    % a3=smooth3(a2,'box',11)>0;
    %a3=imerode(a2,strel('disk',2));
    a3=imdilate(a2,strel('disk',10));
    % for i=1:size(a3,3);     a3(:,:,i)=imfill(a3(:,:,i),'holes'); end
    a4=a3(:);
    ix=find(a4>0);
    mm=c(:,ix);
    bb2=[min(mm,[],2)' ; max(mm,[],2)'] ;
    % bb2(:,3)=bb(:,3);
    resize_img6(z.fix1,z.fix1,[vox], [],bb2, [], 1);
    
    % ..........resize SOURCE
    f1=z.mov1;
    [ha a c ci]=rgetnii(f1);
    [bb vox]=world_bb(f1);    vox=abs(vox);
    % a2=reshape(otsu(a(:),20),[ha.dim])>1;
    a2=a>0;
    % a3=smooth3(a2,'box',11)>0;
    %a3=imerode(a2,strel('disk',2));
    a3=imdilate(a2,strel('disk',10));
    % for i=1:size(a3,3);     a3(:,:,i)=imfill(a3(:,:,i),'holes'); end
    a4=a3(:);
    ix=find(a4>0);
    mm=c(:,ix);
    bb2=[min(mm,[],2)' ; max(mm,[],2)'] ;
    % bb2(:,3)=bb(:,3);
    resize_img6(z.mov1,z.mov1,[vox(1)*1 vox(2)*1 vox(3)], [],bb2, [], 1);
end


%............................................................



% tic
[~,im,trfile]=evalc('run_elastix(z.fix1,z.mov1,    forw1  ,parafiles{1},   [],[]     ,[],[],[])');
%rmricron([],im,z.fix1,1);
% toc


tf =fullfile(z.path,'mt2.nii');
[ht  t0 ] =rgetnii(tf);
td=reshape(imadjust(mat2gray(t0(:))),[ht.dim]) *10000 ;
t2flip=fullfile(z.path,'t2flip.nii');
rsavenii(t2flip,ht,td);

% t2=fullfile(z.path,'t2.nii');
% t2flip=fullfile(z.path,'t2flip.nii');
% copyfile(t2,t2flip,'f');
v=  spm_vol(t2flip);
spm_get_space(t2flip,      inv(M) * v.mat);

ims=t2flip;
% [wim,wps] = run_transformix(ims,'',trfile,forw1,'');
[~,wim,wps] = evalc('run_transformix(ims,'''',trfile,forw1,'''')');
% rmricron([],wim,z.fix1,1);

%msk
% [~,wim2,wps2] = evalc('run_transformix(fullfile(z.path, ''c1c2mask.nii''),'''',trfile,forw1,'''')');

%———————————————————————————————————————————————
%%   forward-2
%———————————————————————————————————————————————
forw2=fullfile(z.path,'forw2'); mkdir(forw2);
try; delete(fullfile(forw2, '*.txt' )) ;end
try; delete(fullfile(forw2, '*.log' )) ;end
try; delete(fullfile(forw2, '*.nii' )) ;end

fix2 = z.fix1;
mov2 = wim;
p2=parafiles{2};
set_ix(p2,'FixedInternalImagePixelType' , 'float');
set_ix(p2,'MovingInternalImagePixelType', 'float');

% tic
[~,im2,trfile2]=evalc('run_elastix(fix2,mov2,    forw2  ,p2,   [],[]     ,[],[],[])');
% rmricron([],im2,fix2,1);
% toc

%———————————————————————————————————————————————
%%   merge forward 1 & 2 
%———————————————————————————————————————————————

z.outforw=fullfile(z.path,z.folder{1}); mkdir(z.outforw);
try; delete(fullfile(z.outforw, '*.txt' )) ;end
try; delete(fullfile(z.outforw, '*.log' )) ;end
try; delete(fullfile(z.outforw, '*.nii' )) ;end


t1=fullfile(z.outforw,'TransformParameters.0.txt' );
copyfile(trfile, t1,'f');
t2=fullfile(z.outforw,'TransformParameters.1.txt' );
copyfile(trfile2, t2,'f');

set_ix( t2, 'InitialTransformParametersFileName', t1 );
set_ix( t2, 'HowToCombineTransforms', 'Add' );

if 0 %resize
    hx=spm_vol(fullfile(z.path,'AVGT.nii'));
    [~,vox]=world_bb(hx.fname); vox=abs(vox);
    % (Size 116 148 35)
    % (Index 0 0 0)
    % (Spacing 0.1000000015 0.1000000015 0.2500000000)
    % (Origin 5.6750001907 8.7944593430 -7.8203458786)
    set_ix( t1,'Size'    ,[hx.dim]);
    set_ix( t1,'Spacing' ,[vox]);
    set_ix( t2,'Size'    ,[hx.dim]);
    set_ix( t2,'Spacing' ,[vox]);
    % set_ix( t2,'Origin'  ,[5.6750001907 8.7944593430 -7.8203458786]);%[hx.mat(1:3,4)]');
end


%TEST
if 0
    [  wim2,wps2] =        run_transformix(ims,'',  t2,z.outforw,'')
    % [~,wim2,wps2] = evalc('run_transformix(ims,'''',t2,z.outforw,'''')');
    rmricron([],wim2,fullfile(z.path,'AVGT.nii'),1);
end


% ####################################################################################################
%% run Elastix : backWardDirection
% ####################################################################################################
fprintf('backwardDIR..');
% tic
parafilesinv=stradd(parafiles,'inv',1);       %% copy PARAMfiles
for i=1:length(parafilesinv)
    copyfile(parafiles{i},parafilesinv{i},'f');
    pause(.01)
    rm_ix(parafilesinv{i},'Metric'); pause(.1) ;
    set_ix(parafilesinv{i},'Metric','DisplacementMagnitudePenalty'); %SET DisplacementMagnitudePenalty
end

trafofile=dir(fullfile(z.outforw,'TransformParameters*.txt')); %get Forward TRAFOfile
trafofile=fullfile(z.outforw,trafofile(end).name);

z.outbackw=fullfile(z.path, z.folder{2} ); mkdir(z.outbackw);
try; delete(fullfile(z.outbackw, '*.txt' )) ;end
try; delete(fullfile(z.outbackw, '*.log' )) ;end
try; delete(fullfile(z.outbackw, '*.nii' )) ;end


% [~,im3,trfile3]=evalc('run_elastix(z.movimg,z.movimg,    z.outbackw  ,parafilesinv,[], []       ,   trafofile   ,[],[])');
[~,im3,trfile3]=evalc('run_elastix(mov2,mov2,    z.outbackw  ,parafilesinv,[], []       ,   trafofile   ,[],[])');
trfile3=cellstr(trfile3);
set_ix(trfile3{1},'InitialTransformParametersFileName','NoInitialTransform');%% orig

if 0 %resize
    
    hz=spm_vol(fullfile(z.path,'t2.nii'));
    [~,vox]=world_bb(hz.fname); vox=abs(vox);
    % (Size 116 148 35)
    % (Index 0 0 0)
    % (Spacing 0.1000000015 0.1000000015 0.2500000000)
    % (Origin 5.6750001907 8.7944593430 -7.8203458786)
    
    tback=trfile3{1};
    set_ix( tback,'Size'    ,[hz.dim]);
    set_ix( tback,'Spacing' ,[vox]);
    tback=trfile3{2};
    set_ix( tback,'Size'    ,[hz.dim]);
    set_ix( tback,'Spacing' ,[vox]);
    % set_ix( t2,'Origin'  ,[5.6750001907 8.7944593430 -7.8203458786]);%[hx.mat(1:3,4)]');
   % toc
end


% TEST
if 0
    px=z.path
    doelastix('transform'     , px,    {fullfile(px,'t2.nii')}    ,3,M );
    rmricron([],fullfile(px,'x_t2.nii'),fullfile(px,'AVGT.nii'),1);
    
    doelastix('transforminv'  , px,    {fullfile(px,'AVGT.nii')}  ,3,M );
    rmricron([],fullfile(px,'t2.nii'),fullfile(px,'ix_AVGT.nii'),0);
end


%———————————————————————————————————————————————
%%   cleanup
%———————————————————————————————————————————————
if z.cleanup ==1
    
    try; delete(fullfile(z.outforw, '*.nii' )) ;end
    try; delete(fullfile(forw1, '*.nii' )) ;end
    try; delete(fullfile(forw2, '*.nii' )) ;end
    try; delete(fullfile(z.outbackw, '*.nii' )) ;end
    
    try; rmdir(forw1, 's'); end
    try; rmdir(forw2, 's'); end

    
end

fprintf('[Done].\n ');





