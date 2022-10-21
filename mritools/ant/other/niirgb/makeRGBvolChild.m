% create 4D-RGB-colored Volume using ID-children as well
% z=makeRGBvolChild( g, tb,IDvec )
%% IN
% g: 3d-ANO volume
% tb: cell-table with columns (LUT-table)
%      - Region-IDs (numeric scalar),
%      - CHILDREN of Region-ID,(numeric vector) 
%      - RGB-tripple of Region (string,example '170 200 255')
% IDvec; Vectors with Region-IDs of interest
%% out
%   z: 4D-vol: x,y,z,RGB(3); example:   [  164   212   158     3]
%
% example of tb (cutted)
% ..
%     [      164]    [         NaN]    '170 170 170'
%     [     1024]    [ 21x1 double]    '170 170 170'
%     [     1032]    [  4x1 double]    '150 170 0'
%     [     1055]    [         NaN]    '255 0 0'
% ..
% see also: makeRGBvol.m, nii_savehdrimg.m, nii_loadhdrimg.m 

function z=makeRGBvolChild( g, tb,IDvec )

if 0
    tb=c2(:,[2 3 5])
    g=reshape(an2,size(an));
    IDvec=[1009];
    z=makeRGBvolChild( g, tb,IDvec);
    
end
% ==============================================
%%   
% ===============================================

si=size(g);
g2=g(:);
col=cellfun(@(a){[ str2num(num2str(a))./255  ]}, tb(:,3));
IDall=cell2mat(tb(:,1));
CH   =tb(:,2);
if iscell(IDvec); IDvec=cell2mat(IDvec); end
    
% tic
[R,G,B]=deal(zeros(size(g)));

for i=1:length(IDvec)
    
    %[hb b]=rgetnii('dti_V1.nii');
    IDthis=IDvec(i);%672
    
    is=find(IDall==IDthis);
    IDch=cell2mat(CH(is));
    if length(IDch)==1 && isnan(IDch); 
        IDch=[];
    end
    allids=[IDthis; IDch];
    
    for j=1:size(allids,1)
        
        iloc=find(g2==allids(j));
        is2=find(IDall==allids(j));
        val=col{is2};
        
        R(iloc)=val(1);
        G(iloc)=val(2);
        B(iloc)=val(3);
    end
end
z=cat(4,reshape(R,si),reshape(G,si),reshape(B,si));
% toc