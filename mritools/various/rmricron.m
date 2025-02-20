
function  rmricron(pa,tmp,ovl,cols, trans)
%% use MRICRON to overlay images  (win,mac,linux)
% ..for MAC no overlay possible,only the 1st volume is displayed
% function rmricron(pa,tmp,ovl,cols, trans)
%  rmricron(pa,tmp,ovl,cols, trans)
%  pa : path
%  tmp : template (without path)
%  ovl: overlaying images (struct, without path)
%  cols: colors =numeric idx from pulldown LUT in mricron
%  trans: 2 values: transparency background/overlay & transperancy between overlays
%% example
% pa='V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1'
% tmp='_AwAVGT.nii'
% ovl={...
% 'H_wc1T2_left.nii'
% 'H_wc1T2_right.nii'
% 'H_wc2T2_right.nii'
% 'H_wc2T2_left.nii'
% }
% cols=[ 2 2 1 1  ];
% trans=[20 -1]
%  rmricron(pa,tmp,ovl,cols, trans)
%% EXAMPLE-2
% rmricron('O:\data3\hedermanip\dat\M_2', 't2.nii',{'masklesion.nii'} , 2,[20 -1])
%% EXAMPLE-3
% rmricron([],'O:\data3\hedermanip\dat\M_2\t2.nii','O:\data3\hedermanip\dat\M_2\hemi.nii' , 2,[20 -1])
%% EXAMPLE-4
% rmricron([],fullfile(pwd,'AVGT.nii'))
%% MAC
%  MAC uses mricroGL
% 4th arg is color defined as string or number see mricroGL
%  example:
% f1 ='/Volumes/M/data4/macTest/dat/mo75/t2.nii'
% f2 ='/Volumes/M/data4/macTest/dat/mo75/c1t2.nii'
% rmricron([],f1,f2,5)
% rmricron([],f1,f2,'1hot')
% rmricron([],fullfile(pwd,'AVGT.nii'),fullfile(pwd,'AVGTmask.nii'),'actc',.5)
% rmricron([], 'AVGT.nii','AVGTmask.nii','actc')

if exist('ovl'  )~=1; ovl  =''; end
if exist('col'  )~=1; col  =''; end
if exist('trans')~=1; trans=''; end


status=0;

if 0
    pa='V:\projects\atlasRegEdemaCorr\niiSubstack\s20150908_FK_C1M01_1_3_1_1'
    tmp='_AwAVGT.nii'
    ovl={...
        'H_wc1T2_left.nii'
        'H_wc1T2_right.nii'
        'H_wc2T2_right.nii'
        'H_wc2T2_left.nii'
        }
    cols=[ 2 2 1 1  ];
    trans=[20 -1]
    rmricron(pa,tmp,ovl,cols, trans)
end




%   start mricron .\templates\ch2.nii.gz -c -0 -l 20 -h 140 -o .\templates\ch2bet.nii.gz -c -1 10 -h 130
% color:   "-c bone",  "-c 0",  gray, -c 1 is red...

% start /MAX c:\mricron\mricron

% clim: -l  and -h for lower/upper value
% trasnparency of overlays:            -b :   -1, 0:20:100,   -1=addititive
% trasnparency between overlays:  -t :   -1, 0:20:100,   -1=addititive


%   H_wmask2_left.nii
% H_wT2_left.nii        H_whemi2_left.nii
% H_wT2_right.nii       H_whemi2_right.nii

% pa='V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1'
% ovl={...
% 'H_wc1T2_left.nii'
% 'H_wc1T2_right.nii'
% 'H_wc2T2_right.nii'
% 'H_wc2T2_left.nii'
% }
% tmp='_AwAVGT.nii'


tmp=char(fullpath(pa,tmp));
% ======== MAC ============================
if ismac
    pa_mricrongl=fullfile((fileparts(fileparts(fileparts(which('ant.m'))))),'mricron','MRIcroGL.app/Contents/MacOS/MRIcroGL');
    k=dir(fullfile(fileparts(fileparts(pa_mricrongl)),'Resources','lut' ,'*.clut'));
    lutlist={k(:).name}' ;
    lutlist(regexpi2(lutlist,'^._'))=[];
    lutlist=regexprep(lutlist,'.clut','');
    iactc=find(strcmp(lutlist,'actc'));
    ioth=13;
    nameoth=lutlist(ioth);
    lutlist{iactc}=nameoth;
    lutlist{ioth}='actc';
    
    if exist('cols')==0; cols=1; end
    
    if isnumeric(cols)
        if cols==0; 
            lutname='actc';
        else
        lutname=char(lutlist(cols));
        end
    else
        lutname=cols;
    end
    
%     lutname='actc';
    if ~isempty(trans)
       if trans<=1
           trans=trans*100;
       end 
    else
        trans=50;
    end
    
    
    if isempty(ovl)
        %f1=tmp;
        %vm=[pa_mricrongl ' -S "begin LOADIMAGE(''' f1 ''');ORTHOVIEW(0.5,0.5,0.5);COLORNAME(''Grayscale'');end."'];
        %system([vm ' &']);
        f1=tmp;
        cm={['import gl']
            ['gl.loadimage("'   f1 '")']
            };
        cm2=strjoin(cm,';');
        cmd=([pa_mricrongl ' -s ''' cm2 ''' &']);
        system(cmd);       
    else
        f1=tmp;
        f2=ovl;
        cm={['import gl']
            %['gl.resetdefaults()']
            ['gl.loadimage("'   f1 '")']
            ['gl.overlayload("' f2 '")']
            %['gl.colorname(2, "actc")' ];
            ['gl.colorname (0,"grayscale")']
            ['gl.colorname (1,"' lutname '")']
            ['gl.opacity(1,' num2str(trans) ')']
            };
        cm2=strjoin(cm,';');
        cmd=([pa_mricrongl ' -s ''' cm2 ''' &']);
        system(cmd);
    end
    
    return
end

% ==============================================
%%   win
% ===============================================


% trans=[20 -1]
% col={ 'r'  '1'
%     'b'  '2'
%     'g'  '3'
%     'v'  '4'
%     'y'  '5'
%     'c' '6'
%     }
if exist('cols')==0
    cols=0;
end

if isempty(ovl);  
    o=''; ;
else
    ov=fullpath(pa,ovl);
    if ischar(ov)
        ov=cellstr(ov);
    end
    
    
    % cols=[ 2 2 1 1  ]% 2 2]
    if ischar(cols)
        cols2={[' -c ' cols '.lut']};
    else
        cols2=[];
        for i=1:length(ov)
            cols2{i,1}=[' -c -' num2str(cols(i)) ' '];
        end
    end
    ov2=cellfun(@(a,b) [' -o ' a b] ,ov,cols2,'UniformOutput',0);
    o = reshape(char(ov2)',   1,  []);
    
end

if isempty(trans)
    btrans='';
    ttrans='';
else
    btrans=[' -b ' num2str(trans(1)) ];
    ttrans=['  -t ' num2str(trans(2)) ];
end

if ispc
    %     call='!start ';
    %     endtag='';
    
    call='';
    endtag=' &';
else
    call='!mricron ';
    endtag=' &';
end

% mri=[call 'c:\mricron\mricron ';];
% mri=[call '/MAX c:\mricron\mricron ';];

if ispc
    exefile=fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','mricron.exe' );
    if exist(exefile)==2
        call=[call  exefile  ' '];
    end
    [status]= system([call   tmp   o  btrans ttrans endtag]);
    return
    
    
end

if exist(tmp)~=2
    tmp=fullfile(pa, '_AwAVGT.nii');
end



c=[call   tmp   o  btrans ttrans endtag];
eval(c);



% !start o:\antx\mricron\mricron.exe o:\antx\mritools\ant\templateBerlin_hres\sAVGT.nii -o O:\data\voxelwise_Maritzen4tool\bla2.nii -c -3  -b 20  -t -13



% !start c:\mricron\mricron V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\_AwAVGT.nii -o V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\H_wc1T2_right.nii -c - 4  -o V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\H_wc2T2_right.nii -c - 1  -b -50  -t - 50


%
% !start c:\mricron\mricron V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\_AwAVGT.nii -o V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\H_wc1T2_right.nii -c -6 -b -50
% -o V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\H_wc2T2_right.nii -c 1  -b 50 -t 50
%
%
% !start c:\mricron\mricron V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\_AwAVGT.nii -o V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\H_wc1T2_right.nii -c 4  -o V:\projects\atlasRegEdemaCorr\nii\s20150908_FK_C1M04_1_3_1_1\H_wc2T2_right.nii -c 1  -b 50 -t 50
%
%
%
% % mri='!start /MAX c:\mricron\mricron'
% mri='!start c:\mricron\mricron '
% tmp=fullfile(pa, '_AwAVGT.nii')
% f1=fullfile(pa, 'H_wT2_left.nii')
% f1=ov{1}
% box=[' -o ' f1 ]
%
% c=[mri   tmp box ]
%  eval(c)
%
%
%


function lutname=lutcol(num)

col={ ...
    'Grayscale'
    'Red'
    'Green'
    'Blue'
    'Violet [r+b]'
    'Yellow [r+g]'
    'Cyan  [g+b]'
    '1hot'
    '2winter'
    '3warm'
    '4cool'
    '5redyell'
    '6bluegrn'
    'actc'
    'bone'
    'carp'
    'CT_Bones'
    'CT_Kidneys'
    'CT_Liver'
    'CT_Lungs'
    'CT_Muscles'
    'CT_Skin'
    'CT_Soft_Tissue'
    'CT_Vessels'
    'electric_blue'
    'GE_color'
    'gold'
    'HOTIRON'
    'jet'
    'MR_scalp'
    'MR_surface'
    'powersurf'
    'Rainramp'
    'random'
    'red_yellow'
    'revactc'
    'surface'
    'x_rain' };


lutname=col{num+1};




