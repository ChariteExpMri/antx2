

%% exist-function for multiple files/objects --if input is cell-type
%% function b=existn(ce,varargin)
% output: vector with flags as in exist.m
%% example
% q={   'O:\data\karina\dat\s2014109_02sr_1_x_x\JD.nii'
%     'O:\data\karina\dat\s20141009_03sr_1_x_x\JD.nii'
%     'O:\data\karina\dat\s20141009_05sr_1_x_x\JD.nii'}
%  b=existn(q);
 
function b=existn(ce,varargin)



if ischar(ce); ce=cellstr(ce); end

if nargin==1
    for i=1:length(ce)
        b(i,1) =exist(ce{i});
    end
elseif nargin==2
    for i=1:length(ce)
        b(i,1) =exist(ce{i},varargin{1});
    end
end