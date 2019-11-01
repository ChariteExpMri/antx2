
function xcheckoverlay(prefdir, mode, saver, keepnfig)


cf;clear

prefdir='O:\harms1\harmsStaircaseTrial\dat';
prefdir={  'O:\harms1\harmsStaircaseTrial\dat\s20150505SM09_1_x_x\t2.nii'}
mode   =1;
saver     =1
keepnfig=1


%% METAFOLDER (char) or    mouseSubfolder/FP-mouseT2.file as (cell)
if ischar(prefdir)
    %     prefdir=pwd;
    msg={'check overlay' 'select mouseFolders with  T2images '};
    [t2path,sts] = cfg_getfile2(inf,'dir',msg,[],prefdir,'^s');
else  %% SINGLE MOUSE path/t2
    t2path=prefdir{1}
    [pas fis exts]=fileparts(t2path)
    if        ~isempty(exts)
        t2path={pas};
    end
end


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% define checkfolder
metametaFolder=fileparts(fileparts(t2path{1}));
checkfolder=fullfile(metametaFolder,'check');

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% MODIES to plot
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if mode==1;
    checkfoldersub=fullfile(checkfolder,'segmentGMnative');
    params={  {'t2.nii' 'c1t2.nii'} ,3,['1'],[.2 .2 0.2 0.2],[1 .5 1],[1 .5 1] };
%     params={  {'t2.nii' 'c1t2.nii'} ,3,['1'],[.4 .2 0.3 0.3],[1 .5 1],[1 .5 1] }
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

if saver==1;
    warning off;
    mkdir(checkfoldersub);
end

for i=1:size(t2path,1)
    
    pa=t2path{i}; if strcmp(pa(end),filesep); pa=pa(1:end-1); end
    params2=params;
    %% check FPpaths  if not determined
    if isempty(fileparts(params2{1}{1}))
        params2{1}{1}=   fullfile( pa,   (params2{1}{1}) );
    end
    if isempty(fileparts(params2{1}{2}))
        params2{1}{2}=   fullfile( pa,   (params2{1}{2}) );
    end
    [ ~, nametag]=fileparts(pa); %LABEL
    filename=fullfile(checkfoldersub, [ '' nametag  '.jpg' ]);
    ovlcontour(params2{:},nametag);
    set(gcf,'tag','checkovl');
    
        %% save plot
        if saver==1;
             print(gcf,'-djpeg','-r300',filename);
        end
        
%     t2=fullfile(pa,'t2.nii')
%     ov=fullfile(pa,'c1t2.nii')
%     [ ~, nametag]=fileparts(pa)
%     filename=fullfile(checkfoldersub, [ '' nametag  '.jpg' ])
%         ovlcontour({t2 ov},3,['1'],[.2 .2 0.2 0.2],[1 .5 1],[1 .5 1],nametag); drawnow;
%     print(gcf,'-djpeg','-r300',filename);
    
%% close first Nfigs, if there are to many
idx=findobj(0,'tag','checkovl');
if ~isnan(keepnfig);
    if length(idx)>keepnfig
        close(idx(keepnfig+1:end));
    end
end
end

%% rename tag
idx2=findobj(0,'tag','checkovl');
try; set(idx,'tag','checkovl_old');end



