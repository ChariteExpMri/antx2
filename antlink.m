
%% link ANTx2-TOOLBOX
% antlink or antlink(1) to setpath of ANT-TBX
% antlink(0) to remove path of ANT-TBX

function antlink(arg)

if exist('arg')~=1
    arg=1;
end
paprev=pwd;
if arg==1 %addPath
    pa=pwd;
    addpath(pa);
    addpath((fullfile(pa,'spm12')));
    spm('defaults', 'FMRI');
   addpath((fullfile(pa,'spm12','matlabbatch')))

    cd(fullfile(pa,'mritools'));
    dtipath;
    cd(pa)
    disp('..ANTx2 - paths set (type "antlink(0) to remove paths")');
    showlastpath;
    
elseif arg==0  %remove path
    try
        warning off
        dirx=fileparts(fileparts(fileparts(which('ant.m'))));
        rmpath(genpath(dirx));
        disp('..[ANTx2] removed from matlab path ');
        cd(dirx);
    end
end


%% gest last path

function showlastpath
pwnow=pwd;

try
    a=preadfile2(fullfile(prefdir,'matlab.settings'));
    
    i0=regexpi2(a,'<settings name="currentfolder">');
    i1=regexpi2(a,' <key name="History">');
    i2=regexpi2(a,' </key>');
    i2=i2(min(find(i1<i2)));
    ip=regexpi2(a,'<value><![CDATA[');
    
    ps=find(ip>i1 & ip<i2);
    
    pw=a(ip(ps));
    pw=regexprep(pw,{'.*[CDATA[',']]></value>'}, '');
    pw(regexpi2(pw, 'antx2'))=[];
    pwlast=pw{1};
    
    disp(['<a href="matlab: cd(''' pwlast ''');">' ['Go Back To:'  ] '</a>' ' ' pwlast ]);
    disp(['<a href="matlab: ant;">' ['open ANTx2-GUI'  ] '</a>' ' '  ]);
end





