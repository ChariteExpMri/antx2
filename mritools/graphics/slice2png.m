


% make plots / save as PNG-file
% slice2png(file,varargin)
% fileName=slice2png(file,varargin)
% 
% INVAR: arg-1: NIFTI (fullpathfilename) or cellstr of NIFTIS to overlay
%        arg-2: pairwise paramter ..see below
%          pairwise
% OUTVAR: name of PNG-file (fileName)
% 
%% ===============================================
%%                  PARAMETER
%% ===============================================
% p.nslices  =16;      number of slices to display: default: 16
% _____________________[alternatives for "nslices"]_____________________________________________________________________________
% p.slice  =[];    slices based on volume-index (this overrides 'nslices') 
%                  examples: [1 5 10] -->will plot slices if volume-index 1,5 and 10
% p.slicemm=[];    slices in mm-units to plot  (this overrides 'nslices') 
%                  examples: [-2 0 4.1] -->will plot slices at position -2mm,0mm and 4.1mm 
% __________________________________________________________________________________________________
%      
% p.dim      =3;         dimension to display {1,2,3}: default: 3
% p.clims    =[nan nan]; colorlimits; default [nan nan] --> set clims to [min max] of slices to display
%                       example: [0 100]    ..min is 0 and max is 100
%                       [nan 1000] ..min determined by slices to display and max is 1000
%                       [nan nan]  ..min & max determined by slices to display
% p.usemask  =1;         use mask to crop background --> makes the image more compact;  {0,1}; default:1
% p.maskOL   =10;        Num Ostu-levels for FG/BG-segmentation, only used when usemask is [1]  and 'AVGTmask'/'ix_AVGTmask' are not available or it's HDR does not match
% p.usemaskotsu=1;       use Otsu-mask instead of explicit mask
%                        if p.mask is empty, 'AVGTmask.nii' or 'ix_AVGTmask.nii' is used as mask (HDR-dependent)
% p.mask     ='';      [if p.usemask is 1] optional: specify fullpath mask to autocrop slices (remove background)
%                       otherwise 'AVGTmask.nii' or 'ix_AVGTmask.nii' is used (HDR-dependent)
%                       default: ''
% p.maskvalue=[];       this maskvalue is used for mask, only if explicit mask is given                    
% ----
% p.flipud   =1;          flip up-down image: {0,1}; default:0
% p.fliplr   =0;          flip left-right image: {0,1}; default:0
% p.sb       =[nan nan];  layout of slices: [rows columns]; default: [nan nan]..autolayout
%                             example: [2 nan] --> all slices in 2 rows
%                                      [nan 3] --> all slices in 3 columns
%                                      [3 3]   --> all slices in 3 rows and 3 columns
% p.imadjust =1;          posthoc adjust colour  {0,1}; default:1
% p.pcolor   =[];         inputfileNum to display in pseudocolors
%                         useful if atlas such as ABA has large dynamic range
%                         example: ...,'pcolor',[2],  ..... pseudocolorize 2nd inputvolume
%                         default: 0
% p.cbarfs   =7;          COLORBAR-fotsize: default:9
% p.cbarcol  ='k';        COLORBAR-color: matlab-single character for color ('b','w'..) or 3 RGB-value-array
% % ---
% p.show     =0;          show figure: {0,1}: [0]: figure is not visible; default: 0
% p.save     =1;          save fig as PNG-file {0,1}  ; default:1
% p.showonly =0;          FAST SWITCH (OVERRIDE SHOW ANS SAVE): prevent saving PNG-file ([1]show only; [0]save as PNG)
% p.cmap     ='gray';     colormap; default: 'gray', in case of more inputfile use cell-array: example: {'gray','jet',...}
% p.cf       =1;           if figure is saved, close figure afterwards: [0,1]; default: 1
% p.title    ='';         [TITLe]: adds a title (string or cell)
% p.titlefs  =9;          [TITLe]-fontsize
%% _________[SAVING]_________________________________________________________________________________________
% p.bgtransp =1;          set background transparency:  {0,1}; default:1
% p.crop     =1;          crop image: crops posthoc image, {0,1}; default:1
% p.res      =300;        PNG-resolution: default: 300 (300dpi)
% p.savename ='';         explicit fullpath name of saved PNG-file, otherwise [path]+[NIFTIfilename]+".png" is used for PNG-file
%                         default: '' --> name of the last inputfile is used for the PNG-filename
%                         usage of '$path' and '$name'
%                        use '$path' to refer to path of NIFTI-file
%                        use '$name' to refer to name of the NIFTI-file
%                        example: '$path/$name_test'  --> would save [path]+[NIFTIfilename]+[_test]+".png"
%% _________[4Dimensions]_________________________________________________________________________________________
% p.vol      =1;         [for  4D-NIFTI]: volume-number to display
% p.volsuffixstart=1;    [for 4D-NIFTI]: start to add suffix for volumeNumber for volumes > p.volsuffixstart
% p.voldigits =3;        [for  4D-NIFTI]: number of digits of filename-suffix to indicate the volume-number
%% __________[contrast]________________________________________________________________________________________
% p.brighter  = [];       single percent value to increase brightness of BG-image
%                         example: [5] ..5% brighter: [10] 10% brighter; default: []                   
% p.darker    =[];        single percent value to increase darkness of BG-image
%                         example: [5] ..5% darker: [20] 10% brighter; default: []
%% _____[FOREGROUND/BACKGROUND-COLOR]_____________________________________________________________________________________________                                    
% p.bgcol='w';           background color
% p.fgcol='k';           text-foreground color (title, cbar)                                   
%% __________________________________________________________________________________________________
% p.alpha=1;            traNsparency of plots, value or array  (range: 0-1); default: [1]...opaque
% p.value0transp=1;     set zero-values to NAN--> enables transparency; default: [1] 
% p.thresh=[nan nan];   [low high] value: values outside this range will be removed/will appear transparent
%                        for multiple files, this is an array (numFile x 2): [low high; low high; low high ....]
%                        default: [nan nan]: i.e. no values are removed/will appear transparent
% p.maskBG=1;           mask background,{0,1}: if set [1]: it is tried to remove background 
%                        this is mandatory to change BG-color or trnasparent background 
%                        default: 1
%% ___________________[COLORBAR]_______________________________________________________________________________
% p.cbarvisible=[1];    [cbar]:set colorbar visisible {0,1} if more than one imagefile is plotted use array  
%                               example: [0 1 1]: show cbar of 2nd and 3rd filevolume
% p.cbarpos=[nan nan .011/2 nan ];   [cbar] colorbar-position 
% p.cbarnticks=2;                    [cbar]:number of ticks to display: default [2]
% p.cbardecimals=1;        [cbar]:number of decimals to display
%                          internally cbar-limits are tried to set to integer value
%                          to force ticks to bave a specific number of decimals you have to set:
%                          'cbardecimals' to [2] and 'cbarintticks' to [0] and 'imadjust' to [0]
%                          example: slice2png({f1,f2},'clims',[nan nan; nan 1000],'dim',2,'showonly',1,'cbardecimals',2,'cbarintticks',0,'imadjust',1);
% p.cbargap=0.07;          [cbar] gap between cbars; default: [0.07]
% p.cbarintticks=1;        [cbar] force integer ticks if feasible, {0,1}
%% ___________________[MESSAGE]_______________________________________________________________________________
% p.msg=0;                 message to plot on bottom; [0]no [1] yes, message with dir,files and path
%                          or costum message as string-cell aor string: example: {'123','ddddd',pwd}';
%                          default: [0]
% p.msgpos=[0.005 0.005 1  .15 ]; [message]-position
% p.msgfs=9;                      [message]-fontsize; default: 9
% p.msgcol='k';                   [message]-color, matlab-color-char ('k') or rgb-triple
% p.msgfont='consolas';           [message]-fontname; default: 'consolas'
%% ___________________[DISPLAY SPECIC REGIONS]_______________________________________________________________________________
% p.keepvalue={};         keep ONLY this values (IDs) of volume and plot it, usefull if selectived regions of
%                         the atlas are displayed
%                   structure: {filenumber, {IDS}}   (for single file)  ..or...
%                              {filenumber, {IDS}; filenumber, {IDS};... }
%             examples:
%       if 2nd fileVolume is an atlas:
%           'keepvalue',{2,[672]}       ...  display region with ID 672
%           'keepvalue',{2,[672,1,5,6]} ...  display region with ID 672,1,5,6
%       if 2nd and 3rd fileVolume is a atlas/mask
%           {2,[672]};3 [ 1 2 3]} ... display region 672 from fileVolume-2 and regions 1,2 and 3 from fileVolume-3
%% ___________________[CONTOUR]_______________________________________________________________________________                                                 
% p.contour=[];    draw contour:
%               structure: {filenumber, {contour parameter}}   (for single controur) ..or ...
%                          {filenumber, {contour parameter}; filenumber, {contour parameter};...  }
%       examples:
%           draw contour of 2nd file, with default contour parameter:
%               {2}
%           draws contour of 2nd file, with 3 contourLevels in red color, linewidth 2:
%               {2,{'colour','r','linewidth',2,'level',3}}
%           draw contour-lines for 2nd and 3rd file:
%               {2,{'colour','r','linewidth',2,'level',3}; 3,{'colour','b','linewidth',1,'level',3}}
%  
% 
%% ===============================================
%%                  EXAMPLES
%% ===============================================
%% ==========================================================================================
%%  single image
%% ==========================================================================================
%  show AVGT as coronar slices (2nd dim)
% f2=fullfile(pwd,'AVGT.nii')
% slice2png(f2,'dim',2,'showonly',1);
% 
%% sliced along dim-2, 8 eqzidistant slices displayed in 1 row ..saved as 'AVGT.png'
% slice2png(f2,'dim',2,'nslices',8,'sb',[1 nan]);
% 
%% or use explizit slice-numbers (100,120,150,170) --> only shown, not saved
% slice2png(f2,'sb',[1 nan],'dim',2,'slice',[100 120 150 170],'showonly',1)
% 
%% or use slices based on mm-unit --> display slices with -5mm,-2.01mm,0mm,0.5mm
% slice2png(f2,'sb',[1 nan],'dim',2,'slicemm',[-5 -2.01 0 0.5],'showonly',1)
%% more plots in more contrained mm-block (20 slices within -1mm and 0mm)
% slice2png(f2,'sb',[nan nan],'dim',2,'slicemm',[linspace(-1,0,20)],'showonly',1)
% 
%% ==========================================================================================
%%  using pseudocolor for large dynamic ranges as in the Allen brain atlas (ABA)
%% ==========================================================================================
%% only pseudocolorized ABA with contour:
% f1=fullfile(pwd,'ANO.nii');
% slice2png({f1},'alpha',[0.5],'sb',[ 2 nan],'dim',2,'nslices',8,'showonly',1,'cbarvisible',[0 0],'contour',{1,{'color','k','linewidth',.1,'levels',5}},'pcolor',[1]);
% 
%% AVGT with overlay of pseudocolorized ABA:
% f1=fullfile(pwd,'AVGT.nii');
% f2=fullfile(pwd,'ANO.nii');
% slice2png({f1,f2},'alpha',[1 .6 ],'sb',[ 2 nan],'dim',2,'nslices',8,'showonly',1,'cbarvisible',[0 0],'brighter',1,'pcolor',[2]);
% 
%% AVGT with overlay of pseudocolorized ABA with contour:
% f1=fullfile(pwd,'AVGT.nii');
% f2=fullfile(pwd,'ANO.nii');
% slice2png({f1,f2},'alpha',[1 0.6],'sb',[ 2 nan],'dim',2,'nslices',8,'showonly',1,'cbarvisible',[0 0],'contour',{2,{'color','k','linewidth',.1,'levels',5}},'brighter',1,'pcolor',[2]);
% 
% 
%% ==========================================================================================
%%  overlay
%% ==========================================================================================
% f1=fullfile(pwd,'AVGT.nii')
% f2=fullfile(pwd,'ANO.nii')
% ff={f1;f2};
% slice2png(ff,'clims',[nan nan; 0 1000],'dim',2);
% 
%% overlay, atlas is semitransparent, 1-column-layout, dim-2 is sliced, 5 slices, cbar of atlas is show, image is saved with 100DPI-resolution
% slice2png(ff,'clims',[0 200; 0 1000],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cbarvisible',[0 1],'res',100)
% 
%% as above but displayed (not saved)
% slice2png(ff,'clims',[0 200; 0 1000],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cbarvisible',[0 1],'showonly',1)
% 
%% automatic layout of 10 slices, with additional title and auto-message
% slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'sb',[nan nan],'dim',2,'nslices',10,'cbarvisible',[1 1],'showonly',0,'title',{pwd},'titlefs',9,'msg',1,'show',1)
% 
%% as above but with specific message
% slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'sb',[nan nan],'dim',2,'nslices',10,'cbarvisible',[1 1],'showonly',0,'title',{pwd},'titlefs',9,'msg',{'kohl','kopf'},'show',1)
% 
%% as above but with explitic name for PNG-file
% slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'dim',2,'savename','dum.png')
% 
%% no transparency, black background, white text
% slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'dim',2,'bgcol','k','fgcol','w','bgtransp',0)
% 
%% other colormap
% slice2png(ff,'clims',[0 200; 0 1000],'alpha',[1 .5],'sb',[ 2 nan],'dim',2,'nslices',6,'cbarvisible',[0 1],'showonly',1,'cmap',{'gray','jet'})
% 
%% ==========================================================================================
%%   DISPLAY MASKLESION IN  STANDARD SPACE
%% ==========================================================================================
% f1=fullfile(pwd,'AVGT.nii');
% f2=fullfile(pwd,'x_masklesion.nii');
% 
% slice2png({f1,f2},'showonly',1); %sagittal, only shown
% slice2png({f1,f2},'dim',2,'showonly',1); %coronar view
% 
%% with contout and specific cmpas---see getCMAP('showmaps');
% slice2png({f1,f2},'dim',2,'showonly',1,'cmap',{'gray','isoFuchsia'},'contour',{2}); % other cmaps
%% specific cmpas---see getCMAP('showmaps');
% slice2png({f1,f2},'dim',2,'showonly',1,'cmap',{'gray','Greens'});     % other cmaps
% 
%% contour only with masklesion
% slice2png({f1,f2},'dim',2,'showonly',1,'cmap',{'gray','isoFuchsia'},'contour',{2,{};1 {}},'alpha',[0 1]);
% 
% 
%% ==============================================
%%   add contour for masklesion
%% ===============================================
% f1=fullfile(pwd,'AVGT.nii');
% f2=fullfile(pwd,'x_masklesion.nii');
%% add contour for masklesion
% slice2png({f1,f2},'dim',2,'showonly',1,'contour',{2}); %coronar view
%% add red contour
% slice2png({f1,f2},'dim',2,'showonly',1,'contour',{2,{'color','r','linewidth',1}}); %coronar view
% 
% 
%% ==========================================================================================
%% 3 IMAGES: add mask-lesion contour on top of ANO
%% ==========================================================================================
% f1=fullfile(pwd,'AVGT.nii');
% f2=fullfile(pwd,'ANO.nii');
% f3=fullfile(pwd,'x_masklesion.nii')
% 
% ff={f1;f2; f3};
% slice2png(ff,'clims',[nan nan;nan 1000; nan nan],'alpha',[1 .6 .1],'sb',[ 3 nan],...
%     'dim',2,'nslices',10,'cmap',{'gray', 'parula', 'isoFuchsia'},'showonly',1,...
%     'cbarvisible',[0 0 0],'contour',{3,{'color','r','linewidth',1}})
% 
%% ====[same in native space]===========================================
% f1=fullfile(pwd,'t2.nii');
% f2=fullfile(pwd,'ix_ANO.nii');
% f3=fullfile(pwd,'masklesion.nii')
% 
% ff={f1;f2; f3};
% slice2png(ff,'clims',[nan nan;nan 1000; nan nan],'alpha',[1 .6 .1],'sb',[ 3 nan],...
%     'dim',1,'nslices',10,'cmap',{'gray', 'parula', 'isoFuchsia'},'showonly',1,...
%     'cbarvisible',[0 0 0],'contour',{3,{'color','r','linewidth',1}},'brighter',10)
% 
%% ====[AVGT as contour to check registration ]===========================================
% f1=fullfile(pwd,'x_t2.nii');
% f2=fullfile(pwd,'AVGT.nii');
% slice2png({f1,f2},'alpha',[1 0 ],'sb',[ 2 nan],'dim',2,'nslices',8,'showonly',1,'cbarvisible',[0 0],'contour',{2,{'color','y','linewidth',.1,'levels',5}},'brighter',1);
% 
%% ====[ANO as contour to check registration ]===========================================
% f1=fullfile(pwd,'x_t2.nii');
% f2=fullfile(pwd,'ANO.nii');
% slice2png({f1,f2},'alpha',[1 0 ],'sb',[ 2 nan],'dim',2,'nslices',8,'showonly',1,'cbarvisible',[0 0],'contour',{2,{'color','y','linewidth',.1,'levels',5}},'brighter',1);
% 
% 
%% ====[gray matter  as contour ]===========================================
% f1=fullfile(pwd,'t2.nii');
% f2=fullfile(pwd,'c1t2.nii');
% slice2png({f1,f2},'alpha',[1 0 ],'sb',[ 1 nan],'dim',1,'nslices',5,'showonly',1,'cbarvisible',[0 0],'contour',{1,{'color','y','linewidth',.1,'levels',3}},'brighter',1);
% 
% 
%% ====[gray matter as contour and masklesion]===========================================
% f1=fullfile(pwd,'t2.nii');
% f2=fullfile(pwd,'c1t2.nii');
% f3=fullfile(pwd,'masklesion.nii')
% 
% ff={f1;f2; f3};
% slice2png(ff,'alpha',[1 0 .2],'sb',[ 3 nan], 'dim',1,'nslices',10,'cmap',{'gray', 'parula', 'isoFuchsia'},'showonly',1, 'cbarvisible',[0 0 0],'contour',{2,{'color','y','linewidth',.1,'levels',1}},'brighter',1)
% 
% 
%% ====[gray and white matter as contour ]===========================================
% f1=fullfile(pwd,'t2.nii');
% f2=fullfile(pwd,'c1t2.nii');
% f3=fullfile(pwd,'c2t2.nii');
% ff={f1;f2; f3};
% slice2png(ff,'alpha',[1 0 0],'sb',[ 3 nan], 'dim',1,'nslices',10,'showonly',1,'cbarvisible',[0 0 0],'contour',{2,{'color','y','linewidth',.1,'levels',1}; 3,{'color','r','linewidth',.1,'levels',1}},'brighter',1);
% 
%% ==========================================================================================
%%    NATIVE SPACE
%% ==========================================================================================
%% using NIFTI in native space, assume no mask is available, using implicit mask via Otsu-method
% f1=fullfile(pwd,'t2.nii');
% f2=fullfile(pwd,'ix_ANO.nii');
% 
%% less compact view because no implicit mask is used
% slice2png({f1 f2},'clims',[nan nan; 0 1000],'alpha',[1 .7],'sb',[4 nan],'dim',1,'nslices',16,'usemask',0,'bgtransp',1,'usemaskotsu',0)
% 
%% more compact view because implicit mask is used
% slice2png({f1 f2},'clims',[nan nan; 0 1000],'alpha',[1 .7],'sb',[4 nan],'dim',1,'nslices',16,'usemask',0,'bgtransp',1)
% 
% 
%% -  --plot tissue compartments
% f1=fullfile(pwd,'t2.nii');
% f2=fullfile(pwd,'c1t2.nii');
% f3=fullfile(pwd,'c2t2.nii');
% f4=fullfile(pwd,'c3t2.nii');
% ff={f1;f2;f3;f4};
% slice2png(ff,'clims',[nan nan],'showonly',1,'dim',1,'cmap',{'gray','isoRed','isoBlue','isoGreen'},'alpha',[1 .3 .3 .3],'cbarvisible',[0 0 0 0])
%% same but with increaded brightness
% slice2png(ff,'clims',[nan nan],'showonly',1,'dim',1,'cmap',{'gray','isoRed','isoBlue','isoGreen'},'alpha',[1 .3 .3 .3],'cbarvisible',[0 0 0 0],'brighter',10)
% 
% 
% 
%% ==========================================================================================
%% overlay with Jacobian
%% ==========================================================================================
% 
% f1=fullfile(pwd,'AVGT.nii');
% f2=fullfile(pwd,'JD.nii');
% ff={f1;f2};
% 
%% overlay, JD is semitransparent, 1-column-layout, dim-2 is sliced,5 slices, only shown (not saved)
% slice2png(ff,'clims',[0 200; 0.5 1.5],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','jet'},'showonly',1)
% 
%% as above, but for JD only values above 1.0 are shown (see thresh)
% slice2png(ff,'clims',[0 200; 0.5 1.5],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','jet'},'showonly',1,'thresh',[nan nan; 1 nan])
% 
%% as above, but for JD only values below 0.5 are shown (see thresh)
% slice2png(ff,'clims',[0 200; 0.5 1.5],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','jet'},'showonly',1,'thresh',[nan nan; nan 0.5])
% 
%% as above, but for JD only values in the range 0.8 and 1.2 are shown (see thresh)
% slice2png(ff,'clims',[0 200; 0.5 1.5],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','jet'},'showonly',1,'thresh',[nan nan; 0.8 1.2])
% 
%% ==========================================================================================
%% USING 2 IMAGES: THRESHOLD INTENSITY MAPS
%% ==========================================================================================
%  for JD only values above 1.0 are shown (see thresh)
% f1=fullfile(pwd,'AVGT.nii');
% f2=fullfile(pwd,'JD.nii');
% ff={f1;f2};
% slice2png(ff,'clims',[0 200; 0.5 1.5],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','hot'},'showonly',1,'thresh',[nan nan; 1 nan])
% 
%% ===============================================
%% USING 3 IMAGES: THRESHOLD INTENSITY MAPS  (as a workaround we use 'JD.nii' twice)
% f1=fullfile(pwd,'AVGT.nii');
% f2=fullfile(pwd,'JD.nii');
% ff={f1;f2; f2};
% slice2png(ff,'clims',[0 200; 0.5 1.5; 0.5 1.5],'alpha',[1 .5 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','hot', 'cool'},'showonly',1,'thresh',[nan nan; 1 nan; nan 0.5])
% 
%% as above but here we use the same 'clims' as for the 'thresh'
% slice2png(ff,'clims',[0 200; 1 nan; nan 0.5],'alpha',[1 .5 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray','hot', 'winter'},'showonly',1,'thresh',[nan nan; 1 nan; nan 0.5])
% 
% 
%% ==========================================================================================
%% USING 3 IMAGES: THRESHOLD INTENSITY MAP
%% ==========================================================================================
% f1=fullfile(pwd,'AVGT.nii');
% f2=fullfile(pwd,'x_masklesion.nii')
% f3=fullfile(pwd,'JD.nii');
% ff={f1;f2; f3};
% slice2png(ff,'clims',[0 200;nan nan; 0.5 1.5],'alpha',[1 .5 .5],'sb',[ 2 nan],'dim',2,'nslices',6,'cmap',{'gray','isoLime', 'RdYlBu_flip'},'showonly',1)
% 
%% save with black background
% slice2png(ff,'clims',[0 200;nan nan; 0.5 1.5],'alpha',[1 .5 .5],'sb',[ 2 nan],'dim',2,'nslices',6,'cmap',{'gray','isoLime', 'RdYlBu_flip'},'showonly',0,'bgcol','k','bgtransp',0)
% 
% 
% 
%% ==========================================================================================
%% USING 4 IMAGES: THRESHOLD INTENSITY MAPS  (as a workaround we use 'JD.nii' 2 times)
%% ==========================================================================================
% f1=fullfile(pwd,'AVGT.nii');
% f2=fullfile(pwd,'x_masklesion.nii')
% f3=fullfile(pwd,'JD.nii');
% ff={f1;f2; f3; f3};
% slice2png(ff,'clims',[nan nan;nan nan; 1 nan; nan 0.5],'alpha',[1 .5 .5 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray', 'isoLime','Oranges', 'Blues_flip'},'showonly',1,'thresh',[nan nan;nan nan; 1 nan; nan 0.5])
% 
%% show specific colorbars only
% slice2png(ff,'clims',[nan nan;nan nan; 1 nan; nan 0.5],'alpha',[1 .5 .5 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray', 'isoLime','Oranges', 'Blues_flip'},'showonly',1,'thresh',[nan nan;nan nan; 1 nan; nan 0.5],'cbarvisible',[0 0 1 1])
% 
%% other cmaps
% slice2png(ff,'clims',[nan nan;nan nan; 1 nan; nan 0.5],'alpha',[1 .5 .5 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cmap',{'gray', 'isoLime','isoRed', 'isoBlue'},'showonly',1,'thresh',[nan nan;nan nan; 1 nan; nan 0.5],'cbarvisible',[0 0 1 1])
% 
% 
%% ==========================================================================================
%%  overlay atlas  and color specic IDs
%% ==========================================================================================
% f1=fullfile(pwd,'AVGT.nii')
% f2=fullfile(pwd,'ANO.nii')
% ff={f1;f2};
% slice2png(ff,'clims',[nan nan; 0 1000],'dim',2);
% 
%% overlay, atlas is semitransparent, 1-column-layout, dim-2 is sliced, 5 slices, cbar of atlas is show, image is saved with 100DPI-resolution
% slice2png(ff,'clims',[0 200],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cbarvisible',[0 1],'res',100,'keepvalue',{2,[ 672   ]} ,'showonly',1,'cmap',{'gray','isoRed'})
% 
%% more ids
% slice2png(ff,'clims',[0 200],'alpha',[1 .5],'sb',[ 1 nan],'dim',2,'nslices',5,'cbarvisible',[0 1],'res',100,'keepvalue',{2,[ 201 672 500 733 1047 1070  ]},'showonly',1,'cmap',{'gray','jet'})
% 
%% ==========================================================================================
%%  overlay atlas  and color specic IDs  with specific colors
%% ==========================================================================================
% f1=fullfile(pwd,'AVGT.nii')
% f2=fullfile(pwd,'ANO.nii')
% ff={f1;f2;f2;f2};
% 
% keepvalue={2,[672 500 733] ;...
%     3 [ 1047 ]; ....
%     4,[  1020  ]}
% slice2png(ff,'clims',[0 200],'alpha',[1 .5 .5 .5 ],'sb',[ 2 nan],'dim',2,'nslices',10,'cbarvisible',[0 1],'keepvalue',keepvalue,'showonly',1,'cmap',{'gray','isoRed'  'isoBlue' 'isoYellow'})
% 
% 
%% adjustment of colorbar
% keepvalue={2,[672] ;...
%     3 [ 1047 ]; ....
%     4,[  1020  ]}
% slice2png(ff,'clims',[0 200],'alpha',[1 .5 .5 .5 ],'sb',[ 2 nan],'dim',2,'nslices',10,'cbarvisible',[0 1],'keepvalue',keepvalue,'showonly',1,'cmap',{'gray','isoRed'  'isoBlue' 'isoYellow'},'cbarpos',[nan nan 0.02 .02])
% 
%% ==========================================================================================
%%  show left or right hemisphere only
%% ==========================================================================================
% f1=fullfile(pwd,'AVGT.nii');
% f2=fullfile(pwd,'ANO.nii');
% f3=fullfile(pwd,'x_masklesion.nii')
% mask=fullfile(pwd,'AVGThemi.nii');
% ff={f1;f2; f3};
% 
%% left hemisphere
% slice2png(ff,'clims',[nan nan;nan 1000; nan nan],'alpha',[1 .6 .1],'sb',[ 3 nan],...
%     'dim',2,'nslices',10,'cmap',{'gray', 'parula', 'isoFuchsia'},'showonly',1,...
%     'cbarvisible',[0 0 0],'contour',{3,{'color','r','linewidth',1}},'mask',mask,'maskvalue',1);
%% right hemisphere
% slice2png(ff,'clims',[nan nan;nan 1000; nan nan],'alpha',[1 .6 .1],'sb',[ 3 nan],...
%     'dim',2,'nslices',10,'cmap',{'gray', 'parula', 'isoFuchsia'},'showonly',1,...
%     'cbarvisible',[0 0 0],'contour',{3,{'color','r','linewidth',1}},'mask',mask,'maskvalue',2);
% 
%% ==============================================
%%   show first 400 regions of the ABA-atlas
%% ===============================================
% f1=fullfile(pwd,'AVGT.nii');
% f2=fullfile(pwd,'ANO.nii');
% mask=fullfile(pwd,'ANO.nii');
% ff={f1;f2};
% slice2png(ff,'clims',[nan nan;nan 1000],'alpha',[1 0],'sb',[ 4 nan],...
%     'dim',2,'nslices',20,'cmap',{'gray', 'parula'},'showonly',1,...
%     'cbarvisible',[0 0],'mask',mask,'maskvalue',[ 1:1400 ]);



function varargout=slice2png(file,varargin)





p.nslices  =16;        %number of slices to display: default: 16
% _____________________[alternatives for "nslices"]_____________________________________________________________________________
p.slice  =[];    % slices based on volume-index (this overrides 'nslices') 
                 % examples: [1 5 10] -->will plot slices if volume-index 1,5 and 10
p.slicemm=[];    %: slices in mm-units to plot  (this overrides 'nslices') 
                 % examples: [-2 0 4.1] -->will plot slices at position -2mm,0mm and 4.1mm 
% __________________________________________________________________________________________________
     
p.dim      =3;         %dimension to display {1,2,3}: default: 3
p.clims    =[nan nan]; %colorlimits; default [nan nan] --> set clims to [min max] of slices to display
%                       example: [0 100]    ..min is 0 and max is 100
%                       [nan 1000] ..min determined by slices to display and max is 1000
%                       [nan nan]  ..min & max determined by slices to display
p.usemask  =1;         % use mask to crop background --> makes the image more compact;  {0,1}; default:1
p.maskOL   =10;        % Num Ostu-levels for FG/BG-segmentation, only used when usemask is [1]  and 'AVGTmask'/'ix_AVGTmask' are not available or it's HDR does not match
p.usemaskotsu=1;       % use Otsu-mask instead of explicit mask
%                       if p.mask is empty, 'AVGTmask.nii' or 'ix_AVGTmask.nii' is used as mask (HDR-dependent)
p.mask     ='';        %[if p.usemask is 1] optional: specify fullpath mask to autocrop slices (remove background)
                       %otherwise 'AVGTmask.nii' or 'ix_AVGTmask.nii' is used (HDR-dependent)
                       %default: ''
p.maskvalue=[];        % this maskvalue is used for mask, only if explicit mask is given                    
% ----
p.flipud   =1;         %flip up-down image: {0,1}; default:0
p.fliplr   =0;         %flip left-right image: {0,1}; default:0
p.sb       =[nan nan]; %layout of slices: [rows columns]; default: [nan nan]..autolayout
                       %    example: [2 nan] --> all slices in 2 rows
                       %             [nan 3] --> all slices in 3 columns
                       %             [3 3]   --> all slices in 3 rows and 3 columns
p.imadjust =1;         %posthoc adjust colour  {0,1}; default:1
p.pcolor   =[];        % inputfileNum to display in pseudocolors
%                      % useful if atlas such as ABA has large dynamic range
%                      %example: ...,'pcolor',[2],  ..... pseudocolorize 2nd inputvolume
%                      %default: 0
p.cbarfs   =7;         %COLORBAR-fotsize: default:9
p.cbarcol  ='k';       %COLORBAR-color: matlab-single character for color ('b','w'..) or 3 RGB-value-array
% ---
p.show     =0;         %show figure: {0,1}: [0]: figure is not visible; default: 0
p.save     =1;         %save fig as PNG-file {0,1}  ; default:1
p.showonly =0;         %FAST SWITCH (OVERRIDE SHOW ANS SAVE): prevent saving PNG-file ([1]show only; [0]save as PNG)
p.cmap     ='gray';    %colormap; default: 'gray', in case of more inputfile use cell-array: example: {'gray','jet',...}
p.cf       =1;         % if figure is saved, close figure afterwards: [0,1]; default: 1
p.title    ='';        %[TITLe]: adds a title (string or cell)
p.titlefs  =9;         %[TITLe]-fontsize
% _________[SAVING]_________________________________________________________________________________________
p.bgtransp =1;         %set background transparency:  {0,1}; default:1
p.crop     =1;         %crop image: crops posthoc image, {0,1}; default:1
p.res      =300;       %PNG-resolution: default: 300 (300dpi)
p.savename ='';        %explicit fullpath name of saved PNG-file, otherwise [path]+[NIFTIfilename]+".png" is used for PNG-file
%                      default: '' --> name of the last inputfile is used for the PNG-filename
%                      usage of '$path' and '$name'
%                      use '$path' to refer to path of NIFTI-file
%                      use '$name' to refer to name of the NIFTI-file
%                      example: '$path/$name_test'  --> would save [path]+[NIFTIfilename]+[_test]+".png"
% _________[4Dimensions]_________________________________________________________________________________________
p.vol      =1;         %[for  4D-NIFTI]: volume-number to display
p.volsuffixstart=1;    %[for 4D-NIFTI]: start to add suffix for volumeNumber for volumes > p.volsuffixstart
p.voldigits =3;        %[for  4D-NIFTI]: number of digits of filename-suffix to indicate the volume-number
% __________[contrast]________________________________________________________________________________________
p.brighter  = [];      % single percent value to increase brightness of BG-image
                       % example: [5] ..5% brighter: [10] 10% brighter; default: []                   
p.darker    =[];       % single percent value to increase darkness of BG-image
                       % example: [5] ..5% darker: [20] 10% brighter; default: []
% _____[FOREGROUND/BACKGROUND-COLOR]_____________________________________________________________________________________________                                    
p.bgcol='w';  %background color
p.fgcol='k';  %text-foreground color (title, cbar)                                   
% __________________________________________________________________________________________________
p.alpha=1;            %trasparency of plots, value or array  (range: 0-1); default: [1]...opaque
p.value0transp=1;     %set zero-values to NAN--> enables transparency; default: [1] 
p.thresh=[nan nan];   %[low high] value: values outside this range will be removed/will appear transparent
%                      for multiple files, this is an array (numFile x 2): [low high; low high; low high ....]
%                      default: [nan nan]: i.e. no values are removed/will appear transparent
p.maskBG=1;           %mask background,{0,1}: if set [1]: it is tried to remove background 
%                      this is mandatory to change BG-color or trnasparent background 
%                      default: 1
% ___________________[COLORBAR]_______________________________________________________________________________
p.cbarvisible=[1];    %[cbar]:set colorbar visisible {0,1} if more than one imagefile is plotted use array  
%                             example: [0 1 1]: show cbar of 2nd and 3rd filevolume
p.cbarpos=[nan nan .011/2 nan ];  %[cbar] colorbar-position 
p.cbarnticks=2;       %[cbar]:number of ticks to display: default [2]
p.cbardecimals=1;     %[cbar]:number of decimals to display
%                     internally cbar-limits are tried to set to integer value
%                     to force ticks to bave a specific number of decimals you have to set:
%                     'cbardecimals' to [2] and 'cbarintticks' to [0] and 'imadjust' to [0]
%                      example: slice2png({f1,f2},'clims',[nan nan; nan 1000],'dim',2,'showonly',1,'cbardecimals',2,'cbarintticks',0,'imadjust',1);
p.cbargap=0.07;       %[cbar] gap between cbars; default: [0.07]
p.cbarintticks=1;     %[cbar] force integer ticks if feasible, {0,1}
% ___________________[MESSAGE]_______________________________________________________________________________
p.msg=0;        % message to plot on bottom; [0]no [1] yes, message with dir,files and path
%  or costum message as string-cell aor string: example: {'123','ddddd',pwd}';
%  default: [0]
p.msgpos=[0.005 0.005 1  .15 ]; % [message]-position
p.msgfs=9;                      % [message]-fontsize; default: 9
p.msgcol='k';                   % [message]-color, matlab-color-char ('k') or rgb-triple
p.msgfont='consolas';           % [message]-fontname; default: 'consolas'
% ___________________[DISPLAY SPECIC REGIONS]_______________________________________________________________________________
p.keepvalue={};  % keep this values (IDs) of volume and plot it, usefull if selectived regions of
% the atlas are displayed
% structure: {filenumber, {IDS}}   (for single file)  ..or...
%            {filenumber, {IDS}; filenumber, {IDS};... }
% examples:
% if 2nd fileVolume is an atlas:
%   'keepvalue',{2,[672]}       ...  display region with ID 672
%   'keepvalue',{2,[672,1,5,6]} ...  display region with ID 672,1,5,6
% if 2nd and 3rd fileVolume is a atlas/mask
%   {2,[672]};3 [ 1 2 3]} ... display region 672 from fileVolume-2 and regions 1,2 and 3 from fileVolume-3
% ___________________[CONTOUR]_______________________________________________________________________________                                                 
p.contour=[];    %draw contour:
% structure: {filenumber, {contour parameter}}   (for single controur) ..or ...
%            {filenumber, {contour parameter}; filenumber, {contour parameter};...  }
% examples:
%  draw contour of 2nd file, with default contour parameter:
%     {2}
%  draws contour of 2nd file, with 3 contourLevels in red color, linewidth 2:
%     {2,{'colour','r','linewidth',2,'level',3}}
%  draw contour-lines for 2nd and 3rd file:
%     {2,{'colour','r','linewidth',2,'level',3}; 3,{'colour','b','linewidth',1,'level',3}}
%     





%% ===============================================
%% not used
%% ===============================================
% p.resize   =0;         % resize image by factor-n;   default:n=0
                 
%% ===============================================

                 
% length(p,'fieldnames')
drawnow;
warning off;
if nargin>1
    pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    p=catstruct(p,pin);
end
if p.showonly==1
    p.show=1;
    p.save=0;
end
p.cmap=cellstr(p.cmap);


if 0
    %% ===============================================
    
    
    slice2png(fullfile(pwd,'t2.nii'),'dim',1);
    slice2png(fullfile(pwd,'AVGT.nii'));
    
    f1=fullfile(pwd,'t2.nii');
    slice2png(f1,'dim',1,'flipud',1,'nslices',8,'sb',[1 nan]);
    
    f2=fullfile(pwd,'AVGT.nii')
    slice2png(f2,'dim',2,'flipud',0,'nslices',8,'sb',[1 nan]);
    
    slice2png(f1,'dim',1,'fliplr',1,'nslices',10,'sb',[1 nan],'resize',0,'usemask',1,'mask',fullfile(pwd,'AVGTmask.nii'),'res',150);
    
    %% ===============================================
    
    f2=fullfile(pwd,'AVGT.nii')
    f3=fullfile(pwd,'AVGT.nii')
    
    slice2png(f2,'dim',2,'flipud',0,'nslices',8,'sb',[1 nan]);
    slice2png(f2,'dim',2,'nslices',48,'sb',[2 nan],'showonly',1);
    slice2png(fullfile(pwd,'ANO.nii'),'clims',[0 1000],'cmap','parula','dim',2,'nslices',8,'sb',[2 nan],'showonly',1);
    
    
    pax='F:\data5\nogui\dat\MPM_Pilot_test_retest_c9038_SID_27183_1tailmark_retest'
    slice2png(fullfile(pax,'qsm_MT_mag.nii'),'dim',2,'flipud',0,'nslices',8,'sb',[1 nan],'showonly',0,'resize',10,'title','123','savename','c:/$namep','vol',8);
    slice2png(fullfile(pax,'qsm_MT_mag.nii'),'dim',2,'flipud',0,'nslices',8,'sb',[1 nan],'showonly',0,'resize',10,'title','123','vol',8);
    
    slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'sb',[1 nan],'dim',2,'nslices',10,'cbarvisible',[1 1],'showonly',0,'title',{pwd},'titlefs',9,'msg',0,'savename','dum.png')
    slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'sb',[1 nan],'dim',2,'nslices',10,'cbarvisible',[0 1],'showonly',1,'title',{pwd},'titlefs',9,'msg',0,'savename','dum.png')
    
    slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'sb',[1 nan],'dim',2,'nslices',10,'cbarvisible',[0 1],'showonly',1,'title',{pwd},'titlefs',9,'msg',0,'savename','dum.png','cmap',{'gray','jet'})
    %% ===============================================
    %     ff={f1;f2}
    %     p.clim=[0 200; 0 1000]
    %     f1=fullfile(pwd,'AVGT.nii')
    %     f2=fullfile(pwd,'ANO.nii')
    %     f3=fullfile(pwd,'JD.nii')
    %     ff={f1;f2; f3}
    %     p.clim=[0 200; 0 1000; 0.5 1.5]
    %     p.cmap={'gray','jet','hot'}
    %     p.alpha=[1 0.3  .4]
    %     p.thresh=[100 nan; nan nan; nan nan]
    
    f1=fullfile(pwd,'AVGT.nii')
    f2=fullfile(pwd,'ANO.nii')
    ff={f1;f2};
    slice2png(ff,'clims',[nan nan; 0 1000]);
    %% ===============================================
    f1=fullfile(pwd,'AVGT.nii')
    f2=fullfile(pwd,'ANO.nii')
    f3=fullfile(pwd,'JD.nii')
    ff={f1;f2;f3};
    slice2png(ff,'clims',[nan nan; 0 1000]);
    
    
    slice2png(ff,'clims',[0 200; 0 1000],'alpha',[1 .2],'sb',[ 1 nan],'dim',1,'nslices',20,'cbarvisible',[0 0 1],'res',100)
    
    slice2png(ff,'clims',[0 200; 0 1000],'alpha',[1 .2],'sb',[ 1 nan],'dim',1,'nslices',20,'cbarvisible',[1 0 0],'showonly',1)
    
    
    slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'sb',[nan nan],'dim',2,'nslices',10,'cbarvisible',[1 1 1],'showonly',0,'title',{pwd},'titlefs',9,'msg',1,'show',1)
    
    slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'sb',[1 nan],'dim',2,'nslices',10,'cbarvisible',[1 1 1],'showonly',0,'title',{pwd},'titlefs',9,'msg',1,'show',1)
    
    slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'sb',[1 nan],'dim',2,'nslices',10,'cbarvisible',[1 1 1],'showonly',0,'title',{pwd},'titlefs',9,'msg',0,'show',1)
    
    slice2png(ff(1:2),'clims',[0 200; 0 1000],'alpha',[1 .7],'sb',[1 nan],'dim',2,'nslices',10,'cbarvisible',[1 1 1],'showonly',0,'title',{pwd},'titlefs',9,'msg',0,'show',1)
    
    %% ===============================================
    f1=fullfile(pwd,'t2.nii')
    f2=fullfile(pwd,'ix_ANO.nii')
    
    slice2png({f1 f2},'clims',[nan nan; 0 1000],'alpha',[1 .7],'sb',[1 nan],'dim',2,'nslices',6,'cbarvisible',[1 1],'showonly',1,'title',{pwd},'titlefs',9,'msg',1,'show',1)

    
    slice2png({f1 f2},'clims',[nan nan; 0 1000],'alpha',[1 .7],'sb',[4 nan],'dim',1,'nslices',16,'usemask',0,'bgtransp',1,'usemaskotsu',0)

    slice2png({f1 f2},'clims',[nan nan; 0 1000],'alpha',[1 .7],'sb',[4 nan],'dim',1,'nslices',16,'usemask',0,'bgtransp',1,'usemaskotsu',1)
    
    %% ===============================================
    
end

% ==============================================
%%
% ===============================================
ff=cellstr(file);
[g.path g.file  g.ext]=fileparts(ff{end});
g.pat=cellstr(g.path);
g.file=cellstr(g.file);
g.ext=cellstr(g.ext);

[~,g.animal ]=fileparts(g.path);

cmap_defaults  ={'gray','parula','hot','summer','winter'};
alpha_defaults =[1 .5 .5 .5 .5 .5];
clims_defaults =repmat(nan,[10 2]);
thresh_defaults=repmat(nan,[10 2]);
vol_defaults=repmat(1,[1 10]);
cbarvisible_defaults=repmat(1,[1 10]);


if length(ff)>1
    if length(length(p.cmap))<length(ff)
        p.cmap= [p.cmap(:)' cmap_defaults(length(p.cmap)+1:end)];
    end
    if length(length(p.alpha))<length(ff)
        p.alpha= [p.alpha(:)' alpha_defaults(length(p.alpha)+1:end)];
    end
    
    if length(size(p.clims,1))<length(ff)
        p.clims= [p.clims; clims_defaults(size(p.clims,1)+1:end,:)  ];
    end
    if length(size(p.thresh,1))<length(ff)
        p.thresh= [p.thresh; thresh_defaults(size(p.thresh,1)+1:end,:)  ];
    end
    
    if length(length(p.vol))<length(ff)
        p.vol=  [p.vol(:)'   vol_defaults(length(p.vol)+1:end)];
    end
    
     if length(length(p.cbarvisible))<length(ff)
        p.cbarvisible=  [p.cbarvisible(:)'   cbarvisible_defaults(length(p.cbarvisible)+1:end)];
    end
    
end


% if ischar(p.bgcol) && strcmp(p.bgcol,'w')==0
%     p.bgtransp=0;
% end


    
if ischar(p.bgcol) && strcmp(p.bgcol,'k') &&    ischar(p.fgcol) && strcmp(p.fgcol,'k') ...
   p.fgcol='w'; 
end
if ischar(p.bgcol) && strcmp(p.bgcol,'w') &&    ischar(p.fgcol) && strcmp(p.fgcol,'w') ...
   p.fgcol='k'; 
end

%% ====[mask issue]===========================================
bg=ff{1};%file;
masks={fullfile(g.path, 'ix_AVGTmask.nii');
    fullfile(g.path,'AVGTmask.nii');
    };
if ~isempty(p.mask)
    if exist(p.mask)==2
        [pa fi ext]=fileparts(p.mask);
        if isempty(pa); pa=g.path; end
        masks=[ fullfile(pa ,[fi ext])  ; masks];
    end
end
masks(find(existn(masks)==0))=[];
masks=unique(masks,'stable') ;


hb=spm_vol(bg); hb=hb(1);
sameorient=zeros(size(masks));
for i=1:length(masks)
    ha=spm_vol(masks{i}); ha=ha(1);
    e1=sum(abs(ha.dim-hb.dim))==0;
    e2=sum(abs(ha.mat(:)-hb.mat(:)))<1e-5;
    if e1+e2==2
        sameorient(i,1)=1;
    end
end
ix=min(find(sameorient==1));
if ~isempty(ix);   g.brainmask=masks{ix};
else           ;   g.brainmask='';         p.usemask=0;
end





%% ===============================================
g.file=cellstr(file); g.file=g.file(:);
makeplot(g,p);
filename=saveplot(g,p);
if nargout==1
    varargout{1}=filename;
end

% ==============================================
%%
% ===============================================



return


% ==============================================
%%   SAVE
% ===============================================



if p.save==1
    if isempty(p.savename)
        filenameout=fullfile(pwd,[g.file '.png'   ]) ;
    else
        [pax name ext]=fileparts(p.savename);
        if strcmp(pax,'$path'); pax=g.path; end
        if isempty(pax); pax=g.path; end
        if ~isempty(strfind(name,'$name'));
            name=strrep(name,'$name',g.file);
        end
        filenameout=fullfile(pax,[name '.png'   ]) ;
        
    end
    if p.vol>p.volsuffixstart % add volume
        if isempty(regexpi(filenameout,['_vol' pnum(2,p.voldigits) '.png$']));
            filenameout= stradd(filenameout,['_vol' pnum(2,p.voldigits) ],2);
        end
    end
    
    
    
    filename=filenameout;%fullfile(pwd,[g.file '.png'   ]) ;
    
    % Make sure printing uses the figure size
    % set(gcf,'visible','on')
    % set(gca,'units','normalized')
    % set(c,'units','normalized')
    %
    % set(hf,'Units','centimeters','Position',[2 2 12 6]);  % figure size in cm
    % set(hf,'PaperUnits','centimeters','PaperPosition',[0 0 12 6]);
    
    
    %% ===============================================
    if p.bgtransp==1; set(gcf,'InvertHardcopy','on' );
    else ;            set(gcf,'InvertHardcopy','off');
    end
    % set(gcf,'color',[1 0 1]);
    % set(findobj(gcf,'type','axes'),'color','none');
    
    q=filename;
    % set(hf,'InvertHardcopy','off');
    % print(hf,filename,'-dpng',['-r'  num2str(p.saveres) ], '-painters');
    print(hf,filename,'-dpng',['-r'  num2str(p.res) ]);
    
    
    if p.bgtransp==1 || p.crop==1;
        [im hv]=imread(filename);
        if p.crop==1;
            v=mean(double(im),3);
            v=v==v(1,1);
            v1=mean(v,1);  mima1=find(v1~=1);
            v2=mean(v,2);  mima2=find(v2~=1);
            do=[mima2(1)-1 mima2(end)+1];
            ri=[mima1(1)-1 mima1(end)+1];
            if do(1)<=0; do(1)=1; end; if do(2)>size(im,1); do(2)=size(im,1); end
            if ri(1)<=0; ri(1)=1; end; if ri(2)>size(im,2); ri(2)=size(im,2); end
            im=im(do(1):do(2),ri(1):ri(2),:);
        end
        if p.bgtransp==1
            imwrite(im,filename,'png','transparency',[1 1  1],'xresolution',p.res,'yresolution',p.res);
            
            % 'a'
            % ywid=size(im,1);
            % xwid=size(im,2);
            % xres=xwid./p.res
            
            
            %             imwrite(im,filename,'png','transparency',[1 1  1]);
            if 0
                imd=double(im);
                pix=squeeze(imd(1,1,:));
                m(:,:,1)=imd(:,:,1)==pix(1);
                m(:,:,2)=imd(:,:,2)==pix(2);
                m(:,:,3)=imd(:,:,3)==pix(3);
                m2=sum(m,3)~=3;
                imwrite(im,filename,'png','alpha',double(m2));
            end
            %         showinfo2(['saved png(resolution:' num2str(p.saveres)  ')'],filename);
            
            %
        else
            imwrite(im,filename,'png');
        end
    end
    
    showinfo2(['Chimap'],filename);
end
% ==============================================
%%
% ===============================================


if p.show==0
    if p.cf==1
        close(hf);
    end
end

if nargout>0
    varargout{1}=[];
    if p.save==1
        varargout{1}=filename;
        
    end
end



function makeplot(g,p)

% ==============================================
%%   get data
% ===============================================

ff=g.file;
if ischar(ff); ff=cellstr(ff); end



ns      =p.nslices;
nslice  =['n' num2str(ns)];
if ~isempty(p.slice)
    nslice=p.slice; 
end
if ~isempty(p.slicemm)
    nslice=''; 
end


volnr   =p.vol(1:length(ff));
ff=cellfun(@(a,b) {[   a ',' num2str(b) ]}, ff, num2cell(volnr(:)));

if ~isempty(g.brainmask)
    ff=[ff; [g.brainmask ',1' ]  ]   ; %add brainmask
end

m={};
for i=1:length(ff)
    if ~isempty(p.slicemm)
        if i==1
            [d ds]=getslices(ff{1}           ,p.dim,[],[p.slicemm],0 );
        else
            [d ds]=getslices({ff{1} [ff{i}]} ,p.dim,[],[p.slicemm],0 );
        end  
    else
        if i==1
            [d ds]=getslices(ff{1}           ,p.dim,[nslice],[],0 );
        else
            [d ds]=getslices({ff{1} [ff{i}]} ,p.dim,[nslice],[],0 );
        end
    end
    
    m{i,1}=d;
    m{i,2}=ds;
    if p.fliplr==1;        m{i,1}=flipdim(m{i,1},2);     end
    if p.flipud==1;        m{i,1}=flipdim(m{i,1},1);     end
end

if p.usemask==1;
    
    % specific mask with specific value to obtain mask
    if strcmp(p.mask,g.brainmask)==1
        if ~isempty(p.maskvalue)
            ma=m{end,1};
            if length(p.maskvalue)==1
                ma=double(m{end,1}==p.maskvalue);
            else
                ma2=ma(:);
                ma3=zeros(size(ma2));
                for ii=1:length(p.maskvalue)
                    ma3( find( ma2==p.maskvalue(ii) )    )=1;
                end
                ma=reshape(ma3,size(ma));
            end
            m{end,1}=ma;
        end
    end
    
    ds=sum(m{end,1},3)>0;  v=sum(ds,2)>0;        h=sum(ds,1)>0;
    bh=[min(find(h==1)) max(find(h==1))];
    bv=[min(find(v==1)) max(find(v==1))];
    for i=1:length(ff)
        d=m{i,1};
        d=d(bv(1):bv(2),bh(1):bh(2),:);
        m{i,1}=d;
    end
end
if p.usemask==0 && p.usemaskotsu==1
    mo=m{1,1};
    for i=1:size(mo,3)
        mo(:,:,i)=imfill(otsu(mo(:,:,i),p.maskOL)>1,'holes');
    end
    mo=bwareaopen(mo, 50);
    ds=sum(mo,3)>0;     v=sum(ds,2)>0;   h=sum(ds,1)>0;
    bh=[min(find(h==1)) max(find(h==1))];
    bv=[min(find(v==1)) max(find(v==1))];
    for i=1:length(ff)
        d=m{i,1};
        d=d(bv(1):bv(2),bh(1):bh(2),:);
        m{i,1}=d;
    end
end


for i=1:length(ff)
    if isempty(p.sb) || sum(isnan(p.sb))==2
        [m{i,3}, rowcols]=montageout( permute(m{i,1},[1 2 4 3]));
    else
        [m{i,3}, rowcols]=montageout( permute(m{i,1},[1 2 4 3]),'Size',[p.sb]);
    end
end

if ~isempty(g.brainmask)
    mask=m(end,:);
    m(end,:)=[];
else
    mask='';
end




% ==============================================
%%   plot
% ===============================================

vis='off'; if p.show==1  ; vis='on'; end
% figure('Visible',vis);
figure('Visible','off');
hf=gcf;
set(hf,'menubar','none');
hf=gcf;
set(gcf,'color',p.bgcol);
% axes('position',[0 0 .85 1],'tag','ax1');
ha=findobj(gcf,'type','axes','tag',['ax1' ]);
if isempty(ha);     set(ha,'tag',['ax1' ]);
else                set(gcf,'CurrentAxes',ha);  axexist=1;
end
delete(findobj(ha,'type','line'));
%--------------------------
clims=[];
cbarvisible=p.cbarvisible(1:size(m,1));
ncount_cbar=0;
for i=1:size(m,1)  % NIFTIS to overlay
    
    if i==1
        %cbarwid=.011/2
        wid=0.95-sum(cbarvisible).*0.1+0.05;
        ha=axes(hf,'position',[0 0 wid 1],'tag','ax1');
        %axes(ha);
        %set(gca,'position',[0 0 wid 1]);
    end
    
    
    
    F=m{i,3};
    
    if p.value0transp==1
        F(F==0)=nan;
    end
    % keepvalues
    %% ===============================================
    
   if ~isempty(p.keepvalue)
       is=find(cell2mat(p.keepvalue(:,1))==i);
       if ~isempty(is)
          vals=p.keepvalue{is,2};
          F0=F(:);
          FV=nan(size(F0));
          for jj=1:length(vals)
              FV( find(F0==vals(jj)),1 )=vals(jj);
          end
          F=reshape(FV,size(F)); 
       end 
   end
    
   
   %% ======pseudocolorize=========================================
   is=find(p.pcolor==i);
   if ~isempty(is)     %pseudocolorize if range is to large
       [vals, ~, idx] = unique(F(:));   % work on vector
       idx(find(isnan(F)))=nan;
       F2 = reshape(idx, size(F));
       F=F2;
   end
    %% ===============================================
    
    
    climF=p.clims(i,:);
    Fvec=F(:);
    %         Fvec=[x(1).a(:);x(2).a(:);x(3).a(:)];
    
    if isnan(climF(1))==1; climF(1)=min(Fvec)  ;end
    if isnan(climF(2))==1; climF(2)=max(Fvec)  ;end
    if climF(1)==climF(2); climF(2)=climF(2)+eps; end
    if isnan(climF(1))==1; climF(1)=0      ;end
    if isnan(climF(2))==1; climF(2)=0+eps  ;end
    %         p.clim(i,:)=climF;
    
    if i==1 &&  p.imadjust==1
        climF= [ prctile(F(:), 1)  prctile(F(:), 99)];
        if round(climF(2)-climF(1))>50
            climF=round(climF);
        end
    end
    if (abs((climF(2)-climF(1)))-eps)==0
        climF=   [climF(2)-0.0001  climF(2)+eps] ;
    end
%     if length(unique(climF))==1
%        climF= [ climF(1)-climF(1)-0.01-eps   climF(1)] ;
%     end


    if i==1 && ~isempty(p.brighter)
        climF= [ climF(1)  prctile(F(:), 100-p.brighter)];
        if round(climF(2)-climF(1))>50
            climF=round(climF);
        end
    end
    if i==1 && ~isempty(p.darker)
        climF= [  prctile(F(:), p.darker)  climF(2)];
        if round(climF(2)-climF(1))>50
            climF=round(climF);
        end
    end
    
    
    clims(i,:)=climF;
    
    %         if ord(j)==2
    %             F=flipud(F');
    %         end
    
    if i==1 %BRAINMASK
        if isempty(mask)
            Fm=F;
            Fm(isnan(Fm))=0;
            Bm=imfill(otsu(Fm,p.maskOL)>1,'holes');
        else
            Bm=mask{1,3};
        end
    end
    him2=findobj(ha,'type','image','tag',['im'  num2str(i)]);
    if isempty(him2)
        him2 = imagesc(F);
    else
        unfreezeColors(him2)
        him2.CData=F;
    end
    if i==1; axis off; end
    hold on;
    set(him2,'tag',['im'  num2str(i)]);
    if length(unique(climF))==2
    caxis(climF);
    else
%         'workxx'
    end
    
    
    % ### ALPHA #############
    %alphadata = p.alpha(i).*(F >= climF(1)); %prevous
    alphadata =ones(size(F))*p.alpha(i);
    if i>1
        alphadata=~isnan(F).*alphadata;    % issue with NAN --> become transparent
    end
    
    % ### THRESHOLD ############
    F(isnan(F))=0;
    athresh=(p.thresh(i,:));
    
    if any(athresh)==1
        if isnan(athresh(1))==0
            % alphadata=alphadata.*(F>athresh(1));
            alphadata(find(F<athresh(1)))=0;
        end
        if isnan(athresh(2))==0
            %alphadata=alphadata.*(F<athresh(2));
            alphadata(find(F>athresh(2)))=0;
            
        end
    end
    if p.maskBG==1
        alphadata=alphadata.*Bm;
    end
    
    set(him2,'AlphaData',alphadata);
    %---CMAP -------------
    if isnumeric(p.cmap)
        cmap=getCMAP(p.cmap(i));
    else
        p.cmap{i};
        cmap=getCMAP(p.cmap{i});
        if size(unique(cmap,'rows'),1) ==1 
           cmap= repmat(cmap,[64 1]);
        end
    end
    colormap(cmap); drawnow;
    freezeColors;%(him2);
    
    set(ha,'tag',['ax1']);
    %     if i==1
    %         %cbarwid=.011/2
    %         wid=0.95-sum(cbarvisible).*0.1+0.05;
    %         set(gca,'position',[0 0 wid 1]);
    %     end
    %
    
    if sum(cbarvisible)>0
        if cbarvisible(i)==1
            hc=findobj(gcf,'tag',['cbar' num2str(i)]);
            %delete(findobj(hf,'tag',['cbar' num2str(i)]));
            if isempty(hc)
                hc=jicolorbar('freeze');
                set(hc,'tag',['cbar' num2str(i)],'userdata','cbar');
                %                 set(hc,'position',[wid+(ncount_cbar*0.1) 0.4 .01 .15]);
                if [size(F,1)./size(F,2)]<1
                    fac= [size(F,1)./size(F,2)]./rowcols(1);
                else
                    fac= 1./rowcols(1) ;
                end
                cbarpos=p.cbarpos;
                if isnan(cbarpos(1)); cbarpos(1)=wid;     end
                cbarpos(1)=cbarpos(1)+(ncount_cbar*p.cbargap)+.01;
                if isnan(cbarpos(2)); cbarpos(2)=0.5-(fac/2);                 end
                if isnan(cbarpos(3)); cbarpos(3)=.011/2;                      end
                if isnan(cbarpos(4)); cbarpos(4)=fac;                         end
                %wid+(ncount_cbar*0.07)+.01 0.5-(fac/2) p.cbarwid fac
                set(hc,'position',[cbarpos ],'fontsize',p.cbarfs,...
                    'ycolor',p.fgcol);
                set(hc,'units','pixels');
                ncount_cbar=ncount_cbar+1;
                set_cbarticks(hc, clims(i,:) ,p);
            end
        end
        
    end
    
    
      %% ===============================================
    
      if ~isempty(p.contour)
          is=find(cell2mat(p.contour(:,1))==i);
          if ~isempty(is)
              try; F2=Bm.*F;
              catch; F2=F;
              end
              
              clevels=[];
              args={};
              try
                  args=p.contour{is,2};
                  is2=find(strcmp(args, 'levels')) ;
                  clevels=args{is2+1};
                  args([is2 is2+1]) =[];             
              end
              if [max(F2(:))-min(F2(:))]>1e6 %pseudocolorize if range is to large
                  [vals, ~, idx] = unique(F2(:));   % work on vector
                  F2 = reshape(idx, size(F2));     
              end
              
              if isempty(clevels);         [c hc]=contour(F2,'color','k');  
              else                         [c hc]=contour(F2,clevels,'color','k');  
              end
              try
                  %args=p.contour{is,2};
                  if ~isempty(args)
                      set(hc,args{:});
                  end
                  %evalc('set(hc,args{:})');
              end

          end
      end
    
    %% ===============================================
    
    
end
% set(ha,'YDir','normal');
set(ha,'NextPlot','add')
% axis tight;
axis image;
set(ha,'xticklabels',[],'yticklabels',[]);
axis off
%% =========[title]======================================
if ~isempty(p.title);
    ti=title(p.title,'fontsize',p.titlefs,'color',p.fgcol);
    %     axpos=get(ha,'position');
    if rowcols(1)<3
        set(ti,'VerticalAlignment','bottom');
    else
        set(ti,'VerticalAlignment','top');
    end
end
%% =========[msg]======================================

% p.msg=1%'';%{'www','ddddd',pwd}';
% % p.msg={'ddd'}
% p.msgpos=[0.005 0.005 1  .15 ];
% p.msgfs=9;
% p.msgcol='k';
% p.msgfont='consolas';
if ischar(p.msg) || iscell(p.msg)
    if isempty(char(p.msg)); p.msg=0; end
end
if isnumeric(p.msg) && p.msg==1
    [~,fnames, ext]=fileparts2(g.file);
    p.msg= {...
        ['dir  : ' g.animal  ]
        ['files: ' strjoin(cellfun(@(a,b) {[   a b ]}, fnames,ext),'|') ]
        ['path : ' g.path  ]
        };
end
% ===============================================
if ~isnumeric(p.msg); % ~isempty(char(p.msg))
    delete(findobj(hf,'tag','ax2'))
    ax2=axes(hf,'position',p.msgpos,'color','none','tag','ax2');
    axis off;
    te=text(0,0, p.msg);
    set(te,'VerticalAlignment','bottom','fontsize',p.msgfs,'color',p.msgcol,...
        'FontName',p.msgfont,'Interpreter','none');
    
end

if p.show==1
    set(hf,'Visible','on');
end
drawnow

%% ===============================================

% hf=gcf;
% hcs=findobj(hf,'userdata','cbar');
% hcs=flipud(hcs);
% u=get(hf,'userdata');
% for i=1:length(hcs)
% %     num=str2num(regexprep( get(hcs(i),'tag'),'cbar',''))
% %     lims=p.clim(num,:);
%     set_cbarticks(hcs(i), clims(i,:) ,p);
% end


% return




function filename=saveplot(g,p);
% ==============================================
%%   SAVE
% ===============================================
filename=[];
if p.save==1
    
    g.file=cellstr(g.file);
    hf=gcf;
    [~,g.name]=fileparts(g.file{end});
    
    if isempty(p.savename)
        filenameout=fullfile(pwd,[g.name '.png'   ]) ;
    else
        [pax name ext]=fileparts(p.savename);
        if strcmp(pax,'$path'); pax=g.path; end
        if isempty(pax); pax=g.path; end
        if ~isempty(strfind(name,'$name'));
            name=strrep(name,'$name',g.name);
        end
        filenameout=fullfile(pax,[name '.png'   ]) ;
        
    end
    if max(p.vol)>p.volsuffixstart % add volume
        if isempty(regexpi(filenameout,['_vol' pnum( max(p.vol) ,p.voldigits) '.png$']));
            filenameout= stradd(filenameout,['_vol' pnum(max(p.vol),p.voldigits) ],2);
        end
    end
    
    
    
    filename=filenameout;%fullfile(pwd,[g.file '.png'   ]) ;
    
    % Make sure printing uses the figure size
    % set(gcf,'visible','on')
    % set(gca,'units','normalized')
    % set(c,'units','normalized')
    %
    % set(hf,'Units','centimeters','Position',[2 2 12 6]);  % figure size in cm
    % set(hf,'PaperUnits','centimeters','PaperPosition',[0 0 12 6]);
    
    
    %% ===============================================
    if p.bgtransp==1; set(gcf,'InvertHardcopy','on' );
    else ;            set(gcf,'InvertHardcopy','off');
    end
    % set(gcf,'color',[1 0 1]);
    % set(findobj(gcf,'type','axes'),'color','none');
    
    q=filename;
    % set(hf,'InvertHardcopy','off');
    % print(hf,filename,'-dpng',['-r'  num2str(p.saveres) ], '-painters');
    print(hf,filename,'-dpng',['-r'  num2str(p.res) ]);
    
    
    if p.bgtransp==1 || p.crop==1;
        [im hv]=imread(filename);
        if p.crop==1;
            v=mean(double(im),3);
            v=v==v(1,1);
            v1=mean(v,1);  mima1=find(v1~=1);
            v2=mean(v,2);  mima2=find(v2~=1);
            do=[mima2(1)-1 mima2(end)+1];
            ri=[mima1(1)-1 mima1(end)+1];
            if do(1)<=0; do(1)=1; end; if do(2)>size(im,1); do(2)=size(im,1); end
            if ri(1)<=0; ri(1)=1; end; if ri(2)>size(im,2); ri(2)=size(im,2); end
            im=im(do(1):do(2),ri(1):ri(2),:);
        end
        if p.bgtransp==1
            imwrite(im,filename,'png','transparency',[1 1  1],'xresolution',p.res,'yresolution',p.res);
            
            % 'a'
            % ywid=size(im,1);
            % xwid=size(im,2);
            % xres=xwid./p.res
            
            
            %             imwrite(im,filename,'png','transparency',[1 1  1]);
            if 0
                imd=double(im);
                pix=squeeze(imd(1,1,:));
                m(:,:,1)=imd(:,:,1)==pix(1);
                m(:,:,2)=imd(:,:,2)==pix(2);
                m(:,:,3)=imd(:,:,3)==pix(3);
                m2=sum(m,3)~=3;
                imwrite(im,filename,'png','alpha',double(m2));
            end
            %         showinfo2(['saved png(resolution:' num2str(p.saveres)  ')'],filename);
            
            %
        else
            imwrite(im,filename,'png');
        end
    end
    
    showinfo2(['Chimap'],filename);
end
% ==============================================
%%
% ===============================================


if p.show==0
    if p.cf==1
        try
            close(hf);
        end
    end
end

if nargout>0
    varargout{1}=[];
    if p.save==1
        varargout{1}=filename;
        
    end
end



%% ===============================================
return














% if     p.flipud==0; set(gca,'ydir','normal');
% elseif p.flipud==1;set(gca,'ydir','reverse');
% end

% if     p.flipud==0; set(gca,'xdir','normal');
% elseif p.flipud==1;set(gca,'xdir','reverse');
% end
%% ===============================================


ax = gca;
set(gca,'units','normalized');
axpos=get(gca,'position');
set(gca,'position',[0 0 .85 1]);

% Get the full axes rectangle in figure units
ax.Units = 'pixels';
axPos = ax.Position;

% Get the effective data aspect ratio scaling
dasp = daspect(ax);   % [dx dy dz], should be [1 1 1] after axis image
pbas = pbaspect(ax);  % actual physical aspect ratio [X Y Z]

% Now, MATLAB shrinks one dimension of axPos to enforce square pixels
% The "real" displayed area is stored in ax.Position + aspect correction:
realPos = hgconvertunits(...
    gcf, axPos, ax.Units, 'pixels', gcf)  % ensures pixels

o5=get(findobj(ax,'tag','im1'),'CData');

% Apply aspect correction
realWidth  = realPos(3);
realHeight = realPos(3) * (size(o5,2)/size(o5,1));  % height adjusted to match image ratio

% Center vertically in the axes box
realY = realPos(2) + (realPos(4) - realHeight)/2;
realX = realPos(1);
realPos2 = [realX, realY, realWidth, realHeight]

axis on

% ==============================================
%%
% ===============================================
'a'
gap=150;
cbs=[];
freezeColors
delete(findobj(gcf,'tag','Colorbar'))
fg
for i=1:size(clims,1)
    %   ax=axes(gcf,'Position',[0.1,0.1,0.7,0.7]);
    sb=subplot(2,2,i)
    imagesc([clims(i,:)])
    colormap(p.cmap{i})
    cb=colorbar('eastoutside')
    %     freezeColors
    freezeColors(cb)
    
    tickv=makeTicks(clims(i,:))
    set(cb,'fontsize',p.cbarfs,'Ticks',cb.Limits, 'TickLabels',tickv,     'color',p.cbarcol);
    
    set(cb,'units','pixels')
    pos=get(cb,'position')
    
    drawnow; pause(1)
    set(sb,'position',[0.5 0.5 .01 .01])
    set(cb,'position',[40+i*gap pos(2)+10 5 50])
    
    
    %     pos2=[pos(1)+10 pos(2)+10 5 50]
    %     set(cb,'position',[pos(1)+i*gap pos(2)+10 5 50])
    %     freezeColors(cb)
    drawnow
    %     c.Ticks=[0 1];
    % c.TickLabels=tl2;
    
    
end
%% ===============================================



function tl2=makeTicks(tl)
% tl=p.clims;
% tl=[-1.0001 -1.0002]
for i=0:10
    tl2=arrayfun(@(x) sprintf(['%.' num2str(i) 'f' ], x), tl, 'UniformOutput', false);
    % if str2num(tl2{1})==round(str2num(tl2{1}));     tl2{1}=num2str(tl(1));end
    %  if str2num(tl2{2})==round(str2num(tl2{2}));     tl2{2}=num2str(tl(2));end
    if strcmp(tl2{1},tl2{2})==0;
        break
    end
end
if str2num(tl2{1})==round(str2num(tl2{1}));     tl2{1}=num2str(round(str2num(tl2{1})));end
if str2num(tl2{2})==round(str2num(tl2{2}));     tl2{2}=num2str(round(str2num(tl2{2})));end




function set_cbarticks(hc, lims,p)
%% ===============================================


% if 0
%     p.mcbarticks  =5           %number of ticks/ticklabels in colorbar
%     p.mcbardecimals=5           %number of decimals of ticklabels in colorbar
%     % set(hc,'ytick',lims,'yticklabels',lims);  %issue yticks 2759
%     lims=[-10 10]
% end


d=linspace(lims(1),lims(2),  p.cbarnticks);
isinteg=d==round(d);
if sum(isinteg)~=length(d)  % if there are number with fractions --> plot integers with fractions
    isinteg=isinteg.*0;
end
isinteg(find(d==0))=1; %set zero allwais to integer

if p.cbarintticks==1  %  force integer ticks if feasible, {0,1}
    if lims(2)-lims(1)>50  %force to no decimals
        isinteg=isinteg.*0+1;
    end
end

% ===============================================

% get smallest necessary number of deciamls to show the different values
ds=cellfun(@(a) {[  regexprep(num2str(sign(a)),{'-1','1','0'},{'-','+','0'})  regexprep(sprintf('%1.10f',a ),'.*\.','') ]},num2cell(d) )';
% dm=cell2mat(cellfun(@(a) {[ double(a) ]},ds))
ndecim=p.cbardecimals;
for i=1:size(ds{1,1},2)-1
    ndiffnumbers=length(   unique(cellfun(@(a) {[ a(1:1+i) ]},ds))    );
    if length(d)==ndiffnumbers
        ndecim=ndecim+i-1;
        break
    else
        
    end
    
end
% ===============================================
%allign pos/neg numbers: https://de.mathworks.com/matlabcentral/answers/169007-how-can-i-align-pos-neg-numbers-with-fprintf
s={};
for i=1:length(d)
    if isinteg(i)==1
       % s{i,1}= sprintf('%d',d(i));
        s{i,1}= sprintf('%0.0f',d(i));
    else
        s{i,1}= sprintf(['%.' num2str(ndecim) 'f'],d(i));
    end
end
yl=get(hc,'ylim');
if length(unique(s))==1
    if size(unique(squeeze(hc.Children.CData),'rows'),1)==1 %isocolor -->sed mid tick
        yt=mean(yl);
    else
        yt=max(yl);
    end
    set(hc,'ytick',yt,'yticklabels',s(1));
else
    
    set(hc,'ytick',d,'yticklabels',s);  %issue yticks 2759
end

%% ===============================================

% function old
% ns      =p.nslices;
% nslice  =['n' num2str(ns)];
% 
% 
% 
% 
% 
% % f1=fullfile(g.path ,p.mask);
% % f2=fullfile(pd,'chimap_MT.nii');
% % f2=file;
% 
% 
% 
% 
% 
% if exist(f1)~=2;
%     p.usemask=0;
%     f1=fullfile(g.path ,'AVGTmask.nii');
%     if exist(f1)==2
%         ha=spm_vol(f1); ha=ha(1);
%         hb=spm_vol(bg); hb=hb(1);
%         e1=sum(abs(ha.dim-hb.dim))==0;
%         e2=sum(abs(ha.mat(:)-hb.mat(:)))<1e-5;
%         if e1+e2==2
%             p.usemask=1;
%         else
%             p.usemask=0;
%         end
%         
%     end
%     
% end
% 
% f2v=[bg,',' num2str(p.vol)]; %explicit volumeNumber
% if p.usemask==1;
%     [d ds]=getslices(f1     ,p.dim,[nslice],[],0 );
%     [o os]=getslices({f1 [f2v]},p.dim,[nslice],[],0 );
%     ds=sum(d,3)>0;
%     v=sum(ds,2)>0;
%     h=sum(ds,1)>0;
%     bh=[min(find(h==1)) max(find(h==1))];
%     bv=[min(find(v==1)) max(find(v==1))];
%     d=d(bv(1):bv(2),bh(1):bh(2),:);
%     o=o(bv(1):bv(2),bh(1):bh(2),:);
% else
%     [d ds]=getslices(f2v     ,p.dim,[nslice],[],0 );
%     [o os]=getslices(f2v,p.dim,[nslice],[],0 );
% end
% 
% % d=permute(d,[2 1 3]);
% % o=permute(o,[2 1 3]);
% d=flipdim(d,1);
% o=flipdim(o,1);
% if p.usemask==1;
%     idel=find(squeeze(sum(sum(d,1),2))<100);
%     d(:,:,idel)=[];
%     o(:,:,idel)=[];
% end
% % nsh=ceil(size(d,3)/2);
% 
% if isempty(p.sb) || sum(isnan(p.sb))==2
%     d2=montageout( permute(d,[1 2 4 3]));
%     o2=montageout( permute(o,[1 2 4 3]));
% else
%     d2=montageout( permute(d,[1 2 4 3]),'Size',[p.sb]);
%     o2=montageout( permute(o,[1 2 4 3]),'Size',[p.sb]);
% end
% 
% %% ===============================================
% % % clear o4
% o3=o2;
% 
% % fg,imagesc(o3); caxis([-0.1 0.1]); colormap(gray);axis off;
% o3=o3(:);
% % o3(o3<-0.1)=-0.1;
% % o3(o3>+0.1)=+0.1;
% if isempty(p.clims(1)) || isnan(p.clims(1)); p.clims(1)=min(o3); end
% if isempty(p.clims(2)) || isnan(p.clims(2)); p.clims(2)=max(o3); end
% 
% % p.clims
% 
% o3(o3<p.clims(1))=p.clims(1);
% o3(o3>p.clims(2))=p.clims(2);
% o3=reshape(o3,size(o2));
% if p.flipud==1;     o3=flipdim(o3,1); end
% if p.fliplr==1;     o3=flipdim(o3,2); end
% % fg,imagesc(o3); caxis([-0.1 0.1]); colormap(gray);axis off
% A_min = min(o3(:));
% A_max = max(o3(:));
% o4 = (o3 - A_min) / (A_max - A_min);   % now scaled to [0,1]
% %  o4=uint8((o4.*255));
% % % A_norm = mat2gray(A, [low high]);   % values ≤ low → 0, values ≥ high → 1
% 
% if ~isempty( p.resize) && p.resize>0
%     o4 = imresize(o4, p.resize, 'nearest');   % 4× larger
% end
% % o4 = imresize(o4, [2 1], 'nearest');
% if p.imadjust==1;         o4=imadjust(o4);     end
% % if p.info==1
% %     t1=text2im([' file:  ' g.file g.ext    ]);
% %     t2=text2im(['  dir:  ' g.animal]);
% %     t3=text2im(['range: ['  [num2str(p.clims(1)) ' ' num2str(p.clims(2))] ']']);
% %     t1=imcomplement(t1);
% %     t2=imcomplement(t2);
% %     t3=imcomplement(t3);
% %     w1=zeros( 20*2+5  ,   size(o4,2) );
% %     w1(1:20, 1:size(t1,2) )=t1;
% %     w1(22+(1:20), 1:size(t2,2) )=t2;
% %     w1(end+1:end+size(t3,1), 1:size(t3,2) )=t3;
% %     % w1(end+1,: )=0;
% %     if size(o4,2)<size(w1,2)
% %         o4(:,end+1:size(w1,2))=0;
% %     end
% %     o5=[w1; o4];
% % else
% o5=o4;
% % end
% 
% 
% 
% 
% 
% %% ===============================================
% % cf
% vis='off'; if p.show==1  ; vis='on'; end
% % figure('Visible',vis);
% figure('Visible','off');
% hf=gcf;
% set(hf,'menubar','none');
% %  imagesc(o5);
% %  axis image;  % axis tight;
% %  axis off;
% imshow(o5)
% 
% % imshow(o5)
% % caxis([-0.1 0.1])
% % colormap(gray);
% colormap(p.cmap);
% c = colorbar('eastoutside');
% % cb=colorbar
% 
% % Lock the axes position in pixels
% ax = gca;
% set(gca,'units','normalized');
% axpos=get(gca,'position');
% set(gca,'position',[0 0 .85 1]);
% 
% % Get the full axes rectangle in figure units
% ax.Units = 'pixels';
% axPos = ax.Position;
% 
% % Get the effective data aspect ratio scaling
% dasp = daspect(ax);   % [dx dy dz], should be [1 1 1] after axis image
% pbas = pbaspect(ax);  % actual physical aspect ratio [X Y Z]
% 
% % Now, MATLAB shrinks one dimension of axPos to enforce square pixels
% % The "real" displayed area is stored in ax.Position + aspect correction:
% realPos = hgconvertunits(...
%     gcf, axPos, ax.Units, 'pixels', gcf);  % ensures pixels
% 
% % Apply aspect correction
% realWidth  = realPos(3);
% realHeight = realPos(3) * (size(o5,1)/size(o5,2));  % height adjusted to match image ratio
% 
% % Center vertically in the axes box
% realY = realPos(2) + (realPos(4) - realHeight)/2;
% realX = realPos(1);
% realPos = [realX, realY, realWidth, realHeight];
% 
% 
% % ===============================================
% 
% 
% % realPos=get(gca,'position')
% 
% if ~isempty(p.title);
%     ti=title(p.title,'fontsize',p.titlefs);
% end
% 
% 
% 
% 
% 
% % Create the colorbar
% 
% 
% % pos = ax.Position;        % axes position (normalized units by default)
% % inset = ax.TightInset;    % space reserved for ticks, labels
% 
% % Actual rectangle occupied by the axes (in figure units):
% % realPos = [pos(1)+inset(1), pos(2)+inset(2), ...
% %            pos(3)-inset(1)-inset(3), pos(4)-inset(2)-inset(4)];
% 
% % Now move the colorbar 5 pixels to the right of the image
% set(c, 'Units', 'pixels');
% cPos = get(c, 'Position');
% 
% % Adjust position: keep same height, shift right by 5 pixels
% cPos(1) = realPos(1) + realPos(3) + 2;   % x = right edge of axes + 5 pixels
% % cPos(2) = realPos(2);                  % align vertically
% cPos(3) = 10;                   % keep width
% if realPos(4)>70
%     cPos(4) = 70;                  % match height of image
% else
%     cPos(4) = realPos(4);
% end
% cPos(3) = round(cPos(4))*0.15;
% if cPos(2)<15; cPos(2)=15; end
% set(c, 'Position', cPos);
% %% ===============================================
% 
% % set(gca,'units','normalized');
% % set(c,'units','normalized');
% % axpos=get(gca,'position');
% % cpos=get(c,'position');
% % set(c,'position',[ axpos(3) cpos(2:end) ])
% 
% %% ===============================================
% tl=p.clims;
% % tl=[-1.0001 -1.0002]
% for i=0:10
%     tl2=arrayfun(@(x) sprintf(['%.' num2str(i) 'f' ], x), tl, 'UniformOutput', false);
%     % if str2num(tl2{1})==round(str2num(tl2{1}));     tl2{1}=num2str(tl(1));end
%     %  if str2num(tl2{2})==round(str2num(tl2{2}));     tl2{2}=num2str(tl(2));end
%     if strcmp(tl2{1},tl2{2})==0;
%         break
%     end
% end
% if str2num(tl2{1})==round(str2num(tl2{1}));     tl2{1}=round(str2num(tl2{1}));end
% if str2num(tl2{2})==round(str2num(tl2{2}));     tl2{2}=round(str2num(tl2{2}));end
% 
% % tl=cellfun(@(a) {[  num2str(a) ]},num2cell((tl)));
% c.Ticks=[0 1];
% c.TickLabels=tl2;
% set(c,'fontsize',p.cbarfs,'color',p.cbarcol);
% if p.show==1
%     set(hf,'Visible','on');
% end
% 

%% ===============================================
% if 0
%     filename=fullfile(pwd,[g.file '.png'   ]) ;
%     print(filename,'-dpng','-r600');  % 600 DPI resolution
%     showinfo2(['Chimap'],filename);
% end
%% ===============================================

