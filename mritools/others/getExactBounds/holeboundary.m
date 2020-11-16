function cellout = holeboundary( cellin )
% holeboundary: get exact boundary of the holes
% sub-function of getExactBounds.m
% input - cellin is a cell (N*1), cellin{j} is clockwise polygonal boundary
%
% an example:
%     bw = [0 1 0 0 0;
%           1 0 1 1 0;
%           1 0 0 1 0;
%           1 0 0 1 0;
%           1 1 1 0 0];
%     bw = logical( bw );
%     B_in = bwboundaries( bw', 8 );    
%     % B_in{1} is boundary of the object
%     % B_in{2} is boundary of hole inside the object
%     B_ex = holeboundary( B_in(2) );
%     % B_ex is the exact boundary of hole inside the object
% 
%     hold on
%     imshow(bw,'InitialMagnification','fit');
%     plot( B_in{2}(:,1), B_in{2}(:,2), 'O-r','MarkerSize',5,'LineWidth',2 );
%     plot( B_ex{1}(:,1), B_ex{1}(:,2), 'v-g','MarkerSize',5,'LineWidth',2 );
%     hold off
%     legend( 'result of bwboundaries( )' ,...
%             'holeboundary( bwboundaries() )');
%
%
% Revision history:
%   Jiexian Ma, mjx0799@gmail.com, May 2020 

cellout = cell( length(cellin), 1 );

for j = 1: length(cellin)
    if size( cellin{j}, 1 ) < 2
        error('size error')
    elseif size( cellin{j}, 1 ) == 2
        % one pixel
        % four corner
        [cx,cy] = meshgrid( cellin{j}(1,1)+[-.5 .5], cellin{j}(1,2)+[-.5 .5] );
        pnt_list = zeros( 5, 2 );
        pnt_list( 1:4, : ) = [ cx(:), cy(:) ];
        pnt_list( 3:4, : ) = flip( pnt_list(3:4,:), 1 );
        pnt_list( 5, : ) = pnt_list( 1, : );
    else
        % two or more pixels
        poly = [ cellin{j}; cellin{j}(2,:) ];   % to make pnt_list be close
        len_pnt_list = ( size( cellin{j}, 1 ) - 1 )*4;
        pnt_list = zeros( len_pnt_list, 2 );    % initailize
        count = 0;
        
        % get exact boundary from inner boundary
        for k = 1: length(poly)-2
            % vector
            vec_1 = [ poly(k+1,1)-poly(k,1), poly(k+1,2)-poly(k,2) ];
            vec_2 = [ poly(k+2,1)-poly(k+1,1), poly(k+2,2)-poly(k+1,2) ];
            xy = [ poly( k, : ); poly( k+1, : ); poly( k+2, : ) ];
            % generate points on the corner of a pixel
            temp = getCorner( vec_1, vec_2, xy );
            
            % delete repeated vertex
            % compare last of pnt_list and first of temp
            if count>0 && isequal( pnt_list(count,:), temp(1,:) )
                temp(1,:) = [];
            end
            % put temp into pnt_list
            if ~isempty( temp )
                len_temp = size( temp, 1 );
                pnt_list( count+(1:len_temp), : ) = temp;
                count = count + len_temp;
            end
        end
        % delete redudant zeros in pnt_list
        pnt_list( count+1:end, : ) = [];
    end
    
    if ~isequal( pnt_list(1,:), pnt_list(end,:) )
        error('polygon not close')
    end
    
    cellout{j} = pnt_list;
end

end

function temp = getCorner( vec_1, vec_2, xy )
% generate points on the corner of a pixel
%
%     % vector
%     vec_1 = [ poly(k+1,1)-poly(k,1), poly(k+1,2)-poly(k,2) ];
%     vec_2 = [ poly(k+2,1)-poly(k+1,1), poly(k+2,2)-poly(k+1,2) ];
%     xy = [ poly( k, : ); poly( k+1, : ); poly( k+2, : ) ];
%     temp = getCorner( vec_1, vec_2, xy );
%

    % rotate xy, make vec_1 to [1 0] direction
    angl = angle( vec_1(1) + vec_1(2)*1i );
    Rmat = @(theta) [cos(theta) sin(theta);-sin(theta) cos(theta)];
    rot = round( Rmat( -angl ) );
    xyr = xy * rot;     % size = (n,2) * (2,2) = (n,2)

    % generate points on the corner of a pixel
    if isequal( vec_1, vec_2 )                       % case 1
        tempr = [ ( xyr(1,1) + xyr(2,1) )/2, xyr(1,2) + 0.5;
                  ( xyr(2,1) + xyr(3,1) )/2, xyr(1,2) + 0.5 ];

    elseif isequal( vec_1, -vec_2 )                  % case 2
        tempr = [ ( xyr(1,1) + xyr(2,1) )/2, xyr(1,2) + 0.5;
                  ( xyr(1,1) + xyr(2,1) )/2 + 1, xyr(1,2) + 0.5;
                  ( xyr(1,1) + xyr(2,1) )/2 + 1, xyr(1,2) - 0.5;
                  ( xyr(1,1) + xyr(2,1) )/2, xyr(1,2) - 0.5 ];

    elseif dot( vec_1, vec_2 ) == 0 && ...            % case 3
            vec_1(1)*vec_2(2) - vec_1(2)*vec_2(1) > 0 % cross product
        tempr = [ ( xyr(1,1) + xyr(2,1) )/2, xyr(1,2) + 0.5 ];

    elseif dot( vec_1, vec_2 ) == 0 && ...            % case4
            vec_1(1)*vec_2(2) - vec_1(2)*vec_2(1) < 0
        tempr = [ ( xyr(1,1) + xyr(2,1) )/2, xyr(1,2) + 0.5;
                  ( xyr(1,1) + xyr(2,1) )/2 + 1, xyr(1,2) + 0.5;
                  ( xyr(1,1) + xyr(2,1) )/2 + 1, xyr(1,2) - 0.5 ];
    else
        error('unexpected cases');
    end
    
    % rotate backward
    temp = tempr * rot';
end
