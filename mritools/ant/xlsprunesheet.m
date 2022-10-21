
%function to prune* xls-table, based on reference-row and refercence-column
% *here the rows and columns containing a NaN in the reference column/row are removed
% if reference-row and/or refercence-column are not provided or empty it is assumed that 
%  refrow is 1 (1st row is the reference) and refcol is 1 (1st column is reference)
% 
function a0=xlsprunesheet(a0,refrow,refcol)

if exist('refcol')~=1 || isempty(refcol)
    refcol=1;
end

if exist('refrow')~=1 || isempty(refrow)
    refrow=1;
end

% delete Nan-rows
idel=find(strcmp(cellfun(@(a){[ num2str(a) ]} ,a0(:,refcol)),'NaN'));
a0(idel,:)=[];

% 'delete Nan-columns
idel=find(strcmp(cellfun(@(a){[ num2str(a) ]} ,a0(refrow,:)),'NaN'));
a0(:,idel)=[];
