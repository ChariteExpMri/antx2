
% recursevly find CHILD-atlas IDS FROM UPPER ATLAS-IDS
% function varargout=getAtlasID_AllenMouse(lx,id)
% 
% [ lx]=getAtlasID_AllenMouse ; % initiate atlas (get table)
% [ lx lu]=getAtlasID_AllenMouse ; % initiate atlas  (get table and look-up-table-structure)
% [ nn]=getAtlasID_AllenMouse([],361); % get CHILD-IDS for ID-361 , slow version
% ----------------------------------------------------------------------------------------
% [ lx]=getAtlasID_AllenMouse ; % initiate atlas
% [ nn]=getAtlasID_AllenMouse(lx,361);    % get CHILD-IDS for ID-361 , fast version
% [ nn]=getAtlasID_AllenMouse(lx,322);    % get CHILD-IDS for ID-322 , fast version

% [ nn ix lx2]=getAtlasID_AllenMouse(lx,322);    % get [nn] CHILD-IDS for ID-322 , [ix] index of region, [lx2] atlas table
% ------------------------------------------------------------------------------------------


function varargout=getAtlasID_AllenMouse(lx,id)

if nargin==0
    lx=[]; id=[];
end

%====================================================================================================
if isempty(lx)
    xx = load('gematlabt_labels.mat');
    [table lu] = buildtable(xx.matlab_results{1}.msg{1});
    lx=[{lu(:).name}' {lu(:).id}' {lu(:).children}'   {lu(:).color_hex_triplet}'];
end

if isempty(id)
   varargout{1}=lx;
   varargout{2}=lu;
   return;
end


%====================================================================================================

% ==============================================
%%   get children
% ===============================================


n=id;

ix=find(cellfun(@(a)[a==n ],  lx(:,2)));
ch=lx{ix,3};
nn=[];
if isempty(ch) % NO CHILDS ANYMORE
    nn=[nn n ];
end

while ~isempty(ch)
    
    is=find(cellfun(@(a)[a==ch(1) ],  lx(:,2))) ;
    
    if isempty(lx{is,3}) % NO CHILDS ANYMORE
       nn=[nn ;ch(1)];
       ch(1)=[];
    else
        ch=[ch; lx{is,3}];
        ch(1)=[];
    end 
end

varargout{1}=nn;
varargout{2}=ix;
varargout{3}=lx;
