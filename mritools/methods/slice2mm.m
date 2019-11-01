
%% convert slice to mm (get mm of slices)
% function out=slice2mm(fi, slices, dimx);
%% IN
% fi:     fp-path of volume  or spm-volume-header
% slices: array of slice-numbers
% dimx:   which dimention 1,2,3 or 'allen' (which is dimx=2) or 'native' (which is dimx==3)  (space)
%% OUT : 2d-array  [slices x mm]
%% example
% native-space or allen-space
% slice2mm('O:\harms1\harms3_lesionfill\dat\s20150908_FK_C1M02_1_3_1\hemi.nii', [1:32], 'native')
% slice2mm('O:\harms1\harms3_lesionfill\dat\s20150908_FK_C1M02_1_3_1\x_hemi.nii', [1:212], 'allen')
  
function out=slice2mm(fi, slices, dimx);

if isstruct(fi)
    ha=fi;
    fi=ha.fname;
else
    ha=rgetnii(fi);
end

q=slices(:)';
%   q=[60,73,86,99,112,125,138]; %sliceIDs
% q2=[ zeros(length(q),1)  zeros(length(q),1) q'];



if 0
    q2=[zeros(length(q),3)]; %matrix
    idx=2;
    q2(:,idx)=q;
    [a b]=voxcalc([q2 ],ha,'idx2mm');
    mm=a(:,idx)';
    out=[q(:) mm(:) ];
end



% disp(out)
[bb vx] = world_bb(fi);

if ischar(dimx)
   if strcmp(dimx,'allen')
       dirs=2;
   elseif strcmp(dimx,'native')
       dirs=3;
   end
else
    dirs=dimx;
end


%%
mm=linspace(bb(1,dirs),bb(2,dirs), ha.dim(dirs))';

out=[ q(:) mm(q(:)) ];
% 
% out([1 end],:)
% 
% ha.dim
% bb
% median(diff(mm))
% vx
% mm([1 end],:)













