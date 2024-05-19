
%mrtrix_delete
% delete  files/from mrtrix-pipeline 
%% input:
% 'id':  numeric animal ids to delete from
%       example: 1,2,3 or [1:4,20], or "all" (remove from all animals)
% 'verbose'  : display message: [0]:silent, [1]:verbose
% 'simulate' :  do simulate: [0|1]  ; %[1] just simulate --> [0] remove files
% 'del'      : cellstr with files, wildcard-tokens --> these files will be deleteted
%              default: {'mrtrix'} : delete "mrtrix"-subfolder
%             example { 'mrtrix' 'rd.nii' 'fa.nii' 'adc.nii' 'ad.nii' -->
%                delete "mrtrix"-subfolder and the niftis: 'rd.nii' 'fa.nii' 'adc.nii' 'ad.nii'
% default: delete 'mrtrix'-subfolder;
% 
%% example-1: delete mrtrix-folder from animals 1:3 (these are animals: 'a001','a002' 'a003')
% mrtrix_delete('id',[1:3])
%% example-2: delete mrtrix-folder from all animals
% mrtrix_delete('id','all')
%% example-3: simulate to delete mrtrix-folder from animal-4 ('a004')
% mrtrix_delete('id',[4],'simulate',0,'del',{ 'mrtrix'})
%% example-4: simulate to delete mrtrix-folder, niftis and 'png'-images from animal-4
% mrtrix_delete('id',[4],'simulate',1,'del',{ 'mrtrix' 'rd.nii' 'fa.nii' 'adc.nii' 'ad.nii' '.*.png'})
%% example-5: delete mrtrix-folder, niftis and 'png'-images from animal-4
% mrtrix_delete('id',[4],'simulate',0,'del',{ 'mrtrix' 'rd.nii' 'fa.nii' 'adc.nii' 'ad.nii' '.*.png'})
%% example-6: restore origninal dataset of animal-4, i.e. delete 'mrtrix'-folder, delete dwimaps ('rd.nii' 'fa.nii' 'adc.nii' 'ad.nii') ans screenshoots (png-files) 
% mrtrix_delete('id',[4],'del',{'origin'})
%% example-7: delete all niftis and txt-files animal-4, 
% mrtrix_delete('id',[4],'del',{'.*.nii','.*.txt'})

function mrtrix_delete(varargin)

%% ===============================================

p.id      ='';
p.simulate=0;
p.verbose =1;
p.del={'mrtrix'};

%% ===============================================

if ~isempty(varargin)
    pin =cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    p=catstruct(p,pin);
end
p.del=cellstr(p.del);
iv=find(strcmp(p.del,'origin'));
if ~isempty(iv)
   ix_delrest=setdiff(1:length(p.del),iv) ;
   delrest=p.del(ix_delrest); 
   p.del=[ {'mrtrix' 'rd.nii' 'fa.nii' 'adc.nii' 'ad.nii' '.*.png'} delrest(:)' ];
   
end
%% ===============================================

% return
v=update_monitor();

%% =====[id]==========================================
if isempty(p.id)
    cprintf('*[1 0 1]',[ 'warning: the following will delete the following files/dirs from animals.\n'  ]);
    cprintf('*[1 0 1]', ['DELETE from animal: ' strjoin(p.del,'|') '.\n'  ]);
    cprintf('*[1 0 1]',[ 'to ABORT: leave empty and press enter.\n'  ]);
    disp('Enter numerid ids (matlabstyle): such as: 1,2,3  ');
    disp('examples: 1,2,3 or [1:4,20], or "all" ');
    p.id = input('enter numeric ids:','s');
end
if isempty(p.id); disp('aborted'); return, end

if strcmp(p.id,'all');
    p.id=cellfun(@(a)[ str2num(a)  ],regexprep(v.dirnum,'\D*',''));
else
    if ~isnumeric(p.id)
        p.id=str2num(p.id)  ;
    end
end
p.id= p.id(:);
% p.id

%% ======== get mrtrix-id=======================================
id_mrtrix=cellfun(@(a)[ str2num(a)  ],regexprep(v.dirnum,'\D*',''));
[~,idx]=intersect(id_mrtrix,p.id);
if isempty(idx);
    disp('IDs not found');
    disp(['possible IDs: ' strjoin(cellfun(@(a){[num2str(a)]},num2cell(id_mrtrix)),'|')]);
    return
end

%% =====delete==========================================
for i=1:length(idx)
    try
    mdir     =v.fpdir{idx(i)};
    catch
       continue 
    end
    mrtrixdir=fullfile(mdir,'mrtrix');
    mrtrix_idstr= v.dirnum{idx(i)};
    showinfo2(['animaID-' mrtrix_idstr ],mdir);
    
    % ==============================================
    %%   delete mrtrix folder
    % ===============================================
    
    if ~isempty(find(strcmp(p.del,'mrtrix')))
        if exist(mrtrixdir);
            if p.simulate==0
                rmdir(mrtrixdir, 's');
                disp(['"mrtrix"-dir removed: ' mrtrixdir]);
                showinfo2(mrtrix_idstr,mdir);
            else
                disp(['..simulate only: delete: ' mrtrixdir]);
            end
        else
            disp(['"mrtrix"-dir not found: ' mrtrixdir]);
        end
    end
    
    % ==============================================
    %%  delete files
    % ===============================================
    other=p.del;
    other(strcmp(p.del,'mrtrix'))=[];
    if ~isempty(other)
        for j=1:length(other)
            this=other{j};
            [fidel] = spm_select('FPListRec',mdir,this);
            
            if ~isempty(char(fidel))
                fidel=cellstr(fidel);
                for k=1:length(fidel)
                    if p.simulate==0
                        delete(fidel{k});
                        if p.verbose==1; 
                            disp(['..deleted: ' fidel{k}]);
                        end
                    else
                        disp(['..simulate only: delete: ' fidel{k}]);
                    end
                end
            else
                if p.verbose==1;
                    disp(['..not found: "' this  '" in: ' mdir]);
                end
            end
        end
    end
end
disp('mrtrix-deletion: DONE');





%% ===============================================



