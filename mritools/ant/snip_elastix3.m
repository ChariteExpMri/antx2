
 Now, if I want to apply what the manual says in section 6.1.6, it is not clear to me if I have to change the fixed and moving image?
For the inversion procedure it's best to set the original fixed image
both as the fixed and moving image!
the transformation I set with -t0 how should it be?
in your example, when you have an affine and bspline transformation
written to <outputdir>, TransformParameters.1.txt contains the resulting
transformation from the registration, so to invert it:
elastix -to outputdir/TransformParameters.1.txt -f fixedimage -m
fixedimage -p inversionparameterfile.txt -out inversionoutdir
In the inversionparameterfile.txt you should set the
DisplacementMagnitudePenalty as metric.
The result of this inversion is
inversionoutdir/TransformParameters.0.txt. This file you should edit, by
replacing the InitialTransformParameterFileName by "NoInitialTransform".
Hope this helps. Let us know if you have any further questions.
Kind regards,
Stefan 

fun0=['!' which('elastix.exe')]
fixIM=[  'O:\harms1\koeln\dat\s20150701_AA1\templateGMWM.nii']

p1='V:\mritools\elastix\paramfiles\Par0025affine.txt'
p2='V:\mritools\elastix\paramfiles\Par0033bspline_EM2.txt'
pp      =[' -p '  p1  ' -p '  p2]
t0   =


do=[fun0  to [' -f '  fixIM ] [' -m '  fixIM ]  pp  [' -out ' outfoldinv ] ]

outdir
O:\harms1\koeln\dat\s20150701_AA1\out9_KopieINV

params
V:\mritools\elastix\paramfiles\Par0025affine.txt     
V:\mritools\elastix\paramfiles\Par0033bspline_EM2.txt

coef
O:\harms1\koeln\dat\s20150701_AA1\out9_Kopie\TransformParameters.1.txt
O:\harms1\koeln\dat\s20150701_AA1\out9_Kopie\TransformParameters.0.txt


%% forward
% transformix -in result.1.nii -tp TransformParameters.0.txt -out
fun1=['!'       which('transformix.exe') ]
in=[' -in '       which('t2.nii')]
tp=[' -tp '      'O:\harms1\koeln\dat\s20150701_AA1\out9\TransformParameters.1.txt' ]
outw=[ fullfile(pwd,'outwarFORWARD')]; mkdir(outw) ; outw=[' -out ' outw]
do2=[fun1 in tp outw]
eval(do2)


%••••••••••••••••••••••••••••••  inverse  ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
fun0=['!' which('elastix.exe')]
% fixIM=[  'O:\harms1\koeln\dat\s20150701_AA1\templateGMWM.nii']
% fixIM=[  'O:\harms1\koeln\dat\s20150701_AA1\templateGMWM.nii']
fixIM=fullfile(pwd,'mouseGMWM.nii')
outfoldinv=fullfile(pwd,'outinv'); mkdir(outfoldinv)
outfold=fullfile(pwd,'out9');
to=[' -to '  fullfile(outfold,'TransformParameters.1.txt') ]


p1='V:\mritools\elastix\paramfiles\Par0025affine.txt'
p2='V:\mritools\elastix\paramfiles\Par0033bspline_EM2.txt'
 pp      =[' -p '  p1  ' -p '  p2]
%pp      =[' -p '  p2  ' -p '  p1]


do=[fun0  to [' -f '  fixIM ] [' -m '  fixIM ]  pp  [' -out ' outfoldinv ] ]
eval(do)

% elastix -to outputdir/TransformParameters.1.txt -f fixedimage -m
% fixedimage -p inversionparameterfile.txt -out inversionoutdir 

% (InitialTransformParametersFileName "NoInitialTransform")
% (Metric "DisplacementMagnitudePenalty")


%••••••••••••••••••••••••••••••  apply inverse  ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

% transformix -in result.1.nii -tp TransformParameters.0.txt -out
fun1=['!'       which('transformix.exe') ]
in=[' -in '       which('sAVGT.nii')]
tp=[' -tp '      'O:\harms1\koeln\dat\s20150701_AA1\outinv\TransformParameters.1.txt' ]
outw=[ fullfile(pwd,'outwarpedinv')]; mkdir(outw) ; outw=[' -out ' outw]
do2=[fun1 in tp outw]
eval(do2)




%••••••••••••••••••••••••••••••  melastix inverse  ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

t0=' -t0 O:\harms1\koeln\dat\s20150701_AA1\out9_Kopie\TransformParameters.1.txt t0 O:\harms1\koeln\dat\s20150701_AA1\out9_Kopie\TransformParameters.0.txt'
pp=' -p V:\mritools\elastix\paramfiles\Par0025affine.txt -p V:\mritools\elastix\paramfiles\Par0033bspline_EM2.txt'

fun0=['!' which('elastix.exe')]
% fixIM=[  'O:\harms1\koeln\dat\s20150701_AA1\templateGMWM.nii']
% fixIM=[  'O:\harms1\koeln\dat\s20150701_AA1\templateGMWM.nii']
fixIM=fullfile(pwd,'mouseGMWM.nii')
outfoldinv=fullfile(pwd,'outinv'); mkdir(outfoldinv)
outfold=fullfile(pwd,'out9');
% t0=[' -to '  fullfile(outfold,'TransformParameters.1.txt') ]


p1='O:\harms1\koeln\dat\s20150701_AA1\xPar0025affine.txt'
p2='O:\harms1\koeln\dat\s20150701_AA1\xPar0033bspline_EM2.txt'
%  pp      =[' -p '  p1  ' -p '  p2]
%pp      =[' -p '  p2  ' -p '  p1]
t0=[' -t0 '  'O:\harms1\koeln\dat\s20150701_AA1\out9\TransformParameters.1.txt']

% pp=' -p O:\harms1\koeln\dat\s20150701_AA1\inversionparameterfile.txt'
p1=' -p O:\harms1\koeln\dat\s20150701_AA1\iPar0025affine.txt'
p2=' -p O:\harms1\koeln\dat\s20150701_AA1\iPar0033bspline_EM2.txt'
pp=[p1 p2]
% pp=[' -p '  'O:\harms1\koeln\dat\s20150701_AA1\out9\inversion.txt' ]
do=[fun0  t0 [' -f '  fixIM ] [' -m '  fixIM ]  pp  [' -out ' outfoldinv ] ]
eval(do)

%% inverse apply
fun1=['!'       which('transformix.exe') ]
in=[' -in '       which('sAVGT.nii')]
tp=[' -tp '      'O:\harms1\koeln\dat\s20150701_AA1\outinv\TransformParameters.1.txt' ]
outw=[ fullfile(pwd,'outwarpedinv')]; mkdir(outw) ; outw=[' -out ' outw]
do2=[fun1 in tp outw]
eval(do2)

% !V:\mritools\elastix\elastix_windows64_v4.7\elastix.exe -t0 O:\harms1\koeln\dat\s20150701_AA1\out9\TransformParameters.1.txt -f O:\harms1\koeln\dat\s20150701_AA1\mouseGMWM.nii -m O:\harms1\koeln\dat\s20150701_AA1\mouseGMWM.nii -p O:\harms1\koeln\dat\s20150701_AA1\out9\ inversion.txt -out O:\harms1\koeln\dat\s20150701_AA1\outinv



