

function check_vol_btable_consistency


%% ===============================================
v=update_monitor();
pastudy       =v.pastudy;% fullfile(fileparts(fileparts(pwd)));
pain          = fullfile(pastudy, 'data');                       
[~,studyname] = fileparts(pastudy);
%% ===============================================
clc;
cprintf('*[0 .5 0]', [  ' CHECK..DOES number of volumes match with number of B-values? '   '\n']);  

  
[files,dirs] = spm_select('FPListRec',pain,'^rc_t2.nii$');
files=cellstr(files);
pa=fileparts2(files);

t2 ={};
tm2={};
for i=1:length(pa)
    [t tm]=checkcons(pa{i});
    t2 =[t2; t];
    tm2=[tm2; tm];
end
ierr=find(cell2mat(t2(:,4))==0);
if ~isempty(ierr)
    ms=strjoin(unique(tm2(ierr)),'|');
    cprintf('*[1 0 1]', [  ' ERROR: mismatch of number of volumes and number of B-values '   '\n']);  
    cprintf('[1 0 1]', [  ' problematic animals: ' ms   '\n']);
    cprintf('[1 0 1]', [  ' please inspect files from problematic animals (check above files tagged with "isOK"=0) '    '\n']);

else
  cprintf('*[0 .5 0]', [  ' OK: The number of volumes and B-values does match!'   '\n']);  
end

function [t tm]=checkcons(px)

%% ===============================================

% px='X:\Imaging\Paul_DTI\pruess_ophelia\data\a001\20230926HP_Oph1_SNA125153_T2_rsMRI_DTI'
 [px0,animal]=fileparts(px);
 [px00,animalID]=fileparts(px0);

[nfis] = spm_select('List',px,'^dwi_.*.nii$');
nfis=cellstr(nfis);
tfis=regexprep(nfis,{'^dwi_','.nii$'},{'grad_','.txt'});
%% ===============================================

t={};
tm={};
for i=1:length(nfis)
    f1=fullfile(px,nfis{i});
    f2=fullfile(px,tfis{i});
   h= spm_vol(f1);
 
   a=preadfile(f2);
   a=a.all;
   nv=length(h);
   nt=size(a,1);

   isok=0;
   if nv==nt; 
       isok=1;
   end
  t(end+1,:)  =([    nfis{i}    num2cell([nv nt isok])   ]);
  tm(end+1,:) ={ animalID animal  };
end

cprintf('*[0 0 1]', [  '[' animalID '] ' animal   '\n']);
disp(cell2table(t,'VariableNames',{'FILE' 'nVols' 'nBvals' 'isOK'}));


