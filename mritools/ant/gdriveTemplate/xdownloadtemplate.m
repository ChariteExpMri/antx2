
% #lk  ***  Download Template(s) from Google Drive via GUI  ***
%
% #r =================================================================
% #r Function is currently Tested ...function help has to be prepared
% #r =================================================================
%
% #kl CURRENT STATUS
% #k WINDOWS: #n relies on matlab.net.http class, Introduced in #b R2016b.
%       #b Matlab version #r before R2016b won't work. #n In this case use manual download from webside.
%   -status via waitbar
% #k LINUX: #n using 'wget' (no other packages needed)
%   -no waitbar, but status via command line
% #k MAC: #n using python (pip/requests-modules) and python-script from
%    https://stackoverflow.com/questions/25010369/wget-curl-large-file-from-google-drive
%    ..packages will be downloaded (if needed..) during download
%     -no waitbar, no status-updates during download


function xdownloadtemplate

warning off;
% p.paout=fullfile(fileparts(fileparts(which('antlink'))),'anttemplates'); %FINAL
p.paout=fullfile(fileparts(fileparts(which('antlink'))),'anttemplates_test'); %TEST

% t=load('C:\paultest\rclone\gdrivetemplates.mat');
t=load(which('gdrivetemplates.mat'));  %in TBX
p.t=t.l2;



makefig(p);
% set(gcf,'userdata',p);
return

% uiwait(gcf);

p=get(gcf,'userdata');
p.selection  = find(cell2mat(p.uit.Data(:,1)));
p.uitable    = p.uit.Data;
p.paout      = get(findobj(gcf,'tag','paout'),'string');

%-----delete file
delete(findobj(0,'tag','gdrive')); %delete previous table
drawnow;

if isempty(p.selection)
    disp('process aborted..no template selected.');
    return
end

%----process
if p.isOK==0
    disp('process aborted by user.');
    return
elseif p.isOK==1
    disp('...');
    process(p);
    
    return
end



function cancel(e,e2)
% delete(findobj(0,'tag','gdrive')); %delete previous table
% us=get(gcf,'userdata');
% us.isOK=0;
% set(gcf,'userdata',us);
% uiresume(gcf);
delete(findobj(0,'tag','gdrive')); %delete previous table
return

function OK(e,e2)
% delete(findobj(0,'tag','gdrive')); %delete previous table
% us=get(gcf,'userdata');
% us.isOK=1;
% set(gcf,'userdata',us);
% uiresume(gcf);

us=get(gcf,'userdata');
p=get(gcf,'userdata');
p.selection  = find(cell2mat(p.uit.Data(:,1)));
p.uitable    = p.uit.Data;
p.paout      = get(findobj(gcf,'tag','paout'),'string');

p.use_proxy  =get(findobj(gcf,'tag','use_proxy'),'value');

hb=findobj(gcf,'tag','http_proxy');
li=get(hb,'string'); va=get(hb,'value');
str=li{va};
if strcmp(str,'<empty>')==1; str=''; end
p.http_proxy=str;

hb=findobj(gcf,'tag','https_proxy');
li=get(hb,'string'); va=get(hb,'value');
str=li{va};
if strcmp(str,'<empty>')==1; str=''; end
p.https_proxy=str;

if p.use_proxy==0
   p.http_proxy=''; 
   p.https_proxy=''; 
end

%  disp(p);
% % 
%  return

%-----delete file
% delete(findobj(0,'tag','gdrive')); %delete previous table
% drawnow;

if isempty(p.selection)
    disp('process aborted..no template selected.');
    return
end
processloop(p);

% ==============================================
%%
% ===============================================
function processloop(p)




% ==============================================
%%   initi
% ===============================================

% clc;
% warning off;
% thispath=pwd;                                      % curent WD
% funpath=fileparts(which('xdownloadtemplate.m'));   % function path
% isAntlink=0;
% if ~isempty(which('ant.m'))
%     isAntlink=1;
% end
%
% if isAntlink==1 %removeANT-path.....
%     antpath=fileparts(which('antlink.m'));
%     cd(antpath);
%     antlink(0);
%     cd(funpath);
% end

% clear persistent options
% clear persistent infos


% % p.paout='C:\paultest\gdrive2';   %outputpath
% %
% % % t=load('C:\paultest\rclone\gdrivetemplates.mat');
% % % t=load(which('gdrivetemplates.mat'));  %in TBX
% % t=load('F:\antx2\mritools\ant\gdriveTemplate\gdrivetemplates.mat');
% % p.t=t.l2;


% ==============================================
%%   loop download
% ===============================================
isError=0;
try
    idxall=p.selection;
    if isempty(idxall); return; end
    
    disp(['*** DOWNLOADING TEMPLATES ***'  ]);
    
    for i=1:length(idxall)
        idx= idxall(i);
        downloadFile(p,idx,idxall);
    end
    errmsg='success';
catch ME
    isError=1;
    errmsg='process aborted';
end


% ==============================================
%%   post
% ===============================================

% if isAntlink==1 %add ANT-path...
%     cd(antpath);
%     antlink(1);
% end
% cd(thispath);

% dispay folders
if strcmp(errmsg,'success')
    cprintf([0 .5 0],['Done...' errmsg '.\n'  ]);
    for i=1:length(idxall)
        name  =strrep(p.t{idxall(i),4},'.zip','');
        namefp=fullfile(p.paout,name);
        disp([ '[' name ']-template .. downloading complete. Open '   '<a href="matlab: explorerpreselect(''' namefp ''');">' '[local folder]' '</a>' '.']);
    end
else
    cprintf([1 0 1],['ERROR...' errmsg '.\n'  ]);
end


% ==============================================
%%   clean up
% ===============================================
% clear TemplateSendRequest
% clear global pardownload;
%
% clear persistent options
% clear persistent infos


% ==============================================
%%  disp error ..in case
% ===============================================
if isError==1
    
    merr=ME.message;
    cprintf([1 0 1],[ 'Download failed' '.\n'  ]);
    cprintf([1 0 1],[ 'Reason: ' merr '.\n'  ]);
    
    %   disp([ ''   '<a href="matlab: rethrow(lasterror);">' '[Rethrow Error]' '</a>' '.']);
    global downloaderror
    downloaderror=ME;
    disp([ '.. For more info click '   '<a href="matlab: global downloaderror; disp( getReport( downloaderror, ''extended'', ''hyperlinks'', ''on'' ) );disp([repmat(''='',[1 70])])">' '[Rethrow Error]' '</a>' '.']);
    %   disp( getReport( ME, 'extended', 'hyperlinks', 'on' ) )
end
















function downloadFile(p,idx,idxall)
% clc;
% clear all
warning off;
% clear TemplateSendRequest
%
% clear persistent options
% clear persistent infos


t    =p.t; %Table
paout=p.paout;


% ==============================================
%%   intialize
% ===============================================
atim=tic;
mkdir(paout);
% ==============================================
%%   get info from template table
% ===============================================


%% 32 MB
% https://drive.google.com/file/d/1nX0g2DaMIPIVgQGead97dCdeNEflFN6h/view?usp=sharing
%% 115 mb
% https://drive.google.com/file/d/1pEYNKuc_IunQfSj_feIhpaXbK3xlMnzN/view?usp=sharing
%%folder
% 'https://drive.google.com/drive/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9?usp=sharing';%folder
%
% fileName = 'mouse_Allen2017HikishimaLR.zip';
% fileId = '1nX0g2DaMIPIVgQGead97dCdeNEflFN6h'; %32MB
%fileId = '1pEYNKuc_IunQfSj_feIhpaXbK3xlMnzN'; %115MB


fileName =fullfile(paout,t{idx,4} );
fileId   =t{idx,3};
bytes    =str2num(t{idx,2})*1e6;

% GLOBLAL
global pardownload;
pardownload.fileName=t{idx,4};
pardownload.bytes   =bytes;
pardownload.idx     =idx;
pardownload.idxall  =idxall;

disp(['[' sprintf( '%d/%d', idx,length(idxall)) '] ================================================== ']);
disp(['downloading  fileName: ' t{idx,4}]);
disp(['                   ID: ' t{idx,3}]);
disp(['                 Date: ' t{idx,1}]);
disp(['             Size(MB): ' t{idx,2}]);
disp('[busy]...');
% ==============================================
%%   download from google drive
% ===============================================
disp('..downloading file..');


fiout      =fullfile(paout,pardownload.fileName);
googleID   =t{idx,3};

if ispc==1
    getFileGdriveWin(googleID,fiout,p.http_proxy,p.https_proxy);
    
else
    googleID_unix=['"' googleID '"'];
    fiout_unix   =['"' fiout '"'];
    http_proxy  =strrep(p.http_proxy,'http://','');
    https_proxy =strrep(p.https_proxy,'http://','');
    
    fun   =[ '.' filesep fullfile(fileparts(which('xdownloadtemplate.m')),'getFileGdrive.sh')];
    ms=[fun ' ' googleID_unix  ' ' fiout_unix ' ' http_proxy ' ' https_proxy ];
    
    eval(ms);
end



if 0 %OLD
    if ispc==1
        fileUrl = sprintf('https://drive.google.com/uc?export=download&id=%s', fileId);
        request = matlab.net.http.RequestMessage();
        
        % First request will be redirected to information page about virus scanning
        % We can get a confirmation code from an associated cookie file
        [~, infos] = TemplateSendRequest(matlab.net.URI(fileUrl), request);
        confirmCode = '';
        for j = 1:length(infos('drive.google.com').cookies)
            if ~isempty(strfind(infos('drive.google.com').cookies(j).Name, 'download'))
                confirmCode = infos('drive.google.com').cookies(j).Value;
                break;
            end
        end
        newUrl = strcat(fileUrl, sprintf('&confirm=%s', confirmCode));
        
        % We now need to send another request to get the file.
        % However, Matlab doesn't download the whole Tiff file, but only one frame.
        [a, b, history] = TemplateSendRequest(matlab.net.URI(newUrl), request);
        
        b1=history(end).Response;
        % fid = fopen('z4.zip', 'wb'); ; fwrite(fid, b1.Body.Data);fclose(fid);
        fid = fopen(fileName, 'wb');
        fwrite(fid, b1.Body.Data);
        fclose(fid);
    elseif ismac
        %MAC without wget
        % check if pip is installed
        [e1,e2]=system('python -m pip');
        if isempty(strfind(e2,'Run pip in an isolated mode'))==1
            disp('..installing pip..');
            !sudo easy_install pip
            disp('..installing requests-module..');
        end
        evalc('!python -m pip install requests');
        disp('..no waitbar available......be patient..');
        system(['python dowloadGdrive.py 1nX0g2DaMIPIVgQGead97dCdeNEflFN6h ' fileName]);
        
    elseif isunix
        % system(['wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate ''https://docs.google.com/uc?export=download&id=1nX0g2DaMIPIVgQGead97dCdeNEflFN6h'' -O- | sed -rn ''s/.*confirm=([0-9A-Za-z_]+).*/\1\n/p'')&id=1nX0g2DaMIPIVgQGead97dCdeNEflFN6h" -O HIKI.zip && rm -rf /tmp/cookies.txt'])
        %     system(['wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate ''https://docs.google.com/uc?export=download&id='  fileId   ''' -O- | sed -rn ''s/.*confirm=([0-9A-Za-z_]+).*/\1\n/p'')&id='  fileId  '" -O ' fileName ' && rm -rf /tmp/cookies.txt']);
        
        cookiefile=fullfile(paout,'cookies.txt');
        system(['wget --load-cookies ' cookiefile ' "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies ' cookiefile ' --keep-session-cookies --no-check-certificate ''https://docs.google.com/uc?export=download&id='  fileId   ''' -O- | sed -rn ''s/.*confirm=([0-9A-Za-z_]+).*/\1\n/p'')&id='  fileId  '" -O ' fileName ' && rm -rf ' cookiefile '']); 
    end
    
end% old


% ==============================================
%%   unzip
% ===============================================
disp('..unzipping..');
[pa fi ext]=fileparts(fileName);
fileNameOut=fileName;   %final finalName
if strcmp(ext,'.zip')==1
    fileName2=fullfile(pa,fi);
    f1=unzip(fileName,fileName2);
    
    %% folder in folder issue
    if exist(fullfile(pa,fi,fi))==7  %subDir with same name
        oldname=fullfile(pa,['_',fi]);
        movefile(fileName2,oldname,'f');                  %1) RENAME THE MAIN FOLDER
        movefile(fullfile(pa,['_',fi],fi),fileName2,'f'); %2) RENAME subfolder with content to final name
%         try; delete(fileName)   ;end  %3) remove old zip-file
        try; rmdir(oldname ,'s');end  %4) remove old main-folder
        fileNameOut=fileName2;%final finalName
    end
end
disp(['[done]..dtime (min): ' num2str(toc(atim)/60)]);




function help(e,e2)
uhelp(mfilename);


function makefig(p)


% ==============================================
%%   fig
% ===============================================

delete(findobj(0,'tag','gdrive'));

fg;
hk=gcf;
set(hk,'units','normalized','menubar','none');
set(hk,'position',[0.3319    0.3900    0.4028    0.2811]);%[0.2986    0.4000    0.5611    0.4667]);
set(hk,'tag','plotconnections','NumberTitle','off',...
    'name',['Gdrive Templates' ' [' mfilename '.m]' ],...
    'tag','gdrive');



% ==============================================
%%   table
% ===============================================
tb=load(which('gdrivetemplates.mat'));
tb=tb.l2;
tbs=tb(:,[4 2 1 3]);

he ={'x'         'Name' 'Size(MB)'  'Date' 'gdrive-ID' };
fmt={'logical'   'char' 'char'      'char' 'char'     };
e=[...
    num2cell(logical(zeros(size(tbs,1),1))) ...
    tbs
    ];
columnname   =he;%{'select'  'name'  'ID'   'c'   'color'};
columnformat =fmt;%{'logical' 'char'  'char' 'char' 'char'};
editable=logical([1 0 0 0 0]);

% ==============================================
%%  uitable
% ===============================================
tv=e;

hk=findobj(0,'tag','gdrive');
figure(hk);
delete(findobj(hk,'tag','table1')); %delete previous table

% get max-column-size
hv=uicontrol('Style', 'text','string','');
mxlen=[];
tw=[he;tv];
for i=1:size(tw,2)
    i2len=cell2mat(cellfun(@(a){ [length(a)]},tw(:,i)));
    str=tw{max(find(i2len==max(i2len))),i};
    if isnumeric(str); str=num2str(str);
    elseif islogical(str); str=num2str(str); end
    set(hv,'string',[str ' ']);
    ext=get(hv,'Extent');
    mxlen(1,i)=ext(3);
    % disp(mxlen);
end
ColumnWidth=[num2cell(mxlen(1:end)+6)];
delete(hv);

% Create the uitable
t = uitable;
set(t,'Data', tv,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnEditable', editable,...
    'ColumnWidth',    ColumnWidth,...
    'RowName',[],...
    'tag','table1');
drawnow;

set(t,'units','normalized','position',[0.01 .33 1 .57]);
% set(t,'CellSelectionCallback',@CellSelectionCallback);
% set(t,'CellEditCallback'     ,@CellEditCallback);
p.uit=t;
% set(t,'fontsize',7);

set(gcf,'userdata',p);


% ==============================================
%%   proxys
% ===============================================
%% WPAD
hb=uicontrol('style','pushbutton','units','norm','string','wpad');
set(hb,'position',[.18 .25 .3 .03],'tag','get_wpad');
set(hb,'tooltipstring','The Web Proxy Auto-Discovery (WPAD) Protocol...determine proxy');
set(hb,'position',[.01 .21 .06 .07]);
set(hb,'callback',@get_wpad);

%% USE-proxy-radio
hb=uicontrol('style','radio','units','norm','string','useProxy','fontsize',7);
set(hb,'tag','use_proxy');
set(hb,'tooltipstring','use proxy','backgroundcolor','w');
set(hb,'position',[.08 .21 .15 .07]);
% set(hb,'callback',@get_wpad);


http_proxyList={'http://proxy.charite.de:8080' 'http://proxyIP:PORT' 'http://#:#' '<empty>'};
%% pulldown http_proxy
hb=uicontrol('style','popup','units','norm','string',http_proxyList);
set(hb,'position',[.2 .25 .3 .03],'tag','http_proxy');
set(hb,'tooltipstring','http_proxy','fontweight','normal');
jCombo = findjobj(hb);
jCombo.setEditable(true);

https_proxyList={'https://proxy.charite.de:8080' 'https://proxyIP:PORT' 'https://#:#' '<empty>'};
%% pulldown http_proxy
hb=uicontrol('style','popup','units','norm','string',https_proxyList);
set(hb,'position',[.52 .25 .3 .03],'tag','https_proxy');
set(hb,'tooltipstring','https_proxy','fontweight','normal');
jCombo = findjobj(hb);
jCombo.setEditable(true);
%% TXT http_proxy
hb=uicontrol('style','text','units','norm','string','HTTP PROXY');
set(hb,'backgroundcolor','w','fontweight','bold');
set(hb,'position',[.2 .28 .3 .05]);
%% TXT https_proxy
hb=uicontrol('style','text','units','norm','string','HTTPS PROXY');
set(hb,'backgroundcolor','w','fontweight','bold');
set(hb,'position',[.5 .28 .3 .05]);

% ==============================================
%%   other controls
% ===============================================

%cancel/CLOSE
hb=uicontrol('style','pushbutton','units','norm','string','CLOSE');
set(hb,'position',[.55 .95 .05 .03],'tag','cancel','callback',@cancel);
set(hb,'tooltipstring','cancel','fontweight','bold');
set(hb,'position',[.87 0.05 .1 .07]);

%OK/DOWNLOAD
hb=uicontrol('style','pushbutton','units','norm','string','Download');
set(hb,'position',[.55 .95 .05 .03],'tag','OK','callback',@OK);
set(hb,'tooltipstring','Proceed. Download selected template(s)',...
    'fontweight','bold','backgroundcolor',[0.4667    0.6745    0.1882]);
set(hb,'position',[.77 0.05 .1 .07]);

%HELP
hb=uicontrol('style','pushbutton','units','norm','string','Help');
set(hb,'position',[.55 .95 .05 .03],'tag','help','callback',@help);
set(hb,'tooltipstring','get some help',...
    'fontweight','bold');
set(hb,'position',[.87 0.92 .1 .07]);

%select all
hb=uicontrol('style','radio','units','norm','string','select all');
set(hb,'position',[.55 .95 .05 .03],'tag','selectall','callback',@selectall);
set(hb,'tooltipstring','select all templates',...
    'fontsize',7);
set(hb,'position',[.013 .92 .13 .05],'backgroundcolor','w','value',0);

%INFO
hb=uicontrol('style','text','units','norm');
set(hb,'tooltipstring','...',    'fontweight','bold');
set(hb,'position',[.2 .92 .6 .05],'backgroundcolor','w');
set(hb,'string','Available templates (gdrive). Select template(s) to download.');
set(hb,'backgroundcolor',[1.0000    0.8157         0]);


%INFOpath
hb=uicontrol('style','text','units','norm');
set(hb,'tooltipstring','path to write the template',    'fontweight','bold');
set(hb,'position',[.013 0.15 .2 .05],'backgroundcolor',[1.0000    0.8157         0]);
set(hb,'string','Local template path');

%radio path-anttemplates
hb=uicontrol('style','radio','units','norm','string','anttemplates');
set(hb,'tag','path1','callback',{@selpath,1});
set(hb,'tooltipstring',['Downloaded template(s) will be stored in the "anttemplates"-folder.' char(10)  ...
    'If "anttemplates"-folder does not exist, it will be created at the same hierarchical level as ANTtbx.' char(10) ...
    '-->--> alternative to "user specified"']);
set(hb,'position',[.03 0.08 .2 .06],'backgroundcolor','w','value',1);

%radio path user-spec
hb=uicontrol('style','radio','units','norm','string','user specified');
set(hb,'tag','path2','callback',{@selpath,2});
set(hb,'tooltipstring','local path is another "anttemplates-path"');
set(hb,'position',[.03 0.02 .2 .06],'backgroundcolor','w','value',0);
set(hb,'tooltipstring',['Downloaded template(s) will be stored at a user-specified location' char(10)  ...
    'User must specify the respective folder where template(s) will be stored.' char(10) ....
    '-->--> alternative to "anttemplates"']);



% %path TXT
% hb=uicontrol('style','text','units','norm','string',patemplates);
% % set(hb,'tag','path2','callback',{@selpath,2});
% set(hb,'string','Local template path:');
% set(hb,'position',[.01 0.08 .18 .06],'backgroundcolor','r','value',0,...
%     'HorizontalAlignment','right');

%path edit
% patemplates=fullfile(fileparts(fileparts(which('antlink'))),'anttemplates');
patemplates=p.paout;
hb=uicontrol('style','edit','units','norm','string',patemplates);
% set(hb,'tag','path2','callback',{@selpath,2});
set(hb,'tooltipstring','final path where template is stored locally');
set(hb,'position',[.22 0.14 .5 .06],'backgroundcolor','w','value',0);
set(hb,'tag','paout');


% return

%% link
url = 'https://drive.google.com/drive/u/2/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9';
labelStr = ['<html>visit <a href="">' 'gDrive' '</a></html>'];
jLabel = javaObjectEDT('javax.swing.JLabel', labelStr);
[hjLabel,hContainer] = javacomponent(jLabel, [10,10,250,20], gcf);
set(hContainer,'units','norm','position',[.45 .01 .2 .1]);%,'backgroundcolor',[0  1 1])
%  http://undocumentedmatlab.com/articles/javacomponent-background-color

% Modify the mouse cursor when hovering on the label
hjLabel.setCursor(java.awt.Cursor.getPredefinedCursor(java.awt.Cursor.HAND_CURSOR));
hjLabel.setBackground(java.awt.Color(1,1,1));

% jFont = java.awt.Font('Tahoma', java.awt.Font.PLAIN, 20);
% hjLabel.setFont(jFont);
drawnow;

% Set the label's tooltip
hjLabel.setToolTipText(['<html><b>' 'Visit template on google drive ' '</b>' '<br><font color=green>'  url '</html>']);

% Set the mouse-click callback
set(hjLabel, 'MouseClickedCallback', @(h,e)web([url], '-browser'));





function selpath(e,e2,par)

p=get(gcf,'userdata');
if par==1 %ANTTEMPLATES
    set(findobj(gcf,'tag','path2'),'value',0);
    set(findobj(gcf,'tag','paout'),'string',p.paout);
elseif par==2
    set(findobj(gcf,'tag','path1'),'value',0);
    
    [pa]=uigetdir(p.paout,'Select local folder where downloaded template(s) will be saved.');
    if isnumeric(pa) %error
        set(findobj(gcf,'tag','path1'),'value',1);
        selpath([],[],1)
        return
    end
    if (~isempty(strfind(pa,'antx2'))) && ...
            (exist(fullfile([pa(1:min(strfind(pa,'antx2'))-1) 'antx2'],'antlink.m'))==2)
        msgbox(['Template cannot be downloaded into ANTx-folder.' char(10)  ...
            'Please select another folder such as the "anttemplates"-folder.' char(10) ....
            '  Suggestion: ' char(10) ...
            'Create a folder "anttemplates" at the same hierarchical level as ANTx-TBX.' ....
            '              Then select this folder. The template will be downloaded into this folder'],'Error','error');
        return
    end
    
    set(findobj(gcf,'tag','paout'),'string',pa);
end

function selectall(e,e2)
p=get(gcf,'userdata');
val=get(findobj(gcf,'tag','selectall'),'value');
if val==1
    p.uit.Data(:,1)=repmat({logical(1)},  [size(p.t,1) 1]);
else
    p.uit.Data(:,1)=repmat({logical(0)},  [size(p.t,1) 1]);
end

function get_wpad(e,e2)

 if ispc
   [r1 r2]=system('echo %TEMP%');
   r2=strsplit(r2,char(10));
   r2=r2{1};
   file=fullfile(r2, 'wpad.html');
   xget   = fullfile(fileparts(which('xdownloadtemplate.m')),'xget.exe');
   system(['"' xget '" --no-hsts "http://wpad/wpad.dat" -O ' file ]);
   


%     
%     line_num=dbstack; % get this line number
%     line_num(end).line % displays the line number
%     
 else
    disp('unix-wpad to be implemented');
     line_num=dbstack; % get this line number
    disp(['line: ' num2str(line_num(end).line) ]); % displays the line number
end


if isempty(file)
    %�����������������������������������������������
%%   
%�����������������������������������������������
    space=repmat('&nbsp;',[1 5]);
    lg={'<html><FONT color=red>'};
    lg{end+1,1}=['<p style="background-color: #F0EEF3">'];
    lg{end+1,1}=[repmat('-',[1 145]) ' message_start' '<br>'];
    
    lg{end+1,1}=[space '<b>There seems to be no proxies!' '</b><br>'];
    lg{end+1,1}=[repmat('-',[1 145]) '<br>'];
    
     lg{end+1,1}=[space '<FONT color=k> Proxy was checkd via <b>["http://wpad/wpad.dat"]</b> .' '<br></FONT>'];
    
    lg{end+1,1}=[  ' !!! But this is no guarantee !!!  Maybe check other resiurces as well.' '<br>'];

     lg{end+1,1}=[ '<br>'];
    
    lg{end+1}=['<FONT color=#0832ED><b>[MAC/LINUX]</b><br>'];
    lg{end+1,1}=[space 'Open termnal and type: "env | grep proxy" and check for potential proxies.' '<br>'];
    
    lg{end+1}=['<FONT color=#8808ED><b>[MAC/LINUX]</b><br>'];
    lg{end+1,1}=[space 'Open cdm-window and type: "netsh winhttp show proxy" and check for potential proxies.' '<br>'];
  
    lg{end+1}=['<FONT color=#000000><b>[Other]</b><br>'];
    lg{end+1}=['# check Settings/Connection Settings of Browser  <br>' ];
    lg{end+1}=['# check value of http_proxy environment variables via Termin:' '<br>'];
    lg{end+1}=['......MAC/LINUX : [echo "$http_proxy"]  and  [echo "$https_proxy"]  <br>' ];
    lg{end+1}=['......WIN       : [echo "%http_proxy%"]  and  [echo "%http_proxy%"]  <br>' ];
    lg{end+1}=['# ask ADMIN...  <br>' ];
    lg{end+1}=['# ask GOOGLE...  <br>' ];
    
    lg{end+1}=['</FONT>'];
    
%     lg{end+1}=['<FONT color=#0008ED><b>[HTTPS-PROXY]</b><br>'];
%     lg{end+1,1}=[space 'Copy the PROXY_IP and PORT into the [HTTPS-PROXY]-field' '<br>'];
%     lg{end+1,1}=[space 'and add a "https://"-prefix.  &#8594;   <b> [https://PROXY_IP:PORT]  </b>' '<br>'];
%     lg{end+1,1}=[space '<FONT color=green> Example: For Charite/Germany the [HTTPS-PROXY] is: https://proxy.charite.de:8080' '<br></FONT>'];
%     lg{end+1}=['</FONT>'];
%     
    lg{end+1}=['<FONT color=red><b>[Other]</b><br>'];
    lg{end+1,1}=[repmat('-',[1 145]) ' message_stop' '<br>'];
    % lg{end+1,1}=['<p style="background-color: #FFFF00">This whole paragraph <br>of text is highlighted in yellow.</p>'];
    lg{end+1,1}=['</p>'];
    lg{end+1,1}=['</FONT>'];
    lg{end+1,1}=['</html>'];
    pwrite2file(file,lg);
    web(file);
    %�����������������������������������������������
%%   
%�����������������������������������������������
else
    a=preadfile(file);
    %�����������������������������������������������
%%   
%�����������������������������������������������
space=repmat('&nbsp;',[1 5]);
lg={'<html><FONT color=red>'};
lg{end+1,1}=['<p style="background-color: #F0EEF3">'];
lg{end+1,1}=[repmat('-',[1 145]) ' message_start' '<br>'];

lg{end+1,1}=[space '<b>Please check the below text and search for "PROXY"-tags followed by a PROXY_IP adress and a PORT!' '</b><br>'];
lg{end+1,1}=[repmat('-',[1 145]) '<br>'];



lg{end+1,1}=['<FONT color=green> Example: For Charite/Germany this file would contain: "{ return "PROXY proxy.charite.de:8080"; }"' '<br></FONT>'];

lg{end+1}=['<FONT color=#0832ED><b>[HTTP-PROXY]</b><br>'];
lg{end+1,1}=[space 'Copy the PROXY_IP and PORT into the [HTTP-PROXY]-field' '<br>'];
lg{end+1,1}=[space 'and add a "http://"-prefix.  &#8594;   <b> [http://PROXY_IP:PORT]  </b>' '<br>'];
lg{end+1,1}=[space '<FONT color=green> Example: For Charite/Germany the [HTTP-PROXY] is: http://proxy.charite.de:8080' '<br></FONT>'];

lg{end+1}=['</FONT>'];

lg{end+1}=['<FONT color=#8808ED><b>[HTTPS-PROXY]</b><br>'];
lg{end+1,1}=[space 'Copy the PROXY_IP and PORT into the [HTTPS-PROXY]-field' '<br>'];
lg{end+1,1}=[space 'and add a "https://"-prefix.  &#8594;   <b> [https://PROXY_IP:PORT]  </b>' '<br>'];
lg{end+1,1}=[space '<FONT color=green> Example: For Charite/Germany the [HTTPS-PROXY] is: https://proxy.charite.de:8080' '<br></FONT>'];
lg{end+1}=['</FONT>'];

lg{end+1,1}=[repmat('-',[1 145]) ' message_stop' '<br>'];
% lg{end+1,1}=['<p style="background-color: #FFFF00">This whole paragraph <br>of text is highlighted in yellow.</p>'];
lg{end+1,1}=['</p>'];
lg{end+1,1}=['</FONT>'];
lg=[lg; a.all];
lg{end+1,1}=['</html>'];
pwrite2file(file,lg);
web(file);
   %�����������������������������������������������
%%   
%����������������������������������������������� 
    
end