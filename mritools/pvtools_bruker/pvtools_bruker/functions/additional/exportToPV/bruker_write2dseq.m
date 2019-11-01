function [VisuCoreData]=bruker_write2dseq( filename,Visu,data )
% this function is called by bruker_writeImage
%
% Out:
%   VisuCoreData: type: struct -  contains VisuCoreDataMax and VisuCoreDataMin
%
% IN:
%   data: your image-matrix with (dim1, dim2, dim3, dim4, Frames)
%   filename: type: string, path incl. name where to write
%   Visu: a struct out of some important parameters for writing the image
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2012
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: bruker_write2dseq.m,v 1.1 2012/09/11 14:22:10 pfre Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Parse arguments
test{1}=Visu;
all_here = bruker_requires(test, {'Visu', 'VisuCoreWordType', 'VisuCoreByteOrder', 'VisuCoreDataSlope', 'VisuCoreDataOffs'});
if ~all_here
   error('Not enough parameters in the Visu struct.') 
end

%% Remap and convert parameters
VisuCoreWordType=Visu.VisuCoreWordType;
VisuCoreByteOrder=Visu.VisuCoreByteOrder;
VisuCoreSize=[size(data,1), size(data,2), size(data,3), size(data,4)];
VisuCoreDataSlope=Visu.VisuCoreDataSlope;
VisuCoreDataOffs=Visu.VisuCoreDataOffs;


switch(VisuCoreWordType)
    case ('_32BIT_SGN_INT')
        format='int32';
        round_type='round';
    case ('_16BIT_SGN_INT')
        format='int16';
        round_type='round';
    case ('_32BIT_FLOAT')
        format='float32';
        round_type='single';
    case('_8BIT_UNSGN_INT')
        format='uint8';
        round_type='round';
    otherwise
        error('Data-Format not correct specified!')
end

%transform the machinecode-format to matlab-format (=endian)
switch(VisuCoreByteOrder)
    case ('littleEndian')
        endian='l';
    case ('bigEndian')
        endian='b';
    otherwise 
        error('MachineCode-Format not correct specified!')
end

%% Convert to one FrameGroupDim
dims=size(data);
if length(dims) >= 5
    data=reshape(data, [VisuCoreSize, prod(dims(5:end))]);
end

%% Split real and imaginary
if ~isreal(data)
   data(:,:,:,:,:,2)=imag(data);
   data(:,:,:,:,:,1)=real(data(:,:,:,:,:,1));
   data=reshape(data, [size(data,1), size(data,2), size(data,3), size(data,4), size(data,5)*2]);
end
    

%% Un-Mapping data
% read in: to get the real values, we have to multiply with the slope-factor and
% add the offset to the data 
% => now we have to do the oposite
offset = repmat(VisuCoreDataOffs',[prod(VisuCoreSize),1]);
offset = reshape(offset,size(data));
data=data-offset;
slope = repmat(VisuCoreDataSlope',[prod(VisuCoreSize),1]);
slope = reshape(slope,size(data));
data=data./slope;

%% Round:
if strcmp(round_type, 'round')
    data=round(data);
elseif strcmp(round_type, 'single')
    data=single(data);
end

%% Generate Mins and Maxs
for i=1:size(data,5)
    VisuCoreData.VisuCoreDataMax(i)=max(max(max(max(data(:,:,:,:,i)))));
    VisuCoreData.VisuCoreDataMin(i)=min(min(min(min(data(:,:,:,:,i)))));
end

%% Write Process:
% Opening output file
try
    FileID=fopen(filename,'wb');
catch
    FileID = -1;
end
if FileID == -1
    error('Cannot create 2dseq file. Problem opening file %s.',filename);
end

% Writing all data to file
data=reshape(data,numel(data),1);

fwrite(FileID,data,format,0,endian);

% Closing input file
fclose(FileID);

end

