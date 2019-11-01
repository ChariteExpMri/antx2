



%% get path and struct with FPlinks to ANT and TPMs in refspace
%  [pathx s]=antpath
% antpath('antpath'): display the ant path

function [pathx s]=antpath(varargin)

if nargin>1
    if strcmp(varargin{1},'antpath')
       disp_antpath
    end
end


pathx=fileparts(mfilename('fullpath'));
s.refpa=fullfile(pathx, 'templateBerlin_hres');

s.refpa='MUST_BE_DEFINED';

s.refTPM={...
    fullfile(s.refpa,'_b1grey.nii')
    fullfile(s.refpa,'_b2white.nii')
    fullfile(s.refpa,'_b3csf.nii')
  };
s.ano       =fullfile(s.refpa,'ANO.nii');
s.avg       =fullfile(s.refpa,'AVGT.nii');
s.fib       =fullfile(s.refpa,'FIBT.nii');
s.refsample =fullfile(s.refpa,'_sample.nii');
s.gwc       =fullfile(s.refpa,'GWC.nii');

function disp_antpath
if exist('arg')
    pathx=fileparts(mfilename('fullpath'));
  explorer(pathx);  
end



