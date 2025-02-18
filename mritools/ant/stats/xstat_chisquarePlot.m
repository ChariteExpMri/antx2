%% create plots and summary powerpoint after running [xstat_chisquare]
% run [xstat_chisquare] before executing this function
% [z varargout] = xstat_chisquarePlot(showgui,x)
% 
%% COMMON PARAMETERS
% 'dir'        folder with chisquareResults   
% 'suffix'     'add suffix to powerpoint to not overwrite previous files' ; EXAMPLE; '_test1'
% 
%% SPECIFIC PARAMETERS
%% please decide whether to have ONE or TWO OVERLAYS
%% ==[ ONE OVERLAY]=============================================
% 'numOverlays'     1                       'number of overlays, {1 or 2}'      
% 'alpha'          [1  0.7]                 'transparency, [img1,img2]'  
% 'cbarvisible'    [0  1  ]                 'colorbar visibility,  [img1, img2]'    
% 'clim'           [  0 200;  [3  10] ]     'color-limits, img1&img2: [[min max];[min max]]'     
% 'cmap'           { 'gray' 	'jet' }     'colormaps,    img1&img2 see: dummyColormap'    
% 'mbarlabel'      { '' 	'OR' }          'cbarlabels,   img1&img2'; if empty no label is plotted
% 'mcbarticks'     [2]                      'number of ticks in colorbar'; default:2
% 'visible'        [1  1]                   'image visibility, [img1, img2]'; structral image and overlay are shown
% 'usebrainmask'   [1]                      'use brainMask to get rid off outerbrain activity {0|1}'     
% 
%% ==[ TWO OVERLAYS]=============================================
% 'numOverlays'   2                                'number of overlays, {1 or 2}' 
% 'alpha'         [1  0.9  1]                      'transparency [images:1,2,3]'       
% 'cbarvisible'   [0  1  0  ]                       'colorbar visibility  [images:1,2,3]'     
% 'clim'          [ 0 200; 0  10;  0  3  ]                'color-limits, [images:1,2,3]:[[min max];[min max];[min max]]'  
% 'cmap'          { 'gray' 	'YlOrRd_flip' 	'isoBlue' }   'colormaps, [images:1,2,3] see: dummyColormap'    
% 'mbarlabel'     { '' 	'OR' 	'' }                      'cbarlabels, [images:1,2,3]'    
% 'mcbarticks'    [2]                                     'number of ticks in barlabel'    
% 'visible'       [1  1  1]                               'image visibility,[images:1,2,3]'  
% 'usebrainmask'  [0]                                     'use brainMask to get rid off outerbrain activity {0|1}'    
% 
%% OUTPUT-variables
% [z2]      : struct with variables to rerun this function
% 2nd output: optional, output-path were ppt and 'plots'-dir is located (same as inputpath 'dir')
% 3rd output: optiona: name of the powerpoint-file
% example: [z2 outpa, newppt]=xstat_chisquarePlot(0,z);
% 
%% ===EXAMPLE: WITH TWO OVERLAYS ============================================
% plot structural image with OddsRatio map and an top the signif. clusters (1BG-image + two overlays)
% output from chisqareTest are located in 'pares', adding suffix to powerpointFile '_ovl2'
% all images(structural image, OddsRatio map and signif. clusters with transparency value of [1]),
% only colorbar of OddsRatio map is shown with label 'OR', 
% important: because angioMasks are used the brainmask is set to 0, i.e. outer brain maps should be plotted
% 
% pares='F:\data8\2024_Stefanie_ORC1_24h_postMCAO\results\stat_x_c_angiomask_blk5_p0.05';
% z=[];
% z.numOverlays   = [2];        % % number of overlays, {1 or 2}
% z.dir           = pares;      % % folder with chisquareResults
% z.suffix        = '_ovl2';    % % add suffix to powerpoint to not overwrite previous files
% z.alpha         = [1  1  1];  % % transparency [images:1,2,3]
% z.cbarvisible   = [0  1  0];  % % colorbar visibility  [images:1,2,3]
% z.clim          = [0 200; 0 2;0 3];      % % color-limits, [images:1,2,3]:[[min max];[min max];[min max]]
% z.cmap          = { 'gray','Reds','isoLime'  };  % % colormaps, [images:1,2,3] see: dummyColormap
% z.mbarlabel     = { '' 'OR' '' };                % % cbarlabels, [images:1,2,3]
% z.mcbarticks    = [2];                           % % number of ticks in barlabel
% z.visible       = [1  1  1];                     % % image visibility,[images:1,2,3]
% z.usebrainmask  = [0];                           % % use brainMask to get rid off outerbrain activity {0|1}
% xstat_chisquarePlot(0,z);
% 
%% ===EXAMPLE: WITH ONE OVERLAY ============================================
% displax only structural BG-image (using gray-cmap) and map of signif. clusters (cool-cmap)
% 
% pares='F:\data8\2024_Stefanie_ORC1_24h_postMCAO\results\stat_x_c_angiomask_blk5_p0.05_test'
% z=[];
% z.numOverlays   = [1];       % % number of overlays, {1 or 2}
% z.dir           = pares;     % % folder with chisquareResults
% z.suffix        = '_ovl1';   % % add suffix to powerpoint to not overwrite previous files
% z.alpha         = [1  1];    % % transparency [images:1,2,3]
% z.cbarvisible   = [0  1];    % % colorbar visibility  [images:1,2,3]
% z.clim          = [0 200 ;0 15];         % % color-limits, [images:1,2,3]:[[min max];[min max];[min max]]
% z.cmap          = { 'gray' 	'cool'  }; % % colormaps, [images:1,2,3] see: dummyColormap
% z.mbarlabel     = { '' 	'ORsig'};      % % cbarlabels, [images:1,2,3]
% z.mcbarticks    = [2];                   % % number of ticks in barlabel
% z.visible       = [1  1];                % % image visibility,[images:1,2,3]
% z.usebrainmask  = [0];                   % % use brainMask to get rid off outerbrain activity {0|1}
% xstat_chisquarePlot(0,z);
% 
% 
% 
% 



function [z varargout] = xstat_chisquarePlot(showgui,x)
warning off;
clc

if 0
    
    %% ===[ plot with 1ovl]============================================
    z=[];
    z.numOverlays   = [1];                                                                                                             % % number of overlays, {1 or 2}
    z.dir           = 'H:\Daten-2\Imaging\AG_Harms\2024_Stefanie_ORC1\24h_postMCAO\results\TESTER__stat_x_c_angiomask_blk5_p0.05';     % % folder with chisquareResults
    z.suffix        = '_oneOverlay';                                                                                                        % % add suffix to powerpoint to not overwrite previous files
    z.alpha         = [1  1];                                                                                                          % % transparency, [img1,img2]
    z.cbarvisible   = [0  1];                                                                                                          % % colorbar visibility,  [img1, img2]
    z.clim          = [          0        200                                                                                          % % color-limits, img1&img2: [[min max];[min max]]
        2          5  ];
    z.cmap          = { 'gray' 	'cool' };                                                                                               % % colormaps,    img1&img2 see: dummyColormap
    z.mbarlabel     = { '' 	'OR' };                                                                                                  % % cbarlabels,   img1&img2
    z.mcbarticks    = [2];                                                                                                             % % number of ticks in colorbar
    z.visible       = [1  1];                                                                                                          % % image visibility, [img1, img2]
    z.usebrainmask  = [1];                                                                                                             % % use brainMask to get rid off outerbrain activity {0|1}
    z.dummyColormap = 'cool';                                                                                                          % % get colormap for visualization--> enter in "cmap"
    xstat_chisquarePlot(0,z);
    %% ===[ plot with 2ovls]============================================
    z=[];
    z.numOverlays   = [2];                                                                                                             % % number of overlays, {1 or 2}
    z.dir           = 'H:\Daten-2\Imaging\AG_Harms\2024_Stefanie_ORC1\24h_postMCAO\results\TESTER__stat_x_c_angiomask_blk5_p0.05';     % % folder with chisquareResults
    z.suffix        = '_ovl2';                                                                                                        % % add suffix to powerpoint to not overwrite previous files
    z.alpha         = [1  1  1];                                                                                                       % % transparency [images:1,2,3]
    z.cbarvisible   = [0  1  0];                                                                                                       % % colorbar visibility  [images:1,2,3]
    z.clim          = [          0        200                                                                                          % % color-limits, [images:1,2,3]:[[min max];[min max];[min max]]
        0         2
        0          3  ];
    z.cmap          = { 'gray' 	'Reds' 	'isoLime'  }; % 'isoFuchsia'    'isoBlue'                                                                  % % colormaps, [images:1,2,3] see: dummyColormap
    z.mbarlabel     = { '' 	'OR' 	'' };                                                                                        % % cbarlabels, [images:1,2,3]
    z.mcbarticks    = [2];                                                                                                             % % number of ticks in barlabel
    z.visible       = [1  1  1];                                                                                                       % % image visibility,[images:1,2,3]
    z.usebrainmask  = [0];                                                                                                             % % use brainMask to get rid off outerbrain activity {0|1}
    z.dummyColormap = 'isoFuchsia';                                                                                                    % % get colormap for visualization--> enter in "cmap"
    xstat_chisquarePlot(1,z);
    %% ===============================================
    
end

%====================================================================================================

if exist('showgui')~=1;  showgui=1; end
if exist('x')~=1;        x=[]; end
if isempty(x); showgui=1; end
%====================================================================================================
% global an
% pa=antcb('getsubjects');
% v=getuniquefiles(pa);
% outdir=fullfile(fileparts(an.datpath),'results');

x0=x;
p=getdefaultparas(x,x0);

pg={
    'dir'           ''        'folder with chisquareResults'    'd'
    'suffix'        '_test3'  'add suffix to powerpoint to not overwrite previous files'  {'_test3' '_res1' '_res2'}
    };

aux={
    'inf2' '___[OTHER PARAMETER]___________________' '' ''
    'dummyColormap' 'jet'  'get colormap for visualization--> enter in "cmap" '  {'cmap',{}}
    };

i_numovl=find(strcmp(p(:,1), 'numOverlays'));
p=[{'inf1' ' ' '' ''};...
    p(i_numovl,:); ...
    pg; {'inf3' '' '' ''};...
    p(setdiff(1:size(p,1),i_numovl),:) ;...
    aux];


%   p=[pg; {'inf2' '' '' ''} ; p ; aux];
p=paramadd(p,x);%add/replace parameter

%reorder
% i_numovl=find(strcmp(p(:,1), 'numOverlays'));
% p=[ p(i_numovl,:);  p(setdiff(1:size(p,1),i_numovl),:)  ];



%% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
        'figpos',[.15 .3 .6 .4 ],...
        'title',mfilename,'info',hlp);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

disp('..read mask-based paramter from images..');
xmakebatch(z,p, mfilename); % ## BATCH

%% ==[run stuff]=======================================

[varargout{1:nargout-1}]=proc(z);


% ==============================================
%%   subs
% ===============================================

% ==============================================
%%   func proc
% ===============================================
function varargout=proc(z0)
warning off
clc
%% ======[extract values]=========================================

paout        =char(z0.dir)      ;

oz=z0; % struct for orthoslice
oz=rmfield(oz,{'numOverlays' 'dir' 'suffix' 'dummyColormap'});


% num_overlays =z0.numOverlays;
%% ===============================================



timex=tic;
% if 0
%     % z0.outdir ='H:\Daten-2\Imaging\AG_Harms\2024_Stefanie_ORC1\d7_postMCAO\results\TESTER_stat_x_masklesion_blk5_p0.05'
%     z0.outdir ='H:\Daten-2\Imaging\AG_Harms\2024_Stefanie_ORC1\24h_postMCAO\results\TESTER__stat_x_c_angiomask_blk5_p0.05'
%     z0.OR_cmap      = 'jet';                                                                                % % cmap of signif. OddsRatio-map for plotting
%     z0.OR_range     = [3  10];
%     z0.suffix       = '_test'; %add suffix to PPT
%
%
%     z0.outdir ='H:\Daten-2\Imaging\AG_Harms\2024_Stefanie_ORC1\24h_postMCAO\results\TESTER__stat_x_c_angiomask_blk5_p0.05'
%     z0.OR_cmap      = 'isoRed';                                                                                % % cmap of signif. OddsRatio-map for plotting
%     z0.OR_range     = [3  10];
%     z0.suffix       = '_test2'; %add suffix to PPT
% end
% ==============================================
%%   make plots
% ===============================================
[fi_nii] = spm_select('FPList',paout,'^s_.*_signif.*.nii');
if isempty(fi_nii); return; end
fi_nii=cellstr(fi_nii);

paoutplot=fullfile(paout,'plots');
if exist(paoutplot)~=7; mkdir(paoutplot); end
% delete(fullfile(paout,'plots','*'));


[~, dum,~]=fileparts2(fi_nii);
name=regexprep(dum,{'\[' '\]','_signif'},{''});
fi_xls=(cellfun(@(a){ [ paout filesep a '.xlsx']} ,name)); % XLS-files

plotpeaks='first' ; %'first' or 'all'
plotpeaks='all' ; %'first' or all




%% ===============================================


% ===============================================
b2={};
num=1;
for i=1:length(fi_xls)
    [~,~,b0]=xlsread(fi_xls{i},2);
    b0=xlsprunesheet(b0);
    hb=b0(1,:);
    b =b0(2:end,:);
    c_x      =find(strcmp(hb, 'x'));
    c_clustNo=find(strcmp(hb, 'clustNo'));
    c_region =find(strcmp(hb, 'region'));
    
    %% ____ get info-sheet
    [~,~,s0]=xlsread(fi_xls{i},1);
    s0=xlsprunesheet(s0);
    
    
    is1=regexpi2(s0,'***PARAMETER***');
    is2=regexpi2(s0,'***BATCH***');
    eval(strjoin(s0(is1+1:is2-1),';'));
    
    %      is2=regexpi2(s0,'z.atlas');
    %      iv=is1-1+min(regexpi2(s0(is1:end),'z.atlas')) ;%get atlas
    %      eval(s0{iv});
    %      z.atlaspath=fileparts(z.atlas);
    %z.avgtfile= fullfile(z.atlaspath, 'AVGT.nii')
    % get study
    q=[char(regexprep(s0(max(regexpi2(s0,'^study:'))),{'^study:\s+'},{'z.study='''})) ''';'];
    eval(q);
    z.avgtfile= fullfile(z.study,'templates', 'AVGT.nii');
    
    %update struct
    %      z.OR_cmap   =z0.cmap;
    %      z.OR_range  =z0.clim;
    z.outdir    =z0.dir ;
    
    %% ----
    
    if strcmp(plotpeaks,'first')
        [~,idx]=unique(cell2mat(b(:,1)),'rows');
        b=b(idx,:);
        peakno=ones(size(b,1),1);
    else
        bcl=cell2mat(b(:,1));
        peakno=zeros(size(bcl));
        unicl=unique(bcl);
        for j=1:length(unicl)
            ix=find(bcl==unicl(j));
            peakno(ix)=[1:length(ix)];
        end
    end
    
    
    
    
    for j=1:size(b,1)
        % ===============================================
        if z0.numOverlays==1
            cf;
            ce=cell2mat(b(j,c_x:c_x+2));
            files={z.avgtfile  fi_nii{i}  };
            r=[];
            r.ce=ce;
            r.alpha       =  [1  0.7];
            r.blobthresh  =  [];
            r.cbarvisible =  [0  1  ];
            r.cblabel     =  '';
            r.clim        =  [  0 200;  z.OR_range  ];
            r.cmap        =  { 'gray' 	z.OR_cmap };%'NIH_fire_inv.lut'
            r.mbarlabel   =  { '' 	'OR' };
            r.mroco       =  [NaN  NaN];
            r.mslicemm    =  [];
            r.saveas      =  '';
            r.thresh      =  [        NaN        NaN
                NaN        NaN  ];
            r.visible     =  [1  1];
            r.usebrainmask =  [0];
            
            r=catstruct(r,oz);
            orthoslice(files,r); drawnow; drawnow; drawnow
            
        else
            %% ===============================================
            
            img1=regexprep(fi_nii{i},{'_signif','\]','\['},{''}) ;
            cf;
            ce=cell2mat(b(j,c_x:c_x+2));
            files={z.avgtfile img1  fi_nii{i}  };
            %             orthoslice(files)
            r=[];
            r.alpha       =  [1  0.9  1];
            r.blobthresh  =  [];
            r.cbarvisible =  [0  1  0  ];
            r.cblabel     =  '';
            r.ce          =  ce;
            r.clim        =  [ 0 200
                0  10
                0  3  ];
            r.cmap        =  { 'gray' 	'YlOrRd_flip' 	'isoBlue' };
            r.mbarlabel   =  { '' 	'OR' 	'' };
            r.mcbarticks  =  [2];
            r.mroco       =  [NaN  NaN];
            r.mslicemm    =  [];
            r.saveas      =  '';
            r.thresh      =  [ NaN NaN; NaN NaN; NaN  NaN  ];
            r.visible     =  [1  1  1];
            
            r=catstruct(r,oz);
            orthoslice(files,r);
            
            %% ===============================================
            
        end
        
        
        % SAVE PNG
        if 1
            disp(['..saving png-' num2str(num)]);
            regname=regexprep(b{j,c_region},{'\s+','(' ')' ,'/'},{'_','','','or'});
            outname=['p' pnum(num,2) '_' name{i} '_CL' num2str(b{j,c_clustNo}) ...
                '_MAX' num2str(peakno(j)) ...
                '_' regname '.png' ];
            Fo4=fullfile(paoutplot,outname);
            orthoslice('post','saveas',Fo4,'dosave',1);
        end
        b2(end+1,:)=b(j,:);
        
        
        % ===============================================
        num=num+1;
    end
end

% ==============================================
%%   make PPT
% ===============================================
disp(['..creating powerpointfile']);
% ===[make 1st slide]============================================
[ ~, studyName]=fileparts(z.study);
info={};
info(end+1,:)={'study:'      [studyName]} ;
info(end+1,:)={'studyPath:'  [z.study]} ;
info(end+1,:)={'file:'        char(z.image)} ;
info(end+1,:)={'date:'     [datestr(now)]} ;
info(end+1,:)={' '     '  '} ;

info(end+1,:)={'Hthresh: '     ['p<' num2str(z.hthresh)]} ;
info(end+1,:)={'nperms:  '     [num2str(z.nperms)]} ;
info(end+1,:)={'blocksize:  '     [num2str(z.blocksize)]} ;


info= plog([],[info],0,'Contrast','plotlines=0;al=1');
%% ===============================================

v1=struct('txy', [0 1.5 ], 'tcol', [0 0 1],'tfs',11, 'tbgcol',[1 1 1],...
    'tfn','consolas');
v1.text=info;

paralist=struct2list2(z,'z');
info2= plog([],[{'MAIN PARAMETER'};paralist],0,'','plotlines=0;al=1;');
v2=struct('txy', [0.5 6 ], 'tcol', [0 0 0],'tfs',8, ...
    'tbgcol',[1    0.96    0.92],  'tfn','consolas');
v2.text=info2;

plotparar=struct2list2(r,'r');
plotparar=regexprep(plotparar,'^\s+',repmat(char(9),[1 3]));
% info2= plog([],[{'PLOT PARAMETER'};plotparar],0,'','plotlines=0;al=1;');
plotparar=[{'PLOT PARAMETER'}; plotparar];
v3=struct('txy', [0.5 12.5 ], 'tcol', [0 0 0],'tfs',7, ...
    'tbgcol',[[0.9451    0.9686    0.9490]],  'tfn','consolas');
v3.text=plotparar;


vs={v1 v2 v3};
titlesufx='';
titcol=[0 0 0];
dirname=[z.outdir(max(strfind(z.outdir,filesep))+1:end) z0.suffix ];
pptnameShort=[dirname '.pptx'];
file=char(z.image);
pptfile2=fullfile(paout, pptnameShort );
img2ppt(paout,[], pptfile2,'doc','new',...
    'title',['chiSquareTest: [' studyName '], file: ' file  ],...
    'multitext',vs,'disp',1 );
%% ===============================================

% ======[make all other slides]=========================================
[fiplotFP] = spm_select('FPList',paoutplot,'^p.*.png');
fiplotFP=cellstr(fiplotFP);
[fiplot] = spm_select('List',paoutplot,'^p.*.png');
if isempty(fiplot); return; end
fiplot=cellstr(fiplot);
condshort=regexprep(fiplot,{'_oddsR.*' ,'p\d\d_s_\d\d_'},{''});
uni_condshort=unique(condshort,'stable');

% ===[2nd slide: add table]============================================
condshortHR=regexprep(condshort,{'__lt__','__gt__' },{'<', '>'});
b3 =[ num2cell([1:size(b2,1)])'  condshortHR    b2   fiplot     ];
hb3=[ 'idx'                      'condition'  hb   'PNG-file'  ];

b3=cellfun(@(a){ [ num2str(a)]} ,b3);

info2= plog([],[hb3;b3],0,'Contrast','plotlines=0;al=1;');
v2=struct('txy', [0.01 1.3 ], 'tcol', [0 0 0],'tfs',7, ...
    'tbgcol',[1    0.96    0.92],  'tfn','consolas');
v2.text=info2;
vs={}; vs{1}=v2;
img2ppt(paout,[], pptfile2,'doc','add',...
    'crop',0,'gap',[1 0],'columns',1,'xy',[0.02 1 ],'wh',[ nan 3.6],...
    'title',[' [' 'Cluster-table' ']'  titlesufx ],...
    'Txy',[0 0],'Tha','left','Tcol',titcol ,...
    'multitext',vs,'disp',0 );


% ===============================================

%% ===[other slides grouped by contrast]============================================
co=uni_condshort;

for j=1:length(co);
    if mod(j,2)==1; titcol=[0 0 1]; else titcol=[0 0 0]; end
    
    imgno=find(strcmp(condshort,co{j} ));
    fi2plot     =fiplotFP(imgno);
    fi2plotshort=fiplot(imgno);
    
    nimg_per_page  =4;           %number of images per plot
    imgIDXpage     =unique([1:nimg_per_page:length(fi2plot) length(fi2plot)+1 ]);
    x2=b3(imgno,:);
    for i=1:length(imgIDXpage)-1
        titlesufx='';
        if i>1; titlesufx=' ..continued';
        end
        iv=[imgIDXpage(i):imgIDXpage(i+1)-1];
        x3=x2(iv,:);
        
        pnglist={'Files:'};
        pnglist=[pnglist; fi2plotshort(iv)];
        %png=stradd(x3(:,c_pngfile), [outdir filesep] );
        png=fi2plot(iv);
        condName=regexprep(co{j},{'__lt__','__gt__' },{'<', '>'});
        
        if 1
            info2= plog([],[hb3;x3],0,'Contrast','plotlines=0;al=1;');
            v2=struct('txy', [0.01 16 ], 'tcol', [0 0 0],'tfs',8, ...
                'tbgcol',[1    0.96    0.92],  'tfn','consolas');
            v2.text=info2;
            vs={}; vs{1}=v2;
            img2ppt(paout,png, pptfile2,'doc','add',...
                'crop',0,'gap',[1 0],'columns',1,'xy',[0.02 1 ],'wh',[ nan 3.6],...
                'title',['condition-' num2str(j)  ': [' condName ']'  titlesufx ],...
                'Txy',[0 0],'Tha','left','Tcol',titcol ,...
                'text',pnglist,'txy', [15 3 ],'tcol', [0 0 1],'tbgcol', [1 1 1],...
                'tfs',9,...
                'multitext',vs,'disp',0 );
        end
    end
end
%  ======[add parameter slide]====================
% info2= plog([],[{'PARAMETER'};paralist],0,'','plotlines=0;al=1;');
% v2=struct('txy', [0.01 1.3 ], 'tcol', [0 0 0],'tfs',7, ...
%     'tbgcol',[1    0.96    0.92],  'tfn','consolas');
% v2.text=info2;
% vs={}; vs{1}=v2;
% img2ppt(paout,[], pptfile2,'doc','add',...
%     'crop',0,'gap',[1 0],'columns',1,'xy',[0.02 1 ],'wh',[ nan 3.6],...
%     'title',[' [' 'PARAMETER' ']'  titlesufx ],...
%     'Txy',[0 0],'Tha','left','Tcol',titcol ,...
%     'multitext',vs,'disp',1 );



% ===============================================

showinfo2(['PPTfile2'],pptfile2);

if nargout>=1;  varargout{1}=paout   ; end
if nargout>=2;  varargout{2}=pptfile2; end












%% ===============================================

cprintf('*[0 0 1]',[sprintf([' Done! (%2.0fmin) \n'], toc(timex)/60)  '\n']);


function p=getdefaultparas(x,x0)
bl1={};
bl1(end+1,:)={['<empty> & "tvalue"' ]        {''                 'tvalue'} };
bl1(end+1,:)={['"magn." & "tvalue"' ]        {'magn.'            'tvalue'} };
bl1(end+1,:)={['<empty> & "overlapp [%]"' ]  {''                 'overlapp [%]'} };

bl2={};
bl2(end+1,:)={['<empty> & "tvalue" & <empty>'     ]  {''        'tvalue'            ''} };
bl2(end+1,:)={['"magn." & "tvalue" & <empty>'     ]  {'magn.'   'tvalue'            ''} };
bl2(end+1,:)={['<empty> & "overlapp [%]" "sign."' ]  {''        'overlapp [%]' 'sign.'} };
if isempty(x) ||  x.numOverlays==1
    p={
        'numOverlays'     1                       'number of overlays, {1 or 2}'     {@numOverlays,x0}
        'alpha'          [1  0.7]                 'transparency, [img1,img2]'        {[1 1]; [1 0.5]}
        'cbarvisible'    [0  1  ]                 'colorbar visibility,  [img1, img2]'      {[1 1]; [0 1]}
        'clim'           [  0 200;  [3  10] ]     'color-limits, img1&img2: [[min max];[min max]]'      ''
        'cmap'           { 'gray' 	'jet' }       'colormaps,    img1&img2 see: dummyColormap'      ''%'NIH_fire_inv.lut'
        'mbarlabel'      { '' 	'OR' }            'cbarlabels,   img1&img2'    bl1
        'mcbarticks'     [2]                      'number of ticks in colorbar'      [2 3 4]
        'visible'        [1  1]                   'image visibility, [img1, img2]'      {[1 1]; [0 1]}
        'usebrainmask'   [1]                      'use brainMask to get rid off outerbrain activity {0|1}'      'b'
        };
else
    %% ===============================================
    
    p={
        'numOverlays'   2                                         'number of overlays, {1 or 2}' {@numOverlays,x0}
        'alpha'         [1  0.9  1]                               'transparency [images:1,2,3]'        {[1 1 1] [1 0.5 1] [1 0.5 .5]}
        'cbarvisible'   [0  1  0  ]                               'colorbar visibility  [images:1,2,3]'      {[1 1 1] [0 1 1] [0 1 0] [0 1 1]}
        'clim'          [ 0 200; 0  10;  0  3  ]                  'color-limits, [images:1,2,3]:[[min max];[min max];[min max]]'      ''
        'cmap'          { 'gray' 	'YlOrRd_flip' 	'isoBlue' }   'colormaps, [images:1,2,3] see: dummyColormap'      ''
        'mbarlabel'     { '' 	'OR' 	'' }                      'cbarlabels, [images:1,2,3]'    bl2
        'mcbarticks'    [2]                                       'number of ticks in barlabel'      [2 3 4]
        'visible'       [1  1  1]                                 'image visibility,[images:1,2,3]'      {[1 1 1] [1 1 1]  [0 1 1] [1 1 0]}
        'usebrainmask'  [0]                                       'use brainMask to get rid off outerbrain activity {0|1}'      'b'
        };
    %% ===============================================
end
% if 0
%     pg={
%         'folder'        ''        'folder with chisquareResults'    'd'
%         'suffix'        '_test3'  'add suffix to powerpoint to not overwrite previous files'  {'_test3' '_res1' '_res2'}
%         };
%
%     aux={
%         'inf2' '___[OTHER PARAMETER]___________________' '' ''
%         'dummyColormap' 'jet'  'get colormap for visualization--> enter in "cmap" '  {'cmap',{}}
%         };
%
%     i_numovl=find(strcmp(p(:,1), 'numOverlays'));
%     p=[{'inf1' ' ' '' ''};...
%         p(i_numovl,:); ...
%         pg; {'inf3' '' '' ''};...
%         p(setdiff(1:size(p,1),i_numovl),:) ;...
%         aux];
% end


function numOverlays(x)
[x1,x2]= paramgui('getdata');
if x2.numOverlays==1;  x.numOverlays=2;
else                   x.numOverlays=1;
end
p=getdefaultparas(x,[]);
%  h = waitbar(0,'Please wait...'); drawnow
hf=findobj(0,'tag','paramgui');
pos=get(hf,'position');
% set(hf,'position',[pos(1:2)  0.001 0.01 ]);
set(hf,'visible','off');
%% ===============================================
for i=1:size(p,1)
    if isempty(...
            regexpi(['x.' p{i,1}], ['x.inf\d+'])) && ...
            isempty(...
            regexpi(['x.' p{i,1}], ['x.inf\d+']))
        paramgui('setdata',['x.' p{i,1} ],p{i,2});
    end
end
%% ===============================================

hf=findobj(0,'tag','paramgui');
% pos=get(hf,'position');
lim=0.0001;
set(hf,'position',[pos(1:3) pos(4)+lim ]);
set(hf,'position',[pos(1:3) pos(4)-lim ]);
set(hf,'visible','on');
% delete(h)
