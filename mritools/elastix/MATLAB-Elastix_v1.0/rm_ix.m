function rm_ix(file,prop)

% rm_ix removes a property from a parameter/transformation file
% 
% Usage:
% rm_ix(file,property_string)
%
% -----------------------------Inputs--------------------------------------
% file: pathname of the text(ASCII) transformation file
% property_string: name of the new property
%
% 5/3/2011
% version 1.0b
% 
% Pedro Antonio Valdés Hernández
% Neuroimaging Department
% Cuban Neuroscience Center

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
flg = false;
for i = 1:length(str)
    ind = findstr(str{i},['(' prop ' ']);
    if ~isempty(ind)
        str(i) = []; %#ok<AGROW>
        flg = true;
        break
    end
end
if flg
    fid = fopen(file,'wt');
    for i = 1:length(str)
        fprintf(fid,'%s\n',str{i});
    end
    fclose(fid);
else
    warning('Property ''%s'' is not present in file %s',prop,file); %#ok<WNTAG>
end