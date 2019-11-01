



C:\Programme\mricron\mricron.exe
 start mricron .\templates\ch2.nii.gz -c -0 -l 20 -h 140 -o .\templates\ch2bet.nii.gz -c -1 10 -h 130
 
 
 a='C:\Programme\mricron\mricron.exe '
 b='c:\Programme\mricron\templates\ch2.nii.gz -c -0 -b 60 -o '
 c='C:\Programme\mricron\templates\ch2bet.nii.gz -c -1  -t 50 -o  '
 d='C:\Programme\mricron\templates\aal.nii.gz -c -2 '

eval(['system('''  [a b c d]  ' &'')'] )

% -----------------------------------
pa='V:\MRI_testdata\T2w_nifti\s20150908_FK_C1M02_1_3_1'
f1=fullfile(pa, 's20150908_FK_C1M02_1_3_1.nii')
f2=fullfile(pa, 'c1s20150908_FK_C1M02_1_3_1.nii')
f3=fullfile(pa, 'c2s20150908_FK_C1M02_1_3_1.nii')

 a=['C:\Programme\mricron\mricron.exe ']
 b=[f1 ' -c -0 -b 60 -o ']
 c=[f2 ' -c -1  -t 50 -o  ']
 d=[f3 ' -c -2 ']

eval(['system('''  [a b c d]  ' &'')'] )

% mouse_axial_2x2x28.ini

e=' -m C:\Programme\mricron\multislice\mouse_axial_2x2x28.ini'
e=' -m '
eval(['system('''  [a b c d e]  ' &'')'] )


% -----------------------------------
% b=[fullfile(ovl.paths{ovl.n},ovl.img1) ]
c=[' -c -0 -l 20 -h 140 -b 60 -o ']
d=[ovl.img2 ]
e=[' -c -1 10 -h 130 ']
eval(['system('''  [a b c d e]  ' &'')'] )
a='C:\Programme\mricron\mricron.exe '
b=[fullfile(ovl.paths{ovl.n},ovl.img1) ]
c=[' -c -0 -b 60 -o ']
d=[ovl.img2 ]
e=[' -c ']
eval(['system('''  [a b c d e]  ' &'')'] )
a='C:\Programme\mricron\mricron.exe '
b=[fullfile(ovl.paths{ovl.n},ovl.img1) ]
c=[' -c -0 -b 60 -o ']
d=[ovl.img2 ]
e=[' -c ']
eval(['system('''  [a b c d e]  ' &'')'] )