
%obtain anchortext: get text between anchor-tags from file 
% example: msg=getanchortext(which('xdraw.m'),'##anker1##')
function msg=getanchortext(file,anchor)


if 0
    msg=getanchortext(which('xdraw.m'),'##anker1##')
    
end

msg=[];
a=preadfile(file); a=a.all;
try
    v1=regexpi2(a,'getanchortext');
    v2=regexpi2(a,anchor);
    is=setdiff(v2,v1);
    msg=a(is(1)+1:is(2)-1);
end