function [ data ] = bruker_freqimage( data )
% data = bruker_freqimage( data )
% kspace -> image
% Converts a 4D cartesian kspace-matrix to an image matrix, 
% does: fftshifts for setting the AC-Value to the correct position and back
% after 4D-Fouriertransformation
% 
% IN:
%   data: ONE 4D-Frame in kspace, (singleton dimensions at the end are allowed)
%
% OUT:
%   data: ONE 4D-Frame in Image-space

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2012
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: bruker_freqimage.m,v 1.1 2012/09/11 14:22:10 pfre Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d=zeros(5,1);
for i=1:5
    d(i)=size(data,i+4); % saves dim5 to 10 to d
end
if prod(d(1:5)) == 1
    data=fftshift(fftshift(fftshift(fftshift( fftn(ifftshift(ifftshift(ifftshift(ifftshift(data,4),3),2),1))  ,4),3),2),1);
else
    error('frequimage only allows 4-dimensional objects !')
end

end

