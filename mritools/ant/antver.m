
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
% 
%
%
%
%
%
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














