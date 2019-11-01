

function nc=vc2nc(v2,hb)
% volume coords to normalized cords
% ----------------------------------

s_x=hb.hdr.hist.srow_x;
s_y=hb.hdr.hist.srow_y;
s_z=hb.hdr.hist.srow_z;

% s_x(find(s_x(1:3)==0))=1;
% s_y(find(s_y(1:3)==0))=1;
% s_z(find(s_z(1:3)==0))=1;


nc(:,1) = s_x(1).* v2(:,1)  +   s_x(2).* v2(:,2)  +   s_x(3).* v2(:,3)  +   s_x(4);
nc(:,2) = s_y(1).* v2(:,1)  +   s_y(2).* v2(:,2)  +   s_y(3).* v2(:,3)  +   s_y(4);
nc(:,3) = s_z(1).* v2(:,1)  +   s_z(2).* v2(:,2)  +   s_z(3).* v2(:,3)  +   s_z(4);

% % 
% % 
% % %    The (x,y,z) coordinates are given by a general affine transformation
% % %    of the (i,j,k) indexes:
% % % 
% % %      x = srow_x[0] * i + srow_x[1] * j + srow_x[2] * k + srow_x[3]
% % %      y = srow_y[0] * i + srow_y[1] * j + srow_y[2] * k + srow_y[3]
% % %      z = srow_z[0] * i + srow_z[1] * j + srow_z[2] * k + srow_z[3]
% % % 
% % %    The srow_* vectors are in the NIFTI_1 header.  Note that no use is
% % %    made of pixdim[] in this method.
% % 
% % 
% % srow_x=g.hdr.hist.srow_x
% % srow_y=g.hdr.hist.srow_y
% % srow_z=g.hdr.hist.srow_z
% % 
% % % a=[27 30 40]
% % a=[78 112 50]
% % i=a(1);j=a(2);k=a(3);
% % disp([i j k])
% % 
% % x = srow_x(1) * i + srow_x(2) * j + srow_x(3) * k + srow_x(4);
% % y = srow_y(1)* i + srow_y(2) * j + srow_y(3) * k + srow_y(4);
% % z = srow_z(1) * i + srow_z(2) * j + srow_z(3) * k + srow_z(4);