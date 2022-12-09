
%%  voxstat: voxstat_pairedsampleTest

function voxstat_pairedsampleTest()
global xvv
xvv.xtype='pairedttest';
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
%% ===========[froup-definitions]====================================
M=s.m;
M.grpNames=unique(M.d(:,2),'stable');
g1=M.files(find(strcmp(  M.d(:,2), M.grpNames{1})));
g2=M.files(find(strcmp(  M.d(:,2), M.grpNames{2})));
%remove xls-indicated subjects that have no data (path or volume)
g1=g1(~cellfun('isempty',g1));
g2=g2(~cellfun('isempty',g2));
groupLabels= M.grpNames(1:2);
%% ===============================================
outdir   =  s.output_dir   ;
mkdir(outdir);
mask     =  s.mask         ;
%% ===============================================
% g1       =  s.grp_1        ;
% g2       =  s.grp_2        ;
% groupLabels=s.classes      ;%group-names

mb={};
for i=1:size(g1,1)
    dv={[g1{i} ,',1']; [g2{i} ,',1'] };
    %disp([i]);     disp(char(dv));
    mb{1}.spm.stats.factorial_design.des.pt.pair(i).scans =dv;  
end
mb{1}.spm.stats.factorial_design.dir ={outdir}  ;% {'O:\data\voxelwise_Maritzen4tool\test_1'};


% mb{1}.spm.stats.factorial_design.des.pt.pair(1).scans = {
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla.nii,1'
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla2.nii,1'
%                                                                   };
% mb{1}.spm.stats.factorial_design.des.pt.pair(2).scans = {
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla.nii,1'
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla2.nii,1'
%                                                                   };
% mb{1}.spm.stats.factorial_design.des.pt.pair(3).scans = {
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla.nii,1'
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla2.nii,1'
%                                                                   };
% mb{1}.spm.stats.factorial_design.des.pt.pair(4).scans = {
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla.nii,1'
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla2.nii,1'
%                                                                   };
% mb{1}.spm.stats.factorial_design.des.pt.pair(5).scans = {
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla.nii,1'
%                                                                   'O:\data\voxelwise_Maritzen4tool\bla2.nii,1'
%                                                                   };
mb{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
mb{1}.spm.stats.factorial_design.des.pt.ancova = 0;



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
mb{1}.spm.stats.factorial_design.masking.em =  {mask};  % {'O:\data\voxelwise_Maritzen4tool\templates\AVGTmask.nii'};
mb{1}.spm.stats.factorial_design.globalc.g_omit = 1;
mb{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
mb{1}.spm.stats.factorial_design.globalm.glonorm = 1;
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
% ===============================================
mb{3}.spm.stats.con.spmmat(1) = cfg_dep;
mb{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
mb{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');

mb{3}.spm.stats.con.consess{1}.tcon.name    = [ groupLabels{1} '>'  groupLabels{2}]  ;%'1>2';
mb{3}.spm.stats.con.consess{1}.tcon.convec  = [1 -1];
mb{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

mb{3}.spm.stats.con.consess{2}.tcon.name    = [ groupLabels{1} '<'  groupLabels{2}] ;%'1<2';
mb{3}.spm.stats.con.consess{2}.tcon.convec  = [-1 1];
mb{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
mb{3}.spm.stats.con.delete = 0;
% ===============================================
mb{4}.spm.stats.results.spmmat(1) = cfg_dep;
mb{4}.spm.stats.results.spmmat(1).tname = 'Select SPM.mat';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).name = 'filter';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).value = 'mat';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).name = 'strtype';
mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).value = 'e';
mb{4}.spm.stats.results.spmmat(1).sname = 'Contrast Manager: SPM.mat File';
mb{4}.spm.stats.results.spmmat(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
mb{4}.spm.stats.results.spmmat(1).src_output = substruct('.','spmmat');

mb{4}.spm.stats.results.conspec(1).titlestr    = [ groupLabels{1} '>'  groupLabels{2}] ;%'1>2';
mb{4}.spm.stats.results.conspec(1).contrasts   = 1;
mb{4}.spm.stats.results.conspec(1).threshdesc  = 'FWE';
mb{4}.spm.stats.results.conspec(1).thresh      = 0.05;
mb{4}.spm.stats.results.conspec(1).extent      = 0;
mb{4}.spm.stats.results.conspec(1).mask        = struct('contrasts', {}, 'thresh', {}, 'mtype', {});

mb{4}.spm.stats.results.conspec(2).titlestr    = [ groupLabels{1} '<'  groupLabels{2}];% '1<2';
mb{4}.spm.stats.results.conspec(2).contrasts   = 2;
mb{4}.spm.stats.results.conspec(2).threshdesc  = 'FWE';
mb{4}.spm.stats.results.conspec(2).thresh      = 0.05;
mb{4}.spm.stats.results.conspec(2).extent      = 0;
mb{4}.spm.stats.results.conspec(2).mask        = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
mb{4}.spm.stats.results.units = 1;
mb{4}.spm.stats.results.print = false;



%% smoothing
% change [1] Data Smoothing [2]data for factDesignSpecif. [3] dependency-order
if s.smoothing==1
    try
        smoothfwhm=str2num(s.smoothing_fwhm);
    catch
        smoothfwhm=        (s.smoothing_fwhm);
    end
    ms={};
    ms{1}.spm.spatial.smooth.data = [g1;g2];
    ms{1}.spm.spatial.smooth.fwhm = smoothfwhm ;% [0.28 0.28 0.28];
    ms{1}.spm.spatial.smooth.dtype = 0;
    ms{1}.spm.spatial.smooth.im = 0;
    ms{1}.spm.spatial.smooth.prefix = 's';
    
    
    %change inputfiles to smoothed images
    mb{1}.spm.stats.factorial_design.des.t2.scans1 = stradd(g1,'s',1);
    mb{1}.spm.stats.factorial_design.des.t2.scans2 = stradd(g2,'s',1);
    
    for i=1:size(g1,1)
        %dv={[g1{i} ,',1']; [g2{i} ,',1'] };
        dv={[stradd(g1{i},'s',1) ,',1']; [stradd(g2{i},'s',1) ,',1'] };
        %disp([i]);     disp(char(dv));
        mb{1}.spm.stats.factorial_design.des.pt.pair(i).scans =dv;
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

