function snips_input1

snips
return


%% #################################################
% cmd
% open Antx-GUI and load project
ant;
antcb('load',  fullfile(pwd,'proj.m'  ))  ;

% close Antx-GUI
antcb('close')

% close Antx-GUI & exit from snips-GUI
snips('close');
antcb('close'); exit

% update Antx-GUI from github
updateantx(2);


%% #################################################
% cmd
% open Antx-history

uhelp(anth) ;
%% #################################################
% cmd
% costumize matlab-session
antcb('cwcol',[1 .94 .87]); 
antcb('cwname','paul works here');

%% #################################################
% file-conversion
% convert an IMG/HDR file to NIfTI format, and replace the header of a mask image
% with the header from the corresponding structural image

pa=pwd
fi1=fullfile(pa,'20250313MO_SCI_Ko01_sag.img');
fi2=fullfile(pa,'20250313MO_SCI_Ko01_sag_masklesion.img');
[ha a]=rgetnii(fi1);
[hb b]=rgetnii(fi2);

fo1=fullfile(pa,'t2.nii');
fo2=fullfile(pa,'mask.nii');
rsavenii(fo1, ha, a, 64);  %safe 'fi1' as NIFTI
rsavenii(fo2, ha, b, 64);  %safe 'fi2' as NIFTI & replace header, using [ha] from 'fi1'

%% #################################################
% file-conversion
% convert all obj-files file from folder 'path_files' and it's source (img/hdr) to NIFTI
path_files='H:\Daten-2\Imaging\AG_Eickholt_SCI\segmentation'
suffix='_mask';
cd(path_files);
[t,sts] = spm_select(inf,'any','Select analyze-files to convert to NIFTI ',[],path_files,...
    '.*.obj');
t=cellstr(t);
if isempty(t); return; end
for i=1:size(t,1)
    objfile   = t{i};
    [pam name ext]=fileparts(objfile);
    [ho o]    = obj2nifti(objfile);
    imgfile   = fullfile(pam, [name '.img' ]);
    [ha a]    = rgetnii(imgfile);
    a         = flipud(a);
    Fo1       = fullfile(pam, [name '.nii' ]);
    rsavenii(Fo1, ha,a, 16);
    %showinfo2([ 'file' ] ,Fo1);
    Fo2       = fullfile(pam, [name suffix '.nii' ]);
    o2        = flipdim(flipdim(o,1),2);
    rsavenii(Fo2, ha,o2, 16);
    showinfo2([ 'file' ] ,Fo1,Fo2,13);
end
%% #################################################
% pipeline
% from Bruker-import to standardspace

%% ==============================================
%% 1.  make ANTx-project
%%     CREATE A PROJECT-FILE WITHOUT GUI: HERE THE PROJECTFILE "proj2.m" IS CREATED USING A VOXELSIZE
%%     OF [.07 .07 .07] mm, and the ANIMAL-TEMPLATE "mouse_Allen2017HikishimaLR" is used, with species 'mouse'
% ===============================================
makeproject('projectname',fullfile(pwd,'proj.m'), 'voxsize',[.07 .07 .07],...
    'wa_refpath','D:\MATLAB\anttemplates\mouse_Allen2017HikishimaLR',...
    'wa_species','mouse')

antcb('load',fullfile(pwd,'proj.m')); % LOAD A PROJECT-FILE "proj.m"

%% ==============================================
%%   2. IMPORT BRUKER-DATA (use all steps here)
%% ===============================================
% DISPLAY all Bruker-files from 'raw'-folder, PLEASE INSPECT THE TABLE BEFORE DOING THE NEXT STEP
w1=xbruker2nifti(fullfile(pwd,'raw'),0,[],[],'gui',0,'show',1);
 
% FILTER and DISPLAY a list of Bruker files where the protocol name contains 'T2_ax_mousebrain'
protocol='T2_ax_mousebrain'
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',1,'flt',{'protocol',protocol});
 
% IMPORT Bruker files where the protocol name contains 'T2_ax_mousebrain'
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',0,'flt',{'protocol',protocol},...
    'paout',fullfile(pwd,'dat'),'ExpNo_File',1);


%% ========================================================================================
%%   3. copy and rename structural image as "t2.nii"
%%      "t2.nii" will be used for transformation to standard space
%% =========================================================================================
antcb('selectdirs','all');   % select all animal-folders
xrename(0,'2_1_T2_ax_mousebrain_3.nii','t2.nii',':');% copy file and name it 't2.nii'

%% ========================================================================================
%%   4. get HTML-file with pre-orientations 
%%      please inspect the HTML-file. Use the best-matching rotation index from the HTML file 
%%      to update the orientType variable in the project file (proj.m).
%% ========================================================================================
antcb('getpreorientation','selectdirs',1);% GET HTMLFILE WITH PRE-ORIENTATION FOR TRAFO TO STANDARD-SPACE from 1st animal

%% ========================================================================================
%%   5. change 'orientType' variable in project-file
%%      When inspecting the HTML-file best orientation is [1] which is set in 'orientType' variable 
%%      in project-file, projectfile is saved and reloaded
%% ========================================================================================
global an
an.wa.orientType=1   ;% set orientType to [1]
antcb('saveproject') ;% save projfile
antcb('reload')      ;% reload projfile
clear an

%% ========================================================================================================================
%%   6. calculate transformation & back-transformation (native-space (NS) -- standard-space (SS))
%%      using parallel-processing
%% =======================================================================================================================
antcb('selectdirs','all');   % select all animal-folders
xwarp3('batch','task',[1:4],'autoreg',1,'parfor',1);

 
%% ================================================================
%%  7. transform images from native to standard-space (SS)
%% =================================================================
 
antcb('selectdirs','all'); %select all animals
% transform bias-corrected t2.nii ('mt2.nii') to SS using B-spline interpolation
doelastix(1, [], 'mt2.nii'  ,3 ,'local' );
 
% transform GrayMatter and WhiteMatter Imaget to SS using linear interpolation
doelastix(1, [], {'c1t2.nii' 'c2t2.nii'}  ,1 ,'local' ); 
 
%% ================================================================
%%  8. transform images from standard-space to native-space  (NS)
%% =================================================================
% transform brain-hemisphere mask from standard-space to native-space using NN-interpolation
doelastix(-1, [], {'AVGThemi.nii'}  ,0 ,'local' );
 
%% ====================================================================================
%%  9. region-based image readout from image in standard-space
%%     get region-based paramers of GrayMatter-image in SS using AllenBrain atlas
%% =====================================================================================
z=[];                                                                                                                                                                              
z.files        = { 'x_c1t2.nii' };            % % files used for calculation                                                                                                                
z.fileNameOut  = 'paras_grayMatter_SS';       % % <optional> specific name of the output-file. EMPTY FIELD: use timestamp+paramter for file name                                            
xgetlabels4(0,z);  
 
%% ====================================================================================
%%  10. region-based image readout from image in native-space (NS)
%%      get region-based paramers of GrayMatter-image in NS using AllenBrain atlas
%% =====================================================================================
z=[];
z.files        = {'c1t2.nii'};  % files used for calculation     
z.space        =  'native'  ;% use images from "standard","native" or "other" space 
z.hemisphere   =  'both';   % hemisphere used: "left","right","both" (united)  or "seperate" (left and right separated)
z.fileNameOut  = 'paras_grayMatter_NS';            % % <optional> specific name of the output-file. EMPTY FIELD: use timestamp+paramter for file name                                            
xgetlabels4(0,z);
 
 
 
 


%% #################################################
% pipeline
% PIG-atlas: from Bruker-import to standardspace ( use donwsampled volume)

%% ==============================================
%% 1.  make ANTx-project
%%     CREATE A PROJECT-FILE WITHOUT GUI: HERE THE PROJECTFILE "proj.m" IS CREATED USING A VOXELSIZE
%%     OF [0.5 0.5 0.5] mm, and the ANIMAL-TEMPLATE "piglet_4weeks_PIGMRI_V21" is used, with species 'piglet4w'
% ===============================================
makeproject('projectname',fullfile(pwd,'proj.m'), 'voxsize',[0.5 0.5 0.5],...
    'wa_refpath','F:\anttemplates\piglet_4weeks_PIGMRI_V21',...
    'wa_species','piglet4w')
ant
antcb('load',fullfile(pwd,'proj.m')); % LOAD A PROJECT-FILE "proj.m"

%% ==============================================
%%   2. IMPORT BRUKER-DATA (use all steps here)
%% ===============================================
% DISPLAY all Bruker-files from 'raw'-folder, PLEASE INSPECT THE TABLE BEFORE DOING THE NEXT STEP
w1=xbruker2nifti(fullfile(pwd,'raw'),0,[],[],'gui',0,'show',1);
 
% FILTER and DISPLAY a list of Bruker files where the protocol name contains 'RARE_8_PigBrain5'
% If more than 1 volume should be imported use vertical bar ('|') and strings contained in the protocol-column
% examples; protocol='RARE_8_PigBrain5|Network-DTI';  (will import 'RARE_8_PigBrain5_Cdkl5' and 'Network-DTI_SE_3D_20dir-Piglet4-Cdkl5')
protocol='RARE_8_PigBrain5';
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',1,'flt',{'protocol',protocol});
 
% IMPORT Bruker files with the specific protocol names
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',0,'flt',{'protocol',protocol},...
    'paout',fullfile(pwd,'dat'),'ExpNo_File',1);

dispfiles();% check files and folders

%% ========================================================================================
%%   3. downsample and rename structural image ('RARE_8_PigBrain5_Cdkl5_6.nii') as "t2.nii"
%% REASON: 'RARE_8_PigBrain5_Cdkl5_6.nii' is super large/much larger than the atlas
%%      "t2.nii" will be used for transformation to standard space
%% NOTE: for registration we use a donwsampled version, because image is to large (840MB)!!!!
%% =========================================================================================
antcb('selectdirs','all');   % select all animal-folders
xrename(0,'RARE_8_PigBrain5_Cdkl5_6.nii','t2.nii','vr: 0.5 0.5 0.5');% downsample file and name it 't2.nii' (voxelresoulution: 0.5, 0.5,0.5)

%% ========================================================================================
%%   4. get HTML-file with pre-orientations 
%%      please inspect the HTML-file. Use the best-matching rotation index from the HTML file 
%%      to update the orientType variable in the project file (proj.m).
%%  !!NOTE THAT THIS STEP DOES NOT WORK HERE BECAUSE BRAINS OF THAT STUDY ARE RANDOMLY DROPPED INTO THE MR-BORE!!
%% ========================================================================================
antcb('getpreorientation','selectdirs',1);% GET HTMLFILE WITH PRE-ORIENTATION FOR TRAFO TO STANDARD-SPACE from 1st animal
% all brains have a different pre-orientation (don't know why??)--> so we have to obtain the pre-orientation for each animal
% see step-5


%% ========================================================================================
%%   5. because step [4] does not work here...
%%      for each animal use 'examine orientation via HTML-file'  and/or 'get orientation via 3-point selection'  to
%%      obtain a proper preorientation --> make a table (animal x preorientation)
%%     Now; for each animal the  project-file is modified, reloaded, and the first two steps (ini and coreg) are performed
%% ========================================================================================

 % table with animal-names and specific pre-orientations
tb1={    %ANIMAL                            PREORIENTATION
    'YW24_1229_4-weekWTpiglet'              '2.5708 0 0'
    'YW25_0103_4-weekWTpigmale174-7'        '-2.7 4.1 0.15'
    'YW25_0308_4-wk-pig-WT'                 '1.5708 6.1232e-17 -1.570'
};

for i=1:size(tb1,1)
    
    global an
    an.wa.orientType          =tb1{i,2};    % set orientType..this is different for each animal
    an.wa.usePriorskullstrip  =[0];         % brains are already skullstripped
    antcb('saveproject');                   % save projfile
    antcb('reload');                        % reload projfile
    clear an
    drawnow
    
    antcb('selectdirs', tb1{i,1}); drawnow;  %select specific animal
    
    % do only the fisrt 2 steps (ini & coreg)
    xwarp3('batch','task',[1:2],'autoreg',1,'parfor',0);
    
end


%% ========================================================================================================================
%%   6. SEGEMTANTATION (STEP-3) & NONLINEAR REGISTRATION (STEP 4)
%%      calculate transformation & back-transformation (native-space (NS) -- standard-space (SS))
%%      using parallel-processing
%% =======================================================================================================================
antcb('selectdirs','all');   % select all animal-folders
xwarp3('batch','task',[3:4],'autoreg',1,'parfor',1);

 
%% ================================================================
%%  7. transform images from native to standard-space (SS)
%% =================================================================
 
antcb('selectdirs','all'); %select all animals
% transform bias-corrected t2.nii ('mt2.nii') to SS using B-spline interpolation
doelastix(1, [], 'mt2.nii'  ,3 ,'local' );
 
% transform GrayMatter and WhiteMatter Imaget to SS using linear interpolation
doelastix(1, [], {'c1t2.nii' 'c2t2.nii'}  ,1 ,'local' ); 
 
%% ================================================================
%%  8. transform images from standard-space to native-space  (NS)
%% =================================================================
% transform brain-hemisphere mask from standard-space to native-space using NN-interpolation
doelastix(-1, [], {'AVGThemi.nii'}  ,0 ,'local' );
 
%% ====================================================================================
%%  9. region-based image readout from image in standard-space
%%     get region-based paramers of GrayMatter-image in SS using AllenBrain atlas
%% =====================================================================================
z=[];                                                                                                                                                                              
z.files        = { 'x_c1t2.nii' };            % % files used for calculation                                                                                                                
z.fileNameOut  = 'paras_grayMatter_SS';       % % <optional> specific name of the output-file. EMPTY FIELD: use timestamp+paramter for file name                                            
xgetlabels4(0,z);  
 
%% ====================================================================================
%%  10. region-based image readout from image in native-space (NS)
%%      get region-based paramers of GrayMatter-image in NS using AllenBrain atlas
%% =====================================================================================
z=[];
z.files        = {'c1t2.nii'};  % files used for calculation     
z.space        =  'native'  ;% use images from "standard","native" or "other" space 
z.hemisphere   =  'both';   % hemisphere used: "left","right","both" (united)  or "seperate" (left and right separated)
z.fileNameOut  = 'paras_grayMatter_NS';            % % <optional> specific name of the output-file. EMPTY FIELD: use timestamp+paramter for file name                                            
xgetlabels4(0,z);
 
 
 
 % ============================================================================================
%% [11.1] BIG_VOLUME:  trafo ANO.nii from standardspace to native space ('ix_ANO_big.nii')
%%  with the same size as the orig. big image 'RARE_8_PigBrain5_Cdkl5_6.nii' (super large: 840MB)
% =============================================================================================
tic
mdirs=antcb('getsubjects') ;
fref=fullfile(mdirs{1},'RARE_8_PigBrain5_Cdkl5_6.nii');
h=spm_vol(fref);

%-use explicit files:
% files = {'F:\data9\devin_pigRegistation\dat\YW24_1229_4-weekWTpiglet\ANO.nii'};
%-or use filename and selected animals from GUI-listbox: 
files='ANO.nii';
pp.resolution     = h.dim  ;% [520  850  256];                                          
pp.source         =  'intern';                                                 
pp.fileNameSuffix =  '_big0';     % creates 'ix_ANO_big.nii'                                             
fis=doelastix(-1, [],files,0,'local' ,pp);                                                                                                                      
toc

% ===FIX issue off different spaces of  'RARE_8_PigBrain5_Cdkl5_6.nii' and 'ix_ANO_big0.nii'
mdirs=antcb('getsubjects') ;
for i=1:length(mdirs)
    fref=fullfile(mdirs{i},'RARE_8_PigBrain5_Cdkl5_6.nii');
    f1=fullfile(mdirs{i},'ix_ANO_big0.nii');
    f2=fullfile(mdirs{i},'ix_ANO_big.nii');
    rreslice2target(f1, fref, f2, 0);
    try; delete(f1); end
    
    %PLOT OVERLAY OF WITH 10 SLICES (BIG-IMAGE & AND 'ix_ANO_big2.nii')
    slice='n10'; % 10 slices
    [d ] = getslices( fref    ,2,[slice],[],0 );
    [o ] = getslices({fref f2},2,[slice],[],0 );
    d2=imadjust(mat2gray(montageout(permute(d,[1 2 4 3]))));
    o2=imadjust(mat2gray(montageout(permute(o,[1 2 4 3]))));
    imoverlay2(d2,o2);  hfig=gcf;
    addNote(hfig,'text',['____  mdir: <b>' mdirs{i} '</b><br>'],'pos',[0 0  1 .05],'mode','multi');
    set(hfig,'menubar','none');
end
toc

%% #################################################
% PLOTS
% make plots/save as PNG-file
%% ==========================================================================================
%%  single image
%% ==========================================================================================
%  show AVGT as coronar slices (2nd dim)
f2=fullfile(pwd,'AVGT.nii')
slice2png(f2,'dim',2,'showonly',1);

% sliced along dim-2, 8 eqzidistant slices displayed in 1 row ..saved as 'AVGT.png'
slice2png(f2,'dim',2,'nslices',8,'sb',[1 nan]);

% or use explizit slice-numbers (100,120,150,170) --> only shown, not saved
slice2png(f2,'sb',[1 nan],'dim',2,'slice',[100 120 150 170],'showonly',1)

% or use slices based on mm-unit --> display slices with -5mm,-2.01mm,0mm,0.5mm
slice2png(f2,'sb',[1 nan],'dim',2,'slicemm',[-5 -2.01 0 0.5],'showonly',1)
% more plots in more contrained mm-block (20 slices within -1mm and 0mm)
slice2png(f2,'sb',[nan nan],'dim',2,'slicemm',[linspace(-1,0,20)],'showonly',1)

%% ==========================================================================================
%%  using pseudocolor for large dynamic ranges as in the Allen brain atlas (ABA)
%% ==========================================================================================
%% only pseudocolorized ABA with contour:
f1=fullfile(pwd,'ANO.nii');
slice2png({f1},'alpha',[0.5],'sb',[ 2 nan],'dim',2,'nslices',8,'showonly',1,'cbarvisible',[0 0],'contour',{1,{'color','k','linewidth',.1,'levels',5}},'pcolor',[1]);

%% AVGT with overlay of pseudocolorized ABA:
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'ANO.nii');
slice2png({f1,f2},'alpha',[1 .6 ],'sb',[ 2 nan],'dim',2,'nslices',8,'showonly',1,'cbarvisible',[0 0],'brighter',1,'pcolor',[2]);

%% AVGT with overlay of pseudocolorized ABA with contour:
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'ANO.nii');
slice2png({f1,f2},'alpha',[1 0.6],'sb',[ 2 nan],'dim',2,'nslices',8,'showonly',1,'cbarvisible',[0 0],'contour',{2,{'color','k','linewidth',.1,'levels',5}},'brighter',1,'pcolor',[2]);


%% ==========================================================================================
%%  overlay
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii')
f2=fullfile(pwd,'ANO.nii')
ff={f1;f2};
slice2png(ff,'clims',[nan nan; 0 1000],'dim',2);

%overlay, atlas is semitransparent, 1-column-layout, dim-2 is sliced, 5 slices, cbar of atlas is show, image is saved with 100DPI-resolution
slice2png(ff,'clims',[0 200; 0 1000],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cbarvisible',[0 1],'res',100)

%as above but displayed (not saved)
slice2png(ff,'clims',[0 200; 0 1000],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cbarvisible',[0 1],'showonly',1)

%automatic layout of 10 slices, with additional title and auto-message
slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'sb',[nan nan],'dim',2,'nslices',10,'cbarvisible',[1 1],'showonly',0,'title',{pwd},'titlefs',9,'msg',1,'show',1)

%as above but with specific message
slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'sb',[nan nan],'dim',2,'nslices',10,'cbarvisible',[1 1],'showonly',0,'title',{pwd},'titlefs',9,'msg',{'kohl','kopf'},'show',1)

%as above but with explitic name for PNG-file
slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'dim',2,'savename','dum.png')

% no transparency, black background, white text
slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'dim',2,'bgcol','k','fgcol','w','bgtransp',0)

% other colormap
slice2png(ff,'clims',[0 200; 0 1000],'alpha',[1 .5],'sb',[ 2 nan],'dim',2,'nslices',6,'cbarvisible',[0 1],'showonly',1,'cmap',{'gray','jet'})

%% ==========================================================================================
%%   DISPLAY MASKLESION IN  STANDARD SPACE
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'x_masklesion.nii');

slice2png({f1,f2},'showonly',1); %sagittal, only shown           
slice2png({f1,f2},'dim',2,'showonly',1); %coronar view

% with contout and specific cmpas---see getCMAP('showmaps');
slice2png({f1,f2},'dim',2,'showonly',1,'cmap',{'gray','isoFuchsia'},'contour',{2}); % other cmaps
% specific cmpas---see getCMAP('showmaps');
slice2png({f1,f2},'dim',2,'showonly',1,'cmap',{'gray','Greens'});     % other cmaps

% contour only with masklesion
slice2png({f1,f2},'dim',2,'showonly',1,'cmap',{'gray','isoFuchsia'},'contour',{2,{};1 {}},'alpha',[0 1]);


%% ==============================================
%%   add contour for masklesion
%% ===============================================
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'x_masklesion.nii');
%add contour for masklesion
slice2png({f1,f2},'dim',2,'showonly',1,'contour',{2}); %coronar view
%add red contour 
slice2png({f1,f2},'dim',2,'showonly',1,'contour',{2,{'color','r','linewidth',1}}); %coronar view


%% ==========================================================================================
%% 3 IMAGES: add mask-lesion contour on top of ANO
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'ANO.nii');
f3=fullfile(pwd,'x_masklesion.nii')

ff={f1;f2; f3};
slice2png(ff,'clims',[nan nan;nan 1000; nan nan],'alpha',[1 .6 .1],'sb',[ 3 nan],...
    'dim',2,'nslices',10,'cmap',{'gray', 'parula', 'isoFuchsia'},'showonly',1,...
    'cbarvisible',[0 0 0],'contour',{3,{'color','r','linewidth',1}})

%% ====[same in native space]===========================================
f1=fullfile(pwd,'t2.nii');
f2=fullfile(pwd,'ix_ANO.nii');
f3=fullfile(pwd,'masklesion.nii')

ff={f1;f2; f3};
slice2png(ff,'clims',[nan nan;nan 1000; nan nan],'alpha',[1 .6 .1],'sb',[ 3 nan],...
    'dim',1,'nslices',10,'cmap',{'gray', 'parula', 'isoFuchsia'},'showonly',1,...
    'cbarvisible',[0 0 0],'contour',{3,{'color','r','linewidth',1}},'brighter',10)


%% ====[AVGT as contour to check registration ]===========================================
f1=fullfile(pwd,'x_t2.nii');
f2=fullfile(pwd,'AVGT.nii');
slice2png({f1,f2},'alpha',[1 0 ],'sb',[ 2 nan],'dim',2,'nslices',8,'showonly',1,'cbarvisible',[0 0],'contour',{2,{'color','y','linewidth',.1,'levels',5}},'brighter',1);

%% ====[ANO as contour to check registration ]===========================================
f1=fullfile(pwd,'x_t2.nii');
f2=fullfile(pwd,'ANO.nii');
slice2png({f1,f2},'alpha',[1 0 ],'sb',[ 2 nan],'dim',2,'nslices',8,'showonly',1,'cbarvisible',[0 0],'contour',{2,{'color','y','linewidth',.1,'levels',5}},'brighter',1);


%% ====[gray matter  as contour ]===========================================
f1=fullfile(pwd,'t2.nii');
f2=fullfile(pwd,'c1t2.nii');
slice2png({f1,f2},'alpha',[1 0 ],'sb',[ 1 nan],'dim',1,'nslices',5,'showonly',1,'cbarvisible',[0 0],'contour',{1,{'color','y','linewidth',.1,'levels',3}},'brighter',1);


%% ====[gray matter as contour and masklesion]===========================================
f1=fullfile(pwd,'t2.nii');
f2=fullfile(pwd,'c1t2.nii');
f3=fullfile(pwd,'masklesion.nii')

ff={f1;f2; f3};
slice2png(ff,'alpha',[1 0 .2],'sb',[ 3 nan], 'dim',1,'nslices',10,'cmap',{'gray', 'parula', 'isoFuchsia'},'showonly',1, 'cbarvisible',[0 0 0],'contour',{2,{'color','y','linewidth',.1,'levels',1}},'brighter',1)


%% ====[gray and white matter as contour ]===========================================
f1=fullfile(pwd,'t2.nii');
f2=fullfile(pwd,'c1t2.nii');
f3=fullfile(pwd,'c2t2.nii');
ff={f1;f2; f3};
slice2png(ff,'alpha',[1 0 0],'sb',[ 3 nan], 'dim',1,'nslices',10,'showonly',1,'cbarvisible',[0 0 0],'contour',{2,{'color','y','linewidth',.1,'levels',1}; 3,{'color','r','linewidth',.1,'levels',1}},'brighter',1);

%% ==========================================================================================
%%    NATIVE SPACE
%% ==========================================================================================
 % using NIFTI in native space, assume no mask is available, using implicit mask via Otsu-method
 f1=fullfile(pwd,'t2.nii');
 f2=fullfile(pwd,'ix_ANO.nii');
 
 % less compact view because no implicit mask is used
 slice2png({f1 f2},'clims',[nan nan; 0 1000],'alpha',[1 .7],'sb',[4 nan],'dim',1,'nslices',16,'usemask',0,'bgtransp',1,'usemaskotsu',0)
 
 % more compact view because implicit mask is used
 slice2png({f1 f2},'clims',[nan nan; 0 1000],'alpha',[1 .7],'sb',[4 nan],'dim',1,'nslices',16,'usemask',0,'bgtransp',1)
 
 
 %% -  --plot tissue compartments
 f1=fullfile(pwd,'t2.nii');
f2=fullfile(pwd,'c1t2.nii');
f3=fullfile(pwd,'c2t2.nii');
f4=fullfile(pwd,'c3t2.nii');
ff={f1;f2;f3;f4};
slice2png(ff,'clims',[nan nan],'showonly',1,'dim',1,'cmap',{'gray','isoRed','isoBlue','isoGreen'},'alpha',[1 .3 .3 .3],'cbarvisible',[0 0 0 0])
%same but with increaded brightness
slice2png(ff,'clims',[nan nan],'showonly',1,'dim',1,'cmap',{'gray','isoRed','isoBlue','isoGreen'},'alpha',[1 .3 .3 .3],'cbarvisible',[0 0 0 0],'brighter',10)



 %% ==========================================================================================
 %% overlay with Jacobian
 %% ==========================================================================================

f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'JD.nii');
ff={f1;f2};

%overlay, JD is semitransparent, 1-column-layout, dim-2 is sliced,5 slices, only shown (not saved) 
slice2png(ff,'clims',[0 200; 0.5 1.5],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','jet'},'showonly',1)

%as above, but for JD only values above 1.0 are shown (see thresh)
slice2png(ff,'clims',[0 200; 0.5 1.5],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','jet'},'showonly',1,'thresh',[nan nan; 1 nan])

%as above, but for JD only values below 0.5 are shown (see thresh)
slice2png(ff,'clims',[0 200; 0.5 1.5],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','jet'},'showonly',1,'thresh',[nan nan; nan 0.5])

%as above, but for JD only values in the range 0.8 and 1.2 are shown (see thresh)
slice2png(ff,'clims',[0 200; 0.5 1.5],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','jet'},'showonly',1,'thresh',[nan nan; 0.8 1.2])

%% ==========================================================================================
%% USING 2 IMAGES: THRESHOLD INTENSITY MAPS
%% ==========================================================================================
%  for JD only values above 1.0 are shown (see thresh)
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'JD.nii');
ff={f1;f2};
slice2png(ff,'clims',[0 200; 0.5 1.5],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','hot'},'showonly',1,'thresh',[nan nan; 1 nan])

%% ===============================================
%% USING 3 IMAGES: THRESHOLD INTENSITY MAPS  (as a workaround we use 'JD.nii' twice)
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'JD.nii');
ff={f1;f2; f2};
slice2png(ff,'clims',[0 200; 0.5 1.5; 0.5 1.5],'alpha',[1 .5 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','hot', 'cool'},'showonly',1,'thresh',[nan nan; 1 nan; nan 0.5])

%as above but here we use the same 'clims' as for the 'thresh'
slice2png(ff,'clims',[0 200; 1 nan; nan 0.5],'alpha',[1 .5 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','hot', 'winter'},'showonly',1,'thresh',[nan nan; 1 nan; nan 0.5])


%% ==========================================================================================
%% USING 3 IMAGES: THRESHOLD INTENSITY MAP 
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'x_masklesion.nii')
f3=fullfile(pwd,'JD.nii');
ff={f1;f2; f3};
slice2png(ff,'clims',[0 200;nan nan; 0.5 1.5],'alpha',[1 .5 .5],'sb',[ 2 nan],'dim',2,'nslices',6,'cmap',{'gray','isoLime', 'RdYlBu_flip'},'showonly',1)

% save with black background
slice2png(ff,'clims',[0 200;nan nan; 0.5 1.5],'alpha',[1 .5 .5],'sb',[ 2 nan],'dim',2,'nslices',6,'cmap',{'gray','isoLime', 'RdYlBu_flip'},'showonly',0,'bgcol','k','bgtransp',0)



%% ==========================================================================================
%% USING 4 IMAGES: THRESHOLD INTENSITY MAPS  (as a workaround we use 'JD.nii' 2 times)
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'x_masklesion.nii')
f3=fullfile(pwd,'JD.nii');
ff={f1;f2; f3; f3};
slice2png(ff,'clims',[nan nan;nan nan; 1 nan; nan 0.5],'alpha',[1 .5 .5 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray', 'isoLime','Oranges', 'Blues_flip'},'showonly',1,'thresh',[nan nan;nan nan; 1 nan; nan 0.5])

% show specific colorbars only
slice2png(ff,'clims',[nan nan;nan nan; 1 nan; nan 0.5],'alpha',[1 .5 .5 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray', 'isoLime','Oranges', 'Blues_flip'},'showonly',1,'thresh',[nan nan;nan nan; 1 nan; nan 0.5],'cbarvisible',[0 0 1 1])

% other cmaps
slice2png(ff,'clims',[nan nan;nan nan; 1 nan; nan 0.5],'alpha',[1 .5 .5 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray', 'isoLime','isoRed', 'isoBlue'},'showonly',1,'thresh',[nan nan;nan nan; 1 nan; nan 0.5],'cbarvisible',[0 0 1 1])


%% ==========================================================================================
%%  overlay atlas  and color specic IDs
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii')
f2=fullfile(pwd,'ANO.nii')
ff={f1;f2};
slice2png(ff,'clims',[nan nan; 0 1000],'dim',2);

%overlay, atlas is semitransparent, 1-column-layout, dim-2 is sliced, 5 slices, cbar of atlas is show, image is saved with 100DPI-resolution
slice2png(ff,'clims',[0 200],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cbarvisible',[0 1],'res',100,'keepvalue',{2,[ 672   ]} ,'showonly',1,'cmap',{'gray','isoRed'})

% more ids
slice2png(ff,'clims',[0 200],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cbarvisible',[0 1],'res',100,'keepvalue',{2,[ 201 672 500 733 1047 1070  ]},'showonly',1,'cmap',{'gray','jet'})

%% ==========================================================================================
%%  overlay atlas  and color specic IDs  with specific colors
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii')
f2=fullfile(pwd,'ANO.nii')
ff={f1;f2;f2;f2};

keepvalue={2,[672 500 733] ;...
    3 [ 1047 ]; ....
    4,[  1020  ]}
slice2png(ff,'clims',[0 200],'alpha',[1 .5 .5 .5 ],'sb',[ 2 nan],'dim',2,'nslices',10,'cbarvisible',[0 1],'keepvalue',keepvalue,'showonly',1,'cmap',{'gray','isoRed'  'isoBlue' 'isoYellow'})


%adjustment of colorbar
keepvalue={2,[672] ;...
    3 [ 1047 ]; ....
    4,[  1020  ]}
slice2png(ff,'clims',[0 200],'alpha',[1 .5 .5 .5 ],'sb',[ 2 nan],'dim',2,'nslices',10,'cbarvisible',[0 1],'keepvalue',keepvalue,'showonly',1,'cmap',{'gray','isoRed'  'isoBlue' 'isoYellow'},'cbarpos',[nan nan 0.02 .02])

%% ==========================================================================================
%%  show left or right hemisphere only
%% ==========================================================================================
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'ANO.nii');
f3=fullfile(pwd,'x_masklesion.nii')
mask=fullfile(pwd,'AVGThemi.nii');
ff={f1;f2; f3};

% left hemisphere
slice2png(ff,'clims',[nan nan;nan 1000; nan nan],'alpha',[1 .6 .1],'sb',[ 3 nan],...
    'dim',2,'nslices',10,'cmap',{'gray', 'parula', 'isoFuchsia'},'showonly',1,...
    'cbarvisible',[0 0 0],'contour',{3,{'color','r','linewidth',1}},'mask',mask,'maskvalue',1);
% right hemisphere
slice2png(ff,'clims',[nan nan;nan 1000; nan nan],'alpha',[1 .6 .1],'sb',[ 3 nan],...
    'dim',2,'nslices',10,'cmap',{'gray', 'parula', 'isoFuchsia'},'showonly',1,...
    'cbarvisible',[0 0 0],'contour',{3,{'color','r','linewidth',1}},'mask',mask,'maskvalue',2);

% ==============================================
%%   show first 400 regions of the ABA-atlas 
% ===============================================
f1=fullfile(pwd,'AVGT.nii');
f2=fullfile(pwd,'ANO.nii');
mask=fullfile(pwd,'ANO.nii');
ff={f1;f2};
slice2png(ff,'clims',[nan nan;nan 1000],'alpha',[1 0],'sb',[ 4 nan],...
    'dim',2,'nslices',20,'cmap',{'gray', 'parula'},'showonly',1,...
    'cbarvisible',[0 0],'mask',mask,'maskvalue',[ 1:1400 ]);








%% #################################################
% powerpoint
% make global PPT with images from animal-folders

%% ==============================================
%%  1) make global PPT with images from animal-folders
%% ===============================================
mdirs=antcb('getsubjects');
paout =pwd;
pptfile =fullfile(paout,'chimaps.pptx');
for j=1:length(mdirs)
    pam   =mdirs{j};
    [~,animal]=fileparts(pam);
    titlem  =['chimaps: ' animal ];
    [pngs]   = spm_select('FPList',pam,'^chimap_.*.png');    pngs=cellstr(pngs);
    tx=[ ['ANIMAL: '  pam ]; pngs];
    if j==1; doc='new'; else; doc='add'; end
    img2ppt(paout,pngs, pptfile,'size','A4l','doc',doc,...
        'crop',0,'gap',[0 0 ],'columns',1,'xy',[0 1 ],'wh',[ 25 5.9],...
        'title',titlem,'Tha','center','Tfs',20,'Tcol',[0 0 0],'Tbgcol',[0.3 0.74 0.93],...
        'text',tx,'tfs',8,'txy',[0 19],'tbgcol',[1 1 1],'disp',0);  
end
showinfo2(['pptfile'],pptfile);
%% #################################################
% powerpoint
% make PPT with multiple images on several ppt-slides
paout   =pwd;
paimg   =fullfile(pwd,'barplot_img');
pptfile =fullfile(paout,'barplot.pptx');
titlem  =['barplots'  ];
[fis]   = spm_select('FPList',paimg,'^bar.*.png');    fis=cellstr(fis);
tx      ={['path: '  paimg ]};

nimg_per_page  =6;           %number of images per plot
imgIDXpage     =unique([1:nimg_per_page:length(fis) length(fis)+1 ]);
for i=1:length(imgIDXpage)-1
    if i==1; doc='new'; else; doc='add'; end
    img_perslice=fis([imgIDXpage(i):imgIDXpage(i+1)-1]);
    img2ppt(paout,img_perslice, pptfile,'size','A4','doc',doc,...
        'crop',0,'gap',[0 0 ],'columns',2,'xy',[0 1.5 ],'wh',[ 10.5 nan],...
        'title',titlem,'Tha','center','Tfs',10,'Tcol',[1 1 1],'Tbgcol',[1 .8 0],...
        'text',tx,'tfs',6,'txy',[0 28],'tbgcol',[1 1 1]);
end






%% #################################################
% mricron
% display volumes in mricron

% show single volume in mricron
rmricron([], fullfile('F:\data8\2024_Stefanie_ORC1_24h_postMCAO\templates','AVGT.nii'))


% show overlay (gray-matter onto AVGT) 
pa='F:\data8\2024_Stefanie_ORC1_24h_postMCAO\templates';
f1=fullfile(pa,'AVGT.nii');
f2=fullfile(pa,'_b1grey.nii');
rmricron([], f1,f2,'actc');

%% #################################################
% mricron 
% splot-slices coronal

z=[];
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image
                     'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
                     'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };
z.view           = 'coronal';                                                                      % % view: {coronal/sagittal/axial}
z.slices         = [80  95  110  125  140  155  170  185  200];                                    % % slices to plot
z.bg_clim        = [0  200];                                                                       % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap
z.ovl_clim       = [0  50];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
z.opacity        = [50];                                                                           % % opacity: -1,0,20,40,50,60,80,100. A value of -1 signifies additive color blending
z.orthoview      = [1];                                                                            % % show orthogonal plot where brain is sliced; {0|1}
z.slicelabel     = [1];                                                                            % % add slice label  (rounded mm); {0|1}
z.OverslicePct   = [0];                                                                            % % percent overlapp slices
z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label
z.cbar_fs        = [12];                                                                           % % colorbar: fonsize
z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color
z.outdir         = fullfile(pwd,'slice1');                                                         % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
z.ppt_filename   = 'lesion33';                                                                     % % PPT-filename
z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
z.closeMricron   = [1];                                                                            % % close mricron afterwards
xplotslices_mricron(0,z);
  
%% #################################################
% mricron 
% splot-8 slices ov ANO-atlas, coronal
pa_study='F:\data8\2024_Stefanie_ORC1_24h_postMCAO'
pa_temp =fullfile(pa_study,'templates')
F1=fullfile(pa_temp,'AVGT.nii')
F2=fullfile(pa_temp,'ANO.nii')
z=[];
z.bg_image       = F1;                        % % background image, if empty, than "AVGT.nii" from template-folder is used
z.ovl_images     = F2       % % get one/more images to separately overlay onto bg_image
z.view           = 'coronal';                 % % view: {coronal/sagittal/axial}
z.slices         = ['n8'];                     % % slices to plot
z.bg_clim        = [0  200];                  % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
z.ovl_cmap       = 'actc.lut';                % % overlay-image: colormap
z.ovl_clim       = [0  1000];                 % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
z.opacity        = [50];                      % % opacity: -1,0,20,40,50,60,80,100. A value of -1 signifies additive color blending
z.orthoview      = [1];                       % % show orthogonal plot where brain is sliced; {0|1}
z.slicelabel     = [1];                       % % add slice label  (rounded mm); {0|1}
z.OverslicePct   = [0];                       % % percent overlapp slices
z.cbar_label     = 'ID';                      % % colorbar: label, if empty cbar has no label
z.cbar_fs        = [12];                            % % colorbar: fonsize
z.cbar_fcol      = [1  1  1];                       % % colorbar: fontcolor a color
z.outdir         = fullfile(pa_study,'__test1');    % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
z.ppt_filename   = 'ANO';                           % % PPT-filename
z.plotdir_suffix = '_plots';                        % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
z.closeMricron   = [1];                             % % close mricron afterwards
xplotslices_mricron(0,z);

%% #################################################
% mricroGL-sliceplots
% using mricroGL to save slices

%% EXAMPLE: coronal ===============================================

z=[];
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                    % % background image, if empty, than "AVGT.nii" from template-folder is used
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'
                     'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
                     'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };      % % get one/more images to separately overlay onto bg_image
z.view           = [2];                                                                             % % view: [1]sagittal; [2]coronal;[3]axial
z.slices         = 'cutR50n6';                                                 % % slices to plot
z.bg_clim        = [50  200];                                                                        % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
z.ovl_cmap       = 'actc.lut';                                                                      % % overlay-image: colormap
z.ovl_clim       = [0  100];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
z.opacity        = [70];                                                                            % % overlay opacity range: 0-100
z.slicelabel     = [0];                                                                             % % add slice label  (rounded mm); {0|1}
z.nrows          = [1];                                                                             % % number of rows to plot; default: 1
z.sliceOverlapp  = [0];                                                                             % % slice overlapp horizontally (left-right)
z.rowOverlapp    = [0];                                                                             % % rows overlapp (vertical overlap of rows)
z.cbar_label     = 'lesion [%]';                                                                    % % colorbar: label, if empty cbar has no label
z.cbar_fs        = [12];                                                                            % % colorbar: fonsize
z.cbar_fontname  = 'Helvetica';                                                                     % % fontName example: arial/consolas/Helvetica
z.cbar_fcol      = [1  1  1];                                                                       % % colorbar: fontcolor a color
z.sliceplot      = [1];                                                                             % % show orthogonal plot where brain is sliced; {0|1}
z.sliceplotDir   = [-1];                                                                             % % change direction of sliceplot
z.sliceplotDim   = [1];                                                                             % % dimension of the orthogonal sliceplot
z.linewidth      = [1];                                                                             % % linewidht of slices
z.linecolor      = [1  1  1];                                                                       % % line color of clices
z.outdir         = '';                                                                              % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
z.ppt_filename   = 'lesion_view2';                                                                        % % PPT-filename
z.plotdir_suffix = '_plots';                                                                        % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
z.closeMricroGL  = [1];                                                                             % % close MricroGl afterwards
z.makePPT        = [1];                                                                             % % make powerpoint with image and infos
xplotslices_mricrogl(0,z);


%% EXAMPLE: sagittal ===============================================
z=[];
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                    % % background image, if empty, than "AVGT.nii" from template-folder is used
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'
    'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
    'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };      % % get one/more images to separately overlay onto bg_image
z.view           = [2];                                                                             % % view: [1]sagittal; [2]coronal;[3]axial
z.slices         = 'cutR50n6';                                                 % % slices to plot
z.bg_clim        = [50  200];                                                                        % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
z.ovl_cmap       = 'actc.lut';                                                                      % % overlay-image: colormap
z.ovl_clim       = [0  100];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
z.opacity        = [70];                                                                            % % overlay opacity range: 0-100
z.slicelabel     = [0];                                                                             % % add slice label  (rounded mm); {0|1}
z.nrows          = [1];                                                                             % % number of rows to plot; default: 1
z.sliceOverlapp  = [0];                                                                             % % slice overlapp horizontally (left-right)
z.rowOverlapp    = [0];                                                                             % % rows overlapp (vertical overlap of rows)
z.cbar_label     = 'lesion [%]';                                                                    % % colorbar: label, if empty cbar has no label
z.cbar_fs        = [12];                                                                            % % colorbar: fonsize
z.cbar_fontname  = 'Helvetica';                                                                     % % fontName example: arial/consolas/Helvetica
z.cbar_fcol      = [1  1  1];                                                                       % % colorbar: fontcolor a color
z.sliceplot      = [1];                                                                             % % show orthogonal plot where brain is sliced; {0|1}
z.sliceplotDir   = [-1];                                                                             % % change direction of sliceplot
z.sliceplotDim   = [1];                                                                             % % dimension of the orthogonal sliceplot
z.linewidth      = [1];                                                                             % % linewidht of slices
z.linecolor      = [1  1  1];                                                                       % % line color of clices
z.outdir         = '';                                                                              % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
z.ppt_filename   = 'lesion_view2';                                                                        % % PPT-filename
z.plotdir_suffix = '_plots';                                                                        % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
z.closeMricroGL  = [1];                                                                             % % close MricroGl afterwards
z.makePPT        = [1];                                                                             % % make powerpoint with image and infos
xplotslices_mricrogl(0,z);
%
%% EXAMPLE: axial ===============================================
z=[];
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                    % % background image, if empty, than "AVGT.nii" from template-folder is used
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'
    'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'
    'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };      % % get one/more images to separately overlay onto bg_image
z.view           = [3];                                                                             % % view: [1]sagittal; [2]coronal;[3]axial
z.slices         = 'cut50n8';                                                 % % slices to plot
z.bg_clim        = [50  200];                                                                        % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
z.ovl_cmap       = 'actc.lut';                                                                      % % overlay-image: colormap
z.ovl_clim       = [0  100];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
z.opacity        = [70];                                                                            % % overlay opacity range: 0-100
z.slicelabel     = [0];                                                                             % % add slice label  (rounded mm); {0|1}
z.nrows          = [1];                                                                             % % number of rows to plot; default: 1
z.sliceOverlapp  = [0];                                                                             % % slice overlapp horizontally (left-right)
z.rowOverlapp    = [0];                                                                             % % rows overlapp (vertical overlap of rows)
z.cbar_label     = 'lesion [%]';                                                                    % % colorbar: label, if empty cbar has no label
z.cbar_fs        = [12];                                                                            % % colorbar: fonsize
z.cbar_fontname  = 'Helvetica';                                                                     % % fontName example: arial/consolas/Helvetica
z.cbar_fcol      = [1  1  1];                                                                       % % colorbar: fontcolor a color
z.sliceplot      = [1];                                                                             % % show orthogonal plot where brain is sliced; {0|1}
z.sliceplotDir   = [-1];                                                                             % % change direction of sliceplot
z.sliceplotDim   = [1];                                                                             % % dimension of the orthogonal sliceplot
z.linewidth      = [1];                                                                             % % linewidht of slices
z.linecolor      = [1  1  1];                                                                       % % line color of clices
z.outdir         = '';                                                                              % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images
z.ppt_filename   = 'lesion_view3';                                                                        % % PPT-filename
z.plotdir_suffix = '_plots';                                                                        % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"
z.closeMricroGL  = [1];                                                                             % % close MricroGl afterwards
z.makePPT        = [1];                                                                             % % make powerpoint with image and infos
xplotslices_mricrogl(0,z);

%% #################################################
% mricroGL-orthoview/plots
% using mricroGL to save orthoview-plots
% EXAMPLE: overlay each of the images in z.ovl_images separatly, put crosshair coordinaes 'z.xyzmm'
% make images & powerpoint
%% ====================================================================================
% EXAMPLE-1: overlay each of the images in z.ovl_images separatly, put crosshair coordinaes 'z.xyzmm'
% make images & powerpoint, force single-row
%% ====================================================================================
z=[];                                                                                                                                                                                                      
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used                            
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image                                             
                     'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };                                                                                                             
z.bg_clim        = [50  200];                                                                      % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                   
z.ovl_clim       = [0  100];                                                                       % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                      
z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap                                                                             
z.opacity        = [70];                                                                           % % overlay opacity range: 0-100                                                                        
z.linewidth      = [5];                                                                            % % crosshairs-linewidht                                                                                
z.linecolor      = [1  1  1];                                                                      % % crosshairs-color                                                                                    
z.xyzmm          = [1 -6 -2 ; -0.5 -0.5 -0.5  ];                                                   % % xyz-coordinates in mm (nx3-matrix)                                                                                                                                                                                                                               
z.png_SingleRow  = [1];                                                                            % % force all views into one row; {0|1}                                                                 
z.png_views      = [1  2  3];                                                                      % % views to keep; default:[1 2 3] which is coronal,sagittal, axial ; {[1 2 3]|[1 2]|[1 3]|[2 3]}       
z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label                                                         
z.cbar_fs        = [12];                                                                           % % colorbar: fonsize                                                                                   
z.cbar_fontname  = 'Helvetica';                                                                    % % fontName example: arial/consolas/Helvetica                                                          
z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color                                                                         
z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images                                    
z.ppt_filename   = 'ortho2';                                                                       % % PPT-filename                                                                                        
z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix" 
z.makePPT        = [1];                                                                            % % make powerpoint with image and infos                                                                
z.sort           = 'coordinate';                                                                    % % png-images in powerpoint is sorted after  {coordinate|image}                                         
z.closeMricroGL  = [1];                                                                            % % close MricroGl afterwards                                                                           
z.mricroGL       = '';                                                                             % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)              
xplotortho_mricrogl(0,z);

%% ====================================================================================
% EXAMPLE-2: as before but use two rows (z.png_SingleRow=[0])
%% ====================================================================================
z=[];                                                                                                                                                                                                      
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used                            
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image                                             
                     'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };                                                                                                             
z.bg_clim        = [50  200];                                                                      % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                   
z.ovl_clim       = [0  100];                                                                       % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                      
z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap                                                                             
z.opacity        = [70];                                                                           % % overlay opacity range: 0-100                                                                        
z.linewidth      = [5];                                                                            % % crosshairs-linewidht                                                                                
z.linecolor      = [1  1  1];                                                                      % % crosshairs-color                                                                                    
z.xyzmm          = [1 -6 -2 ; -0.5 -0.5 -0.5  ];                                                   % % xyz-coordinates in mm (nx3-matrix)                                                                                                                                                                                                                                                                                                                                                                                      
z.png_SingleRow  = [0];                                                                            % % force all views into one row; {0|1}                                                                 
z.png_views      = [1  2  3];                                                                      % % views to keep; default:[1 2 3] which is coronal,sagittal, axial ; {[1 2 3]|[1 2]|[1 3]|[2 3]}       
z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label                                                         
z.cbar_fs        = [12];                                                                           % % colorbar: fonsize                                                                                   
z.cbar_fontname  = 'Helvetica';                                                                    % % fontName example: arial/consolas/Helvetica                                                          
z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color                                                                         
z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images                                    
z.ppt_filename   = 'ortho2';                                                                       % % PPT-filename                                                                                        
z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix" 
z.makePPT        = [1];                                                                            % % make powerpoint with image and infos                                                                
z.sort           = 'coordinate';                                                                    % % png-images in powerpoint is sorted after  {coordinate|image}                                         
z.closeMricroGL  = [1];                                                                            % % close MricroGl afterwards                                                                           
z.mricroGL       = '';                                                                             % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)              
xplotortho_mricrogl(0,z); 

%% ====================================================================================
% EXAMPLE-3: as EXAMPLE-2 but show create only coronar slices (z.png_views= [1];  )
%% ====================================================================================
z=[];                                                                                                                                                                                                      
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used                            
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image                                             
                     'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };                                                                                                             
z.bg_clim        = [50  200];                                                                      % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                   
z.ovl_clim       = [0  100];                                                                       % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                      
z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap                                                                             
z.opacity        = [70];                                                                           % % overlay opacity range: 0-100                                                                        
z.linewidth      = [5];                                                                            % % crosshairs-linewidht                                                                                
z.linecolor      = [1  1  1];                                                                      % % crosshairs-color                                                                                    
z.xyzmm          = [1 -6 -2 ; -0.5 -0.5 -0.5  ];                                                   % % xyz-coordinates in mm (nx3-matrix)                                                                                                                                                                                                                               
z.png_SingleRow  = [1];                                                                            % % force all views into one row; {0|1}                                                                 
z.png_views      = [1];                                                                            % % views to keep; default:[1 2 3] which is coronal,sagittal, axial ; {[1 2 3]|[1 2]|[1 3]|[2 3]}       
z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label                                                         
z.cbar_fs        = [12];                                                                           % % colorbar: fonsize                                                                                   
z.cbar_fontname  = 'Helvetica';                                                                    % % fontName example: arial/consolas/Helvetica                                                          
z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color                                                                         
z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images                                    
z.ppt_filename   = 'ortho2';                                                                       % % PPT-filename                                                                                        
z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix" 
z.makePPT        = [1];                                                                            % % make powerpoint with image and infos                                                                
z.sort           = 'coordinate';                                                                    % % png-images in powerpoint is sorted after  {coordinate|image}                                         
z.closeMricroGL  = [1];                                                                            % % close MricroGl afterwards                                                                           
z.mricroGL       = '';                                                                             % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)              
xplotortho_mricrogl(0,z); 

%% ============================================================
% EXAMPLE-4: plot ANO-atlas at specifix mm-coordinates
%% ============================================================
z=[];                                                                                                                                                                                      
z.bg_image       = 'F:\data8\mricron_makeSlices_plots\templates\AVGT.nii';        % % background image; if empty, "AVGT.nii" from the template folder is used                              
z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\templates\ANO.nii' };     % % overlay one or more images onto bg_image                                                             
z.bg_clim        = [50  200];                                                     % % background image intensity limits [min,max]; [nan nan] = auto                                        
z.ovl_clim       = [0  1000];                                                     % % overlay image intensity limits [min,max]; [nan nan] = auto                                           
z.ovl_cmap       = 'actc.clut';                                                   % % overlay colormap                                                                                     
z.opacity        = [50];                                                          % % overlay opacity (0-100)                                                                              
z.linewidth      = [5];                                                           % % crosshair line width                                                                                 
z.linecolor      = [1  1  1];                                                     % % crosshair color (RGB, range 0-1)                                                                     
z.xyzmm          = [0 -7 -4; 0 -4 -4 ; 0 -1 -2; 0 2 -2 ]                         % % XYZ coordinates in mm (n×3 matrix)                                                                                                                                                                                                          
z.png_SingleRow  = [1];                                                           % % force all views into one row; {0|1}                                                                  
z.png_views      = [1  2  3];                                                     % % views to keep; default: [1 2 3] (coronal, sagittal, axial)                                           
z.cbar_label     = 'atlas IDs';                                                   % % colorbar label; empty = no label                                                                     
z.cbar_fs        = [12];                                                          % % colorbar font size                                                                                   
z.cbar_fontname  = 'Helvetica';                                                   % % colorbar font name (e.g., Arial, Consolas, Helvetica)                                                
z.cbar_fcol      = [1  1  1];                                                     % % colorbar font color                                                                                  
z.outdir         = 'F:\data8\mricron_makeSlices_plots\results2';                % % output directory; if empty, plots/PPT are stored in "ovl_images" DIR                                 
z.ppt_filename   = 'ABA_atlas';                                                       % % PowerPoint filename                                                                                  
z.plotdir_suffix = '_plots';                                                      % % subdirectory for PNG files (in "outdir"), named as "ppt_filename" + "plotdir_suffix"                 
z.makePPT        = [1];                                                           % % create PowerPoint with images and info                                                               
z.sort           = 'coordinate';                                                  % % sort PNGs in PowerPoint by {coordinate|image}                                                        
z.closeMricroGL  = [1];                                                           % % close MRIcroGL after execution                                                                       
z.mricroGL       = '';                                                            % % <optional> specify full path to MRIcroGL exe/app if not auto-detected (SEE HELP)                     
xplotortho_mricrogl(0,z);  


%% #################################################
% orthoslice
% display volumes using orthoslice

  %% =============================================================
  %% display 3 images using orthoslice
  %% =============================================================
 files =  { 'F:\data8\ortoslice_tests\AVGT.nii' 	
      'F:\data8\ortoslice_tests\_b1grey.nii' 
      'F:\data8\ortoslice_tests\_b2white.nii' 	
      'F:\data8\ortoslice_tests\_b3csf.nii' };
  r=[];   
  r.ce=[-1 -1 -1.5]  ;%  center/cursor-location
  r.alpha       =  [0.5  0.5  0.5  0.7];  %transparency                                                                                                                                 
  r.axolperc    =  [7];   %overlapp ov axis in percent                                                                                                                                                  
  r.bgcol       =  '0.93725 0.86667 0.86667'; %background-color                                                                                                                             
  r.cbarvisible =  [0  1  1  1  1]; % colorbar-visibility                                                                                                                                       
  r.clim        =  [0     495.24 ;  0.7 1 ;0.7 1 ; 0.4  1 ];                                                                                                                                     
  r.cmap        =  { 'gray' 	'Oranges' 	'Greens' 	'@yellow' };  %colormaps                                                                                                           
  r.cursorcol   =  [1 1 1 ]; %cursor-color                                                                                                                                                
  r.cursorwidth =  [1];    %cursor-width                                                                                                                                                  
  r.figwidth    =  [780];  %figure width in pixels                                                                                                                                                
  r.mbarlabel   =  { '' 	'GM' 	'WM' 	'csf' };  %cbar-labels 
  r.labelcol    =  [1 0 1]; %cbar-color
  r.mcbarfs     =  [11];      %cbar-fontsize                                                                                                                                             
  r.mcbarpos    =  [-70  20  10  100];   % last c-bar-location relativ to right-fig-size (pixels)                                                                                                                                  
  r.visible     =  [1  1  1  1]; %bg/overlay-images-visible                                                                                                                                          
  orthoslice(files,r);
  
  %% =============================================================
  %% display 3 images using orthoslice  from current study
  %% =============================================================
  global an
  pa_study=fileparts(an.datpath)
  pa_temp=fullfile(pa_study,'templates')
 files =  { fullfile(pa_temp,'AVGT.nii'    )	
            fullfile(pa_temp,'_b1grey.nii' )
            fullfile(pa_temp,'_b2white.nii')	
            fullfile(pa_temp,'_b3csf.nii'  ) };
  r=[];   
  r.ce=[-1 -1 -1.5]  ;%  center/cursor-location
  r.alpha       =  [0.5  0.5  0.5  0.7];  %transparency                                                                                                                                 
  r.axolperc    =  [7];   %overlapp ov axis in percent                                                                                                                                                  
  r.bgcol       =  '0.93725 0.86667 0.86667'; %background-color                                                                                                                             
  r.cbarvisible =  [0  1  1  1  1]; % colorbar-visibility                                                                                                                                       
  r.clim        =  [0     495.24 ;  0.7 1 ;0.7 1 ; 0.4  1 ];                                                                                                                                     
  r.cmap        =  { 'gray' 	'Oranges' 	'Greens' 	'@yellow' };  %colormaps                                                                                                           
  r.cursorcol   =  [1 1 1 ]; %cursor-color                                                                                                                                                
  r.cursorwidth =  [1];    %cursor-width                                                                                                                                                  
  r.figwidth    =  [780];  %figure width in pixels                                                                                                                                                
  r.mbarlabel   =  { '' 	'GM' 	'WM' 	'csf' };  %cbar-labels 
  r.labelcol    =  [1 0 1]; %cbar-color
  r.mcbarfs     =  [11];      %cbar-fontsize                                                                                                                                             
  r.mcbarpos    =  [-70  20  10  100];   % last c-bar-location relativ to right-fig-size (pixels)                                                                                                                                  
  r.visible     =  [1  1  1  1]; %bg/overlay-images-visible                                                                                                                                          
  orthoslice(files,r)
  
%% #################################################
% mricroGL-colorize brain region from atlas
% save as  png, create ppt-file

%% =============================================================
%% EXAMPLE-1: ANTx-projext is already loaded: no need to specify 'bg_image','bg_mask' and 'atlas_image', because
%% the study's template files are used : 'AVGT.nii', 'AVGTmask.nii' and 'ANO.nii'  
%% For regions specified in 'regions' create PNG-files and a PPT-file,region-color is red
%% =============================================================
    z=[];                                                                                                                                                                                                                                   
    z.bg_image     = '';                    % % background image, if empty, "AVGT.nii" from template-folder is used                                                                                
    z.bg_mask      = '';                    % % image mask, if empty, "AVGTmask.nii" from template-folder is used                                                                                  
    z.atlas_image  = '';                    % % atlas (NIFTI), if empty, "ANO.nii" from template-folder is used                                                                                    
    z.regions      = { 'L_Prelimbic area'   % % enter regons or select regionfile (Excelfile with regions,1st column) or select regions from Atlas (Excelfile such as "ANO.xlsx")                  
                       'R_Prelimbic area' 
                       'L_Orbital area' 
                       'Caudoputamen'};                                                                                                                                                                                                  
    z.bg_clim      = [50  200];             % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                                                                  
    z.ovl_cmap     = '1red.clut';           % % overlay-image: colormap                                                                                                                            
    z.ovl_clim     = [0  1];                % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                                                                     
    z.opacity      = [30];                  % % overlay opacity range: 0-100                                                                                                                       
    z.linewidth    = [5];                   % % linewidth of slice cutting line                                                                                                                    
    z.linecolor    = [0  0  0];             % % line color of slice cutting line                                                                                                                   
    z.outdir       = '';                    % % output-dir, if empty plots/ppt-file in current directory                                                                                           
    z.subdir       = 'test5';               % % subdir in outdir, contains created png-files, can be <empty>                                                                                       
    z.ppt_filename = 'regions';             % % PPT-filename                                                                                                                                       
    z.cleanup      = [1];                   % % remove temporarily created NIFTIs,{0|1}                                                                                                            
    z.makePPT      = [1];                   % % make Powerpoint-file with image and infos, {0|1}                                                                                                   
    z.mricroGL     = '';                    % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)                                                             
    xcolorregion_mricrogl(0,z);
%% =============================================================
%% EXAMPLE-2: ANTx-projext is already loaded, SHORTEST VERSION
% Antx-project must be loaded before, create colored regions using default parameter
% output (png-images and pptfile) is saved in <study>\results\regioncolorized
% using default AVGT.nii, AVGTmask and ANO.nii from template folder
% Although not explicitely occuring in the corresponding region-file 'ANO.xlsx', we can separately display the
% left and right hemispheric regions when adding the prefix 'L_' and 'R_' in the region-names (example:
% 'L_Primary motor area' or 'R_Primary motor area')
%% =============================================================    
    z=[];
    z.regions= {...
        'L_Primary motor area'        % % enter regons or select regionfile (Excelfile with regions,1st column) or select regions from Atlas (Excelfile such as "ANO.xlsx")
        'R_Primary motor area'
        'Primary motor area'
        'L_Caudoputamen'
        'R_Caudoputamen'
        'Caudoputamen'
        };                                                                                                                                                                            % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)
    xcolorregion_mricrogl(0,z);

  
%% =============================================================
%% EXAMPLE-3: independent from loaded ANTx-project 
%% =============================================================
    pastudy='F:\data8\sarah\sarah_plots_26jan24';
    z=[];
    z.bg_image     = fullfile(pastudy,'templates','AVGT.nii');        % % background image, if empty, "AVGT.nii" from template-folder is used
    z.bg_mask      = fullfile(pastudy,'templates','AVGTmask.nii');    % % image mask, if empty, "AVGTmask.nii" from template-folder is used
    z.atlas_image  = fullfile(pastudy,'templates','ANO.nii');         % % atlas (NIFTI), if empty, "ANO.nii" from template-folder is used
    z.regions      = {'Caudoputamen' 'L_Primary motor area'}          % % enter regons or select regionfile (Excelfile with regions,1st column) or select regions from Atlas (Excelfile such as "ANO.xlsx")
    z.bg_clim      = [NaN  NaN];                                      % % background-image: intensity limits [min,max], if [nan nan]..automatically defined
    z.ovl_cmap     = '3blue.clut';                                    % % overlay-image: colormap
    z.ovl_clim     = [NaN  NaN];                                      % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
    z.opacity      = [40];                                            % % overlay opacity range: 0-100
    z.linewidth    = [1];                                             % % linewidth of slice cutting line
    z.linecolor    = [0  0  0];                                       % % line color of slice cutting line
    z.outdir       = fullfile(pastudy,'results','___colRegsTest')     % % output-dir, if empty plots/ppt-file in current directory
    z.subdir       = '';                                              % % subdir in outdir, contains created png-files, can be <empty>
    z.ppt_filename = 'test2';                                         % % PPT-filename
    z.cleanup      = [1];                                             % % remove temporarily created NIFTIs,{0|1}
    z.makePPT      = [1];                                             % % make Powerpoint-file with image and infos, {0|1}
    z.mricroGL     = '';                                              % % <optional> specify fullpath name of MRicroGL-exe/app if not otherwise found (SEE HELP)
    xcolorregion_mricrogl(0,z);

%% #################################################
% mricroGL-diverse
% run mricrogl-script (explicit mricrogl-path)
system(['"C:\paulprogramme\MRIcroGL\MRIcroGL.exe" "F:\data9\susanne_imghdr\my_xt2_nosaveBPM.py" &'])

% run mricrogl-script (automatically obtain mricrogl-path)
system(['"' xplotslices_mricrogl('path_mricrogl') '" "F:\data9\susanne_imghdr\my_xt2_nosaveBPM.py" &'])


% ==============================================
%%  overlay mask onto BG-image, and rotate 
% ===============================================
F1='F:\data9\susanne_imghdr\20250313MO_SCI_Ko01_sag.nii'  ;%BG-image
F2='F:\data9\susanne_imghdr\mask.nii'                     ;%FG-image
cm={
 'import gl'
 'gl.resetdefaults()'
 'gl.scriptformvisible(0)'
 'ktime= 60'
 'ksteps= 72'
 'gl.resetdefaults()'
 ['gl.loadimage('''     strrep(F1,filesep,[filesep filesep]) ''')']
 ['gl.overlayload('''   strrep(F2,filesep,[filesep filesep]) ''')']
 'gl.minmax(0, 0.5,2.6)'
 'gl.minmax(1, 0, 2)'
 'gl.opacity(1,90)'
 'gl.colorname(1,''actc'')'
 'gl.colorbarposition(0)'
 'gl.backcolor(255,255,255)'
 '#gl.cameradistance(1)'
 'for x in range(1, ksteps):'
 '  #gl.azimuthelevation(160+(x*5),30)'
 '  gl.azimuthelevation(90,120+(x*5))'
 '  gl.wait(ktime)'
 '#adjust color scheme to show kidneys'
 'gl.colorname(0,''bone'')'
 'gl.shadername(''Tomography'')'
 '#gl.shaderadjust(''brighten'', 1.2)'
 'for x in range(1, ksteps):'
 '  gl.azimuthelevation(160+(x*5),30)'
 '  gl.wait(ktime)'
 'gl.scriptformvisible(1)'
};
cm2=strjoin(cm,'^');
exefile=xplotslices_mricrogl('path_mricrogl')
cmd=(['"' exefile '"' ' -s "' cm2 '" &']);
system(cmd );

%% #################################################
% mricroGL-diverse
% make animated GIF using mricroGL
%% ===============================================

F1    ='F:\data9\susanne_imghdr\20250313MO_SCI_Ko01_sag.nii'; %BG-image
F2    ='F:\data9\susanne_imghdr\mask.nii'                   ; %FG-image
rotations=[1 1]; %[pitch yaw]-rotation,  each{0|1}; [1 1]:pitch&yaw rotation; [1 0]:pitch only; [0 1]:yaw only 
ktime = 60; %pause between rotations [ms]
ksteps= 10; %rotational steps
outdir='F:\data9\susanne_imghdr\img4';  %PATH WERE IMAGES ARE STORED (used to created animGIF)
dosave    =1;  %save BMP {0|1}; [0]: no PNG-files created & no animGIF created
outputGIF = fullfile('F:\data9\susanne_imghdr', 'rotation_movie4.gif'); %animGIF: filename
delayTime = 0.2;  %animGIF: seconds between frames (e.g., 0.1 = 10 fps)
% ===============================================
cm={
 ['ktime=  ' num2str(ktime)]
 ['ksteps= ' num2str(ksteps)]
 ['dosave='  num2str(dosave)]
 ['output_folder = ''' strrep(outdir,filesep,[filesep filesep])  '''']
 ['rotations = [' num2str(rotations(1)) ',' num2str(rotations(2)) ']']
 'import gl'
 'import os'
 'import glob'
 'gl.resetdefaults()'
 'gl.scriptformvisible(0)'
 ['gl.loadimage('''     strrep(F1,filesep,[filesep filesep]) ''')']
 ['gl.overlayload('''   strrep(F2,filesep,[filesep filesep]) ''')']
 'gl.minmax(0, 0.5,2.6)'
 'gl.minmax(1, 0, 2)'
 'gl.opacity(1,90)'
 'gl.colorname(1,''actc'')'
 'gl.colorbarposition(0)'
 'gl.backcolor(255,255,255)'
 'if not os.path.exists(output_folder):'
 '    os.makedirs(output_folder)'
 'else:'
 '    if dosave==1:'
 '    	[os.remove(f) for f in glob.glob(output_folder+''\\/*.png'')]'
 'x=0'
 'if rotations[0] == 1:'
 '   for x in range(1, ksteps):'
 '       gl.azimuthelevation(90,120+(x*5))'
 '       gl.wait(ktime)'
 '       if dosave==1:'
 '          gl.savebmp(output_folder+''\\''+str(x)+''.png'')'
 ''
 'if rotations[1] == 1:'
 '   for y in range(1, ksteps):'
 '       gl.azimuthelevation(160+(y*5),30)'
 '       gl.wait(ktime)'
 '       if dosave==1:'
 '          gl.savebmp(output_folder+''\\''+str(x+y)+''.png'')'
 ''
 'gl.scriptformvisible(1)'
 'gl.wait(2000)'
 'gl.quit()' 
};
cm2=strjoin(cm,'^');
exefile=xplotslices_mricrogl('path_mricrogl')
cmd=(['"' exefile '"' ' -s "' cm2 '" ']);
system(cmd );
showinfo2(['imagePath:'],outdir);
% ====[SAVE AS NIMATED GIF]===========================================
imgFiles = dir(fullfile(outdir, '*.png'));
if isempty(imgFiles);  error('No PNG files found in %s', outdir);end
imgFiles = natsort({imgFiles(:).name}');% Sort files alphabetically
for k = 1:length(imgFiles)
    imgPath = fullfile(outdir, imgFiles{k});
    [img, cmap] = imread(imgPath);
    img = imresize(img, 0.5);
    if size(img, 3) == 3  % RGB image , % Convert to indexed image with colormap if needed
         [imgInd, cmap] = rgb2ind(img, 128);
    else
        imgInd = img; cmap = gray(256); % already grayscale
    end
    if k == 1 % First frame — create the GIF file
        imwrite(imgInd, cmap, outputGIF, 'gif', 'LoopCount', Inf, 'DelayTime', delayTime);
    else % Append subsequent frames
        imwrite(imgInd, cmap, outputGIF, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
    end
end
fprintf('Animated GIF saved to:\n%s\n', outputGIF);
showinfo2(['gif:'],outputGIF); 

%% #################################################
% mricroGL-diverse
% make several animated GIFs using mricroGL
% animated gifs created from all '.*Ko.*_mask.nii'-files in folder 'path_files'
path_files='H:\Daten-2\Imaging\AG_Eickholt_SCI\segmentation'
[fi] = spm_select('FPList',path_files,'.*Ko.*_mask.nii')
fi=cellstr(fi);
for i=1:length(fi)
    name0=fi{i};
    [~,namemask]=fileparts(name0);
    name=strrep(namemask,'_mask','');
    
    F1=fullfile(path_files,[name '.nii']);%BG-image
    F2=fi{i};%FG-image
    rotations=[1 1]; %[pitch yaw]-rotation,  each{0|1}; [1 1]:pitch&yaw rotation; [1 0]:pitch only; [0 1]:yaw only
    ktime = 30; %pause between rotations [ms]
    ksteps= 100; %rotational steps
    outdir=fullfile(path_files,['imgs_' name])  ;  %PATH WERE IMAGES ARE STORED (used to created animGIF)
    dosave    =1;  %save BMP {0|1}; [0]: no PNG-files created & no animGIF created
    outputGIF = fullfile(path_files,['movie_' name '.gif' ]); %animGIF: filename
    delayTime = 0.2;  %animGIF: seconds between frames (e.g., 0.1 = 10 fps)
    % ===============================================
    cm={
        ['ktime=  ' num2str(ktime)]
        ['ksteps= ' num2str(ksteps)]
        ['dosave='  num2str(dosave)]
        ['output_folder = ''' strrep(outdir,filesep,[filesep filesep])  '''']
        ['rotations = [' num2str(rotations(1)) ',' num2str(rotations(2)) ']']
        'import gl'
        'import os'
        'import glob'
        'gl.resetdefaults()'
        'gl.scriptformvisible(0)'
        ['gl.loadimage('''     strrep(F1,filesep,[filesep filesep]) ''')']
        ['gl.overlayload('''   strrep(F2,filesep,[filesep filesep]) ''')']
        'gl.minmax(0, 0.5,2.6)'
        'gl.minmax(1, 0, 2)'
        'gl.opacity(1,90)'
        'gl.colorname(1,''actc'')'
        'gl.colorbarposition(0)'
        'gl.backcolor(255,255,255)'
        'if not os.path.exists(output_folder):'
        '    os.makedirs(output_folder)'
        'else:'
        '    if dosave==1:'
        '    	[os.remove(f) for f in glob.glob(output_folder+''\\/*.png'')]'
        'x=0'
        'if rotations[0] == 1:'
        '   for x in range(1, ksteps):'
        '       gl.azimuthelevation(90,120+(x*5))'
        '       gl.wait(ktime)'
        '       if dosave==1:'
        '          gl.savebmp(output_folder+''\\''+str(x)+''.png'')'
        ''
        'if rotations[1] == 1:'
        '   for y in range(1, ksteps):'
        '       gl.azimuthelevation(160+(y*5),30)'
        '       gl.wait(ktime)'
        '       if dosave==1:'
        '          gl.savebmp(output_folder+''\\''+str(x+y)+''.png'')'
        ''
        'gl.scriptformvisible(1)'
        'gl.wait(2000)'
        'gl.quit()'
        };
    cm2=strjoin(cm,'^');
    exefile=xplotslices_mricrogl('path_mricrogl')
    % exefile='D:\software\MRIcroGL\MRIcroGL\MRIcroGL.exe'
    cmd=(['"' exefile '"' ' -s "' cm2 '" ']);
    system(cmd );
    showinfo2(['imagePath:'],outdir);
    % ====[SAVE AS NIMATED GIF]===========================================
    imgFiles = dir(fullfile(outdir, '*.png'));
    if isempty(imgFiles);  error('No PNG files found in %s', outdir);end
    imgFiles = natsort({imgFiles(:).name}');% Sort files alphabetically
    for k = 1:length(imgFiles)
        imgPath = fullfile(outdir, imgFiles{k});
        [img, cmap] = imread(imgPath);
        img = imresize(img, 0.5);
        if size(img, 3) == 3  % RGB image , % Convert to indexed image with colormap if needed
            [imgInd, cmap] = rgb2ind(img, 128);
        else
            imgInd = img; cmap = gray(256); % already grayscale
        end
        if k == 1 % First frame — create the GIF file
            imwrite(imgInd, cmap, outputGIF, 'gif', 'LoopCount', Inf, 'DelayTime', delayTime);
        else % Append subsequent frames
            imwrite(imgInd, cmap, outputGIF, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
        end
    end
    fprintf('Animated GIF saved to:\n%s\n', outputGIF);
    showinfo2(['gif:'],outputGIF);
    
end




%% #################################################
% mricroGL-diverse
% make animated GIF (AVGT & ANO) using mricroGL
F1    ='F:\data9\region_redering_mricrogl\templates\x_t2.nii'; %BG-image
F2    ='F:\data9\region_redering_mricrogl\templates\ANO.nii' ; %FG-image
rotations=[1 1]; %[pitch yaw]-rotation,  each{0|1}; [1 1]:pitch&yaw rotation; [1 0]:pitch only; [0 1]:yaw only 
ktime = 60; %pause between rotations [ms]
ksteps= 10; %rotational steps
outdir='F:\data9\susanne_imghdr\img5';  %PATH WERE IMAGES ARE STORED (used to created animGIF)
dosave    =1;  %save BMP {0|1}; [0]: no PNG-files created & no animGIF created
outputGIF = fullfile('F:\data9\susanne_imghdr', 'rotation_movie5.gif'); %animGIF: filename
delayTime = 0.2;  %animGIF: seconds between frames (e.g., 0.1 = 10 fps)
% ===============================================
cm={
 ['ktime=  ' num2str(ktime)]
 ['ksteps= ' num2str(ksteps)]
 ['dosave='  num2str(dosave)]
 ['output_folder = ''' strrep(outdir,filesep,[filesep filesep])  '''']
 ['rotations = [' num2str(rotations(1)) ',' num2str(rotations(2)) ']']
 'import gl'
 'import os'
 'import glob'
 'gl.resetdefaults()'
 'gl.scriptformvisible(0)'
 ['gl.loadimage('''     strrep(F1,filesep,[filesep filesep]) ''')']
 ['gl.overlayload('''   strrep(F2,filesep,[filesep filesep]) ''')']
 
 'gl.minmax(0, 10,100)'
 'gl.minmax(1, 1, 1000)'
 'gl.opacity(  0, 100)'
 'gl.opacity(  1 ,90)'
 'gl.colorname(1 ,''actc'')'
 'gl.cameradistance(2)'
 'gl.colorname(0,''bone'')'
 '#gl.shadername(''Tomography'')'
 '#gl.shaderadjust(''brighten'', 3)'
 'gl.cutout(0,0,0,.5,1,1)'
 'gl.colorname(1,''actc'')'
 
 'gl.colorbarposition(0)'
 'gl.backcolor(255,255,255)'
 'if not os.path.exists(output_folder):'
 '    os.makedirs(output_folder)'
 'else:'
 '    if dosave==1:'
 '    	[os.remove(f) for f in glob.glob(output_folder+''\\/*.png'')]'
 'x=0'
 'if rotations[0] == 1:'
 '   for x in range(1, ksteps):'
 '       gl.azimuthelevation(90,120+(x*5))'
 '       gl.wait(ktime)'
 '       if dosave==1:'
 '          gl.savebmp(output_folder+''\\''+str(x)+''.png'')'
 ''
 'if rotations[1] == 1:'
 '   for y in range(1, ksteps):'
 '       gl.azimuthelevation(160+(y*5),30)'
 '       gl.wait(ktime)'
 '       if dosave==1:'
 '          gl.savebmp(output_folder+''\\''+str(x+y)+''.png'')'
 ''
 'gl.scriptformvisible(1)'
 'gl.wait(2000)'
 'gl.quit()' 
};
cm2=strjoin(cm,'^');
exefile=xplotslices_mricrogl('path_mricrogl')
cmd=(['"' exefile '"' ' -s "' cm2 '" ']);
system(cmd );
showinfo2(['imagePath:'],outdir);
% ====[SAVE AS NIMATED GIF]===========================================
imgFiles = dir(fullfile(outdir, '*.png'));
if isempty(imgFiles);  error('No PNG files found in %s', outdir);end
imgFiles = natsort({imgFiles(:).name}');% Sort files alphabetically
for k = 1:length(imgFiles)
    imgPath = fullfile(outdir, imgFiles{k});
    [img, cmap] = imread(imgPath);
    img = imresize(img, 0.5);
    if size(img, 3) == 3  % RGB image , % Convert to indexed image with colormap if needed
         [imgInd, cmap] = rgb2ind(img, 128);
    else
        imgInd = img; cmap = gray(256); % already grayscale
    end
    if k == 1 % First frame — create the GIF file
        imwrite(imgInd, cmap, outputGIF, 'gif', 'LoopCount', Inf, 'DelayTime', delayTime);
    else % Append subsequent frames
        imwrite(imgInd, cmap, outputGIF, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
    end
end
fprintf('Animated GIF saved to:\n%s\n', outputGIF);
showinfo2(['gif:'],outputGIF); 











   
 
%% #################################################
% chisquaretest
% xstat_chisquarePlot:  example-1
pares='F:\data8\2024_Stefanie_ORC1_24h_postMCAO\results\stat_x_c_angiomask_blk5_p0.05';
z=[];
z.numOverlays   = [2];        % % number of overlays, {1 or 2}
z.dir           = pares;      % % folder with chisquareResults
z.suffix        = '_ovl2';    % % add suffix to powerpoint to not overwrite previous files
z.alpha         = [1  .8  1];  % % transparency [images:1,2,3]
z.cbarvisible   = [0  1  0];  % % colorbar visibility  [images:1,2,3]
z.clim          = [0 200; 1 3; 0 3];      % % color-limits, [images:1,2,3]:[[min max];[min max];[min max]]
% z.cmap          = { 'gray','autumnFLIP','isoLime'  };  % % colormaps, [images:1,2,3] see: dummyColormap
% z.cmap          = { 'gray' 	'autumnFLIP' 	'isoFuchsia' }; 
% z.cmap          = { 'gray' 	'winter' 	'isoFuchsia' };   
z.cmap          = { 'gray' 	'winterFLIP' 	'isoFuchsia' }; 
z.mbarlabel     = { '' 'OR' '' };                % % cbarlabels, [images:1,2,3]
z.mcbarticks    = [2];                           % % number of ticks in barlabel
z.visible       = [1  1  1];                     % % image visibility,[images:1,2,3]
z.usebrainmask  = [0];                           % % use brainMask to get rid off outerbrain activity {0|1}
xstat_chisquarePlot(0,z);


%% #################################################
% chisquaretest
% run chisquaretest

% xstat_chisquare:  example-1
pastudy   ='F:\data8\2024_Stefanie_ORC1_24h_postMCAO';
groupfile =fullfile(pastudy, 'animal_groups_24hMCAO.xlsx');
% pacode    =fullfile(pastudy,'chisquare_test')
% addpath(pacode)

cd(pastudy)
antcb('close')
ant; antcb('load',fullfile(pastudy,'proj.m')); drawnow;
antcb('close')

file='x_c_angiomask.nii'

% blocksize x hthresh
pars=[...
%     5   0.001
%     0   0.001
    5   0.05
%     0   0.05
    ];

for i=1:size(pars,1)
    z=[];
    z.image        = file;                                                                       % % binary image to make statistic on
    z.groupfile    = groupfile;     % % groupfile(excelfile) with animmals and group
    z.atlas        = '';                                                                                           % % nifti-atlas, if empty the default template-atlas is used
    z.outdir       = '';                                                                                           % % output-dir, if empty the default results-folder is used as upper dir
    z.suffix       = '';                                                                                           % % add suffix-string to final output-dir
    z.useUnionMask = [1];                                                                                          % % [1] use union of all image-files as mask, [0] use AVGTmask from templates-dir
    z.hthresh      = pars(i,2);%[0.05];                                                                                      % % high-threshold such as 0.05
    z.blocksize    = pars(i,1) ;%blocksize(i);%[5];                                                                                          % % if value above 0 use block-shuffling approach (less conservative), must be integer
    z.nperms       = [100];                                                                                        % % number of permutations
    z.CLpeak_num   = [3];                                                                                          % % number of clusterPeaks to report
    z.CLpeak_dist  = [2];                                                                                          % % minum distance between clusterPeaks
    z.OR_cmap      = 'isoFuchsia'%'YlOrRd_flip';                                                                                % % cmap of signif. OddsRatio-map for plotting
    z.OR_range     = [1  5];                                                                                      % % intensity range of OddsRatio-map for plotting
    z.isparfor     = [1];	% use pararellel processing {0|1} ; default: [1] 
    plot_uncorrected=1;
    xstat_chisquare(0,z);
end



% ==============================================
%%   using angiomask
% ===============================================
cf;clear
pastudy='H:\Daten-2\Imaging\AG_Harms\2024_Stefanie_ORC1\d7_postMCAO';
groupfile=fullfile(pastudy,'animal_groups_d7.xlsx');
 
cd(pastudy);
antcb('close');
ant; antcb('load',fullfile(pastudy,'proj_d7.m')); drawnow;
antcb('close');
% blocksize x hthresh
pars=[...
    5   0.001
    0   0.001
    5   0.05
    0   0.05
    ];
for i=1:size(pars,1)
    z=[];
    z.image        = { 'x_c_angiomask.nii' };                                                                       % % binary image to make statistic on
    z.groupfile    = groupfile;     % % groupfile(excelfile) with animmals and group
    z.atlas        = '';                                                                                           % % nifti-atlas, if empty the default template-atlas is used
    z.outdir       = '';                                                                                           % % output-dir, if empty the default results-folder is used as upper dir
    z.suffix       = '_v2';                                                                                           % % add suffix-string to final output-dir
    z.useUnionMask = [1];                                                                                          % % [1] use union of all image-files as mask, [0] use AVGTmask from templates-dir
    z.hthresh      = pars(i,2);%[0.05];                                                                                      % % high-threshold such as 0.05
    z.blocksize    = pars(i,1) ;%blocksize(i);%[5];                                                                                          % % if value above 0 use block-shuffling approach (less conservative), must be integer
    z.nperms       = [5000];                                                                                        % % number of permutations
    z.isparfor             = [1];             % % use pararellel processing {0|1} ; default: [1]
    % %  ---CLUSTER-PEAKS---
    z.CLpeak_num           = [3];             % % number of peaks per signif. cluster to report
    z.CLpeak_dist          = [2];             % % minimum distance between clusterPeaks
    % ---PLOT OPTIONS---
    z.OR_cmap              = 'isoFuchsia';    % % used colormap of overlay, ie. to plot the OddsRatio-map
    z.OR_range             = [1  5];          % % intensity range of OddsRatio-map for plotting
    z.plot_uncorrected     = [1];             % % additionally create+display the uncorrected image
    z.OR_cmap_uncorrected  = 'winterFLIP';    % % uncorrected image: colormap of overlay for plotting
    z.OR_range_uncorrected = [1  5];          % % uncorrected image: intensity range for plotting
    xstat_chisquare(0,z); 
end


%% #################################################
%  registration to standardspace
% estimation

%   EXAMPLES to batch the warping step
%   [1]: perform all tasks, using the mouse dirs as defined in "dirs"-cell array, automatic preregistration
   xwarp3('batch','mdirs',dirs,'task',[1:4],'autoreg',1)
%   [2] same.., but onle mice previously highlighted in the ANT listbox will be processed
   xwarp3('batch','task',[1:4],'autoreg',1)
%   [3] USING PARALLEL-COMPUTATION
   xwarp3('batch','task',[1:2],'autoreg',1,'parfor',1)
 
%% #################################################
%  registration to standardspace
% apply transformation to other images:

%   doelastix(direction, [], files  ,interpx ,'local' );
%   arg1:  direction .. which direction to warp [1]to allen [-1] to native space
%   arg2:  voxresolution--> leave it empty
%   arg3: files --> cell with nifti files to warp
%   arg4: interpolation order [0,1,2,3] for NN, linear, 2nd order, 3rd order (spline)
%   arg5: apply additional rigid body transformation (calculated beforehand) ..use 'local' to use the local parameters
%   example:
      files={'O:\harms1\harms3_lesionfill\dat\s20150505SM02_1_x_x\lesion_64.nii'
      'O:\harms1\harms3_lesionfill\dat\s20150505SM03_1_x_x\lesion_64.nii'
      'O:\harms1\harms3_lesionfill\dat\s20150505SM09_1_x_x\lesion_64.nii'}
      doelastix(1   , [],      files                      ,3 ,'local' );


  
%% #################################################
% MPM
% Bruker import

% DISPLAY all Bruker-files from 'raw'-folder
w1=xbruker2nifti(fullfile(pwd,'raw'),0,[],[],'gui',0,'show',1);

% DISPLAY a list of Bruker files where the protocol name contains 'MPM_3D
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',1,'flt',{'protocol','MPM_3D'},...
    'paout',fullfile(pwd,'dat'),'ExpNo_File',1);

% IMPORT Bruker files where the protocol name contains 'MPM_3D
w2=xbruker2nifti(w1,0,[],[],'gui',0,'show',0,'flt',{'protocol','MPM_3D'},...
    'paout',fullfile(pwd,'dat'),'ExpNo_File',1);

%% #################################################
% regexp
% Pattern to match required files and exclude '_UNCOR_'
pattern = '^p(?!.*_UNCOR_).*\.png$';

% Get a list of all files in the directory
files = dir(fullfile(folder, '*.png'));

% Filter files based on the regular expression
filtered_files = {files.name};
matches = regexp(filtered_files, pattern, 'match');

%% #################################################
% cellfun
% remove paths from fullpath-filelist
filenameOnlyList = cellfun(@(x) x(max(strfind(x, filesep))+1:end), cellList, 'UniformOutput', false);






