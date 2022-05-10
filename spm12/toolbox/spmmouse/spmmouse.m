function spmmouse(varargin)
%SPMMouse - toolbox for SPM for animal brains
%Stephen Sawiak - http://www.wbic.cam.ac.uk/~sjs80/spmmouse.html


global spmmouseset

isDesktop=usejava('desktop');   
    
    % DISPLAY_COMMAND_OUTPUT_IN_CMD-WINDOW
    if isDesktop==1
        fg = spm_figure('FindWin','Menu');
        if isempty(fg)
            spm('PET');
        end
    else
        spm('defaults', 'fmri');
        %spm_jobman('initcfg')
        spm_get_defaults('cmdline',true);
        
    end
    
    % what should we do
    if nargin == 0 
        showinfo;
        return;
    end

    str = varargin{1};

switch lower(str)
    case {'load','loadpreset'}
        loadpreset(varargin{2:end});
    case 'unload'
        unload;
    case 'createpreset'
        createpreset;
    case 'loadimage'
        loadimage;
    case 'autochk'
        autochk;clear
    case 'slideru'
        slideru;
    case 'sliderl'
        sliderl;
    case 'slidert'
        slidert;
    case 'createmip'
        createmip;
    case 'priors'
        priors;
    case 'savepreset'
        savepreset;
    case 'applypreset'
        applypreset;
end


%------------------------------
function initspmmouseset
global spmmouseset
        mypath = mfilename('fullpath');
        spmmouseset.oldpath = path;
        spmmouseset.path = fileparts(mypath);
        spmmouseset.title = 'SPMMouse v1.0';
        spmmouseset.margin = 15;
        spmmouseset.size = [400 364];

%------------------------------
function showinfo
global spmmouseset;
if isempty(spmmouseset)
    initspmmouseset;
end;

    try
        gfig = spm_figure('FindWin','Graphics');
        figure(gfig);
    catch
        fprintf(1,'Could not find SPM graphics window ! Is SPM loaded ?\n');
        return;
    end
    
    % clear everything visible from graphics window
	delete(findobj(get(gfig,'Children'),'flat','HandleVisibility','on'));
    % clear callbacks
	set(gfig,'KeyPressFcn','','WindowButtonDownFcn','','WindowButtonMotionFcn','','WindowButtonUpFcn','');
    winscale = spm('WinScale');
    tTitle = uicontrol(gfig,'Style','Text','Position',[20 800 560 40].*winscale,'String',spmmouseset.title,'FontSize',24,'BackgroundColor','w');
    tInfo = uicontrol(gfig,'Style','Edit','Position',[20 180 560 560].*winscale,...
             'FontSize',14,'FontWeight','normal','BackgroundColor',[1 1 0.5],'Min',0,'Max',2,'Enable','on','Value',0,'Enable','inactive');

     newl = sprintf('\n');   
     set(tInfo,'String', ...
         {'SPMMouse is a series of modifications to SPM making it easy to use non-human brains. It includes templates for the mouse brain but is generally applicable, and an interface is provided to make a ''glass brain'' from any brain-extracted image.',newl,...
         'Modifications to default settings allow realign, coregister, normalise, segment, etc to work with non-human images. A new option appears in Display allowing an overlay to be displayed on the image, easing initial manual registration.',newl,...
         'Use of VBM in the mouse brain is described in',...
         'S.J. Sawiak et al. "Voxel-based Morphometry Reveals Changes Not Seen with Manual 2D Volumetry in the R6/2 Huntingdon''s disease mouse brain. Neurobiol. Dis. (2009) 33(1) p20-27',newl,...
         'Please cite this paper if you use this toolbox. Sample data, updates and tutorials are available from',...
         '      http://www.wbic.cam.ac.uk/~sjs80/spmmouse.html','',...
         'Bug reports and suggestions should be sent to','','Stephen Sawiak','sjs80@cam.ac.uk'});
     set(tInfo,'Listboxtop',1)
     
     
      uicontrol('Position',[20 760 148 30].*winscale,'String','Load Animal Preset',...
          'Callback','spmmouse(''loadpreset'');');
      uicontrol('Position',[180 760 148 30].*winscale,'String','Create Animal Preset',...
          'Callback','spmmouse(''createpreset'');');
      uicontrol('Position',[340 760 148 30].*winscale,'String','Unload SPMMouse',...
          'Callback','spmmouse(''unload'');');
      
      try 
          im=imread('mouse.jpg');
          axes('Position',[0.8 0.01 0.2 0.2]);
          imagesc(im);axis image off;
      catch
          % it doesn't matter if the mouse can't be displayed ;)
      end

%--------------------------
function unload
global spmmouseset
    if ~isempty(spmmouseset)
       adjustdefaults('unset');
       spmmouseset=[];
    end
    
    
%--------------------------
function loadpreset(filename)
% If no filename given, use GUI to ask for details & print summary. With
% a filename, work silently.
global spmmouseset;
if isempty(spmmouseset)
    initspmmouseset;
end;
if nargin == 0
    % 
    % ask user for a preset file
    filename = spm_select(1,'mat','Select preset...',[], ...
                          spmmouseset.path);
end
try 
    preset = load(char(filename));
catch
    fprintf(1,'Couldn''t open file, or file is corrupt / not preset file! Aborting.\n');
    return;
end
%load things about the glass brain and scaling factors
try
    spmmouseset.animal.name  = preset.name;
    spmmouseset.animal.mipmat= preset.mipmat;
    load(char(preset.mipmat),'scale');
    spmmouseset.animal.scale = 1./scale(1);
catch
    fprintf(1,'Critical fields missing from preset file - aborting\n.');
    return;
end
if(isfield(preset,'isig')) % does the file have any priors in it?
                           % will be read by replaced/spm_affine_priors.m
    spmmouseset.animal.isig = preset.isig;
    spmmouseset.animal.mu = preset.mu(:);
end
if(isfield(preset,'grey'))
    % can we open the file?
    if ~spm_existfile(preset.grey)
        % no - is it in the spmmouse tpm directory?
        [gpth,gnm,gext,gfr] = spm_fileparts(preset.grey);
        [wpth,wnm,wext,wfr] = spm_fileparts(preset.white);
        [cpth,cnm,cext,cfr] = spm_fileparts(preset.csf);
        % best just pretend we have nothing
        preset = rmfield(preset,{'grey','white','csf'});
        % try to find tpms
        if spm_existfile(fullfile(spmmouseset.path,'tpm',[gnm gext]))
            % yes - let's just update it
            preset.grey = fullfile(spmmouseset.path,'tpm',[gnm gext gfr]);
            % white and csf files probably in same place, let's
            % take a chance ... 
            preset.white= fullfile(spmmouseset.path,'tpm',[wnm wext wfr]);
            preset.csf  = fullfile(spmmouseset.path,'tpm',[cnm cext cfr]);
        elseif nargin == 0
            % no - ask the user
            if strcmpi(questdlg(sprintf('Couldn''t find \n"%s"\n\nWould you like to locate tissue probability maps now?', preset.grey), preset.name, 'Yes', 'No', 'Yes'),'yes')
                [files,sts] = spm_select(3,'image','Select grey, white, csf TPMs');
                if sts
                    preset.grey  = deblank(files(1,:));
                    preset.white = deblank(files(2,:));
                    preset.csf   = deblank(files(3,:));
                    % user will probably want to save this,
                    % let's just do it 
                    try
                        save(filename, '-v6', '-struct', 'preset');
                    catch
                        warning('Couldn''t save amended preset file');
                    end
                end
            end
        end
    end
end
if isfield(preset,'grey')
    spmmouseset.animal.tpm = char(...
        preset.grey,...
        preset.white,...
        preset.csf); % Prior probability maps
end
adjustdefaults;
if nargin == 0
    try
        gfig = findobj('Tag','Graphics');
        figure(gfig);
    catch
        fprintf(1,'Could not find SPM graphics window ! Is SPM loaded ?\n');
        return;
    end
    % clear everything visible from graphics window
    delete(findobj(get(gfig,'Children'),'flat','HandleVisibility','on'));
    % clear callbacks
    set(gfig,'KeyPressFcn','','WindowButtonDownFcn','','WindowButtonMotionFcn','','WindowButtonUpFcn','');
    winscale = spm('WinScale');
    tTitle = uicontrol(gfig,'Style','Text','Position',[20 800 560 40].*winscale,'String',spmmouseset.title,'FontSize',24,'BackgroundColor','w');
    tName = uicontrol(gfig,'Style','Text','Position',[20 700 560 40].*winscale,'String',spmmouseset.animal.name,'FontSize',14,'BackgroundColor','w','FontWeight','bold','ForegroundColor','b');
    uicontrol('Position',[20 760 148 30].*winscale,'String','Show Welcome Screen',...
              'Callback','spmmouse;');
    %uicontrol('Position',[180 760 148 30].*winscale,'String','Edit Preset',...
    %  'Callback','spmmouse(''editpreset'');');
    % display details of the loaded preset
    axmip = axes('Position',[0.1 0.4 0.4 0.4]);
    mip=load(char(preset.mipmat));
    imagesc(rot90(mip.mask_all)); axis image off; colormap gray;
    title('Preview of MIP template');
    if(isfield(preset,'grey'))
        strtpms = sprintf('TPMs:\n%s\n%s\n%s\n',preset.grey,preset.white,preset.csf);
    else
        strtpms = sprintf('No TPMs specified in preset.\n');
    end
    tInfo = uicontrol(gfig,'Style','Text','Position',[20 50 560 250].*winscale,'String','','FontSize',12,'BackgroundColor','w','FontWeight','bold');
    set(tInfo, 'String', ...
               {sprintf('CX %i CY %i CZ %i DX %i DY %i DZ %i scale %f %f %f', ...
                        mip.CXYZ, mip.DXYZ, mip.scale), ...
                '',strtpms,'','preset file:',filename,'','Ready to go, use SPM as normal.',''});
end
%----------------------------------
function adjustdefaults(cmd)
% Set and unset small animal specific defaults for spatial processing
% FORMAT adjustdefaults('set')
% Override SPM (human brain sized) defaults with values suitable for
% images with smaller FOV. Previous defaults will be saved.
% FORMAT adjustdefaults('unset')
% Reset defaults to values before the last call to
% adjustdefaults('set'). Usually, this will be human brain sized
% defaults, except if adjustdefaults('set') has been called more than
% once.
persistent olddefs
global spmmouseset;
if nargin == 0
    cmd = 'set';
end
% Defaults sections to be modified
%=======================================================================
defnames = {'realign','unwarp','coreg','normalise','preproc','smooth','stats'};

switch cmd,
    case 'set'
        try
            for cdef = 1:numel(defnames)
                olddefs.(defnames{cdef}) = spm_get_defaults(defnames{cdef});
            end
            newdefs = olddefs;

            animal = spmmouseset.animal;
            % now adjust all settings based on scale - all these numbers can be
            % adjusted in the particular interfaces for each function, they are
            % reasonable enough but not really worth adding a further fudge-factor
            % modifying interface...

            fixedscale = 0.01 * round(animal.scale * 100);
    
            newdefs.realign.estimate.sep    = 3*fixedscale;
            newdefs.realign.estimate.fwhm   = 4*fixedscale;

            newdefs.unwarp.estimate.fwhm    = 4*fixedscale;
            newdefs.unwarp.estimate.basfcn  = [12 12]*fixedscale;

            newdefs.coreg.estimate.sep      = fixedscale*[4 2];
            newdefs.coreg.estimate.tol      = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
            newdefs.coreg.estimate.fwhm     = 7*[fixedscale fixedscale]; % bug fix 22/7/09

            newdefs.normalise.estimate.smosrc  = 8*fixedscale;
            newdefs.normalise.estimate.smoref  = 0;
            newdefs.normalise.estimate.regtype = 'none';
            newdefs.normalise.estimate.cutoff  = 25*fixedscale; 
            newdefs.normalise.write.bb         = [[-6 -10 -10];[6 7 1]];
            newdefs.normalise.write.vox        = fixedscale*[2 2 2];


            % for bias correction
            allowedvals = [1,2,5,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,Inf];

            newdefs.preproc.ngaus    = [3 2 2 4]'; % Gaussians per class
            newdefs.preproc.warpco   = 25*fixedscale;
            newdefs.preproc.biasfwhm = allowedvals(find(allowedvals>=(60*fixedscale),1,'first'));
            newdefs.preproc.fudge    = .5;
            newdefs.preproc.samp     = 3*fixedscale;
            newdefs.preproc.regtype = 'animal';
            if(isfield(animal,'tpm'))
                newdefs.preproc.tpm = cellstr(animal.tpm);
            end

            newdefs.smooth.fwhm  = [8 8 8].*fixedscale;
   
            newdefs.stats.results.volume.distmin = 8*fixedscale; 
            newdefs.stats.results.svc.distmin    = 4*fixedscale; 
            newdefs.stats.results.mipmat         = animal.mipmat;

        catch
            fprintf(1,'..warning setting defaults in spmmouse not loaded...but this neend''t to be a problem!u\n');
            return;
        end

        spm_get_defaults('animal', spmmouseset.animal);
        for cdef = 1:numel(defnames)
            spm_get_defaults(defnames{cdef},newdefs.(defnames{cdef}));
        end
        % Zoom defaults
        %===============================================================
        [olddefs.orthviews.zoom.fov olddefs.orthviews.zoom.res] = ...
            spm_orthviews('ZoomMenu');
        newdefs.orthviews.zoom.fov = [Inf 20  10  5    2   1];
        newdefs.orthviews.zoom.res = [ .1 .05 .05 .025 .01 .01];
        spm_orthviews('ZoomMenu',newdefs.orthviews.zoom.fov,  newdefs.orthviews.zoom.res);
        % VBM8 defaults
        %===============================================================
        try
            olddefs.vbm8.opts = cg_vbm8_get_defaults('opts');
            newdefs.vbm8.opts = olddefs.vbm8.opts;
            newdefs.vbm8.opts.tpm       = {fullfile(spm('dir'),'toolbox','Seg','TPM.nii')}; % TPM.nii
            newdefs.vbm8.opts.ngaus     = [3 2 2 3 4 2];  % Gaussians per class
            newdefs.vbm8.opts.affreg    = 'animal';    % Affine regularisation
            newdefs.vbm8.opts.biasfwhm  = allowedvals(find(allowedvals>=(60*fixedscale),1,'first'));   % Bias FWHM
            newdefs.vbm8.opts.samp      = 3*fixedscale;      % Sampling distance
            cg_vbm8_get_defaults('opts',newdefs.vbm8.opts);
        end
        addpath(fullfile(spmmouseset.path,'replaced'),'-begin');
    case 'unset',
        if ~isempty(olddefs)
            for cdef = 1:numel(defnames)
                spm_get_defaults(defnames{cdef},olddefs.(defnames{cdef}));
            end
            spm_orthviews('ZoomMenu',olddefs.orthviews.zoom.fov,  olddefs.orthviews.zoom.res);
            if isfield(olddefs,'vbm8')
                cg_vbm8_get_defaults('opts',olddefs.vbm8.opts);
            end
        end
        spm_get_defaults('animal',[]);
        rmpath(fullfile(spmmouseset.path,'replaced'));
end
