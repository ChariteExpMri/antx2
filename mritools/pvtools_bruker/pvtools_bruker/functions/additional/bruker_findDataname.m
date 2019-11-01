function out_findlist=bruker_findDataname(yourpath, dataname, you_disp)
% out_findlist=bruker_findDataname(yourpath, dataname, you_disp)
% searches in yourpath and all subdirectories for a file with the given dataname.
% IN:
%   yourpath: string, name of the directory e.g. '/opt/PV6.0/data'
%   dataname: string, name of the searched file, e.g. 'acqp'
%   you_disp: if you add 'disp' as third argument: the list with found
%             paths will getting displayed at the end of the search
%
% OUT:
%   out_findlist: cellarray with paths to found files
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2012
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: bruker_findDataname.m,v 1.1.4.1 2014/05/23 08:43:51 haas Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    out_findlist={};
    out_dirlist={};
    start=dir(yourpath);
    for i=1:length(start);
       if start(i).isdir==1 && ~strcmp(start(i).name, '.') && ~strcmp(start(i).name, '..')
           out_dirlist{length(out_dirlist)+1}=[yourpath, filesep, start(i).name];
       end
       if strcmp(start(i).name, dataname)
           out_findlist{length(out_findlist)+1}=[yourpath, filesep, start(i).name];
       end
    end
    if ~isempty(out_dirlist)
        [out_dirlist, out_findlist]=recursive_find2dseq(out_dirlist, out_findlist, dataname);
    end 
    
    
    % show:
    if nargin==3 && strcmp(you_disp, 'disp')
        for i=1:length(out_findlist)
            disp(out_findlist{i});
        end
    end

end


% dirlist=cellarray mit verzeichnissen
function [out_dirlist, out_findlist]=recursive_find2dseq(in_dirlist, in_findlist, dataname)
    out_dirlist=cell(1000,1);
    out_findlist=in_findlist;
    out_dirlist_counter=0;
    for i1=1:length(in_dirlist)
       s=dir(in_dirlist{i1});

       for i2=3:length(s)
           if s(i2).isdir %&& (~strcmp(s(i2).name, '.')) && (~strcmp(s(i2).name, '..'))
               out_dirlist_counter=out_dirlist_counter+1;
               out_dirlist{out_dirlist_counter}=[in_dirlist{i1}, filesep, s(i2).name];              
               if out_dirlist_counter==length(out_dirlist)
                   out_dirlist=[out_dirlist; cell(1000,1)];
               end
           end
           if strcmp(s(i2).name, dataname)
               out_findlist{length(out_findlist)+1}=[in_dirlist{i1}, filesep, s(i2).name];
           end
       end
    end
    out_dirlist=out_dirlist(1:out_dirlist_counter);
    %disp(out_dirlist_counter)
    if ~isempty(out_dirlist)
        [out_dirlist, out_findlist]=recursive_find2dseq(out_dirlist, out_findlist, dataname);
    end        
end