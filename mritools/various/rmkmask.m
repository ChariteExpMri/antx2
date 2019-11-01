

function [fileout h d ]=rmkmask(file,threshoperation, val1, val0, dowritefile )
%% make mask , suffixes '_msk' if written to disk
% [fileout h d ]=rmkmask(file,threshoperation, val1, val0, dowritefile )
%% In
% file: niftifile
% threshoperation: string (operation&value) , e.g  '>0' ,'>=1.24'
% val1: value to replace trueValues (ones)   , e.g 3, 1000...
% val0: value to replace falseValues (zeros)  , e.g nan, inf..-1000
% dowritefile  : [0,1]..no/jes
%% out:
% h, d  ..header, data
%% example
% [fileout h d ]=rmkmask('T2brain.nii','>0',[],[],1); %write
% [fileout h d ]=rmkmask('T2brain.nii','>0',[],[],0); %doNotwrite
% [fileout h d ]=rmkmask('T2brain.nii','>0', 5, nan, 1 ); %set true=5,false=nan
% [fileout h d ]=rmkmask('T2brain.nii','==0', 5, nan, 1 ); reverse

% file  ='T2brain.nii';
% threshoperation='>0';


ha=spm_vol(file);
a=(spm_read_vols(ha));

str=['a2=single(a' threshoperation ');'];
eval(str);

if ~exist('val1','var'); val1=1; end
if ~exist('val0','var'); val0=0; end
if isempty(val1);  val1=1; end
if isempty(val0);  val0=0; end


d=zeros(size(a2));
d(a2==1)=val1;
d(a2==0)=val0;




[pa fi ext]= fileparts(file);
if isempty(pa)
    pa=pwd;
end
% fileout=fullfile(pa, [  fi '_msk' ext ]);
fileout=fullfile(pa, [ 'msk_' fi  ext ]);
%     [num2str(val2) num2str(val1)]

h=ha;
h.fname=fileout;
h.dt=[16 0];
h.descrip=['mask '   [num2str(val0) '-' num2str(val1)] ];

if ~exist('dowritefile','var'); dowritefile=0; end
if dowritefile==1
    h=spm_create_vol(h);
    h=spm_write_vol(h,  d);
end













