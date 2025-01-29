
%% convert xls-sheets to single powerpoint-file
% xls2ppt(pabase,flt,sheetnum,pptfile,VARARGIN)
% pabase  :  path to look for excelfiles
% flt     : xls-filename filtert (use regexp)
%           -example:
%             '^.*.xlsx'   ...use all xlsfiles with extension '.xlsx'
%             '^statROI_SIG_.*.xlsx'  .. all files starting with '^statROI_SIG_' and extension '.xlsx'
% sheetnum:  sheet-number...sheet to convert; use either:
%       single number      : example: 2
%       or vector of sheets: example: 2:4
%       or 'all' to convert all sheets
% pptfile: name of the resulting PPT-file
%       example:  fullfile(pwd,'test3.pptx');
%
%% ___ OPTIONAL pairwise inputs____
% 'append' [0,1]: [1]  append slides to to existing ppt-file via 'append', [0]: overwrite
% 'sort'   [0,1]: sort slides according xls-sheetnumber: 
%                 -[0]: no sorting
%                 -[1]: sort: lowest sheetNumber for all files is transfomed to ppt-slides,
%                       than next highest sheetNumber for all files is transformed to ppt-slides 
%% ___EXAMPLES____________________
%% simple examples
% xls2ppt(pabase,flt,sheetnum,pptfile)
% xls2ppt(pabase,'^.*.xlsx',2,fullfile(pwd,'brainvol.pptx'));
%% example[1]: append slides to to existing ppt-file via 'append'
% xls2ppt('F:\data5\eranet_round2_statistic\DTI\result_test2','^res_SIG_',3,fullfile('F:\data5\eranet_round2_statistic\DTI\result_test2','123'),'append',0);
% 
%% example[2]: from "../regionwise"-dir select all xlsx-files starting with 'statROI_SIG' and transform all sheets to PPT-slides,
%% save as '_test4.pptx' in same folder, create new PPT-document, 
%% sort ppt-slides according xls-sheetnumber (first sheetNo-1 for all files converted, than sheetNo-2..than sheetNo-3...  )
% xls2ppt('F:\data5\eranet_round2_statistic\regionwise','^statROI_SIG_.*.xlsx','all',fullfile('F:\data5\eranet_round2_statistic\regionwise','_test4.pptx'),'append',0,'sort',1);
% 
%% example[3]: same as example[2] but convert only sheets 2:4
% xls2ppt('F:\data5\eranet_round2_statistic\regionwise','^statROI_SIG_.*.xlsx',[2:4],fullfile('F:\data5\eranet_round2_statistic\regionwise','_test4.pptx'),'append',0,'sort',1);
% 
%% example[4]: excelfiles to single ppt--all sheets
%     Fout=fullfile(pwd,'SUMMARY_excelfiles.pptx');
%     pax=fullfile('F:\data8\test_merge_ppt_andxlsx','data');
%     [xlsfiles] = spm_select('FPListRec',pax,'.*.xlsx'); xlsfiles=cellstr(xlsfiles);
%     xls2ppt(xlsfiles,'','all',Fout)
% 
%% example[5]:excelfiles to single ppt, sheet-2
%     Fout=fullfile(pwd,'SUMMARY_excelfiles.pptx');
%     pax=fullfile('F:\data8\test_merge_ppt_andxlsx','data');
%     [xlsfiles] = spm_select('FPListRec',pax,'.*.xlsx'); xlsfiles=cellstr(xlsfiles);
%     xls2ppt(xlsfiles,'',2,Fout)
% 
% 




function xls2ppt(pabase,flt,sheetnum,pptfile,varargin)
warning off;
% ==============================================
%%
% ===============================================
if 0
    %     flt='^.*.xlsx'
    %     pabase=pwd
    %     sheetnum=2
    %     pptfile  =fullfile(pabase,'test3.pptx');
    % xls2ppt(pabase,flt,sheetnum,pptfile)
    xls2ppt(pwd,'^.*.xlsx',2,fullfile(pwd,'brainvol.pptx'))
end

p0.append=0;
p0.sort  =0;
if isempty(varargin)
    p=p0;
else
    v=varargin;
    p=cell2struct(v(2:2:end),v(1:2:end),2);
    pinput=p; %backup input
    p=catstruct(p0,p);
end

% pabase='H:\Daten-2\Imaging\AG_Mueller_Mainz\stat_brainvol\result';
if iscell(pabase) && size(pabase,1)>=1
    files=pabase;
else
    [files]  = spm_select('FPList',pabase,flt); files=cellstr(files);
end
% pptfile  =fullfile(pabase,'test2.pptx');
% sheetnum=2
%% ===============================================
thisdir=pwd;

% ==============================================
%%   generate list: path + sheetname + sheetNUm
% ===============================================
tb={};
if isnumeric(sheetnum) %numeric num
    sheets=sheetnum;
    for i=1:length(files);
        [~, sheetnamesAll ] =xlsfinfo(files{i});
        sheetnamesAllidx=[1:length(sheetnamesAll)];
        sheetnumValid=intersect(sheetnamesAllidx,sheets);
        sheetsel=sheetnamesAll(sheetnumValid);
        tb=[tb;
            [repmat(files(i),[length(sheetsel) 1 ])   sheetsel(:)  num2cell([sheetnumValid(:)])] ];
    end
elseif ischar(sheetnum)
   for i=1:length(files);
        [~, sheetnamesAll ] =xlsfinfo(files{i});
        sheetnumValid=[1:length(sheetnamesAll)];
        sheetsel=sheetnamesAll(sheetnumValid);
        tb=[tb;
            [repmat(files(i),[length(sheetsel) 1 ])   sheetsel(:)  num2cell([sheetnumValid(:)])] ];
    end 
end


% sort according sheetnumber (2,2,2..than 3,3,3 etc)
if p.sort  ==1;
    tb=sortrows(tb,3);
end
%% ===============================================


% ==============================================
%%   loop over tb-table
% ===============================================

if size(tb,1)>0
    fprintf('Added slide: ');
end

s.bgcol=[1 1 1];
for i=1:size(tb,1)
    try
    cd(fileparts(pptfile));
    fi            =tb{i,1};
    thissheetName =tb{i,2};
    thissheetNum  =tb{i,3};
    %[~,sheetnames]=xlsfinfo(fi);
    [~,~,a]=xlsread(fi,thissheetNum);
    if size(a,1)>200
        a=a(1:200,:);
    end
    
    
    %% ===============================================
    [pa , fname, ext]=fileparts(fi);
    [pa1, subdir    ]=fileparts(pa);
    [~, subdir2     ]=fileparts(pa1);
    info={
        ['file   : '    [  fname ext ]]
        ['dir    : '    [  subdir    ]]
        ['dirUp  : '  [  subdir2   ]]
        ['sheet-' num2str(thissheetNum) ': "'  thissheetName '"' ]
        };
    
    %clc; disp(info)
    
    %% ===============================================
    
    isOpen  = exportToPPTX();
    if ~isempty(isOpen),
        % If PowerPoint already started, then close first and then open a new one
        exportToPPTX('close');
    end
    
    % =======new PPT/add to ppt ========================================
    % if strcmp(s.doc,'add') && exist([pptfile,'.pptx'])
    %     exportToPPTX('open',[pptfile,'.pptx'])
    % else
    % ===============================================
    if i==1 && exist(pptfile)~=2 % check existence, if not exist...do not append but create
        p.append=0;
    end
    
    if i==1 && p.append==0
    exportToPPTX('new','Dimensions',[12 6], ...
        'Title','Example Presentation', ...
        'Author','MatLab', ...
        'Subject','Automatically generated PPTX file', ...
        'Comments','This file has been automatically generated by exportToPPTX');
    else
     exportToPPTX('open',[pptfile]);
    end
    
    %% =========[get width]======================================
    m=plog([],a,0,[  fname ext ],'d=5;al=1');
    %    clc
    fs1=10;
    fn1='Calibri';
    
    fs2=6;
    fn2='Courier New';
    
    
    warning off;
    hff=figure('tag','getfontsize','units','inches','visible','off'); drawnow;
    
    te1=text(0,0,info,'FontName',fn1,'fontsize',fs1);
    set(te1,'units','inches');
    w1= ceil(te1.Extent(3))+1;
    h1= ceil(te1.Extent(4))+.2;
    
    te2=text(0,0,m,'FontName',fn2,'fontsize',fs2);
    set(te2,'units','inches');
    w2= ceil(te2.Extent(3))+1;
    %   w
    delete(hff);
    
    %% ===============================================
    
         
    % cd(paPPT);
    slideNum = exportToPPTX('addslide','BackgroundColor',s.bgcol);
    %fprintf('Added slide %d\n',slideNum);
    fprintf('%d,',slideNum);
    % exportToPPTX('addpicture',figH);
    % exportToPPTX('addtext',lb.String{lb.Value});
    exportToPPTX('addtext',strjoin(info,char(10)),'FontSize',fs1,...
       'FontName',fn1, 'Position',[0 0 w1 h1  ]); % [0 0 7 3  ]
    
    
    % m=strjoin(m,char(10))
    
    
    exportToPPTX('addtext',strjoin(m,char(10)),'FontSize',fs2,...
        'FontName',fn2,'Position',[0 1 w2 3  ])
    
    
    %exportToPPTX('addnote',sprintf('Notes data: slide number %d',slideNum));
    note={...
        ['source: '  pwd ]
        ['file   : '    [  fname ext ]]
        ['sheet-' num2str(thissheetNum) ': "'  thissheetName '"' ]
        ['fileFP   : '   fullfile(pa, [  fname ext ])  ]
        };
    
    exportToPPTX('addnote',note);
    % Rotate mesh on each slide
    %     view(18*islide,18*islide);
    
    
    % close(figH)
    % Check current presentation
    
    fileStats   = exportToPPTX('query');
    newFile = exportToPPTX('saveandclose',pptfile);
    catch
        disp(lasterr);
        disp(['ERROR: maybe excel-file/ppt-file open?'  ]);
%         rethrow(lasterr);
    end
    
end
%fprintf('Added slide %d\n',slideNum);
if size(tb,1)>0
     fprintf('..Done\n'); 
    %fprintf('saved PPT-file: <a href="matlab:open(''%s'')">%s</a>\n',newFile,newFile);
    showinfo2('saved PPT-file',newFile);
end
cd(thisdir);











