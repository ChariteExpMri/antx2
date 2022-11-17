

% d=spm_extractData(co,where,what,radius);
% --------INPUT
% co     : cordinate [x,y,z] (mm)           mandatory!
% where  : 'voxel', 'cluster' ,'shpere'    [default: 'voxel']
% what   : 'y','kwy', 'beta'               [default: 'y']
% radius : optional when where is 'sphere' [default: 0.5]
% --------OUTPUT
% d: extracted data
% u: struct containing: files (explicit path), animal(dir), file (used files)
% 
% --------EXAMPLES
% d=spm_extractData([ -3.5750    0.3755   -1.4503])
% same as ...
% d=spm_extractData([ -3.5750    0.3755   -1.4503],'voxel','y')
% d=spm_extractData([ -3.5750    0.3755   -1.4503],'sphere','y',0.1)
% 
% ==============================================
%%  
% from: spm_mip_ui.m -line-778 (extract)
% ===============================================




function [d u]=spm_extractData(co,where,what,radius)
d=[];
u=[];
% if 0
%     co=[ -3.5750    0.3755   -1.4503];
%     where='voxel';
%     % where='sphere'; radius=0.0005;
%     what='y'
% end


if exist('where')~=1;     where='voxel'; end
if exist('what')~=1;      what='y'; end
if exist('radius')~=1;    radius=0.5; end

spm_results_ui('SetCoords',co);


% data = spm_mip_ui('Extract',what,where)
% if nargin<2, what='beta'; else what=varargin{2}; end
% if nargin<3, where='voxel'; else where=varargin{3}; end
xSPM = evalin('base','xSPM');
SPM  = evalin('base','SPM');

XYZmm = spm_results_ui('GetCoords');
[XYZmm,i] = spm_XYZreg('NearestXYZ',XYZmm,xSPM.XYZmm);
% if isempty(i), varargout = {[]}; return; end
try
    spm_results_ui('SetCoords',xSPM.XYZmm(:,i));
catch
    d=[];
    return
end

switch lower(where)
    case 'voxel'
        % current voxel
        XYZ = SPM.xVol.iM(1:3,:)*[XYZmm;1];
    case 'cluster'
        % current cluster
        A   = spm_clusters(xSPM.XYZ);
        j   = find(A == A(i));
        XYZ = xSPM.XYZ(:,j);
    case 'sphere'
        
        fileSPM=fullfile(xSPM.swd,xSPM.Vspm.fname);
        [ha a mm xyz1 ]=rgetnii(fileSPM);
        
        % radius=0.2;
        O     = single( ones(1,length(mm)));% searchlite
        s = (sum((mm-co(:)*O).^2) <= radius);
        mms=mm(:,find(s==1)); %mm-sphere
        % XYZ = SPM.xVol.iM(1:3,:)*[XYZmm;1];
        XYZ = SPM.xVol.iM(1:3,:)*[mms;ones(1,size(mms,2))];
        if 0
            s2=reshape(s,ha.dim);
            rsavenii('test1.nii',ha, s2)
        end
        
        
    otherwise
        error('Unknown action.');
end

switch lower(what)
    case {'y','kwy'}
        data = spm_get_data(SPM.xY.VY,XYZ);
        if strcmpi(what,'kwy')
            data = spm_filter(SPM.xX.K,SPM.xX.W*data);
        end
    case 'beta'
        data = spm_get_data(SPM.Vbeta,XYZ);
    otherwise
        error('Unknown action.');
end

d= data;

%% ===============================================
files={SPM.xY.VY(:).fname}; files=files(:);

u.files=files;
[~,animal]=fileparts2(fileparts2(files));
u.animal=animal;
[~,fi ext]=fileparts((files{1}));
u.file=fullfile([fi ext]);






