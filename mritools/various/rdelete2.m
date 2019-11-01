function rdelete2( folder, tags)
%% delete multiple files, using REGEXP_STYLE  with cellarray of multiple wildcard tags -->WATCHOUT: this uses regexp-STYLE
% folder: folder to delete from  (tags does not have fullpath)
% tags  : string or cell of strings to match  ->caseSensitive
         % use use regexp-STYLE !!!!
         %     tags='^H.*.nii'    -->string
         %   tags={'^H.*.nii' '^c.*.nii'}    cell all files starting with H or c with format '.nii'
%             same as
%                tags={'^H*.nii' '^c*.nii'}  ; %% '*' is internally replaced by '.*' REGEXP-Style
%% NOTE THE DIFFERENCE TO RDELETE.m
%% example
% rdelete2(pwd, '^H.*.nii' '^c.*.nii')
% rdelete2(pwd, {'^H.*.nii' '^c.*.nii'})




%% new VERSION
% if 0
%     folder=pwd
%     %   tags='^H.*.nii'
%     %   tags={'^H.*.nii' '^c.*.nii'}
%     tags={'^H*.nii' '^c*.nii'}

%tag becoms cellType
if ischar(tags)
    tags={tags};
end

tags=strrep(strrep(tags,'*','.*'),'..*','.*');


k =dir(pwd);
k2={k(:).name}';

% regexp tags
k3=[];
for i=1:length(tags)
    k3=[k3; k2(~cellfun('isempty',regexpi(k2,tags{i},'matchcase')))];
end

% fullpathLIst +delete files
if ~isempty(k3)
%     disp(k3)
    k4=cellfun(@(k3) [fullfile(folder,k3)] , k3,'UniformOutput',0);
    
    for i=1:length(k4)
        try
          delete(k4{i});
        end
    end
end


% =================================
%% OLDER VERSION
%delete multiple files, using cellarry with multiple files/wildcards
% function rdelete2(tags)
% folder: folder to delete from  (tags does not have fullpath)
% tags  : fullpathfiles (folder must be empty) or wildcardstuff
%% example
% rdelete2( [], {'p*.nii'  'r*.nii' '*.ps' }) ;%current folder or explicit path
% rdelete2(pwd, {'p*.nii'  'r*.nii' '*.ps' })
% if 0
%     for i=1:length(tags)
%         if ~isempty(folder)
%             try
%                 delete(fullfile(folder,tags{i}));
%             end
%         else
%             delete(tags{i});
%         end
%     end
% end


