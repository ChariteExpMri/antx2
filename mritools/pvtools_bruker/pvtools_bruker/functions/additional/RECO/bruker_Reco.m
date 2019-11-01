function [ data ] = bruker_Reco( recopart, data, Reco, varargin )
% [ data ] = bruker_Reco( recopart, data, Reco, ['RECO_Parametername', ParameterValues], ['RECO_Parametername2', ParameterValues2], ... )
% This function performs the steps of a reco based on the Bruker reco parameters.
% Normally you insert to this function the Reco parameter struct and overwrite some variables with additional arguments.
% This function also keeps the precision.
%
% E.g. [ data ] = bruker_Reco( 'all' , data, Reco, 'RECO_ft_size', [512; 512],  'RECO_size', [128; 128], 'RECO_offset', [192 192; 192 192]);
% The additonal arguments will overwrite the Reco parameters.
%
% IN:
%   recopart: There are some recosteps, you can choose the steps with the recopart variable:
%           recopart can be a string or a cell array with multiple strings.
%           Your options:
%           'quadrature': uses RECO_qopts to set the correct phase to use the FT
%                         required parameters: RECO_qopts
%           'phase_rotate': in some cases it is necessary to shift the image. This option adds a phase offset to the frequency data to do this,
%                           therefore it uses the RECO_rotate variable. This method is recommended, because it also supportd subpixel shifts.
%                         required parameters: RECO_rotate
%           'zero_filling': Performs zero-filling.
%                         required parameters: RECO_ft_size and signal_position
%           'FT': The Fourier transformation
%                         required parameters: RECO_ft_mode
%           'image_rotate': in some cases it is necessarry to shift the image. This option shifts the image data to do this,
%                           therefore it uses the RECO_rotate variable.
%                         required parameters: RECO_rotate
%           'cutoff': reduces the size of the image. This is often used after zero filling and FT. 
%                         required parameters: RECO_size, RECO_offset
%           'sumOfSquares': computes the sum of squares of the images from each receive channel.
%                         required parameters: none
%           'transposition': generates the transposition.
%                         required parameters: RECO_transposition
%           'all' : equivalent to recopart={'quadrature', 'phase_rotate', 'zero_filling', 'FT', 'cutoff', 'sumOfSquares', 'transposition'};
%                         required parameters: all listed above
%
%   data: Your standard 7-dimensional cartesian k-space-Matrix
%   varargin: You can add the Reco-parametername as string, followed by the value you want to set. Take a look at the example above.
%
% OUT:
%   data: your datamatrix with 7-dimensions
%
%
%   Parameters:
%   ------------
%       
%    RECO_qopts - cellarray with string. This parameter determines the quadrature options that will be applied to the data in each dimension.
%        The possible allowed values are:
%        •  NO_QOPTS - meaning is obvious.
%        •  COMPLEX_CONJUGATE - is the normal complex conjugate in which the imaginary component of each complex number is negated.
%                             - implies that every second complex point will be QUAD_NEGATION negated.
%        •  CONJ_AND_QNEG - combines both of the preceding two options. This will have the effect of alternately negating the real and imaginary
%                           component of the complex data points.
%        The default quadrature options are:
%        RECO_qopts{1} = 'QUAD_NEGATION' if AQ_mod = 'qseq',
%        RECO_qopts{1} = 'CONJ_AND_QNEG' if AQ_mod = 'qsim',
%        RECO_qopts{1}) = 'NO_QOPTS' otherwise.
%        i > 1 -> RECO_qopts{i} = 'NO_QOPTS'.
%
%     RECO_rotate - double array This parameter specifies a ‘roll’ of the data row which is carried out after the Fourier transformation 
%         and before the reduction implied by the RECO_size and RECO_offset parameters. This will shift all points
%         in the data row towards the end of the row. Those points that ‘fall off’ the end will be reinserted at the start. This parameter must
%         satisfy the relationship 0 ≤ RECO_rotate(i) < 1.
%         If the user enters a value for this parameter which is greater than 1 and less than RECO_ft_size(i), the value for the parameter
%         will be corrected by dividing the input by RECO_ft_size(i).
%
%     RECO_ft_size - int array. This array contains the sizes of the complex data matrix in each direction after the FT but before it is output. 
%         The following two conditions must be satisfied:
%         if i = 1 -> RECO_ft_size(i) ≥ ACQ_size(i)/2 
%         otherwise -> RECO_ft_size(i) ≥ ACQ_size(i)  and RECO_ft_size(i) = 2^n .
%         If FT processing is being done in the i-th dimension and if RECO_ft_size(i) ≠ ACQ_size(i)/2 if i = 0, RECO_ft_size(i) ≥ ACQ_size(i) otherwise, 
%         then zero-filling will be performed to expand the input dataset to the specified size.
%
%     signal_position - column-vektor with NumberOfDimensions elements (maximum: 4) between 0 and 1. It defines the position of your data between the zeros. 
%          0 means it's at the start of the line, and 1 means the data is at the end of the line. Default is a symmetric, means only values of 0.5
%
%     RECO_size - int array. This array contains the sizes of the data matrix in each direction after output from the reconstruction. 
%         This parameter will specify the resolution of the image matrix in the reconstructed images. 
%         The following conditions must be satisfied:
%         RECO_ft_size(i) ≥ RECO_size(i) > 0.
%         Reducing the output size will also significantly reduce the required reconstruction time. Reducing the output size in the first 
%         direction will reduce the memory requirements for the reconstruction.
%
%     RECO_offset - int array. When RECO_ft_size(i) ≠ RECO_size(i) the parameter RECO_size(i) determines the length of the output data row. 
%         The parameter RECO_offset(i,j) gives the starting point of the output for all rows in the i-th direction for the j-th image. 
%         This must be a two dimensional array since the desired offsets can change from one image to the next. The frequency offsets in a
%         standard multi-slice experiment are a typical example. The following conditions must be satisfied:
%         RECO_ft_size(i) > RECO_offset(i,j) ≥ 0 and
%         RECO_ft_size(i) ≥ RECO_offset(i,j) + RECO_size(i)
%
%     RECO_ft_mode - defined string. This parameter determines the type of FT to be performed in each direction.
%         The allowed values for this parameter are:
%         •  NO_FT - meaning is obvious.
%         •  COMPLEX_FT - means that the input data is treated as complex. The results
%            will be complex.
%         •  COMPLEX_IFT - means that the input data is treated as complex and an inverse Fourier transformation is performed.
%         The default value for the FT mode is: RECO_ft_mode{i} = 'COMPLEX_FT', if i > 0 or AQ_mod = 'qsim'.
%
%     RECO_transposition - array. This parameter can be used to transpose the final image matrix for each object during the reconstruction. 
%         The following conditions must be satisfied:
%         0 ≤ RECO_transposition(i) ≤ ACQ_dim, 0 ≤ i ≤ NI.
%         A value of 0 (zero) implies that no transposition is desired. A value of 1 implies transposition of the first and 
%         second (read and phase) directions. A value of 2 implies transposition of the second and third (phase and slice) directions. 
%         A value of ACQ_dim implies transposition of the first and last directions. 
%         This parameter is ignored for all setup pipelines (e.g. GSP, GS Auto etc.). It will be forced to the value 0 (zero) if ACQ_dim = 1.
%         Please note that the value of this parameter does not affect the interpretation of other reconstruction parameters. 
%         For example, the entries in the output parameter RECO_fov are not reordered to reflect the transposition. 
%         Also, the values of all other RECO parameters (RECO_ft_size, RECO_size, etc.) refer to the non-transposed data ordering. 
%         When the image processing parameters (the D3 class) are written to disk at the end of the reconstruction they are filled in
%         so as to describe the transposed image matrix.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2013
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: bruker_Reco.m,v 1.4 2013/07/05 12:56:02 haas Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% Calculate some necessary variables:
dims=[size(data,1), size(data,2), size(data,3), size(data,4)];
for i=1:4
    if dims(i)>1
        dimnumber=i;
    end
end
NINR=size(data,6)*size(data,7);

%% parse Input-Variables 
% needed in reco_qopts
[varargin, RECO_qopts] =bruker_addParamValue(varargin, 'RECO_qopts', '@(x) 1', []);
if ~isempty(RECO_qopts), Reco.RECO_qopts=RECO_qopts; end

% reco_x_rotate
[varargin, RECO_rotate] =bruker_addParamValue(varargin, 'RECO_rotate', '@(x) isnumeric(x)', []);
if ~isempty(RECO_rotate), Reco.RECO_rotate=RECO_rotate; end

% nedded in reco_zero_filling
[varargin, RECO_ft_size] =bruker_addParamValue(varargin, 'RECO_ft_size', '@(x) isnumeric(x)', []);
[varargin, RECO_offset] =bruker_addParamValue(varargin, 'RECO_offset', '@(x) isnumeric(x)', []);
[varargin, RECO_size] =bruker_addParamValue(varargin, 'RECO_size', '@(x) isnumeric(x)', []);
[varargin, signal_position] =bruker_addParamValue(varargin, 'signal_position', '@(x) isnumeric(x)', []);
if isempty(signal_position), signal_position=ones(dimnumber,1)*0.5; end 
if ~isempty(RECO_ft_size), Reco.RECO_ft_size=RECO_ft_size; end
if ~isempty(RECO_offset), Reco.RECO_offset=RECO_offset; end
if ~isempty(RECO_size), Reco.RECO_size=RECO_size; end

% reco_ft
[varargin, RECO_ft_mode] =bruker_addParamValue(varargin, 'RECO_ft_mode', '@(x) ischar(x)', []);
if ~isempty(RECO_ft_mode), Reco.RECO_ft_mode=RECO_ft_mode; end

% RECO_transposition
[varargin, RECO_transposition] =bruker_addParamValue(varargin, 'RECO_transposition', '@(x) isnumeric(x)', []);
if ~isempty(RECO_transposition), Reco.RECO_transposition=RECO_transposition; end

if ~isempty(varargin)
    error([varargin{1}, ' is not accepted.']);
end


%% covert some varibles

% all-option
if sum(strcmp(recopart, 'all')) >=1
    recopart={'quadrature', 'phase_rotate', 'zero_filling', 'FT', 'cutoff', 'sumOfSquares', 'transposition'};
end

% precision
precision=whos('data');
precision=precision.class;

% all transposition the same?
same_transposition=true;
for i=1:length(Reco.RECO_transposition)
    if ~isequal(Reco.RECO_transposition(i), Reco.RECO_transposition(1))
        same_transposition=false;
    end
end

% generate mapping-table: to map dim6 and dim7 to one frame/object-dimension
map=reshape(1:size(data,6)*size(data,7), [size(data,7), size(data,6)])';

% change recopart to cell
if ~iscell(recopart)
    recopart={recopart};
end

%% start processing
for part=1:length(recopart)
    switch recopart{part}
        
        %% qudarature
        case 'quadrature'
            % errorcheck:
            if isfield(Reco, 'RECO_qopts') && ischar(Reco.RECO_qopts)
                if ~( strcmp(Reco.RECO_qopts, 'COMPLEX_CONJUGATE') || strcmp(Reco.RECO_qopts, 'QUAD_NEGATION') || strcmp(Reco.RECO_qopts, 'CONJ_AND_QNEG') || strcmp(Reco.RECO_qopts, 'NO_QOPTS') )
                    error('RECO_qopts has not the correct format');
                end
            elseif isfield(Reco, 'RECO_qopts') && iscell(Reco.RECO_qopts)
                for i=1:length(Reco.RECO_qopts)
                    if ~( strcmp(Reco.RECO_qopts{i}, 'COMPLEX_CONJUGATE') || strcmp(Reco.RECO_qopts{i}, 'QUAD_NEGATION') || strcmp(Reco.RECO_qopts{i}, 'CONJ_AND_QNEG') || strcmp(Reco.RECO_qopts{i}, 'NO_QOPTS') )
                        error('RECO_qopts has not the correct format');
                    end
                end
            elseif isfield(Reco, 'RECO_qopts')
                error('RECO_qopts has not the correct format');
            end
            if isfield(Reco, 'RECO_qopts') && iscell(Reco.RECO_qopts) && ~(length(Reco.RECO_qopts)==dimnumber)
                error('RECO_qopts has not the correct format');
            elseif isfield(Reco, 'RECO_qopts') && ~(iscell(Reco.RECO_qopts)) && ~(dimnumber==1)
                error('RECO_qopts has not the correct format');
            end
            % start processing:
            for NR=1:size(data,7)
                for NI=1:size(data,6)
                    for channel=1:size(data,5)
                        [ data(:,:,:,:,channel,NI,NR) ] = reco_qopts( data(:,:,:,:,channel,NI,NR) , Reco, map(NI, NR) );
                    end   
                end
            end
        
        %% phase_rotate
        case 'phase_rotate'
            for NR=1:size(data,7)
                for NI=1:size(data,6)
                    for channel=1:size(data,5)
                        [ data(:,:,:,:,channel,NI,NR) ] = reco_phase_rotate( data(:,:,:,:,channel,NI,NR) , Reco, NI );
                    end
                end
            end
            
        %% zero-filling 
        case 'zero_filling'
            % errorcheck
            if isfield(Reco, 'RECO_ft_size') && ~( size(Reco.RECO_ft_size,2)==dimnumber && size(Reco.RECO_ft_size,1)==1 && length(size(Reco.RECO_ft_size))<=2 )
                error('RECO_ft_size has not the correct format');
            end
            if isfield(Reco, 'signal_position') && ~( size(signal_position,2)==dimnumber && size(signal_position,1)==1 && length(size(signal_position))<=2 )
                error('signal_position has not the correct format');
            end
            % init: zero-Matrix in correct precision
            newdata_dims=[1 1 1 1];
            newdata_dims(1:length(Reco.RECO_ft_size))=Reco.RECO_ft_size;           
            newdata=zeros([newdata_dims, size(data,5), size(data,6), size(data,7)], precision);
            % function-calls:
            for NR=1:size(data,7)
                for NI=1:size(data,6)
                    for channel=1:size(data,5) 
                        newdata(:,:,:,:,channel,NI,NR) = reco_zero_filling( data(:,:,:,:,channel,NI,NR) , Reco, map(NI, NR), signal_position );                       
                    end
                end
            end
            data=newdata;
            clear newdata;
            
        %% FT  
        case 'FT'
            % errorcheck:
            if isfield(Reco, 'RECO_ft_mode') && iscell(Reco.RECO_ft_mode)
                for i=1:length(Reco.RECO_ft_mode)
                    if ~( strcmp(Reco.RECO_ft_mode{i}, 'COMPLEX_FT') || strcmp(Reco.RECO_ft_mode{i}, 'COMPLEX_FFT') || strcmp(Reco.RECO_ft_mode{i}, 'COMPLEX_IFT')  || ...
                        strcmp(Reco.RECO_ft_mode{i}, 'COMPLEX_IFFT') || strcmp(Reco.RECO_ft_mode{i}, 'NO_FT') || strcmp(Reco.RECO_ft_mode{i}, 'NO_FFT') )
                    error('RECO_ft_mode has not the correct format');
                    end
                end
            elseif isfield(Reco, 'RECO_ft_mode') && ischar(Reco.RECO_ft_mode)
                if ~( strcmp(Reco.RECO_ft_mode, 'COMPLEX_FT') || strcmp(Reco.RECO_ft_mode, 'COMPLEX_FFT') || strcmp(Reco.RECO_ft_mode, 'COMPLEX_IFT')  || ...
                    strcmp(Reco.RECO_ft_mode, 'COMPLEX_IFFT') || strcmp(Reco.RECO_ft_mode, 'NO_FT') || strcmp(Reco.RECO_ft_mode, 'NO_FFT') )
                    error('RECO_ft_mode has not the correct format');
                end
            else
                error('RECO_ft_mode has not the correct format');
            end
            % start processing:
            for NR=1:size(data,7)
                for NI=1:size(data,6)
                    for channel=1:size(data,5)
                        [ data(:,:,:,:,channel,NI,NR) ] = reco_FT( data(:,:,:,:,channel,NI,NR) , Reco, map(NI, NR) );
                    end
                end
            end
            
            
        %% image_rotate
        case 'image_rotate'
            for NR=1:size(data,7)
                for NI=1:size(data,6)
                    for channel=1:size(data,5)
                        [ data(:,:,:,:,channel,NI,NR) ] = reco_image_rotate( data(:,:,:,:,channel,NI,NR) , Reco, map(NI, NR) );
                    end
                end
            end
            
        %% cutoff
        case 'cutoff'
            % errorcheck
            if isfield(Reco, 'RECO_offset') && ~( size(Reco.RECO_offset,1)==dimnumber && size(Reco.RECO_offset,2)==size(data,6) && length(size(Reco.RECO_offset))<=2 )
                error('RECO_offset has not the correct format');
            end
            if isfield(Reco, 'RECO_size') && ~( size(Reco.RECO_size,2)==dimnumber && size(Reco.RECO_size,1)==1 && length(size(Reco.RECO_size))<=2 )
                error('RECO_size has not the correct format');
            end            
            % init: zero-Matrix in correct precision
            newdata_dims=[1 1 1 1];
            newdata_dims(1:length(Reco.RECO_size))=Reco.RECO_size;
            newdata=zeros([newdata_dims, size(data,5), size(data,6), size(data,7)], precision);
            % function-calls:
            for NR=1:size(data,7)
                for NI=1:size(data,6)
                    for channel=1:size(data,5) 
                        newdata(:,:,:,:,channel,NI,NR) = reco_cutoff( data(:,:,:,:,channel,NI,NR) , Reco, NI );                       
                    end
                end
            end
            data=newdata;
            clear newdata;                
            
        %% sumOfSquares
        case 'sumOfSquares'
            for NR=1:size(data,7)
                for NI=1:size(data,6)
                    data(:,:,:,:,1,NI,NR)=reco_channel_sumOfSquares( data(:,:,:,:,:,NI,NR) );
                end
            end
            data=data(:,:,:,:,1, :, :);
            
        %% transposition
        case 'transposition'
            % errorcheck:
            if isfield(Reco, 'RECO_transposition') && ~( size(Reco.RECO_transposition,2)==size(data,6) && size(Reco.RECO_transposition,1)==1 && length(size(Reco.RECO_transposition))<=2 )
                error('RECO_transposition has not the correct format');
            end
            
            % start processing:
            
            % = special case -> speed up: do it not framwise
            if same_transposition
                if ~(exist('Reco','var') && isstruct(Reco) && isfield(Reco, 'RECO_transposition') )
                    error('RECO_transposition is missing')
                end
                % import variables:
                RECO_transposition=Reco.RECO_transposition(1);
                % calculate additional variables:

                % start process
                if RECO_transposition > 0
                    ch_dim1=mod(RECO_transposition, length(size(data(:,:,:,:,1,1,1))) )+1;
                    ch_dim2=RECO_transposition-1+1;
                    new_order=1:4;
                    new_order(ch_dim1)=ch_dim2;
                    new_order(ch_dim2)=ch_dim1;
                    data=permute(data, [new_order, 5, 6, 7]);
                end
                clear RECO_transposition;
                
             else % = normal
                 for NR=1:size(data,7)
                    for NI=1:size(data,6)   
                        for channel=1:size(data,5)
                            [ data(:,:,:,:,channel,NI,NR) ] = reco_transposition( data(:,:,:,:,channel,NI,NR) , Reco, NI );
                        end
                    end
                 end
            end
    end
end
    
end

%% reco_qopts
function frame=reco_qopts(frame, Reco, actual_framenumber)
% check input
if ~(exist('Reco','var') && isstruct(Reco) && isfield(Reco, 'RECO_qopts') )
    error('RECO_qopts is missing')
end

% import variables
RECO_qopts=Reco.RECO_qopts;

% claculate additional parameters
dims=[size(frame,1), size(frame,2), size(frame,3), size(frame,4)];

% check if the qneg-Matrix is necessary:
use_qneg=false;
if ( sum(strcmp(RECO_qopts, 'QUAD_NEGATION')) + sum(strcmp(RECO_qopts, 'CONJ_AND_QNEG')) )>=1
    use_qneg=true;
    qneg=ones(size(frame)); % Matrix containing QUAD_NEGATION multiplication matrix
end

% start preocess
for i=1:length(RECO_qopts)
   switch(RECO_qopts{i})
       case 'COMPLEX_CONJUGATE'
           frame=conj(frame);
       case 'QUAD_NEGATION'
           switch i
               case 1
                   qneg=qneg.*repmat([1, -1]', [ceil(dims(1)/2), dims(2), dims(3), dims(4)]);
               case 2
                   qneg=qneg.*repmat([1, -1], [dims(1), ceil(dims(2)/2), dims(3), dims(4)]);
               case 3
                   tmp(1,1,:)=[1,-1];
                   qneg=qneg.*repmat(tmp, [dims(1), dims(2), ceil(dims(3)/2), dims(4)]);
               case 4
                   tmp(1,1,1,:)=[1,-1];
                   qneg=qneg.*repmat(tmp, [dims(1), dims(2), dims(3), ceil(dims(4)/2)]);
           end                   
                   
       case 'CONJ_AND_QNEG'
           frame=conj(frame);
           switch i
               case 1
                   qneg=qneg.*repmat([1, -1]', [ceil(dims(1)/2), dims(2), dims(3), dims(4)]);
               case 2
                   qneg=qneg.*repmat([1, -1], [dims(1), ceil(dims(2)/2), dims(3), dims(4)]);
               case 3
                   tmp(1,1,:)=[1,-1];
                   qneg=qneg.*repmat(tmp, [dims(1), dims(2), ceil(dims(3)/2), dims(4)]);
               case 4
                   tmp(1,1,1,:)=[1,-1];
                   qneg=qneg.*repmat(tmp, [dims(1), dims(2), dims(3), ceil(dims(4)/2)]);
           end 
   end   
end

if use_qneg
    % odd dimension size (ceil() does affekt the size)
    if ~( size(qneg)==size(frame))
        qneg=qneg(1:dims(1), 1:dims(2), 1:dims(3), 1:dims(4));
    end
    frame=frame.*qneg;
end
end

%% reco_phase_rotate
function frame=reco_phase_rotate(frame, Reco, actual_framenumber)
% check input
if ~(exist('Reco','var') && isstruct(Reco) && isfield(Reco, 'RECO_rotate') )
    error('RECO_rotate is missing')
end
% import variables:
RECO_rotate=Reco.RECO_rotate(:, actual_framenumber);

% calculate additional variables
dims=[size(frame,1), size(frame,2), size(frame,3), size(frame,4)];

% start process
phase_matrix=ones(size(frame));
for index=1:length(size(frame))
    % written complete it would be:
    % 0:1/dims(index):(1-1/dims(index));
    % phase_vektor=exp(1i*2*pi*RECO_rotate(index)*dims(index)*f);
    f=1:dims(index);
    phase_vektor=exp(1i*2*pi*RECO_rotate(index)*f);
    switch index
       case 1
           phase_matrix=phase_matrix.*repmat(phase_vektor', [1, dims(2), dims(3), dims(4)]);
       case 2
           phase_matrix=phase_matrix.*repmat(phase_vektor, [dims(1), 1, dims(3), dims(4)]);
       case 3
           tmp(1,1,:)=phase_vektor;
           phase_matrix=phase_matrix.*repmat(tmp, [dims(1), dims(2), 1, dims(4)]);
       case 4
           tmp(1,1,1,:)=phase_vektor;
           phase_matrix=phase_matrix.*repmat(tmp, [dims(1), dims(2), dims(3), 1]);
    end        
   clear phase_vekor f tmp
end
frame=frame.*phase_matrix;


end

%% reco_zero_filling
function newframe=reco_zero_filling(frame, Reco, actual_framenumber, signal_position)
% check input
if ~(exist('Reco','var') && isstruct(Reco) && isfield(Reco, 'RECO_ft_size') )
    error('RECO_ft_size is missing')
end


% use function only if: Reco.RECO_ft_size is not equal to size(frame)
if ~( isequal(size(frame), Reco.RECO_ft_size ) )
    if sum(signal_position >1)>=1 || sum(signal_position < 0)>=1
        error('signal_position has to be a vektor between 0 and 1');
    end

    % import variables:
    RECO_ft_size=Reco.RECO_ft_size;

    % check if ft_size is correct:
    for i=1:length(RECO_ft_size)
%         if ~( log2(RECO_ft_size(i))-floor(log2(RECO_ft_size(i))) == 0 )
%             error('RECO_ft_size has to be only of 2^n ');
%         end
        if RECO_ft_size(i) < size(frame,i)
            error('RECO_ft_size has to be bigger than the size of your data-matrix')
        end
    end

    % calculate additional variables
    dims=[size(frame,1), size(frame,2), size(frame,3), size(frame,4)];

    % start process

    %Dimensions of frame and RECO_ft_size doesn't match? -> zerofilling
    if ~( sum( size(frame)==RECO_ft_size )==length(RECO_ft_size) )
        newframe=zeros(RECO_ft_size);
        startpos=zeros(length(RECO_ft_size),1);
        pos_ges={1, 1, 1, 1};
        for i=1:length(RECO_ft_size)
           diff=RECO_ft_size(i)-size(frame,i)+1;
           startpos(i)=fix(diff*signal_position(i)+1);
           if startpos(i)>RECO_ft_size(i)
               startpos(i)=RECO_ft_size(i);
           end
           pos_ges{i}=startpos(i):startpos(i)+dims(i)-1;
        end
        newframe(pos_ges{1}, pos_ges{2}, pos_ges{3}, pos_ges{4})=frame;
    else
        newframe=frame;
    end
    clear startpos pos_ges diff;
else
    newframe=frame;
end
end

%% reco_FT
function frame=reco_FT(frame, Reco, actual_framenumber)
% check input
if ~(exist('Reco','var') && isstruct(Reco) && isfield(Reco, 'RECO_ft_mode') )
    error('RECO_ft_mode is missing')
end

% import variables:
for i=1:4
    if size(frame,i)>1
        dimnumber=i;
    end
end

if iscell(Reco.RECO_ft_mode)
    for i=1:length(Reco.RECO_ft_mode)
        if ~strcmp(strrep(Reco.RECO_ft_mode{i},'FFT','FT'), strrep(Reco.RECO_ft_mode{1},'FFT','FT'))
           error(['It''s not allowed to use different transfomations on different Dimensions: ' Reco.RECO_ft_mode{:}]);
        end
    end
    RECO_ft_mode=Reco.RECO_ft_mode{1};
else
    RECO_ft_mode=Reco.RECO_ft_mode;
end

% start process
switch RECO_ft_mode    
    case {'COMPLEX_FT', 'COMPLEX_FFT'}
        frame=fftn(frame);
    case {'NO_FT', 'NO_FFT'}
        % do nothing
    case {'COMPLEX_IFT', 'COMPLEX_IFFT'}
        frame=ifftn(frame);
    otherwise
        error('Your RECO_ft_mode is not supported');
end
end

%% reco_cutoff
function newframe=reco_cutoff(frame, Reco, actual_framenumber)
% check input
if ~(exist('Reco','var') && isstruct(Reco) && isfield(Reco, 'RECO_size') )
    error('RECO_size is missing')
end

% use function only if: Reco.RECO_ft_size is not equal to size(frame)
if ~( isequal(size(frame), Reco.RECO_size ) )
    if ~(exist('Reco','var') && isstruct(Reco) && isfield(Reco, 'RECO_offset') )
        error('RECO_offset is missing')
    end
    if ~(exist('Reco','var') && isstruct(Reco) && isfield(Reco, 'RECO_size') )
        error('RECO_size is missing')
    end

    % import variables:
    RECO_offset=Reco.RECO_offset(:, actual_framenumber);
    RECO_size=Reco.RECO_size;

    % cut the new part with RECO_size and RECO_offset
    pos_ges={1, 1, 1, 1};
    for i=1:length(RECO_size)
        % +1 because RECO_offset starts with 0
       pos_ges{i}=RECO_offset(i)+1:RECO_offset(i)+RECO_size(i);
    end
    newframe=frame(pos_ges{1}, pos_ges{2}, pos_ges{3}, pos_ges{4});
else
    newframe=frame;
end
end

%% reco_image_rotate
function frame=reco_image_rotate(frame, Reco, actual_framenumber)
% check input
if ~(exist('Reco','var') && isstruct(Reco) && isfield(Reco, 'RECO_rotate') )
    error('RECO_rotate is missing')
end
% import variables:
RECO_rotate=Reco.RECO_rotate(:,actual_framenumber);

% start process
for i=1:length(size(frame))
   pixelshift=zeros(4,1); 
   pixelshift(i)=round(RECO_rotate(i)*size(frame,i));
   frame=circshift(frame, pixelshift);
end
end

%% channel_sumOfSquares
function newframe=reco_channel_sumOfSquares(frame, Reco, actual_framenumber)
dims=[size(frame,1), size(frame,2), size(frame,3), size(frame,4)];
newframe=zeros(dims);
for i=1:size(frame,5)
    newframe=newframe+(abs(frame(:,:,:,:,i))).^2;
end
newframe=sqrt(newframe);
end

%% reco_transposition
function frame=reco_transposition(frame, Reco, actual_framenumber)
% check input
if ~(exist('Reco','var') && isstruct(Reco) && isfield(Reco, 'RECO_transposition') )
    error('RECO_transposition is missing')
end
% import variables:
RECO_transposition=Reco.RECO_transposition(actual_framenumber);

% calculate additional variables:
dims=[size(frame,1), size(frame,2), size(frame,3), size(frame,4)];

% start process
if RECO_transposition > 0
        ch_dim1=mod(RECO_transposition, length(size(frame)) )+1;
        ch_dim2=RECO_transposition-1+1;
        new_order=1:4;
        new_order(ch_dim1)=ch_dim2;
        new_order(ch_dim2)=ch_dim1;
        frame=permute(frame, new_order);
        frame=reshape(frame, dims);
end
end
