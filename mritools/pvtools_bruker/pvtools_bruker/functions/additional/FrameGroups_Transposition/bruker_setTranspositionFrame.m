function [ data ] = bruker_setTranspositionFrame( data, frame, Visu, numberFrame )
% [ data ] = bruker_setTranspositionFrame( data, frame, Visu, numberFrame )
% adds one frame to a dataset - considering the transposition
% 
% IN:
%   data: the image matrix stored in the ImageDataObject or generated with
%         readBruker2dseq
%   Visu: a parameterstruct of visu-parameters
%   numberFrame: the number of the Frame, which should be returned has to
%                be one single integer value
%   frame: 4-dimensional Image Matrix of one frame
%    
% OUT:
%   data: the image matrix stored in the ImageDataObject or generated with
%         readBruker2dseq 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2012
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: bruker_setTranspositionFrame.m,v 1.1 2012/09/11 14:22:10 pfre Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Check input
if ~isfield(Visu, 'VisuCoreTransposition')
    dims=size(data);
    if length(dims)>5
        data=reshape(data,[size(data,1), size(data,2), size(data,3), size(data,4), prod(dims(5:end))]);
    end
    data(:,:,:,:,numberFrame)=frame;
    data=reshape(data, dims);
else
    cellstruct{1}=Visu;
    all_here = bruker_requires(cellstruct, {'Visu','VisuCoreTransposition', 'VisuCoreSize', 'VisuCoreFrameCount', 'VisuCoreDim'});
    clear cellstruct;
    if ~all_here
        error('Some parameters are missing');
    end

    if length(size(frame))>=5
        error('Your frame has to much dimensions')
    end

    if numberFrame < 1 && numberFrame >  Visu.VisuCoreFrameCount
        error('numberFrame is not correct')
    end

    %% localize Variables
    VisuCoreSize=Visu.VisuCoreSize;
    VisuCoreTransposition=Visu.VisuCoreTransposition;
    VisuCoreDim=Visu.VisuCoreDim;

    %% Reshape
    dims=size(data);
    if length(dims)>5
        data=reshape(data,[size(data,1), size(data,2), size(data,3), size(data,4), prod(dims(5:end))]);
    end

    %% start Transposition
    if VisuCoreTransposition(numberFrame) >0  
        frame=reshape(frame, VisuCoreSize'); 
    end

    data(:,:,:,:,numberFrame)=frame;
    data=reshape(data, dims);

end
end

