

% #k COPIES FILES (NIFTI and aux. files) from reference system to the studie's
% #k "templates" folder 
%  * NIFTIS will be resliced depending on the desired voxel size
%  * project file (proj*.m) has do be created before
% ___________________________________________________________________________
% #r NOTE: This step is usually performed during the warping-procedure. However,
% #r sometimes it is necessary to create the templates before the normalization step.
% #r For example, the orientation of the imput image (t2.nii) is unclear and one has to
% #r determine the matching rotation parameter
% ___________________________________________________________________________
% #g commandline alternative
%   antcb('copytemplates');               % copy nonexisting files to template folder (default)            
%   antcb('copytemplates','overwrite,1);  % force to overwrite existing files                              
%

function  t=xcreatetemplatefiles2(s,forcetooverwrite)

%% create templateFolder
patpl=s.templatepath;
if exist(patpl)~=7; mkdir(patpl); end


% .             AVGT.nii      _b2white.nii  sANO.nii      
% ..            AllenMip.mat  _b3csf.nii    sAVGT.nii     
% ANO.nii       FIBT.nii      parameter.m   sFIBT.nii     
% ANO.xls       _b1grey.nii   readme.txt    
s.avg=fullfile(s.refpath,'AVGT.nii');
s.ano=fullfile(s.refpath,'ANO.nii');
s.fib=fullfile(s.refpath,'FIBT.nii');

s.refTPM={...
    fullfile(s.refpath,'_b1grey.nii')
    fullfile(s.refpath,'_b2white.nii')
    fullfile(s.refpath,'_b3csf.nii')};

%% --------------------------------------------------------------------AVGT.nii------------------
f1=s.avg;
f2       =fullfile(patpl,'AVGT.nii');
t.avg=f2;
if any([~exist(f2,'file')  forcetooverwrite])==1
    disp(['generate: ' f2]);
    
    %check for lowres-image and if voxseize is default
    f1small=stradd(f1,'s',1);
    if (exist(f1small)==2) && (all(s.voxsize==repmat(0.07,1,3))==1)
        f1=f1small;
    end
    
   
    [BB, vox]   = world_bb(f1);
    resize_img5(f1,f2, s.voxsize , BB, [], 1,[64 0]);

end
refimage=f2;
%% --------------------------------------------------------------------AVGTmask.nii------------------
%% AVGTmask.nii
avgtmask=fullfile(fileparts(f2),'AVGTmask.nii');
t.avgmask=avgtmask;
if any([~exist(t.avgmask,'file')  forcetooverwrite])==1
    f1 = fullfile(fileparts(s.avg), 'AVGTmask.nii');
    f2 = fullfile(patpl           , 'AVGTmask.nii');
    
    if exist(f1)==2                            % 'AVGTmask.nii' is defined
        rreslice2target(f1, refimage, f2, 0,[2 0]);
    else     
        makeMaskT3m(refimage, avgtmask , '>30');
    end
end
%% --------------------------------------------------------------------AVGThemi-------------------
%% AVGThemi.nii
f1 = fullfile(fileparts(s.avg), 'AVGThemi.nii');
f2 = fullfile(patpl           , 'AVGThemi.nii');
t.avgthemi = f2;

if any([~exist(f2,'file')  forcetooverwrite])==1
    if exist(f1)==2
        rreslice2target(f1, refimage, f2, 0,[2 0]);
    else
        %% ANO-MOUSE-BEFORE UPDATE
        %keyboard
        fout=makeAVGThemi(avgtmask); %make AVGThemi.nii based on AVGTmask.nii
    end
end

%% -------------------------------------------------------------------------ANO------------------
f1=s.ano;
f2       =fullfile(patpl,'ANO.nii');
t.ano=f2;
if any([~exist(f2,'file')  forcetooverwrite])==1
    disp(['generate: ' f2]);
     %check for lowres-image and if voxseize is default
     f1small=stradd(f1,'s',1);
     if (exist(f1small)==2) && (all(s.voxsize==repmat(0.07,1,3))==1)
         f1=f1small;
     end
    rreslice2target(f1, refimage, f2, 0,[64 0]);
end

%% ------------------------------------------------------------------------ANO-atlasLabels-------------------
atlab={...
    fullfile(fileparts(s.avg),'ANO.xls')
    fullfile(fileparts(s.avg),'ANO.xlsx')
    };
ilab =max(find([exist(atlab{1}) exist(atlab{2})]==2));
if ~isempty(ilab)
    f1       =atlab{ilab};
    f2       =replacefilepath(f1,patpl);
    try; copyfile(f1,f2,'f');end
end

%% ------------------------------------------------------------------------FIBT-------------------
f1=s.fib;
f2       =fullfile(patpl,'FIBT.nii');
t.fib=f2;
if any([~exist(f2,'file')  forcetooverwrite])==1
    if exist(f1)==2  %ONLY IF FIB EXISTs
        disp(['generate: ' f2]);
        
        %check for lowres-image and if voxseize is default
        f1small=stradd(f1,'s',1);
        if (exist(f1small)==2) && (all(s.voxsize==repmat(0.07,1,3))==1)
            f1=f1small;
        end
        
        rreslice2target(f1, refimage, f2, 0,[64 0]);
    end
end

%-------------------------------------------------------------------------------------------
%% TPMS
%-----------------------------------------------------------------------grey--------------------
f1=s.refTPM{1};
f2       =fullfile(patpl,'_b1grey.nii');
t.refTPM{1,1}=f2;
if any([~exist(f2,'file')  forcetooverwrite])==1
    disp(['generate: ' f2]);
    rreslice2target(f1, refimage, f2, 0);
end
%% ------------------------------------------------------------------------white-------------------
f1=s.refTPM{2};
f2       =fullfile(patpl,'_b2white.nii');
t.refTPM{2,1}=f2;
if any([~exist(f2,'file')  forcetooverwrite])==1
    disp(['generate: ' f2]);
    rreslice2target(f1, refimage, f2, 0);
end
%% ------------------------------------------------------------------------csf-------------------
f1=s.refTPM{3};
f2       =fullfile(patpl,'_b3csf.nii');
t.refTPM{3,1}=f2;
if any([~exist(f2,'file')  forcetooverwrite])==1
    disp(['generate: ' f2]);
    rreslice2target(f1, refimage, f2, 0);
end
%-------------------------------------------------------------------------------------------
% %% others
% if s.create_gwc==1
%     ano=fullfile(patpl,'ANO.nii');
%     fib=fullfile(patpl,'FIBT.nii');
%     f2=fullfile(patpl,'GWC.nii');
%     t.gwc=f2;
%     if any([~exist(f2,'file')  forcetooverwrite])==1
%         disp(['generate: ' f2]);
%         xcreateGWC( ano,fib,  f2 );
%     end
% end
%-------------------------------------------------------------------------------------------
if isfield(s,'create_anopcol')==1
    if s.create_anopcol==1
        ano=fullfile(patpl,'ANO.nii');
        f2=fullfile(patpl,'ANOpcol.nii');
        t.anopcol=f2;
        if any([~exist(f2,'file')  forcetooverwrite])==1
            disp(['generate: ' f2]);
            [ha a]=rgetnii(ano);
            % pseudocolor conversion
            reg1=single(a);
            uni=unique(reg1(:));
            uni(find(uni==0))=[];
            reg2=reg1.*0;
            for l=1:length(uni)
                reg2=reg2+(reg1==uni(l)).*l;
            end
            rsavenii(f2,ha,reg2,[4 0]);
        end
    end
end


%-------------------------------------------------------------------------------------------
% f1=fullfile(fileparts(f1),'_sample2.nii');
% f2       =fullfile(patpl,'_sample.nii');
% t.sample=f2;
% if any([~exist(f2,'file')  forcetooverwrite])==1
%     disp(['generate: ' f2]);
%     rreslice2target(f1, refimage, f2, 0,[2 0]);
% end




