function [out_im,out_trans] = run_transformix(im,points,tfile,outfold,opt)

% run_transformix runs transformix.exe with a desired set of inputs
%
% Usage:
% [wim,wps] = run_transformix(im,points,tfile,out,evaltype)
%
% -----------------------------Inputs--------------------------------------
% im: image to be warped
% points: text file with the coordinates where the deformation is evaluated
%        (empty: if input "evaltype" is not empty, all points will be evaluated 
%         and the result is then saved in an image as either vector deformation, 
%         scalar Jacobians or matrix Jacobian fields, depending on "evaltype")
% tfile: transformation text(ASCII) file
% out: output directory (empty: first moving image directory)
% evaltype: type of evaluation of the transformation
%           evaltype = '' ---> evaltype = 'def' for non emtpy input "points"
%           evaltype = 'def' --> deformations T(x)-x
%           evaltype = 'jac' --> Jacobians |dT(x)/dx|
%           evaltype = 'jacmat' --> Jacobian matrices dT(x)/dx
% ------------------------------Outputs------------------------------------
% wim: warped image (empty if im = '')
% wps: transformation evaluated.
%      If the file in input "points" is provided, wps has its name postfixed 
%      by '-out'. Otherwise if points = '', the transformation is evaluated 
%      in all voxels of the fixed image and stored in wps as either NIFTI or
%      MHD depending on the tfile (though only MHD for evaltype = 'jacmat' 
%      since NIFTI is not supported). In this case wps has the name of the 
%      transformation file posfixed by: 
%      1. '-def' if evaltype = 'def'
%      2. '-jac' if evaltype = 'jac'
%      3. '-jac' if evaltype = 'jacmat'
%
% 5/3/2011
% version 1.0b
% 
% Pedro Antonio Vald�s Hern�ndez
% Neuroimaging Department
% Cuban Neuroscience Center

%===============================
if ispc
    transformix = which('transformix.exe');
elseif ismac
    ela=elastix4mac;
    transformix=ela.T;
else
    %LINUX
    %error('not supported OS');
    transformix='transformix';
end
%===============================


format = get_ix(tfile,'ResultImageFormat');
if isempty(im) && isempty(points) && isempty(opt)
    warning('%s\n%s','not enough valued inputs to perform an operation!','please provide values for "im", "points" and/or "opt"'); %#ok<WNTAG>
end

str = '';
if ~isempty(im)
    if isempty(outfold)
        outfold = fileparts(im);
    end
    str = sprintf('! %s -in %s -out %s -tp %s',transformix,['"' im '"'],['"' outfold '"'],['"' tfile '"']);
    flgim = 1;
else
    flgim = 0;
    if isempty(outfold)
        outfold = fileparts(tfile);
    end
end
if ~isempty(str)
    %==========================paul=====
    if ispc
        eval(str);
    else
        if exist('ela')~=1
            ela.pa=pwd;
        end
        thispa=pwd;
        cd(ela.pa);
        eval(str);
        cd(thispa);
    end
    %===============================
end
if flgim
    result = fullfile(outfold,['result.' format]);
    [pp,nn,ee] = fileparts(im); %#ok<NASGU>
    out_im = rename_elastix(result,outfold,sprintf('elx_%s',nn));
else
    out_im = '';
end
str = '';
if ~isempty(points)
    if ~strcmp(opt,'def')
        warning('points are provided: setting evaltype to ''def'''); %#ok<WNTAG>
        opt = 'def';
    end        
    str = sprintf('! %s -%s %s -out %s -tp %s',transformix,opt,['"' points '"'],['"' outfold '"'],['"' tfile '"']);
elseif ~isempty(opt)
    str = sprintf('! %s -%s all -out %s -tp %s',transformix,opt,['"' outfold '"'],['"' tfile '"']);
end
if strcmp(format,'nii') && strcmp(opt,'jacmat')
    set_ix(tfile,'ResultImageFormat','mhd');
end
if ~isempty(str)
        %==========================paul=====
    if ispc
        eval(str);
    else
        if exist('ela')~=1
            ela.pa=pwd;
        end
        thispa=pwd;
        cd(ela.pa);
        evalc(str);
        cd(thispa);
    end
    %===============================
    
    %eval(str);
end
if strcmp(opt,'def')
    if ~isempty(points)
        [pp,nn,ee] = fileparts(points);
        result = fullfile(outfold,'outputpoints.txt');
        out_trans = fullfile(outfold,[nn '-out' ee]);
        movefile(result,out_trans);
    else
        result = fullfile(outfold,['deformationField.' format]);
        [pp,nn,ee] = fileparts(tfile); %#ok<NASGU>
        out_trans = rename_elastix(result,outfold,sprintf('%s-def',nn));
    end
elseif strcmp(opt,'jac')
    result = fullfile(outfold,['spatialJacobian.' format]);
    [pp,nn,ee] = fileparts(tfile); %#ok<NASGU>
    out_trans = rename_elastix(result,outfold,sprintf('%s-jac',nn));
elseif strcmp(opt,'jacmat')
    result = fullfile(outfold,'fullSpatialJacobian.mhd');
    [pp,nn,ee] = fileparts(tfile); %#ok<NASGU>
    out_trans = rename_elastix(result,outfold,sprintf('%s-jacmat',nn));
else
    out_trans = '';
end
set_ix(tfile,'ResultImageFormat',format);