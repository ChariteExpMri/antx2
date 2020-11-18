
% #lk  ***  Download Template(s) from Google Drive via GUI  ***
%
% This function can be used to download template(s) from  Google drive.
% Google drive: 
%        https://drive.google.com/drive/u/2/folders/1q5XOOVLvUYLqYsQJLqNRF7OK8fNwYhI9
% Note that a "template" is a #k folder #n with Nifti-files (Not a single file!).
% The templates can be alos downloaded manually from the above google address.
% --------------------------------------------------------------------------------
% #lk *** GUI controls ***
% #b [select all]       #n Select all templates from the table to download (radio).
% #b [table checkboxes] #n Select one ore more templates from the table to download.
% #b [wpad]             #n Get "Web Proxy Auto-Discovery Protocol" to detect 
%                       your or the department's intermediary proxy.
%                     - see [wpad] for other options to obtain the proxy address/port
% #b [use proxy]        #n Use proxys. Use this only if there is an intermediary proxy.
%                       [x] Yes, I'm behind a proxy
%                       [ ] there is no proxy 
% #b [http/https proxies] #n Specify your proxy addresses.
%                      - only applies if [use proxy] is enabled!
%                      - use items from pulldown menu for costumizing proxy address/port
%                      ..see [wpad] for other options to detect proxy address/port
% #b [f.OVR]  #n Force to overwrite folder. 
%            [x] an existing folder with the same template name will be overwritten (no feedback)
%            [ ] The user decides how to proceed (overwrite vs. skip this download)
% #b [local template path] #n This is the main target folder. The downloaded template is
%           stored here. 
%         - The "anttemplates"-folder is the default download-folder
%         - use radio [user specified] to select another target folder
%     #b [anttemplates]    #n Set target folder to the "anttemplates"-folder
%     #b [user specified]  #n User defines the target folder where template is stored
% #b [Download] #n  This will download the selected templates.
%                #n The GUI #r stays open #n when selecting the [Download] button.
% #b [Close]    #n Close GUI. You have to explicitely close this GUI afterwards.
% 
% #lk *** TESTS ***
% Successfully tested with & without proxies using Windows 10, Mac Catalina and Ubuntu 18
% #k WINDOWS: #n relies on "Wget 1.20.3": https://eternallybored.org/misc/wget/
%           - The exe-file was renamed to "xget.exe" instead of "wget.exe" 
%           - The exe-file is located here: ..\antx2\mritools\ant\gdriveTemplate\ 
% #k LINUX/MAC : #n using curl-function (distributed with the OS)
% 
% 

function xdownloadtemplate

warning off;
 p.paout=fullfile(fileparts(fileparts(which('antlink'))),'anttemplates'); %FINAL
%p.paout=fullfile(fileparts(fileparts(which('antlink'))),'anttemplates_test'); %TEST

% t=load('C:\paultest\rclone\gdrivetemplates.mat');
t=load(which('gdrivetemplates.mat'));  %in TBX
p.t=t.l2;



makefig(p);



% set(gcf,'userdata',p);
return

% % uiwait(gcf);
% 
% p=get(gcf,'userdata');
% p.selection  = find(cell2mat(p.uit.Data(:,1)));
% p.uitable    = p.uit.Data;
% p.paout      = get(findobj(gcf,'tag','paout'),'string');
% 
% %-----delete file
% delete(findobj(0,'tag','gdrive')); %delete previous table
% drawnow;
% 
% if isempty(p.selection)
%     disp('process aborted..no template selected.');
%     return
% end
% 
% %----process
% if p.isOK==0
%     disp('process aborted by user.');
%     return
% elseif p.isOK==1
%     disp('...');
%     process(p);
%     
%     return
% end



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
    
    %------------forceOverwrite
    forceOverwrite=get(findobj(gcf,'tag','forceOverwrite'),'value');
    
    
     skiplist=[];
    for i=1:length(idxall)
        
        fiout=fullfile(p.paout,strrep(p.t{idxall(i),4},'.zip',''));
        
       %  mkdir(fiout); %ONLY A TESTER
        
        if exist(fiout)==7 %EXIST
            if forceOverwrite==1
                ovrlog=1;
            elseif forceOverwrite==0
               
                %———————————————————————————————————————————————
                %%
                %———————————————————————————————————————————————
                CT={'overwrite','skip','cancel all'};
                choice = questdlg(...
                    {'OUTPUT-FOLDER: '
                    ['[FOLDER]: "' fiout '"' 'exists!']
                    '    [overwrite]: Try to overwrite this folder.'
                    '            [skip]: Do not download this template.'
                    '       [skip all]: No templates will be downloaded'
                    },...
                    '? OVERWRITE STUFF', CT{1},CT{2},CT{3},CT{1});
                ovrlog=find(strcmp(CT,choice));  %[1]overwrite[2]skip file [3] cancel
                
                %———————————————————————————————————————————————
                %%
                %———————————————————————————————————————————————
            end %if focetoOverwrite
            
            if ovrlog==1
                
                disp('OVR-1');
                try; rmdir(fiout, 's'); end
            elseif ovrlog==2
                disp('OVR-2');
                skiplist=[skiplist i];
            else
                idxall=[];
                break
                return
            end
            
        end
    end
    
    
   if exist('skiplist')==1 %remove skipped templates
       idxall      =setdiff(idxall,skiplist);
       p.selection =idxall;
   end
    
    
    %———————————————————————————————————————————————
    %%
    %———————————————————————————————————————————————
    if isempty(idxall); %nothing selected
        return
    end
    
    
    %----download
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
    https_proxy =strrep(p.https_proxy,'https://','');
    
    shfile=fullfile(fileparts(which('xdownloadtemplate.m')),'getFileGdrive.sh');
    fun   =[ 'sh ' shfile];
    %     fun   =fullfile( 'sh ', 'getFileGdrive.sh')
    %      fun   =['sh ' 'getFileGdrive.sh']
    ms=['!' fun ' ' googleID_unix  ' ' fiout_unix ' ' http_proxy ' ' https_proxy ];
    %ms=[ 'cd ' fileparts(which('xdownloadtemplate.m')) ';' ms]
    ms=regexprep(ms,'\s*$','');
    eval(ms);
    
    %     !sh /Users/skoch/Documents/mac_stuff/antx2/mritools/ant/gdriveTemplate/getFileGdrive.sh "1nX0g2DaMIPIVgQGead97dCdeNEflFN6h" "/Users/skoch/Documents/mac_stuff/anttemplates_test/mouse_Allen2017HikishimaLR.zip"
    
    %eval(['!ls -l ' shfile])
    %eval(['!sudo chmod 666 ' shfile])
    %eval(['!sudo chmod 777 ' shfile])
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
        try; delete(fileName)   ;end  %3) remove old zip-file
        try; rmdir(oldname ,'s');end  %4) remove old main-folder
        fileNameOut=fileName2;%final finalName
    end
end
disp(['[done]..dtime (min): ' num2str(toc(atim)/60)]);




function pb_help(e,e2)
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
set(hb,'position',[.2 .25 .3 .025],'tag','http_proxy');
set(hb,'tooltipstring','http_proxy','fontweight','normal');
set(hb,'fontsize',8);
jCombo = findjobj(hb);
jCombo.setEditable(true);


https_proxyList={'https://proxy.charite.de:8080' 'https://proxyIP:PORT' 'https://#:#' '<empty>'};
%% pulldown http_proxy
hb=uicontrol('style','popup','units','norm','string',https_proxyList);
set(hb,'position',[.52 .25 .3 .025],'tag','https_proxy');
set(hb,'tooltipstring','https_proxy','fontweight','normal');
set(hb,'fontsize',8);
jCombo = findjobj(hb);
jCombo.setEditable(true);

%% TXT http_proxy
hb=uicontrol('style','text','units','norm','string','HTTP PROXY');
set(hb,'backgroundcolor','w','fontweight','bold');
set(hb,'position',[.2 .28 .3 .05]);
set(hb,'fontsize',8);
%% TXT https_proxy
hb=uicontrol('style','text','units','norm','string','HTTPS PROXY');
set(hb,'backgroundcolor','w','fontweight','bold');
set(hb,'position',[.5 .28 .3 .05]);
set(hb,'fontsize',8);

%% check internet connection-bulb
hb=uicontrol('style','push','units','norm','string','','fontsize',7);
set(hb,'tag','internetconnection');
set(hb,'position',[.75 .14 .06 .06]);
set(hb,'units','pixels')
hbpos=get(hb,'pos');
set(hb,'pos', [hbpos(1:2) 16 16]);
set(hb,'units','norm','backgroundcolor','w')
set(hb,'tooltipstring',['internet connection']);

internetconnection_retry();



%% check internet connection-retry
hb=uicontrol('style','push','units','norm','string','retry NET','fontsize',7);
set(hb,'tag','internetconnection_retry');
set(hb,'position',[.78 .14 .1 .06]);
set(hb,'tooltipstring',['retry internet connection...if bulb is red']);
set(hb,'callback',@internetconnection_retry);

%% force overwrite-radio
hb=uicontrol('style','radio','units','norm','string','f.OVR','fontsize',7);
set(hb,'tag','forceOverwrite');
set(hb,'position',[.9 .21 .15 .07]);
set(hb,'tooltipstring',[...
    '[FORCE TO OVERWRITE] this specific template folder.' char(10) ...
    '[x] force to overwrite folder, if folder already exists' char(10) ...
    '[ ] User decides how to proceed.' char(10) ...
    ],'backgroundcolor','w');
% set(hb,'callback',@get_wpad);

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
set(hb,'position',[.55 .95 .05 .03],'tag','pb_help','callback',@pb_help);
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
    
    %     line_num=dbstack; % get this line number
    %     line_num(end).line % displays the line number
    %
else
    %disp('unix-wpad to be implemented');
    %line_num=dbstack; % get this line number
    %disp(['line: ' num2str(line_num(end).line) ]); % displays the line number
    [r1 r2]=system('echo ~/Documents');
    r2=strsplit(r2,char(10));
    r2=r2{1};
    file=fullfile(r2, 'wpad.html');
    system(['curl "http://wpad/wpad.dat" > ' file ]);
    %web(file);
end

a=preadfile(file);
% html=preadfile(file);
html=char(regexprep( (a.all),'\s*',''));
if isempty(html)
    %———————————————————————————————————————————————
    %%  empty
    %———————————————————————————————————————————————
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
    %———————————————————————————————————————————————
    %%
    %———————————————————————————————————————————————
else
    %a=preadfile(file);
    %———————————————————————————————————————————————
    %%   wpad not empty
    %———————————————————————————————————————————————
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
    %———————————————————————————————————————————————
    %%
    %———————————————————————————————————————————————
    
end

function internetconnection_retry(e,e2);
hb=findobj(gcf,'tag','internetconnection');
disp('checking internet connection...');
hm=uicontrol('style','text','units','norm','string','wait','fontsize',25);
set(hm,'pos',[.4 .2 .5 .6],'string','wait...checking internet connection','backgroundcolor',[1 .8 0]);
drawnow;
netstate=chk_internetconnection();
if netstate==1 %OK
    ic=getIcon('green'); msgnet='NETWORK established';
    disp('internet connection.... OK.');
else
    ic=getIcon('red');   msgnet='no NETWORK check network cable/wlan access';
    disp('internet connection.... FAILED! ...check network cable/wlan access');
end
set(hb,'CData',ic,'tooltipstring',msgnet);
delete(hm);

function netstate=chk_internetconnection();
if ispc
    [a,b]=system('ping -n 1 www.google.com');
elseif isunix
    [a,b]=system('ping -c 1 www.google.com');
end
if a==0
    netstate=1; % OK..ther is newtworkconnection
else
    netstate=0;
end

% --------------------------- 
% WINDOWS
% ---------------------------
%  ---------NO NETWORK----

% [a,b]=system('ping -c 1 www.google.com')
% 
% a =
% 
%     68
% 
% 
% b =
% 
%     'ping: cannot resolve www.google.com: Unknown host
%      '
     
% vs ---------NETWORK----

% [a,b]=system('ping -c 1 www.google.com')
% 
% a =
% 
%      0
% 
% 
% b =
% 
%     'PING www.google.com (172.217.16.68): 56 data bytes
%      64 bytes from 172.217.16.68: icmp_seq=0 ttl=117 time=11.723 ms
%      
%      --- www.google.com ping statistics ---
%      1 packets transmitted, 1 packets received, 0.0% packet loss
%      round-trip min/avg/max/stddev = 11.723/11.723/11.723/0.000 ms
%      '

% --------------------------- 
% WINDOWS
% ---------------------------
%  ---------NO NETWORK----
% >> [a,b]=system('ping -n 1 www.google.com')
% a =
% 
%      1
% b =
% 
%     'Ping-Anforderung konnte Host "www.google.com" nicht finden. Überprüfen Sie den Namen, und versuchen Sie es erneut.
%      '
% %      '
% vs ---------NETWORK----
% a = 
% 
%      0
% b =
% 
%     '
%      Ping wird ausgeführt für www.google.com [172.217.16.68] mit 32 Bytes Daten:
%      Antwort von 172.217.16.68: Bytes=32 Zeit=20ms TTL=128
%      
%      Ping-Statistik für 172.217.16.68:
%          Pakete: Gesendet = 1, Empfangen = 1, Verloren = 0
%          (0% Verlust),
%      Ca. Zeitangaben in Millisek.:
%          Minimum = 20ms, Maximum = 20ms, Mittelwert = 20ms
%      '
% 





function ic=getIcon(str)

if strcmp(str, 'green')
    
    
    %     ic(:,:,1)=[[NaN NaN NaN NaN NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN 0 0 0 NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN]];
    %     ic(:,:,2)=[[NaN NaN NaN NaN NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN 0 0 0 NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN]];
    %     ic(:,:,3)=[[NaN NaN NaN NaN NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN 0 0 0 0 0 0 NaN NaN 0;NaN NaN NaN NaN 0 NaN NaN NaN NaN 0 0 NaN NaN NaN NaN 0;NaN NaN NaN NaN NaN 0 NaN NaN NaN 0 0 NaN NaN NaN 0 NaN;NaN NaN NaN NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN 0 NaN;NaN NaN NaN NaN 0 0 0 0 NaN NaN NaN NaN 0 0 NaN NaN;NaN NaN NaN 0 0 0 NaN NaN 0 0 0 0 NaN NaN NaN NaN;NaN NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN 0 0 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN;NaN NaN 0 NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN]];
    %
   ic(:,:,1)=[[255 255 255 255 231 135 68 36 36 68 135 231 255 255 255 255;255 255 254 136 13 39 94 121 121 94 39 13 136 254 255 255;255 254 95 21 109 157 158 159 159 158 157 109 21 95 254 255;255 136 23 111 133 135 137 138 138 137 135 133 111 24 136 255;231 22 80 115 119 122 124 126 126 124 122 119 115 80 22 231;135 41 99 107 112 116 119 120 120 119 116 112 107 99 41 135;72 67 97 105 111 116 119 121 121 120 116 111 105 98 67 72;50 78 99 108 116 121 125 128 128 125 121 116 108 99 79 50;51 88 105 115 124 131 136 138 138 136 131 124 116 105 89 51;74 100 114 126 135 143 149 152 152 149 144 135 126 114 100 74;135 91 125 138 149 158 165 169 169 165 158 149 138 125 91 135;231 52 136 150 163 174 182 187 187 182 174 163 150 136 52 231;255 136 100 162 179 191 202 207 207 202 192 179 162 100 136 255;255 254 98 115 191 210 220 227 227 221 210 191 115 98 254 255;255 255 254 136 74 171 228 241 241 229 171 74 136 254 255 255;255 255 255 255 231 135 84 85 85 84 135 231 255 255 255 255]];
   ic(:,:,2)=[[255 255 255 255 231 135 78 65 65 78 135 231 255 255 255 255;255 255 254 136 60 134 185 197 197 185 134 60 136 254 255 255;255 254 98 108 192 213 214 214 214 214 213 192 108 98 254 255;255 136 109 193 203 204 205 205 205 205 204 203 193 109 136 255;231 65 179 194 196 198 199 200 200 199 198 196 194 179 65 231;135 135 187 191 193 195 196 197 197 196 195 193 191 187 135 135;80 174 187 190 193 195 196 197 197 196 195 193 190 187 174 80;70 179 187 191 194 197 200 201 201 200 197 194 191 188 179 70;72 183 190 194 199 202 204 205 205 204 202 199 194 190 183 72;81 188 194 199 204 207 210 211 211 210 207 204 200 194 188 81;135 156 199 205 210 214 217 218 218 217 214 210 205 199 156 135;231 77 204 210 216 220 224 226 226 224 220 216 210 204 77 231;255 136 142 215 223 228 232 234 234 232 228 223 215 142 136 255;255 254 99 149 228 235 240 243 243 240 235 228 149 99 254 255;255 255 254 136 87 191 243 249 249 243 191 87 136 254 255 255;255 255 255 255 231 135 86 86 86 86 135 231 255 255 255 255]];
   ic(:,:,3)=[[255 255 255 255 231 135 72 49 49 72 135 231 255 255 255 255;255 255 254 136 31 77 131 151 151 131 77 31 136 254 255 255;255 254 96 50 135 172 171 171 171 171 172 135 50 96 254 255;255 136 45 129 144 143 142 142 142 142 143 144 129 45 136 255;231 29 92 118 117 116 116 116 116 116 116 117 118 92 29 231;135 45 95 95 94 93 92 92 92 92 93 94 95 95 45 135;72 56 77 75 73 72 71 71 71 71 72 73 75 77 56 72;45 50 60 58 56 54 53 53 53 53 54 56 58 60 50 45;45 43 47 45 42 40 39 38 38 39 40 42 45 47 43 45;71 40 37 35 32 30 29 28 28 29 30 32 35 37 40 71;135 29 33 29 26 24 22 21 21 22 24 26 29 33 29 135;231 21 30 27 24 21 19 18 18 19 21 24 27 30 21 231;255 136 19 29 34 30 28 26 26 28 30 34 29 18 136 255;255 254 95 15 40 57 55 53 53 54 57 40 15 95 254 255;255 255 254 136 15 20 42 52 52 42 20 15 136 254 255 255;255 255 255 255 231 135 68 36 36 68 135 231 255 255 255 255]];
   ic([1 end],:,:)=0;    ic(:,[1 end],:)=0;
    ic=ic./255;
elseif strcmp(str, 'red')
    ic(:,:,1)=[[255 255 255 255 231 135 86 87 87 86 135 231 255 255 255 255;255 255 254 136 96 206 254 255 255 254 206 96 136 254 255 255;255 254 101 173 254 254 255 255 255 255 254 254 173 101 254 255;255 136 173 254 254 254 254 254 254 254 254 254 254 173 136 255;231 96 253 254 254 253 253 253 253 253 253 254 254 253 96 231;135 205 253 253 253 253 253 253 253 253 253 253 253 253 205 135;86 252 252 252 252 251 251 251 251 251 251 252 252 252 252 86;87 252 251 251 251 251 251 251 251 251 251 251 251 251 252 87;86 251 251 251 250 250 250 250 250 250 250 250 251 251 251 86;86 251 251 250 250 249 249 249 249 249 249 250 250 251 251 86;135 203 250 250 249 249 249 249 249 249 249 249 250 250 203 135;231 95 250 249 249 248 248 248 248 248 248 249 249 250 95 231;255 136 170 249 249 248 248 248 248 248 248 249 249 170 136 255;255 254 101 170 249 249 248 248 248 248 249 248 170 101 254 255;255 255 254 136 94 201 247 248 248 247 201 94 136 254 255 255;255 255 255 255 231 135 86 85 85 86 135 231 255 255 255 255]];
   ic(:,:,2)=[[255 255 255 255 231 135 68 36 36 68 135 231 255 255 255 255;255 255 254 136 12 36 92 119 119 92 36 12 136 254 255 255;255 254 95 17 104 153 153 154 154 153 153 104 17 95 254 255;255 136 17 103 125 126 127 128 128 127 126 125 104 17 136 255;231 18 67 102 105 107 108 109 109 108 107 105 102 67 18 231;135 26 82 88 91 94 95 96 96 95 94 91 88 82 26 135;70 44 74 79 83 86 88 89 89 88 86 83 79 74 44 70;44 50 69 75 79 83 86 87 87 86 83 80 75 69 50 45;45 55 69 75 80 85 88 89 89 88 85 81 75 69 55 45;72 62 71 79 85 90 94 96 96 94 90 85 79 71 62 72;135 56 78 86 93 99 103 105 105 103 99 93 86 78 57 135;231 36 85 94 102 109 114 117 117 114 109 102 94 85 36 231;255 136 62 103 118 125 131 135 135 131 125 118 104 62 136 255;255 254 97 72 128 148 155 159 159 155 148 128 72 97 254 255;255 255 254 136 50 110 156 168 169 156 111 50 136 254 255 255;255 255 255 255 231 135 78 66 66 78 135 231 255 255 255 255]];
   ic(:,:,3)=[[255 255 255 255 231 135 68 36 36 68 135 231 255 255 255 255;255 255 254 136 10 32 88 115 115 88 32 10 136 254 255 255;255 254 95 10 96 146 146 146 146 146 146 96 10 95 254 255;255 136 6 91 112 112 112 112 112 112 112 112 91 6 136 255;231 10 47 82 82 82 82 82 82 82 82 82 82 47 10 231;135 3 55 57 57 57 57 57 57 57 57 57 57 55 3 135;68 9 37 37 37 37 38 38 38 38 37 37 37 37 9 68;36 6 21 22 22 22 22 22 22 22 22 22 22 21 6 36;36 2 11 11 11 12 12 12 12 12 12 11 11 11 2 36;68 2 3 5 6 6 6 6 6 6 6 6 5 3 2 68;135 2 3 4 4 4 4 4 4 4 4 4 4 3 2 135;231 11 3 4 5 6 6 6 6 6 6 5 4 3 11 231;255 136 2 10 19 19 19 20 20 19 19 19 10 2 136 255;255 254 95 3 28 50 50 50 50 50 50 28 3 95 254 255;255 255 254 136 11 15 41 54 54 41 15 11 136 254 255 255;255 255 255 255 231 135 68 37 37 68 135 231 255 255 255 255]];
    ic([1 end],:,:)=0;    ic(:,[1 end],:)=0;
    ic=ic./255;
elseif strcmp(str, 'clear')
    
    ic(:,:,1)=[0 1 5 5 5 5 5 5 5 5 5 5 5 5 1 0;1 164 220 219 219 218 218 217 217 216 216 215 214 215 161 1;6 203 209 209 209 209 209 209 209 209 209 209 209 209 198 6;7 194 202 190 193 192 202 202 202 202 192 193 190 202 189 8;8 187 194 226 240 216 190 194 194 189 215 240 226 194 184 9;10 181 187 198 235 233 215 190 189 213 231 234 198 187 179 10;11 176 180 180 195 230 226 214 213 222 226 195 180 180 178 11;12 167 170 177 186 203 225 219 217 221 206 188 174 161 146 13;12 154 142 158 175 178 202 216 212 199 175 171 156 142 143 13;12 153 148 165 174 204 221 222 217 207 199 176 165 148 142 13;12 153 153 169 213 230 229 237 236 219 220 215 172 153 143 13;12 152 154 221 239 236 231 244 244 231 233 239 224 154 143 13;12 152 153 193 239 214 221 233 233 221 214 239 194 153 145 13;11 152 148 164 180 196 209 217 217 209 196 180 164 148 146 12;3 124 148 152 157 161 164 166 166 163 159 155 149 144 116 3;0 3 11 12 12 12 12 12 12 12 12 12 12 11 3 0];
    ic(:,:,2)=[0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0;0 75 112 107 107 107 107 107 107 107 107 107 107 112 75 0;0 88 152 152 152 152 152 152 152 152 152 152 152 152 102 0;0 68 136 145 186 139 136 136 136 136 139 186 145 136 87 0;0 60 121 218 240 211 130 121 121 130 210 240 218 121 82 0;0 52 105 131 229 233 209 122 122 207 231 228 131 105 78 0;0 46 89 89 120 223 226 207 206 222 219 120 89 89 79 0;0 33 66 76 84 118 217 219 217 215 128 87 69 47 14 0;0 10 2 18 35 66 194 216 212 190 52 23 12 2 12 0;0 14 6 19 51 192 221 209 204 207 187 54 19 6 16 0;0 18 10 48 202 230 217 104 103 207 220 203 51 10 20 0;0 22 11 205 239 224 100 79 79 100 221 239 208 11 24 0;0 26 10 94 223 87 62 71 71 62 87 223 94 10 27 0;0 35 6 18 30 42 52 58 58 52 42 30 18 6 32 0;0 31 38 36 40 44 47 49 49 47 44 40 36 35 23 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    ic(:,:,3)=[0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0;0 75 112 107 107 107 107 107 107 107 107 107 107 112 75 0;0 88 152 152 152 152 152 152 152 152 152 152 152 152 102 0;0 68 136 145 186 139 136 136 136 136 139 186 145 136 87 0;0 60 121 218 240 211 130 121 121 130 210 240 218 121 82 0;0 52 105 131 229 233 209 120 120 207 231 228 131 105 78 0;0 46 89 89 117 222 226 206 205 222 219 117 89 89 79 0;0 32 66 73 74 105 215 219 217 213 116 77 66 47 13 0;0 9 0 5 13 42 192 216 212 187 26 0 0 0 10 0;0 11 0 0 27 189 221 205 199 207 184 29 0 0 12 0;0 13 0 30 199 230 211 45 44 201 220 201 33 0 14 0;0 15 0 203 239 220 45 0 0 45 216 239 206 0 15 0;0 16 0 79 219 46 0 0 0 0 46 219 79 0 16 0;0 22 0 0 0 0 0 0 0 0 0 0 0 0 20 0;0 26 22 17 17 17 17 17 17 17 17 17 17 19 17 0;0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    %source: https://iconarchive.com/search?q=delete+16x16&res=16&page=1
elseif strcmp(str, 'bulb')
    a2=[0 1 0.0313725490196078 0.32156862745098 1 1 1 1 1 1 1 1 1 1 0.83921568627451 0.741176470588235 0.968627450980392 0.905882352941176 0.741176470588235 0.968627450980392 0.776470588235294 0.258823529411765 0.776470588235294 0.0627450980392157 0.0313725490196078 1 0 0 0 0 0 0;0 1 0.0470588235294118 0.333333333333333 1 1 1 1 1 1 1 1 1 1 0.811764705882353 0.729411764705882 0.952941176470588 0.890196078431373 0.713725490196078 0.937254901960784 0.745098039215686 0.235294117647059 0.764705882352941 0.0627450980392157 0.0313725490196078 1 0 0 0 0 0 0;0 1 0.0627450980392157 0.290196078431373 0 0.290196078431373 0.32156862745098 0.352941176470588 0.517647058823529 0.611764705882353 0.67843137254902 0.83921568627451 0.870588235294118 0.968627450980392 0 0.0941176470588235 0.223529411764706 0.258823529411765 0.0941176470588235 0.290196078431373 0.290196078431373 0.0627450980392157 0.741176470588235 0.0627450980392157 0.0313725490196078 1 0 0 0 0 0 0]';
    aa2=[25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 25 25 25 21 25 25 25 25 25;25 25 21 25 25 21 21 21 21 25 25 25 25 25 25 25;25 25 25 25 21 20 16 19 17 21 21 25 25 25 25 25;25 25 25 21 15 11 13 8 5 14 14 21 21 24 24 25;25 25 25 21 18 12 1 10 5 5 4 4 21 1 1 2;21 21 25 21 18 12 1 4 7 21 21 4 21 22 22 2;25 25 25 21 18 9 7 5 5 5 4 4 21 3 3 2;25 25 25 21 18 6 4 4 4 18 18 21 21 2 23 25;25 25 25 25 21 18 18 18 18 21 21 25 25 25 25 25;25 25 21 25 25 21 21 21 21 25 25 25 25 25 25 25;25 25 25 25 25 25 25 25 25 25 21 25 25 25 25 25;25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 21 25 25 25 25 25 25 25 25;25 25 25 25 25 25 25 25 25 25 25 25 25 25 25 25]';
    ic= ind2rgb(uint8(aa2),a2);
    ic([1 end],:,:)=0;    ic(:,[1 end],:)=0;
elseif strcp(str,'hand')
    a2=[129 129 129 129 129 129 129 0 0 129 129 129 129 129 129 129;129 129 129 0 0 129 0 215 215 0 0 0 129 129 129 129;129 129 0 215 215 0 0 215 215 0 215 215 0 129 129 129;129 129 0 215 215 0 0 215 215 0 215 215 0 129 0 129;129 129 129 0 215 215 0 215 215 0 215 215 0 0 215 0;129 129 129 0 215 215 0 215 215 0 215 215 0 215 215 0;129 0 0 129 0 215 215 215 215 215 215 215 0 215 215 0;0 215 215 0 0 215 215 215 215 215 215 215 215 215 215 0;0 215 215 215 0 215 215 215 215 215 215 215 215 215 0 129;129 0 215 215 215 215 215 215 215 215 215 215 215 215 0 129;129 129 0 215 215 215 215 215 215 215 215 215 215 215 0 129;129 129 0 215 215 215 215 215 215 215 215 215 215 0 129 129;129 129 129 0 215 215 215 215 215 215 215 215 215 0 129 129;129 129 129 129 0 215 215 215 215 215 215 215 0 129 129 129;129 129 129 129 129 0 215 215 215 215 215 215 0 129 129 129;129 129 129 129 129 0 215 215 215 215 215 215 0 129 129 129];
    a2=cat(3,a2,a2,a2);
    ic=a2./255;
end