

%%  open a scripts-GUI with a general collection of scripts 
% copy and modify scripts according your data
% ===============================================

function scripts_collection()

%% ===============================================

scripts={...
    'sc_xrename.m'
    'sc_register_to_standardspace.m'
    'sc_transformimage_exportfile.m'
    'sc_checkregistrationHTML.m'
    'sc_getantomicalLabels.m'
%     'VWscript_twosampleStat_simple.m'
%     'VWscript_MakeSummary_simple.m'
%     'VWscript_twosampleStat_severalimages.m'
%     'VWscript_MakeSummary_severalimages.m'
%     'VWscript_twosampleStat_severalimages_severalgroups.m'
%     'VWscript_MakeSummary_severalimages_severalgroups.m'
    };
scripts_gui([],'figpos',[.3 .2 .4 .4], 'pos',[0 0 1 1],'name','scripts: general','closefig',1,'scripts',scripts)
% scripts_gui(gcf, 'pos',[0 0 1 1],'name','scripts: voxelwise statistic','closefig',1,'scripts',scripts)
%% ===============================================
