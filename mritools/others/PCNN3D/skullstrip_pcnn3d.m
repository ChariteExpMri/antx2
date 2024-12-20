
function sfile=skullstrip_pcnn3d(t2file, fileout,  mode,params   )
sfile=[];
% params:  params.species {'mouse', 'rat'}; if not specified, mouse is used


if 0
    
    skullstrip_pcnn3d(fullfile(pwd,'t2_aa.nii'), fullfile(pwd, '_test1.nii' ),  'mask'   )
    skullstrip_pcnn3d(fullfile(pwd,'t2_aa.nii'), fullfile(pwd, '_test2.nii' ),  'skullstrip'   )
end

warning off;

% tmpfile=fullfile(fileparts(t2file),'__temp4skullstrip.nii')
% copyfile(t2file,tmpfile,'f')
% spm_reslice(tmpfile)
[bb vox]=world_bb(t2file);
% outfile=resize_img5(imname,outname, Voxdim, BB, ismask, interpmethod, dt)

% [ha a]=rgetnii('T2.nii');
[ha a]=         rgetnii(t2file);

% ==============================================
%%   mouse/rat params
% ===============================================

pmouse.species      ='mouse';
pmouse.brainSize    = [100 550]; %c57/B6- mouse
pmouse.scalefactor  = [1];

pmouse.species      ='rat';
prat.brainSize      = [300 500 ]; %rat but scaled via scalefactor
prat.scalefactor    = (5.^(1/3)) ;  % --> 5.^(1/3) % rat 5 times larger than mouse

shrew.species      ='etruscianshrew';
shrew.brainSize    = [55 80]; %shrew
shrew.scalefactor  = [1];


if exist('params')~=1
    pp=pmouse;
else
    if isfield(params,'species') && strcmp(params.species,'rat')
        pp=prat;
    elseif isfield(params,'species') && strcmp(params.species,'etruscianshrew')
        pp=shrew;    
    elseif isfield(params,'species') && strcmp(params.species,'mouse')
        pp=pmouse;
    elseif isfield(params,'species') && strcmp(params.species,'hamster')
        pp.species      = params.species;
        pp.brainSize    = [500 1300]; %
        pp.scalefactor  = [1];
    elseif isfield(params,'species') && strcmp(params.species,'piglet4w')
        pp.species      = params.species;
        pp.brainSize    = [50e3 65e3]; %[60e3 65e3];
        pp.scalefactor  = [1];
        pp.resizeFactor =  3 ;%resize brain by this factor, for faster extraction --> i.e. working on smaller image 
    else
        %warning('### unknown species ### --> ') ;
        pp=pmouse;
    end
end

% disp(['skullstripping with parameters of [' pp.species ']']);
% brainSize=  [100 550]; %c57/B6- mouse
% brainSize=  [2200 2800]; %rat
% % % % % % % % % if 0
% % % % % % % % %     disp('use CD1');
% % % % % % % % %     brainSize=  [100 500];%CD1(31)
% % % % % % % % % end
if isfield(pp,'resizeFactor')==0 
    pp.resizeFactor=0;
end
    
% ==============================================
%%   resize image for faster segmentation
% ===============================================
if pp.resizeFactor~=0
    pp.t2file_orig = t2file;
    [bb2 vox1 ]    = world_bb(t2file);
    vox2           = vox1*pp.resizeFactor;
    t2file_small   = fullfile(fileparts(t2file), 't2_small.nii')
    resize_img5(t2file,t2file_small, vox2, bb, [], 1, 16);
    pp.t2file_small=t2file_small;
    %showinfo2('small file:',t2file_small);
    
    
    t2file   =t2file_small;      %replace filename
    [bb vox] =world_bb(t2file); %get vox and BB
    [ha a]   =rgetnii(t2file);   %load data
end



%=============================================
%%   cd1
%=============================================

%niter        = 100;
radelem      = 4;
vdim         = abs(vox);%abs(diag(ha.mat(1:3,1:3))');
vdim2        = vdim/pp.scalefactor;
brainSize    = pp.brainSize;

%[I_border, gi] = PCNN3D(  a , 4  , vdim, brainSize );
iserror=0;
try
    [args ,I_border, gi] =  evalc('PCNN3D(  a , radelem  , vdim2, brainSize );');
    iserror=0;
    %get Guess for best iteration.
    ix  = strfind(args,'Guess for best iteration is ');
    ix2 = strfind(args,'.');
    ank = ix2(min(find(ix2>ix)));
    id  = str2num(regexprep(args(ix:ank-1),'\D',''));
    sprintf('brainvolume: %2.2f [qmm]: ' ,gi(id));
    
catch
    iserror=1 ;
end
if iserror==1
    try
        % [args ,I_border, gi] =  evalc(['PCNN3D(  a , ' num2str(radelem-1) '  , vdim2, brainSize );']);
        [args ,I_border, gi] =  evalc(['PCNN3D(  a , ' num2str(radelem-1) '  , vdim2, brainSize );']);
        iserror=0;
        %get Guess for best iteration.
        ix  = strfind(args,'Guess for best iteration is ');
        ix2 = strfind(args,'.');
        ank = ix2(min(find(ix2>ix)));
        id  = str2num(regexprep(args(ix:ank-1),'\D',''))-2;
        sprintf('brainvolume: %2.2f [qmm]: ' ,gi(id));
        
    catch
        iserror=1;
    end
end


if iserror==1
    err=lasterr;%lasterror;
    errmsg={ ...
        ['         *** ERROR ***'   ]
        ['STEP              : scullstripping [' mfilename '.m]'  ]
        ['INPUT             : ' t2file ]
        ['ERROR             : ' err]
        ['Potential SOLUTION: '        sprintf('  VOXEL-size: [%2.2f %2.2f %2.2f] mm ..check voxelsize (might be to large)',vdim)
        ]        };
    error([strjoin(errmsg,char(10))]);
    % rethrow(lasterror)
end

% disp(args);

% %get Guess for best iteration.
% ix  = strfind(args,'Guess for best iteration is ');
% ix2 = strfind(args,'.');
% ank = ix2(min(find(ix2>ix)));
% id  = str2num(regexprep(args(ix:ank-1),'\D',''));
% sprintf('brainvolume: %2.2f [qmm]: ' ,gi(id));

if 0
    gi(find(gi<brainSize(1) | gi>brainSize(2)))=nan  ;%set nan outside brainsize
    id=  find(diff(gi)==nanmin(diff(gi))); %find plateau
    id=min(id);
end

r=I_border{id};
% r=I_border{35}
for i=1:length(r)
    b=full(r{i});
    if i==1; x=zeros(size(a));end
    x(:,:,i)=b;
end

if strcmp(mode, 'mask')
    m=x;
elseif strcmp(mode, 'skullstrip')
    m=x.*a;
end


rsavenii(fileout,ha,m);

% ============================================================
%%  back-resizeing image when used faster segmentation 
% =============================================================
if pp.resizeFactor~=0
    
    rreslice2target(fileout, pp.t2file_orig, fileout, 1,16)
    %[hq q  ] =rgetnii(pp.t2file_orig);
    %[hq2 q2] =rgetnii(fileout);
    try; delete(pp.t2file_small); end
    
end
% ==============================================
%%   
% ===============================================
close(gcf);
sfile=fileout;
