

% function set_ix2(file,prop,value)
%% set propertey ..(set_ix is buggy if there exist 'commented' properties )
% rm_ix2(parafiles2{1},'MaximumStepLength')
function set_ix2(file,prop,value)



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
ipot=ones(length(ix),1);

for i=1:length(ix)
    if strfind(d{ix(i)},'//')<strfind(d{ix(i)},prop)
        ipot(i)=0;
    end
end
ix(ipot==0)=[];


if isnumeric(value)
    valstr=num2str(value);
else
    valstr=['"' value '"'];
end

dn=['(' prop ' ' valstr  ')'];


if isempty(ix)%append parameter to parameterfile
    d=[d; {dn}];
else %replace parameter
    d{ix}=dn;
end


flag=1;


if flag~=0
    fid = fopen(file,'wt');
    for i = 1:length(d)
        fprintf(fid,'%s\n',d{i});
    end
    fclose(fid);
else
    warning('Property ''%s'' is not present in filee %s',prop,file); %#ok<WNTAG>
end


