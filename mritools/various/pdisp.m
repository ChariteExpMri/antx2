% function pdisp(i)
% disp iterationnumber in one line
% example
% for i=1:10; pdisp(i);end
% pdisp(i,10);%show everey 10th
function pdisp(i,varargin)


if nargin==2
  if mod(i,varargin{1})==0
    fprintf(1,'%d ',i);   
  end
    
else
   fprintf(1,'%d ',i); 
    
end