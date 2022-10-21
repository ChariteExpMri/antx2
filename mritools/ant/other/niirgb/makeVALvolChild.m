% create 3D-VALUE-based Volume using ID-children as well
% z=makeVALvolChild( g, tb,IDvec )
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
% see also: makeRGBvolChild.m, makeRGBvol.m, nii_savehdrimg.m, nii_loadhdrimg.m
% internally sorted: filling first IDsd with lots of childs and than ids with fewer/no childs 

function z=makeVALvolChild( g, tb,IDvec,value,verbose )

if 0
    
    
end
if exist('verbose')~=1; verbose=0; end
% ==============================================
%%
% ===============================================
si=size(g);
g2=g(:);



if size(tb,2)==3                % label & ID &CH
    tblabel=tb(:,1);
    IDall  =cell2mat(tb(:,2));
    CH     =tb(:,3);
elseif size(tb,2)==2 
    try                         % ID & CH
    IDall  =cell2mat(tb(:,1));
    CH     =tb(:,2);
    tblabel=repmat({'-not specified-'},[ length(IDall) 1 ]);
    catch                      %label & ID
        tblabel=tb(:,1);
        IDall  =cell2mat(tb(:,2));
        CH    =repmat({nan},[ length(IDall) 1 ]);
    end
elseif size(tb,2)==1       % ID
    IDall  =cell2mat(tb(:,1));
    tblabel=repmat({'-not specified-'},[ length(IDall) 1 ]);
    CH    =repmat({nan},[ length(IDall) 1 ]);
    
end





if iscell(IDvec); IDvec=cell2mat(IDvec); end
IDvec=IDvec(:);

if iscell(value); value=cell2mat(value); end
value=value(:);
if size(value,1)==1; value=repmat(value(1),[size(IDvec,1) ,1]); end % ONLY 1 color given --> identical color for all regs


% ==============================================
%%   resort ID and value
% ===============================================
% sort IDs such that that macrostructures with children will be plottet first
% than the microstructures --> reason-example 1st color corpus calossum, than color knee of corpos callosum
% [nch,isort]=sort(cell2mat(cellfun(@(a){[ length(a)]} , tb(:,3) )),'descend');

nch=zeros(length(IDvec),1);
for i=1:length(IDvec)
    IDthis=IDvec(i);%672
    is=find(IDall==IDthis);
    IDch=[CH{is}]; IDch=IDch(:);
    if length(IDch)==1 && isnan(IDch);
        IDch=[];
    end
    nch(i,1)=length(IDch);
end

dumtb =[nch, IDvec value];
% dumtbs=flipud(sortrows(dumtb,1)); %sort accord number of children (starting with most kids,)
dumtbs=(sortrows(dumtb,3)); %sort accord value , plot first low values than high values

IDvec=dumtbs(:,2);
value=dumtbs(:,3);

% ==============================================
%%   search and insert value
% ===============================================

% tic
[z]=deal(zeros(size(g2)));

for i=1:length(IDvec)
    
    %[hb b]=rgetnii('dti_V1.nii');
    IDthis=IDvec(i);%672
    
    is=find(IDall==IDthis);
    IDch=[CH{is}]; IDch=IDch(:);
    if length(IDch)==1 && isnan(IDch);
        IDch=[];
    end
    
    allids=[IDthis; IDch];
    %      disp([i length(allids) length(find(ismember(g2, allids )))]);
    
    if verbose>0
%         disp(['i:' num2str(i) ...
%             '| ID:'  num2str(IDthis)   ...
%             '| nCH:'  num2str(length(allids)-1)   ...
%             '| vox: ' num2str(length(find(ismember(g2, allids )))) ...
%             '| Reg:' tblabel{is} ]);
        
          fprintf(['i: %3d' '|ID: %10d' '|vox: %6d' '|CH: %3d'   '|REG: %s \n' ],...
              i,...
              IDthis,...
              length(find(ismember(g2, allids ))),...
              length(allids)-1,...
              tblabel{is} );
        
    end
    z(find(ismember(g2, allids )))=value(i);
    %    
    
    %     for  j=1:size(allids,1)
    %         iloc     =find(g2==allids(j));    %index in 3Dvol
    %         z(iloc)  =value(i);               %insert value
    %
    %
    %         %z(g2==allids(j))=value(i);
    %
    %         %z(find(ismember(g2, allids )))=value(i);
    %     end
    
    %  z2=reshape(z,si);
    %  montage2(z2); disp(i); drawnow;
    %  pause
    
    
end
% disp('---');
% disp(toc);
z=reshape(z,si);

% ===========================PLOT====================
if verbose==2
    montage2(z);
end

% ==============================================
%%
% ===============================================