
% get number as string within a 'n-digits zeros string', such as '001, 002,003'
% function str=pnum(nr,ndigits)
% nr: number 
% ndigits: number of digits
% example:    
%  str=pnum(112,5);   %output string is 00112; e.g. 5digits string with the number 112
%  str=pnum(1:10,3);  % get cellarray: { '001';  '002'; ... ;  '010'}

function str=pnum(nr,digits)



% nu=3
if numel(nr)==1
    str=repmat('0',[1 digits]);
    str(end-length(num2str(nr))+1:end)=num2str(nr);
else %if nr is a numeric vector
    str=cellstr(repmat('0',[max(size(nr)) digits]));
    for i=1:length(nr)
        str{i}(end-length(num2str(nr(i)))+1:end)=num2str(nr(i));
    end
end


% % nu=3
% 
% str=repmat('0',[1 digits]);
% str(end-length(num2str(nr))+1:end)=num2str(nr);
% 
% % for i=1:100
% %     og2=og;
% %      og2(end-length(num2str(i))+1:end)=num2str(i);
% %     disp(og2);
% % end
