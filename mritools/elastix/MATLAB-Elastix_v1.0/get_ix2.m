

% function get_ix2(file,prop)
%% get property value..(get_ix is buggy if there exist 'commented' properties )
% get ix2(parafiles2{1},'MaximumStepLength')
function val=get_ix2(file,prop)

val=[];

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

if isempty(ix); return; end


w=d{ix};
i1=min(strfind(w,'('));
i2=min(strfind(w,')'));
w=w(i1+1:i2-1);
w=strrep(w,prop,'');
w=regexprep(w,'\s','');

if strcmp(w(1),'"') && strcmp(w(end),'"')
    val=w;
else
    val=str2num(w);
end