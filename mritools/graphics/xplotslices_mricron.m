
% PLOT SLICE OVERLAYS USING MRICRON 
% *** WINDOWS ONLY ***
% 
%% #wb *** PARAMETER *** 
%     'bg_image'      background image, if empty, than "AVGT.nii" from template-folder is used
%     'ovl_images'    one/more images to separately overlay onto bg_image
%     'view'          view: {coronal/sagittal/axial} ; default: 'coronal' 
%     'slices'        slices to plot
%                      [1] as numeric array to use slice-indices
%                         -AVGT-coronal:[60,73,86,99,112,125,138]            -->  [60,73,86,99,112,125,138] 
%                         -AVGT-coronal:[80,95,110,125,140,155,170,185,200]  -->  [80,95,110,125,140,155,170,185,200] 
%                         -AVGT-coronal:[80,95,110,125,140,155,170,185,200]  -->  [80,95,110,125,140,155,170,185,200] 
%                         -AVGT-coronal:[50,62,74,87,99,111,123,136,148,160] -->  [50,62,74,87,99,111,123,136,148,160]
%                         -AVGT-coronal:[50,83,115,148,180]                  -->  [50,83,115,148,180]   
%                         -slices index: from 50 to 150, 6 slices            -->[50:6:150]  
%                      [2] as string to work with voxel-milimeters (mm)
%                         -slices in mm: 0mm,1.1mm,2.135mm,-0.1mm            -->  '0,1.1,2.135,-0.1'   defined as string
%                      [3] as string to obtain a defined number of slices
%                         -5 equidistant slices      -->   'n5'  
%                         -8 equidistant slices'     -->   'n8'  
%                         -10 equidistant slices'    -->   'n10'  
%                         -cut 20% left and right (=40%)  and plot 12 equidistant slices --> 'cut40n12' 
%                         -cut 35% left and right (=70%)  and plot 6 equidistant slices  --> 'cut70n6'  
%                         -cut 45% left and right (=90%)  and plot 6 equidistant slices  --> 'cut90n6'  
%                         -cut 50% left and plot 5 equidistant slices                    --> 'cutL50n5'  
%                         -cut 50% right and plot 5 equidistant slices                   --> 'cutR50n5' 
%     
%     'bg_clim'        background-image: intensity limits [min,max], if [nan nan]..automatically defined
%                           examples: [0 200 ] or [nan nan]
%     'ovl_cmap'       overlay-image: colormap --> see icon for colormap' 
%     'ovl_clim'       overlay-image: intensity limits [min,max], if [nan nan]..automatically defined
%                            examples: [0 200 ] or [nan nan]
%     'opacity'        opacity of the overlayed image : -1,0,20,40,50,60,80,100. 
%                          A value of -1 signifies additive color blending'  
% 
%     'orthoview'     show orthogonal plot where brain is sliced; {0|1}'
%                         default: [1]
%     'slicelabel'    add slice label , this is the rounded mm-cordinate); {0|1}
%                        NOT RECOMMENDED (rounded value by MRICRON)
%     'OverslicePct'  percent overlapp of slices', range is from [-100:10:100]
%                        default: [0]
%     'cbar_label'    colorbar label, define a label for the colorbar, if empty colorbar has no label
%                         examples: 'lesion [%]' or  'intensity [a.u.]'
%     'cbar_fs'       colorbar-fonsize: default: [12]
%     'cbar_fcol'     colorbar-fontcolor a color' , use icon to obtain a color
%                         default:  [1 1 1] (white)
%     'outdir'        output-directory, if empty plots/ppt-file are genereated in the DIR of the ovl_images 
%                         default: ''
%     'ppt_filename'  powerpoint-filename which is generated
%                          example: 'lesion' 
%     'plotdir_suffix' This subfolder contains the png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix" 
%     
%     'closeMricron'  1  'close mricron afterwards'  'b'
% 
%% #wb *** RUN *** 
% xplotslices_mricron(1) or  xplotslices_mricron    ... open PARAMETER_GUI 
% xplotslices_mricron(0,z)             ...NO-GUI,  z is the predefined struct 
% xplotslices_mricron(1,z)             ...WITH-GUI z is the predefined struct 
% 
% 
%% #wb *** EXAMPLES *** 
% 
%% EXAMPLE: coronal ===============================================
%     z=[];                                                                                                                                                                                                       
%     z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used                             
%     z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image                                              
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'                                                                                                                 
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };                                                                                                              
%     z.view           = 'coronal';                                                                      % % view: {coronal/sagittal/axial}                                                                       
%     z.slices         = [80  95  110  125  140  155  170  185  200];                                    % % slices to plot                                                                                       
%     z.bg_clim        = [0  200];                                                                       % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                    
%     z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap                                                                              
%     z.ovl_clim       = [0  50];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                       
%     z.opacity        = [50];                                                                           % % opacity: -1,0,20,40,50,60,80,100. A value of -1 signifies additive color blending                    
%     z.orthoview      = [1];                                                                            % % show orthogonal plot where brain is sliced; {0|1}                                                    
%     z.slicelabel     = [1];                                                                            % % add slice label  (rounded mm); {0|1}                                                                 
%     z.OverslicePct   = [0];                                                                            % % percent overlapp slices                                                                              
%     z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label                                                          
%     z.cbar_fs        = [12];                                                                           % % colorbar: fonsize                                                                                    
%     z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color                                                                          
%     z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images                                     
%     z.ppt_filename   = 'lesion33';                                                                     % % PPT-filename                                                                                         
%     z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"  
%     z.closeMricron   = [1];                                                                            % % close mricron afterwards                                                                             
%     xplotslices_mricron(1,z); 
% 
%% EXAMPLE: sagittal ===============================================
%     z=[];                                                                                                                                                                                                       
%     z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used                             
%     z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image                                              
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'                                                                                                                 
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };                                                                                                              
%     z.view           = 'sagittal';                                                                     % % view: {coronal/sagittal/axial}                                                                       
%     z.slices         = 'cutR50n6';                                                                     % % slices to plot                                                                                       
%     z.bg_clim        = [0  200];                                                                       % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                    
%     z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap                                                                              
%     z.ovl_clim       = [0  50];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                       
%     z.opacity        = [50];                                                                           % % opacity: -1,0,20,40,50,60,80,100. A value of -1 signifies additive color blending                    
%     z.orthoview      = [1];                                                                            % % show orthogonal plot where brain is sliced; {0|1}                                                    
%     z.slicelabel     = [1];                                                                            % % add slice label  (rounded mm); {0|1}                                                                 
%     z.OverslicePct   = [0];                                                                            % % percent overlapp slices                                                                              
%     z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label                                                          
%     z.cbar_fs        = [12];                                                                           % % colorbar: fonsize                                                                                    
%     z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color                                                                          
%     z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images                                     
%     z.ppt_filename   = 'lesion33';                                                                     % % PPT-filename                                                                                         
%     z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"  
%     z.closeMricron   = [1];                                                                            % % close mricron afterwards                                                                             
%     xplotslices_mricron(1,z);
% 
%% EXAMPLE: AXIONAL ===============================================
%     z=[];                                                                                                                                                                                                       
%     z.bg_image       = 'F:\data8\mricron_makeSlices_plots\AVGT.nii';                                   % % background image, if empty, than "AVGT.nii" from template-folder is used                             
%     z.ovl_images     = { 'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_HET.nii'       % % get one/more images to separately overlay onto bg_image                                              
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_KO.nii'                                                                                                                 
%                          'F:\data8\mricron_makeSlices_plots\MAPpercent_x_masklesion_24h_WT.nii' };                                                                                                              
%     z.view           = 'axial';                                                                     % % view: {coronal/sagittal/axial}                                                                       
%     z.slices         = 'cut50n5';                                                                     % % slices to plot                                                                                       
%     z.bg_clim        = [0  200];                                                                       % % background-image: intensity limits [min,max], if [nan nan]..automatically defined                    
%     z.ovl_cmap       = 'actc.lut';                                                                     % % overlay-image: colormap                                                                              
%     z.ovl_clim       = [0  50];                                                                        % % overlay-image: intensity limits [min,max], if [nan nan]..automatically defined                       
%     z.opacity        = [50];                                                                           % % opacity: -1,0,20,40,50,60,80,100. A value of -1 signifies additive color blending                    
%     z.orthoview      = [1];                                                                            % % show orthogonal plot where brain is sliced; {0|1}                                                    
%     z.slicelabel     = [1];                                                                            % % add slice label  (rounded mm); {0|1}                                                                 
%     z.OverslicePct   = [0];                                                                            % % percent overlapp slices                                                                              
%     z.cbar_label     = 'lesion [%]';                                                                   % % colorbar: label, if empty cbar has no label                                                          
%     z.cbar_fs        = [12];                                                                           % % colorbar: fonsize                                                                                    
%     z.cbar_fcol      = [1  1  1];                                                                      % % colorbar: fontcolor a color                                                                          
%     z.outdir         = '';                                                                             % % output-dir, if empty plots/ppt-file in the DIR of the ovl_images                                     
%     z.ppt_filename   = 'lesion33';                                                                     % % PPT-filename                                                                                         
%     z.plotdir_suffix = '_plots';                                                                       % % DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix"  
%     z.closeMricron   = [1];                                                                            % % close mricron afterwards                                                                             
%     xplotslices_mricron(1,z);

function [z]=xplotslices_mricron(showgui,x,pa)


%===========================================
%%   PARAMS
%===========================================
isExtPath=0; % external path
if exist('pa')==1 && ~isempty(pa)
    isExtPath=1;
end

if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if isExtPath==0      ;    pa=antcb('getsubjects')  ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end



% ==============================================
%%   PARAMETER-gui
% ===============================================
if exist('x')~=1;        x=[]; end



% clipboard('copy',['[' regexprep(num2str(80:15:200),'\s+',',') ']'])

viewopt={};
viewopt(end+1,:)={'coronal'             'coronal' };
viewopt(end+1,:)={'sagittal'            'sagittal' };
viewopt(end+1,:)={'axial'               'axial'  };

sliceopt={};
sliceopt(end+1,:)={'AVGT-coronal:[60,73,86,99,112,125,138]'             [60,73,86,99,112,125,138] };
sliceopt(end+1,:)={'AVGT-coronal:[80,95,110,125,140,155,170,185,200]'   [80,95,110,125,140,155,170,185,200]   };
sliceopt(end+1,:)={'AVGT-coronal:[80,95,110,125,140,155,170,185,200]'   [80,95,110,125,140,155,170,185,200]   };
sliceopt(end+1,:)={'AVGT-coronal:[50,62,74,87,99,111,123,136,148,160]'  [50,62,74,87,99,111,123,136,148,160]   };
sliceopt(end+1,:)={'AVGT-coronal:[50,83,115,148,180]]'                  [50,83,115,148,180]   };
sliceopt(end+1,:)={'slices index: from 50 to 150, 6 slices [50:6:150]'        '50:6:150'   };
sliceopt(end+1,:)={'slices index: from 80 to 200, 10 slices[80:10:200]'       '80:10:200'  };
sliceopt(end+1,:)={'slices in mm: 0mm,1.1mm,2.135mm,-0.1mm'              '0,1.1,2.135,-0.1'  };
sliceopt(end+1,:)={'5 equidistant slices'              'n5'   };
sliceopt(end+1,:)={'8 equidistant slices'              'n8'   };
sliceopt(end+1,:)={'10 equidistant slices'             'n10'  };
sliceopt(end+1,:)={'cut 20% left and right (=40%)  and plot 12 equidistant slices'            'cut40n12'  };
sliceopt(end+1,:)={'cut 35% left and right (=70%)  and plot 6 equidistant slices'             'cut70n6'  };
sliceopt(end+1,:)={'cut 45% left and right (=90%)  and plot 6 equidistant slices'             'cut90n6'  };
sliceopt(end+1,:)={'cut 50% left and plot 5 equidistant slices'                               'cutL50n5'  };
sliceopt(end+1,:)={'cut 50% right and plot 5 equidistant slices'                              'cutR50n5'  };


exefile     =fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','mricron.exe' );
lutdir=(fullfile(fileparts(exefile),'lut'));
[luts] = spm_select('List',lutdir,'.lut'); luts=cellstr(luts);


p={
    'inf0'  '*** WINDOWS ONLY ***' '' ''
    'bg_image'      ''              'background image, if empty, than "AVGT.nii" from template-folder is used' 'f'
    'ovl_images'    ''              'get one/more images to separately overlay onto bg_image' 'mf'
    'view'         'coronal'        'view: {coronal/sagittal/axial} '   viewopt
    'slices'       '-2.5,-2,1,2.3'  'slices to plot-->see help/icon'   sliceopt  %[60,73,86,99,112,125,138]
    
    'inf1'  '' '' ''
    'inf11'  '' '' ''
    'bg_clim'         [0 200 ]           'background-image: intensity limits [min,max], if [nan nan]..automatically defined' {[0 200 ]; [nan nan]}
    'ovl_cmap'        'NIH_fire.lut'     'overlay-image: colormap ' {'cmap',luts'}
    'ovl_clim'        [0 100 ]           'overlay-image: intensity limits [min,max], if [nan nan]..automatically defined' {[0 200 ]; [nan nan]}
   
  
    'inf2' '' '' ''
    'opacity'        50   'opacity: -1,0,20,40,50,60,80,100. A value of -1 signifies additive color blending'  {-1,0,20,40,50,60,80,100}'
    'orthoview'     [1]   'show orthogonal plot where brain is sliced; {0|1}' 'b'
    'slicelabel'    [1]   'add slice label  (rounded mm); {0|1}'    'b'   
    'OverslicePct'  [0]   'percent overlapp slices'  num2cell([-100:10:100]')
    
   
    'cbar_label'      'lesion [%]'  'colorbar: label, if empty cbar has no label' {'lesion [%]'; 'intensity [a.u.]'}
    'cbar_fs'         12            'colorbar: fonsize'     [num2cell(7:30)']
    'cbar_fcol'       [1 1 1]       'colorbar: fontcolor a color'                         'col'
    
    
    'inf33'  '___OUTPUT-PARAMETER___' '' ''
    'outdir'         ''           'output-dir, if empty plots/ppt-file in the DIR of the ovl_images'   'd' ;% {@selector2,li,{'SourceImage'},'out','list','selection','single','position','auto','info','select source-image'}
    'ppt_filename'   'lesion'     'PPT-filename'  {'incidencemaps' '_test2'}
    'plotdir_suffix' '_plots'      'DIR contains png-files(located in "outdir"), DIR-name is defined by "ppt_filename"+"plotdir_suffix" '         {'_plots' '_figs'}
    
    'inf4'  '___misc___' '' ''
    'closeMricron'  1  'close mricron afterwards'  'b'
    
    };
% [m z]=paramgui(p,'close',1,'figpos',[0.2 0.4 0.5 0.35],'info',{@uhelp, 'paramgui.m' },'title','GUI-123'); %%START GUI
%% ====[test]===========================================
% if 1
%     cprintf('*[1 0 1]',[ '   TESTDATA'  '\n'] );
%     pa='F:\data8\mricron_makeSlices_plots';
%     f1=fullfile(pa,'AVGT.nii');
%     % f2=fullfile(pa,'MAPpercent_x_masklesion_24h_KO.nii')
%     [ovl] = spm_select('FPList',pa,'^MAP.*.nii');
%     ovl=cellstr(ovl);
%     ovl=ovl(1);
%     p(find(strcmp(p(:,1),'bg_image')),2)={f1};
%     p(find(strcmp(p(:,1),'ovl_images')),2)={ovl};
% end
%% ===============================================

% NIH_ice.lut'

p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .6 .46 ],...
        'title',[ '[' mfilename '.m]'],'info',{@uhelp, [mfilename '.m']});
    if isempty(m);
        return;
    end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end
% ==============================================
%%   BATCH
% ===============================================
try
    isDesktop=usejava('desktop');
    % xmakebatch(z,p, mfilename,isDesktop)
    if isExtPath==0
        batch=  xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z);' ]);
    else
        batch=  xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z,mdirs);' ],pa);
    end
end




%% ===============================================

z_bk=z;

% ==============================================
%%  proc
% https://people.cas.sc.edu/rorden/mricron/bat.html
% ===============================================

%% ====define parameter===========================================
z.bg_image   =char(   z.bg_image);
z.ovl_images =cellstr(z.ovl_images);
z.outdir     =char(   z.outdir);
[~, z.ppt_filename] =fileparts(z.ppt_filename);
if isempty(z.ppt_filename); z.ppt_filename='test123'; end



global an
if isempty(an)
    studydir=fileparts(z.ovl_images{1});
else
    studydir=fileparts(an.datpath);
end
if isempty(z.outdir)
   z.outdir=fullfile(studydir,'results'); 
end
if exist(z.outdir)~=7; mkdir(z.outdir); end
if isempty(z.bg_image)
    z.bg_image=fullfile(studydir, 'templates','AVGT.nii');
end
viewtb={...
    'coronal'   3
    'sagittal'  2
    'axial'     1 };
if ischar(z.view)
    z.view=viewtb{strcmp(viewtb(:,1),z.view),2};
end

hb=spm_vol(z.bg_image);
[bb vox]= world_bb(z.bg_image);

if ischar(z.slices)
    if ~isempty(strfind(z.slices,':'))  %from-to
        eval(['slices=' z.slices ';']);
    elseif ~isempty(strfind(z.slices,'n'))  %n-slices
        if ~isempty(strfind(z.slices,'cutR'))
            cut     =str2num(regexprep(z.slices,{'n\d+' ,'\D'},''));
            numslices=str2num(regexprep(z.slices,{'cutR\d+' ,'\D'},''));
            cutidx=round((cut*hb.dim/100)); %onesided
            if z.view==3
                slices=round(linspace(2,hb.dim([2])-cutidx(2),numslices));
            elseif z.view==2
                slices=round(linspace(2,hb.dim([1])-cutidx(1),numslices));
            elseif z.view==1
                slices=round(linspace(2,hb.dim([3])-cutidx(3),numslices));
            end
        elseif ~isempty(strfind(z.slices,'cutL'))
            cut     =str2num(regexprep(z.slices,{'n\d+' ,'\D'},''));
            numslices=str2num(regexprep(z.slices,{'cutL\d+' ,'\D'},''));
            cutidx=round((cut*hb.dim/100)); %onesided
            if z.view==3
                slices=round(linspace(cutidx(2),hb.dim([2]),numslices));
            elseif z.view==2
                slices=round(linspace(cutidx(1),hb.dim([1]),numslices));
            elseif z.view==1
                slices=round(linspace(cutidx(3),hb.dim([3]),numslices));
            end
        elseif ~isempty(strfind(z.slices,'cut'))
            cut     =str2num(regexprep(z.slices,{'n\d+' ,'\D'},''));
            numslices=str2num(regexprep(z.slices,{'cut\d+' ,'\D'},''));
            cutidx=round((cut*hb.dim/100/2)); %twosided
            if z.view==3
                slices=round(linspace(cutidx(2),hb.dim([2])-cutidx(2),numslices));
            elseif z.view==2
                slices=round(linspace(cutidx(1),hb.dim([1])-cutidx(1),numslices));
            elseif z.view==1
                slices=round(linspace(cutidx(3),hb.dim([3])-cutidx(3),numslices));
            end
            
        else
            numslices=str2num(strrep(z.slices,'n',''));
            if z.view==3
                slices=round(linspace(2,hb.dim([2])-1,numslices));
            elseif z.view==2
                slices=round(linspace(2,hb.dim([1])-1,numslices));
            elseif z.view==1
                slices=round(linspace(2,hb.dim([3])-1,numslices));
            end
        end
    else  % mm-approach
        
        slicemm=str2num(z.slices);
        if z.view==3
            mm=linspace(bb(1,[2]),bb(2,[2]),hb.dim([2]));
            slices=vecnearest2(mm, slicemm);
        elseif z.view==2
            mm=linspace(bb(1,[1]),bb(2,[1]),hb.dim([1]));
            slices=vecnearest2(mm, slicemm);
        elseif z.view==1
            mm=linspace(bb(1,[3]),bb(2,[3]),hb.dim([3]));
            slices=vecnearest2(mm, slicemm);
        end
    end
else
    slices=z.slices ;
end

%get mm-cords
if z.view==3
    mm=linspace(bb(1,[2]),bb(2,[2]),hb.dim([2]));
    slicemm_str=['[' regexprep(num2str(mm(slices)),'\s+',',') ']'];
elseif z.view==2
    mm=linspace(bb(1,[1]),bb(2,[1]),hb.dim([1]));
    slicemm_str=['[' regexprep(num2str(mm(slices)),'\s+',',') ']'];
elseif z.view==1
    mm=linspace(bb(1,[3]),bb(2,[3]),hb.dim([3]));
    slicemm_str=['[' regexprep(num2str(mm(slices)),'\s+',',') ']'];
end


% slices    =regexprep(num2str(z.slices(:)'),'\s+',',');
slice_index_str =['[' regexprep(num2str(slices(:)'),'\s+',',') ']'];

%% ===============================================
% 
% cf;clear;
% clc
% pa='F:\data8\mricron_makeSlices_plots';
% f1=fullfile(pa,'AVGT.nii');
% % f2=fullfile(pa,'MAPpercent_x_masklesion_24h_KO.nii')
% 
% [ovl] = spm_select('FPList',pa,'^MAP.*.nii');
% ovl=cellstr(ovl);
% 
% p.slices=[60,73,86,99,112,125,138];
% % p.slices=[60:10:100];
% p.orient =3 ;
% p.lim    =[ 10 80 ];
% % p.cmapname='actc.lut'
% p.cmapname='NIH_fire.lut';
% p.orthoview=1;
% p.slicelabel=1;
% p.sliceoverlap=0;
% 
% p.cmap_label= 'Power (db)'
% p.cmap_fs   = 12;
% 
% p.ppt_filename='test';
% p.ppt_title='Lesion Incidencemaps';

%% ===============================================
% temp to be shure
clear p
clear pa

%% ===============================================


outdir=z.outdir;
outdirplot=fullfile(outdir, [ [z.ppt_filename z.plotdir_suffix]]);
if exist(outdirplot)~=7; mkdir(outdirplot); end
delete(fullfile(outdirplot ,'*.png'));

exefile     =fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','mricron.exe' );
inifilebase =fullfile(fileparts(exefile),'mricron.ini');
inifile     =fullfile(outdirplot,'mricron.ini');
copyfile(inifilebase,inifile,'f');


slices_insert=regexprep(num2str(slices(:)'),'\s+',',');

msfile=fullfile(outdirplot,'multislice.ini');
ms=...
    {
    '[STR]'
    ['Slices=' slices_insert]  %60,73,86,99,112,125,138'
    '[BOOL]'
    ['OrthoView='  num2str(z.orthoview)]
    ['SliceLabel=' num2str(z.slicelabel)]
    '[INT]'
    ['Orient='  num2str(z.view) ]%'Orient=3'
    ['OverslicePct=' num2str(z.OverslicePct)]
    };
pwrite2file(msfile,ms);
% showinfo2(['msfile:'],msfile);


lutdir=(fullfile(fileparts(exefile),'lut'));
[luts] = spm_select('List',lutdir,'.lut'); luts=cellstr(luts);
% luttb=[num2cell([1:length(luts)]'-1)  luts];
cmapname=z.ovl_cmap;
% cmapnum =find(strcmp(luttb(:,2), cmapname));
[o o2]=getCMAP(cmapname);
call='';
endtag=' &';
if exist(exefile)==2
    call=[call  exefile  ' '];
end

% ==============================================
%%   loop over images
% ===============================================
ovl=z.ovl_images;
f1 =z.bg_image;
opacity=z.opacity;
if z.opacity>0
    opacity=100-z.opacity;
end

pnglist={};
for i=1:length(ovl)
    f2=ovl{i};
    [~, name,ext]=fileparts(f2);
    
    if any(isnan(z.bg_clim))
        bglims='';
    else
      bglims =[ ' -l ' num2str(z.bg_clim(1)) ' -h ' num2str(z.bg_clim(2))];
    end
    p1=[' -m ' msfile ' -c -0 ' bglims ' -b ' num2str(opacity) ];
    
    if any(isnan(z.ovl_clim))
        ovlims='';
    else
        ovlims =[ ' -l ' num2str(z.ovl_clim(1)) ' -h ' num2str(z.ovl_clim(2))];
    end
    
%     img2para=[' -c -' num2str(cmapnum) ' -l ' num2str(p.lim(1)) ' -h ' num2str(p.lim(2)) ' ']
     p2=[' -c ' cmapname ' ' ovlims ' '];
    [status]= system([call   f1 p1   ' -o '  f2  p2 endtag]);
    
    
    % ==============================================
    %%   automate
    % ===============================================

    n_attempts  =2;
    issuccess   =0;
    
    for j=1:length(n_attempts)
        if issuccess==0;
            [fistemp] = spm_select('FPList',outdirplot,'_temp123*.png');
            while ~isempty(fistemp)
                delete(fullfile(outdirplot ,'_temp123*.png'));
                [fistemp] = spm_select('FPList',outdirplot,'_temp123*.png');
            end
            pause(.5);
            f3=fullfile(outdirplot,[repmat('_temp123' ,[1 2])]);
            h = actxserver('WScript.Shell');
            h.AppActivate('MultiSlice'); h.SendKeys('%{F}a');pause(.5); h.SendKeys([f3 '{ENTER}']);
            fis='';
            n=0;
            dorun=1;
            tic_max=tic;
            while  dorun==1 % exist(fis)~=2
                [fis] = spm_select('FPList',outdirplot,'_temp123.png');
                % fis=fullfile(outdirplot, '_temp123.png')
                drawnow;
                if isnumeric(fis); fis=''; end
                n=n+1;
                if exist(fis)==2 ;            dorun=0;        end
                if toc(tic_max)>2;            dorun=0;        end
            end
            
            
            
            [fis] = spm_select('FPList',outdirplot,'_temp123.png');
            f4=fullfile(outdirplot,[ 'p_' pnum(i,2) '_' name  '.png']);
            pause(.5);
            [status,message,messageid]=movefile(fis,f4,'f');
        end
        if status==1
            issuccess=1;
        end
        
    end
    %showinfo2(['png:'],f4);
    
    %% ===============================================
    
    
    if z.closeMricron==1
        rclosemricron
    end
    pnglist(end+1,1)={f4};
end



% ==============================================
%%   colorbar
% ===============================================
% cf;
delete(findobj(0,'tag','colorbarTemp'));
fg; hf=gcf;
set(hf,'tag','colorbarTemp')
set(gcf,'position',[ 585   421   100   189] );


ax = axes;
c = colorbar(ax);
colormap(o)
ax.Visible = 'off';
caxis(z.ovl_clim);
set(c,'fontsize',z.cbar_fs,'fontweight','bold');
set(hf,'menubar','none');
set(hf,'color','none');
set(gca,'color','none');
c.Color=z.cbar_fcol;
c.Label.String  = z.cbar_label;
c.FontSize      =z.cbar_fs;
c.Label.FontSize=z.cbar_fs;

pos=get(c,'position');
set(c,'position',[pos(1)-.5 pos(2) pos(3)+0.05 pos(4) ]);
set(c, 'YAxisLocation','right');

%% ===============================================

set(gca,'units','pixels')
set(hf,'units','pixels')
%% ===============================================
p.bgtransp =0;
p.saveres  =200;
p.crop     =0;
file_legend=fullfile(outdirplot,'legend.png');

if p.bgtransp==1; set(hf,'InvertHardcopy','on' );
else ;            set(hf,'InvertHardcopy','off');
end
% set(gcf,'color',[1 0 1]); 
% set(findobj(gcf,'type','axes'),'color','none');
% set(hf,'InvertHardcopy','off');
% print(hf,file_legend,'-dpng',['-r'  num2str(p.saveres) ], '-painters');
print(hf,file_legend,'-dpng',['-r'  num2str(p.saveres) ]);
% showinfo2(['legend:'],file_legend);

if p.bgtransp==1 || p.crop==1;
    [im hv]=imread(file_legend);
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
        imwrite(im,file_legend,'png','transparency',[1 1  1],'xresolution',p.saveres,'yresolution',p.saveres);
        if 0
            imd=double(im);
            pix=squeeze(imd(1,1,:));
            m(:,:,1)=imd(:,:,1)==pix(1);
            m(:,:,2)=imd(:,:,2)==pix(2);
            m(:,:,3)=imd(:,:,3)==pix(3);
            m2=sum(m,3)~=3;
            imwrite(im,file_legend,'png','alpha',double(m2));
        end
%         showinfo2(['saved png(resolution:' num2str(p.saveres)  ')'],file_legend);     
    else
        imwrite(im,file_legend,'png');
    end
end
close(hf);
delete(findobj(0,'tag','colorbarTemp'));
% showinfo2(['saved png(resolution:' num2str(p.saveres)  ')'],file_legend);
% ===============================================

%% ===============================================
%%   PPT
%% ===============================================

% paout =pa;
% paimg =fullfile(pa);
% [~, pptname]=fileparts(p.ppt_filename);
% if isempty(pptname); pptname='test1'; end
% [fis]   = spm_select('FPList',paimg,'p_.*.png');    fis=cellstr(fis);
% tx      ={['path: '  paimg ]};


pptfile =fullfile(outdirplot,[z.ppt_filename '.pptx']);
titlem  =z.ppt_filename ;%['lesion'  ];
fis=pnglist;

nimg_per_page  =6;           %number of images per plot
imgIDXpage     =unique([1:nimg_per_page:length(fis) length(fis)+1 ]);
for i=1:length(imgIDXpage)-1
    if i==1; doc='new'; else; doc='add'; end
    img_perslice=fis([imgIDXpage(i):imgIDXpage(i+1)-1]);
    [~, namex ext]=fileparts2(img_perslice);
    tx=cellfun(@(a,b) {[ a b ]},namex,ext);
    [~,namelegend, ext]=fileparts(file_legend);
    tx(end+1,1)={[ namelegend ext ]};
    
    
    img2ppt([],img_perslice, pptfile,'doc',doc,...%,'size','A4'
        'crop',0,'gap',[0 0 ],'columns',1,'xy',[0.02 1.5 ],'wh',[ nan 3.5],...
        'title',titlem,'Tha','center','Tfs',25,'Tcol',[0 0 0],'Tbgcol',[0.8706    0.9216    0.9804],...
        'text',tx,'tfs',12,'txy',[0 16],'tbgcol',[1 1 1],'disp',0 );
    
    legendfile={file_legend};
    img2ppt([],legendfile, pptfile,'doc','same',...%,'size','A4'
        'crop',0,'gap',[0 0 ],'columns',1,'xy',[21.5 15 ],'wh',[ 2 nan],'disp',0 );
    
    
end
%% ===============================================
[ ~, studyName]=fileparts(studydir);
info={};
info(end+1,:)={'study:'                 [studyName]} ;
info(end+1,:)={'studyPath:'             [studydir]} ;
info(end+1,:)={'slices [mm]   :'        slicemm_str} ;
info(end+1,:)={'slices [index]:'        slice_index_str} ;
info(end+1,:)={'date:'                  [datestr(now)]} ;
info(end+1,:)={' '     '  '} ;
info= plog([],[info],0,'INFO','plotlines=0;al=1');
%===============================================

v1=struct('txy', [0 1.5 ], 'tcol', [0 0 0],'tfs',11, 'tbgcol',[0.9843    0.9686    0.9686],...
    'tfn','consolas');
v1.text=info;      
vs={v1};            
% paralist= struct2list2(z_bk,'z');
% paralist=[{' PARAMETER'}; {'z={};'}; paralist; {[mfilename '(1,z) ;% RUN FUNCTION ']}];

paralist=batch(max(regexpi2(batch,'^z=\[\];')):end);
paralist=[{' *** PARAMETER/BATCH ***   '}; paralist ];

img2ppt([],[], pptfile,'doc','add',...
    'title',titlem,'Tha','center','Tfs',25,'Tcol',[0 0 0],'Tbgcol',[0.8706    0.9216    0.9804],...
    'text',paralist,'tfs',10,'txy',[0 8],'tcol', [0 0 0],'tbgcol',[0.9451    0.9686    0.9490], 'tfn','consolas',...
    'multitext',vs,'disp',1 );






