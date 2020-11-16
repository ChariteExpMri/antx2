function Bs = getExactBounds( bw )
% getExactBounds: get the exact boundaries (polygonal) of binary image
% sub-function: outerboundary.m and holeboundary.m
% 
% input bw - binary image
% ouput Bs - stores column (x) and row (y) coordinates of exact polygonal 
%           boundaries. Bs is a p-by-1 cell array, where p is the number of
%           (4 connected) objects and (4 connected) holes. Each cell in the
%           cell array contains a q-by-2 matrix. Each row in the matrix 
%           contains the column and row coordinates of a boundary corner. q
%           is the number of boundary corner for the corresponding region.
%           Size of Bs{i} is (1+number_of_vertices)-by-2.
%
% Comment:
% There're huge different between function bwboundaries and getExactBounds.
% The output of bwboundaries and getExactBounds may have different length.
%
% 1. bwboundaries(BW,conn,options)
% Return row (y) and column (x) coordinates of boundary pixel locations.
% Only inner boundaries are obatined.
% Parameter conn is very important for function bwboundaries. According to 
% bwboundaries.m in Matlab, 
% if conn = 4, objects are 4 connected and holes are 8 connected; 
% if conn = 8, objects are 8 connected and holes are 4 connected.
% This is to avoid topological errors.
%
% 2. getExactBounds( bw )
% Return column (x) and row (y) coordinates of the corner of boundary
% pixels.
% However, function getExactBounds don't have connectivity parameter. Both 
% objects and holes are 4 connected, since outputs are exact boundary. 
%
% Example:
%     bw = imread('bw.tif');
%     Bs = getExactBounds( bw );
% 
%     hold on
%     imshow(bw,'InitialMagnification','fit');
%     for k = 1:length(Bs)
%        plot( Bs{k}(:,1), Bs{k}(:,2), 's-g','MarkerSize',5,'LineWidth',2 );
%     end
%     hold off
% 
% Revision history:
%   Jiexian Ma, mjx0799@gmail.com, May 2020

    % initialize
    Bs = cell(0);
    % label objects using 4-connected neighborhood
    [ Label, num_object ] = bwlabel( bw, 4 );
    objs = regionprops( Label, 'Image', 'BoundingBox' );

    % get boundary of each 4-connected object, and update Bs
    for i = 1: num_object
        % one object at a time
        % B_temp is a cell & inner boundary
        B_temp = bwboundaries( (objs(i).Image)', 8 );

        % convert back to global coordinate
        for j = 1: length(B_temp)
            B_temp{j}(:,1) = B_temp{j}(:,1) + objs(i).BoundingBox(1) -0.5;  
            B_temp{j}(:,2) = B_temp{j}(:,2) + objs(i).BoundingBox(2) -0.5;
        end

        % convert B_temp (inner boundary) to B (exact boundary)
        if length(B_temp) == 1       % no holes
            B = outerboundary( B_temp(1) );
        elseif length(B_temp) > 1    % exist holes
            B = [ outerboundary( B_temp(1) ); 
                holeboundary( B_temp(2:end) ) ];
        else
            error('boundary error')
        end

        % update Bs
        Bs = [ Bs; B ];
    end

end