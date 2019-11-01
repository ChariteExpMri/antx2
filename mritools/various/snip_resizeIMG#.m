

return
%resize image to isovox .1mm

[bb vox]=world_bb('s20150908_FK_C1M01_1_3_1.nii')
resize_img3('s20150908_FK_C1M01_1_3_1.nii', [.1 .1 .1], bb, [],1,'b', dt)



[bb vox]=world_bb('cdti_template_highRes.nii')
resize_img3('cdti_template_highRes.nii', [.07 .07 .07], bb, [],1,...
    'h',[8 0])
