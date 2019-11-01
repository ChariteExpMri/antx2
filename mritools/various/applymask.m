function fileout=applymask(fil, fimask, operation, outmatch,outnonmatch,suffix)

%% apply mask on volume
%% function applymask(fil, fimask, operation, outmatch,outnonmatch,suffix)
% fil, ..file
% fimask,..maskfile 
% operation.. (string)  logical operation such as '>=1'  '==1' 
% outmatch,  matching voxels replacement: ,[]..replace by orig value   | nan..replace by nan | value..replace by value
% outnonmatch,   nonmatching voxels replacement: ,[]..replace by orig value   | nan..replace by nan | value..replace by value
% suffix: suffix added to saved file
%% OUT: new filename
%% examples
% applymask(fil, fimask, '==1', [],nan,'_test34')  ; %find 1 in mask, keep orig. values, nonmatching values replaced by nan
% applymask(fil, fimask, '==1', 3,nan,'_test34')  ;% same but replace matching values by 3
% applymask(fil, fimask, '==1', 3,6,'_test34')     %same but but replace matching and nonmatching values by 3 and 6,respectively



if 0
fil       ='T2.nii'
fimask='hemi2.nii'
operation ='==1'

outmatch=[]
outnonmatch=0
suffix='_test33'
end



 [ha a xyz]=rgetnii(fil );
 [hm m xyzm]=rgetnii(fimask );
 
 a2=a(:);
 m2=m(:);
 
 
 
 eval(['idx=find(m2' operation ');' ]);
 idx2=setdiff([1:length(a2)]',idx);
 
 %standard masking
a3=zeros(size(a2));
%  a3(idx)=a2(idx);
%  a3(idx2)=0;


%set values
if isempty(outmatch)
    a3(idx)=a2(idx);
else
    if ~isnan(outmatch)
        a3(idx)=outmatch;
    elseif isnan(outmatch)
        a3(idx)=nan;
    end
end

if isempty(outnonmatch)
    a3(idx2)=a2(idx2);
else
    if ~isnan(outnonmatch)
        a3(idx2)=outnonmatch;
    elseif isnan(outnonmatch)
        a3(idx2)=nan;
    end
end
    

 ha4=ha;
a4=reshape(a3,  ha.dim);

fileout=strrep(fil,'.nii',[suffix '.nii']);
rsavenii(fileout,ha4,a4 );

 
 