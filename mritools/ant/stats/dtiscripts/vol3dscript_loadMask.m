% <b> script to load+display a brain-mask </b>

clear

% ===============================================
%        general properties
% ===============================================
p.gen.info_______=' *** GENERAL PARAMETER ***';
p.gen.mask='F:\data5\eranet_round2_statistic\DTI\templates\AVGTmask.nii'; %brainMask
p.gen.view=[-141.5  46];
p.gen.brainColor=[0.92941  0.69412  0.12549];

% ===============================================
%        main-gui properties
% ===============================================
p.main.info_______=' *** MAIN PARAMETER [xvol3d-window]*** ';
p.main.showarrows=[1];
p.main.braindot=[0];
p.main.brainalpha='0.03';
p.main.material=[2];
p.main.notused_material='shiny';
p.main.rblight=[1];
p.g.brainColor=[0.9333 0.9333 0.9333];

%% ======= comand ========================================
xvol3d('loadprop',[],'p',p);
