% create 4D-RGB-colored Volume WITHOUT ID-children
% z=makeRGBvol( g, tb,IDvec )
%% IN
% g: 3d-ANO volume
% tb: cell-table with columns (LUT-table)
%      - Region-IDs (numeric scalar),
%      - RGB-tripple of Region (string,example '170 200 255')
% IDvec; Vectors with Region-IDs of interest
%% out
%   z: 4D-vol: x,y,z,RGB(3); example:   [  164   212   158     3]
%
% example of tb (cutted)
% ..
%     [      164]    '170 170 170'
%     [     1024]    '170 170 170'
%     [     1032]    '150 170 0'
%     [     1055]    '255 0 0'
% ..
% see also: makeRGBvolChild, nii_savehdrimg.m, nii_loadhdrimg.m 

function z=makeRGBvol( g, tb,IDvec )

if 0
    tb=c2(:,[2 5])
    g=reshape(an2,size(an));
    IDvec=[226 672];
    z=makeRGBvol( g, tb,IDvec);
    
end
if exist('IDvec')~=1
    IDvec=cell2mat(tb(:,1));
end
% ==============================================
%%   
% ===============================================

si=size(g);
g2=g(:);
col=cellfun(@(a){[ str2num(num2str(a))./255  ]}, tb(:,2));
IDall=cell2mat(tb(:,1));
if iscell(IDvec); IDvec=cell2mat(IDvec); end
    
% tic
[R,G,B]=deal(zeros(size(g)));

for i=1:length(IDvec)
    
    %[hb b]=rgetnii('dti_V1.nii');
    IDthis=IDvec(i);%672
    iloc=find(g2==IDthis);
    val=col{find(IDall==IDthis)};
    
    R(iloc)=val(1);
    G(iloc)=val(2);
    B(iloc)=val(3);
end
z=cat(4,reshape(R,si),reshape(G,si),reshape(B,si));
% toc