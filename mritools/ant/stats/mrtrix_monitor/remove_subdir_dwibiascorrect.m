
function remove_subdir_dwibiascorrect
% ==============================================

% ===============================================
v=update_monitor();
pastudy=v.pastudy;
pad=fullfile(v.pastudy,'data');
[dirs] = spm_select('List',pad,'dir');
dirs=cellstr(dirs);

cprintf('*[0 0 1]', [  '*** [1] CHECK unexpected sub-folders (''dwibiascorrect'')***'   '\n']);

t={};
for i=1:length(dirs)
    pam=fullfile(pad,dirs{i});
    [dsub] = spm_select('List',pam,'dir');
    dsub=cellstr(dsub);
    dsubother=dsub(regexpi2(dsub,'dwibiascorrect'));
    dsubother2=dsub(regexpi2(dsub,'dwi2response'));
    if ~isempty(dsubother2)
      dsubother= [dsubother(:); dsubother2(:)];
    end
    
    msg='';
    if ~isempty(dsubother)
        msg=[' [OtherSUBdirs]: ' strjoin(dsubother,'|')];
        disp([dirs{i} ':'  'Nsubs==' num2str(length(dsub)) msg ]);
    end
    
    if length(dsub)>1
        t(end+1,:)={ dirs{i} dsubother pam} ;
    end
end
%% ===[message issue: find subdir "dwibiascorrect"]============================================
% a024|a025|a027
if ~isempty(t)
    cprintf('*[1 0 1]', [  ' problem: several unexpected sub-folders (''dwibiascorrect'') found'   '\n']);
    disp(['critical-animals: '  strjoin(t(:,1),'|')]);
    q=cellfun(@(a){[char(a) ]}, t(:,2));
    disp(['subfolders      : '  strjoin(cellstr(char(q)),'|')]);
else
   cprintf('*[0 .5 0]', [  ' OK: no unexpected subfolders (''dwibiascorrect'') found'   '\n']);
 
end

%% ======[remove subdirs "dwibiascorrect"]=========================================
if ~isempty(t)
    cprintf('*[0 .5 0]', [  ' [1.] remove this subfolders (''dwibiascorrect'') now?'   '\n']);
    qest=input('remove this subfolders [type: ''y'' or ''n'']?: ','s');
    disp(['you pressed:' qest ]);
    if strcmp(qest,'y')
        for i=1:size(t,1)
            td=t(i,:)
            for j=1:length(td{1,2})
                padel=fullfile( td{3},  td{1,2}{j});
                if exist(padel)
                    [suc mes] =rmdir(padel,'s');
                    if suc==0
                        cprintf('*[1 0 1]', [  ' could not remove folder: '  td{1,2}{j}  '\n']);
                        disp(['   ...problem with: ' padel]);
                        disp(mes);
                        cprintf('*[1 0 1]', [  ' could not remove folder: '  td{1,2}{j}  '\n']);
                        
                    end
                end
            end
        end
    end
end


% ==============================================
%%   part-2 : check whether Pipeline is finished
% unprocessed-animals: a019|a023|a024|a025|a027
% ===============================================
cprintf('*[0 0 1]', [  '***[2] REMOVE MRTRIX-FOLDER FROM UNPROCESSED ANIMALS***'   '\n']);

t={};
fi2check={...
    'assignments_di_sy.txt'
    'connectome_di_sy.csv'
    '100k.tck'
    '100m.tck'};
for i=1:length(dirs)
    pam=fullfile(pad,dirs{i});
    [dsub] = spm_select('List',pam,'dir');
    dsub=cellstr(dsub);
    dsubother=dsub(regexpi2(dsub,'dwibiascorrect'));
    
    pam=fullfile(pam,dsub{1});
    
    pam_mrtrix=fullfile(pam,'mrtrix');
    fis=stradd(fi2check,[ pam_mrtrix filesep ],1);
    
    isexist=[sum(existn(fis)==2)==length(fis)];
    if isexist==0
        t(end+1,:)={ dirs{i} 'ee' pam pam_mrtrix} ;
    end
end
% ==============================================
%%  remove animal-a023 from MRTRIX-delList because it is currently processing
% ===============================================

% t(strcmp(t(:,1),'a023'),:)=[];

% ==============================================
%%   disp message
% ===============================================

if ~isempty(t)
    cprintf('*[1 0 1]', [  ' MRtrix-ANALYSIS NOT done for the followinf animals:'   '\n']);
    disp(['unprocessed-animals: '  strjoin(t(:,1),'|')]);
   disp(['unprocessed-animals: ' regexprep( [ strjoin(t(:,1),',')],'a0{0,10}','') ]);
%     disp(['subfolders      : '  strjoin(cellstr(char(q)),'|')]);
else
   cprintf('*[0 .5 0]', [  ' OK: MRtrix-ANALYSIS done for all animals !!'   '\n']);
end



%% ======[remove subdirs "dwibiascorrect"]=========================================

if ~isempty(t)
    t=t(find(existn(t(:,4))==7),:);
    cprintf('*[0 .5 0]', [  ' [2.] remove MRtrix-folder from un-processed animals?'   '\n']);
    qest=input('remove MRtrix-folder: ''y'' or ''n'']?: ','s');
    if strcmp(qest,'y')
        for i=1:size(t,1)
            td=t(i,:);
            pa_mrtrix=td{4};
            if exist(pa_mrtrix)
                [suc mes] =rmdir(pa_mrtrix,'s');
                if suc==0
                    cprintf('*[1 0 1]', [  ' could not MRTRIX-remove folder: '  '\n']);
                    disp(['   ...problem with: [' td{1} '] --> "' pa_mrtrix  '"']);
                    disp(mes);
                    cprintf('*[1 0 1]', [  ' could not remove folder "mrtrix" '  '\n']);
                end
            end 
        end
    end
elseif ~isempty(t)
%   cprintf('*[0 .5 0]', [  ' ..'   '\n']);
 
end

disp('DONE!');

% for j=1:length(td{1,2})
%                 padel=fullfile( td{3},  td{1,2}{j});
%                 if exist(padel)
%                     [suc mes] =rmdir(padel,'s');
%                     if suc==0
%                         cprintf('*[1 0 1]', [  ' could not remove folder: '  td{1,2}{j}  '\n']);
%                         disp(['problem with: ' padel]);
%                         disp(mes);
%                         cprintf('*[1 0 1]', [  ' could not remove folder: '  td{1,2}{j}  '\n']);
%                         
%                     end
%                 end
%             end