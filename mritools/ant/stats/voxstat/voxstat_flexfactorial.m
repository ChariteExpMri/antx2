
%%  voxstat: voxstat_flexfactorial

function voxstat_flexfactorial()
global xvv
xvv.xtype='flexfactorial';
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

M.Nfactors=(size(M.dh,2)-1);
M.idxfactor=[1:M.Nfactors]+1;
factors=M.dh(M.idxfactor);

if 0 %% test string for level-names as input
    for i=1:length(M.idxfactor)
        if i==1
            M.d(:,M.idxfactor(i))=regexprep(M.d(:,M.idxfactor(i)),{'1','2','3'},{'one' ,'two' 'three'});%test wether it works with strings
        elseif i==2
            M.d(:,M.idxfactor(i))=regexprep(M.d(:,M.idxfactor(i)),{'1','2','3'},{'eins' ,'zwei' 'drei'});%test wether it works with strings
        elseif i==3
            M.d(:,M.idxfactor(i))=regexprep(M.d(:,M.idxfactor(i)),{'1','2','3'},{'en' ,'tvo' 'tre'});%test wether it works with strings
        end
    end
end

levels    =M.d(:,M.idxfactor);%s.d(:,2:length(s.dfactornames)+1);
% ---convert to numeric
levelsnumeric=cell(size(levels,1),size(levels,2));
levelsoriginal=M.d(:,M.idxfactor);

levelsstring =levels;
levcode={};

for i=1:size(levels,2)
    [uniL IA IC ]=unique(levels(:,i),'stable');
    numL=cellfun(@(a){[num2str(a)]},num2cell([1:length(uniL)]'));
    uniLS=cellfun(@(a){['^' a '$']},uniL);
    levelsnumeric(:,i)=regexprep(levels(:,i),uniLS,numL);
    levcode{i}.hc={'Levelstring' 'LevelIndex'};
    levcode{i}.c=[uniL num2cell(IC(IA))];
end
% levels    =cell2mat(cellfun(@(a){[str2num(a)]},levels));
levels    =cell2mat(cellfun(@(a){[str2num(a)]},levelsnumeric));
if 0
    %%  ==============[ get files + covars]=================================
    comb=unique(levels,'rows');
    % char(x.inputimage)
    
    
    scans  ={};
    lev    ={};
    nlev   =max(comb);
    covars =[];
    
    for i=1:size(comb,1)
        ix=find(sum(abs(levels-repmat(comb(i,:),[size(levels,1) 1])),2)==0);
        tempfiles=M.files(ix);
        %isexist  =M.filesExist(ix);
        %tempfiles=tempfiles(isexist==1);
        
        scans{i,1}  =tempfiles;         % # NIFTIS
        lev{i,1}    =comb(i,:)  ;       % # LEVEL
        if M.isCovar~=0
            %covars=[covars; cell2mat(M.covar(ix(isexist==1),:)) ]; %  # RGRESSORS
            covars=[covars; cell2mat(M.covar(ix,:)) ]; %  # RGRESSORS
            covarName=M.covarName;
        end
    end
    
end
%% ===============================================


%——————————————————————————————————————————————?E
%   get other params
%——————————————————————————————————————————————?E
outdir    = s.output_dir;
try;mkdir(outdir);end
mask      = s.mask;



% keyboard
%——————————————————————————————————————————————
%%  batch
%——————————————————————————————————————————————
padat=s.data_dir;
niftis=(stradd(stradd(M.d(:,1),[padat filesep],1), [filesep s.inputimage ],2));

subjectfactor=s.m.a(:,s.subjectFactor_col);
if length(niftis)<length(subjectfactor)
    if isstr(subjectfactor{1})
        subjectfactor=subjectfactor(2:end) ;
    end
end
subjectfactorNumeric=cell2mat(subjectfactor);
tb=[ subjectfactorNumeric levels ];
dummycol=ones(  [ size(tb,1) 4-size(tb,2)]);
tb=[tb dummycol];
%% ===============================================
bx=struct();
bx.factors              =factors;
bx.levels               =levels;
bx.levelsoriginal       =levelsoriginal;
bx.levelcombs           =unique(levels,'rows');
bx.nlevels              =max(bx.levelcombs);
bx.subjectfactorNumeric =subjectfactorNumeric;
bx.isWithin             =s.factorDependency;
save(fullfile(outdir, 'info_design.mat'),'bx');
%% ===============================================


mb={};
mb{1}.spm.stats.factorial_design.dir = {outdir} % {'F:\data6\voxwise_flexfactorial\vox1'};



mb{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'subject';
mb{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 0;
mb{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 0;
mb{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
mb{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;



for i=1:length(factors)
    is=i+1;
    dep   =s.factorDependency(i);
    varia =~s.factorVariance(i);
    mb{1}.spm.stats.factorial_design.des.fblock.fac(is).name       = factors{i};
    mb{1}.spm.stats.factorial_design.des.fblock.fac(is).dept       = dep
    mb{1}.spm.stats.factorial_design.des.fblock.fac(is).variance   = varia;
    mb{1}.spm.stats.factorial_design.des.fblock.fac(is).gmsca = 0;
    mb{1}.spm.stats.factorial_design.des.fblock.fac(is).ancova = 0;
end
% mb{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'group';
% mb{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 0;
% mb{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 0;
% mb{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
% mb{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
%
% mb{1}.spm.stats.factorial_design.des.fblock.fac(2).name = 'treatment';
% mb{1}.spm.stats.factorial_design.des.fblock.fac(2).dept = 1;
% mb{1}.spm.stats.factorial_design.des.fblock.fac(2).variance = 0;
% mb{1}.spm.stats.factorial_design.des.fblock.fac(2).gmsca = 0;
% mb{1}.spm.stats.factorial_design.des.fblock.fac(2).ancova = 0;

tb=tb(:,[ 4 1 2 3 ]);
% tb2=ones(size(tb));



mb{1}.spm.stats.factorial_design.des.fblock.fsuball.specall.scans         =niftis;
mb{1}.spm.stats.factorial_design.des.fblock.fsuball.specall.imatrix       = tb;



if 0
    for i=1:length(factors)
        dep   =s.factorDependency(i);
        varia =~s.factorVariance(i);
        mb{1}.spm.stats.factorial_design.des.fblock.fac(i).name       = factors{i};
        mb{1}.spm.stats.factorial_design.des.fblock.fac(i).dept       = dep
        mb{1}.spm.stats.factorial_design.des.fblock.fac(i).variance   = varia;
        mb{1}.spm.stats.factorial_design.des.fblock.fac(i).gmsca = 0;
        mb{1}.spm.stats.factorial_design.des.fblock.fac(i).ancova = 0;
    end
    % mb{1}.spm.stats.factorial_design.des.fblock.fac(1).name = 'group';
    % mb{1}.spm.stats.factorial_design.des.fblock.fac(1).dept = 0;
    % mb{1}.spm.stats.factorial_design.des.fblock.fac(1).variance = 0;
    % mb{1}.spm.stats.factorial_design.des.fblock.fac(1).gmsca = 0;
    % mb{1}.spm.stats.factorial_design.des.fblock.fac(1).ancova = 0;
    %
    % mb{1}.spm.stats.factorial_design.des.fblock.fac(2).name = 'treatment';
    % mb{1}.spm.stats.factorial_design.des.fblock.fac(2).dept = 1;
    % mb{1}.spm.stats.factorial_design.des.fblock.fac(2).variance = 0;
    % mb{1}.spm.stats.factorial_design.des.fblock.fac(2).gmsca = 0;
    % mb{1}.spm.stats.factorial_design.des.fblock.fac(2).ancova = 0;
    
    mb{1}.spm.stats.factorial_design.des.fblock.fac(i+1).name = 'subject';
    mb{1}.spm.stats.factorial_design.des.fblock.fac(i+1).dept = 0;
    mb{1}.spm.stats.factorial_design.des.fblock.fac(i+1).variance = 0;
    mb{1}.spm.stats.factorial_design.des.fblock.fac(i+1).gmsca = 0;
    mb{1}.spm.stats.factorial_design.des.fblock.fac(i+1).ancova = 0;
    mb{1}.spm.stats.factorial_design.des.fblock.fsuball.specall.scans         =niftis;
    mb{1}.spm.stats.factorial_design.des.fblock.fsuball.specall.imatrix       = tb;
end


% disp(tb)
%
% mb{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 1;
% mb{1}.spm.stats.factorial_design.des.fblock.maininters{2}.fmain.fnum = 2;
% % mb{1}.spm.stats.factorial_design.des.fblock.maininters{3}.fmain.fnum = 3;
% mb{1}.spm.stats.factorial_design.des.fblock.maininters{3}.inter.fnums = [1 2];

% mb{1}.spm.stats.factorial_design.des.fblock.maininters{1}.fmain.fnum = 1;
% mb{1}.spm.stats.factorial_design.des.fblock.maininters{2}.fmain.fnum = 2;
% mb{1}.spm.stats.factorial_design.des.fblock.maininters{3}.fmain.fnum = 3;

for i=1:length(factors)+1
    mb{1}.spm.stats.factorial_design.des.fblock.maininters{i}.fmain.fnum = i;
end
Nfactors=length(factors);
fac=([1:Nfactors]);
iac=allcomb([1:Nfactors],1:Nfactors);
iac(iac(:,1)>=iac(:,2),:)=[];
iac=iac+1;

nc=length(factors)+1
for i=1:size(iac,1)
    mb{1}.spm.stats.factorial_design.des.fblock.maininters{nc+i}.inter.fnums =iac(i,:);
end

if 0
    Nfactors=length(factors);
    fac=([1:Nfactors]);
    iac=allcomb([1:Nfactors],1:Nfactors);
    iac(iac(:,1)>=iac(:,2),:)=[];
    
    for i=1:length(fac)
        mb{1}.spm.stats.factorial_design.des.fblock.maininters{i}.fmain.fnum = fac(i);
    end
    
    % fac=[]
    for i=1:size(iac,1)
        mb{1}.spm.stats.factorial_design.des.fblock.maininters{length(fac)+i}.inter.fnums =iac(i,:);
    end
end

mb{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
mb{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
mb{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
mb{1}.spm.stats.factorial_design.masking.im = 1;
mb{1}.spm.stats.factorial_design.masking.em =              {mask};       %{'F:\data6\voxwise_flexfactorial\templates\AVGTmask.nii,1'};
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
if 0
    
    mb{3}.spm.stats.con.spmmat(1) = cfg_dep;
    mb{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
    mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
    mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
    mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
    mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
    mb{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
    mb{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
    mb{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
    mb{3}.spm.stats.con.delete = 0;
    
    % matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    
    mb{3}.spm.stats.con.consess{1}.tcon.name = 'g1>g2';
    mb{3}.spm.stats.con.consess{1}.tcon.weights = [1 1 1 -1 -1 -1];
    mb{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    mb{3}.spm.stats.con.consess{2}.tcon.name = 'treat1<treat2';
    mb{3}.spm.stats.con.consess{2}.tcon.weights = [-1 0 1 -1 0 1];
    mb{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    mb{3}.spm.stats.con.consess{3}.tcon.name = 'IA grp x treat';
    mb{3}.spm.stats.con.consess{3}.tcon.weights = [-1 0 1 1 0 -1];
    mb{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    mb{3}.spm.stats.con.consess{4}.fcon.name = 'Fcon1';
    mb{3}.spm.stats.con.consess{4}.fcon.weights = [1 1 1 -1 -1 -1
        -1 -1 -1 1 1 1];
    mb{3}.spm.stats.con.consess{4}.fcon.sessrep = 'none';
    % matlabbatch{3}.spm.stats.con.delete = 1;
    
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
    
end
spm_jobman('run',mb)
return

% ==============================================
%%   old mb
% ===============================================
if 0
    
    mb={};
    mb{1}.spm.stats.factorial_design.dir ={outdir}                ;% {'O:\data2\x03_yildirim\v00_fullfactorial_test\'};
    
    
    % code dependency of factors
    if isfield(s,'factorDependency')
        if length(s.factorDependency)==length(factors)
            dept=s.factorDependency;
        else
            dept=repmat(s.factorDependency, [1 length(factors)]);
            dept=dept(1:length(factors));
        end
    else
        s.factorDependency=zeros(1,length(factors)); % make all independent
        dept=s.factorDependency;
    end
    
    
    for i=1:length(factors) %FACTOR
        mb{1}.spm.stats.factorial_design.des.fd.fact(i).name =        factors{i} ;% 'desease';
        mb{1}.spm.stats.factorial_design.des.fd.fact(i).levels =      nlev(i);
        mb{1}.spm.stats.factorial_design.des.fd.fact(i).dept = dept(i);    % default: dept = 0; which is independent
        mb{1}.spm.stats.factorial_design.des.fd.fact(i).variance = 1;
        mb{1}.spm.stats.factorial_design.des.fd.fact(i).gmsca = 0;
        mb{1}.spm.stats.factorial_design.des.fd.fact(i).ancova = 0;
    end
    
    for i=1:size(lev,1)  % SCANS for each COMBI
        mb{1}.spm.stats.factorial_design.des.fd.icell(i).scans =       scans{i};      % # SCANS
        mb{1}.spm.stats.factorial_design.des.fd.icell(i).levels =      lev{i}  ; % # FACT-COMBI  ([2  1])
    end
    
    % mb{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    mb{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    mb{1}.spm.stats.factorial_design.masking.im         = 1;
    mb{1}.spm.stats.factorial_design.masking.em         = {mask};
    
    mb{1}.spm.stats.factorial_design.globalc.g_omit         = 1;
    mb{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    mb{1}.spm.stats.factorial_design.globalm.glonorm        = 1;
    
    % without covariates
    if M.isCovar==0;
        mb{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    else
        % WITH covariates
        for i=1:size(covars,2)
            mb{1}.spm.stats.factorial_design.cov(i).c       = covars(:,i);
            mb{1}.spm.stats.factorial_design.cov(i).cname   = covarName{i};
            mb{1}.spm.stats.factorial_design.cov(i).iCFI    = 1;
            mb{1}.spm.stats.factorial_design.cov(i).iCC     = 1;
        end
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
    
    % matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    % matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    % matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
    
    mb{3}.spm.stats.con.spmmat(1) = cfg_dep;
    mb{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
    mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
    mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
    mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
    mb{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
    mb{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
    mb{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
    mb{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
    mb{3}.spm.stats.con.delete = 0;
    
    %% ===============================================
    %% ===============================================
    
    % fcon={};
    % tcon={};
    % for j=1:length(nlev)
    %     nolev=nlev(j);
    %     iadd=sum(nlev(1:j-1));
    %
    %     al=allcomb(1:nolev,1:nolev);
    %     %b=allcomb(1:3,1:3)
    %     al(al(:,1)>=al(:,2),:)=[];
    %     b=al;
    %     b=b+iadd;
    %
    %     conx=zeros(size(b,1),[sum(nlev)]);
    %     for k=1:size(b,1)
    %         conx(k,b(k,1))= 1;
    %         conx(k,b(k,2))=-1;
    %     end
    %
    %    fcon(j,:)={  ['F_' factors{j} ] conx };
    %    %------------
    %    TP=fcon{j,2};
    %    TN=fcon{j,2}*-1;
    %     for i=1:size(TP,1)
    %       dum=  {  [factors{j} '_' num2str(al(i,1)) '>' num2str(al(i,2)) ] TP(i,:) };
    %       tcon=[tcon; dum];
    %       dum=  {  [factors{j} '_' num2str(al(i,1)) '<' num2str(al(i,2)) ] TN(i,:) };
    %       tcon=[tcon; dum];
    %     end
    % end
    % % ===============================================
    % % ===============================================
    % if 1
    %     for i=1:size(tcon,1)
    %         disp('-------------') ;
    %         disp(tcon{i,1});
    %         disp(tcon{i,2});
    %     end
    %
    % end
    % ==============================================
    %%   contrasts
    % ===============================================
    % =====[F-contrasts: Factors & T-contrasts ]==========================================
    
    fcon={};
    tcon={};
    % clc;
    for i=1:size(comb,2)
        nl=unique(comb(:,i));
        c=allcomb(nl,nl);
        c(c(:,1)>=c(:,2),:)=[];
        
        fmat=[];
        for j=1:size(c,1)
            zvec=zeros(1,size(comb,1));
            ix=find( comb(:,i)==c(j,1));
            zvec(1,ix)=+1;
            ix=find( comb(:,i)==c(j,2));
            zvec(1,ix)=-1;
            fmat=[fmat; zvec];
            %---[T]-------
            %tcon(end+1,:)={  [factors{i} '_' num2str(c(j,1)) '>' num2str(c(j,2))   ] +zvec };
            %tcon(end+1,:)={  [factors{i} '_' num2str(c(j,1)) '<' num2str(c(j,2))   ] -zvec };
            
            lm=levcode{i}.c;
            conStr1=lm{cell2mat(lm(:,2))==c(j,1),1};
            conStr2=lm{cell2mat(lm(:,2))==c(j,2),1};
            tcon(end+1,:)={  [factors{i} '_' conStr1 '>' conStr2   ] +zvec };
            tcon(end+1,:)={  [factors{i} '_' conStr1 '<' conStr2   ] -zvec };
            
        end
        %disp(['FCON-' num2str(i)])
        %disp(fmat);
        fcon(i,:)={  ['F_' factors{i} ] fmat };
    end
    
    %% ======[interim: get combi-names from comb]=========================================
    combstr={};
    for i=1:size(comb,1)
        for j=1:size(comb,2)
            thisfaclevels=levcode{j}.c;
            levvec=cell2mat(thisfaclevels(:,2));
            levname=thisfaclevels{find(levvec==comb(i,j)),1};
            combstr{i,j}=levname;
        end
    end
    
    
    
    
    
    %% =====[t-contrasts: interactions]==========================================
    icombia=allcomb([1:size(comb,1)],[1:size(comb,1)]);
    % icombia(icombia(:,1)==icombia(:,2),:)=[];
    icombia(icombia(:,1)>=icombia(:,2),:)=[];
    tias ={};
    tias2={};
    concode=[];
    tconIA={};
    
    keepNcharacters=4;
    
    for i=1:size(icombia,1)
        %zvec=zeros(1,size(comb,1));
        l1=combstr(icombia(i,1),:);
        l2=combstr(icombia(i,2),:);
        
        d1=comb(icombia(i,1),:);
        d2=comb(icombia(i,2),:);
        
        
        isequal=strcmp(l1,l2);
        if (sum(isequal)+1)==length(l1);
            tias(end+1,:)=[l1 '|' l2];
            tias2(end+1,:)=[num2cell(d1) '|' num2cell(d1)];
            concode(end+1,:)=[ icombia(i,1) icombia(i,2) ];
            
            L1=regexprep(cellfun(@(a){[ a(1:keepNcharacters)]}, cellfun(@(a){[ a repmat('#',[1 10])]}, l1)),'#','');
            L2=regexprep(cellfun(@(a){[ a(1:keepNcharacters)]}, cellfun(@(a){[ a repmat('#',[1 10])]}, l2)),'#','');
            
            
            L1=strjoin(L1,'_');
            L2=strjoin(L2,'_');
            
            
            zvec=zeros(1,size(comb,1));
            zvec(icombia(i,1))=+1;
            zvec(icombia(i,2))=-1;
            
            zvec2=-zvec;
            
            thiscon={ [L1 '>' L2] (zvec )};  %contrast
            tconIA(end+1,:)=thiscon;
            
            thiscon={ [L1 '<' L2] (zvec2)};  %inverse contrast
            tconIA(end+1,:)=thiscon;
            
        end
    end
    
    disp(tconIA);
    keyboard
    
    %% ===============================================
    
    
    % =====[F-contrasts: INTERACTION ]==========================================
    
    % interaction
    nIX=size(fcon,1);
    % comia=allcomb([1 nIX],[1 nIX]);
    comia=allcomb([1:nIX],[1:nIX]);
    comia(comia(:,1)>=comia(:,2),:)=[];
    fconIA={};
    for i=1:size(comia,1)
        fconstr1=fcon{comia(i,1),1};
        fconstr2=fcon{comia(i,2),1};
        constr=['F_' regexprep(fconstr1,'^F_','') '_X_' regexprep(fconstr2,'^F_','')];
        
        con1=fcon{comia(i,1),2};
        con2=fcon{comia(i,2),2};
        if size(con2,1)>size(con1,1)  %swap contrasts, such that 1st.Fcon has more rows than 2nd-Fcon
            dum  = con2;
            con2 = con1;
            con1 = dum;
        end
        fmat=[];
        for j=1:size(con2,1)
            con2Rep=repmat(con2(j,:),[size(con1,1) 1]);
            fmat=[fmat; con2Rep.*con1];
        end
        fconIA(i,:)={  [ constr  ] fmat };
    end
    fconAll=[fcon;fconIA];
    % ===============================================
    
    if 0 %CHECK CONS
        cprintf('*[1 0 1]',[ 'CONTRASTS_________' '\n']);
        consall=[fconAll;tcon];
        for i=1:size(consall,1)
            disp(['con-' num2str(i)])
            cprintf('*[0 .5 0]',[ consall{i,1} '\n']);
            disp(consall{i,2});
        end
    end
    
    
    
    
    
    % ==============================================
    %%   insert contrasts
    % ===============================================
    
    ncon=1;
    for i=1:size(fconAll,1)
        mb{3}.spm.stats.con.consess{ncon}.fcon.name    =fconAll{i,1} ;%['negative effect of ' factors{1}];
        mb{3}.spm.stats.con.consess{ncon}.fcon.convec  =fconAll{i,2} ;% [-ones(1,nlev(1)) ones(1,prod(nlev(2:end)))] ;% [-1 -1 1 1];
        mb{3}.spm.stats.con.consess{ncon}.fcon.sessrep = 'none';
        ncon=ncon+1;
    end
    
    for i=1:size(tcon,1)
        mb{3}.spm.stats.con.consess{ncon}.tcon.name    =tcon{i,1} ;%['negative effect of ' factors{1}];
        mb{3}.spm.stats.con.consess{ncon}.tcon.convec  =tcon{i,2} ;% [-ones(1,nlev(1)) ones(1,prod(nlev(2:end)))] ;% [-1 -1 1 1];
        mb{3}.spm.stats.con.consess{ncon}.tcon.sessrep = 'none';
        ncon=ncon+1;
    end
    mb{3}.spm.stats.con.delete = 1;
    
    %% ===============================================
    
    
    if 0
        
        if length(factors)>=2
            mb{3}.spm.stats.con.consess{1}.tcon.name    = ['negative effect of ' factors{1}];
            mb{3}.spm.stats.con.consess{1}.tcon.convec  = [-ones(1,nlev(1)) ones(1,prod(nlev(2:end)))] ;% [-1 -1 1 1];
            mb{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
            
            mb{3}.spm.stats.con.consess{2}.tcon.name    =['negative effect of ' factors{2}];;
            mb{3}.spm.stats.con.consess{2}.tcon.convec  = [-1 1 -1 1];
            mb{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
            
            mb{3}.spm.stats.con.consess{3}.tcon.name    = ['negative Interaction: ' factors{1} ' x ' factors{2}];
            mb{3}.spm.stats.con.consess{3}.tcon.convec  = [-1 1 1 -1];
            mb{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
            mb{3}.spm.stats.con.delete = 0;
        end
        
    end
    
    %% ===============================================
    
    
    % mb{4}.spm.stats.results.spmmat(1) = cfg_dep;
    % mb{4}.spm.stats.results.spmmat(1).tname = 'Select SPM.mat';
    % mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).name = 'filter';
    % mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(1).value = 'mat';
    % mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).name = 'strtype';
    % mb{4}.spm.stats.results.spmmat(1).tgt_spec{1}(2).value = 'e';
    % mb{4}.spm.stats.results.spmmat(1).sname = 'Contrast Manager: SPM.mat File';
    % mb{4}.spm.stats.results.spmmat(1).src_exbranch = substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1});
    % mb{4}.spm.stats.results.spmmat(1).src_output = substruct('.','spmmat');
    % mb{4}.spm.stats.results.conspec(1).titlestr = '';
    % mb{4}.spm.stats.results.conspec(1).contrasts = 1;
    % mb{4}.spm.stats.results.conspec(1).threshdesc = 'FWE';
    % mb{4}.spm.stats.results.conspec(1).thresh = 0.05;
    % mb{4}.spm.stats.results.conspec(1).extent = 0;
    % mb{4}.spm.stats.results.conspec(1).mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
    % % mb{4}.spm.stats.results.conspec(2).titlestr = '';
    % % mb{4}.spm.stats.results.conspec(2).contrasts = 2;
    % % mb{4}.spm.stats.results.conspec(2).threshdesc = 'FWE';
    % % mb{4}.spm.stats.results.conspec(2).thresh = 0.05;
    % % mb{4}.spm.stats.results.conspec(2).extent = 0;
    % % mb{4}.spm.stats.results.conspec(2).mask = struct('contrasts', {}, 'thresh', {}, 'mtype', {});
    % mb{4}.spm.stats.results.units = 1;
    % mb{4}.spm.stats.results.print = false;
    
    % ####################
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
    
end % if 0

%%  smoothing
if s.smoothing==1
    % change [1] Data Smoothing [2]data for factDesignSpecif. [3] dependency-order
    try ;        smoothfwhm=str2num(s.smoothing_fwhm);
    catch;       smoothfwhm=        (s.smoothing_fwhm);
    end
    
    ms={};
    ms{1}.spm.spatial.smooth.data = [niftis];
    ms{1}.spm.spatial.smooth.fwhm = smoothfwhm ;% [0.28 0.28 0.28];
    ms{1}.spm.spatial.smooth.dtype = 0;
    ms{1}.spm.spatial.smooth.im = 0;
    ms{1}.spm.spatial.smooth.prefix = 's';
    
    mb{1}.spm.stats.factorial_design.des.fblock.fsuball.specall.scans =stradd( niftis,'s',1);
    %change inputfiles to smoothed images
    %     for i=1:size(scans,1)
    %         mb{1}.spm.stats.factorial_design.des.fd.icell(i).scans =      stradd( scans{i},'s',1);
    %     end
    
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



