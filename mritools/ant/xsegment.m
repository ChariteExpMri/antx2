%% SEGMENT MOUSE
% function xsegment(t2,template)
%% INPUT:
% t2 :          FPfile of t2.nii
% template: {cell} with ordered TPMs(GM,WM,CSF)+FPfile of reorient.mat
%% EXAMPLE
% t2='O:\harms1\koeln\dat\s20150701_BB1\t2.nii';
% template={         'O:\harms1\koeln\dat\s20150701_BB1\_b1grey.nii'
%                             'O:\harms1\koeln\dat\s20150701_BB1\_b2white.nii'
%                             'O:\harms1\koeln\dat\s20150701_BB1\_b3csf.nii'
%                             'O:\harms1\koeln\dat\s20150701_BB1\reorient.mat'}
% xsegment(t2,template)

function xsegment(t2,template,param)

if exist('param')~=1
    param=struct();
end

spmversion=spm('ver');
if strcmp(spmversion,'SPM12')
    runsegmSPM12(t2,template,param);
elseif strcmp(spmversion,'SPM8')
    runsegmSPM8(t2,template);
end
%% —————————————————————————————————————————————————————————————————————————————————————————————————
%% SUBS
% ==============================================
%%  SPM-12
% ===============================================
function runsegmSPM12(t2,template,param);
t2destpath=fileparts(t2);


% if 1
%
%     cnt=1
%     matlabbatch={};
%     matlabbatch{1}.spm.tools.animal.oldseg.data = {t2};
%     matlabbatch{1}.spm.tools.animal.oldseg.output.GM = [0 0 1];
%     matlabbatch{1}.spm.tools.animal.oldseg.output.WM = [0 0 1];
%     matlabbatch{1}.spm.tools.animal.oldseg.output.CSF= [0 0 1];
%     matlabbatch{1}.spm.tools.animal.oldseg.output.biascor = 1;
%     matlabbatch{1}.spm.tools.animal.oldseg.output.cleanup = 0;
%     matlabbatch{1}.spm.tools.animal.oldseg.opts.tpm = template(1:3); % Define Templates here
%     matlabbatch{1}.spm.tools.animal.oldseg.opts.ngaus = [2 2 2 4]' ;
%
%     matlabbatch{1}.spm.tools.animal.oldseg.opts.regtype = 'animal';
%     matlabbatch{1}.spm.tools.animal.oldseg.opts.warpreg = 1;
%     matlabbatch{1}.spm.tools.animal.oldseg.opts.warpco =  1.75;
%     matlabbatch{1}.spm.tools.animal.oldseg.opts.biasreg = 0.0001;
%     matlabbatch{1}.spm.tools.animal.oldseg.opts.biasfwhm = 5;
%     matlabbatch{1}.spm.tools.animal.oldseg.opts.samp = 0.1;
%     matlabbatch{1}.spm.tools.animal.oldseg.opts.msk = {''};
%     spm_jobman('serial',  matlabbatch);
%
%
% %     cnt = cnt + 1;
% matlabbatch={}; cnt=1
% matlabbatch{cnt}.spm.util.imcalc.input =  {
%     fullfile(t2destpath,'c1t2.nii')
%     fullfile(t2destpath,'c2t2.nii')
%     };
% matlabbatch{cnt}.spm.util.imcalc.output         = 'c1c2mask.nii';
% matlabbatch{cnt}.spm.util.imcalc.outdir         = { t2destpath };
% matlabbatch{cnt}.spm.util.imcalc.expression     = '((i1 + i2)/2)>0.3';
% matlabbatch{cnt}.spm.util.imcalc.options.dmtx   = 0;
% matlabbatch{cnt}.spm.util.imcalc.options.mask   = 0;
% matlabbatch{cnt}.spm.util.imcalc.options.interp = 1;
% matlabbatch{cnt}.spm.util.imcalc.options.dtype  = 4;
% spm_jobman('serial',  matlabbatch);
%
% end
%
%
% cnt = 1;
% matlabbatch{cnt}.spm.spatial.preproc.data           = {t2}  ;%{t2nii{1}}; %% T2file
% matlabbatch{cnt}.spm.spatial.preproc.opts.warpreg   =   1; % Original 1 (funzt okay: 50)
% matlabbatch{cnt}.spm.spatial.preproc.opts.warpco    = 1.75; % Original 1.75 (funzt okay: 2.5)
% matlabbatch{cnt}.spm.spatial.preproc.output.GM      = [0 0 1];
% matlabbatch{cnt}.spm.spatial.preproc.output.WM      = [0 0 1];
% matlabbatch{cnt}.spm.spatial.preproc.output.CSF     = [0 0 1];
% matlabbatch{cnt}.spm.spatial.preproc.output.biascor = 1;
% matlabbatch{cnt}.spm.spatial.preproc.output.cleanup = 0;
% matlabbatch{cnt}.spm.spatial.preproc.opts.tpm       = template; % Define Templates here
% matlabbatch{cnt}.spm.spatial.preproc.opts.ngaus     = [3    2    2    4];
% matlabbatch{cnt}.spm.spatial.preproc.opts.regtype   = 'animal'; % 'animal' / '';
% matlabbatch{cnt}.spm.spatial.preproc.opts.biasreg   = 0.0001;%0.0001;
% matlabbatch{cnt}.spm.spatial.preproc.opts.biasfwhm  = 5;
% matlabbatch{cnt}.spm.spatial.preproc.opts.samp      = 0.1;%0.1;
% matlabbatch{cnt}.spm.spatial.preproc.opts.msk       = {''};

%% —————————————————————————————————————————————————————————————————————————————————————————————————
% using spm8 function

%---------------------- changing defaults
global defaults
tpm0pa = fullfile(fileparts(which('spmmouse')),'tpm');
tpm0  ={'greyr62.nii' 'whiter62.nii' 'csfr62.nii' };
tpm0  =stradd(tpm0,[tpm0pa filesep],1);

pr.tpm      = tpm0; %{'o:\antx2\spm12\toolbox\spmmouse\tpm\greyr62.nii'  %see: defaults.animal.tpm
%                     'o:\antx2\spm12\toolbox\spmmouse\tpm\whiter62.nii'
%                     'o:\antx2\spm12\toolbox\spmmouse\tpm\csfr62.nii'  }
pr.ngaus    = [3 2 2 4]';
pr.warpreg  = 1;
pr.warpco   = 1.7500;
pr.biasreg  = 1.0000e-04;
pr.biasfwhm = 5;
pr.regtype  = 'animal';
pr.fudge    = 0.5000;
pr.samp     = 0.2100;
pr.output   = struct('GM',[0 0 1],'WM',[0 0 1],'CSF',[0 0 0]) ; %[1x1 struct]
% output
% ans =
%          GM: [0 0 1]
%          WM: [0 0 1]
%         CSF: [0 0 0]
defaults.preproc=pr;
%----------------------


job={};
job.data          = {t2}; %{ 'O:\data4\ant_upd2_win\dat\m09\segm\t2.nii'}
job.output.GM     = [0 0 1];
job.output.WM     = [0 0 1];
job.output.CSF    = [0 0 1];
job.output.biascor= 1;
job.output.cleanup= 0;

job.opts.tpm = template(1:3) ;%{      'O:\data4\ant_upd2_win\dat\m09\segm\_b1grey.nii'
%                                     'O:\data4\ant_upd2_win\dat\m09\segm\_b2white.nii'
%                                     'O:\data4\ant_upd2_win\dat\m09\segm\_b3csf.nii'}
job.opts.ngaus   = [3 2 2 4]';
job.opts.regtype = 'animal';
job.opts.warpreg = 1;
job.opts.warpco  = 1.7500;
job.opts.biasreg = 1.0000e-04;
job.opts.biasfwhm= 5;
job.opts.samp    = 0.1000;
job.opts.msk     = {''};

% ==============================================
%%   check params (s-struct)
% ===============================================
if isfield(param,'species')==1
    % ==============================================
    %%  override parameter for "RAT"
    % ===============================================
    if strcmp(param.species,'rat')% override for "rat"
        
        job.opts.warpco  = 3.75  ;
        job.opts.samp    = 0.25  ;
        
        [t2pathorig subdir]=fileparts(fileparts(t2));
        msk1=fullfile(t2pathorig,'_msk.nii');
        if exist(msk1)==2
            [h,d ]=rreslice2target(msk1, t2, [], 0,[2 0])  ;
            msk2=fullfile(t2pathorig,subdir,[ '_mskBin.nii']);
            rsavenii(msk2, h,d>0,[2 0]);
            job.opts.msk=msk2;
        end
    elseif strcmp(param.species,'cat')% override for "cat"
        %         mouse:
        %          job.opts.warpco = 1.75
        %          job.opts.samp   = 0.1
        %          tpm: {3x1 cell}
        %        ngaus: [4x1 double]
        %      regtype: 'animal'
        %      warpreg: 1
        %       warpco: 1.7500
        %      biasreg: 1.0000e-04
        %     biasfwhm: 5
        %         samp: 0.1000
        %          msk: {''}
        % http://91.121.177.56/axon-4.5/en/processes/segment_SPM_noLinks.html    
        disp('cat-parameter-new');
        job.opts.warpco   =  25;% 6;% 10, 25  ;
        job.opts.samp     =  2;% 0.7 ; %0.25*factor2.8  %3;%3, 2(no vis diff to 3)
        job.opts.biasfwhm =  10; %10,  7.5 (7.5 slow >20min). 5: really slow (>4h)
        
         if 0
            job.opts.warpco  = 10;% 10, 25  ;
            job.opts.samp    = 3;%3, 2(no vis diff to 3)
            job.opts.biasfwhm= 8 ; %10,  7.5 (7.5 slow >20min). 5: really slow (>4h)
        end
        
        
        %         job.opts.warpco  = 25  ;
        %         job.opts.samp    = 3  ;
        %         job.opts.biasfwhm=20
        %
        [t2pathorig subdir]=fileparts(fileparts(t2));
        msk1=fullfile(t2pathorig,'_msk.nii');
        if exist(msk1)==2
            [h,d ]=rreslice2target(msk1, t2, [], 0,[2 0])  ;
            msk2=fullfile(t2pathorig,subdir,[ '_mskBin.nii']);
            rsavenii(msk2, h,d>0,[2 0]);
            job.opts.msk=msk2;
        end
        
    end
end

% ==============================================
%%   OVERRIDE-parameters
% ===============================================
if 1
    paoverride=fileparts(fileparts(fileparts(fileparts(t2))));
    overridefun=fullfile(paoverride,'override.m');
    if exist(overridefun)
        pabef=pwd;
        cd(paoverride);
        parm=override();
        cd(pabef);
        if isfield(parm,'segm') && isfield(parm.segm,'opts')
            fields=fieldnames(parm.segm.opts);
            disp('overriding parameters from "override.m"-function');
            for i=1:length(fields)
                job.opts= setfield(job.opts,  fields{i}   ,getfield(parm.segm.opts,fields{i}) );
            end
        end
    end
end

% ==============================================
%%   run job
% ===============================================

spm_run_preproc_spm8(job);  % spm8-function









%% —————————————————————————————————————————————————————————————————————————————————————————————————

% cnt = cnt + 1;
cnt = 1;  matlabbatch={};

matlabbatch{cnt}.spm.util.imcalc.input =  {
    fullfile(t2destpath,'c1t2.nii')
    fullfile(t2destpath,'c2t2.nii')
    };
matlabbatch{cnt}.spm.util.imcalc.output         = 'c1c2mask.nii';
matlabbatch{cnt}.spm.util.imcalc.outdir         = { t2destpath };
matlabbatch{cnt}.spm.util.imcalc.expression     = '((i1 + i2)/2)>0.3';
matlabbatch{cnt}.spm.util.imcalc.options.dmtx   = 0;
matlabbatch{cnt}.spm.util.imcalc.options.mask   = 0;
matlabbatch{cnt}.spm.util.imcalc.options.interp = 1;
matlabbatch{cnt}.spm.util.imcalc.options.dtype  = 4;


%% —————————————————————————————————————————————————————————————————————————————————————————————————

% deformField SPM12-forward
% cnt=1;matlabbatch={}
% cnt=0;matlabbatch={}

cnt=cnt+1;
matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.matname         = { fullfile(t2destpath,'t2_seg_sn.mat') }; % {'O:\data4\ant_upd2_win\dat\m09\t2_seg_sn.mat'};
matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.vox             = [NaN NaN NaN];
matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.bb              = [NaN NaN NaN; NaN NaN NaN];
matlabbatch{cnt}.spm.util.defs.out{1}.savedef.ofname          = 'forward';
matlabbatch{cnt}.spm.util.defs.out{1}.savedef.savedir.saveusr = {t2destpath} ;% {'O:\data4\ant_upd2_win\dat\m09'};
% spm_jobman('interactive',  matlabbatch)
% spm_jobman('serial',  matlabbatch)


% deformField SPM12-backward
% cnt=1;matlabbatch={}
cnt=cnt+1;
matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.matname         = { fullfile(t2destpath,'t2_seg_inv_sn.mat') }; %{'O:\data4\ant_upd2_win\dat\m09\t2_seg_inv_sn.mat'};
matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.vox             = [NaN NaN NaN];
matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.bb              = [NaN NaN NaN; NaN NaN NaN];
matlabbatch{cnt}.spm.util.defs.out{1}.savedef.ofname          = 'inverse';
matlabbatch{cnt}.spm.util.defs.out{1}.savedef.savedir.saveusr = {t2destpath} ;%{'O:\data4\ant_upd2_win\dat\m09'};
% spm_jobman('interactive',  matlabbatch)
spm_jobman('serial',  matlabbatch)


% Realign deformations to original template space
P.yname   =  { fullfile(t2destpath,'y_forward.nii') }   ;%{'O:\data4\ant_upd2_win\dat\m09\y_forward.nii'}
P.iyname  =  { fullfile(t2destpath,'y_inverse.nii') }   ;%{'O:\data4\ant_upd2_win\dat\m09\y_inverse.nii'}
P.matname =  { fullfile(t2destpath,'reorient.mat' ) }   ;%{'O:\data4\ant_upd2_win\dat\m09\reorient.mat'}
out = FB_dti_realigndef_ui(P);
%% —————————————————————————————————————————————————————————————————————————————————————————————————














% ==============================================
%%  SPM-8
% ===============================================
function runsegmSPM8(t2,template);
t2destpath=fileparts(t2);

cnt = 1;
matlabbatch{cnt}.spm.spatial.preproc.data = {t2}  ;%{t2nii{1}}; %% T2file
matlabbatch{cnt}.spm.spatial.preproc.opts.warpreg = 1; % Original 1 (funzt okay: 50)
matlabbatch{cnt}.spm.spatial.preproc.opts.warpco = 1.75; % Original 1.75 (funzt okay: 2.5)
%     else
% %         matlabbatch{cnt}.spm.spatial.preproc.data = {fullfile(t2destpath,'b0.nii')};
% %         matlabbatch{cnt}.spm.spatial.preproc.opts.warpreg = 1; % Original 1 (funzt okay: 50)
% %         matlabbatch{cnt}.spm.spatial.preproc.opts.warpco = 1.75; % Original 1.75 (funzt okay: 2.5)
%     end;
matlabbatch{cnt}.spm.spatial.preproc.output.GM = [0 0 1];
matlabbatch{cnt}.spm.spatial.preproc.output.WM = [0 0 1];
matlabbatch{cnt}.spm.spatial.preproc.output.CSF = [0 0 1];
matlabbatch{cnt}.spm.spatial.preproc.output.biascor = 1;
matlabbatch{cnt}.spm.spatial.preproc.output.cleanup = 0;
matlabbatch{cnt}.spm.spatial.preproc.opts.tpm = template; % Define Templates here
matlabbatch{cnt}.spm.spatial.preproc.opts.ngaus = [3
    2
    2
    4];
matlabbatch{cnt}.spm.spatial.preproc.opts.regtype = 'animal'; % 'animal' / '';
matlabbatch{cnt}.spm.spatial.preproc.opts.biasreg = 0.0001;%0.0001;
matlabbatch{cnt}.spm.spatial.preproc.opts.biasfwhm = 5;
matlabbatch{cnt}.spm.spatial.preproc.opts.samp = 0.1;%0.1;
matlabbatch{cnt}.spm.spatial.preproc.opts.msk = {''};


cnt = cnt + 1;
matlabbatch{cnt}.spm.util.imcalc.input =  {
    fullfile(t2destpath,'c1t2.nii')
    fullfile(t2destpath,'c2t2.nii')
    };
matlabbatch{cnt}.spm.util.imcalc.output = 'c1c2mask.nii';
matlabbatch{cnt}.spm.util.imcalc.outdir = { t2destpath };
matlabbatch{cnt}.spm.util.imcalc.expression = '((i1 + i2)/2)>0.3';
matlabbatch{cnt}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{cnt}.spm.util.imcalc.options.mask = 0;
matlabbatch{cnt}.spm.util.imcalc.options.interp = 1;
matlabbatch{cnt}.spm.util.imcalc.options.dtype = 4;


% Convert Deformation Parameters
% Convert deformation parameters to iy/y format (forward)
% if any(options == 4)
cnt = cnt + 1;
matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.matname = {fullfile(t2destpath,'t2_seg_sn.mat')};
matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.vox = [NaN NaN NaN];
matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.bb = [NaN NaN NaN
    NaN NaN NaN];
matlabbatch{cnt}.spm.util.defs.ofname = 'forward';
matlabbatch{cnt}.spm.util.defs.fnames = '';
matlabbatch{cnt}.spm.util.defs.savedir.savedef = 1;
matlabbatch{cnt}.spm.util.defs.interp = 4;


% Convert deformation parameters to iy/y format (inverse)
% if any(options == 4)
cnt = cnt + 1;
matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.matname = {fullfile(t2destpath,'t2_seg_inv_sn.mat')};
matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.vox = [NaN NaN NaN];
matlabbatch{cnt}.spm.util.defs.comp{1}.sn2def.bb = [NaN NaN NaN
    NaN NaN NaN];
matlabbatch{cnt}.spm.util.defs.ofname = 'inverse';
matlabbatch{cnt}.spm.util.defs.fnames = {''};
matlabbatch{cnt}.spm.util.defs.savedir.savedef = 1;
matlabbatch{cnt}.spm.util.defs.interp = 4;

% Realign deformations to original template space
cnt = cnt + 1;
matlabbatch{cnt}.dtijobs.realigndef.yname = {fullfile(t2destpath,'y_forward.nii')};
matlabbatch{cnt}.dtijobs.realigndef.iyname = {fullfile(t2destpath,'y_inverse.nii')};
matlabbatch{cnt}.dtijobs.realigndef.matname =  template(end);%template(4);

%     return
spm_jobman('serial',  matlabbatch);







