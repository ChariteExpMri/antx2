
function fiout=rimg2nii(in,gui )
%%  convert analyze2niffti with empty(GUI) or path/FPfile-INPUT
% fiout=rimg2nii(in,gui )
%% INPUTS
% in: empty [],path <string> or   fullpathfilename of imag(s) <string/cell>
% gui: <0|1> with GUI for selection of files (empty: open GUI)
%    
%% OUTPUTS
% fiout: cell with FPlist of nifitFiles
%% no path defined
% rimg2nii :            GUI for path, GUI for imgs
% rimg2nii([],1)       GUI for path, GUI for imgs
% rimg2nii([],0)       GUI for path,  allIMG in path
%% with defined path
% rimg2nii(pwd,0)  ; pathis defined, allIMG in path
% rimg2nii(pwd,1)  ; pathis defined, GUI for imgs
%% with fullpath-files defined (as string or cell)  !! use cell for multiple files!!
%  rimg2nii('o:\harms1\harmsStaircaseTrial\lesionMasks\analyze\20150505SM09_lesion_total_mask.img') 
%  rimg2nii({'o:\harms1\harmsStaircaseTrial\lesionMasks\analyze\20150505SM09_lesion_total_mask.img'}) 
%
% z={ 'o:\harms1\harmsStaircaseTrial\lesionMasks\analyze\20150505SM09_lesion_total_mask.img'
%      'o:\harms1\harmsStaircaseTrial\lesionMasks\analyze\20150507Sm25_lesion_total_mask.im'}
% rimg2nii(z)    ; 
%% output
% e=rimg2nii(pwd,0); %all files in pwd converted...output is a cell with all nifftiFiles

% in=pwd
% gui=0
% in=[]

%% check INPUTS

if exist('in')   ==0; in=[]; end
if exist('gui')==0; gui=1; end

%% GUI/inputs

if isempty(in)
    in= uigetdir(pwd,'selectFolder with img/hdr');
    if in==0; return; end
end

t=[];
if iscell(in) %in
    t=in;
else %one file or dir
   if exist(in)==7 %is a DIRECTORY
       if gui==0
           [t,sts] = spm_select('FPList',in,'.*.img$');
           t=cellstr(t);
       else  %USERSELECTION
           [t,sts] = spm_select(inf,'any','select analyzeData','',in,'.*.img$',1);
           t=cellstr(t);
       end
   else
       t=cellstr(in);
   end
end


if isempty(t); return; end


%% conversion
% return
 t=t(:);  
fiout=[];
for i=1:length(t)
    file=t{i};
    [ha a]=rgetnii(file );
    [pa fi ext]=fileparts(file);
    fileout=fullfile(pa,[fi,'.nii']);
    fiout{i,1}=rsavenii(fileout,ha,a);
end


% if isempty(in)
%     pa= uigetdir(pwd,'selectFolder with img/hdr')
%     [t,sts] = spm_select(inf,'any','select analyzeData','',pa,'.*.img',1)
%      t=cellstr(t);
% else
%     t=in;
% end






