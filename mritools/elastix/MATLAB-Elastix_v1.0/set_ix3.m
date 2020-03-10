

% function set_ix2(file,prop,value)
%% set propertey ..(set_ix is buggy if there exist 'commented' properties )
% rm_ix2(parafiles2{1},'MaximumStepLength')
function set_ix3(file,prop,value)

% file=parafilesinv{i},
% prop='Metric'
% value='DisplacementMagnitudePenalty'

a=preadfile(file);
a=a.all;

t=regexpi2(a,[ '^\s{0,100}' '(' prop ' ']);
if ~isempty(t)
    a(t)=cellfun(@(a){ ['//' a ]}, a(t));
    split=t(end);
else
    split=0;
end

lin={['(' prop ' "'  value '"' ')']};
if split==0
   a= [a; lin];
else
    a1=a(1:split);
    try
    a2=a(split+1:end);
    catch
     a2={' '};
    end
    
    a=[a1;lin;a2];
end
pwrite2file(file, a  );

    