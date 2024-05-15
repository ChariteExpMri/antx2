
%% create initial warpfield
%% o=makewarpfield(refimg,saveimg)
%% INPUT:
% refimg: reference image (NIFTI)
% saveimg: (optional), fullpath-filename to save warpfield as NIFTI
% 
%% example-1: output warpfied as struct
% pam='H:\Daten-2\Extern\AG_Schmid\implement_seedbased\dat\20240216_114712_wmstroke_mainstudy_BD3018_TP4_4Month_1_200_200'
% refimg=fullfile(pam,'AVGT.nii');
% o=makewarpfield(refimg);
% 
%% example-2: save warpfield as NIFTI
% pam='H:\Daten-2\Extern\AG_Schmid\implement_seedbased\dat\20240216_114712_wmstroke_mainstudy_BD3018_TP4_4Month_1_200_200'
% refimg =fullfile(pam,'AVGT.nii');
% outfile=fullfile(pam,'_testwarpfield.nii');
% o=makewarpfield(refimg,outfile);

function o=makewarpfield(refimg,saveimg,varargin)
% ==============================================
%%
% ===============================================
%% ===============================================
if 0
    % output warpfied as struct
    pam='H:\Daten-2\Extern\AG_Schmid\implement_seedbased\dat\20240216_114712_wmstroke_mainstudy_BD3018_TP4_4Month_1_200_200'
    refimg=fullfile(pam,'AVGT.nii');
    o=makewarpfield(refimg);
    
    % save warpfield as NIFTI
    pam='H:\Daten-2\Extern\AG_Schmid\implement_seedbased\dat\20240216_114712_wmstroke_mainstudy_BD3018_TP4_4Month_1_200_200'
    refimg =fullfile(pam,'AVGT.nii');
    outfile=fullfile(pam,'_testwarpfield.nii');
    o=makewarpfield(refimg,outfile);
    
    
end
%% ======== adiditonal inputs =======================================
p.verbose =0;
p.dtype   =64;
%------------
if ~isempty(varargin)
   pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
   p=catstruct(p,pin);
end
% p
% return
%% ===============================================
[hb b]=rgetnii(refimg);
hb=hb(1);
[bb vox]=world_bb(refimg);
dim=hb.dim;

%% ======= v1========
w=linspace(bb(1,1),bb(2,1),dim(1))';
% r1=a(:,1,1,1); r1=r1(:);
% w2=[bb(1,1): vox(1) :bb(2,1)]'
c1=repmat(w(:),[1 dim(2) dim(3) ]);
% r1=a(:,:,:,1);
% max(abs(c1(:)-r1(:)))
%% ======= v2========
% r2=a(:,:,:,2);
% d=r2(:,:,1);
w=linspace(bb(1,[2]),bb(2,[2]),dim(2));
c2=repmat(w(:)',[dim(1) 1 dim(3) ]);
% max(abs(c2(:)-r2(:)))

%% ======= v3========

% r3=a(:,:,:,3);
% d=squeeze(r3(1,1,:));
% [min(d) max(d)]
wq=linspace(bb(1,[3]),bb(2,[3]),dim(3))';
clear w
w(1,1,:)=wq;
c3=repmat(w,[dim(1)  dim(2) 1]);
% max(abs(c3(:)-r3(:)))

%% ======= aggreg========
cc=cat(4,c1,c2,c3);

%% ======= save========
if exist('saveimg')==0 || isempty(saveimg)
    o.d =cc;
    o.hd=hb;
    o.hd.fname='';
else
    [px name ext]=fileparts(saveimg);
    if isempty(px); px=pwd; end
    if strcmp(ext,'.nii')~=1
        error('"saveimg" must be fullpath-nifti filename to write the warpfield');
    end
    %f3=fullfile(pwd,'no-warp_selfcreated.nii')
    try; delete(saveimg); end
    rsavenii(saveimg,hb,cc,p.dtype);
    o=saveimg;
    if p.verbose==1
        showinfo2(['created inital warpfield'],saveimg);
    end
end
% rmricron([],f1,f3,0);







