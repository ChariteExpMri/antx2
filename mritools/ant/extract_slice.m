% exctract single slice from NIFTI and store as NIFTI (same space as orig. file)
% f2=extract_slice(f1,f2,slice,volnr)
% f1: input NIFTI
% f2: output NIFTI
%      -if empty: output file is inputFile + suffix '_slice'
%       if path: output file is this path + suffix '_slice'
% slice : nlice number to extract
%       - single number  or range (1:5) or defined [1 3 10]
%       - use 'all' to extract all slices
%       - if more than one slice is extracted the output suffix '_slice' + sliceNumber (3digits) is used 
% show  -[0|1] disp hyperlink to show overlay of input&output images
%   
%% =[examples]==============================================
%% extract slice 23 and store as 't2anat_slice.nii'
% f1=fullfile(pwd,'t2anat.nii');
% f2=fullfile(pwd,'t2anat_slice.nii');
% extract_slice(f1,f2,23);
% 
%% extract slices 20:23 and store as t2anat_slice020.nii,'t2anat_slice021.nii',...,t2anat_slice023.nii
% f1=fullfile(pwd,'t2anat.nii');
% f2=fullfile(pwd,'t2anat_slice.nii');
% extract_slice(f1,f2,20:23);
% 
%% same as previous example: but outputfile is generated via input-file
% f1=fullfile(pwd,'t2anat.nii');
% extract_slice(f1,[],20:23);
% 
%% same as previous example: but all slices are extracted
% f1=fullfile(pwd,'t2anat.nii');
% extract_slice(f1,[],'all');



function o=extract_slice(f1,f2,slice,volnr,show)

warning off
% ==============================================
%%   example
% ===============================================

if 0
    %% ===============================================
    
    f1=fullfile(pwd,'t2anat.nii');
    f2=fullfile(pwd,'t2anat_slice.nii');
    extract_slice(f1,f2,23);
    %% ===============================================
    f1=fullfile(pwd,'t2anat.nii');
    f2=fullfile(pwd,'t2anat_slice.nii');
    extract_slice(f1,f2,20:23);
    %% ===[single slices]============================================
    f1=fullfile(pwd,'t2anat.nii');
    extract_slice(f1,[],5:23);
     %% ===============================================
     %% =====[all slices]==========================================
    f1=fullfile(pwd,'t2anat.nii');
    extract_slice(f1,[],'all');
     %% ===============================================

end


% ==============================================
%%
% ===============================================
if exist('volnr')==0 || isempty(volnr)
    volnr=1;
end
if exist('show')==0 || isempty(show)
    show=0;
end

% ==============================================
%%   
% ===============================================



[ha a mm]=rgetnii(f1);

ha=ha(1);
% ix=find(squeeze(sum(sum(a,1),2))~=0)
aq=repmat(permute(1:size(a,3),[1 3 2]), [size(a,1) size(a,2)  1]);
aq=aq(:);
mx=[median(squeeze(mm(3,find(aq==1))))
    median(squeeze(mm(3,find(aq==max(aq)))))];
%% =====[ ifs]==========================================
%all slices
if ischar('slice') && strcmp(slice,'all')
 slice=[1:size(a,3)];
end

%empty outputfile
if isempty(f2)
    [pax namex extx]=fileparts(f1);
    f2=fullfile(pax,[namex '_slice' extx  ]);
elseif isdir(f2)==1
    [pax namex extx]=fileparts(f1);
    f2=fullfile(f2,[namex '_slice' extx  ]);
end
    
%multple slices
if length(slice)>1
   [pax namex extx]=fileparts(f2);
    foutList=cellfun(@(a){[ fullfile(pax,[namex a  extx ] )]}, pnum(slice,3));
else
    foutList=cellstr(f2);
end

%% ===============================================

o=foutList;
for i=1:length(slice)
    slicenum=slice(i); 
    ifin=median(squeeze(mm(3,find(aq==slicenum))));
    %% ===============================================
    l=linspace(mx(1),mx(2),size(a,3));
    v=spm_imatrix(ha.mat);
    sv=[1:ha.dim(3)]*v(9)+v(3);
    % !sv-l=0!!!
    
    if 0
        i0=vecnearest2(sv,0);
        df=slicenum-i0-1;
        dfmm=df*v(9);
    end
    
    
    v2=v;
    %v2(3)=dfmm;
    m=spm_matrix(v2);
    hb=ha(1);
    hb.dim(3)=1;
    hb.mat=m;
    hb.mat(3,4)=ifin-v2(9);
    
    b=a(:,:,slicenum,volnr);
    fout=foutList{i};
    try; delete(fout); end
    rsavenii(fout, hb, b, 64);
    
    if show==1
        showinfo2('saved: ',fout,f1,13);
    end
    % rmricron([],f2,f1,14)
    
end


