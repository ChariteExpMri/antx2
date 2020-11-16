function cellout = outerboundary( cellin )
% outerboundary: get exact boundary of the outer contour of objects
% sub-function of getExactBounds.m
% input - cellin is a cell (N*1), cellin{j} is clockwise polygonal boundary
%
% an example:
%     bw = [0 0 0 0 0;
%           0 0 1 1 0;
%           0 1 1 1 0;
%           0 0 0 1 0;
%           0 0 0 0 0];
%     bw = logical( bw );
%     B_in = bwboundaries( bw', 8, 'noholes' );
%     B_ex = outerboundary( B_in );
% 
%     hold on
%     imshow(bw,'InitialMagnification','fit');
%     for i = 1: length(B_ex)
%         plot( B_in{i}(:,1), B_in{i}(:,2), 'O-k','MarkerSize',5,'LineWidth',2 );
%         plot( B_ex{i}(:,1), B_ex{i}(:,2), 'v-g','MarkerSize',5,'LineWidth',2 );
%     end
%     hold off
%     legend( 'result of bwboundaries(bw'',8,''noholes'' )' ,...
%             'outerboundary( bwboundaries() )');
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
        new_pnt_list = pnt_list;
    else
        % two or more pixels
        % Step 1: obtain mid point of 2 neighbouring vertex. Treat mid 
        % points as new vertex. If not skew line, offset by 0.5.
        % Step 2: add special vertex since step 1 will miss some corners.
        % Step 3: for the skew line, offset by sqrt(2)/2.
        
        poly = [ cellin{j}; cellin{j}(2,:) ];   % to make pnt_list be close
        len_pnt_list = ( size( cellin{j}, 1 ) - 1 )*4;
        pnt_list = zeros( len_pnt_list, 2 );    % initailize
        count = 0;
        % pnt_list = [];
        
        % step 1 & step 2
        for k = 1: length(poly)-1
            % step 1
            if poly(k,1) == poly(k+1,1)
                % vertical line
                temp_y = 0.5*( poly(k,2) + poly(k+1,2) );
                if poly(k+1,2) > poly(k,2)
                    temp_x = poly(k,1) - 0.5;
                else
                    temp_x = poly(k,1) + 0.5;
                end
                temp = [ temp_x, temp_y ];

            elseif poly(k,2) == poly(k+1,2)
                % horizontal line
                temp_x = 0.5*( poly(k,1) + poly(k+1,1) );
                if poly(k+1,1) > poly(k,1)
                    temp_y = poly(k,2) + 0.5;
                else
                    temp_y = poly(k,2) - 0.5;
                end
                temp = [ temp_x, temp_y ];
            else
                % skew line
                temp = 0.5*( poly(k,:) + poly(k+1,:) );
            end 	% end of step 1

            % step 2
            if count > 0
                p1 = pnt_list(count,:);
                p2 = temp;
                if p1(1) == p2(1)
                    % vertical line
                    % pnt_list(end,:)  temp
                    % poly(k,:)
                    if p2(2) > p1(2)
                        if poly(k,1) < p1(1)
                            temp = [
                                poly(k,:) + [-0.5 -0.5];
                                poly(k,:) + [-0.5 +0.5];
                                temp
                                ];
                        else
                            % do nothing
                        end
                    else
                        if poly(k,1) > p1(1)
                            temp = [
                                poly(k,:) + [+0.5 +0.5];
                                poly(k,:) + [+0.5 -0.5];
                                temp
                                ];
                        else
                            % do nothing
                        end
                    end
                elseif p1(2) == p2(2)
                    % horizontal line
                    if p2(1) > p1(1)
                        if poly(k,2) > p1(2)
                            temp = [
                                poly(k,:) + [-0.5 +0.5];
                                poly(k,:) + [+0.5 +0.5];
                                temp
                                ];
                        else
                            % do nothing
                        end
                    else
                        if poly(k,2) < p1(2)
                            temp = [
                                poly(k,:) + [+0.5 -0.5];
                                poly(k,:) + [-0.5 -0.5];
                                temp
                                ];
                        else
                            % do nothing
                        end
                    end
                else
                    % do nothing
                end
            end     % end of step 2
            
            % put temp into pnt_list
            if ~isempty( temp )
                len_temp = size( temp, 1 );
                pnt_list( count+(1:len_temp), : ) = temp;
                count = count + len_temp;
            end
        end   	% end of step 1 & step 2
        
        % delete redudant zeros in pnt_list
        pnt_list( count+1:end, : ) = [];

        if ~isequal( pnt_list(1,:), pnt_list(end,:) )
            error('polygon not close')
        end

        % step 3
        new_pnt_list = pnt_list;
        count = 0;
        % pnt_list remain unchanged
        % update new_pnt_list
        for k = 1: size(pnt_list,1)-1
            p1 = pnt_list(k,:);
            p2 = pnt_list(k+1,:);

            if p1(1) ~= p2(1) && p1(2) ~= p2(2)
                if p2(1) < p1(1) && p2(2) > p1(2)
                    temp = [ p2(1) p1(2) ];
                elseif p2(1) > p1(1) && p2(2) > p1(2)
                    temp = [ p1(1) p2(2) ];
                elseif p2(1) > p1(1) && p2(2) < p1(2)
                    temp = [ p2(1) p1(2) ];
                elseif p2(1) < p1(1) && p2(2) < p1(2)
                    temp = [ p1(1) p2(2) ];
                end

                new_pnt_list = [
                                new_pnt_list( 1: k+count, : );
                                temp;
                                new_pnt_list( k+count+1: end, : )
                                ];
                count = count + 1;
            else
                % do nothing
            end
        end     % end of step 3
        
        if ~isequal( new_pnt_list(1,:), new_pnt_list(end,:) )
            error('polygon not close')
        end
    end
    
    cellout{j} = new_pnt_list;
end
     
end