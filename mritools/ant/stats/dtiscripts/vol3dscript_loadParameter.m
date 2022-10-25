% <b> script to load mask & display connections (and save images) </b>
% please modify "file_mask" & file_nodes" accordingly
% to generate a parameter-list use xvol3d-MENU: props/"copy properties to clipboard"
% 
% 

%% ===============================================
%%   [xvol3] main-gui properties                         
%% ===============================================
pain=pwd; %input-directory
file_mask  ='F:\data4\sarahDTI_stat\atlas_SA040521_v4\AVGTmask.nii'; %maskFile
file_nodes =fullfile(pain, 'expFig4__g1_vs_g2_3_p0.05.xlsx');        % nodesfile...generated via [dtistat.m], button: "export4xvol3d" 
paout      =fullfile(pain, 'images');                                % outputfile to save the figures

close all;  %close all figures
p=[];
p.gen.info_______=' *** GENERAL PARAMETER ***';
p.gen.mask=file_mask;
p.gen.view=[-37.5  30];
p.gen.brainColor=[0.9333  0.9333  0.9333];
p.main.info_______=' *** MAIN PARAMETER [xvol3d-window]*** ';
p.main.showarrows=[1];
p.main.braindot=[0];
p.main.brainalpha='0.05';
p.main.material=[2];
p.main.notused_material='shiny';
p.main.rblight=[1];
 
% ===============================================
%   [xvol3]   connections properties              
% ===============================================
p.con.filenode=file_nodes;
p.con.lab.dummi=[1];
p.con.lab.fs=[7];
p.con.lab.fcol=[0  0  0];
p.con.lab.fhorzal=[2];
p.con.lab.needlevisible=[0];
p.con.lab.needlelength=[0];
p.con.lab.needlecol=[0  0  0];
p.con.lab.abbreviate=[0];
p.con.lab.abbreviationLength=[3];
p.con.lab.useNumbers=[1];
p.con.sting.dummi=[1];
p.con.sting.stingview=[1];
p.con.sting.linestyle=':';
p.con.sting.linewidth=[0.8];
p.con.sting.linecol=[0.7  0.7  0.7];
p.con.sting.fs=[7];
p.con.sting.fontbold=[1];
p.con.sting.fontcol=[0  0  0];
p.con.sting.isdebug=[0];
p.con.sting.radiusfac=[1.1];
p.con.sting.sepmax=[10];
p.con.sting.pointsfac=[250];
p.con.sting.volcenter=[1];
p.con.t.col1={ '0 0.5 0' };
p.con.t.R1={ '2' };
p.con.t.T1={ '1' };
p.con.t.Lcol={ '0 0 1' };
p.con.t.LR={ '1' };
p.con.t.LT={ '1' };
p.con.win.nodelabel=[1];
p.con.win.stingview=[1];
p.con.win.selectAll=[1];
p.con.win.allnodes=[1];
p.con.win.alllinks=[1];
p.con.win.instantUpdate=[1];
p.con.win.selectRow=[0];
p.con.win.CS2RAD=[1];
p.con.win.CS2RADexpression='*2+.3';
p.con.win.linkintensity=[1];
p.con.win.colorlimits=' -2 2';
p.con.win.linkcolormap=[59];
%-----load xvol3-properties-----------------------
xvol3d('loadprop',p); % load properties

% ==============================================
%%   save images ...optional
% ===============================================

if 0
    % code to save an image
    s=[];
    s.saveimg_edPath      = paout  % outpot path for image(s)
    s.saveimg_rdTimeStamp =  [1];     % add timeStamp to image-filename {0,1}
    s.saveimg_edPrefix    =  'v';     % prefix for image-filename {string}
    s.saveimg_popResol    =  [1];     % image resolution {pulldown-index}
    s.saveimg_popFormat   =  [1];     % image-format {pulldown-index}
    s.saveimg_popViewType =  [2];     % view-type {pulldown-index}; (1)current view; (2) all views
    s.saveimg_edCropTol   =  '20';     % crop-tolerance (in pixel) applies only if [saveimg_rdCrop] is 1
    s.saveimg_rdHideCbar  =  [1];     % hide colorbar {0,1}
    s.saveimg_rdCrop      =  [1];     % crop image {0,1}
    xvol3d('saveimg',s,'closeGUI',1 ); % cmd to save image(s) keep GUI open
end
