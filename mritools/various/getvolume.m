
function [ vol nvox h3]=getvolume(fili,operation)
% [ vol nvox h3]=getvolume(fili,operation)
% calc volume (qmm) &nvox from file
% fili: niftifile
% operation:  (optional) 
%           -string containuing a logical operation to searchn in volume: ">=0", "==1" , 
%           -value:  this value (ID) is searched in volume
%           -vecor with values:  values (IDs) are searched in volume
%           - 'all'  (string): search for all IDs in volume and obtain ID-specific volume
%            if omitted: the voxvalues of '1' are counted)
%% ===============================================
% #b OUTPUT: 
% volume(qmm) ,
% number of voxels, 
% list:  list contains {filename, volume, voxels, ID/operation}
%% ===============================================
%  example:
% [ vol nvox h2]=getvolume(fili)  ;%calc vol of mask (ID is 1, i.e. maskvalue is 1)
% [ vol nvox h2]=getvolume(fili,'==1'); same as above
% [ vol nvox h2]=getvolume(fili,'>0'); same as above of there are no others IDs in the volume
% 
%  [vol vox tb]=getvolume({'Rat_Atlas_Segmentation.nii'},[1 2]); % obtain volume for IDs 1&2 in volume
% [ vol nvox h2]=getvolume('Rat_Atlas_Segmentation.nii','>0');  % obtain volume for all IDs >0 
% [ vol nvox h2]=getvolume('Rat_Atlas_Segmentation.nii','all'); %get volume of all unique IDs in volume

if 0
    fili=fullfile(pwd,'Xwmask2.nii')
    operation='==1'
    
end

if  exist('fili')==0;                 fili=[]; end
if  exist('operation')==0;     operation='==1'; end
    
if isempty(fili)
    %manual select
    [files,sts] = spm_select(inf,'image','select mouse folders',[],pwd,'.*');
    if isempty(files); return; end
    files=cellstr(files);
    fili=files;
end




% ==============================================
%%   
% ===============================================

fili=cellstr(fili);
vol  =[];
nvox =[];
h3   =[];
for i=1:length(fili)
    disp(['calc vol: ' fili{i}]);
    %[h2 d2 xyz2]=rgetnii(fili{i});
    [h2 d2 ]=rgetnii(fili{i});
    if isnumeric(operation)
        op=cellfun(@(a){[ '==' num2str(a)]} ,num2cell(operation(:)));
    else
       if strcmp(operation,'all')
          uni=unique(d2); uni(uni==0)=[] ; uni(isnan(uni))=[];
          op=cellfun(@(a){[ '==' num2str(a)]} ,num2cell(uni));
       else
          op={operation};
       end
    end
    
    for j=1:length(op)
        eval([ 'idx=find(d2' op{j} ');']);
        voxt  = length(idx);
        volt  = abs(det(h2.mat(1:3,1:3)) *(voxt));
        if isempty( regexpi(op{j},'==') )
            IDt   =op{j};
        else
            IDt   =regexprep(op{j},'\D','');
            
        end
        
        nvox =[nvox ; voxt];
        vol  =[vol  ; volt];
        h3=[h3; [{fili{i}}  voxt  volt IDt]];
    end
end



% ==============================================
%%   
% ===============================================




return

% if ~exist('operation')
%     % if isempty(operation)
%     operation='==1';
% end

% if ischar(fili)
%     [h2 d2 xyz2]=rgetnii(fili);
%     eval([ 'idx=find(d2' operation ');']);
%     nvox=length(idx);
% %     vol=(abs(prod(diag(h2.mat(1:3,1:3))))  ) *(nvox);  %brain volume(qmm)
%     vol=abs(det(h2.mat(1:3,1:3)) *(nvox));  %brain volume(qmm)
% 
% else
%   
%     for i=1:length(fili)
%         disp(['calc vol: ' fili{i}]);
%         [h2 d2 xyz2]=rgetnii(fili{i});
%         eval([ 'idx=find(d2' operation ');']);
%         nvox(i,1)=length(idx);
% %         vol(i,1)=(abs(prod(diag(h2.mat(1:3,1:3))))  ) *(nvox(i));  %brain volume(qmm)
%        vol(i,1)= abs(det(h2.mat(1:3,1:3)) *(nvox(i)));  
%     end
%     h2=[fili num2cell([vol nvox])];
% end




