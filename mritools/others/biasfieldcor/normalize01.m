function f2=normalize01(f);
% Normalize to the range of [0,1]

fmin  = min(f(:));
fmax  = max(f(:));
f2 = (f-fmin)/(fmax-fmin);  % Normalize f to the range [0,1]



% f2 = (f-fmin)/(fmax-fmin);  % Normalize f to the range [0,1]

% f2 = (f-fmin)/(fmax-fmin);  % Normalize f to the range [0,1]

 
% fu=f2.*(fmax-fmin)+fmin;

 


