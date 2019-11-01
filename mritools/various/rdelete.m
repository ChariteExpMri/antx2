function rdelete( folder, tags)

%delete multiple files, using cellarry with multiple files/wildcards
% function rdelete(tags)
% folder: folder to delete from  (tags does not have fullpath)
% tags  : fullpathfiles (folder must be empty) or wildcardstuff
%% example
% rdelete( [], {'p*.nii'  'r*.nii' '*.ps' }) ;%current folder or explicit path
% rdelete(pwd, {'p*.nii'  'r*.nii' '*.ps' })


for i=1:length(tags)
    if ~isempty(folder)
        try
            delete(fullfile(folder,tags{i}));
        end
    else
         delete(tags{i});
    end
end