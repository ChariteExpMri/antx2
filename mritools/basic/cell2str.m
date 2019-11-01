%% concatenate cells to a string
% function b=cell2str(a,sep)
%  cell2str({'aa' 'bb' 'cc' 'dd'} , '_');
%   cell2str({'aa' 'bb' 'cc' 'dd'});
  
function b=cell2str(a,sep)


if ~exist('sep') ; sep=''; end

if length(a)==1
    b=char(a);
else
    b='';
    for i=1:length(a)-1
       b=[b a{i} sep ];
    end
     b=[b a{i+1}  ];
    
end
