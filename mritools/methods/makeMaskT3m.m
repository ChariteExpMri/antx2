

%make mask from t2 image
% makeMaskT2(file,fileout, thresh)
% example
% file='O:\harms1\harms3_lesionfill\templates\AVGT.nii'
% fileout='O:\harms1\harms3_lesionfill\templates\allemask.nii'
% thresh='>50';   %string with operator and number ,e.g. '>0'
% makeMaskT2(file,fileout, thresh)

function makeMaskT3(file,fileout, thresh)

if 0
    file='O:\harms1\harms3_lesionfill\templates\AVGT.nii'
    fileout='O:\harms1\harms3_lesionfill\templates\allemask.nii'
    thresh='>50';
end

[ha a  xyz xyzind]=rgetnii(file);
str=['b=a' thresh ';'];
eval(str);

d=b.*nan;
for i=1:size(b,2)
    c=squeeze(b(:,i,:));
    c=imfill(c,'holes');
    d(:,i,:)=c;
end

e=d;
for i=1:size(e,3)
    e(:,:,i)=medfilt2(e(:,:,i));
end



rsavenii(fileout,ha,e,[2 0]);
