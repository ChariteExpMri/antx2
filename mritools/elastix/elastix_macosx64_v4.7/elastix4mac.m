

function ela=elastix4mac
%fet path of elastix for mac
v=which('libANNlib.dylib');
px=fileparts(v);
ela.E=fullfile(px,'elastix');
ela.T=fullfile(px,'transformix');
ela.pa=px;