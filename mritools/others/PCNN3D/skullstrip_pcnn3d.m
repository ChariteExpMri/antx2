
function skullstrip_pcnn3d(t2file, fileout,  mode,params   )

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

if exist('params')~=1
    pp=pmouse;
else
    if isfield(params,'species') && strcmp(params.species,'rat')
        pp=prat;
    elseif isfield(params,'species') && strcmp(params.species,'mouse')
        pp=pmouse;
    else
        %warning('### unknown species ### --> ') ;
        pp=pmouse;
    end
end





% brainSize=  [100 550]; %c57/B6- mouse
% brainSize=  [2200 2800]; %rat
% % % % % % % % % if 0
% % % % % % % % %     disp('use CD1');
% % % % % % % % %     brainSize=  [100 500];%CD1(31)
% % % % % % % % % end


%=============================================
%%   cd1
%=============================================

%niter        = 100;
radelem      = 4;
vdim         = abs(vox);%abs(diag(ha.mat(1:3,1:3))');
vdim2        = vdim/pp.scalefactor;
brainSize    = pp.brainSize;

%[I_border, gi] = PCNN3D(  a , 4  , vdim, brainSize );
[args ,I_border, gi] =  evalc('PCNN3D(  a , radelem  , vdim2, brainSize );');

% disp(args);

%get Guess for best iteration.
ix  = strfind(args,'Guess for best iteration is ');
ix2 = strfind(args,'.');
ank = ix2(min(find(ix2>ix)));
id  = str2num(regexprep(args(ix:ank-1),'\D',''));
sprintf('brainvolume: %2.2f [qmm]: ' ,gi(id));

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


% rsavenii('_msk',ha,m);
rsavenii(fileout,ha,m);
close(gcf);


