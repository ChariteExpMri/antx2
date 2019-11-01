
function [ vol nvox h2]=getvolume(fili,operation)
% calc volume (qmm) &nvox from file
% fili: niftifile
% operation:  (optional) logical operation to searchn in volume, 3>,>=3,>3,...~=3
%                   (optional: the voxvalues of '1' are counted)
%  output: volume(qmm) ,number of voxels, header
%  example:
% [ vol nvox h2]=getvolume(fili)
% [ vol nvox h2]=getvolume(fili,'==1')
% [ vol nvox h2]=getvolume(fili,'>0')

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


% if ~exist('operation')
%     % if isempty(operation)
%     operation='==1';
% end

if ischar(fili)
    [h2 d2 xyz2]=rgetnii(fili);
    eval([ 'idx=find(d2' operation ');']);
    nvox=length(idx);
%     vol=(abs(prod(diag(h2.mat(1:3,1:3))))  ) *(nvox);  %brain volume(qmm)
    vol=abs(det(h2.mat(1:3,1:3)) *(nvox));  %brain volume(qmm)

else
  
    for i=1:length(fili)
        disp(['calc vol: ' fili{i}]);
        [h2 d2 xyz2]=rgetnii(fili{i});
        eval([ 'idx=find(d2' operation ');']);
        nvox(i,1)=length(idx);
%         vol(i,1)=(abs(prod(diag(h2.mat(1:3,1:3))))  ) *(nvox(i));  %brain volume(qmm)
       vol(i,1)= abs(det(h2.mat(1:3,1:3)) *(nvox(i)));  
    end
    h2=[fili num2cell([vol nvox])];
end




