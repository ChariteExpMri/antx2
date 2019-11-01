function add_ix(file,prop,value,pos)

% add_ix adds a new property to a parameter/transformation file
% 
% Usage:
% add_ix(file,property_string,value,position)
%
% -----------------------------Inputs--------------------------------------
% file: pathname of the text(ASCII) parameter/transformation file
% property_string: name of the new property
% value: value of the new property
%        value can be a string (for files or, e.g. the type of cost function
%        in a parameter file, say 'AdvancedMattesMutualInformation') or a 
%        vector (e.g. the value of property 'Size' in a transformation file)
% position: line where the property is located in the text file
%       (Note: this is only for aesthetics, in fact position can be anywhere
%        in the file)
%
% 5/3/2011
% version 1.0b
% 
% Pedro Antonio Valdés Hernández
% Neuroimaging Department
% Cuban Neuroscience Center

warning off %#ok<WNOFF>
value0 = get_ix(file,prop);
warning on %#ok<WNON>
if ~isempty(value0)
    warning('Switching from add_ix to set_ix: the property ''%s'' already exists in file %s',prop,file); %#ok<WNTAG>
    set_ix(file,prop,value);
end
fid = fopen(file);
flg = true;
str = [];
c = 0;
while flg
    c = c+1;
    tmp = fgetl(fid);
    if (~ischar(tmp) && tmp == -1)
        flg = false;
    else
        str{c} = deblank(tmp); %#ok<AGROW>
    end
end
fclose(fid);
if ischar(value)
    if value(1)=='"'
        value(1) = [];
    end
    if value(end)=='"'
        value(end) = [];
    end
    str{end+1} = ['(' prop ' "' value '")'];
elseif isnumeric(value)
    str{end+1} = ['(' prop ' ' num2str(value) ')'];
end
if nargin == 4
    str = str([1:pos-1 end pos:end-1]);
end
fid = fopen(file,'wt');
for i = 1:length(str)
    fprintf(fid,'%s\n',str{i});
end
fclose(fid);