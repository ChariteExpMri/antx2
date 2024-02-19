
%% convert analyze obj-file to nifti
% function [ha a] =obj2nifti(objfile,fileoutname)
%% INPUT
% objfile    : input objfile
% fileoutname: <optional> nifti output name  
%% OUTPUT    : <optional> if fileoutname is not defined: 
%     ha: header
%      a: 3d-data
%% example-1: save data   
% obj2nifti('20170926CH_Exp8_M01.obj','bla3.nii');
%% example-1: save data   
% [ha a]=obj2nifti('20170926CH_Exp8_M01.obj');

function varargout=obj2nifti(file,fileout)

% if 0
%     
%     obj2nifti('20170926CH_Exp8_M01.obj','bla2.nii');
%     
%     
% end


[b, header] = decodeOBJ(file);

% [ha  a]  =rgetnii('masklesion.nii');


hb.fname = 'bla';
hb.dim   = size(b);
hb.pinfo =[1 0 352]';
hb.dt    =[2 1];
hb.n     =[1 1];
hb.descrip  ='';

% hb.mat=[[diag([-1 1 1]); 0 0 0 ] [[([size(a)/2]+[1 1 1]./2).*[1 -1 -1] 1]]']
% hb.mat=[[diag([ 1 1 1]); 0 0 0 ] [[([size(a)/2]+[1 1 1]./2).*[-1 -1 -1] 1]]']
% hb.mat=[[diag([ 1 1 1]); 0 0 0 ] [ -(hb.dim/2+1) 1 ]'];

if length(hb.mat)==2
  hb.mat=[[diag([ 1 1 1]); 0 0 0 ] [ -(hb.dim/2+1) 1 1 ]'];  
else
  hb.mat=[[diag([ 1 1 1]); 0 0 0 ] [ -(hb.dim/2+1) 1   ]'];  
end




if exist('fileout')~=0
    rsavenii(fileout,hb,b);
else
    varargout{1} =hb;
    varargout{2} = b;
end




% [hc c]  =rgetnii('bla.nii');

function [b, header] = decodeOBJ(file)
% decodeOBJ: Reads Analyze 6.0 ROI Object Map format (*.OBJ)
% 
% I spent about an hour examining Object Maps in a hex editor until I came
% up with a way to parse them.  Warning, if you're not using Analyze 6.0 on 
% Windows and Matlab R14 SP1 then I have no clue if this will work.
% 
% Usage: [objectmap,header] = decodeOBJ(file);
% 
% Example: 
% [objectmap,header] = decodeOBJ('C:\foo\bar.obj');

% (C) Copyright Jan 11, 2006, David Johnson <monorail at po.cwru.edu>
% Rights to "rude: a pedestrian run-length decoder-encoder" remain the
% property of their respective owner(s).

% I use Analyze to manually trace ROIs in my data and then I load the
% Object Maps and do statistical tests on them in matlab.  

fid=fopen(file);
fseek(fid,0,'bof');

% the header is 20 bytes
fileheader=fread(fid,5,'uint32=>uint32','ieee-be');

% ignore=fileheader(1);  % can't figure out what this means, probably
% version related stuff

% dimensions indicated as displayed in Analyze 6.0 ROI
axis1dim=fileheader(2);    % x
axis2dim=fileheader(3);    % z
axis3dim=fileheader(4);  % y
numObjects=fileheader(5);  

header.xdim = axis1dim;
header.ydim = axis3dim;
header.zdim = axis2dim;

% each ROI Object takes up 152 bytes.  
% FIXME: read in more than just object names

header.NumObjects = numObjects;
header.ObjectNames = [];
for i=1:numObjects
    objectstruct=fread(fid,152,'uchar');
% The name of the object is a null-terminated string starting at the
% beginning of the object struct.
    allNulls = find(objectstruct==0);
    firstNull = allNulls(1);
    header.ObjectNames = [header.ObjectNames, {char(objectstruct(1:firstNull-1)).'}];
end

% skip past all the ROI objects and read the data
fseek(fid,20+double(numObjects)*152,'bof');
A = fread(fid,inf,'uchar');  % this is RLE
fclose(fid);

% decode RLE data
lengths=A(1:2:length(A)).';
bytes=A(2:2:length(A)).';

% decode the simple RLE data
dta=rl_decode(lengths,bytes);

% this is how it's actually stored: XZY

if prod([axis1dim,axis2dim,axis3dim])==length(dta)  %# multiple masks
    B=reshape(dta,[axis1dim,axis2dim,axis3dim]);
else
    B=reshape(dta(64:end),[axis1dim,axis2dim,axis3dim]); %#orig
end

% I prefer my data to be in YXZ (matlab convention)
% data=permute(B,[3,1,2]);
data=B;

b=B;
b=flipdim(b,2);
% [ha  a]  =rgetnii('masklesion.nii');


% The axes in Analyze are screwy.  [0,0,0] is the lower left hand corner in
% the first slice.  therefore the y axis needs flipped.
% objectmap = flipdim(data,1);

% debugging code
% imagesc(squeeze(objectmap(:,:,20)))
% keyboard

return;


% I took this function below from code from "rude: a pedestrian run-length
% decoder-encoder" on matlab central
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=6436&objectType=FILE

% run-length decoder
function	vec=rl_decode(len,val)

lx=len>0 & ~(len==inf);
if	~any(lx)
    vec=[];
    return;
end
if	numel(len) ~= numel(val)
    error(...
        sprintf(['rl-decoder: length mismatch\n',...
        'len = %-1d\n',...
        'val = %-1d'],...
        numel(len),numel(val)));
end
len=len(lx);
val=val(lx);
val=val(:).';
len=len(:);
lc=cumsum(len);
lx=zeros(1,lc(end));
lx([1;lc(1:end-1)+1])=1;
lc=cumsum(lx);
vec=val(lc);
return;
