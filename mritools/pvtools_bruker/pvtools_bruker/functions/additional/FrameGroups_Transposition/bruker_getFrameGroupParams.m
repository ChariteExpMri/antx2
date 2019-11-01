function [FGstruct, info]=bruker_getFrameGroupParams(Visu)
% [FGstruct, info]=bruker_getFrameGroupParams(Visu)
% generates a structmatrix that has the dimensions of the framegroups.
% every field of that matrixstruct contains one frame and the dependent
% parameters to that frame.
%
% Out:
%   FGstruct: Structmatrix e.g. FGstruct(1,3,2).VisuCoreOrientation
%       contains: multiple parameters, which belong to that frame
%   info: a cellarray with string: shows you in which matrix-dimension of
%       the struct is a framegroup
%
% IN:
%   Visu: a parameterstruct of visu-parameters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2013
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: bruker_getFrameGroupParams.m,v 1.2 2013/05/24 13:29:27 haas Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isfield(Visu, 'VisuFGOrderDesc')
    FGstruct=[]; info='VisuCoreFrameCount';
elseif size(Visu.VisuFGOrderDesc,2)==1 && Visu.VisuFGOrderDesc{5,1}==0
    FGstruct=struct();
    info{1}=Visu.VisuFGOrderDesc{2,1};
else

for i=1:size(Visu.VisuFGOrderDesc,2)
    dimlist(i)=Visu.VisuFGOrderDesc{1,i};
end

if ~(prod(dimlist)==Visu.VisuCoreFrameCount)
    error('VisuCoreFrameCount and VisuFGOrderDesc are not compatible.')
end
if length(dimlist)>10
    error('More then 10 FrameGroups are not supported')
end

% generate mapping-table:
dimmatrix_tmp=zeros(prod(dimlist),length(dimlist));
for i1=1:prod(dimlist)
    modulus=mod(i1-1,dimlist(end));
    reminder=fix((i1-1)/dimlist(end));
    dimmatrix_tmp(i1,length(dimlist))=modulus+1;
    for i2=length(dimlist)-1:-1:1
        modulus=mod(reminder,dimlist(i2));
        reminder=fix(reminder/dimlist(i2));
        dimmatrix_tmp(i1,i2)=modulus+1;
    end      
end
% convert to 10 Dims:
dimmatrix=ones(prod(dimlist),10);
dimmatrix(:,1:length(dimlist))=dimmatrix_tmp;

% write the info-strings
info=cell(length(dimlist),1);
for i=1:size(Visu.VisuFGOrderDesc,2)
    info{i}=Visu.VisuFGOrderDesc{2,i};       
end

% read DepVals
dm=dimmatrix;
clear dimmatrix;
for i_group=1:size(Visu.VisuFGOrderDesc,2)
    valstart=Visu.VisuFGOrderDesc{4,i_group};
    valcount=Visu.VisuFGOrderDesc{5,i_group};
    for i_variables=valstart+1:valcount+valstart
        paramName=Visu.VisuGroupDepVals{1,i_variables};
        paramStart=Visu.VisuGroupDepVals{2,i_variables};
        for i=1:prod(dimlist)
            actual_line=dm(i,i_group)+paramStart;
            %disp(paramName)
            %disp(actual_line);
            %disp([dm(i,1), dm(i,2), dm(i,3), dm(i,4), dm(i,5), dm(i,6), dm(i,7), dm(i,8), dm(i,9), dm(i,10)])
            if iscell(Visu.(paramName))
                FGstruct(dm(i,1), dm(i,2), dm(i,3), dm(i,4), dm(i,5), dm(i,6), dm(i,7), dm(i,8), dm(i,9), dm(i,10)).(paramName)=Visu.(paramName)(actual_line);
            else
                if size(Visu.(paramName),1)>1 % Parameters are one line for one frame
                    FGstruct(dm(i,1), dm(i,2), dm(i,3), dm(i,4), dm(i,5), dm(i,6), dm(i,7), dm(i,8), dm(i,9), dm(i,10)).(paramName)=Visu.(paramName)(actual_line,:);
                else % The parameters are all writen in one line 
                    FGstruct(dm(i,1), dm(i,2), dm(i,3), dm(i,4), dm(i,5), dm(i,6), dm(i,7), dm(i,8), dm(i,9), dm(i,10)).(paramName)=Visu.(paramName)(:,actual_line);
                end
            end
        end
    end
    
    
end
end % end: no FrameGroups
end


