function spm_image(op,varargin)
% image and header display
% FORMAT spm_image
%_______________________________________________________________________
%
% spm_image is an interactive facility that allows orthogonal sections
% from an image volume to be displayed.  Clicking the cursor on either
% of the three images moves the point around which the orthogonal
% sections are viewed.  The co-ordinates of the cursor are shown both
% in voxel co-ordinates and millimeters within some fixed framework.
% The intensity at that point in the image (sampled using the current
% interpolation scheme) is also given. The position of the crosshairs
% can also be moved by specifying the co-ordinates in millimeters to
% which they should be moved.  Clicking on the horizontal bar above
% these boxes will move the cursor back to the origin  (analogous to
% setting the crosshair position (in mm) to [0 0 0]).
%
% The images can be re-oriented by entering appropriate translations,
% rotations and zooms into the panel on the left.  The transformations
% can then be saved by hitting the ``Reorient images...'' button.  The
% transformations that were applied to the image are saved to the
% ``.mat'' files of the selected images.  The transformations are
% considered to be relative to any existing transformations that may be
% stored in the ``.mat'' files.  Note that the order that the
% transformations are applied in is the same as in ``spm_matrix.m''.
%
% The ``Reset...'' button next to it is for setting the orientation of
% images back to transverse.  It retains the current voxel sizes,
% but sets the origin of the images to be the centre of the volumes
% and all rotations back to zero.
%
% The right panel shows miscellaneous information about the image.
% This includes:
%   Dimensions - the x, y and z dimensions of the image.
%   Datatype   - the computer representation of each voxel.
%   Intensity  - scalefactors and possibly a DC offset.
%   Miscellaneous other information about the image.
%   Vox size   - the distance (in mm) between the centres of
%                neighbouring voxels.
%   Origin     - the voxel at the origin of the co-ordinate system
%   DIr Cos    - Direction cosines.  This is a widely used
%                representation of the orientation of an image.
%
% There are also a few options for different resampling modes, zooms
% etc.  You can also flip between voxel space (as would be displayed
% by Analyze) or world space (the orientation that SPM considers the
% image to be in).  If you are re-orienting the images, make sure that
% world space is specified.  Blobs (from activation studies) can be
% superimposed on the images and the intensity windowing can also be
% changed.
%
%_______________________________________________________________________
% Copyright (C) 2005 Wellcome Department of Imaging Neuroscience

% John Ashburner
% $Id: spm_image.m 904 2007-09-03 17:41:15Z john $


%
% Modified for animal sized brains and allowed overlays to be shown
% simultaneous to the main image. sjs.
%
global st

if nargin == 0,
    spm('FnUIsetup','Display',0);
    spm('FnBanner',mfilename,'$Rev: 904 $');
    spm_help('!ContextHelp',[mfilename,'.m']);

    % get the image's filename {P}
    %-----------------------------------------------------------------------
    P      = spm_select(1,'image','Select image',[],0);
    spm_image('init',P);
    return;
end;

try
    if ~strcmp(op,'init') && ~strcmp(op,'reset') && isempty(st.vols{1})
        my_reset; warning('Lost all the image information');
        return;
    end;
catch
end

if strcmp(op,'repos'),
    % The widgets for translation rotation or zooms have been modified.
    %-----------------------------------------------------------------------
    fg      = spm_figure('Findwin','Graphics');
    set(fg,'Pointer','watch');
    i       = varargin{1};
    st.B(i) = eval(get(gco,'String'),num2str(st.B(i)));
    set(gco,'String',st.B(i));
    st.vols{1}.premul = spm_matrix(st.B);
    % spm_orthviews2('MaxBB');
    spm_image('zoom_in');
    spm_image('update_info');
    set(fg,'Pointer','arrow');
    return;
end;

if strcmp(op,'shopos'),
    % The position of the crosshairs has been moved.
    %-----------------------------------------------------------------------
    if isfield(st,'mp'),
        fg  = spm_figure('Findwin','Graphics');
        if any(findobj(fg) == st.mp),
            set(st.mp,'String',sprintf('%.1f %.1f %.1f',spm_orthviews2('pos')));
            pos = spm_orthviews2('pos',1);
            set(st.vp,'String',sprintf('%.1f %.1f %.1f',pos));
            set(st.in,'String',sprintf('%g',spm_sample_vol(st.vols{1},pos(1),pos(2),pos(3),st.hld)));
        else
            st.Callback = ';';
            st = rmfield(st,{'mp','vp','in'});
        end;
    else
        st.Callback = ';';
    end;
    return;
end;

if strcmp(op,'setposmm'),
    % Move the crosshairs to the specified position
    %-----------------------------------------------------------------------
    if isfield(st,'mp'),
        fg = spm_figure('Findwin','Graphics');
        if any(findobj(fg) == st.mp),
            pos = sscanf(get(st.mp,'String'), '%g %g %g');
            if length(pos)~=3,
                pos = spm_orthviews2('pos');
            end;
            spm_orthviews2('Reposition',pos);
        end;
    end;
    return;
end;

if strcmp(op,'setposvx'),
    % Move the crosshairs to the specified position
    %-----------------------------------------------------------------------
    if isfield(st,'mp'),
        fg = spm_figure('Findwin','Graphics');
        if any(findobj(fg) == st.vp),
            pos = sscanf(get(st.vp,'String'), '%g %g %g');
            if length(pos)~=3,
                pos = spm_orthviews2('pos',1);
            end;
            tmp = st.vols{1}.premul*st.vols{1}.mat;
            pos = tmp(1:3,:)*[pos ; 1];
            spm_orthviews2('Reposition',pos);
        end;
    end;
    return;
end;

if strcmp(op,'addblobs'),
    % Add blobs to the image - in full colour
    spm_figure('Clear','Interactive');
    nblobs = spm_input('Number of sets of blobs',1,'1|2|3|4|5|6',[1 2 3 4 5 6],1);
    for i=1:nblobs,
        [SPM,VOL] = spm_getSPM;
        c = spm_input('Colour','+1','m','Red blobs|Yellow blobs|Green blobs|Cyan blobs|Blue blobs|Magenta blobs',[1 2 3 4 5 6],1);
        colours = [1 0 0;1 1 0;0 1 0;0 1 1;0 0 1;1 0 1];
        spm_orthviews2('addcolouredblobs',1,VOL.XYZ,VOL.Z,VOL.M,colours(c,:));
        set(st.blobber,'String','Remove Blobs','Callback','spm_image(''rmblobs'');');
    end;
    spm_orthviews2('addcontext',1);
    spm_orthviews2('Redraw');
end;

if strcmp(op,'rmblobs'),
    % Remove all blobs from the images
    spm_orthviews2('rmblobs',1);
    set(st.blobber,'String','Add Blobs','Callback','spm_image(''addblobs'');');
    spm_orthviews2('rmcontext',1);
    spm_orthviews2('Redraw');
end;

if strcmp(op,'window'),
    op = get(st.win,'Value');
    if op == 1,
        spm_orthviews2('window',1);
    else
        spm_orthviews2('window',1,spm_input('Range','+1','e','',2));
    end;
end;


if strcmp(op,'reorient'),
    % Time to modify the ``.mat'' files for the images.
    % I hope that giving people this facility is the right thing to do....
    %-----------------------------------------------------------------------
    mat = spm_matrix(st.B);
    if det(mat)<=0
        spm('alert!','This will flip the images',mfilename,0,1);
    end;
    P = spm_select(Inf, 'image','Images to reorient');
    Mats = zeros(4,4,size(P,1));
    spm_progress_bar('Init',size(P,1),'Reading current orientations',...
        'Images Complete');
    for i=1:size(P,1),
        Mats(:,:,i) = spm_get_space(P(i,:));
        spm_progress_bar('Set',i);
    end;
    spm_progress_bar('Init',size(P,1),'Reorienting images',...
        'Images Complete');
    for i=1:size(P,1),
        spm_get_space(P(i,:),mat*Mats(:,:,i));
        spm_progress_bar('Set',i);
    end;
    spm_progress_bar('Clear');
    tmp = spm_get_space([st.vols{1}.fname ',' num2str(st.vols{1}.n)]);
    if sum((tmp(:)-st.vols{1}.mat(:)).^2) > 1e-8,
        spm_image('init',st.vols{1}.fname);
    end;
    return;
end;

if strcmp(op,'resetorient'),
    % Time to modify the ``.mat'' files for the images.
    % I hope that giving people this facility is the right thing to do....
    %-----------------------------------------------------------------------
    P = spm_select(Inf, 'image','Images to reset orientation of');
    spm_progress_bar('Init',size(P,1),'Resetting orientations',...
        'Images Complete');
    for i=1:size(P,1),
        V    = spm_vol(deblank(P(i,:)));
        M    = V.mat;
        vox  = sqrt(sum(M(1:3,1:3).^2));
        if det(M(1:3,1:3))<0, vox(1) = -vox(1); end;
        orig = (V.dim(1:3)+1)/2;
        off  = -vox.*orig;
        M    = [vox(1) 0      0      off(1)
            0      vox(2) 0      off(2)
            0      0      vox(3) off(3)
            0      0      0      1];
        spm_get_space(P(i,:),M);
        spm_progress_bar('Set',i);
    end;
    spm_progress_bar('Clear');
    tmp = spm_get_space([st.vols{1}.fname ',' num2str(st.vols{1}.n)]);
    if sum((tmp(:)-st.vols{1}.mat(:)).^2) > 1e-8,
        spm_image('init',st.vols{1}.fname);
    end;
    return;
end;

if strcmp(op,'update_info'),
    % Modify the positional information in the right hand panel.
    %-----------------------------------------------------------------------
    mat = st.vols{1}.premul*st.vols{1}.mat;
    Z = spm_imatrix(mat);
    Z = Z(7:9);

    set(st.posinf.z,'String', sprintf('%.3g x %.3g x %.3g', Z));

    O = mat\[0 0 0 1]'; O=O(1:3)';
    set(st.posinf.o, 'String', sprintf('%.3g %.3g %.3g', O));

    R = spm_imatrix(mat);
    R = spm_matrix([0 0 0 R(4:6)]);
    R = R(1:3,1:3);

    tmp2 = sprintf('%+5.3f %+5.3f %+5.3f', R(1,1:3)); tmp2(tmp2=='+') = ' ';
    set(st.posinf.m1, 'String', tmp2);
    tmp2 = sprintf('%+5.3f %+5.3f %+5.3f', R(2,1:3)); tmp2(tmp2=='+') = ' ';
    set(st.posinf.m2, 'String', tmp2);
    tmp2 = sprintf('%+5.3f %+5.3f %+5.3f', R(3,1:3)); tmp2(tmp2=='+') = ' ';
    set(st.posinf.m3, 'String', tmp2);

    tmp = [[R zeros(3,1)] ; 0 0 0 1]*diag([Z 1])*spm_matrix(-O) - mat;

    if sum(tmp(:).^2)>1e-8,
        set(st.posinf.w, 'String', 'Warning: shears involved');
    else
        set(st.posinf.w, 'String', '');
    end;

    return;
end;

if strcmp(op,'reset'),
    my_reset;
end;
global defaults;
if strcmp(op,'zoom_in'),
    op = get(st.zoomer,'Value');
    if op==1,
        scl = 1;
        if(~isempty('defaults'))
            if(isfield(defaults,'animal'))
                scl = defaults.animal.scale;
            end
        end

        spm_orthviews2('resolution',scl);
        spm_orthviews2('MaxBB');
    else
        vx = sqrt(sum(st.Space(1:3,1:3).^2));
        vx = vx.^(-1);
        pos = spm_orthviews2('pos');
        pos = st.Space\[pos ; 1];
        pos = pos(1:3)';
        if     op == 2, st.bb = [pos-10*vx ; pos+10*vx] ; spm_orthviews2('resolution',0.125);
        elseif op == 3, st.bb = [pos-5*vx ; pos+5*vx] ; spm_orthviews2('resolution',0.0625);
        elseif op == 4, st.bb = [pos-1*vx ; pos+1*vx] ; spm_orthviews2('resolution',0.03125);
        elseif op == 5, st.bb = [pos-0.4*vx ; pos+0.4*vx] ; spm_orthviews2('resolution',0.015625);
        else            st.bb = [pos- 0.2*vx ; pos+ 0.2*vx] ; spm_orthviews2('resolution',.00728125);
        end;
    end;
    return;
end;


%=============================0
if strcmp(op,'setparams')
   lab=varargin(1:2:end);
   val=varargin(2:2:end);
   iex=find(strcmp(lab,'col'));
   if ~isempty(iex);        st.overlay.col=val{iex};    end
   iex=find(strcmp(lab,'wt'));
   if ~isempty(iex);        st.overlay.wt=val{iex};    end 
   
   spm_orthviews2('Redraw');
    
end


if strcmp(op,'addoverlay2')
   
  t=varargin{1};
   st.overlay = spm_vol(t);  
   spm_orthviews2('Redraw');
    
end

%===============================

if strcmp(op,'addoverlay')
    % put an overlay on the image
%     t = V:\spmmouse\tpm\output.img,1
    [t,sts]=spm_select(1,'image','Select overlay image',[],pwd);
    if(sts==0) return; end;

    st.overlay = spm_vol(t);
    spm_orthviews2('Redraw');
end

if strcmp(op,'rmoverlay')
    % remove overlay
    if(isfield(st,'overlay'))
        rmfield(st,'overlay');
        spm_orthviews2('Redraw');
    end

end

if strcmp(op,'init'),
    fg = spm_figure('GetWin','Graphics');
    if isempty(fg), error('Can''t create graphics window'); end
    spm_figure('Clear','Graphics');

    P = varargin{1};
    if ischar(P), P = spm_vol(P); end;
    P = P(1);

    spm_orthviews2('Reset');
    spm_orthviews2('Image', P, [0.0 0.45 1 0.55]);
    if isempty(st.vols{1}), return; end;

    spm_orthviews2('MaxBB');
    global defaults
    scl = 1;
    if(~isempty('defaults'))
        if(isfield(defaults,'animal'))
            scl = defaults.animal.scale;
        end
    end

    spm_orthviews2('resolution',scl);

    st.callback = 'spm_image(''shopos'');';

    st.B = [0 0 0  0 0 0  1 1 1  0 0 0];

    % locate Graphics window and clear it
    %-----------------------------------------------------------------------
    WS = spm('WinScale');

    % Widgets for re-orienting images.
    %-----------------------------------------------------------------------
    uicontrol(fg,'Style','Frame','Position',[60 25 200 325].*WS,'DeleteFcn','spm_image(''reset'');');
    uicontrol(fg,'Style','Text', 'Position',[75 220 100 016].*WS,'String','right  {mm}');
    uicontrol(fg,'Style','Text', 'Position',[75 200 100 016].*WS,'String','foward  {mm}');
    uicontrol(fg,'Style','Text', 'Position',[75 180 100 016].*WS,'String','up  {mm}');
    uicontrol(fg,'Style','Text', 'Position',[75 160 100 016].*WS,'String','pitch  {rad}');
    uicontrol(fg,'Style','Text', 'Position',[75 140 100 016].*WS,'String','roll  {rad}');
    uicontrol(fg,'Style','Text', 'Position',[75 120 100 016].*WS,'String','yaw  {rad}');
    uicontrol(fg,'Style','Text', 'Position',[75 100 100 016].*WS,'String','resize  {x}');
    uicontrol(fg,'Style','Text', 'Position',[75  80 100 016].*WS,'String','resize  {y}');
    uicontrol(fg,'Style','Text', 'Position',[75  60 100 016].*WS,'String','resize  {z}');

    uicontrol(fg,'Style','edit','Callback','spm_image(''repos'',1)','Position',[175 220 065 020].*WS,'String','0','ToolTipString','translate');
    uicontrol(fg,'Style','edit','Callback','spm_image(''repos'',2)','Position',[175 200 065 020].*WS,'String','0','ToolTipString','translate');
    uicontrol(fg,'Style','edit','Callback','spm_image(''repos'',3)','Position',[175 180 065 020].*WS,'String','0','ToolTipString','translate');
    uicontrol(fg,'Style','edit','Callback','spm_image(''repos'',4)','Position',[175 160 065 020].*WS,'String','0','ToolTipString','rotate');
    uicontrol(fg,'Style','edit','Callback','spm_image(''repos'',5)','Position',[175 140 065 020].*WS,'String','0','ToolTipString','rotate');
    uicontrol(fg,'Style','edit','Callback','spm_image(''repos'',6)','Position',[175 120 065 020].*WS,'String','0','ToolTipString','rotate');
    uicontrol(fg,'Style','edit','Callback','spm_image(''repos'',7)','Position',[175 100 065 020].*WS,'String','1','ToolTipString','zoom');
    uicontrol(fg,'Style','edit','Callback','spm_image(''repos'',8)','Position',[175  80 065 020].*WS,'String','1','ToolTipString','zoom');
    uicontrol(fg,'Style','edit','Callback','spm_image(''repos'',9)','Position',[175  60 065 020].*WS,'String','1','ToolTipString','zoom');

    uicontrol(fg,'Style','Pushbutton','String','Reorient images...','Callback','spm_image(''reorient'')',...
        'Position',[70 35 125 020].*WS,'ToolTipString','modify position information of selected images');

    uicontrol(fg,'Style','Pushbutton','String','Reset...','Callback','spm_image(''resetorient'')',...
        'Position',[195 35 55 020].*WS,'ToolTipString','reset orientations of selected images');

    % Crosshair position
    %-----------------------------------------------------------------------
    uicontrol(fg,'Style','Frame','Position',[70 250 180 90].*WS);
    uicontrol(fg,'Style','Text', 'Position',[75 320 170 016].*WS,'String','Crosshair Position');
    uicontrol(fg,'Style','PushButton', 'Position',[75 316 170 006].*WS,...
        'Callback','spm_orthviews2(''Reposition'',[0 0 0]);','ToolTipString','move crosshairs to origin');
    % uicontrol(fg,'Style','PushButton', 'Position',[75 315 170 020].*WS,'String','Crosshair Position',...
    %	'Callback','spm_orthviews2(''Reposition'',[0 0 0]);','ToolTipString','move crosshairs to origin');
    uicontrol(fg,'Style','Text', 'Position',[75 295 35 020].*WS,'String','mm:');
    uicontrol(fg,'Style','Text', 'Position',[75 275 35 020].*WS,'String','vx:');
    uicontrol(fg,'Style','Text', 'Position',[75 255 65 020].*WS,'String','Intensity:');

    st.mp = uicontrol(fg,'Style','edit', 'Position',[110 295 135 020].*WS,'String','','Callback','spm_image(''setposmm'')','ToolTipString','move crosshairs to mm coordinates');
    st.vp = uicontrol(fg,'Style','edit', 'Position',[110 275 135 020].*WS,'String','','Callback','spm_image(''setposvx'')','ToolTipString','move crosshairs to voxel coordinates');
    st.in = uicontrol(fg,'Style','Text', 'Position',[140 255  85 020].*WS,'String','');

    % General information
    %-----------------------------------------------------------------------
    uicontrol(fg,'Style','Frame','Position',[305  25 280 325].*WS);
    uicontrol(fg,'Style','Text','Position' ,[310 330 50 016].*WS,...
        'HorizontalAlignment','right', 'String', 'File:');
    uicontrol(fg,'Style','Text','Position' ,[360 330 210 016].*WS,...
        'HorizontalAlignment','left', 'String', spm_str_manip(st.vols{1}.fname,'k25'),'FontWeight','bold');
    uicontrol(fg,'Style','Text','Position' ,[310 310 100 016].*WS,...
        'HorizontalAlignment','right', 'String', 'Dimensions:');
    uicontrol(fg,'Style','Text','Position' ,[410 310 160 016].*WS,...
        'HorizontalAlignment','left', 'String', sprintf('%d x %d x %d', st.vols{1}.dim(1:3)),'FontWeight','bold');
    uicontrol(fg,'Style','Text','Position' ,[310 290 100 016].*WS,...
        'HorizontalAlignment','right', 'String', 'Datatype:');
    uicontrol(fg,'Style','Text','Position' ,[410 290 160 016].*WS,...
        'HorizontalAlignment','left', 'String', spm_type(st.vols{1}.dt(1)),'FontWeight','bold');
    uicontrol(fg,'Style','Text','Position' ,[310 270 100 016].*WS,...
        'HorizontalAlignment','right', 'String', 'Intensity:');
    str = 'varied';
    if size(st.vols{1}.pinfo,2) == 1,
        if st.vols{1}.pinfo(2),
            str = sprintf('Y = %g X + %g', st.vols{1}.pinfo(1:2)');
        else
            str = sprintf('Y = %g X', st.vols{1}.pinfo(1)');
        end;
    end;
    uicontrol(fg,'Style','Text','Position' ,[410 270 160 016].*WS,...
        'HorizontalAlignment','left', 'String', str,'FontWeight','bold');

    if isfield(st.vols{1}, 'descrip'),
        uicontrol(fg,'Style','Text','Position' ,[310 250 260 016].*WS,...
            'HorizontalAlignment','center', 'String', st.vols{1}.descrip,'FontWeight','bold');
    end;


    % Positional information
    %-----------------------------------------------------------------------
    mat = st.vols{1}.premul*st.vols{1}.mat;
    Z = spm_imatrix(mat);
    Z = Z(7:9);
    uicontrol(fg,'Style','Text','Position' ,[310 210 100 016].*WS,...
        'HorizontalAlignment','right', 'String', 'Vox size:');
    st.posinf = struct('z',uicontrol(fg,'Style','Text','Position' ,[410 210 160 016].*WS,...
        'HorizontalAlignment','left', 'String', sprintf('%.3g x %.3g x %.3g', Z),'FontWeight','bold'));

    O = mat\[0 0 0 1]'; O=O(1:3)';
    uicontrol(fg,'Style','Text','Position' ,[310 190 100 016].*WS,...
        'HorizontalAlignment','right', 'String', 'Origin:');
    st.posinf.o = uicontrol(fg,'Style','Text','Position' ,[410 190 160 016].*WS,...
        'HorizontalAlignment','left', 'String', sprintf('%.3g %.3g %.3g', O),'FontWeight','bold');

    R = spm_imatrix(mat);
    R = spm_matrix([0 0 0 R(4:6)]);
    R = R(1:3,1:3);

    uicontrol(fg,'Style','Text','Position' ,[310 170 100 016].*WS,...
        'HorizontalAlignment','right', 'String', 'Dir Cos:');
    tmp2 = sprintf('%+5.3f %+5.3f %+5.3f', R(1,1:3)); tmp2(tmp2=='+') = ' ';
    st.posinf.m1 = uicontrol(fg,'Style','Text','Position' ,[410 170 160 016].*WS,...
        'HorizontalAlignment','left', 'String', tmp2,'FontWeight','bold');
    tmp2 = sprintf('%+5.3f %+5.3f %+5.3f', R(2,1:3)); tmp2(tmp2=='+') = ' ';
    st.posinf.m2 = uicontrol(fg,'Style','Text','Position' ,[410 150 160 016].*WS,...
        'HorizontalAlignment','left', 'String', tmp2,'FontWeight','bold');
    tmp2 = sprintf('%+5.3f %+5.3f %+5.3f', R(3,1:3)); tmp2(tmp2=='+') = ' ';
    st.posinf.m3 = uicontrol(fg,'Style','Text','Position' ,[410 130 160 016].*WS,...
        'HorizontalAlignment','left', 'String', tmp2,'FontWeight','bold');

    tmp = [[R zeros(3,1)] ; 0 0 0 1]*diag([Z 1])*spm_matrix(-O) - mat;
    st.posinf.w = uicontrol(fg,'Style','Text','Position' ,[310 110 260 016].*WS,...
        'HorizontalAlignment','center', 'String', '','FontWeight','bold');
    if sum(tmp(:).^2)>1e-8,
        set(st.posinf.w, 'String', 'Warning: shears involved');
    end;

    % Assorted other buttons.
    %-----------------------------------------------------------------------
    uicontrol(fg,'Style','Frame','Position',[310 30 270 100].*WS); % changed 70 to 110 to accommodate new button for overlays
    st.zoomer = uicontrol(fg,'Style','popupmenu' ,'Position',[315 105 125 20].*WS,...
        'String',char('Full Volume','20x20x20mm','10x10x10mm','2x2x2mm','800x800x800um','400x400x400um'),...
        'Callback','spm_image(''zoom_in'')','ToolTipString','zoom in by different amounts');
    c = 'if get(gco,''Value'')==1, spm_orthviews2(''Space''), else, spm_orthviews2(''Space'', 1);end;spm_image(''zoom_in'')';
    uicontrol(fg,'Style','popupmenu' ,'Position',[315 82 125 20].*WS,...
        'String',char('World Space','Voxel Space'),...
        'Callback',c,'ToolTipString','display in aquired/world orientation');
    c = 'if get(gco,''Value'')==1, spm_orthviews2(''Xhairs'',''off''), else, spm_orthviews2(''Xhairs'',''on''); end;';
    uicontrol(fg,'Style','togglebutton','Position',[450 95 125 20].*WS,...
        'String','Hide Crosshairs','Callback',c,'ToolTipString','show/hide crosshairs');
    uicontrol(fg,'Style','popupmenu' ,'Position',[450 75 125 20].*WS,...
        'String',char('NN interp','bilin interp','sinc interp'),...
        'Callback','tmp_ = [0 1 -4];spm_orthviews2(''Interp'',tmp_(get(gco,''Value'')))',...
        'Value',2,'ToolTipString','interpolation method for displaying images');
    st.win = uicontrol(fg,'Style','popupmenu','Position',[315 60 125 20].*WS,...
        'String',char('Auto Window','Manual Window'),'Callback','spm_image(''window'');','ToolTipString','range of voxel intensities displayed');
    % uicontrol(fg,'Style','pushbutton','Position',[315 35 125 20].*WS,...
    % 	'String','Window','Callback','spm_image(''window'');','ToolTipString','range of voxel intensities % displayed');

    %added by sjs - overlay image
    uicontrol(fg,'Style','pushbutton','Position',[315 35 125 20].*WS,...
        'String','Add Overlay',...
        'Callback','spm_image(''addoverlay'');',...
        'ToolTipString','Add overlay image');

    st.blobber = uicontrol(fg,'Style','pushbutton','Position',[450 35 125 20].*WS,...
        'String','Add Blobs','Callback','spm_image(''addblobs'');','ToolTipString','superimpose activations');
end;
return;


function my_reset
spm_orthviews2('reset');
spm_figure('Clear','Graphics');
return;
