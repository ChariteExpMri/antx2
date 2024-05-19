
function makeHTML_QA()
%% ===============================================

% clear;
warning off;

%% ==============================================
%% variable paramter-settings (please modify accordingly)
%% #r  __MANDATORY INPUTS___
%% ==============================================
% pain:    main path containing the DTI-data (this folder contains the animals)
% outname: output-name string for HTML-file and HTML-image-folder
% paout:   output-folder (fullpath): this resulting folder will contain the HTML-file+images
% ===============================================
v=update_monitor();
pastudy=v.pastudy;%fullfile(fileparts(fileparts(pwd)));
[~,studyname]=fileparts(pastudy);
pain=fullfile(pastudy, 'data');                       % % DTI-data-folder
outname=['QA_DTIpostMrtrix_' studyname];                      % % HTML-name-string
paout=fullfile(pastudy,'checks');                   % % HTML-output-folder


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
mkdir(paout);   %make output folder
% ==============================================
%%   [1] check files
% ===============================================
[dirs]   = spm_select('List',pain,'dir');  dirs=cellstr(dirs);
[dirsFP] = spm_select('FPList',pain,'dir'); dirsFP=cellstr(dirsFP);

fi={};
t={};
for i=1:length(dirsFP)
    [~,numid]=fileparts(dirsFP{i});
    [animal] = spm_select('List',dirsFP{i},'dir');
    [fim ] = spm_select('FPListRec',dirsFP{i},'.*.png');%obtain all png-files
    if isempty(fim);
        fim='';
        %         msgbox({...
        %             'no thumbnails (*.png-images) found ' ...
        %             ' - check data-path ("pain")' ...
        %             ' - run "*.qa.sh" -shellscript first'...
        %             });
        %         return
    end
    fim=cellstr(fim);
    mdir=fullfile(dirsFP{i},animal);
    t(end+1,:)={numid animal fim, mdir};
end





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

winfo={
    ['<b><div style="font-family:ARIAL;color:BLUE">' 'DTI-QUALITY-CHECK</div></b>']
    '<pre>'
    ['Date:     ' datestr(now) ];
    ['PATH:     ' pain         ];
    ['#Animals: ' num2str(size(t,1))   ];
    '</pre>'
    };

% ==============================================
%%  [3] loop over animals and png-files...assign animal
% ===============================================
paimgName=[outname];%'ressources';
paimg=fullfile(paout,paimgName);
mkdir(paimg);
w={};
for i=1:size(t,1)
    t2=t(i,:);
    animalNo=t2{1};
    animal  =t2{2};
    files   =t2{3};
    pas     =t2{4};
    
    w{end+1,1}=['<h3>' '[' animalNo  '] ' animal   '</h3>'];
    w{end+1,1}=['<pre>DIR: ' pas  '</pre>'];
    filenamelist={};
    if isempty(char(files))
       w{end+1,1}= ['<h2><font color=red>' 'missing screenhots!!!!'  '</font></h2>'];
    else
        for j=1:size(files,1)
            f1=files{j};
            [pas name ext]=fileparts(f1);
            shortname=[name ext ];
            imgname_html=[animalNo '_[' animal ']_' shortname];
            f2=fullfile(paimg,imgname_html);
            copyfile(f1,f2,'f');
            filenamelist(end+1)={shortname};
            w{end+1,1}=['<img src="' paimgName '/' imgname_html '" alt="this" style="width:400px;height:400px;">'];
        end
        if ~isempty(filenamelist)
            filelistanimal=['<br>' strjoin(filenamelist,'<br>') ' '];
            w=[w; filelistanimal];
        end
    end
    
end


% ==============================================
% [4]  write HTML-file
% ===============================================
q=[wa;winfo; w;we];
htmlname=fullfile( paout,[paimgName '.html']);
pwrite2file(htmlname,q);
showinfo2('DTI-quality check',htmlname); %show hyperlink in Matlab-cmd



