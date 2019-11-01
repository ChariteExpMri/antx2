function f3=denormalize01(f,ref)
% Normalize to the range of [0,1]

% fmin  = min(f(:));
% fmax  = max(f(:));
% f = (f-fmin)/(fmax-fmin);  % Normalize f to the range [0,1]

%   fmin  = min(ref(:));
%   fmax  = max(ref(:));

% fu=f*(fmax-fmin)+fmin;


% f=ref;
fmin  = min(ref(:));
fmax  = max(ref(:));
% f2 = (f-fmin)/(fmax-fmin);

f3=f*(fmax-fmin)+fmin;