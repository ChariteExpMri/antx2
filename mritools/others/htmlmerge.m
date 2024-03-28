



% merge HTML-files
%% INPUT:
% 'fisoutname': resulting html-filename
% 'fis': fullpath list (cell) of html-files to merge (merge is done in that order)
%% optinal pairwise-inputs
% Use 'flt' in combination with 'dir' and 'dirflt' to seach for HTML-files.
% In this case the 'fis'-variable must be EMPTY!
% ------------------------------------------------------
% 'dir'    : single directory to search for HTML-files
% 'flt'    : HTML file-filter to search for
%            example: '^sum_CLUST_.*.html'
%            NOTE: 'fis' must be empty when using 'flt' in combination with 'dir' and 'dirflt'!
% 'dirflt' : filter for directory-search (see spm_select)
%           'FPList'    : find HTML-files in a single directory
%           'FPListRec' : recursively find HTML-files in a single directory and subfolders
%           default: 'FPListRec'
% ------
% verbose  : {0|1} display progress of merging and at the end a
%            hyperlink of generated HTML-File in cmdwin
%
%% EXAMPLES:
%% example-1: using file-filter
% F1='F:\data8\schmidCalico_voxstat\tp3\voxstat\voxstat_TP3_Result\test1.html';
% paSPM ='F:\data8\schmidCalico_voxstat\tp3\voxstat\voxstat_TP3';
% htmlmerge(F1,[],'dir',paSPM,'flt','^.*.html', 'dirflt','FPListRec');
% 
%% example-2: using a list of HTML-files to merge
% F1='F:\data8\schmidCalico_voxstat\tp3\voxstat\voxstat_TP3_Result\test2.html';
% files={
%     'F:\data8\schmidCalico_voxstat\tp3\voxstat\voxstat_TP3\res_vx_x_fa__gr_01_LN_Treat__vs__LN_ctrl\sum_CLUST_x_fa_CLUST0.001k145.html'
%     'F:\data8\schmidCalico_voxstat\tp3\voxstat\voxstat_TP3\res_vx_x_fa__gr_01_LN_Treat__vs__LN_ctrl\sum_FWE_x_fa_FWE0.05k1.html'
%     'F:\data8\schmidCalico_voxstat\tp3\voxstat\voxstat_TP3\res_vx_x_fa__gr_01_LN_Treat__vs__LN_ctrl\sum_UNCOR_x_fa_none0.001k1.html'};
% htmlmerge(F1,files);


function htmlmerge(fisoutname,fis,varargin)

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
    
    %% example-1: using file-filter
    F1='F:\data8\schmidCalico_voxstat\tp3\voxstat\voxstat_TP3_Result\test1.html';
    paSPM ='F:\data8\schmidCalico_voxstat\tp3\voxstat\voxstat_TP3';
    htmlmerge(F1,[],'dir',paSPM,'flt','^.*.html', 'dirflt','FPListRec');
    
    
    %% example-2: using a list of HTML-files to merge
    F1='F:\data8\schmidCalico_voxstat\tp3\voxstat\voxstat_TP3_Result\test2.html';
    files={
        'F:\data8\schmidCalico_voxstat\tp3\voxstat\voxstat_TP3\res_vx_x_fa__gr_01_LN_Treat__vs__LN_ctrl\sum_CLUST_x_fa_CLUST0.001k145.html'
        'F:\data8\schmidCalico_voxstat\tp3\voxstat\voxstat_TP3\res_vx_x_fa__gr_01_LN_Treat__vs__LN_ctrl\sum_FWE_x_fa_FWE0.05k1.html'
        'F:\data8\schmidCalico_voxstat\tp3\voxstat\voxstat_TP3\res_vx_x_fa__gr_01_LN_Treat__vs__LN_ctrl\sum_UNCOR_x_fa_none0.001k1.html'};
    htmlmerge(F1,files)
    
    
    
    %% ===============================================
    
end
%% =======[check if outputdir exist]===================
[paout nameout extout]=fileparts(fisoutname);
if exist(paout)~=7
    mkdir(paout) ;
end

%% =======[ HTML-files]========================
if p.verbose==1
    fprintf([sprintf('%c', 8594) 'merging slides: ']);
end

h={'<html>'};
for i=1:length(fis)
    if p.verbose==1;         fprintf('%d,', i);      end
    a=preadfile(fis{i}); a=a.all;
    [pain namein extin]=fileparts(fis{i});
    
    %--get subdirs
    ix=regexpi2(a,'<\s{0,100}img\s{0,100}src\s{0,100}=\s{0,100}"') ;%path of images
    subdirs={};
    for j=1:length(ix)
        l=a{ix(j)};
        s=strfind(l,'"');
        
        for k=1:2:length(s)
            imgpa=l(s(k)+1:s(k+1)-1);
            [pax namx extx]=fileparts(imgpa);
            if any(strcmp({'.jpg','.tif','.png','.bmp'},extx))
                subdirs(end+1,:) ={pax};
            end
        end
    end
    subdirs=unique(subdirs);
    
    %copy subdirs
    for j=1:length(subdirs)
        D1=fullfile(pain,subdirs{j});
        D2=fullfile(paout,subdirs{j});
        copyfile(D1,D2,'f');
    end
    
    
    %---cleanup htmlfile
    a=strrep(a,'<html>','');
    a=strrep(a,'</html>','');
    if j>2 %remove style
        istyle=[regexpi2(a,'<style>') regexpi2(a,'</style>')];
        a(istyle(1):istyle(2))=[];
    end
    
    % append HTLM-file
    tit     ={[ '<h2 style="margin: 0; padding: 0; "> File: <mark> [' [namein extin] '] </mark></h2>'   ]};
    source  ={[ '<h6 style="margin: 0; padding: 0; "> Path: ' [pain  ] '</h6>'   ]};
    h=[h;tit;source; a];
    
    
end
h=[h; '<html>'];
if p.verbose==1;     fprintf(['\b.'  'Done.\n']);   end


pwrite2file(fisoutname, h );

if p.verbose==1 && exist(fisoutname)==2
    showinfo2(['new HTMLfile'],fisoutname);
end


