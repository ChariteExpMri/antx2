
%% check overlay using contour
%%  xcheckoverlay(prefdir, mode, saver, keepnfig)
%% INPUTS
% prefdir    - METAFOLDER (char) directing to all mouseFolders --># this OPENS A GUI for SELECTION
%                or   single mouseSubfolder/fullpath-mouseT2.file as (cell)
% mode    : [1]  OVERLAY (T2, GM) in native space
%               ..other modes will follow
% saver     :[0/1] save plot in "check" Folder ("check" Folder is on the same level as mouse-METAFOLDER)
% keepnfig: [0,n,nan] keep N figures (delete the Xoldest), 0: close fig directly after creation (useful for savingIssue)
%                     nan: keep all figs
% Note: guiSelection can be multiple opened without distroying older figures   -->for comparisons
%% examples GUI-mouseSelection
% xcheckoverlay('O:\harms1\harmsStaircaseTrial\dat', 1, 0, nan); %metafolder+GUI,mode=1,don't save, keep all figs
% xcheckoverlay('O:\harms1\harmsStaircaseTrial\dat', 1, 1, 2);     %metafolder+GUI,mode=1,save, keep latest two figs
%% examples NO-gui (via Fullpath name of T2.nii or via specific mousefolder)
% xcheckoverlay({  'O:\harms1\harmsStaircaseTrial\dat\s20150505SM09_1_x_x\t2.nii'}, 1, 1, 2); %USE THIS MOUSE -->this does not imply that the T2.nii is used,
%  xcheckoverlay({  'O:\harms1\harmsStaircaseTrial\dat\s20150505SM09_1_x_x'}, 1, 1, 2);
%% example study
% xcheckoverlay('O:\harms1\harmsStaircaseTrial\dat', 1, 1, 1);  %GUI+mode1+save+keep currentFig
% xcheckoverlay('O:\harms1\harmsStaircaseTrial\dat', 2, 0, 1); %mask+fliterGui
%  xcheckoverlay('O:\harms1\koeln\dat', 3, 1, 1)  % wt2.nii + templates GM1 
function xcheckoverlay(prefdir, mode, saver, keepnfig)

if 0
    cf;clear
    
    prefdir='O:\harms1\harmsStaircaseTrial\dat';
    prefdir={  'O:\harms1\harmsStaircaseTrial\dat\s20150505SM09_1_x_x\t2.nii'}
    mode   =1;
    saver     =1
    keepnfig=1
end


%% METAFOLDER (char) or    mouseSubfolder/FP-mouseT2.file as (cell)
if ischar(prefdir)
    %     prefdir=pwd;
    msg={'check overlay' 'select mouseFolders with  T2images '};
    [t2path,sts] = cfg_getfile2(inf,'dir',msg,[],prefdir,'^s');
    
    %% define checkfolder
    metametaFolder=fileparts(fileparts(fileparts(t2path{1})));
else  %% SINGLE MOUSE path/t2
    t2path=prefdir(1);
    [pas fis exts]=fileparts(t2path{1});
    if     ~isempty(exts)
        t2path={pas};
    end
    %% define checkfolder
    metametaFolder=fileparts(fileparts(t2path{1}));
end


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

checkfolder=fullfile(metametaFolder,'check');



%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% MODIES to plot
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if mode==1;
    checkfoldersub=fullfile(checkfolder,'segmentGMnative');
    params={  {'t2.nii' 'c1t2.nii'} ,3,['1'],[.2 .2 0.2 0.2],[1 0 -1],[1 .5 1] };
    %     params={  {'t2.nii' 'c1t2.nii'} ,3,['1'],[.4 .2 0.3 0.3],[1 .5 1],[1 .5 1] }
elseif mode==2
    checkfoldersub=fullfile(checkfolder,'mask2native');
    params={  {'t2.nii' '*.nii'} ,3,['1'],[.2 .2 0.2 0.2],[1 0 -1],[1 .5 1] };
elseif mode==3
    checkfoldersub=fullfile(checkfolder,'wt2_GMtemplate_AllenSpace');
     [pathx s]=antpath;
     
     %plot: 2nd dim, every 10th slice from 10th to end-10th slice, noCROP
    params={  {'wt2.nii' s.refTPM{1}     } ,2,['6 10'],[0 0 0 0],[1 1 0],[1 .5 1] };   
   % params={  {s.avg  'wt2.nii' } ,3,['1'],[.2 .2 0.2 0.2],[1 0 -1],[1 .5 1] };   

else
    disp('current modes:1[t2-GM],2[t2-masks]');return
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

if saver==1;
    warning off;
    mkdir(checkfoldersub);
end

%% get filter OVL
if~isempty(strfind(params{1}{2},'*'))
    flt2=  input('name filter for MASK [e.g. ''mask_left'' or ''lesion_total_mask.nii'']: ' ,'s');
else
    flt2='';
end


errorlog={};
for i=1:size(t2path,1)
    
    pa=t2path{i}; if strcmp(pa(end),filesep); pa=pa(1:end-1); end
    params2=params;
    
    %% chk filter
    if ~isempty(flt2)
        [files,dirs] = spm_select('List',pa,flt2);  files=cellstr(files);
        
        if mode==2 %mask native  ->no warped files
            files(regexpi2(files,'^w'))=[];
        end
        files=cellfun(@(a) {fullfile(pa,a)} , files);
        params2{1}{2}=files{1};
    end
    
    
    %% check FPpaths  if not determined
    if isempty(fileparts(params2{1}{1}))
        params2{1}{1}=   fullfile( pa,   (params2{1}{1}) );
    end
    if isempty(fileparts(params2{1}{2}))
        params2{1}{2}=   fullfile( pa,   (params2{1}{2}) );
    end
    [ ~, nametag]=fileparts(pa); %LABEL
        if ~isempty(flt2)
            nametag=[nametag ' ' flt2   ];
            %nametag= regexprep('hals.nii.abs&$.^/\|',{'\.nii'  '\^' '/' '\\' '\|'  '\.'     '\&'     '\$'},'-')  ;%
            nametag= regexprep(nametag  ,{'\.nii'  '\^' '/' '\\' '\|'  '\.'     '\&'     '\$'},'-')  ;%

        end
    filename=fullfile(checkfoldersub, [ '' nametag  '.jpg' ]);
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    try
        
       hfig= ovlcontour(params2{:},nametag);
        set(gcf,'tag','checkovl','name',nametag);
        ovlerror=0;
    catch
         ovlerror=1;
        errorlog{end+1,1}=['error (overlay) : ' nametag];
    end
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    try
        %% save plot
        if saver==1 && ovlerror==0
            print(hfig,'-djpeg','-r300',filename);
        end
    catch
        errorlog{end+1,1}=['error (savePlot) : ' nametag];
    end
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
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

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
status={'OVERLAY <no errors>'};
if ~isempty(errorlog)
    status=[{'OVERLAY-ERRORS: '} ; errorlog];
    disp(char(status));
    pwrite2file(fullfile(checkfoldersub, ['checkerrors' '.txt' ]),status);
end





