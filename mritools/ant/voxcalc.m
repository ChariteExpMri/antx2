function [out varargout]=voxcalc(in,ha,direction)
% converts -mm-coordinates in voxel-coordinates/indices and vice versa     
% out=voxcalc(in,ha,direction)
% using an existing transformation matrix 
% in  = [x y z] as mm coordinates or indices
% V = filename or nifti-header
% direction: 'mm2idx'  or 'idx2mm' 
%% EXAMPLE
% f1=fullfile('O:\data\karina\dat\s20141009_01sr_1_x_x\AVGT.nii');
% [o u]=voxcalc([82 127 122],f1,'idx2mm')
%%--result:   -0.0050    0.0255    0.0197   (0-center)
% [o u]=voxcalc([-0.0050    0.0255    0.0197],f1,'mm2idx')
% [o u]=voxcalc([-0.0050    0.0255    0.0197],f1,'mm2idx')
%%--result:   82.0000  126.9994  122.0007
%
%% get mm from slice (coronar view)
% q=[70,75,80,85,90,95,100,105,110,115,120,125,130,135,140,145,150]; sliceIDs
% q2=[ zeros(length(q),1) q' zeros(length(q),1)]
% [a b]=voxcalc([q2 ],ha,'idx2mm')
%  mm=a(:,2)'

if nargin==2
   toID=1;
else
   toID=0; %inversion : vox2mm
end

if nargin<1
    return
else
    mm= in;
    d = find(size(mm) == 3);
    if isempty(d),
        error('wrong usage: vox = mm2vox(mm-coord, [fname])');
    elseif d==1 && length(d)==1,
        mm=mm'; %arrange coordinate triples in rows        
    end
    
   
    if isstruct(ha),
        v.fname=ha.fname;
        name=v.fname;
    else
        name=ha;
        v=spm_vol(name);
        if size(v,1)==1
        name=v.fname;
        else
         name=v(1).fname   ;
        end
        
    end
end

v2m=spm_get_space(name);
 m2v=inv(v2m);
 
if direction=='mm2idx'
    for i=1:size(mm,1)
        vox(i,1:3)=mm(i,:)*m2v(1:3,1:3) + m2v(1:3,4)';
    end
    out=vox;
elseif direction=='idx2mm'
    
    for i=1:size(mm,1)
       % vox(i,1:3)=mm(i,:)*m2v(1:3,1:3) + m2v(1:3,4)';
       % disp('inversion')
       vox(i,1:3)= (mm(i,1:3)-m2v(1:3,4)')*v2m(1:3,1:3);
    end
    out=vox;
end

varargout{1}=direction;


