%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% all meta-function here   ---guis werden spaeter gemacht...
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••



%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% segmentation
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if 0
    %% AUTO all
    
    close all;clear;warning off
    
    voxres=[0.0700    0.0700    0.0700 ]
    prefdir='O:\harms1\harmsStaircaseTrial\dat';
    
    %     prefdir=pwd;
    msg={'SEGEMNTATION STEP' 'select mouseFolders with  T2images '};
    [t2path,sts] = cfg_getfile2(inf,'dir',msg,[],prefdir,'^s');
    
    
    for i=1:size(t2path,1)
        xnormalize(t2path{i}, voxres ,0);
    end
    
end
if 0
    %% MANU-single
    
    voxres=[0.0700    0.0700    0.0700 ]
    t2path='O:\harms1\harmsStaircaseTrial\dat\s20150506SM11_1_x_x'
    xnormalize(t2path, voxres ,1); %MANUEL
    %
    
    %% AUTO-single
    xnormalize(t2path, voxres ,0);%AUTO
end
 
 %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% checkoverlay
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if 0
    xcheckoverlay('O:\harms1\harmsStaircaseTrial\dat', 1, 1, 1);  %GUI+mode1+save+keep currentFig
end

 %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% copy mask and other images
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if 0
x.pathdat='O:\harms1\harmsStaircaseTrial\dat' 
 xcopyimg2t2(fileparts(x.pathdat),  x.pathdat); %
end

if 0
   xcheckoverlay('O:\harms1\harmsStaircaseTrial\dat', 2, 1, 1); 
end


 %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% deform imgaes
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

tic
voxres=[0.0700    0.0700    0.0700 ]
[files,dirs] = cfg_getfile('FPList','O:\harms1\harmsStaircaseTrial\dat\s20150505SM01_1_x_x','lesion_total_mask.*')
xdeform(   files         ,1,  voxres, 0)
toc


cd O:\overlay

[pathx s]=antpath
pa='O:\harms1\harmsStaircaseTrial\dat\s20150506SM11_1_x_x'

x.subjectname='ddd'
x.views             =1 ;  %multiple view: [1] x.orient only  [2] 2views fixed with 'sagittal' and 'axial' views
x.slices            =[-5:1:5];  %slices to display
x.orient            ='coronal'  ;%'axial','coronal','sagittal'
x.cmap              =[];%colormap;  [] if empty use defaults colormap otherwise use x.cmap=jet,or cmap=copper etc
x.crange            =[];  %colorRange :  [] if empty use subject's colorRange, otherwise 2numbers, e.g. [0 1000]
x.itype0            ={ 'Structural' 'Truecolour' } ;%colorSystem %'Structural' 'Truecolour' 'Negative blobs' 'Blobs'
x.intensity         =[];

% f1=fullfile( s.refpa, 'AVGTsmall.nii') %  ;fullfile(pwd,'hx_T2.nii')
% f2=fullfile( pa, 'wT2.nii') ;%fullfile(pwd,'hx_c1T2.nii')
% % f3=fullfile(pwd,'hx_c2T2.nii')

f1=fullfile( pa, 'wT2.nii') ;%fullfile(pwd,'hx_c1T2.nii')
f2=s.refTPM{1}

x.imgs{1,1}=[f1 ];  tagMPR='pbsMPR';
% x.imgs{2,1}=[f2 ',1'];
x.imgs{2,1}=[f2 ];

p_displaySlices(x);

add.anatomicalImg=f1;   add.transparency=.7
pslices(f2,[],[-3:  .3 :3],'','coronal',add) ;









 
 