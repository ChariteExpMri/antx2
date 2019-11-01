

function [fileout h x ]=rapplymask(file,filemsk,threshoperation, val1, val0, suffix )
%% apply maskFile to another file 
% [fileout h x ]=rapplymask(file,filemsk,threshoperation, val1, val0, suffix )
%% In
% file      : file
% filemsk   : masking file
% threshoperation: string (operation&value) , e.g  '>0' ,'>=1.24'
% val1: value to replace trueValues (ones)   , e.g 3, 1000...
% val0: value to replace falseValues (zeros)  , e.g nan, inf..-1000
% suffix: string to append ; default: '_msked'
% dowritefile  : [0,1]..no/jes
%% out:
% fileout/h/x  ..written filename/header/data
%% example
%  [fileout h x]=rapplymask('RE_rfNt2.nii','RE_rfNat.nii','>0',1,nan,'_masked');
%  [fileout h x ]=rapplymask('RE_s20150908_FK_C1M01_1_3_1.nii ','RE_msk_brain.nii','>0',1,nan,'_masked');
if 0
    
file   ='RE_rfNt2.nii'  
filemsk='RE_rfNat.nii'
threshoperation='>0'
   val0=nan 
   suffix='_masked'
   
   [fileout h d ]=rapplymask('RE_rfNt2.nii','RE_rfNat.nii','>0',1,nan,'_masked')
end



ha=spm_vol(filemsk);
a=(spm_read_vols(ha));

str=['a2=single(a' threshoperation ');'];
eval(str);


if ~exist('val1','var'); val1=1; end
if ~exist('val0','var'); val0=0; end
if ~exist('suffix','var'); suffix='_msked'; end
if isempty(val1);     val1=1; end
if isempty(val0);     val0=0; end
if isempty(suffix);   suffix='_msked'; end

d=zeros(size(a2));
d(a2==1)=val1;
d(a2==0)=val0;

%% applyMASK
hb=spm_vol(file);
b=(spm_read_vols(hb));

x=b.*d;



[pa fi ext]= fileparts(file);
if isempty(pa)
    pa=pwd;
end
% fileout=fullfile(pa, [  fi '_msk' ext ]);
fileout=fullfile(pa, [   fi suffix  ext ]);
%     [num2str(val2) num2str(val1)]

h=hb;
h.fname=fileout;
if any(isnan(unique(x(:))))
    h.dt=[16 0];
end
h.descrip=['masked '   [num2str(val0) '-' num2str(val1)] ];

% if ~exist('dowritefile','var'); dowritefile=0; end
% if dowritefile==1
    h=spm_create_vol(h);
    h=spm_write_vol(h,  x);
% end













