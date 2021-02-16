
%% convert coordinates to mm (from index) or to index (from mm)
% [co2 str]=convertcoord(co,h, outputmetric)
% 
% source: https://alivelearn.net/?p=1434
% co           :cordinate list [n-by-[x y z]]
% h            :spm-header
% outputmetric : the output metric  either :
%      'mm' :           co-list must be indices
%      'idx': (index)   co-list must be mm-values


function [co2 str]=convertcoord(co,h, outputmetric)

if 0
    %% convert two mm-coordinates to INDEX-coordinates
   co=[0 0 0; 2 1 1]; %mm-list
   [mm str]=convertcoord(co,h, 'idx')
   
   %% convert two INDEX-coordinates to 'mm'-coordinates  
   co=[82   127   122
       111   141   136]; %indices
   [idx str]=convertcoord(co,h, 'mm');
end



if strcmp(outputmetric,'idx')
    %% to index ---------------------------------------------------
    % ix=[0 0 0 1]*(inv(hc.mat))'
    cx = [co(:,1) co(:,2) co(:,3) ones(size(co,1),1)]*(inv(h.mat))';
    cx(:,4) = [];
    cx = round(cx);
    co2=cx;
    str='mm2idx';
elseif strcmp(outputmetric,'mm')
    %% to mm ---------------------------------------------------
    cor =  (co);
    % cor = round(co);
    mni = h.mat*[cor(:,1) cor(:,2) cor(:,3) ones(size(co,1),1)]';
    mni = mni';
    mni(:,4) = [];
    co2=mni;
    str='idx2mm';
else
    error(['outputmetric not specified,"idx" or "mm"'])
end