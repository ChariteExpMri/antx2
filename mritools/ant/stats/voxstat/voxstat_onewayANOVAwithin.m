
%%  voxstat: voxstat_onewayANOVAwithin

function voxstat_onewayANOVAwithin()
global xvv
xvv.xtype='onewayanova_within';
% --------------
warning off;
isOK=xstat('obtainGroupfile',xvv.xtype); %older: isOK=readexcel(xvv.xtype);
if isOK==0; return; end
xstat('makeBatch');  %older: fmakebatch(mfilename );

%%  ==============[ initialize]=================================
cprintf('*[0 0 1]',['[METHOD: "' xvv.xtype '"] ..please wait....' '\n']);
x=xvv.x;
if x.showSPMwindows==1
    xstat('spmsetup');
    %spmsetup;
elseif x.showSPMwindows==0
    xstat('spmsetup',[],0);
    %spmsetup([],0);
%     spm('defaults', 'fmri')
%     spm_jobman('initcfg')
%     spm_get_defaults('cmdline',true)
end
hfig=findobj(0,'tag','vvstat');
s=get(hfig,'userdata');
try ;     cd(s.workpath); end

%% ===========[group-definitions]====================================
M=s.m;

grps=unique(M.d(:,2),'stable');
niftis    ={};
regresvals=[];
condvec=zeros(length(M.files),1);
for i=1:length(grps)
    ix=find(strcmp(M.d(:,2),grps{i}));
    %niftis{i,1}=s.d(ix,4)
    %niftis{i,1}=cellfun(@(a){[ a ',1']},s.d(ix,4));
    condvec(ix,1)=i;
   % niftis{i,1}=cellfun(@(a){[ a ',1']},M.files(ix));
    niftis{i,1}=M.files(ix);
end

%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧・
%   get other parans
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧・
outdir    = s.output_dir;
mask      = s.mask;
mkdir(outdir);
%% ===============================================
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧・
%  batch
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧・
mb={};
mb{1}.spm.stats.factorial_design.dir = {outdir}; %'<UNDEFINED>';
mb{1}.spm.stats.factorial_design.des.anovaw.fsubject.scans = M.files;% '<UNDEFINED>';
mb{1}.spm.stats.factorial_design.des.anovaw.fsubject.conds = condvec;% '<UNDEFINED>';
mb{1}.spm.stats.factorial_design.des.anovaw.dept = 1;
mb{1}.spm.stats.factorial_design.des.anovaw.variance = 1;
mb{1}.spm.stats.factorial_design.des.anovaw.gmsca = 0;
mb{1}.spm.stats.factorial_design.des.anovaw.ancova = 0;

% mb{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});

%% without covariates
if M.isCovar==0;     
    mb{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
else
    %% WITH covariates
    for i=1:size(M.covar,2)
        mb{1}.spm.stats.factorial_design.cov(i).c       = cell2mat(M.covar(:,i));
        mb{1}.spm.stats.factorial_design.cov(i).cname   = M.covarName{i};
        mb{1}.spm.stats.factorial_design.cov(i).iCFI    = 1;
        mb{1}.spm.stats.factorial_design.cov(i).iCC     = 1;
    end
end

mb{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
mb{1}.spm.stats.factorial_design.masking.im = 1;
mb{1}.spm.stats.factorial_design.masking.em = {mask};
mb{1}.spm.stats.factorial_design.globalc.g_omit = 1;
mb{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
mb{1}.spm.stats.factorial_design.globalm.glonorm = 1;


% if 0
%     mb{1}.spm.stats.factorial_design.cov.c = '<UNDEFINED>';
%     mb{1}.spm.stats.factorial_design.cov.cname = '<UNDEFINED>';
%     mb{1}.spm.stats.factorial_design.cov.iCFI = 1;
%     mb{1}.spm.stats.factorial_design.cov.iCC = 1;
% end
% mb{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
% mb{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
% mb{1}.spm.stats.factorial_design.masking.im = 1;
% mb{1}.spm.stats.factorial_design.masking.em = {''};
% mb{1}.spm.stats.factorial_design.globalc.g_omit = 1;
% mb{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
% mb{1}.spm.stats.factorial_design.globalm.glonorm = 1;

%% ===============================================
if 0
mb{1}.spm.stats.factorial_design.dir = {outdir};

for i=1:length(grps)
    mb{1}.spm.stats.factorial_design.des.anova.icell(i,1).scans =   niftis{i};
end
mb{1}.spm.stats.factorial_design.des.anova.dept      = 0;
mb{1}.spm.stats.factorial_design.des.anova.variance  = 1;
mb{1}.spm.stats.factorial_design.des.anova.gmsca     = 0;
mb{1}.spm.stats.factorial_design.des.anova.ancova    = 0;

%% without covariates
if M.isCovar==0;
    mb{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
else
    %% WITH covariates
    for i=1:size(M.covar,2)
        mb{1}.spm.stats.factorial_design.cov(i).c       = cell2mat(M.covar(:,i));
        mb{1}.spm.stats.factorial_design.cov(i).cname   = M.covarName{i};
        mb{1}.spm.stats.factorial_design.cov(i).iCFI    = 1;
        mb{1}.spm.stats.factorial_design.cov(i).iCC     = 1;
    end
end

mb{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
mb{1}.spm.stats.factorial_design.masking.im = 1;
mb{1}.spm.stats.factorial_design.masking.em = {mask};
mb{1}.spm.stats.factorial_design.globalc.g_omit = 1;
mb{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
mb{1}.spm.stats.factorial_design.globalm.glonorm = 1;
end

mb{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
mb{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{2}.spm.stats.fmri_est.spmmat(1).sname = 'Factorial design specification: SPM.mat File';
mb{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
mb{2}.spm.stats.fmri_est.method.Classical = 1;

mb{3}.spm.stats.con.spmmat(1) = cfg_dep;
mb{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
mb{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');



% v=allcomb(grps,grps);
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧・
%  contrasts
%覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧覧・
v=nchoosek([1:length(grps)],2);
pat={'>'   1 -1
    '<'   -1  1 };
cons={};
%_________________[T-contrast]_________________
for i=1:size(v,1)
    n=1;
    dzero=zeros(1,10);
    dzero([v(i,1)  v(i,2)] ) =  [pat{n,2}  pat{n,3}];
    cons(end+1,:)=  {[grps{v(i,1)} pat{n,1}  grps{v(i,2)}  ]   dzero(1:v(i,2))   };
    n=2;
    dzero=zeros(1,10);
    dzero([v(i,1)  v(i,2)] ) =  [pat{n,2}  pat{n,3}];
    cons(end+1,:)=  {[grps{v(i,1)} pat{n,1}  grps{v(i,2)}  ]   dzero(1:v(i,2))   };
%     disp(cons{i,1});
%     disp(cons{i,2});
end

for i=1:size(cons,1)
    mb{3}.spm.stats.con.consess{i}.tcon.name    = cons{i,1}   ;%'a1>a2';
    mb{3}.spm.stats.con.consess{i}.tcon.convec  = cons{i,2}   ;%[1 -1];
    mb{3}.spm.stats.con.consess{i}.tcon.sessrep = 'none';
end
%_________________[F-contrast]_________________
fcon=zeros(size(v,1), length(grps));
for i=1:size(fcon,1)
    fcon(i, v(i,1) )  = 1;
    fcon(i, v(i,2) )  =-1;
end
mb{3}.spm.stats.con.consess{size(cons,1)+1}.fcon.name    = 'f-contrast'   ;
mb{3}.spm.stats.con.consess{size(cons,1)+1}.fcon.convec  = fcon          ;
mb{3}.spm.stats.con.consess{size(cons,1)+1}.fcon.sessrep = 'none'        ;

mb{3}.spm.stats.con.delete = 0;

mb{4}.spm.stats.results.spmmat(1) = cfg_dep;
mb{4}.spm.stats.results.spmmat(1).tname = 'Select SPM.mat';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{4}.spm.stats.results.spmmat(1).sname = 'Contrast Manager: SPM.mat File';
mb{4}.spm.stats.results.spmmat(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{4}.spm.stats.results.spmmat(1).src_output = substruct('.','spmmat');
mb{4}.spm.stats.results.conspec(1).titlestr = '';
mb{4}.spm.stats.results.conspec(1).contrasts = 1;
mb{4}.spm.stats.results.conspec(1).threshdesc = 'FWE';
mb{4}.spm.stats.results.conspec(1).thresh = 0.05;
mb{4}.spm.stats.results.conspec(1).extent = 0;
mb{4}.spm.stats.results.conspec(1).mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
mb{4}.spm.stats.results.units = 1;
mb{4}.spm.stats.results.print = false;


%%  smoothing
if s.smoothing==1
    % change [1] Data Smoothing [2]data for factDesignSpecif. [3] dependency-order
    try
        smoothfwhm=str2num(s.smoothing_fwhm);
    catch
        smoothfwhm=        (s.smoothing_fwhm);
    end
    
    nifti_all={};
    for i=1:length(grps)
        nifti_all=[nifti_all;  niftis{i} ] ;
    end
    
    ms={};
    ms{1}.spm.spatial.smooth.data = [nifti_all];
    ms{1}.spm.spatial.smooth.fwhm = smoothfwhm ;% [0.28 0.28 0.28];
    ms{1}.spm.spatial.smooth.dtype = 0;
    ms{1}.spm.spatial.smooth.im = 0;
    ms{1}.spm.spatial.smooth.prefix = 's';
    
    %change inputfiles to smoothed images
    for i=1:length(grps)
        mb{1}.spm.stats.factorial_design.des.anova.icell(i,1).scans = stradd( niftis{i},'s',1);
    end
    
    mb=  [ms mb ]  ;% add smoothing job
    %% UPDATE dependency-order
    mb{3}.spm.stats.fmri_est.spmmat(1).src_exbranch   = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
    mb{4}.spm.stats.con.spmmat(1).src_exbranch        = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
    mb{5}.spm.stats.results.spmmat(1).src_exbranch    = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
end


% ==============================================
%%   RUN-JOB
% ===============================================
if x.showSPMbatch==1 && x.runSPMbatch==1
    idmb=spm_jobman('interactive',mb);
    drawnow;
end
matlabbatch=mb;
fjob=fullfile(outdir,'job.mat');
showinfo2('batch saved as',fjob,[],1,[' -->[' fjob ']']);
save(fjob,'matlabbatch'); %SAVE BATCH

if x.runSPMbatch==1
    spm_jobman('run',mb);
else
    cprintf('*[0.9294    0.6941    0.1255]',['.. batch is shown in SPM BATCH-EDITOR....' '\n']);
    cprintf('*[0 .5 0]',['.. hit "RUN BATCH"-ICON of APM BATCH-EDITOR to start the batch!' '\n']);
    if x.showResults==1
        mres=[];
        mres{1}.cfg_basicio.run_ops.call_matlab.fun = 'xstat';
        mres{1}.cfg_basicio.run_ops.call_matlab.inputs{1}.evaluated = 'loadspm';
        mres{1}.cfg_basicio.run_ops.call_matlab.inputs{2}.evaluated = fullfile(outdir,'SPM.mat');
        mb2=[mb mres];
        spm_jobman('interactive',mb2);
    end
end

try ;    cd(s.workpath); end
if x.runSPMbatch==1 && x.showResults==1
    xstat('loadspm',fullfile(outdir,'SPM.mat'));
end

