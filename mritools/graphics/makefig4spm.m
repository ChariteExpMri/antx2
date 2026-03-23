






%% make orthoplots from SPM-voxelwise results & create PPT
% USAGE:
% hs hp]=makefig4spm(v)
% hs hp]=makefig4spm(v,r)
%%________________________________________
% INPUT:
% 
% v-struct:
% v.outdir     =fullfile(pwd,'test_spmImages');  %OUTPUT-FOLDER
% v.meth       ='clust';  % used method: %'clust', 'FWE' ,'none' , default, 'clust'
% <OPTIONAL>
% v.study      =antcb('getstudypath');           %STUDYFOLDER
% v.template   =fullfile(v.study,'templates','AVGT.nii');%BACKGROUND-IMAGE
% v.peak       ='all';   %plot peaks in cluster, either 'all' or 'first' ; default 'all', i.e. plot all peaks
% v.cluster    ='all';   %plot cluster, either 'all' or 'first' ; default 'all', i.e. plot all clusters
% v.prefix     ='p';     %output png-prefix
% v.addnumber =1;  %add number to putput PNG-file ; [0,1]; default:[1]
% v.addlabel  =1;  %add anat.label to putput PNG-file ; [0,1]; default:[1]
% v.makePPT   =1;  %make powerpointFile; [0,1]; default:[1]
% v.outdir    =fullfile(v.study ,'voxstatPlots',['method_' v.meth]); %target-Folder
% v.copyexcel =0;  %copy also used (existing) excelfile(s) to target-Folder,[0,1], default [0]
% v.copyppt   =0;  %copy summary-PPT-files (existing)  to target-Folder,[0,1], default [0]
% 
% r-struct <OPTIONAL>:
% r0: plot-parameter ..see orthoslice
%  ...some defaults here...
% r.alpha       =  [1  1];    %transparency of BG &FG-image
% r.cbarvisible =  [0  1];   %cbar of BG-image is invisibl,e FG-image is visible
% r.ce          =  [0.11828  1.3336  0.50203]; %peak cordinate ..will be overwritten by peak-coordinate
% r.clim        =  [nan nan;       3  5  ];  % colorlmits of BG-image &FG-image
% r.cmap        =  { 'gray' 	'SPMhot' }; %colormaps of  BG-image &FG-image
% r.mbarlabel   =  { '' 	'tvalue' };     %colormap labels of BG-image &FG-image
% r.mcbarpos    =  [-160  20  10  100];   %relative position of 1st colorbar (indep. of visibility)
% r.mcbarticks  =  [2];          %number of colorbar ticks
% r.thresh      =  [  NaN        NaN;    NaN        NaN  ];  %threhold/cutout limits of BG-image &FG-image
% r.visible     =  [1  1];   % show BG-image &FG-image
% r.hide        =1;  %hide image (image is not shown, [0,1])
% 
% 
%%________________________________________
% 
% EXAMPLES: 
%% make plots and PPT of all cluster-baseed results 
% v.indir= 'H:\Daten-2\Imaging\AG_Boehm_Sturm\Ratbrains_Iowa_2025_ana2\voxstat\voxstat_smooth 0';
% v.meth= 'clust'
% [hs hp]=makefig4spm(v);
% 
%% as above but show plot 
% [hs hp]=makefig4spm(v,struct('hide',0));
% 
%% as above , but copy excelfile and PPT --> results in one main folder
% v=[];
% v.meth      ='clust'
% v.copyexcel =1;
% v.copyppt   =1;
% v.indir     ='H:\Daten-2\Imaging\AG_Boehm_Sturm\Ratbrains_Iowa_2025_ana2\voxstat\voxstat_smooth 0';
% makefig4spm(v);

function [hs hp]=makefig4spm(v0,r0)




if 0
    %% ====[test]===========================================
    v=[];
    v.meth      ='clust';
    v.copyexcel =1;
    v.copyppt   =1;
    v.indir     ='H:\Daten-2\Imaging\AG_Boehm_Sturm\Ratbrains_Iowa_2025_ana2\voxstat\voxstat_smooth 0';
    makefig4spm(v);
    
       %as file
    %     v0.indir='H:\Daten-2\Imaging\AG_Boehm_Sturm\Ratbrains_Iowa_2025_ana2\voxstat\voxstat_smooth 0\res_vx_groups__x_fa\data';
  
    %% ====[test:FWE]===========================================
    v=[];
    v.meth='FWE';
    v.peak='first';
    v.indir='H:\Daten-2\Imaging\AG_Boehm_Sturm\Ratbrains_Iowa_2025_ana2\voxstat\voxstat_smooth 0'
    v.hide=0;
    v.outdir='H:\Daten-2\Imaging\AG_Boehm_Sturm\Ratbrains_Iowa_2025_ana2\voxstatPlots\meth_FWE'
    r=[];
    r.clim =  [nan nan;       2  5  ];
    r.cmap        =  { 'gray' 	'NIH_fire.lut' };
    [hs hp]=makefig4spm(v,r);
    
    %% ====[test:NONE]===========================================
    v=[];
    v.meth='none';
    v.peak='first';
    v.cluster='first';
    v.indir='H:\Daten-2\Imaging\AG_Boehm_Sturm\Ratbrains_Iowa_2025_ana2\voxstat\voxstat_smooth 0';
    v.hide=0;
    v.outdir=fullfile(antcb('getstudypath'),'voxstatPlots', ['meth_' v.meth] );
    r=[];
    r.clim =  [nan nan;    2  5  ];
    r.cmap        =  { 'gray' 	'NIH_fire.lut' };
    [hs hp]=makefig4spm(v,r);
    
    %% ===============================================
    
end

% ==============================================
%%   defaults
% ===============================================
v.outdir     =fullfile(pwd,'test_spmImages');  %OUTPUT-FOLDER
v.study      =antcb('getstudypath');           %STUDYFOLDER
v.template   =fullfile(v.study,'templates','AVGT.nii');%BACKGROUND-IMAGE
v.meth       ='clust';  % used method: %'clust', 'FWE' ,'none' , default, 'clust'
v.peak       ='all';   %plot peaks in cluster, either 'all' or 'first' ; default 'all', i.e. plot all peaks
v.cluster    ='all';   %plot cluster, either 'all' or 'first' ; default 'all', i.e. plot all clusters
v.prefix     ='p';     %output png-prefix
v.addnumber =1;  %add number to putput PNG-file ; [0,1]; default:[1]
v.addlabel  =1;  %add anat.label to putput PNG-file ; [0,1]; default:[1]
v.makePPT   =1;  %make powerpointFile; [0,1]; default:[1]
v.outdir    =fullfile(v.study ,'voxstatPlots',['method_' v.meth]); %target-Folder
v.copyexcel =0;  %copy also used (existing) excelfile(s) to target-Folder,[0,1], default [0]
v.copyppt   =0;  %copy summary-PPT-files (existing)  to target-Folder,[0,1], default [0]
% ==============================================
%%  v0-inputparams
% ===============================================
if exist('r0')==0; r0.dummy=1; end
v=catstruct(v,v0);

% ==============================================
%%   get xlsfiles
% ===============================================
if isdir(v.indir)==1
    [files] = spm_select('FPListRec',v.indir,'.*.xlsx');
    if isempty(files);         disp(['no excel-files found in  path..abort..']) ;
        return;
    end
    files=cellstr(files);
    files=files(regexpi2(files,v.meth));
else
    files=cellstr(v.indir);
    files=find(cell2mat(cellfun(@(a) {[ exist(a)]} ,files ))==7) ;% only existing excelfiles
end

if isempty(char(files));
    disp(['no excel-files with method "' v.meth '"found in path..abort..']) ; return ;
end
%% ======[r-parameter]=========================================
r=[];
r.alpha       =  [1  1];    %transparency of BG &FG-image
r.cbarvisible =  [0  1];   %cbar of BG-image is invisibl,e FG-image is visible
r.cblabel     =  '';
r.ce          =  [0.11828  1.3336  0.50203]; %peak cordinate ..will be overwritten
r.clim        =  [nan nan;       3  5  ];  % colorlmits of BG-image &FG-image
r.cmap        =  { 'gray' 	'SPMhot' }; %colormaps of  BG-image &FG-image
r.mbarlabel   =  { '' 	'tvalue' };     %colormap labels of BG-image &FG-image
r.mcbarpos    =  [-160  20  10  100];   %relative position of 1st colorbar (indep. of visibility)
r.mcbarticks  =  [2];          %number of colorbar ticks
r.mroco       =  [NaN  NaN];
r.mslicemm    =  [];
r.saveas      =  '';
r.thresh      =  [  NaN        NaN;    NaN        NaN  ];  %threhold/cutout limits of BG-image &FG-image
r.visible     =  [1  1];   % show BG-image &FG-image
r.hide        =1;  %hide image (image is not shown, [0,1])
r=catstruct(r,r0);


%% ===[outdir]============================================
if exist(v.outdir)~=7; mkdir(v.outdir); end

%% ====[run over excelfiles]==========================
hs2={};
hx2={};
nplots=0;
for i=1:length(files)
    [hs hx nplots]=plotthis(files{i},v,r,nplots);
    hs2=[hs2; hs];
    hx2=[hx2; hx];
end


if isempty(hs2)
   disp([' meth: [' v.meth '] no significances found']); 
end

% ==============================================
%%   makeppt
% ===============================================
hp=[];
if ~isempty(char(hs2))  && v.makePPT==1
    paout   =v.outdir;
    % paimg   =fullfile(pwd,'barplot_img');
    pptfile =fullfile(paout,['resSig_' v.meth '.pptx']);
    
    %[fis]   = spm_select('FPList',paimg,'^bar.*.png');    fis=cellstr(fis);
    png=hs2;
    [figpath,fisShort, ext]=fileparts2(png);
    %     fisShort=cellfun(@(a,b){ [a b]} ,fisShort, ext)
    %     tx      ={['path: '  figpath{1} ]};
    %% ===============================================
    
    % extract group names
    groupNames = cellfun(@(x) regexp(x, [v.meth '(.*?)_' v.meth], 'tokens', 'once','ignorecase'), ...
        fisShort, 'UniformOutput', false);
    % groupNames = cellfun(@(x) regexp(x, 'clust_(.*?)_C1__', 'tokens', 'once'), ...
    %                      fisShort, 'UniformOutput', false);
    groupNames = cellfun(@(x) x{1}, groupNames, 'UniformOutput', false);
    % convert to numeric group IDs
    [groupname, ~, groupID] = unique(groupNames);
    %disp(groupID)
    
    
    %% ===============================================
    nimg_per_page = 4;
    groups = unique(groupID);
    firstSlide = true;
    for g = 1:length(groups)
        idx = find(groupID == groups(g));   % indices of this group
        png_group = png(idx);
        % pagination within group
        imgIDXpage = unique([1:nimg_per_page:length(png_group), length(png_group)+1]);
        
        
        
        for i = 1:length(imgIDXpage)-1
            if i==1
                titlem  =['voxstat: method "'  v.meth '" [' groupname{g} ']'    ];
            else
                titlem  =['voxstat: method "'  v.meth '" [' groupname{g} ']  ..continued'    ];
            end
            
            if firstSlide
                doc = 'new';
                firstSlide = false;
            else
                doc = 'add';
            end
            img_perslice = png_group(imgIDXpage(i):imgIDXpage(i+1)-1);
            [~, pngname, pngext] = fileparts2(img_perslice);
            pnglist = ['Files:'; cellfun(@(a,b){[a b]}, pngname, pngext)];
            img2ppt(v.outdir, img_perslice, pptfile, 'doc', doc, ...
                'crop',0,'gap',[1 0],'columns',1,'xy',[1 1],'wh',[nan 3.6], ...
                'title', titlem, ...
                'text', pnglist,'txy',[1 15.5],'tcol',[0 0 1],'tfs',10,'disp',0);
        end
    end
    
    showinfo2(['PPTfile'], pptfile);
    hp=pptfile;
    
end


% ==============================================
%%   copy excelfiles 
% ===============================================
if v.copyexcel==1 && ~isempty(char(hx2))
    disp(' ..copy excelFiles');
   out_excel=fullfile(v.outdir,'xls');
   if exist(out_excel)~=7; mkdir(out_excel); end 
    for i=1:length(hx2)
       copyfile(hx2{i},out_excel,'f' ) ;
    end
end
% ==============================================
%%   copy orig ppt-file
% ===============================================
if v.copyppt==1 && ~isempty(char(hx2))
    outsummary=fullfile(v.outdir,'summary');
    if exist(outsummary)~=7; mkdir(outsummary); end
    ppt2copy={};  
    for i=1:length(hx2)
        [pa_xls] = fileparts(fileparts(hx2{i}));
        [fip] = spm_select('List',pa_xls,'.*.pptx'); 
        fip=cellstr(fip);
        is=regexpi2(fip,v.meth);
        if ~isempty(is)
            fip=fip(is);
        end
        fipFP=stradd(fip,[ pa_xls filesep],1);
        ppt2copy=[ppt2copy; fipFP];
    end
    for i=1:length(ppt2copy)
       copyfile(ppt2copy{i},outsummary,'f' ) ;
    end
     disp(' ..copy PPTfiles');
    
end




%% ======old=========================================


%     nimg_per_page  =4;           %number of images per plot
%     imgIDXpage     =unique([1:nimg_per_page:length(png) length(png)+1 ]);
%     for i=1:length(imgIDXpage)-1
%         if i==1; doc='new'; else; doc='add'; end
%         img_perslice=png([imgIDXpage(i):imgIDXpage(i+1)-1]);
%         [~ ,pngname,pngext ]=fileparts2(img_perslice);
%         pnglist=['Files:'; cellfun(@(a,b){[ a b ]},pngname,pngext)];
%
%         img2ppt(v.outdir,img_perslice, pptfile,'doc',doc,...
%             'crop',0,'gap',[1 0],'columns',1,'xy',[1 1 ],'wh',[ nan 3.6],...
%             'title',titlem,...
%             'text',pnglist,'txy', [1 15.5 ], 'tcol', [0 0 1],'tfs',10)
%     end
%     showinfo2(['PPTfile'],pptfile);
%
%
%
%     nimg_per_page  =6;           %number of images per plot
%     imgIDXpage     =unique([1:nimg_per_page:length(fis) length(fis)+1 ]);
%     for i=1:length(imgIDXpage)-1
%         if i==1; doc='new'; else; doc='add'; end
%         img_perslice=fis([imgIDXpage(i):imgIDXpage(i+1)-1]);
%         img2ppt(paout,img_perslice, pptfile,'size','A4','doc',doc,...
%             'crop',0,'gap',[0 0 ],'columns',2,'xy',[0 1.5 ],'wh',[ 10.5 nan],...
%             'title',titlem,'Tha','center','Tfs',10,'Tcol',[1 1 1],'Tbgcol',[1 .8 0],...
%             'text',tx,'tfs',6,'txy',[0 28],'tbgcol',[1 1 1]);
%     end










%% ====[SUBS]===========================================


function [hs hx nplots ]=plotthis(file,v,r,nplots)
hs=[];
hx=[];
% ==============================================
%%   make plots for SPM-voxstat
% ===============================================
xfile=file;
[pax name ext ]=fileparts(xfile);
sfile=[name ext];

% pax='H:\Daten-2\Imaging\AG_Boehm_Sturm\Ratbrains_Iowa_2025_ana2\voxstat\voxstat_smooth 0\res_vx_groups__x_fa\data';
% sfile='x_fa_C1__NS_GT_SI__CLUST0.001k965.xlsx';
% xfile=fullfile(pax,sfile);
% [~,sheets]=xlsfinfo(xfile)
[~,~ ,a0]=xlsread(xfile,2); %excel

issig=1;
try
    if strcmp(a0{find(strcmp(a0(:,1),'Result')),2}, 'no suprathreshold clusters found')==1
        issig=0;
        return
    end
    % catch
    %     keyboard
end


outdir_png=fullfile(v.outdir,'png');
if exist(outdir_png)~=7; mkdir(outdir_png); end 
nfile=fullfile(pax,regexprep(sfile,'.xlsx','.nii'));% ===NIFTI=
hx   =xfile;
%% ===============================================
h1=a0(1,:);
h2=a0(2,:);
a =a0(3:end,:);
c_k=find(strcmp(h2,'equivk'));
c_x=find(strcmp(h1,'x'));
c_labels=find(strcmp(h1,'Labels'));
b=a;
if strcmp(v.peak,'first')
    b(isnan(cell2mat(b(:,c_k))),:)=[];
end

if strcmp(v.cluster,'first')
    b=b(1,:);
end


%% ===============================================
[~,filetag]=fileparts(sfile);
meth='clust';
if ~isempty(strfind(filetag,'none'))
    meth='none';
elseif ~isempty(strfind(filetag,'FWE'))
    meth='FWE';
end
cl_no=0; %clusterNUmber

hs={};
for i=1:size(b,1)
    cf;
    co=[cell2mat(b(i, c_x:c_x+2 ))];
    if ~isnan(b{i,c_k})
        cl_size=b{i,c_k};
        peakno=1;
        cl_no=cl_no+1;
    else
        peakno=peakno+1;
    end
    
    nplots=nplots+1;
    if v.addnumber~=1
        addnumber='';
    else
        addnumber=['_' pnum(nplots,3) '_'];
    end
    
    if v.addlabel==1
        label=b{i,c_labels};
        label=['_' regexprep(label, {'[\\/:*?"<>|]', ' '}, {''})];
    else
        label='';
    end
    
    ofile=[ v.prefix  addnumber  meth '_'  filetag '_CL' pnum(cl_no,3)  '_PEAK' pnum(peakno,3) ...
        '[' sprintf('%2.2f,%2.2f,%2.2f',co) ']' label '.png'];
    disp(ofile);
    if 1
        r.ce=co;
        orthoslice({v.template nfile},r);
        drawnow;
        fo4=fullfile(outdir_png,ofile);
        q=orthoslice('post','saveas',fo4,'dosave',1);
        hs{end+1,1}=fo4;
        
    end
    % ===============================================
end





