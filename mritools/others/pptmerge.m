



% merge powerpoint files (ppt-files)
%% INPUT:
% 'fisoutname': resulting ppt-filename
% 'fis': fullpath list (cell) of pwerpoints to merge (merge is done in that order)
%% optinal pairwise-inputs
% Use 'flt' in combination with 'dir' and 'dirflt' to seach for powerpoint-files.
% In this case the 'fis'-variable must be EMPTY!
% ------------------------------------------------------
% 'dir'    : single directory to search for powerpoint-files
% 'flt'    : powerpoint file-filter to search for
%            example: '^sum_CLUST_.*.pptx'
%            NOTE: 'fis' must be empty when using 'flt' in combination with 'dir' and 'dirflt'!
% 'dirflt' : filter for directory-search (see spm_select)
%           'FPList'    : find ppt-files in a single directory
%           'FPListRec' : recursively find ppt-files in a single directory and subfolders
%           default: 'FPListRec'
% ------
% verbose  : {0|1} display progress of merging and at the end a
%            hyperlink of generated powerpoint-File in cmdwin
%
%% EXAMPLES:
%% example using file-filter
% F1='H:\Daten-2\Extern\AG_Schmid\ANALYSIS_connectome\voxstat_TP3_Test_Result\all_sum_CLUST_.pptx';
% paSPM ='H:\Daten-2\Extern\AG_Schmid\ANALYSIS_connectome\voxstat_TP3_TEST';
% pptmerge(F1,[],'dir',paSPM,'flt','^sum_CLUST_.*.pptx', 'dirflt','FPListRec');
% 
%% example using a list of powerpoint-files to merge
% files={
%     'H:\Daten-2\Extern\AG_Schmid\ANALYSIS_connectome\voxstat_TP3_TEST\res_vx_x_ad__gr_01_LN_Treat__vs__LN_ctrl\sum_CLUST_x_ad_CLUST0.001k178.pptx'
%     'H:\Daten-2\Extern\AG_Schmid\ANALYSIS_connectome\voxstat_TP3_TEST\res_vx_x_ad__gr_02_LN_Treat__vs__LN_preTreat\sum_CLUST_x_ad_CLUST0.001k160.pptx'
%     'H:\Daten-2\Extern\AG_Schmid\ANALYSIS_connectome\voxstat_TP3_TEST\res_vx_x_ad__gr_03_LN_Treat__vs__sal_ctrl\sum_CLUST_x_ad_CLUST0.001k155.pptx'
%     };
% F1='H:\Daten-2\Extern\AG_Schmid\ANALYSIS_connectome\voxstat_TP3_Test_Result\all_sum_CLUST_.pptx'
% pptmerge(F1,files)


function pptmerge(fisoutname,fis,varargin)

%% ======[inputs]=========================================

p.flt    ='';
p.dirflt ='FPListRec';
p.dir    ='';
p.verbose=1;

if ~isempty(varargin)
    pin=cell2struct(varargin(2:2:end),varargin(1:2:end),2);
    p=catstruct(p,pin);
end
%% ======[obtain files]=========================================
if isempty(fis)
    [fis] = spm_select(p.dirflt,p.dir,p.flt); fis=cellstr(fis);
end




% ==============================================
%%   example
% ===============================================
if 0
    %% ===============================================
    
    %% example using file-filter
    F1='H:\Daten-2\Extern\AG_Schmid\ANALYSIS_connectome\voxstat_TP3_Test_Result\all_sum_CLUST_.pptx';
    paSPM ='H:\Daten-2\Extern\AG_Schmid\ANALYSIS_connectome\voxstat_TP3_TEST';
    pptmerge(F1,[],'dir',paSPM,'flt','^sum_CLUST_.*.pptx', 'dirflt','FPListRec');
    
    %% example using a list of powerpoint files to merge
    files={
        'H:\Daten-2\Extern\AG_Schmid\ANALYSIS_connectome\voxstat_TP3_TEST\res_vx_x_ad__gr_01_LN_Treat__vs__LN_ctrl\sum_CLUST_x_ad_CLUST0.001k178.pptx'
        'H:\Daten-2\Extern\AG_Schmid\ANALYSIS_connectome\voxstat_TP3_TEST\res_vx_x_ad__gr_02_LN_Treat__vs__LN_preTreat\sum_CLUST_x_ad_CLUST0.001k160.pptx'
        'H:\Daten-2\Extern\AG_Schmid\ANALYSIS_connectome\voxstat_TP3_TEST\res_vx_x_ad__gr_03_LN_Treat__vs__sal_ctrl\sum_CLUST_x_ad_CLUST0.001k155.pptx'
        };
    F1='H:\Daten-2\Extern\AG_Schmid\ANALYSIS_connectome\voxstat_TP3_Test_Result\all_sum_CLUST_.pptx'
    pptmerge(F1,files)
    
    %% ===============================================
    
end
%% =======[check if outputdir exist]===================
[paout nameout extout]=fileparts(fisoutname);
if exist(paout)~=7
    mkdir(paout) ;
end

%% =======[ copy first pptfile]========================
fclose('all');
copyfile(fis{1},fisoutname,'f');

if p.verbose==1
    fprintf([sprintf('%c', 8594) 'merging slides: ']);
end
%% ===============================================
for i=2:length(fis)
    if p.verbose==1
        fprintf('%d,', i);
    end
    dorun=1;
    while dorun
        drawnow;
        fclose('all');
        try  
            mergefile(fisoutname,fis{i})
            dorun=0;
        end
    end           
end
%% ===============================================
if p.verbose==1
    fprintf(['\b.'  'Done.\n']);
end

if p.verbose==1 && exist(fisoutname)==2
    showinfo2(['new PPTfile'],fisoutname);
end
% ==============================================
%%
% ===============================================
function mergefile(filespec2,filespec1)

% filespec1 = 'D:\Copy_ppt.pptx';
% filespec2 = 'D:\Paste_ppt.pptx';

ppt = actxserver('PowerPoint.Application');
op1 = invoke(ppt.Presentations,'Open',filespec1,[],[],0);
op2 = invoke(ppt.Presentations,'Open',filespec2,[],[],0);

slide_count1 = get(op1.Slides,'Count');
slide_count2 = get(op2.Slides,'Count');

k =slide_count2+1;
for i = 1 : slide_count1
    invoke(op1.Slides.Item(i),'Copy');
    invoke(op2.Slides,'Paste');
    
    % copy background
    col=get(op1.Slides.Item(i).Background.Fill.ForeColor,'RGB');
    %sol=get(op1.Slides.Item(i).Background,'Fill')
    
    sn=get(op2.Slides,'Count');
    set(op2.Slides.Item(sn),'FollowMasterBackground', 'msoFalse');
    %set(op2.Slides.Item(sn).Background,'Fill',sol)
    set(op2.Slides.Item(sn).Background.Fill.ForeColor,'RGB',col);
    
    
    k = k+1;
end
invoke(op2,'Save');
% invoke(op2,'SaveAs',filespec2,1);
invoke(op1,'Close');
invoke(op2,'Close');
invoke(ppt,'Quit');




