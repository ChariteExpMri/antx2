
% <b> generate a HTML-file for DTI-Quality check using DTI-QA-png-images  </b> 
% <font color="red">- use this script when DTI-processing is finished  </font>
% The script recursively searches for all png-images in the "data"-path-folder ("pain")
% and creates a HTML-file
% #m -please modify the MANDATORY INPUTS (pain,outname,paout ...see below)
% 
% !!!  FIRST CREATE QA-THUMBNAILS (*.png-files) BEFORE RUNNING THIS SCRIPT !!!
%
% example to create the thumbnails:
% (1) on HPC: using script "rat_exvivo_qa_HPC.sh": 
%  go to folder ../data/   then execute: ./../shellscripts/rat_exvivo_qa_HPC.sh
% 
%% ===============================================

clear; warning off;

%% ==============================================
%% variable paramter-settings (please modify accordingly)
%% #r  __MANDATORY INPUTS___
%% ==============================================
% pain:    main path containing the DTI-data (this folder contains the animals)
% outname: output-name string for HTML-file and HTML-image-folder
% paout:   output-folder (fullpath): this resulting folder will contain the HTML-file+images
% ===============================================
pain='X:\Daten-2\Imaging\Paul_DTI\Eranet\test4\data'; % % DTI-data-folder
outname='round_HPC_test4'                           ; % % HTML-name-string
paout=fullfile(pwd,'check_DTI')                     ; % % HTML-output-folder


%     -------
%     pain   ='H:\Daten-2\Imaging\AG_Boehm_Sturm\ERA-Net_topdownPTSD\analysis_27nov20\dat'; %DTI-data-folder
%     outname='round1'                                      ; %HTML-name-string
%     paout=fullfile(pwd,'check_DTI')                       ; %HTML-output-folder
%     -------
%     pain='X:\Daten-2\Imaging\Paul_DTI\Eranet\test2\dat' ; %DTI-data-folder
%     outname='round_HPC_test2'                           ; %HTML-name-string
%     paout=fullfile(pwd,'check_DTI')                     ; %HTML-output-folder


%% ========================================================================
%% #ka  ___ internal stuff ___                  
%% ========================================================================

% ==============================================
%%   [1] check files
% ===============================================
[fi ] = spm_select('FPListRec',pain,'.*.png');%obtain all png-files
if isempty(fi); 
    msgbox({...
        'no thumbnails (*.png-images) found ' ...
        ' - check data-path ("pain")' ...
        ' - run "*.qa.sh" -shellscript first'...
        });
    return
end
fi=cellstr(fi);
mkdir(paout);   %make output folder
% ==============================================
%%   [2] HTML-header/footer
% ===============================================
wa={
    '<!DOCTYPE html>'
    '<html>'
    '<body>'
    };

we={'</body>' 
    '</html>'};

% ==============================================
%%  [3] loop over png-files...assign animal
% ===============================================
% mn=min(cell2mat(cellfun(@(a){[length(a) ]},fi)))
% d=cell2mat(cellfun(@(a){[double(char(a(1:mn))) ]},fi))
% bo=find(sum(abs(d-repmat(d(1,:),[size(d,1) 1])),1)>0)
paimgName=[outname];%'ressources';
paimg=fullfile(paout,paimgName);
mkdir(paimg);
w={};
name0='empty';

n=1;
for i=1:length(fi)
    f1=fi{i};
    [pas name ext]=fileparts(f1);
    shortname=[pnum(i,3) ext ];
    f2=fullfile(paimg,shortname);
    copyfile(f1,f2,'f');
    [~,animal]= fileparts(fileparts(pas));
    if strcmp(name0,animal)==0
        s=['<h3>' num2str(n) '] ' animal   '</h3>'];        w{end+1,1}=s;
        s2=['<pre>DIR: ' pas  '</pre>'];                    w{end+1,1}=s2;
       
        n=n+1;
        name0=animal;
    end
    
%     <img src="images/picture.jpg">	The "picture.jpg" file is located in the images folder in the current folder
s=['<img src="' paimgName '/' shortname '" alt="this" style="width:400px;height:400px;">'];
w{end+1,1}=s;
end

winfo={
    ['<b><div style="font-family:ARIAL;color:BLUE">' 'DTI-QUALITY-CHECK</div></b>']
    '<pre>'
    ['Date:     ' datestr(now) ];
    ['PATH:     ' pain         ];
    ['#Animals: ' num2str(n)   ];
    '</pre>'
    ...
    };

% ==============================================
%% [4]  write HTML-file
% ===============================================
q=[wa;winfo; w;we];
htmlname=fullfile( paout,[paimgName '.html']);
pwrite2file(htmlname,q);
showinfo2('DTI-quality check',htmlname); %show hyperlink in Matlab-cmd




