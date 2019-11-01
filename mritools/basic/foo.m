
% in the command window
% fh=foo; % load the function handles to the subfunctions
% fh.msub(10,5)
% fh.madd(pi,pi)

function fh=foo
fh.msub=@msub;
fh.madd=@madd;
end
function r=msub(a,b)
r=a-b;
end
function r=madd(a,b)
r=a+b;
end

% % in the command window
% fh=foo; % load the function handles to the subfunctions
% fh.msub(10,5)
% fh.madd(pi,pi)