


function fh=foo
fh.msub=@msub;
fh.madd=@madd;
fh.minfo=@minfo;
 
function r=msub(a,b)
r=a-b;
 
function r=madd(a,b)
r=a+b;
 

function [x y z]=minfo(a,b,c)
x='hallo'
y=[1:3]
z=b
 