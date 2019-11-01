
%get infos from 'antinfomessage.txt'
% function msg=getinfomessage(search)
% search=


function msg=getinfomessage(search)

msg='';

try
    a=preadfile(which('antinfomessage.txt')); a=a.all;
    
    
    i1=regexpi2(a,search);
    i2=regexpi2(a,'##end');
    i2=i2(min(find(i2>i1)));
    msg=a(i1+1:i2-1);
end