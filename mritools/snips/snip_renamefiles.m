

paout='C:\Users\skoch\Desktop\masks\maskandHemisphere20'


pain='V:\projects\atlasRegEdemaCorr\nii20'
%% hemisphere
k=rdir([fullfile(pain, '**\hemisphere.nii') ])
for i=1:length(k)
    oldname=k(i).name;
    [pa fi ext]=fileparts(oldname);
 [pa2 fi2]=fileparts(pa);

       nameshort= regexprep(fi2,'^\w','') ;
        usc= strfind(nameshort,'_') ;
        nameshort=        nameshort(1:usc(3)-1);
        newname=[nameshort '_hemispheres_mask.nii'];
        
        copyfile(oldname, fullfile(paout,newname));
end

%% lesion


k=rdir([fullfile(pain, '**\mask.nii') ])
for i=1:length(k)
    oldname=k(i).name;
    [pa fi ext]=fileparts(oldname);
 [pa2 fi2]=fileparts(pa);

       nameshort= regexprep(fi2,'^\w','') ;
        usc= strfind(nameshort,'_') ;
        nameshort=        nameshort(1:usc(3)-1);
        newname=[nameshort '_lesion_total_mask.nii'];
        
        copyfile(oldname, fullfile(paout,newname));
end