% changes Field of fiew in DCMdata
% current state: increase of FOV possible
function DCM_changeFOV(showgui,x,pa)

clc
if 0
    z=[];
 z.dicomDIR     = { 'O:\data4\nii2dicom\input\INPUT_DCM\20190129TJ_d7_rat15_d7_rat15_response__E6_P1'      % % >>select DICOM directories here
  'O:\data4\nii2dicom\input\INPUT_DCM\k2' };

%     z.dicomDIR     = { 'O:\data4\nii2dicom\input\INPUT_DCM\20190129TJ_d7_rat15_d7_rat15_response__E6_P1'      % % >>select DICOM directories here
%        };
    z.fOV          = [42];                                                                                    % % new field of view
    z.nPixeledge   = [10];                                                                                    % % number of pixels in x&y-direction from corners to get median background signal (NpixBGtotal =4corners*nPixeledge*nPixeledge)
    z.interp       = 'nearest';                                                                               % % interpolation order (default: nearest)
    z.outDirPrefix = 'fov42';                                                                                % % prefix of outputfolder
    z.showResult   = [0];                                                                                     % % convert to nifti and shows the result in MRICRON
    DCM_changeFOV(1,z);
    
end


%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                           ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=[]  ;end
if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end




%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  PARAMETER-gui
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if exist('x')~=1;        x=[]; end


p={...
    'inf98'      '* change field of view in DICOM files *'                         '' ''
    'inf100'     '======================================='                          '' ''
    'dicomDIR'    {''}  '>>select DICOM directories here'  {@selectDir,pa}
    
    'fOV'         42        'new field of view'      ''
    'nPixeledge'  10        'number of pixels in x&y-direction from corners to get median background signal (NpixBGtotal =4corners*nPixeledge*nPixeledge)'      ''
    'interp'     'nearest'  'interpolation order (default: nearest)'      {'nearest' 'bilinear' 'bicubic'}
    
    'outDirPrefix'  'fov42'    'prefix of outputfolder' ''
    'showResult'    2           '[0|1|2]: [1|2]show result in MRICRON, [2] more infos, ' {'0' '1' '2' }
    };
p=paramadd(p,x);%add/replace parameter
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .8 .3 ],...
        'title',['PARAMETERS: ' mfilename],'info',{@uhelp, [mfilename '.m']});
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end




% return
%———————————————————————————————————————————————
%%   make batch
%———————————————————————————————————————————————
xmakebatch(z,p, [mfilename ]);





for j=1:size(z.dicomDIR,1)
    runx(z,z.dicomDIR{j})
end
fprintf(['[DONE]\n']);


%———————————————————————————————————————————————
%%   run
%———————————————————————————————————————————————
function runx(z,mdir)


[d2] = spm_select('FPList',mdir,'.*.dcm$'); d2=cellstr(d2);

[mdirup mdirshort ]=fileparts(mdir);
[mdirup2  ]=fileparts(mdirup);

outdir=fullfile(mdirup2,[z.outDirPrefix  ],mdirshort);  %OUTPUT DIR
mkdir(outdir);

%=========== checks

if isempty(z.outDirPrefix)
    z.outDirPrefix='outFOVchange';
end
if isempty(regexpi2({'nearest' 'bilinear' 'bicubic'}, z.interp))
    z.interp='nearest';
end

%=========== FOV
if length(z.fOV)==1;
    fovnew=[z.fOV z.fOV]';
else
    fovnew=[z.fOV(:)];
end

fprintf(['reading DCM''s [' mdirshort '] ']);
for i=1:size(d2,1)
    fprintf('.%d' ,i);
    
    clear x;
    [x ]=dicomread(d2{i});
    hx  =dicominfo(d2{i});
    
    % ============================================================================
    %     if 0
    %         a2=a(:,:,i);
    %         %     cast(a3,'like',x);
    %         val=a2(1,1);
    %
    %
    %         x2=double(x);
    %         dcorn=[...
    %             x2(1:nedge         , 1:nedge)
    %             x2(1:nedge         , end-nedge+1:end)
    %             x2(end-nedge+1:end , 1:nedge)
    %             x2(end-nedge+1:end ,end-nedge+1:end)
    %             ];
    %         medval=round(median(dcorn(:)));
    %
    %         a2(a2==val)=mean(a2(:));
    %         % a2(a2==val)=medval;
    %         a3=flipud(rot90(a2));  %does not change data
    %     end
    % ============================================================================
    % if 0
    %     fg,
    %     subplot(2,2,1);imagesc(x);   title(['dcm frame-' num2str(i) ]); colorbar
    %     subplot(2,2,2);imagesc(a3); title(['NII frame-' num2str(i) ]); colorbar
    % end
    % ============================================================================
    
    
    dim    = [double(hx.Width)  double(hx.Height)]';
    oldvox = double(hx.PixelSpacing);
    fovold = dim.*oldvox; %OLD FOV
    
    newvox = fovnew./dim;
    %vec    = spm_imatrix(ha.mat);
    %newvox = abs(vec(7:8))';
    %fov2=[newvox.*dim]; %NEW FOV
    moveo  = (fovnew-fovold)/2 ;%move origin
    
    
    %=========================
    nedge = z.nPixeledge;
    
    mx=@(a) [min(a(:)) max(a(:))];
    x1=double(x);
    dcorn=[...
        x1(1:nedge         , 1:nedge)
        x1(1:nedge         , end-nedge+1:end)
        x1(end-nedge+1:end , 1:nedge)
        x1(end-nedge+1:end ,end-nedge+1:end)
        ];
    medval=round(median(dcorn(:)));
    
    pad = round((dim-(oldvox./newvox).*dim)/2);
    siz = dim-2*pad;
    
    %pad=round((300-(0.1333/.14)*300)/2); pad=[pad pad]';
    %siz=round(((0.1333/.14)*300)) ;
    
    
    
    x2 = imresize(x1,[siz'],z.interp);
    x3 = padarray(x2,[pad'], medval  );
    x3=round(x3);
    
    a5=int16(x3);
    
%     disp([mx(x) mx(x1) mx(x2) mx(x3) mx(a5)]);
    
    a5(a5<min(x(:)))  =  min(x(:));
    a5(a5>max(x(:)))  =  max(x(:));
    
    
    %=========================
    % copy and replace metadata
    %=========================
    hx2=hx;
    hx2.PixelSpacing = fovnew./dim  ; % which is [42/300 42/300]';
    
    iop    = hx2.ImageOrientationPatient([1 6]);
    fc2    = iop.*moveo;
    newiop = hx.ImagePositionPatient([1 3])-fc2;
    hx2.ImagePositionPatient([1 3]) = newiop;
    
    
    %=========================
    % save DCM
    %=========================
    
    [~,name,ext]=fileparts(d2{i});
    dcmname=[name ext];
    outfi=fullfile(outdir, [dcmname]);
    dicomwrite(a5,outfi, hx2,'CreateMode','copy');
    
    
    
end
fprintf('\n');

% keyboard

%=========================
% show MRICRON
%=========================
if z.showResult<=0 ; return; end
    
    % check
    % !C:\paulprogramme\mricron\dcm2nii -g n O:\data4\nii2dicom\input\20190129TJ_d7_rat15_d7_rat15_response__E6_P1
    % !C:\paulprogramme\mricron\dcm2nii -g n O:\data4\nii2dicom\input\testout
    
    dcm2nii=fullfile(fileparts(fileparts(fileparts(which('ant.m')))),'mricron','dcm2nii.exe');
    
    % try; delete(fullfile(ddir{j},'*.nii')); end
    % try; delete(fullfile(outdir,'*.nii')); end
    
    [arg1 arg2]=system([dcm2nii ' -g n ' mdir]);
    arg2=strsplit(arg2,char(10))';
    dum=strrep(arg2{regexpi2(arg2,'Saving')},'Saving ','');
    D1=fullfile(fileparts(dum),'test.nii');
    movefile(dum,D1,'f');
    if z.showResult==2; rmricron([],D1); end
    
    [arg1 arg2]=system([dcm2nii ' -g n ' outdir]);
    arg2=strsplit(arg2,char(10))';
    dum=strrep(arg2{regexpi2(arg2,'Saving')},'Saving ','');
    D2=fullfile(fileparts(dum),'test.nii');
    movefile(dum,D2,'f');
    if z.showResult==2; rmricron([],D2); end
   
    
    
    rmricron([],D1,D2,5);
    
    if z.showResult<2 ; return; end 
    [h1 ha1]=rgetnii(D1);
    [h2 ha2]=rgetnii(D2);
    
    mx=@(a) [min(a(:)) max(a(:))];
    %% show    ;
    disp('===========================================================================');
    disp([' INPUT/OUTPUT COMPARISON:  [' mdirshort ']']);
    disp('===========================================================================');
    disp(['*  MAT  INPUT:  ...'  ]);
    disp(h1.mat);
    disp(['   MAT  OUTPUT:  ...'  ]);
    disp(h2.mat);
    
    disp(['*  dim  INPUT:  ' num2str(h1.dim)]);
    disp(['   dim  OUTPUT: ' num2str(h2.dim)]);
    disp(['*  pinfo INPUT: ' num2str(h1.pinfo')]);
    disp(['   pinfo OUTPUT ' num2str(h2.pinfo')]);
    disp(['* dt INPUT         : ' num2str(h1.dt)]);
    disp(['  dt OUTPUT        : ' num2str(h2.dt)]);
    disp(['* min-max-Val INPUT : ' num2str(mx(ha1))]);
    disp(['  min-max-Val OUTPUT: ' num2str(mx(ha2))]);
% end


% % % 
% % % [h1 ha1]=rgetnii(dcin);
% % % [h2 ha2]=rgetnii(dcout);
% % % 
% % % % [h3 ha3]=rgetnii('O:\data4\nii2dicom\input\20190129TJ_d7_rat15_d7_rat15_response__E6_P1\2019-01-28_09-23\T2_TurboRAREunknown_60001\s2019-01-28_09-23-102106-00030-00030-0.nii');
% % % 
% % % rmricron([],dcout,dcin,5)
% % % [h1.pinfo h2.pinfo]
% % % 
% % % [min(ha1(:)) max(ha1(:)) min(ha2(:)) max(ha2(:))]
% % % 
% % % 
% % % 
% % % 
% % % 
% % % if 0
% % %     %%
% % %     [d3] = spm_select('FPList',outdir,'.*.dcm$'); d3=cellstr(d3);
% % %     mb{1}.spm.util.dicom.data = d3
% % %     mb{1}.spm.util.dicom.root = 'date_time';
% % %     mb{1}.spm.util.dicom.outdir = {outdir} %{'O:\data4\nii2dicom\input\20190129TJ_d7_rat15_d7_rat15_response__E6_P1\'};
% % %     mb{1}.spm.util.dicom.convopts.format = 'nii';
% % %     mb{1}.spm.util.dicom.convopts.icedims = 0;
% % %     
% % %     [ar1 ar2 ]=spm_jobman('run',mb)
% % %     
% % %     ni2=char(ar1{1}.files)
% % %     [h4 ha4]=rgetnii(ni2);
% % %     [min(ha4(:)) max(ha4(:))]
% % %     
% % % end











% CRITICAL
% [1] hx.ImagePositionPatient'
% ans =
%   -20.3912    3.9044   26.4548
% [2]
% hx2. SliceLocation: 3.9044



%———————————————————————————————————————————————
%%   select DCM-DIRS
%———————————————————————————————————————————————
function out=selectDir(pa)
out='';

% return
if isempty(pa)
    px=pwd;
else
    px=char(pa);
end
% px='I:\Oelschlegel\antx_ct\MRs_Bruker_original';
[t,sts] = spm_select(inf,'dir','select DICOM FOLDERS','', px,'.*','');
if isempty(t);out=''; return; end

t=cellstr(t);
for i=1:length(t)
    [pa fi ext]=fileparts(t{i});
    t{i}=pa;
end
out=t;
return