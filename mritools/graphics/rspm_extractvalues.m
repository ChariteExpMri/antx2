


function [fo]=rspm_extractvalues(v0)


if 0
    %% ===============================================
    clc;
    v=struct();
    v.indir=  {'H:\Daten-2\Imaging\AG_Ambrozkiewicz\voxstat\voxstat_unequalVar_smooth0\res_vx_gr_02_f__vs__m__x_fa\data\x_fa_C2__f_LT_m__CLUST0.001k449.xlsx'  };
    v.type='cluster';
    v.outdir=fullfile(pwd,'test1.xlsx');
    [fo]=rspm_extractvalues(v);
    
    %% ==========no sign result=====================================
    clc;
    v=struct();
    v.indir=  {'H:\Daten-2\Imaging\AG_Ambrozkiewicz\voxstat\voxstat_unequalVar_smooth0\res_vx_gr_01_ki__vs__wt__JD\data\JD_C2__ki_LT_wt__CLUST0.001k4879.xlsx'  };
    v.type='cluster';
    v.outdir=fullfile(pwd,'test2.xlsx');
    [fo]=rspm_extractvalues(v);
    %% ===============================================
    indir='H:\Daten-2\Imaging\AG_Ambrozkiewicz\voxstat\voxstat_unequalVar_smooth0';
    flt='.*CLUST.*.xlsx';
    [fis] = spm_select('FPListRec',indir,flt); fis=cellstr(fis);
    v=struct();
    v.indir=  fis;%(1:4)
    v.type='peak';%'cluster';
    v.outdir=fullfile(pwd,'test6_peaks.xlsx');
    [fo]=rspm_extractvalues(v);
    %% ===============================================
end

% ==============================================
%%   defaults
% ===============================================
v.outdir     =fullfile(pwd,'test_spmImages');  %OUTPUT-FOLDER
v.study      =antcb('getstudypath');           %STUDYFOLDER
% v.template   =fullfile(v.study,'templates','AVGT.nii');%BACKGROUND-IMAGE
v.meth       ='clust';  % used method: %'clust', 'FWE' ,'none' , default, 'clust'
v.type       ='peak';   %aggregate data from  peaks or cluster, either 'peaks' or 'cluster'
% v.cluster    ='all';   %plot cluster, either 'all' or 'first' ; default 'all', i.e. plot all clusters
% v.prefix     ='p';     %output png-prefix
% v.addnumber =1;  %add number to putput PNG-file ; [0,1]; default:[1]
% v.addlabel  =1;  %add anat.label to putput PNG-file ; [0,1]; default:[1]
% v.makePPT   =1;  %make powerpointFile; [0,1]; default:[1]
v.outdir    =fullfile(v.study ,'voxstatSinglevalues',['method_' v.meth]); %target-Folder
v.additer   =1;
v.iterprefix='table_';

% ==============================================
%%  v0-inputparams
% ===============================================
if exist('r0')==0; r0.dummy=1; end
v=catstruct(v,v0);
fo=[];
% ==============================================
%%   get xlsfiles
% ===============================================
if iscell(v.indir) %assuming files
    files=v.indir;
else %maybe path
    
    if isdir(v.indir)==1
        [files] = spm_select('FPListRec',v.indir,'.*.xlsx');
        if isempty(files);         disp(['no excel-files found in  path..abort..']) ;
            return;
        end
        files=cellstr(files);
        files=files(regexpi2(files,v.meth));
    else
        files=cellstr(v.indir);
        files=files(find(cell2mat(cellfun(@(a) {[ exist(a)]} ,files ))==2)) ;% only existing excelfiles
    end
    if isempty(char(files));
        disp(['no excel-files with method "' v.meth '"found in path..abort..']) ; return ;
    end
end



t4=[];
iter=0;
fprintf(['[' v.meth ']' 'extractvalues..']);
for i=1:length(files)
    pdisp(i,1);
    fclose('all');
    [ t3 ht3 iter] =proc(files{i},v,iter);
    t4=[t4; t3];
    if ~isempty(ht3);      ht4=ht3;    end
end
fprintf('Done!\n');
fclose('all');


% ==============================================
%%   write excelfile
% ===============================================
if ~isempty(t4)
    outname=v.outdir;
    [paout nameout ext]=fileparts(outname);
    if isempty(paout); paout=pwd;end
    if isempty(ext)
        paout=fullfile(paout,nameout);
        nameout=[v.meth '_singlevalues'];
    end
    if exist(paout)~=7; mkdir(paout); end
    if isempty(nameout); nameout=[v.meth '_singlevalues']; end
    fo1=fullfile(paout, [ nameout '.xlsx' ]);
    pwrite2excel(fo1,{1 ['singlevalues_' v.type  ]}, ht4,[],t4);
    showinfo2(['xlsfile'],fo1);
    fo=fo1;
end


% ==============================================
%%   proc
% ===============================================

function [ t3 ht3 iter]= proc(infile,v,iter)
%% ===============================================
[ t3 ht3]=deal([]);



[pa name ext]=fileparts(infile);

% --- Detect sheets
[~, sheets] = xlsfinfo(infile);
% if length(sheets)==1; return; end
%--- Read metadata from sheet1
sheet_meta  = sheets{1};
[~,~,raw_meta] = xlsread(infile, sheet_meta);
col1=cellfun(@(a) {[ num2str(a) ]} ,raw_meta(:,1) );
col2=cellfun(@(a) {[ num2str(a) ]} ,raw_meta(:,2) );
%check if 'k' exist and if k>0
isok=0;
% checkprefixinfile=strfind(inname,v.prefix);
% if ~isempty(checkprefixinfile) && checkprefixinfile==1
%     isok=0;
% end
try
    ik=regexpi2(col2,'k=');
    cl_size=str2num(regexprep(col2{ik},'k=',''));
    if cl_size>1
        isok=1;
    end
end
if isok==0; return; end
% --- Read table (raw)
sheet_table = sheets{2};
[~,~,raw] = xlsread(infile, sheet_table);
% Combine header rows (row1 + row2)
header1 = raw(1,:);
header2 = raw(2,:);
headers_combined = strcat(header1,'_',header2);
% Data starts from row 3
d = raw(3:end,:);
ix_noclustersfound=regexpi2(  cellfun(@(a) {[ num2str(a)]} ,d(:,2) ) ,'no suprathreshold clusters found');
if ~isempty(ix_noclustersfound)
    return
end

%% ====[define peaksno and clutnum -->make new table]===========================================
c_k=find(strcmp(headers_combined,'cluster_equivk'));
k=cell2mat(d(:,c_k));

clustno =0;
peakno  =1;
clust_peak=zeros(size(k,1),2);
for i=1:length(k)
    if ~isnan(k(i))
        clustno=clustno+1;
        peakno=1;
    else
        peakno=peakno+1;
    end
    clust_peak(i,:)=[clustno  peakno  ];
end
t=[ num2cell(clust_peak) d ];
ht=[ 'cluster' 'peak'  headers_combined];

%CLUSTER-AVERAGED: keep only cluster (1st peak)
if strcmp(v.type,'cluster')
    icl=find(cell2mat(t(:,find(strcmp(ht,'peak'))))==1);
    t=t(icl,:);
end

% uhelp(plog([],[ht;t],0,'files','al=1'),1);

%% ==[get files]=============================================

ix1=find(strcmp(raw_meta(:,1),'ANIMAL/Dir'))+1;
ix2=find(strcmp(raw_meta(:,1),'ADDITIONAL INFO*** '))-2;
t2=raw_meta(ix1:ix2,:);


%% ===get thresholded nifti=====================================
f1=fullfile(pa,[name '.nii']);
[ha a mm]=rgetnii(f1);
mm2=mm';
[cl ncl]=bwlabeln(a>0);
%% =====obtain cluster-ID==========================================
c_xmm=find(strcmp(ht,'x_mm'));
co=cell2mat(t(:,[c_xmm:c_xmm+2]));
clustid=zeros(size(t,1),2);
% clustid=zeros(size(t,1),1);
for i=1:size(t,1)
    df=sum((mm2-repmat(co(i,:),[size(mm2,1)  1])).^2,2)  ;
    %     ix=min(find(df==min(df)));
    clustid(i,1) =cl(min(find(df==min(df))));
    clustid(i,2) =sum(cl(:)==clustid(i,1));
end

%% ====  extract data ... test..should correspond to excel-table T-values===========================================
if 0
    V = spm_vol(f1);
    xyz_mm =co(2,:)';% [ -2.9450   -0.5345   -4.5303]';
    vox = inv(V.mat) * [xyz_mm; 1];
    vox = round(vox(1:3));
    val = spm_sample_vol(V, vox(1), vox(2), vox(3), 0) % 0 = nearest
end

%% =====[extract peaks  ]==========================================
if strcmp(v.type,'peaks')
    dx=zeros(size(t2,1),size(co,1) );
    for i=1:size(t2,1)
        f2=t2{i,2};
        V = spm_vol(f2);
        for j=1:size(co,1)
            xyz_mm =co(j,:)';% [ -2.9450   -0.5345   -4.5303]';
            vox = inv(V.mat) * [xyz_mm; 1];
            vox = round(vox(1:3));
            val = spm_sample_vol(V, vox(1), vox(2), vox(3), 0) ;% 0 = nearest
            dx(i,j)=val;
        end
    end
else
    % =====[extract clusters  ]==========================================
    dx=zeros(size(t2,1),size(co,1) );
    for i=1:size(t2,1)
        f2=t2{i,2};
        V = spm_vol(f2);
        for j=1:size(co,1)
            iv=find( cl==clustid(j,1) );
            xyz_mm=mm(:,iv);
            vox = inv(V.mat) * [xyz_mm; ones(1, size(xyz_mm,2))];
            vox = round(vox(1:3,:));
            val = spm_sample_vol(V, vox(1,:), vox(2,:), vox(3,:), 0) ;% 0 = nearest
            dx(i,j)=mean(val(:));
        end
    end
end

%% ======[assign data ]=========================================
s=struct;
s.contrastname=col2{min(regexpi2(col1,'contrastName'))};
irel=regexp(s.contrastname,'>|<');
[~,s.image]=fileparts(col2{min(regexpi2(col1,'Image'))});

s.groups={regexprep(s.contrastname(1:irel-1),'\s+','') ...
    regexprep(s.contrastname(irel+1:end),'\s+','')};

if size(t2,2)~=4
    keyboard
end
s.ig1=find(cell2mat(t2(:,3)));
s.ig2=find(cell2mat(t2(:,4)));
s.animal1=t2(s.ig1,1);
s.animal2=t2(s.ig2,1);


s.type=v.type;
c_cluster =find(strcmp(ht,'cluster'));
c_peak    =find(strcmp(ht,'peak'));
c_clsize  =find(strcmp(ht,'cluster_equivk'));
c_labels  =regexpi2(ht,'Labels');

t3={};
for i=1:size(dx,2)
    v1=dx(s.ig1,i);
    v2=dx(s.ig2,i);
    dl1=strjoin(cellstr(num2str( v1  )),';');
    dl2=strjoin(cellstr(num2str( v2  )),';');
    an1=strjoin(s.animal1,';');
    an2=strjoin(s.animal2,';');
    
    me1=mean(v1);
    me2=mean(v2);
    sd1=std(v1);
    sd2=std(v2);
    n1=length(v1);
    n2=length(v2);
    
    dz={s.contrastname s.image  s.groups{1} s.groups{2}  s.type ...
        t{i,c_cluster}  t{i,c_peak}  t{i,c_clsize}  t{i,c_labels}  ...
        me1 me2 sd1 sd2 n1 n2 ...
        dl1 dl2  an1 an2 ...
        };
    
    t3=[t3; dz];
end


ht3={'contrastname' 'image'  'group1' 'group2'  'datatype' ...
    'cluster'  'peak'  'k'  'region' ...
    'ME1' 'ME2' 'SD1' 'SD2' 'n1' 'n2'...
    'values1' 'values2'  'animals1' 'animals2' ...
    };
if strcmp(v.type,'cluster') %set peaknumber-in table to '0'
    t3(:,find(strcmp(ht3,'peak')))={0};
end
% uhelp(plog([],[ht3;t3],0,'files','al=1'),1);

%% add table-number ,add iter
iter=iter+1;
if v.additer==1
    ht3=[ [v.iterprefix ]  ht3 ];
    t3= [ repmat( {[ [v.iterprefix pnum(iter,3)] ]}, [ size(t3,1) 1] )   t3  ] ;
end


% uhelp(plog([],[ht3;t3],0,'files','al=1'),1);






























