function bigImage = montage(varargin)
%MONTAGE Display multiple image frames as rectangular montage.
%   MONTAGE(FILENAMES) displays a montage of the images specified in
%   FILENAMES. FILENAMES is an N-by-1 or 1-by-N cell array of file name
%   strings. If the files are not in the current directory or in a
%   directory on the MATLAB path, specify the full pathname. (See the
%   IMREAD command for more information.) If one or more of the image files
%   contains an indexed image, MONTAGE uses the colormap from the first
%   indexed image file. 
%
%   By default, MONTAGE arranges the images so that they roughly form a
%   square, but you can specify other arrangments using the 'Size'
%   parameter (see below).  MONTAGE creates a single image object to
%   display the images.
%
%   MONTAGE(I) displays a montage of all the frames of a multiframe image
%   array I. I can be a sequence of binary, grayscale, or truecolor images.
%   A binary or grayscale image sequence must be an M-by-N-by-1-by-K array.
%   A truecolor image sequence must be an M-by-N-by-3-by-K array.
%
%   MONTAGE(X,MAP) displays all the frames of the indexed image array X,
%   using the colormap MAP for all frames. X is an M-by-N-by-1-by-K array.
%
%   MONTAGE(..., PARAM1, VALUE1, PARAM2, VALUE2, ...) returns a customized
%   display of an image montage, depending on the values of the optional
%   parameter/value pairs. See Parameters below. Parameter names can be
%   abbreviated, and case does not matter. 
%   
%   H = MONTAGE(...) returns the handle of the single image object which
%   contains all the frames displayed.
%
%   Parameters
%   ----------
%   'Size'         A 2-element vector, [NROWS NCOLS], specifying the number
%                  of rows and columns in the montage. Use NaNs to have 
%                  MONTAGE calculate the size in a particular dimension in
%                  a way that includes all the images in the montage. For
%                  example, if 'Size' is [2 NaN], MONTAGE creates a montage
%                  with 2 rows and the number of columns necessary to
%                  include all of the images.  MONTAGE displays the images
%                  horizontally across columns.
%
%                  Default: MONTAGE calculates the rows and columns so the
%                  images in the montage roughly form a square.
%
%   'Indices'      A numeric array that specifies which frames MONTAGE
%                  includes in the montage. MONTAGE interprets the values
%                  as indices into array I or cell array FILENAMES.  For
%                  example, to create a montage of the first four frames in
%                  I, use this syntax: 
%  
%                  montage(I,'Indices',1:4);
%
%                  Default: 1:K, where K is the total number of frames or
%                  image files.
%
%   'DisplayRange' A 1-by-2 vector, [LOW HIGH], that adjusts the display
%                  range of the images in the image array. The images must
%                  must be grayscale images. The value LOW (and any value
%                  less than LOW) displays as black, the value HIGH (and
%                  any value greater than HIGH) displays as white. If you
%                  specify an empty matrix ([]), MONTAGE uses the minimum
%                  and maximum values of the images to be displayed in the
%                  montage as specified by 'Indices'. For example, if
%                  'Indices' is 1:K and the 'Display Range' is set to [],
%                  MONTAGE displays the minimum value in of the image array
%                  (min(I(:)) as black, and displays the maximum value 
%                  (max(I(:)) as white.
%
%                  Default: Range of the datatype of the image array.
%
%   Class Support
%   -------------  
%   A grayscale image array can be uint8, logical, uint16, int16, single,
%   or double. An indexed image array can be logical, uint8, uint16,
%   single, or double. MAP must be double. A truecolor image array can
%   be uint8, uint16, single, or double. The output is a handle to the
%   image object produced by MONTAGE.
%
%   Example 1
%   ---------
%   This example creates a montage from a series of images in ten files.
%   The montage has two rows and five columns.  Use the DisplayRange
%   parameter to highlight structures in the image.
%
%       fileFolder = fullfile(matlabroot,'toolbox','images','imdemos');
%       dirOutput = dir(fullfile(fileFolder,'AT3_1m4_*.tif'));
%       fileNames = {dirOutput.name}'
%       montage(fileNames, 'Size', [2 5]);
%
%       figure, montage(fileNames, 'Size', [2 5], ...
%       'DisplayRange', [75 200]);
%
%   Example 2
%   ---------
%   This example shows you how to customize the number of images in the
%   montage.
%
%       % Create a default montage.
%       load mri
%       montage(D, map)
%
%       % Create a new montage containing only the first 9 images.
%       figure
%       montage(D, map, 'Indices', 1:9);
%
%   See also IMMOVIE, IMSHOW, IMPLAY.

%   Copyright 1993-2007 The MathWorks, Inc.
%   $Revision: 1.1.8.8 $  $Date: 2007/06/04 21:11:07 $

[I,cmap,mSize,indices,displayRange] = parse_inputs(varargin{:});

if isempty(indices) || isempty(I)
    hh = imshow([]);
    if nargout > 0
        h = hh;
    end
    return;
end

% Function Scope
nFrames = numel(indices);
nRows = size(I,1);
nCols = size(I,2);

montageSize = calculateMontageSize(mSize);

bigImage = createMontageImage;

% if isempty(cmap)
%     if isempty(displayRange)
%         num = numel(I(:,:,:,indices));
%         displayRange(1) = min(reshape(I(:,:,:,indices),[1 num]));
%         displayRange(2) = max(reshape(I(:,:,:,indices),[1 num]));
%     end
%     hh = imshow(bigImage, displayRange);
% else
%     hh = imshow(bigImage,cmap);
% end
% 
% if nargout > 0
%     h = hh;
% end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function montageSize = calculateMontageSize(mSize)

        if isempty(mSize) || all(isnan(mSize))
            %Calculate montageSize for the user
            
            % Estimate nMontageColumns and nMontageRows given the desired
            % ratio of Columns to Rows to be one (square montage).
            aspectRatio = 1;
            montageCols = sqrt(aspectRatio * nRows * nFrames / nCols);

            % Make sure montage rows and columns are integers. The order in
            % the adjustment matters because the montage image is created
            % horizontally across columns.
            montageCols = ceil(montageCols);
            montageRows = ceil(nFrames / montageCols);
            montageSize = [montageRows montageCols];
        
        elseif any(isnan(mSize))
            montageSize = mSize;
            nanIdx = isnan(mSize);
            montageSize(nanIdx) = ceil(nFrames / mSize(~nanIdx));

        elseif prod(mSize) < nFrames
            eid = sprintf('Images:%s:sizeTooSmall', mfilename);
            error(eid, ...
                  'SIZE must be big enough to include all frames in I.');

        else
            montageSize = mSize;
        end

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function b = createMontageImage

        nMontageRows = montageSize(1);
        nMontageCols = montageSize(2);
        nBands = size(I, 3);

        sizeOfBigImage = [nMontageRows*nRows nMontageCols*nCols nBands 1];
        if islogical(I)
            b = false(sizeOfBigImage);
        else
            b = zeros(sizeOfBigImage, class(I));
        end
        
        rows = 1 : nRows;
        cols = 1 : nCols;
        k = 1;

        for i = 0 : nMontageRows-1
            for j = 0 : nMontageCols-1,
                if k <= nFrames
                    b(rows + i * nRows, cols + j * nCols, :) = ...
                        I(:,:,:,indices(k));
                else
                    return;
                end
                k = k + 1;
            end
        end

    end

end %MONTAGE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [I,cmap,montageSize,idxs,displayRange] = parse_inputs(varargin)

iptchecknargin(1, 8, nargin, mfilename);

% initialize variables
cmap = [];
montageSize = [];

charStart = find(cellfun('isclass', varargin, 'char'));

if iscell(varargin{1})
    %MONTAGE(FILENAMES.,..)
    [I,cmap] = getImagesFromFiles(varargin{1});
    
else
    %MONTAGE(I,...) or MONTAGE(X,MAP,...)
    I = varargin{1};
    iptcheckinput(varargin{1}, ...
        {'uint8' 'double' 'uint16' 'logical' 'single' 'int16'}, {}, ...
        mfilename, 'I, BW, or RGB', 1);
end

nframes = size(I,4);
displayRange = getrangefromclass(I);
idxs = 1:nframes;

if isempty(charStart)
    %MONTAGE(FILENAMES), MONTAGE(I) or MONTAGE(X,MAP)
    if nargin == 2
        %MONTAGE(X,MAP)
        cmap = validateColormapSyntax(I,varargin{2});
    end
    return;
end

charStart = charStart(1);

if charStart == 3
    %MONTAGE(X,MAP,Param1,Value1,...)
    cmap = validateColormapSyntax(I,varargin{2});
end

paramStrings = {'Size', 'Indices', 'DisplayRange'};
    
for k = charStart:2:nargin

    param = lower(varargin{k});
    inputStr = iptcheckstrs(param, paramStrings, mfilename, 'PARAM', k);
    valueIdx = k + 1;
    if valueIdx > nargin
        eid = sprintf('Images:%s:missingParameterValue', mfilename);
        error(eid, ...
            'Parameter ''%s'' must be followed by a value.', ...
            inputStr);
    end

    switch (inputStr)
        case 'Size'
            montageSize = varargin{valueIdx};
            iptcheckinput(montageSize,{'numeric'},...
                {'vector','positive'}, ...
                mfilename, 'Size', valueIdx);
            if numel(montageSize) ~= 2
                eid = sprintf('Images:%s:invalidSize',mfilename);
                error(eid, 'Size must be a 2-element vector.');
            end

            montageSize = double(montageSize);

        case 'Indices'
            idxs = varargin{valueIdx};
            iptcheckinput(idxs, {'numeric'},...
                {'vector','integer','nonnan'}, ...
                mfilename, 'Indices', valueIdx);

            invalidIdxs = ~isempty(idxs) && ...
                any(idxs < 1) || ...
                any(idxs > nframes);

            if invalidIdxs
                eid = sprintf('Images:%s:invalidIndices',mfilename);
                error(eid, ...
                    'An index in INDICES cannot be less than 1 %s', ...
                    'or greater than the number of frames in I.');
            end

            idxs = double(idxs);

        case 'DisplayRange'
            displayRange = varargin{valueIdx};
            displayRange = checkDisplayRange(displayRange, mfilename);

    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cmap = validateColormapSyntax(I,cmap)

if isa(I,'int16')
    eid = sprintf('Images:%s:invalidIndexedImage',mfilename);
    error(eid, 'An indexed image can be uint8, uint16, %s', ...
        'double, single, or logical.');
end

iptcheckinput(cmap,{'double'},{},mfilename,'MAP',1);

if size(cmap,1) == 1 && prod(cmap) == numel(I)
    % MONTAGE(D,[M N P]) OBSOLETE
    eid = sprintf('Images:%s:obsoleteSyntax',mfilename);
    error(eid, ...
        'MONTAGE(D,[M N P]) is an obsolete syntax.\n%s', ...
        'Use multidimensional arrays to represent multiframe images.');
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [I, map] = getImagesFromFiles(fileNames)

if isempty(fileNames)
    eid = sprintf('Images:%s:invalidType', mfilename);
    msg = 'FILENAMES must be a cell array of strings.';
    error(eid, msg);
end
    
nframes = length(fileNames);
 
[img, map] = getImageFromFile(fileNames{1}, mfilename);
classImg = class(img);
sizeImg = size(img);

if length(sizeImg) > 2 && sizeImg(3) == 3
    nbands = 3;
else
    nbands = 1;
end
    
sizeImageArray = [sizeImg(1) sizeImg(2) nbands nframes]; 
if islogical(img)
    I = false(sizeImageArray);
else
    I = zeros(sizeImageArray, classImg);
end

I(:,:,:,1) = img;

for k = 2 : nframes
    [img,tempmap] = getImageFromFile(fileNames{k}, mfilename);
    
    if ~isequal(size(img),sizeImg)
        eid = sprintf('Images:%s:imagesNotSameSize', mfilename);
        error(eid, ...
            'FILENAMES must contain images that are the same size.');
    end
    
    if ~strcmp(class(img),classImg)
        eid = sprintf('Images:%s:imagesNotSameClass', mfilename);
        error(eid, ...
            'FILENAMES must contain images that have the same class.');
    end

    if isempty(map) && ~isempty(tempmap)
        map = tempmap;
    end
    I(:,:,:,k) = img;
end
end