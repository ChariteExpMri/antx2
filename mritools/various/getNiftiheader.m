%% get NIFTI-header information of one/several NIFTI-files
% varargout=getNiftiheader(fis,p);
%%  INPUT: all inputs are optional!
% fis: cellstr of fullplath NIFTI-files otherwise empty to interactively select files
% p:   struct with key-value args: 
%  'show': show information. [0]no [1]yes show it
%  'mode': show [1] short version [2] extended version
%%  OUPUT: optional
% obtain header-info as cell-array
%% =======examples-1========================================
% getNiftiheader   %interactive file selection 
% getNiftiheader([],struct('show',1,'mode',1)); %interactive file selection 
%% =======examples-2========================================
% fis={
%         'H:\Daten-2\Imaging\AG_Wu\wu_segissue_feb2022\dat\ED22_0112\2-Pilot-FOV5cm_1.nii'
%         'H:\Daten-2\Imaging\AG_Wu\wu_segissue_feb2022\dat\ED22_0112\3-Ex-Vivo_Network-DTI_SE_3D_30dir-Sm_1.nii'
%         'H:\Daten-2\Imaging\AG_Wu\wu_segissue_feb2022\dat\ED22_0112\4-Ex-Vivo_Network_RARE8_78u_1.nii'
%         };
% getNiftiheader(fis,struct('show',1))                 ;% show headerInfo in window
% hdrinfo=getNiftiheader(fis,struct('show',0,'mode',2)); %show nothing, headerInfo is passed as output: 

function varargout=getNiftiheader(fis,p)
warning off;
p0.show=1;
p0.mode=1;

if exist('p')==0;
    p=struct('dummy',1);
end
p=catstruct(p0,p);

% disp(p);



% return
% ==============================================
%%   test
% ===============================================

if 0
    fis={
        'H:\Daten-2\Imaging\AG_Wu\wu_segissue_feb2022\dat\ED22_0112\2-Pilot-FOV5cm_1.nii'
        'H:\Daten-2\Imaging\AG_Wu\wu_segissue_feb2022\dat\ED22_0112\3-Ex-Vivo_Network-DTI_SE_3D_30dir-Sm_1.nii'
        'H:\Daten-2\Imaging\AG_Wu\wu_segissue_feb2022\dat\ED22_0112\4-Ex-Vivo_Network_RARE8_78u_1.nii'
        };
    getNiftiheader(fis)
    

    
end
usegui=1;

% ==============================================
%%   INPUT-files
% ===============================================
if exist('fis')==1 && ~isempty(fis)
    fis=cellstr(fis);
    fis=fis(find(existn(fis)==2));        %check file-existence;
    [px fi ext]=fileparts2(fis);
    fis=fis(regexpi2(ext,'.nii$|.hdr$')); % check extension
    if ~isempty(fis)
        usegui=0;
    end            
end
% ==============================================
%%   manual file-selection
% ===============================================
if usegui==1;
    msg='sct one/several Nifti-files';
    [t,sts] = spm_select(inf,'image',msg,'','pwd,.nii$|.hdr$',1);
    fis=cellstr(t);
end

% ==============================================
%%   process
% ===============================================
l2={};
for i=1:length(fis)
% i=1
   [pa,name,ext]=fileparts(fis{i});
   [pa2,mdir]=fileparts(pa);
   fi=fullfile(pa,[name '.nii']);
    ha=spm_vol(fi);
    dim4=length(ha);
    ha=ha(1);
    
    l=struct2list(ha);
    if dim4>1
        idim=regexpi2(l,'ha.dim');
        l(idim)={sprintf('ha.dim=[%d %d %d %d] ',[ha.dim dim4])};
    end
    
    if p.mode==1 %short version 
       l(regexpi2(l,'ha.fname'))=[] ;
       l(regexpi2(l,'ha.descrip'))=[] ; 
       l(regexpi2(l,'ha.n'))=[] ;
    end
    
    ls={repmat('=',[1 size(char(l),2) ])};
    lh={ [ ' #ko ***    '    [name '.nii']            '   ***' ]};
    lp1={['DirUP: #b '  mdir]};
    lp2={['DIR: '  pa]};
    l1=[[ls;lh;ls;lp1;lp2; l]];
    
    %--------
    l2=[l2; l1];
end

l2=[l2; {'';''}];

if p.show==1
    uhelp(l2,1,'name','NIFTIs');
end
%% ======OUTPUT=========================================

if nargout>0
    varargout{1}=l2;
end






