% <b> script to plot a brain-mask and plot fibre-connections <b>

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

% ===============================================
%        connections properties
% ===============================================
con.filenode='F:\data5\eranet_round2_statistic\DTI\result_propTresh1\eranet_connectome_6vsAll\e__diff_CTRL_vs_HR_FDR.xlsx'; %connections (xls-file from DTIstat)
con.lab.dummi=[1];
con.lab.fs=[7];
con.lab.fcol=[0  0  0];
con.lab.fhorzal=[2];
con.lab.needlevisible=[0];
con.lab.needlelength=[0];
con.lab.needlecol=[0  0  0];
con.lab.abbreviate=[0];
con.lab.abbreviationLength=[3];
con.lab.useNumbers=[1];
con.sting.dummi=[1];
con.sting.stingview=[1];
con.sting.linestyle=':';
con.sting.linewidth=[0.8];
con.sting.linecol=[0.7  0.7  0.7];
con.sting.fs=[7];
con.sting.fontbold=[1];
con.sting.fontcol=[0  0  0];
con.sting.isdebug=[0];
con.sting.radiusfac=[1.1];
con.sting.sepmax=[10];
con.sting.pointsfac=[250];
con.sting.volcenter=[1];
con.t.col1={ '0 .5 0' };
con.t.R1={ '3' };
con.t.T1={ '1' };
con.t.Lcol={ '0 0 1' };
con.t.LR={ '1' };
con.t.LT={ '1' };
con.win.nodelabel=[1];
con.win.stingview=[1];
con.win.selectAll=[1];
con.win.allnodes=[1];
con.win.alllinks=[1];
con.win.instantUpdate=[1];
con.win.selectRow=[0];
con.win.CS2RAD=[1];
con.win.CS2RADexpression='*3+.3';
con.win.linkintensity=[1];
con.win.colorlimits='-3 0 ';
con.win.linkcolormap=[64];
con.win.notused_linkcolormapString='<html> <FONT color=#08306B >&#9632;<FONT color=#0D5DA7 >&#9632;<FONT color=#3486C0 >&#9632;<FONT color=#71B2D8 >&#9632;<FONT color=#AFD1E6 >&#9632;<FONT color=#D8E7F5 >&#9632;<FONT color=#F7FBFF >&#9632;<FONT color=black>&nbsp;Blues_flip';


xvol3d('loadprop',[],'p',p,'con',con); % load mask and than connections

% xvol3d('loadprop',[],'p',p)
