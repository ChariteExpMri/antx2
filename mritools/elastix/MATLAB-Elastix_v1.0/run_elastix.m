function [out_ims,out_trns] = run_elastix(fix_ims,mov_ims,outfold,pfiles,fix_mask,mov_mask,t0file,threads,priority)

% run_elastix runs elastix.exe with a desired set of inputs
%
% Usage: 
% [rmovs,tfile] = run_elastix(fix,mov,out,pfiles,fix_m,mov_m,t0file,threads,prio)
%
% -----------------------------Inputs--------------------------------------
% fix: string vector or cell array with fixed images
% mov: string vector or cell array with moving images
% out: output directory (empty: first moving image directory)
% pfiles: parameter files (more than 1 is for multiple registrations in one run)
% fix_m: string vector or cell array with the of masks of the fixed images 
%       (empty: no mask)
% mov_m: string vector or cell array with the of masks of the moving images 
%       (empty: no mask)
% t0file: initial transformation file (empty: no initial file)
% threads: number of threads (empty: 2)
% prio: priority of the process (empty: normal)
% 
% Note #1: The number of fixed and moving images must be the same. More than
% 1 is intented for multispectral registration
% Note #2: The number of masks images (if not empty) must be the same as the
% number of their corresponding images
% ------------------------------Outputs----------------------------------
% rmovs: registered images, named as the moving image but prefixed with 'elx_' 
%        and postfixed by -(n-1), indicating the image warped by the n-th 
%        parameter file (if WriteResultImage = "false" for the n-th parameter
%        file, the corresponding rmov(n,:) = 'not written')
% tfile: resulting text (ASCII) transformation file (moving image name prefixed
%        with 'elx_' and postfixed with '(n-1)-trns.txt', for the n-th parameter 
%        file)
%
% 5/3/2011
% version 1.0b
% 
% Pedro Antonio Vald�s Hern�ndez
% Neuroimaging Department
% Cuban Neuroscience Center
%===============================
if ispc
    elastix = which('elastix.exe');
elseif ismac
    ela=elastix4mac;
    elastix=ela.E;
else
    %LINUX
    arg=evalc('!elastix');
    if regexpi2(cellstr(arg),' "elastix --help" for information') ~=1
        disp('ELASSTIX FOR LINUX NOT FOUND/INSTALLED');
        disp('INSTALL ELASSTIX FOR LINUX');
        disp('see: https://www.youtube.com/watch?v=spo6UA3PFsU');
        disp('1) in terminal type: sudo apt-get install elastix');
        disp('- if this does not work, type: ');
        disp('   1a) type: sudo dpkg --configure -a');
        disp('   1b) type: sudo apt-get install elastix');
        disp('2) check: type: elastix —help  ');
        error('INSTALL ELASSTIX FOR LINUX ..elastix not installed ');
    end
    elastix='elastix';
     
    
    
end
%===============================
if iscell(pfiles)
    pfiles = strvcat(pfiles{:}); %#ok<VCAT>
end
if iscell(fix_ims)
    fix_ims = strvcat(fix_ims{:}); %#ok<VCAT>
end
if iscell(mov_ims)
    mov_ims = strvcat(mov_ims{:}); %#ok<VCAT>
end
if isempty(outfold)
    outfold = fileparts(deblank(mov_ims(1,:)));
end
if size(fix_ims,1) ~= size(mov_ims,1)
    error('the number of fixed and moving images must be the same');
end
if size(fix_ims,1) == 1
    str = sprintf('!%s -f %s -m %s -out %s',elastix,['"' fix_ims '"'],['"' mov_ims '"'],['"' outfold '"']);
else
    str = sprintf('!%s -out %s',elastix,['"' outfold '"']);
    for i = 1:size(fix_ims,1)
        str = addopt(str,sprintf('f%d',i-1),['"' deblank(fix_ims(i,:)) '"']);
    end
    for i = 1:size(mov_ims,1)
        str = addopt(str,sprintf('m%d',i-1),['"' deblank(mov_ims(i,:)) '"']);
    end
end
for i = 1:size(pfiles,1)
    str = addopt(str,'p',['"' deblank(pfiles(i,:)) '"']);
end
str = addopt(str,'fMask',['"' deblank(fix_mask) '"']);
str = addopt(str,'mMask',['"' deblank(mov_mask) '"']);
str = addopt(str,'t0',['"' t0file '"']);
str = addopt(str,'threads',num2str(threads));
str = addopt(str,'priority',priority);

%===============================
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


out_ims = cell(size(pfiles,1),1);
out_trns = cell(size(pfiles,1),1);
for i = 1:size(pfiles,1)
    w = get_ix(deblank(pfiles(end,:)),'WriteResultImage');
    format = get_ix(deblank(pfiles(end,:)),'ResultImageFormat');
    if str2num(w) %#ok<ST2NM>
        result = fullfile(outfold,sprintf('result.%d.%s',i-1,format));
        [pp,nn,ee] = fileparts(deblank(mov_ims(1,:))); %#ok<NASGU>
        out_ims{i} = rename_elastix(result,outfold,sprintf('elx_%s-%d',nn,i-1));
    else
        out_ims{i} = 'not written';
    end
    transform = fullfile(outfold,sprintf('TransformParameters.%d.txt',i-1));
    if exist(transform,'file')
       % [pp,nn,ee] = fileparts(deblank(mov_ims(1,:))); %#ok<NASGU>
        %out_trns{i} = fullfile(outfold,sprintf('elx_%s-%d-trns.txt',nn,i-1));
       % movefile(transform,out_trns{i});
       out_trns{i}=transform;
    end
end
out_ims = strvcat(out_ims{:}); %#ok<VCAT>
out_trns = strvcat(out_trns{:}); %#ok<VCAT>

function str = addopt(str,optstr,opt)

if ~isempty(opt)
    str = sprintf('%s -%s %s',str,optstr,opt);
end