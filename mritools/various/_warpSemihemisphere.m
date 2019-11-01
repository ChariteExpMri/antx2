thispath=pwd
cd('V:\mritools')
maus
cd(thispath)

% clear

maskvol=fullfile(pwd,    'whemi2.nii')
val2replace=nan

 if  1
%%  T2-volumes ausstanzen .1 .05
  % SOURCE
  thresh=.01;%.2%[.01]
 tpm=  {    'wc1T2.nii'    'wc2T2.nii'   'wc3T2.nii'     }';  tpm=fullpath(pwd,tpm);
 makebrainmask2(tpm, thresh, fullfile(pwd, 'mousemask.nii'))
 fi1=applymask(fullfile(pwd,'wT2.nii'), fullfile(pwd,'mousemask.nii'),'>0',[],nan,'_masked');
%  fi2=rapplymask('_Atpl_mouseatlasNew.nii ','templatemask.nii','>0',1,nan,'_masked');

 % TEMPLATE
 tpm=  {    '_Atpl_greyr62.nii'    '_Atpl_whiter62.nii'   '_Atpl_csfr62.nii' }';  tpm=fullpath(pwd,tpm);
 makebrainmask2(tpm, thresh, fullfile(pwd,'templatemask.nii')); %checked
fi2=applymask(fullfile(pwd,'_Atpl_mouseatlasNew.nii'),'templatemask.nii','>0',[],nan,'_masked');
  

%% masken bilden
side=2
if side==1
    sideTag =   '_left'
    operator=  '==1'   
    operatorNormalized='>'
else
    sideTag='_right'
    operator=  '==2'  
    operatorNormalized='<='
end


source   = applymask(fi1           ,   maskvol,                         operator      ,[],val2replace, sideTag);
template=maskData(fi2             ,     [0 0 0],1, operatorNormalized ,val2replace,                             sideTag)

 
end

% return

if 1

%% source & template Image

% val2replace=0
% source   = applymask(fullfile(pwd, 'wc1T2.nii'),                 maskvol,                     '==1',1,val2replace,'_left');
% template=maskData(fullfile(pwd, '_Atpl_greyr62.nii'),                    [0 0 0],1,'>',val2replace, '_left' )

%% NNinterp
resn1   = applymask(fullfile(pwd, 'whemi2.nii'),maskvol,                                     operator      ,[],val2replace,      sideTag);
resn2   = applymask(fullfile(pwd, 'wmask2.nii'),maskvol,                                    operator      ,[],val2replace,       sideTag);
resampleNN={resn1;resn2}

%%  trilinInterp
res1   = applymask(fullfile(pwd, 'wT2.nii'),     maskvol,                                  operator      ,[],val2replace,            sideTag);
res2   = applymask(fullfile(pwd, 'wc1T2.nii'), maskvol,                                  operator      ,[],val2replace,            sideTag);
res3   = applymask(fullfile(pwd, 'wc2T2.nii'), maskvol,                                  operator      ,[],val2replace,           sideTag);
resampleTRI={res1;res2;res3}
  

end

  interp         =0
  matlabbatch=[]
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.source ={source};% {'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\wT2_masked.nii'};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.wtsrc = {''};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample =''; 
% {...
%         'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\wT2.nii'
%         'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\wc1T2.nii'
%         'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\wc2T2.nii'
%         'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\wc3T2.nii'
%         };

matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.template ={template};% {'V:\projects\atlasRegEdemaCorr\optimiceWarp\s20150909_FK_C2M10_1_3_1_1\_Atpl_mouseatlasNew_masked.nii'};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.weight = '';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smosrc =.7; [.3]%35%[.72];%0.3;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.smoref =0 %[.2];%0.2;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.regtype = 'subj';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.cutoff =1%1.8%1.8;%[2.25]% 1;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.nits = 16;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg =.1  ;% [1];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.preserve = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.bb = [-5.9252 -9.4889 -8.671
                                                             5.5466 6.5385 0.7027];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.vox = [0.069 0.07 0.07];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.interp = interp
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.prefix = 'X';
    

%  iteration 16:  FWHM = 0.2381 Var = 0.502254
% iteration 16:  FWHM = 0.2278 Var = 0.305215
%   iteration 16:  FWHM = 0.1838 Var = 0.186112
%% trilinar
if 1
interp1=1;
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = resampleTRI;%; resampleTRI
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.interp = interp1
spm_jobman('run',  matlabbatch);
end


interp2=0;
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample =resampleNN; 
matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.interp = interp2
spm_jobman('run',  matlabbatch);
% 


%% calc volumes
% [ vol ]=getvolume(['Xmask2_left.nii'],'==1')
% [ vol ]=getvolume(['hemi2_left.nii'],'==1')
% [ vol ]=getvolume(['Xhemi2_left.nii'],'==1')

    disp('hemisphere(pre/post)');
    file=resn1;
    [pa2 fi ext]=fileparts(file);
    [ vol1 ]=getvolume(file,'~=0');
    [ vol2 ]=getvolume(fullfile(pa2,[     matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.prefix  fi ext ]  ),'~=0');
    disp([vol1 vol2]);


disp('lesion(pre/post)');
file=resn2;
[pa2 fi ext]=fileparts(file);
[ vol3 ]=getvolume(file,'==1');
[ vol4]=getvolume(fullfile(pa2,[     matlabbatch{1}.spm.spatial.normalise.estwrite.roptions.prefix  fi ext ]  ),'==1');
disp([vol3 vol4]);

vol4*(vol1/vol2)






%% left side
% hemisphere(pre/post)
%   270.5328  277.9331
% 
% lesion(pre/post)
%    76.2024   65.9200
% 
% 
% ans =
% 
%    64.1648
%% right side
% 254.3545  254.1853

if 0
    [ vol1 ]=getvolume(fullfile(pwd, 'hemisphere.nii'),'==1');
    [ vol2 ]=getvolume(fullfile(pwd, 'hemisphere.nii'),'==2');
    
    [ vol3 ]=getvolume(fullfile(pwd, 'Xwhemi2_left.nii'),'==1');
    [ vol4 ]=getvolume(fullfile(pwd, 'Xwhemi2_right.nii'),'==2');
    
    disp('hemisphere LR');
    mm=  [vol1 vol2; vol3 vol4];
    disp(mm);
    
    disp('Ratio');
    %     [vol1/vol2 vol3/vol4]
    ratio=[ 1/(mm(1,2)/(mean(mm(1,:))))
        1/(mm(2,2)/(mean(mm(2,:))))];
    disp(ratio);
    
    [ vol5]=getvolume(fullfile(pwd, 'mask.nii'),'==1');
    %       [ vol5]=getvolume(fullfile(pwd, 'wmask2_left.nii'),'==1')
    [ vol6]=getvolume(fullfile(pwd, 'Xwmask2_left.nii'),'==1');
    disp('lesion');
    disp([vol5 vol6]);
    
    if 0 %susanne
        %=CON+IPS - (CON+IPS-LAS)*(CON+IPS)/(2*CON)
        %78,49	230,18	259,22	52,57
        LAS=78.49
        CON=230.18
        IPS=259.22
        CON+IPS - (CON+IPS-LAS)*(CON+IPS)/(2*CON)
    end
       LAS=vol6
        CON=mm(2,2)
        IPS=mm(2,1)
        CON+IPS - (CON+IPS-LAS)*(CON+IPS)/(2*CON)

        
        
    
    
end


%   259.2250  230.1750
%   262.5965  267.1815
%     1.1262    0.9828

%native GM
% hemisphere(pre/post)
%   255.8514  268.9827
% lesion(pre/post)
%    77.5104   76.7692
% native WM
% hemisphere(pre/post)
%   255.8514  278.5918
% lesion(pre/post)
%    77.5104   75.4350
%
%normalized GM
% hemisphere(pre/post)
%   270.5328  268.8437
% lesion(pre/post)
%    76.2024   75.5687

%normalized WM
% hemisphere(pre/post)
%   270.5328  278.5177
% lesion(pre/post)
%    76.2024   75.0738
   
   
   



  