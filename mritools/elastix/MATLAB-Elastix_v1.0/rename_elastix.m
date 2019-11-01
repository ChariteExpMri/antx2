function newims = rename_elastix(result,outfold,newname)

% 5/3/2011
% version 1.0b
% 
% Pedro Antonio Vald�s Hern�ndez
% Neuroimaging Department
% Cuban Neuroscience Center

[pp,nn,ee] = fileparts(result);        
newim1 = fullfile(outfold,[newname ee]);

% n=1;
% while exist(result)~=2
%     disp(['wait for imag-' num2str(n)]);
%     n=n+1;
% end

movefile(result,newim1,'f');
switch ee
    case '.nii'
        newim2 = '';
    case '.mhd'
        result2 = fullfile(pp,[nn '.raw']);
        newim2 = fullfile(outfold,[newname '.raw']);
        movefile(result2,newim2);
    otherwise
        error('file format not supported');
end
newims = strvcat(newim1,newim2); %#ok<VCAT>