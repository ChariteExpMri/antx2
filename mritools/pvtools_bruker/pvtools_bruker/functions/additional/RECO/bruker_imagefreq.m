function [ data ] = bruker_imagefreq( data )
% data = bruker_imagefreq( data )
% image -> kspace
% Converts a 4D cartesian image-matrix to an kspace matrix, 
% does: fftshifts for setting the AC-Value to the correct position and back
% after 4D-Fouriertransformation
% 
% IN:
%   data: ONE 4D-frame in image-space, (singleton dimensions at the end are allowed)
%
% OUT:
%   data: ONE 4D-frame in k-space

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2012
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: bruker_imagefreq.m,v 1.1 2012/09/11 14:22:10 pfre Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d=zeros(5,1);
for i=1:5
    d(i)=size(data,i+4); % saves dim5 to 10
end
if prod(d(1:5)) == 1
    data=ifftshift(ifftshift(ifftshift(ifftshift( ifftn(fftshift(fftshift(fftshift(fftshift(data,4),3),2),1))  ,4),3),2),1);
else
    error('frequimage only allows 4-dimensional objects !')
end

end

