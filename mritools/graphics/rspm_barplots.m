


function [fo]=rspm_barplots(v0,p0)


timex=tic;
fo='';

if 0
    %% ===============================================
    clc;
    v=struct();
    v.infile=  fullfile(pwd,'test6_peaks.xlsx');
    v.plots =[1:2];
    v.hide=1;
    v.verbose=0;
%     v.res=50;
    fo=rspm_barplots(v);
    
    
    
    %% ===============================================
end

% ==============================================
%%   defaults
% ===============================================
v.infile='';
v.outdir       ='';%fullfile(pwd,'barplots','png');  %OUTPUT-FOLDER
% v.study      =antcb('getstudypath');           %STUDYFOLDER
% v.template   =fullfile(v.study,'templates','AVGT.nii');%BACKGROUND-IMAGE
% v.meth       ='clust';  % used method: %'clust', 'FWE' ,'none' , default, 'clust'
% v.type       ='peak';   %aggregate data from  peaks or cluster, either 'peaks' or 'cluster'
% v.cluster    ='all';   %plot cluster, either 'all' or 'first' ; default 'all', i.e. plot all clusters
% v.prefix     ='p';     %output png-prefix
% v.addnumber =1;  %add number to putput PNG-file ; [0,1]; default:[1]
% v.addlabel  =1;  %add anat.label to putput PNG-file ; [0,1]; default:[1]
% v.makePPT   =1;  %make powerpointFile; [0,1]; default:[1]
% v.outdir    =fullfile(v.study ,'voxstatSinglevalues',['method_' v.meth]); %target-Folder
v.addnumber   =1;
v.prefix    ='p_';
v.colors    =[];
v.flipbar   =0;
v.plots     ='all';
v.cfnthfig  =5 ; %close all figs aver nth figure, default:[5]
v.makeppt   =1;
v.pptfile   ='';
v.verbose   =1; % display messages, [0,1]; default: 1
v.res       =600; %image resolution : default: 600



% %% ====input plot-paramter [p-struct]===========================================
% p=struct();
% p.xs      =.48  ; %bar-width/extend in x-direction; default: .48
% p.sdalpha =[.5] ; %bar-transparency [0-1]
% p.mecol   =[0 0 0]; % mean-linecolor; default: [0 0 0]
% p.mewidth =2;       % mean-linewidth; default: 2
% p.sfacecol=repmat([0.7],[1 3]); %single dots facecolor, default [.7 .7 .7]
% p.sedgecol=repmat([0],[1 3]);   %single dots edgecolor, default [0 0 0]
% p.smarkersize=3;  %single dots , markersize, default: 3
% p.sstackbottom=0; %single dots, stack in background/below bars; default: [0]
% p.sjitter=1;      %single dots, jitter dots horizontally, small value.. small jitter, default: [1]


% ==============================================
%%  v0-inputparams
% ===============================================
v=catstruct(v,v0);

p.dummy=1;
if exist('p0')==0; p0.dummy=1; end
p=catstruct(p,p0);
fo=[];

%% ==[infile and outdir]=================
v.infile=char(v.infile);
if isempty(v.outdir)
    [pa name ext]=fileparts(v.infile);
    v.outdir=fullfile(pa, ['barplots_'  name ],'png');
end
if exist(v.outdir)~=7; mkdir(v.outdir); end

%% ==[  read excel]=================
[~,~,a0] = xlsread(v.infile, 1);
ha=a0(1,:);
a =a0(2:end,:);
%% ==[  obtain column_idx]=================
c=struct;
for i=1:length(ha)
    c=setfield(c,['c_' ha{i}], find(strcmp(ha,ha{i}))  );
end


%% ==[  colors]=================
allgroups=unique([a(:,c.c_group1); a(:,c.c_group2)]);
ngroups=length(allgroups);
if isempty(v.colors)
    v.colors= distinguishable_colors(ngroups, {'w','k'});
else
    if size(v.colors,1)<ngroups
        col= distinguishable_colors(ngroups, {'w','k'});
        v.colors(size(v.colors,1)+1:ngroups,:)=col(size(v.colors,1)+1:ngroups,:);
    end
end

% ==============================================
%%   testplots
% ===============================================
if isnumeric(v.plots)
    iuse=v.plots(find(v.plots<size(a,1)));
    a=a(iuse,:);
end




% ==============================================
%%   plots
% ===============================================
outdir=v.outdir;

fo_temp={};
for i=1:size(a,1)
    disp([pnum(i,3) '/' pnum(size(a,1),3)  ]);
    addnumber='';
    if v.addnumber==1;     addnumber=pnum(i,3);     end
    contrast=a{i,c.c_contrastname};
    leg={a{i,c.c_group1} a{i,c.c_group2}};
    ME =[a{i,c.c_ME1} a{i,c.c_ME2}];
    SD =[a{i,c.c_SD1} a{i,c.c_SD2}];
    DP =[{str2num(a{i,c.c_values1})} {str2num(a{i,c.c_values2})}];
    
    
    clusterNo=1;
    col=[v.colors(strcmp(allgroups, leg{1}),:)  ; v.colors(strcmp(allgroups, leg{2}),:)];
    % leg={g1name g2name};
    % t={ this_contrast 'ww' [me1 me2] [sd1 sd2] {dp1 dp2} 'xlab','',leg,col, clusterNo };
    % t={ contrast 'ww' ME SD DP '','',leg,col };
    
    t={  ME SD DP contrast, leg, '','',col };
    %% ===============================================
    condstr=regexprep(contrast, {'>','<'},{'_GT_', '_LT_'}  );
    condstr=regexprep(condstr, {'[<>:"/\\|?*]',' ' }, {''});
    
    region=a{i,c.c_region};
    region= regexprep(region, {'[<>:"/\\|?*]',' ' }, {''});
    
    map   =a{i,c.c_image};
    datatype=a{i,c.c_datatype};
    
    %---PLOT
    nameout= [v.prefix addnumber  '_[' condstr ']' '[' map ']' ...
        '_cl' pnum(a{i,c.c_cluster},2)  '_pk' pnum(a{i,c.c_peak},2) ...
        '[' region ']'  ...
        '_' datatype '.png'];
    
    %% ===============================================
    
    F2=fullfile(outdir,nameout);
    barplotfun2(t,F2, v, p);
    
    
    if mod(i,v.cfnthfig)==0;            cf  ;    end %CLOSE figs after nth. fig-creation
    
    fo_temp=[fo_temp {F2}];
end

if ~isempty(fo_temp)
    fo=fo_temp;
end


%% ===============================================
try;
    tf.study =antcb('getstudypath');
catch
    tf.study='--'
end
[~, tf.studyname]=fileparts(tf.study );





% ==============================================
%%   make powerpoint
% ===============================================
if v.makeppt==1
    [poutdir  pname pext]=fileparts(v.pptfile);
    if isempty(poutdir); poutdir=fileparts(outdir); end
    if isempty(pname);   pname=  [  'bars_' datatype  ]; end
    pext=  [  '.pptx'  ];
    pptfile=fullfile(poutdir ,[ pname pext]);
    if exist(pptfile)==2
        try;     delete(pptfile);end
    end
    % ===============================================
    pd= outdir;
    %header=['bars ' excelname  ' [' studyName ']'  ];
    if strcmp(datatype,'peak')
        header         =['Bars: '  datatype ': [' tf.studyname ']' ];
    else
        header         =['Bars: '  'mean ' datatype ': [' tf.studyname ']' ];
    end
    
    tbi={};
    tbi{end+1,1}=['STUDY:    '   tf.studyname   ];
    tbi{end+1,1}=['PATH:     '   tf.study       ];
    tbi{end+1,1}=['DATE:     '   datestr(now)   ];
    tbi{end+1,1}=['OUTPUT:   '   outdir         ];
    tbi{end+1,1}=['FUNCTION: '   mfilename      ];
    % tbi{end+1,1}=['info    : peaks of signif clusters'       ];
    doc='new';
    img2ppt(outdir,[], pptfile,'size','A4','doc',doc,...
        'title',header,'Tha','center','Tfs',16,'Tcol',[1 1 1],'Tbgcol',[1 .8 0],'tfw','bold',...
        'text',tbi,'txy', [0.1 3], 'tcol',[0 0 0],'tbgcol',[1 1 1],...
        'tfs',10,'tfn','consolas',     'disp',0);
    % ===============================================
    [png] = spm_select('FPList',pd,['^' v.prefix '.*.png']);    png=cellstr(png);
    if isempty(char(png))
       return 
    end
    [~, pngname,pngext ]=fileparts2(png);
    pnglist=cellfun(@(a,b){[ a b ]},pngname,pngext);
    
    nimg_per_page  =8;           %number of images per plot
    imgIDXpage     =unique([1:nimg_per_page:length(png) length(png)+1 ]);
    for i=1:length(imgIDXpage)-1
        %     if i==1; doc='new'; else; doc='add'; end
        doc='add';
        png_perslice     =png([imgIDXpage(i):imgIDXpage(i+1)-1]);
        pnglist_perslice =pnglist([imgIDXpage(i):imgIDXpage(i+1)-1]);
        pnglist_perslice(regexpi2(pnglist_perslice,'_legend'))=[]; %remove legend-info
        img2ppt(pd,png_perslice, pptfile,'size','A4','doc',doc,...
            'crop',0,'gap',[0 0 ],'columns',4,'xy',[.5 1.5 ],'wh',[ 5 nan],...
            'title',header,'Tha','center','Tfs',16,'Tcol',[1 1 1],'Tbgcol',[1 .8 0],'tfw','bold',...
            'text',pnglist_perslice,'tfs',10,'txy',[1 18],'tbgcol',[1 1 1],'disp',0);
    end
    % ====[add info slide]===========================
    % if exist(pptfile)==2
    %
    %     tbi={};
    %     tbi{end+1,1}=['STUDY:    '   tf.studyname   ];
    %     tbi{end+1,1}=['PATH:     '   tf.study       ];
    %     tbi{end+1,1}=['DATE:     '   timeAnalysis   ];
    %     tbi{end+1,1}=['OUTPUT:   '   outdir         ];
    %     tbi{end+1,1}=['FUNCTION: '   mfilename      ];
    %     tbi{end+1,1}=['info    : peaks of signif clusters'       ];
    %
    %     doc='add';
    %     img2ppt(outdir,[], pptfile,'size','A4','doc',doc,...
    %         'title',header,'Tha','center','Tfs',16,'Tcol',[1 1 1],'Tbgcol',[1 .8 0],'tfw','bold',...
    %         'text',tbi,'txy', [0.1 3], 'tcol',[0 0 0],'tbgcol',[1 1 1],...
    %         'tfs',10,'tfn','consolas');
    %
    % end
    
    fo=pptfile;
    showinfo2(['  .PPT-file'],pptfile);
end

fprintf('DONE. [ET: %2.1f min]\n',toc(timex)/60);




