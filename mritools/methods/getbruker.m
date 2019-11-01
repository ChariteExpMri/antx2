function [ni bh  da]=getbruker(file) 
% file:  bruker:2dseq file
% ni: structure with niti header & data
% bh: bruker params: method/acqp / visu_pars
% dh: another importFuntion
if 0
    
    [ni bh da]=getbruker('O:\data\epi_test\bruker\20151126_162717_20151126_TF_LT16_1_1\6\pdata\1\2dseq');

    
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% if 0
% %         [a q]=Bruker2nifti('O:\temp\Karina_singleSubject\20141009_02sr.s91\3\pdata\1\2dseq');
% %         [a q]=Bruker2nifti('O:\temp\Karina_singleSubject\20141009_02sr.s91\4\pdata\1\2dseq');
% %
%
%     if 0
%
%  %           pal='O:\harms1\harmsStaircaseTrial\pvraw\20150909_084103_20150909_FK_C2M10_1_1'
%      pal='O:\data\epi_test\bruker\20151126_162717_20151126_TF_LT16_1_1\'
%           [wfile,~] = spm_select('FPListRec',pal,'^2dseq$')
% %         wfile={
% %             'O:\data\epi_test\bruker\20151126_162717_20151126_TF_LT16_1_1\2\pdata\1\2dseq'
% %             'O:\data\epi_test\bruker\20151126_162717_20151126_TF_LT16_1_1\6\pdata\1\2dseq'
% %             'O:\data\epi_test\bruker\20151126_162717_20151126_TF_LT16_1_1\7\pdata\1\2dseq'
% %             'O:\data\epi_test\bruker\20151126_162717_20151126_TF_LT16_1_1\8\pdata\1\2dseq'
% %             }
%
%         for i=1:length(wfile)
%             try
%                 [a q]=Bruker2nifti2(wfile{i});
%                 catch
%                 disp([num2str(i) 'failed: ' wfile{i}])
%             end
%         end
%
%
%     end
%
% end


% disp(char(file));
% return
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

%———————————————————————————————————————————————
%% GET DATA & PARAS
%———————————————————————————————————————————————
da= xreadbruker(file,'wbar' ,'off');
% bhdr=da.HDR.FileHeader;
% v  = bhdr.visu_pars;
% m  = bhdr.method;
% a  = bhdr.acqp;


pa=strrep(file,'2dseq','');
v  =readBrukerParamFile(fullfile(pa,'visu_pars'));
mpa=fileparts(fileparts(fileparts(pa)));
m  =readBrukerParamFile(fullfile(mpa,'method'));
a=readBrukerParamFile(fullfile(mpa,'acqp'));

bh.v  = v;
bh.m  = m;
bh.a  = a;
bh.info={'Bruker-PARS: visu_pars/methods/acqp'};

%———————————————————————————————————————————————
%%  GET PARAS-2
%———————————————————————————————————————————————
p  = v.VisuCorePosition;
o  = v.VisuCoreOrientation;

or      =  p(1,:)*reshape(o(1,:),[3 3]);
m_or2  =   reshape(o(1,:)',[3 3]);
% m_or2 =[1 0 0; 0 1 0; 0 0 1]


resol     = [v.VisuCoreExtent./v.VisuCoreSize v.VisuCoreFrameThickness];
FOV       = [v.VisuCoreExtent  size(v.VisuCoreOrientation,1)*v.VisuCoreFrameThickness ]';

half_vx    = (resol/2)';
offset     = [mean(a.ACQ_phase1_offset) mean(a.ACQ_read_offset)  -mean(p(:,3))]';

% shift      =   -FOV/2-half_vx-offset;
% pos0    =m_or2*shift;
pos0      =p(1,:)';

orient    =m.PVM_SPackArrSliceOrient;
dims      =[v.VisuCoreSize v.VisuCoreFrameCount]';

%———————————————————————————————————————————————
%%   MAKE REORIENT-MAT
%———————————————————————————————————————————————
%%
mat             =  [m_or2*diag(resol(1:3)) pos0(1:3) ; 0 0 0 1];
% if strcmp(orient,'axial')
%     mat             =   spm_matrix([0 0 0 0 pi pi 1 1 1])*mat;
% elseif strcmp(orient,'sagittal')
%  mat             =   spm_matrix([0 0 0 0 0 pi 1 1 1])*mat;
% end

%———————————————————————————————————————————————
%%   prep VOLUME
%———————————————————————————————————————————————

img=da.FTDATA;


if   ndims(img)>3  %% HIGHER DIMS
    %      img=squeeze(img(:,:,2,:));%%TEST
    hdim=v.VisuFGOrderDesc;
    slicedim=regexpi2(hdim(2,:),'slice'); %% where is the slice coded
    img=squeeze(img);
    if  ~isempty(slicedim)
        slicedim=slicedim+2;
        iflipdim=[1: size(hdim,2)+2];
        iflipdim=[iflipdim(1:2)  slicedim setdiff(iflipdim(3:end),slicedim)];
        img=permute(img, iflipdim);
        
        %%just test 2nd slice
        %         img=img(:,:,:,2);
        
    end
    dims=[size(img)]';
end

%———————————————————————————————————————————————
%%   make TO ANT-ORIENTATION
%  this equals:   mat=spm_matrix([0 0 0 [0 0 -pi/2 ] 1 -1 1])*mat;
% but we do not need to change the reorientMat (no possible reslicing)
% check sample:
% [hb b]=rgetnii(fullfile('O:\harms1\harmsStaircaseTrial\dat\s20150909_FK_C2M10_1_3_1','t2.nii'));
%———————————————————————————————————————————————
if da.useBrukerImport==0
    img=rot90(fliplr(img));
    dims=[dims([ 2 1 3]); dims(4:end) ];
    imat=spm_imatrix(mat);
    mat=spm_matrix(imat([[2 1, 3] [5 4, 6] [8 7, 9] [11 10, 12]]));
    
%     mat=spm_matrix([0 0 0 [0 0 -pi/2 ] 1 -1 1])*mat;
end


%———————————————————————————————————————————————
%%   get dataType
%———————————————————————————————————————————————

switch v.VisuCoreWordType
    case '_8BIT_USGN_INT'
        tp  =   'uint8';
    case '_16BIT_SGN_INT'
        tp  =   'int16';
    case '_32BIT_SGN_INT'
        tp  =   'int32';
    case '_32BIT_FLT'
        tp  =   'float32';
    case '_64BIT_FLT'
        tp  =   'float64';
    case '_8BIT_SGN_INT'
        tp  =   'int8';
    case '_16BIT_USGN_INT'
        tp  =   'uint16';
    case '_32BIT_USGN_INT'
        tp  =   'uint32';
end
%datatype__________________________________________________________________
prec =   {'uint8','int16','int32','float32','float64','int8','uint16','uint32'};
types   = [    2      4      8      16         64       256    512     768];
dt=0;
for j=1:size(prec,2)
    if strcmp(tp,prec(1,j)) dt=types(j); end
end


vol = struct('fname','??','dim',double(dims(1:3)'),'mat',mat,...'pinfo',[1 0 0]'
    'dt',[dt 0]);
ni.hd   =vol;
ni.d    =img;
ni.ndim=ndims(ni.d);
ni.info='hd.fname not specified jet !!!';



return

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% fname=['' strrep(strrep(pa, fileparts(mpa),''),'\','_')];
%
%     % Write
%     path_out=fullfile(out,[ fname '.nii']);
%     Vol = struct('fname',path_out,'dim',double(dims'),'mat',mat,...'pinfo',[1 0 0]'
%         'dt',[dt 0]);
%     spm_write_vol(Vol,img);
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

