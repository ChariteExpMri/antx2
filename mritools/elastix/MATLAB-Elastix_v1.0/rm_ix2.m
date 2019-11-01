

% function rm_ix2(file,prop)
%% remove propertey from field
% rm_ix2(parafiles2{1},'MaximumStepLength')
function rm_ix2(file,prop)



d={};
fid=fopen(file);
j=1;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    d{j,1}=tline;  
    j=j+1;
end
fclose(fid);

if exist('d')==0;     d=' ';end

% regexpi(['(    ' prop],['(\s*' prop])
ix=find(~cellfun('isempty', regexpi(d,['(\s*' prop]) ));
flag=length(ix);
d(ix)=[];


if flag~=0
    fid = fopen(file,'wt');
    for i = 1:length(d)
        fprintf(fid,'%s\n',d{i});
    end
    fclose(fid);
else
    warning('Property ''%s'' is not present in filee %s',prop,file); %#ok<WNTAG>
end


