


function snipp_uitable1

raw={'p1'; 'p2'; 'p3'}; %points id  %COLUMN not row
column1=[200;250;300]; %distances
column1=num2cell(column1);
checked=false(size(raw,1),1);  %is it checked?
cellArray=[raw,column1,checked];
set(handles.uitable1, 'Data', cellArray);
set(handles.uitable1, 'ColumnFormat', {'string', 'numeric', 'logical'});
set(handles.uitable1, 'CellEditCallback', @check_checked);

function check_checked(src, eventdata);
%   cur_data = get(src, 'Data');
%   where_changed = eventdata.Indices;
%   row_changed = where_changed(1);
%   id_affected = cur_data{row_changed, 1);
%   dist_affected = cur_data(row_changed, 2);
%   %now do something with the information ...
 

