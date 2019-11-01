
function MR=autoregister(s,ref, predef)

% s:    source IMAGE (to be warped)
%ref:  reference IMAGE



pa=fileparts(s);


timex=tic;

% ref       =fullfile(pa,'t2_1.nii')
% s         =fullfile(pa,'greyr62.nii')
% predef=[ [[0 0 0   -pi/2 pi 0 ]]  1 1 1 0 0 0]

[shift vec]=restimateOrigin4(s, ref ,[-7 7], [2 .5 .1 .05],predef);
st=fullfile(pa,'_test333SHIFT.nii');
copyfile(s,st);
% trafo=[ [shift] [-pi/2 pi 0] 1 1 1 0 0 0]
% fsetorigin({st}, vec);  %ANA

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


%% coreg
T2=fullfile(pa,'_test333KOREG.nii');
copyfile(st,T2);
T1=ref;


ff.cost_fun = 'nmi';
% ff.sep = [4 2 1 0.5 0.1];%[2 1 0.36 0.18 ];%
ff.sep = [4 2 1 0.5 0.1 .05];%[2 1 0.36 0.18 ];%
ff.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
ff.fwhm = [7 7];

T1_vol = spm_vol(T1);
T2_vol = spm_vol(T2);
x = spm_coreg(T2_vol, T1_vol,ff);
M = spm_matrix(x);
spm_get_space(T2, M * T2_vol.mat);

%% retest
q=fullfile(pa,'_test333FIN.nii');
copyfile(s,q);

mf=q;
mg=T2;

% The mat file contents are loaded by:
	MF = spm_get_space(mf);
	MG = spm_get_space(mg); %VG    - handle for reference image ## see spm_vol or spm_coreg
	
	% A rigid body mapping is derived by:
% 	MR = MF/MG; % or
    MR = MG/MF;
	
    mfvol=spm_vol(mf);
    spm_get_space(mf, MR * mfvol.mat);
    
    toc(timex)
    
    %% clean up
%     try; delete(st);end
%     try; delete(T2);end
    
    
    
    
    
    