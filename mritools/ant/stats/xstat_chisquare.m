
%% run chi-square test for two independent groups on binary images
% images must be binary such as lesion-masks
% permutation test is used to deal with the multiple comparison problem
% [z varargout]=xstat_chisquare(showgui,x,pa)
%
%% PARAMETER
% 'image'         select the binary image, on this image the statistic is perfomred
% 'groupfile'     groupfile(excelfile) with animmals and group
%                  1st colum: animal-names (string)
%                  2nd column: group-name  (string)
%                  more than 2 groups possible here to code, such as 'groupA' , groupB, 'groupC'
% 'atlas'         nifti-atlas, if empty the default template-atlas is used
% 'outdir'        output-dir, if empty the default results-folder is used as upper-dir
% 'suffix'        add suffix-string to final output-dir
%
% 'useUnionMask'  [1] use union of all image-files as mask, [0] use AVGTmask from templates-dir
%                 default: [1]
% 'hthresh'      'high-threshold such as 0.05
% 'blocksize'     if value above 0: use block-shuffling approach (less conservative) with this blocksize, must be integer'
%                 if [0]: conventional approach, i..e no block-wise shuffling
%                 otherise : a number >0, this vaule defined the blocksize in x-y-z direction (cube) which is coherently shuffled
%
% 'nperms'       number of permutations (default: 5000)
% 'isparfor'     use pararellel processing {0|1}; default: [1]
%
%% '---CLUSTER-PEAKS---'
% 'CLpeak_num'    number of peaks per signif. cluster to report; default: [3]
% 'CLpeak_dist'   minimum distance between clusterPeaks; default: [2]
%% ---PLOT OPTIONS---'
% 'OR_cmap'       used colormap of overlay, ie. to plot the OddsRatio-map; example: 'NIH_ice.lut'  or 'jet'
% 'OR_range'      intensity range of OddsRatio-map for plotting; 2 values [min max]; example:[3 20]
% 'plot_uncorrected' additionally create+display the uncorrected image; {0|1}
%                   default: [1]
%
%% OUTPUT-variables
% [z2]      : struct with variables to rerun this function
% 2nd output: optional, output-path were ppt and 'plots'-dir is located (same as inputpath 'dir')
%
%
%% batch
% xstat_chisquare; 	    % open GUI for parameter settings and run.. same as: xstat_chisquare(1)
% xstat_chisquare(1,z);	% RUN with GUI and defined struct
% xstat_chisquare(0,z);	% RUN without GUI and defined struct
% type char(anth) in CMD-WIN to obtain the code after execution of the function
%
%% === example-1
% run chisquare test over image 'x_c_angiomask.nii', groups defined in z.groupfile, use default atlas and
% defualt result-dir as upper-dir, use union of all mask to obtain data, high-threshold p<0.05, and bock-sample approach
% with blocksize of 5, 5000 permutation, use parfor, if signif clusters found report the first 3 with max. distance of 2mm
% for plotting use colormap 'isoFuchsia'. Addionally create and add in powerpoint the uncorrected image with cmap 'winterFLIP'
%     z=[];
%     z.image                = 'x_c_angiomask.nii';                                                       % % binary image to make statistic on
%     z.groupfile            = 'F:\data8\2024_Stefanie_ORC1_24h_postMCAO\animal_groups_24hMCAO.xlsx';     % % groupfile(excelfile) with animmals and group
%     z.atlas                = '';              % % nifti-atlas, if empty the default template-atlas is used
%     z.outdir               = '';              % % output-dir, if empty the default results-folder is used as upper-dir
%     z.suffix               = '';              % % add suffix-string to final output-dir
%     z.useUnionMask         = [1];             % % [1] use union of all image-files as mask, [0] use AVGTmask from templates-dir
%     z.hthresh              = [0.05];          % % high-threshold such as 0.05
%     z.blocksize            = [5];             % % if value above 0: use block-shuffling approach(less conservative) with this blocksize, must be integer
%     z.nperms               = [5000];          % % number of permutations
%     z.isparfor             = [1];             % % use pararellel processing {0|1} ; default: [1]
%     % %  ---CLUSTER-PEAKS---
%     z.CLpeak_num           = [3];             % % number of peaks per signif. cluster to report
%     z.CLpeak_dist          = [2];             % % minimum distance between clusterPeaks
%     % ---PLOT OPTIONS---
%     z.OR_cmap              = 'isoFuchsia';    % % used colormap of overlay, ie. to plot the OddsRatio-map
%     z.OR_range             = [1  5];          % % intensity range of OddsRatio-map for plotting
%     z.plot_uncorrected     = [1];             % % additionally create+display the uncorrected image
%     z.OR_cmap_uncorrected  = 'winterFLIP';    % % uncorrected image: colormap of overlay for plotting
%     z.OR_range_uncorrected = [1  5];          % % uncorrected image: intensity range for plotting
%     xstat_chisquare(1,z);
%
%
%


function [z varargout]=xstat_chisquare(showgui,x,pa)
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
%%    generate list of nifit-files within pa-path
% ===============================================
%%
if 1
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=unique(fi2);
end
% ==============================================
%%   PARAMETER-gui
% ===============================================
if exist('x')~=1;        x=[]; end
p={...
    'image'          ''           'binary image to make statistic on'  {@selector2,li,{'TargetImage'},'out','list','selection','single','position','auto','info','select binary image'}
    'groupfile'      ''           'groupfile(excelfile) with animmals and group'   'f' ;% {@selector2,li,{'SourceImage'},'out','list','selection','single','position','auto','info','select source-image'}
    'atlas'          ''           'nifti-atlas, if empty the default template-atlas is used '   'f' ;% {@selector2,li,{'SourceImage'},'out','list','selection','single','position','auto','info','select source-image'}
    'outdir'         ''           'output-dir, if empty the default results-folder is used as upper-dir'   'd' ;% {@selector2,li,{'SourceImage'},'out','list','selection','single','position','auto','info','select source-image'}
    'suffix'         ''           'add suffix-string to final output-dir'  {'_test' '_test2'}
    
    
    'useUnionMask'   1           '[1] use union of all image-files as mask, [0] use AVGTmask from templates-dir'  'b'
    'hthresh'      0.05          'high-threshold such as 0.05'                                                      {0.05  0.01 0.005 0.001}
    'blocksize'     5            'if value above 0: use block-shuffling approach(less conservative) with this blocksize, must be integer'  {0 3 5 10}
    'nperms'       5000          'number of permutations'  {100 1000 5000}
    
    'inf33'      ' '                 '' ''
    'isparfor'     1              'use pararellel processing {0|1} ; default: [1] '  'b'
    
    
    'inf1'  '---CLUSTER-PEAKS---'  '' ''
    'CLpeak_num'    3              'number of peaks per signif. cluster to report'  {1 3 5}
    'CLpeak_dist'   2              'minimum distance between clusterPeaks'  { 0.5 1 2 3}
    
    'inf2'  '---PLOT OPTIONS---'   '' ''
    'OR_cmap'               'isoFuchsia'   'used colormap of overlay, ie. to plot the OddsRatio-map'       {'cmap',{}}
    'OR_range'               [1 5]         'intensity range of OddsRatio-map for plotting'   {[1 5];[0 20]; [3 20]}
    
    'plot_uncorrected'       1             'additionally create+display the uncorrected image' 'b'
    'OR_cmap_uncorrected'   'winterFLIP'   'uncorrected image: colormap of overlay for plotting'       {'cmap',{}}
    'OR_range_uncorrected'  [1 5]          'uncorrected image: intensity range for plotting'   {[1 5];[0 20]; [3 20]}
    
    };
% NIH_ice.lut'

p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .6 .4 ],...
        'title',['***chi-square-test***' '[' mfilename '.m]'],'info',{@uhelp, [mfilename '.m']});
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
        [qq,batch]=  xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z);' ]);
    else
        [qq,batch]=  xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z,mdirs);' ],pa);
    end
end




% ==============================================
%%
% ===============================================
cprintf('*[0 0 1]',['chi-square test'  '\n']);
timex=tic;
if isExtPath==0  %ANTX
    global an
    padat=an.datpath;
    pastudy=fileparts(padat);
    patemplates=fullfile(pastudy,'templates');
    
    Fatlas=char(z.atlas);
    if isempty(Fatlas)
        Fatlas=fullfile(patemplates,'ANO.nii');
    end
    Fgroup=char(z.groupfile);
    
    
else
    
end

%% ===============================================
% Fatlas=fullfile(patemplates,'ANO.nii');
% Fgroup=fullfile(pastudy,'animal_groups_24hMCAO.xlsx');
maskfile =fullfile(patemplates,'AVGTmask.nii');
avgtfile =fullfile(patemplates,'AVGT.nii');
file     =char(z.image); %'x_masklesion.nii';

useUnionMask =z.useUnionMask;  %[0|1]
hthresh      =z.hthresh;
blocksize    =z.blocksize;
nperms       =z.nperms;
suffix       =char(z.suffix);


% % tail=1;
% % hthresh   =0.05;
% hthresh   =0.001;
% blocksize =5;
% %blocksize =0;
% nperms    =100;

outdir=char(z.outdir);
if isempty(outdir);
    outdir= fullfile(pastudy,'results');
end
[~,filenameShort, ext]=fileparts(file);
dirname=[ 'stat_' filenameShort '_blk' num2str(blocksize) '_p' num2str(hthresh) suffix ];
paout=fullfile(outdir, dirname);

if nargout>1
    varargout{1}=paout;
end

% try; rmdir(paout,'s'); end
if exist(paout)~=7; mkdir(paout); end

try; delete(fullfile(paout,'*')); end
try; delete(fullfile(paout,'plots','*')); end

% ==============================================
%%   read excelfile
% ===============================================
[~,~,ah]=xlsread(Fgroup);
ah=xlsprunesheet(ah);
ha =ah(1,1:2);
a  =ah(2:end,1:2);

% ==============================================
%%   get atlas
% ===============================================
at=struct();
[at.hat at.at]=rgetnii(Fatlas);
[pa_at,at_name, ~]=fileparts(Fatlas);
Fatlas_xls=fullfile(pa_at,[at_name '.xlsx']);
[~,~,e0]=xlsread(Fatlas_xls);
e0=xlsprunesheet(e0);
at.he=e0(1,:);
at.e =e0(2:end,:);

% ==============================================
%%   make group-struct
% ===============================================
gr=struct();
gr.group=unique(a(:,2))';
for i=1:length(gr.group)
    ix=find(strcmp(a(:,2), gr.group{i}));
    gr.idx{1,i}    =ix;
    gr.animals{1,i}=a(ix,1);
    gr.n(1,i)      =length(ix);
end
gr.info1='### origTable';
gr.ha =ha;
gr.a  =a;
% ==============================================
%%   combs
% ===============================================
combs=sort(allcomb(1:length(gr.group),1:length(gr.group)),2);
combs(combs(:,1)==combs(:,2),:)=[];
combs=unique(combs,'rows');
% now the direction in 3rd column
combs1=combs; combs1(:,3)=+1;
combs2=combs; combs2(:,3)=-1;
combs=[];
for i=1:size(combs1,1)
    combs(end+1,:)=combs1(i,:);
    combs(end+1,:)=combs2(i,:);
end

% ==============================================
%%   get maskfile
% ===============================================
[hm m  xyz xyzidx]=rgetnii(maskfile);
m2=m(:);
% ==============================================
%%   proc
% ===============================================
combs2analyize=1:size(combs,1);
%  combs2analyize=1;

for c=combs2analyize;
    missdata={};
    ig1 =combs(c,1);
    ig2 =combs(c,2);
    tail=combs(c,3);
    %% =====[get animals for comparison]==========================================
    comp={gr.group{ig1} gr.group{ig2}};
    if    tail==1; tailstr1='>';  tailstr2='gt';
    else           tailstr1='<';  tailstr2='lt';
    end
    compStr1=strjoin(comp,[  tailstr1     ]);
    compStr2=strjoin(comp,['__' tailstr2 '__']);
    cprintf('*[0 0 1]',['comparison-'  num2str(c) ': ' compStr1  '\n']);
    cprintf('*[0 0 1]',[repmat('-',[1 length( ['comparison-'  num2str(c) ': ' compStr1])])  '\n']);
    
    animallist=[gr.animals{ig1}    ; gr.animals{ig2}];
    animalvec =[zeros(gr.n(ig1),1) ; ones(gr.n(ig2),1)];
    %check data+remove from list if not exist
    isvalid=zeros(length(animallist),1);
    for i=1:length(animallist)
        F1=fullfile(padat,animallist{i}, file );
        if exist(F1)==2; isvalid(i,1)=1; end
    end
    idel=find(isvalid==0);
    missdata=animallist(idel); % remember miss datafile
    animallist(idel)=[];
    animalvec(idel) =[];
    %% =====[make struct of animals for logging]=====================
    igr1=find(animalvec==0);
    igr2=find(animalvec==1);
    group=struct;
    group.info='current comparison';
    group.group=comp;
    group.animals={ animallist(igr1)  animallist(igr2) };
    group.n      =[ length(igr1)  length(igr2)];
    group.missdata ='';
    group.hmissdata='';
    if ~isempty(missdata)
        group.missdata={};
        group.hmissdata={'excludedAnmial' 'group' 'reason'};
        for i=1:length(missdata)
            
            reason=[ 'file "'  file '" not found']           ;
            if exist(fullfile(padat,missdata{i}))~=7
                reason=[ 'folder "'  missdata{i} '" not found'];
            end
            group.missdata(i,:)=[gr.a(strcmp(gr.a(:,1),missdata{i}),:)  reason];
        end
    end
    %% ===[load the data]============================================
    hd=spm_vol(fullfile(padat,animallist{1}, file ));
    d2=zeros( prod(hd.dim) ,length(animallist)); %alloc
    fprintf('%s', 'loading data..');
    for i=1:length(animallist)
        pdisp(i,5);
        F1=fullfile(padat,animallist{i}, file );
        [hd d]=rgetnii(F1);
        d2(:,i)=d(:);
    end
    fprintf(' ..Done! \n');
    %% ==============================================
    %%   get voxels and make statistic
    %% ===============================================
    if useUnionMask==0;         is=find(m2==1);
    else                        is=find(sum(d2,2)~=0);
    end
    Y=d2(is,:);
    xyzidxmask=xyzidx(:,is);
    [pv or ch] = voxelwise_chi2(Y, animalvec,tail);
    ixnan=find(isnan(pv));
    pv(ixnan)=1;
    or(ixnan)=0;
    [OR PV]     =deal(zeros(size(m2)));
    OR(is)=or;      OR2   =reshape(OR,hm.dim);
    PV(is)=pv;      PV2   =reshape(PV,hm.dim);
    %% =====[bwlabel]==========================================
    ip     =find(pv(:)<hthresh);
    r=zeros(size(m2));
    r(is(ip))=1;
    r2=reshape(r,hm.dim);
    [cl cn ]=bwlabeln(r2);
    cluster_sizes = histcounts(cl, 'BinMethod', 'integers');
    cluster_sizes(1)=[];%remove 0-as value
    %disp(['maxCLuster_real: '  num2str(max(cluster_sizes)) ]);
    %% ==============================================
    %%   make block-shuffling approach: Define block size
    %% ===============================================
    if blocksize>0
        %bs = [5]; % Define block size
        si=hm.dim    ;%164   212   158
        [xx yy zz]=ndgrid(1:si(1),1:si(2),1:si(3));
        cm=floor( (xx-1) / blocksize)+floor( (yy-1) / blocksize) *...
            100+floor( (zz-1) / blocksize)*10000;
        cm2=cm(:);
        cmmask=cm2(is);
        
        uniblock=unique(cmmask); uniblock(uniblock==0)=[];
        block_idx=repmat({[]},[length(uniblock)  1]);
        for i=1:length(uniblock)
            block_idx{i,1}= find(cmmask==uniblock(i));
        end
    else
        block_idx=[];
    end
    
    %% ==============================================
    %%   permutation-test
    %% ===============================================
    n_subjects=size(d2,2);
    %nperms=100;
    clustsizeperm=zeros(nperms,1);
    rng('shuffle')
    timex1=tic;
    if z.isparfor==1
        parfor i=1:nperms
            Y2=Y;
            % ===============================================
            if blocksize>0
                for j=1:length(block_idx)
                    Y2(block_idx{j},:)=Y2( block_idx{j}  ,randperm(n_subjects));
                end
            else
                % do nothing
            end
            % ===============================================
            animalvec_perm = animalvec(randperm(n_subjects));
            [pv2 or2 ch2] = voxelwise_chi2(Y2, animalvec_perm,tail);
            ip2=find(pv2<hthresh);
            rp=zeros(size(m2));
            rp(is(ip2))=1;
            rp2=reshape(rp,hm.dim);
            [clp cnp]=bwlabeln(rp2);
            clsize_perm = histcounts(clp, 'BinMethod', 'integers');
            if length(clsize_perm)>1
                maxcl(i,1)=max(clsize_perm(2:end)); % not zero..thus starting from 1
            end
        end
    else
        for i=1:nperms
            Y2=Y;
            pdisp(i,500);
            % ===============================================
            if blocksize>0
                for j=1:length(block_idx)
                    Y2(block_idx{j},:)=Y2( block_idx{j}  ,randperm(n_subjects));
                end
            else
                % do nothing
            end
            % ===============================================
            animalvec_perm = animalvec(randperm(n_subjects));
            [pv2 or2 ch2] = voxelwise_chi2(Y2, animalvec_perm,tail);
            ip2=find(pv2<hthresh);
            rp=zeros(size(m2));
            rp(is(ip2))=1;
            rp2=reshape(rp,hm.dim);
            [clp cnp]=bwlabeln(rp2);
            clsize_perm = histcounts(clp, 'BinMethod', 'integers');
            if length(clsize_perm)>1
                maxcl(i,1)=max(clsize_perm(2:end)); % not zero..thus starting from 1
            end
        end
    end
    disp(sprintf('dTperm: %2.2fmin',toc(timex1)/60));
    %% ==============================================
    %%   check for significant clusters
    %% ===============================================
    % 95th percentile cluster size threshold
    cluster_size_threshold = prctile(maxcl, 95);
    corrected_clusters = find(cluster_sizes >= cluster_size_threshold);
    %disp(['maxCLuster_real: '  num2str(max(cluster_sizes)) ]);
    disp(['..found max clustersize: ' num2str(max(cluster_sizes))]);
    disp(['..expected clustersize : ' num2str(cluster_size_threshold)]);
    if length(corrected_clusters)==0
        cprintf('[1 0 1]',['..survived clusters    : '  num2str(length(corrected_clusters))  '\n']);
    else
        cprintf('*[0.4667    0.6745    0.1882]',['..survived clusters    : '  num2str(length(corrected_clusters))  '\n']);
    end
    if 0
        fg,plot([1:length((maxcl))  ],sort(maxcl),'.r-');
        hold on
        hline(max(cluster_sizes),'b');
        hline(cluster_size_threshold,'m');
    end
    %% ==============================================
    %% if cluster survive save image
    %% ===============================================
    ic=find(cluster_sizes>cluster_size_threshold);
    if ~isempty(ic)
        
        %% ====[get clusterVOL]===========================================
        clnum=1:length(cluster_sizes);
        clkeep=clnum(ic);
        o1=zeros(size(m2));
        for i=1:length(clkeep)
            iv=(find(cl(:)==clkeep(i)));
            o1(iv)=i;
        end
        o1=reshape(o1,hd.dim);
        %[v vn]=bwlabeln((o1>0)); vn
        %% ----save sign clustered OddsRatio
        nameout=['s_' pnum(c,2) '_' compStr2  '_oddsR_SIGNIF_' filenameShort ''   '.nii' ];
        Fo1=fullfile(paout,nameout);
        ORsig=OR2.*(o1>0);
        rsavenii(Fo1, hm, ORsig );
        showinfo2([ 'img_ORsig' ] ,avgtfile,Fo1,13);
        %% ======[clusterINFO]=========================================
        
        nvoxsig=[];
        for i=1:length(clkeep)
            nvoxsig(i)=length(find(o1==i));
        end
        [~,nvossigsort]=sort(nvoxsig,'descend');
        
        
        tr_npeakClust   =z.CLpeak_num;
        tr_clustDist    =z.CLpeak_dist;
        
        
        t1=[];
        for i=1:length(nvossigsort)
            ix=find(o1==nvossigsort(i));
            %dx=OR2.*(o1==nvossigsort(i));
            %[sm]=clustervol(dx(:)',xyzidx,hm) ;
            [sm]=clustervol(OR2(ix)',xyzidx(:,ix),hm) ;
            sm.A=sm.A.*0+1;
            
            
            
            
            [sv]=clustermaxima(sm.Z,sm.A,sm.XYZ,sm.hdr,tr_npeakClust,tr_clustDist,'');
            
            tx=[];
            for j=1:length(sv.A)
                
                io=sub2ind(hd.dim,sv.XYZ(1,j),sv.XYZ(2,j),sv.XYZ(3,j) );% get index
                %chck:  sv.Z(j)
                %  -'clusterNo'  'K'     'Z'     'pvalue'  'x' 'y' 'z'
                tx(j,:)= [  i length(ix)  sv.Z(j) PV(io) sv.XYZmm(:,j)'   cluster_size_threshold ];
                %tx(j,:)=[  i length(ix)  sv.Z(j) sv.XYZmm(:,j)' ];
            end
            [ so isort]=sort(sv.Z,'descend');
            tx=tx(isort,:);
            t1=[t1; tx];
            
        end
        %uhelp(plog([],[ t1 ],0,'paired ttest , maually calc'),1)
        
        
        
        %% ===[save oddsRatio image]============================================
        
        %---oddsRatio
        %nameout2=['s_' pnum(c,2) '_' compStr2  '_oddsR_' filenameShort ''   '.nii' ];
        nameout2=strrep(nameout,'_oddsR_SIGNIF_','_oddsR_UNCOR_');
        Fo1=fullfile(paout,nameout2);
        rsavenii(Fo1, hm,reshape(OR2,hm.dim));
        showinfo2([ 'img_OR' ] ,avgtfile,Fo1,13);
        
        % ==============================================
        %%   save info
        % ===============================================
        
        
        v={};
        v={...
            ['comp-index: ' num2str(c)]
            ['comparison: ' compStr1]
            ['file: '    file]
            ['test: '  'chi-square']
            ['nperms: '  num2str(nperms)]
            ['blocksize: ' num2str(blocksize)]
            ['hthresh: '  num2str(hthresh)]
            
            ['expected clustersize: ' num2str(cluster_size_threshold)]
            ['survived clusters: '    num2str(length(ic))]
            };
        
        t2=[];
        
        
        
        vc= ['survived clustersSizes: '...
            regexprep(strjoin(cellstr(num2str(sort(unique(t1(:,2)),'descend'))),','),'\s+','')];
        
        % ===[atlas-labels]============================================
        ht1={'clustNo' 'voxels' 'OddsR' 'p' 'x' 'y' 'z'  'clusterThreshold'};
        c_x=find(strcmp(ht1,'x'));
        t2={};
        for i=1:size(t1,1)
            df=sum((xyz-repmat(  t1(i,[c_x:c_x+2])' ,[1 size(xyz,2)   ])).^2,1);
            iv=find(df==min(df));
            atid=at.at(iv);
            IDzeroIsfound=0;
            if atid==0 % get next nearsted-label if atid='0'
                [df_sorted df_isort]=sort(df);
                atIDS_sortedDF=at.at(df_isort(:));
                iv=df_isort(min(find(atIDS_sortedDF~=0)));
                atid=at.at(iv);
                IDzeroIsfound=1;
            end
            
            iat=find(cell2mat(at.e(:,4))==atid);
            lab='not defined';
            if ~isempty(iat)
                if IDzeroIsfound==0;
                    lab=at.e{iat,1};
                else
                    lab=[at.e{iat,1} ' nearest' ] ;
                end
            else
                atid=0;
            end
            t2(i,:)=[num2cell(t1(i,:)) lab atid];
        end
        ht2=[ht1 'region' 'ID'];
        %vt=plog([],[ht2; t2 ],0,'clusters');
        % ===============================================
        v=[v; vc];
        
        
        
        
        iw1=find(animalvec==0);
        iw2=find(animalvec==1);
        va={['']
            ['#GROUP-INFO: ']
            [ 'group-1 : ' comp{1} '  (n=' num2str(group.n(1)) ')']
            [ 'group-2 : ' comp{2} '  (n=' num2str(group.n(2)) ')']
            [ 'missings: n=' num2str(size(group.missdata,1)) ]
            ['']};
        
        v1={' '};
        v1{end+1,1}=[ comp{1} '-ANIMALS (grp1, n=' num2str(group.n(1)) ')' ];
        v1=[v1; cellfun(@(a){ [ '    ' a]} ,group.animals{1})];
        v1{end+1,1}=' ';
        v1{end+1,1}=[ comp{2} '-ANIMALS (grp2, n=' num2str(group.n(2)) ')' ];
        v1=[ v1; cellfun(@(a){ [ '    ' a]} ,group.animals{2})];
        v1{end+1,1}=' ';
        
        v1{end+1,1}=[ 'missing data (' num2str(size(group.missdata,1)) ')' ];
        dum={'none'};
        if size(group.missdata,1)>0
            dum=plog([],[group.hmissdata; group.missdata],0,'','plotlines=0;al=1');
        end
        v1=[ v1; dum];
        
        paras=z;
        paras.atlas  =Fatlas;
        paras.outdir =paout;
        paralist=struct2list2(paras,'z');
        v1=[ v1;' '; '***PARAMETER***' ;paralist];
        
        v1=[ v1;' '; '***BATCH***' ;batch(max(regexpi2(batch,'z=\[\];')):end)];
        
        vs={''
            ['#GOLBAL-INFO: ']
            ['study: ' pastudy]
            ['date: ' datestr(now)]
            ['caller: ' mfilename]
            };
        
        v=[v; va; v1; vs];
        %     nameout=['s_' pnum(c,2) '_' compStr2  '_oddsR_' filenameShort ''   '.txt' ];
        %     Fo2=fullfile(paout,nameout);
        %pwrite2file(Fo2,v);
        %showinfo2([ 'txtFile' ] ,Fo2);
        
        %uhelp(plog([],[ v ],0,'','al=1'),1)
        
        %% ===[write excelfile]============================================
        
        %nameout3=['s_' pnum(c,2) '_' compStr2  '_oddsR_' filenameShort ''   '.xlsx' ];
        nameout3=regexprep(nameout,'.nii$','.xlsx');
        Fo3=fullfile(paout,nameout3);
        pwrite2excel(Fo3,{1 'info'}   , {'info'},[],v);
        if ~isempty(t2)
            pwrite2excel(Fo3,{2 'cluster'}, ht2,[],t2);
            showinfo2([ 'xlsfile' ] ,Fo3);
        end
    end
    %% ===============================================
    fprintf([' Done! (%2.1fmin, %dperms) \n'], toc(timex)/60,nperms);
    %% ===============================================
    
end %c


% ==============================================
%%   make plots
% ===============================================
plot_uncorrected=z.plot_uncorrected;


[fi_nii] = spm_select('FPList',paout,'^s_.*_SIGNIF_.*.nii');
if isempty(fi_nii); return; end
fi_nii     =cellstr(fi_nii);                         %signif NII
fiuncor_nii=regexprep(fi_nii,'_SIGNIF_', '_UNCOR_'); %uncorrected NII

fi_xls     =regexprep(fi_nii,'.nii$','.xlsx');        %excelfile


paoutplot=fullfile(paout,'plots');
try; mkdir(paoutplot); end

% [~, dum,~]=fileparts2(fi_nii);
% name=regexprep(dum,{'\[' '\]','_signif'},{''});
% fi_xls=(cellfun(@(a){ [ paout filesep a '.xlsx']} ,name));

plotpeaks='first' ; %'first' or 'all'
plotpeaks='all' ; %'first' or all


% ===============================================
b2={};
num=1;
for i=1:length(fi_xls)  %over excelfiles
    [~,name]=fileparts(fi_xls{i});
    [~,~,b0]=xlsread(fi_xls{i},2);
    b0=xlsprunesheet(b0);
    hb=b0(1,:);
    b =b0(2:end,:);
    c_x      =find(strcmp(hb, 'x'));
    c_clustNo=find(strcmp(hb, 'clustNo'));
    c_region =find(strcmp(hb, 'region'));
    
    
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
        cf;
        ce=cell2mat(b(j,c_x:c_x+2));
        
        r=[];
        r.ce=ce;
        r.alpha       =  [1  0.7];
        r.blobthresh  =  [];
        r.cbarvisible =  [0  1  1  1  1];
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
        
        regname=regexprep(b{j,c_region},{'\s+','(' ')' ,'/'},{'_','','','or'});
        
        dx=b(j,:);
        disp(['..saving png-' num2str(num)]);
        if plot_uncorrected==1
            r2=r;
            r2.cmap{2}   =z.OR_cmap_uncorrected;
            r2.clim(2,:) =z.OR_range_uncorrected;
            
            %__uncorrected plot
            files={avgtfile  fiuncor_nii{i}  };
            orthoslice(files,r2); drawnow; drawnow; drawnow
            nameUncor=regexprep(name,'_SIGNIF_','_UNCOR_');
            outname1=['p' pnum(num,2) '_' nameUncor '_CL' num2str(b{j,c_clustNo}) ...
                '_MAX' num2str(peakno(j)) ...
                '_' regname '.png' ];
            Fo4=fullfile(paoutplot,outname1);
            orthoslice('post','saveas',Fo4,'dosave',1);
        else
            Fo4={''};
        end
        
        
        %___signif plot
        cf;
        files={avgtfile  fi_nii{i}  };
        orthoslice(files,r); drawnow; drawnow; drawnow
        outname2=['p' pnum(num,2) '_' name '_CL' num2str(b{j,c_clustNo}) ...
            '_MAX' num2str(peakno(j)) ...
            '_' regname '.png' ];
        Fo5=fullfile(paoutplot,outname2);
        orthoslice('post','saveas',Fo5,'dosave',1);
        
        
        b2(end+1,:)=[dx outname1 outname2];
        
        
        
        
        
        % ===============================================
        num=num+1;
    end
end
hb2=[ hb  'uncor_png'  'sig_png' ];

% ==============================================
%%   make PPT
% ===============================================

%% ===[make 1st slide]============================================
disp(['..creating powerpointfile']);
[ ~, studyName]=fileparts(pastudy);
info={};
info(end+1,:)={'study:'      [studyName]} ;
info(end+1,:)={'studyPath:'  [pastudy]} ;
info(end+1,:)={'file:'        file} ;
info(end+1,:)={'date:'     [datestr(now)]} ;
info(end+1,:)={' '     '  '} ;

info(end+1,:)={'Hthresh: '     ['p<' num2str(hthresh)]} ;
info(end+1,:)={'nperms:  '     [num2str(nperms)]} ;
info(end+1,:)={'blocksize:  '     [num2str(blocksize)]} ;

info= plog([],[info],0,'Contrast','plotlines=0;al=1');
v1=struct('txy', [0 1.5 ], 'tcol', [0 0 1],'tfs',11, 'tbgcol',[1 1 1],...
    'tfn','consolas');
v1.text=info;
info2= plog([],[{'PARAMETER'};paralist],0,'','plotlines=0;al=1;');
v2=struct('txy', [1 10 ], 'tcol', [0 0 0],'tfs',7, ...
    'tbgcol',[1    0.96    0.92],  'tfn','consolas');
v2.text=info2;
vs={v1 v2};
titlesufx='';
titcol=[0 0 0];
% ===============================================
% pptnameShort=['chiSquareTest_' regexprep(file,'.nii','') ...
%     '_blkSz' num2str(blocksize)...
%     '_Thr' num2str(hthresh)  '.pptx'];
pptnameShort=[dirname '.pptx'];

pptfile2=fullfile(paout, pptnameShort );
img2ppt(paout,[], pptfile2,'doc','new',...
    'title',['chiSquareTest: [' studyName '], file: ' file  ],...
    'multitext',vs,'disp',0 );

% =======[ 2nd slide]======================
% ======[make all other slides]=========================================
ic_sig_png=find(strcmp(hb2,'sig_png'));
fiplot=b2(:,ic_sig_png);
if isempty(fiplot); return; end

fiplotFP=stradd(fiplot,[  paoutplot filesep ],1);
% [~, fiplot ]=fileparts2(fiplotFP);
%  fiplot=stradd(fiplot,'.png',2);
condshort=regexprep(fiplot,{'_oddsR.*' ,'p\d\d_s_\d\d_'},{''});
uni_condshort=unique(condshort,'stable');

% [fiplotFP] = spm_select('FPList',paoutplot,'^p.*.*.png');
% fiplotFP=cellstr(fiplotFP);
% % [fiplot] = spm_select('List',paoutplot,'^p.*.png');
% [~, fiplot ]=fileparts2(fiplotFP);
% fiplot=stradd(fiplot,'.png',2);
%
%
% if isempty(fiplot); return; end
% fiplot=cellstr(fiplot);
% condshort=regexprep(fiplot,{'_oddsR.*' ,'p\d\d_s_\d\d_'},{''});
% uni_condshort=unique(condshort,'stable');

% ===============================================

% ===[2nd slide: add table]============================================
condshortHR=regexprep(condshort,{'__lt__','__gt__' },{'<', '>'});
b3 =[ num2cell([1:size(b2,1)])'  condshortHR    b2           ];
hb3=[ 'idx'                      'condition'    hb2          ];

b3=cellfun(@(a){ [ num2str(a)]} ,b3);

info2= plog([],[hb3;b3],0,'Contrast','plotlines=0;al=1;');
v2=struct('txy', [0.01 1.3 ], 'tcol', [0 0 0],'tfs',7, ...
    'tbgcol',[1    0.96    0.92],  'tfn','consolas');
v2.text=info2;
vs={}; vs{1}=v2;

if 1
    img2ppt(paout,[], pptfile2,'doc','add',...
        'crop',0,'gap',[1 0],'columns',1,'xy',[0.02 1 ],'wh',[ nan 3.6],...
        'title',[' [' 'Cluster-table' ']'  titlesufx ],...
        'Txy',[0 0],'Tha','left','Tcol',titcol ,...
        'multitext',vs,'disp',0 );
end

%% ===[other slides grouped by contrast]============================================
fiplot_sig    = b2(:, end);
% condshort     = regexprep(fiplot,{'_oddsR.*' ,'p\d\d_s_\d\d_'},{''});
condshort_sig =regexprep(fiplot_sig,{'_oddsR.*' ,'p\d\d_s_\d\d_'},{''});
co            = uni_condshort;

if plot_uncorrected==1  ;   nimg_per_page  =2;           %number of images per plot
else                        nimg_per_page  =4;           %number of images per plot
end
for j=1:length(co)
    if mod(j,2)==1; titcol=[0 0 1]; else titcol=[0 0 0]; end
    imgnosig      = find(strcmp(condshort_sig ,co{j} ));
    x2            = b3(imgnosig,:);
    plotSlideNo   = ceil((1:size(x2,1))./nimg_per_page);
    nslides       = max(plotSlideNo);
    
    for i=1:nslides
        titlesufx='';  if i>1; titlesufx=' ..continued';   end
        ix=find(plotSlideNo==i);
        x3=x2(ix,:); %TABLE
        
        %PNG-images to display
        if     plot_uncorrected==1    dum   =[x3(:,end-1) x3(:,end)]';
        else                          dum   =[ x3(:,end)]';
        end
        png     =dum(:);
        png(cellfun(@isempty,png))=[]; % remove empties..this is the case when no uncorrected files are created
        pngFP   =stradd(png,[paoutplot filesep],1);
        pnglist =[{'Files:'}; png];
        
        condName=regexprep(co{j},{'__lt__','__gt__' },{'<', '>'});
        info2= plog([],[hb3;x3],0,'Contrast','plotlines=0;al=1;');
        v2=struct('txy', [0.01 16 ], 'tcol', [0 0 0],'tfs',8, ...
            'tbgcol',[1    0.96    0.92],  'tfn','consolas');
        v2.text=info2;
        vs={}; vs{1}=v2;
        img2ppt(paout,pngFP, pptfile2,'doc','add',...
            'crop',0,'gap',[1 0],'columns',1,'xy',[0.02 1 ],'wh',[ nan 3.6],...
            'title',['condition-' num2str(j)  ': [' condName ']'  titlesufx ],...
            'Txy',[0 0],'Tha','left','Tcol',titcol ,...
            'text',pnglist,'txy', [15 3 ],'tcol', [0 0 1],'tbgcol', [1 1 1],...
            'tfs',9,...
            'multitext',vs,'disp',0 );
    end
end
showinfo2(['PPTfile2'],pptfile2);

%% ===============================================

cprintf('*[0 0 1]',[sprintf([' Done! (%2.0fmin) \n'], toc(timex)/60)  '\n']);





function [pvals odds_ratios chi2_stat] = voxelwise_chi2(Y, group,tail)
% Computes voxel-wise p-values using Fisher's exact test for small samples
% and Chi-square test for large samples.
%
% Inputs:
% Y - [subjects x voxels] binary matrix (0/1)
% group1 - Indices of subjects in group 1
% group2 - Indices of subjects in group 2
%
% Output:
% pvals - Vector of p-values for each voxel

if size(Y,1)~=length(group);     Y=Y';end

% group1=find(group==0);
% group2=find(group==1);

group1=find(group==1);
group2=find(group==0);


adj=0.5; % Haldane corretion (avoid zero counts in oddsratio calc.)


num_voxels = size(Y, 2);
pvals = nan(1, num_voxels); % Preallocate p-value vector
odds_ratios = nan(1, num_voxels);

% Compute contingency table counts for all voxels at once
group1_pos = sum(Y(group1, :) == 1);
group1_neg = sum(Y(group1, :) == 0);
group2_pos = sum(Y(group2, :) == 1);
group2_neg = sum(Y(group2, :) == 0);

% Compute expected counts under the independence assumption
total_group1 = group1_pos + group1_neg;
total_group2 = group2_pos + group2_neg;
total_pos = group1_pos + group2_pos;
total_neg = group1_neg + group2_neg;
grand_total = total_group1 + total_group2;

expected_group1_pos = (total_group1 .* total_pos) ./ grand_total;
expected_group1_neg = (total_group1 .* total_neg) ./ grand_total;
expected_group2_pos = (total_group2 .* total_pos) ./ grand_total;
expected_group2_neg = (total_group2 .* total_neg) ./ grand_total;

%     % Identify small-sample voxels (expected count < 5 in any cell)
%     small_sample_voxels = (expected_group1_pos < 5) | (expected_group1_neg < 5) | ...
%                           (expected_group2_pos < 5) | (expected_group2_neg < 5);

% Apply Chi-square test for large samples (vectorized)
observed = [group1_pos; group1_neg;
    group2_pos; group2_neg];
expected = [expected_group1_pos; expected_group1_neg;
    expected_group2_pos; expected_group2_neg];

chi2_stat = sum((observed - expected).^2 ./ expected, 1);
pvals = chi2cdf(chi2_stat, 1, 'upper');
pvals=pvals*0.5  ;% ONSE-SIDED

odds_ratios =...
    (   (group1_pos+adj) .* (group2_neg+adj)    ) ...
    ./ ...
    (  (group1_neg+adj)  .* (group2_pos+adj)    );

%% ===============================================

if tail==1
    direction=(group1_pos./total_group1)<(group2_pos./total_group2);
else
    direction=(group1_pos./total_group1)>(group2_pos./total_group2);
end


pvals(~direction)=1-pvals(~direction);

odds_ratios =...
    (   (group1_pos+adj) .* (group2_neg+adj)    ) ...
    ./ ...
    (  (group1_neg+adj)  .* (group2_pos+adj)    );


%        odds_ratios(direction)=1./odds_ratios(direction);
%        odds_ratios(~direction)=1./odds_ratios(~direction);
%
if tail==1
    odds_ratios= 1./odds_ratios;
end

%         disp(['### tail-' num2str(tail) ' ####']);
%         disp(['pvals      : '  sprintf('% 3.2g ',pvals)]);
%         disp(['odds_ratios: '  sprintf('% 2.1f ',odds_ratios)]);
%         disp(['odds_ratios: '  sprintf('% 2.1f ',odds_ratios)]);


%% ===============================================


%     % Apply Fisher’s exact test for small samples (parallelized)
%     small_voxel_indices = find(small_sample_voxels);
%    for i = 1:length(small_voxel_indices)
%         v = small_voxel_indices(i);
%         table = [group1_pos(v), group1_neg(v); group2_pos(v), group2_neg(v)];
%         [~, pvals(v) stats] = fishertest(table);
%         odds_ratios(v) = stats.OddsRatio; % Extract OR from Fisher’s test
%     end




function [s]=clustervol(Z,xyz,hdr, clusterminimum)
% Sizes, maxima and locations of clusters
%
% function [s]=pclustermaxima(Z,xyz,hdr)
%
% IN:
%    Z  : values (Accuracies,t,Z... but not p-values)
%    XYZ: locations [x y x]' indices  [3 x nvox]
%
% OUT:
%       hdr: [1x1 struct]   header
%     XYZmm: [3x254 double] locations [x y x]' {in mm}
%       XYZ: [3x254 double] locations [x y x]' {in voxels}
%      nvox: [254x1 double] size of region {in voxels)
%     regnr: [254x1 double] region number
%         Z: [1x254 double] values
% example:
%    [s]=pclustermaxima(st.Z,st.XYZ,st.hdr)
%
% regnr(i) identifies the ith maximum with a region. Region regnr(i) contains nvox(i) voxels.
%

if exist('clusterminimum')~=1 || isempty(clusterminimum)
    clusterminimum=0;
end

%from [spmlist.m -line 418]
% Includes Darren Gitelman's code for working around
% spm_max for conjunctions with negative thresholds
%----------------------------------------------------------------------
minz        = abs(min(min(Z)));
zscores     = 1 + minz + Z;
[N Z xyz2 A] = spm_max(zscores,xyz);
Z           = Z - minz - 1;

%     %-Convert maxima locations from voxels to mm
%     %----------------------------------------------------------------------
M=hdr.mat;
xyzmm = M(1:3,:)*[xyz2; ones(1,size(xyz2,2))];

%% ===============================================

s.hdr  =hdr;
s.XYZmm=xyzmm;
s.XYZ  =xyz2;
% s.nvox =N;
s.A=A;
s.Z    =Z;

uni=unique(s.A);
clnum=histcounts(s.A, 'BinMethod', 'integers');
clnum(clnum==0)=[];
s.counts=[uni clnum'];
% =====[remove smaller clusters]==========================================
if 0% clusterminimum~=0
    %uni=unique(A);
    %
    idel=find(N<clusterminimum);
    s.XYZmm(:,idel)=[];
    s.XYZ(:,idel)  =[];
    s.A(idel)=[];
    s.Z(idel)=[];
    
    uni=unique(s.A);
    clnum=histcounts(s.A, 'BinMethod', 'integers');
    clnum(clnum==0)=[];
    s.counts=[uni clnum'];
    
    %recode A
    s.counts=flipud(sortrows(s.counts,2));
    a=zeros(size(s.A));
    counts=s.counts;
    for i=1:size(s.counts,1)
        old=s.counts(i,1);
        counts(i,1)         =  [i];
        a(find(s.A==old),1 )=  [i];
    end
    
    s.A     =a;
    s.counts=counts;
end



%% ===============================================

% '<'
% X     - values of 3-D field
% L     - locations [x y x]' {in voxels}
% N     - size of region {in voxels)
% Z     - Z values of maxima
% M     - location of maxima {in voxels}
% A     - region number



function [sv]=clustermaxima(Z,A,XYZ,hdr,Num,Dis,invertZ)

%number of maxima pr cluster and distance among cluster  copy of [spm_list ~line 204]
%
% function [sv]=pclustermaximaContraint(Z,A,XYZ,hdr,Num,Dis)
% NOTE: usage after applying [pclustermaxima]
% IN
%     Z   [vector] (Z,T  but not p!)
%     A   [vector]regnr: [254x1 double] region number
%     XYZ [3xNvox double] locations [x y x]' {in voxels}
%     hdr header
%       Num    default(3)        % number of maxima per cluster
%       Dis    default(8)        % distance among clusters (mm)
% OUT
%       idx: [33x1 double]  indices
%        tb: [33x6 double]  table [xyzmm(3cols) clusterIndex Zvector  idx]
%         Z: [1x33 double]  survived Zvector
%         A: [33x1 double]  survived region number
%       XYZ: [33x1 double]  ..
%     XYZmm: [33x1 double] ..
%       hdr: [1x1 struct]  ...
% EXAMPLE: contrainscluster with max N<=3 max per cluster with distance of 8mm
%    [sv]=pclustermaximaContraint(sm.Z,sm.regnr,sm.XYZ,sm.hdr,3,8)



if strcmp(invertZ,'invert')
    Z=-Z;
end

Z2=Z;%copy to be used later

%   XYZmm2=sm.XYZmm
M=hdr.mat;
XYZmm = M(1:3,:)*[XYZ; ones(1,size(XYZ,2))];

test=sortrows([XYZmm' A Z(:)],4);
%-Local maxima p-values & statistics
%----------------------------------------------------------------------
%     HlistXYZ = [];
tb=[];
while numel(find(isfinite(Z)))
    
    
    
    %-Find largest remaining local maximum
    %------------------------------------------------------------------
    [U,i]   = max(Z);           % largest maxima
    j       = find(A == A(i));  % maxima in cluster
    
    
    %         %-Compute cluster {k} and peak-level {u} p values for this cluster
    %         %------------------------------------------------------------------
    %         if STAT ~= 'P'
    %             Nv      = N(i)/v2r;                       % extent {voxels}
    %
    %             Pz      = spm_P(1,0,   U,df,STAT,1,n,S);  % uncorrected p value
    %             Pu      = spm_P(1,0,   U,df,STAT,R,n,S);  % FWE-corrected {based on Z}
    %             [Pk Pn] = spm_P(1,N(i),u,df,STAT,R,n,S);  % [un]corrected {based on k}
    %             if topoFDR
    %                 Qc  = spm_P_clusterFDR(N(i),df,STAT,R,n,u,QPc); % cluster FDR-corrected {based on k}
    %                 Qp  = spm_P_peakFDR(U,df,STAT,R,n,u,QPp); % peak FDR-corrected {based on Z}
    %                 Qu  = [];
    %             else
    %                 Qu  = spm_P_FDR(   U,df,STAT,n,QPs);  % voxel FDR-corrected {based on Z}
    %                 Qc  = [];
    %                 Qp  = [];
    %             end
    %
    %             if Pz < tol                               % Equivalent Z-variate
    %                 Ze  = Inf;                            % (underflow => can't compute)
    %             else
    %                 Ze  = spm_invNcdf(1 - Pz);
    %             end
    %         else
    %             Nv      = N(i);
    %
    %             Pz      = [];
    %             Pu      = [];
    %             Qu      = [];
    %             Pk      = [];
    %             Pn      = [];
    %             Qc      = [];
    %             Qp      = [];
    %             Ze      = spm_invNcdf(U);
    %         end
    %
    
    
    % Specifically changed so it properly finds hMIPax
    %------------------------------------------------------------------
    tXYZmm = XYZmm(:,i);
    
    
    %         HlistXYZ = [HlistXYZ, h];
    %         if spm_XYZreg('Edist',xyzmm,XYZmm(:,i))<tol && ~isempty(hReg)
    %             set(h,'Color','r')
    %         end
    %         hPage  = [hPage, h];
    
    %         y      = y - dy;
    %
    %         if topoFDR
    %         [TabDat.dat{TabLin,3:12}] = deal(Pk,Qc,Nv,Pn,Pu,Qp,U,Ze,Pz,XYZmm(:,i));
    %         else
    %         [TabDat.dat{TabLin,3:12}] = deal(Pk,Qc,Nv,Pn,Pu,Qu,U,Ze,Pz,XYZmm(:,i));
    %         end
    %         TabLin = TabLin + 1;
    
    %-Print Num secondary maxima (> Dis mm apart)
    %------------------------------------------------------------------
    [l q] = sort(-Z(j));                % sort on Z value
    D     = i;
    
    %             disp([XYZmm(:,D)' A(D) Z(D)]);
    tb(end+1,:)=[XYZmm(:,D)' A(D) Z(D) D];
    for i = 1:length(q)
        d = j(q(i));
        
        
        
        if min(sqrt(sum((XYZmm(:,D)-XYZmm(:,d)*ones(1,size(D,2))).^2)))>Dis;
            
            if length(D) < Num
                
                %                     % Paginate if necessary
                %                     %------------------------------------------------------
                %                     if y < dy
                %                         h = text(0.5,-5*dy,sprintf('Page %d',...
                %                             spm_figure('#page',Fgraph)),...
                %                             'FontName',PF.helvetica,...
                %                             'FontAngle','Italic',...
                %                             'FontSize',FS(8));
                %
                %                         spm_figure('NewPage',[hPage,h])
                %                         hPage = [];
                %                         y     = y0;
                %                     end
                
                % voxel-level p values {Z}
                %------------------------------------------------------
                %                     if STAT ~= 'P'
                %                         Pz    = spm_P(1,0,Z(d),df,STAT,1,n,S);
                %                         Pu    = spm_P(1,0,Z(d),df,STAT,R,n,S);
                %                         if topoFDR
                %                             Qp = spm_P_peakFDR(Z(d),df,STAT,R,n,u,QPp);
                %                             Qu = [];
                %                         else
                %                             Qu = spm_P_FDR(Z(d),df,STAT,n,QPs);
                %                             Qp = [];
                %                         end
                %                         if Pz < tol
                %                             Ze = Inf;
                %                         else
                %                             Ze = spm_invNcdf(1 - Pz);
                %                         end
                %                     else
                %                         Pz    = [];
                %                         Pu    = [];
                %                         Qu    = [];
                %                         Qp    = [];
                %                         Ze    = spm_invNcdf(Z(d));
                %                     end
                
                %                     h     = text(tCol(7),y,sprintf(TabDat.fmt{7},Pu),...
                %                         'UserData',Pu,...
                %                         'ButtonDownFcn','get(gcbo,''UserData'')');
                %                     hPage = [hPage, h];
                %
                %                     if topoFDR
                %                     h     = text(tCol(8),y,sprintf(TabDat.fmt{8},Qp),...
                %                         'UserData',Qp,...
                %                         'ButtonDownFcn','get(gcbo,''UserData'')');
                %                     else
                %                     h     = text(tCol(8),y,sprintf(TabDat.fmt{8},Qu),...
                %                         'UserData',Qu,...
                %                         'ButtonDownFcn','get(gcbo,''UserData'')');
                %                     end
                %                     hPage = [hPage, h];
                %                     h     = text(tCol(9),y,sprintf(TabDat.fmt{9},Z(d)),...
                %                         'UserData',Z(d),...
                %                         'ButtonDownFcn','get(gcbo,''UserData'')');
                %                     hPage = [hPage, h];
                %                     h     = text(tCol(10),y,sprintf(TabDat.fmt{10},Ze),...
                %                         'UserData',Ze,...
                %                         'ButtonDownFcn','get(gcbo,''UserData'')');
                %                     hPage = [hPage, h];
                %                     h     = text(tCol(11),y,sprintf(TabDat.fmt{11},Pz),...
                %                         'UserData',Pz,...
                %                         'ButtonDownFcn','get(gcbo,''UserData'')');
                %                     hPage = [hPage, h];
                
                % specifically modified line to use hMIPax
                %------------------------------------------------------
                tXYZmm = XYZmm(:,d);
                %                     h     = text(tCol(12),y,...
                %                         sprintf(TabDat.fmt{12},tXYZmm),...
                %                         'Tag','ListXYZ',...
                %                         'ButtonDownFcn',[...
                %                         'hMIPax = findobj(''tag'',''hMIPax'');',...
                %                         'spm_mip_ui(''SetCoords'',',...
                %                         'get(gcbo,''UserData''),hMIPax);'],...
                %                         'Interruptible','off','BusyAction','Cancel',...
                %                         'UserData',XYZmm(:,d));
                
                %                     HlistXYZ = [HlistXYZ, h];
                %                     if spm_XYZreg('Edist',xyzmm,XYZmm(:,d))<tol && ...
                %                             ~isempty(hReg)
                %                         set(h,'Color','r')
                %                     end
                %                     hPage = [hPage, h];
                D     = [D d];
                %                     y     = y - dy;
                %                     if topoFDR
                %                     [TabDat.dat{TabLin,7:12}] = ...
                %                         deal(Pu,Qp,Z(d),Ze,Pz,XYZmm(:,d));
                %                     else
                %                     [TabDat.dat{TabLin,7:12}] = ...
                %                         deal(Pu,Qu,Z(d),Ze,Pz,XYZmm(:,d));
                %                     end
                %                     TabLin = TabLin+1;
                
                %                 disp( [XYZmm(:,d)' A(d) Z(d)]);
                tb(end+1,:)=[XYZmm(:,d)' A(d) Z(d) d];
                
            end
        end
    end
    Z(j) = NaN;     % Set local maxima to NaN
end             % end region


idx=tb(:,6);


sv.nvox= tb(:,6);
sv.tb=tb;
if strcmp(invertZ,'invert')
    sv.Z     =-[Z2(idx)];
else
    sv.Z     =[Z2(idx)];
end


sv.A     =A(idx);
sv.XYZ   =XYZ(:,idx);
sv.XYZmm =XYZmm(:,idx);
sv.hdr   =hdr;
if strcmp(invertZ,'invert')
    sv.Z  =-sv.Z(:);
else
    sv.Z  =sv.Z(:);
end
sv.A  =sv.A(:);
% [sv]=pclustermaximaContraint(Z,A,XYZ,hdr,Num,Dis)


%% ====sort===========================================
w=sortrows([sv.A sv.nvox [1:length(sv.A)]'],[1 -2]);
isort=w(:,3);

sv.nvox   =sv.nvox(isort) ;% nvox: [9x1 double]
sv.tb     =tb(isort,:)    ;% tb: [9x6 double]
sv.Z      =sv.Z(isort)    ;% Z: [9x1 double]
sv.A      =sv.A(isort)    ;% A: [9x1 double]
sv.XYZ    =sv.XYZ(:,isort)   ;% XYZ: [3x9 double]
sv.XYZmm  =sv.XYZmm(:,isort) ;% XYZmm: [3x9 double]


%% ===============================================













