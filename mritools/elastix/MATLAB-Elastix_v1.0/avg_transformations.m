function avg_tfile = avg_transformations(tfiles0,outfold,name)

% avg_tfiles creates a text(ASCII) transformation file that is be used to 
% evaluate (by running transformix.exe) the average of a set of transformations
%
% Usage:
% avg_tfile = avg_transformations(tfiles,outfold,name)
%
% -----------------------------Inputs--------------------------------------
% tfiles: vector or cell array of file pathnames of the transformations files
% outfold: output directory (if empty outfold will be the directory containing
%          the last transformation file)
% name: fragment of the name for the average transformation file
% ------------------------------Outputs------------------------------------
% avg_tfile: average transformation file (filename is ['avg-' name '.txt'])
% 
% 5/3/2011
% version 1.0b
% 
% Pedro Antonio Valdés Hernández
% Neuroimaging Department
% Cuban Neuroscience Center

if ischar(tfiles0)
    N = size(tfiles0,1);
    tfiles = cell(N,1);
    for i = 1:N
        tfiles{i} = deblank(tfiles0(i,:));
    end
elseif iscell(tfiles0)
    N = lentgh(tfiles0);
    tfiles = tfiles0;
end
%---
[pp,nn,ee] = fileparts(tfiles{end});
if isempty(outfold)
    outfold = pp;
end
avg_tfile = fullfile(outfold,['avg-' name ee]);
copyfile(tfiles{end},avg_tfile);
%---
set_ix(avg_tfile,'Transform','WeightedCombinationTransform');
set_ix(avg_tfile,'InitialTransformParametersFileName','NoInitialTransform');
set_ix(avg_tfile,'NumberOfParameters',N);
set_ix(avg_tfile,'TransformParameters',ones(1,N));
add_ix(avg_tfile,'NormalizeCombinationWeights','true',5);
add_ix(avg_tfile,'SubTransforms',deblank(sprintf('"%s" ',tfiles{:})),6);