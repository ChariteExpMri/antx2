
% .
% 
% #yk ANTx2
% 
%======= CHANGES ================================
% #ra 07 May 2019 (14:16:48)
% #ok new version "ANTx2"
%    - SPM-package: SPM12
%    - templates were outsourced and can be downloaded from:
%      https://drive.google.com/drive/folders/0B9o4cT_le3AhSFJRdUx3eXlyUWM
%    - linux/mac/windows
% #ra 08 May 2019 (01:34:19)
%  addedd icon panel [iconpannel4spm.m] for manual preregistration step to facilitate manual
%  registration step
% #ra 22 May 2019 (12:19:03)
%  addded: [xcoregmanu.m] - manually coregister images 
% #ra 07 Aug 2019 (14:23:20)
% initial rigid registration (xwarp3) modified for more robust registration
% [checkRegist.m]:     GUI to check registration of several images
% [getorientation.m]: GUI to examine the apriory orientation (how animal is positioned in scanner)
%  - run it without input arguments or use context menu from ANT animal listbox
%  - the respective ID/number of orientation can be used to define the "orientType" in the projectfile 
% #ra 16 Oct 2019 (03:42:04)
%  1) "create study templates"-step can be performed before running the normalization step
%    ..see Main/Create Study Templates
%  2) two new "get-orientation"-functions implemented. Functions can be used if the orientation of 
%    the native image (t2.nii) is unknown. See animal listbox context menu 
%    (2a) "examineOrientation"       #k [getorientation.m] #n using apriori rotations,.. 
%         best orientation selected via eyeballing
%    (2b) "getOrientationVia3points" #k [manuorient3points.m] #n using 3 manually tagged corresponding points in
%         source and reference image
%     --> 2b approach is easier and faster  for difficult rotations
% function modifications: uhelp, plog
% #ra 17 Oct 2019 (22:04:14)
% [xregisterCT/CTgetbrain_approach2]: added parameter "bonebrainvolume" for more robust cluster-identifaction
% #ra 29 Oct 2019 (23:28:16)
%   starting GITHUB REPO : https://github.com/pstkoch/antx2
%  modif. files [cfg_getfile2], [uhelp]
% #ra 04 Nov 2019 (11:35:28)
% set up GITHUB repository #bw https://github.com/ChariteExpMri/antx2/
% -primary checks macOS, Linux MINT
% - updated [uhelp]
% #ra 13 Nov 2019 (00:47:38) 
% [maskgenerator] added region-lection list and online link to compare selected regions
% #ra 15 Nov 2019 (02:14:16)
% [maskgenerator] added "find" region-panel
% #ra 22 Nov 2019 (11:37:49)
% [maskgenerator] added alpha-transparency slider and display number-of-rows pull down
% checked regions of new Allen2017Hikishima template
% #ra 11 Dec 2019 (14:41:37)
% [xcoreg] fix filename bug; display missing files
% [uhelp]: allows column-wise/selectionwise copying 
% #ra 07 Jan 2020 (15:40:52)
% matlab19b fix: cfg_getfiles2: data from server
% sub_atlaslabel2xls: added writetable if xlwrite not working (matlab2017 upwards issue)
% #ra 27 Jan 2020 (09:43:48)
% [xexcel2atlas.m]: create atlas from excelfile, excelfile is a modified version of the ANO.xlsx
% [sub_write2excel_nopc]: subfun: write excel file for mac/linux
% #ra 28 Jan 2020 (10:14:11)
% [xexcel2atlas.m]: added information
% #ra 31 Jan 2020 (14:07:48): 
% [xgetlabels4]: allowing readout from "other Space"
% #ra 04 Feb 2020 (18:03:15)
% rat-brain segmentation accelerated
% #ra 17 Feb 2020 (12:32:00)
% set-up pipeline for etruscian shrew
% [xcoreg]: enables elastix registration with multiple paramter files (regid&|affine&|bspline) and
% without spm-registration, (set "task" to [100])
% #ra 19 Feb 2020 (15:15:55)
% [xdraw.m]: manual drawing tool to create masks  ->>Tools/"draw mask"
% #ra 09 Mar 2020 (12:31:52)
% etrucian-shrew modified templates --> not finalized jet
% [approach_60] t2.nii to "sample"-registration: register t2.nii to another t2.nii-sample in standard space
% Par0033bspline_EM3.txt: bspline-paramter file works well with "sample"-registration
% #ra 11 Mar 2020 (17:28:49)
% [xsegmenttube]: segment several animals from the same image /tube
% [xsplittubedata]: split data-sets based on tube-segementation
% #ra 20 Mar 2020 (12:30:38)
% [case-filematrix]: export selected files from selected folders
% % #ra 14 May 2020 (14:14:07)
% [elastix_checkinstallation] addeed (extras/troubleshoot)  .. fct to check installation of elastix-program
% [uhelp.m] modified: selection color  
% [checkRegist] modified: changed image2clipboard function 
% [summary_export] added (available via context menu of "PR"-radio in ANT-main window) 
% .. export HTML-summary (ini/coreg/segm/warp) structure to exporting folder
% #ra 15 May 2020 (17:33:52)
% [setup_elastixlinux.m] modified-->solved problem: stucked installation of MRICRON 
%
%
%----- EOF
%


function antver()

% r=preadfile(which('antver.m')); r=r.all;
r=strsplit(help('antver'),char(10))';
ichanges=regexpi2(r,'#*20\d{2}.*(\d{2}:\d{2}:\d{2})' );
lastchange=r{ichanges(end)};
lastchange=regexprep(lastchange,{'#\w+ ', ').*'},{'',')'});
r=[r(1:3); {[' last modification: ' lastchange ]}  ;  r(4:end)];
uhelp(r,0, 'cursor' ,'end');
set(gcf,'NumberTitle','off', 'name', 'ANTx2 - VERSION');
% uhelp('antver.m');


if 0
    clipboard('copy', [    ['% #ra '   datestr(now,'dd mmm yyyy (HH:MM:SS)') repmat(' ',1,0) ]           ]);
    clipboard('copy', [    ['% #T '   datestr(now,'dd mmm yyyy (HH:MM:SS)') '' ]           ]);
end



return














