
% xQAregistration: calculate registration-based quality metric (standard-space comparison)
% -this procedure evaluates the animal registration quality to standard space
% -the [gm]-approach: the gray-matter compartement is warped to standard-space and compared with 
%  the gray matter image of the template (metrics: correlation or mutual information)
% -the resulting report is saved as HTML-file or excel-file
% -Use this function when registration to standard-space is done. 
% -run over many/all animals of the study to infer over relative deviances from reference image
% -before running this function select animals from the ANT-GUI
% 
% #ma ___ PARAMETER_____________________                                                    
% metric      +used metric [1] Pearson correlation(R); [2] mutual information (MI)   
%             default: [1]
% imageType   +image to compare with     
%             [gm]: compare gray matter; [avgt] compare x_t2.nii with AVGT.nii              
%              [gm]: -the gray matter image of the animal in standard-space is compared with
%                     the gray matter image of the template (reference image)
%            [avgt]: -the structural image of the animal in standard-space ("x_t2.nii") is compared
%                     with the structural image of the template ("AVGT.nii")
%             default: 'gm'
% forceReCreateImage +force to (re-)create image even when file exists
%                    -for "gm" the image "c1t2.nii will be forced to warped to standard-space
%                    {[0] NO; [1] yes}  
%             default: 0
% 
% report_dosave   +save report in checks-folder
%                 {[0] NO; [1] yes} 
%                 default: 1
% report_type     +save report as "html" or "xlsx" file
%                 {'html' 'xlsx'}
%                 default: 'html'
% report_filename  +file name of the report saved in the "checks"-folder 
%                   default: 'QA_registration';   
% report_addDate   +add date and time to the filename of the report
%                 {[0] NO; [1] yes} 
%                 default: 1
% #ga ___ GRAPHIC_____________________ 
% Explanation of the plot:
%   -blue dot: the metric-value of each animal   
%   -gray dot: the metric-value of each animal, here the animals image (example: the animal's gray matter image) 
%    in standard-space is shifted by one voxel in anterior-posterior and left-right directions to obtain 
%    a subjective measure for deviation
%   -horizontal magenta line displays the 2 SD deviation of the metric across animals
%   -outliers: missing data are displayed with a metric of 0 (these data are not involved in the 2 SD calculation) 
% 
% #ga ___ EXAMPLE_____________________                                                     
% % ==================================================================================================                                                                     
% % #g use Pearson correlation (metric) for gray matter image (imageType); save the report 
% % (report_dosave) as HTML-file (report_type) with filename 'QA_test' + timestamp (report_addDate) 
% %  execute command without showing the GUI (1st arg of xQAregistration is 0 )
% % ==================================================================================================                                                                     
% z=[];                                                                                                                   
% z.metric             = [1];           % % used metric [1]Pearson correlation(R); [2] mutual information (MI)            
% z.imageType          = 'gm';          % % imageType to compare "gm": gray matter image is compared                      
% z.forceReCreateImage = [0];           % % force to create image even when exists (warp image to standard-space)         
% z.report_dosave      = [1];           % % save report in checks-folder [0]NO, [1]yes                                    
% z.report_type        = 'html';        % % save report as "html" or "xlsx" file                                          
% z.report_filename    = 'QA_test';     % % filename to save the report in "checks"-folder                                
% z.report_addDate     = [1];           % % add time/dateStamp to the saved report                                        
% xQAregistration(0,z);                 % % run function, without GUI (1st arg is 0 )  
% 
%% =====[other calling options]===================
% xQAregistration(1);                                 % %  run function, with GUI, show default parameter 
% xQAregistration(1,z);                               % %  run function, with GUI (1st arg is 1 ) using specific parameter                                                                     
% 
% mdirs={
%     'F:\data5\nogui\dat\Devin_5apr22'
%     'F:\data5\nogui\dat\Kevin'
% };
% xQAregistration(0,z,mdirs);          % % run for specific animals (mdirs); no GUI
% 
% 
% 
% 
% 

%% ===============================================



function xQAregistration(showgui,x,pa)

isExtPath=0; % external path
if exist('pa')==1 && ~isempty(pa)
    isExtPath=1;
end
%===========================================
%%   PARAMS
%===========================================
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if isExtPath==0      ;    pa=antcb('getsubjects')  ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end

if isempty(pa); return; end



%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end

p={...
    'inf1'                  '--- QA registration parameter   ---             '                         ''    ''
    'metric'                1                           'used metric [1]Pearson correlation(R); [2] mutual information (MI)'  {1 ,2}
    'imageType'             'gm'                      'imageType to compare "gm": gray matter image is compared'         {'gm','avgt'}
    'forceReCreateImage'    0                           'force to create image even when exists (warp image to standard-space) ' 'b'
    'inf3'                  ''    '' ''
    'inf2'                  '__SAVE REPORT_________'    '' ''
    'report_dosave'         1                           'save report in checks-folder [0]NO, [1]yes'           'b'
    'report_type'           'html'                      'save report as "html" or "xlsx" file'                       {'html' 'xlsx'}
    'report_filename'       'QA_registration'           'filename to save the report in "checks"-folder'   ''
    'report_addDate'        1                           'add time/dateStamp to the saved report'                               'b'
        };




p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[0.15    0.3    0.5    0.3],...
        'title',[mfilename '.m'],'info',hlp);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

% ==============================================
%%   BATCH
% ===============================================
try
    isDesktop=usejava('desktop');
    % xmakebatch(z,p, mfilename,isDesktop)
    if isExtPath==0
        xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z);' ]);
    else
        xmakebatch(z,p, mfilename,[mfilename '(' num2str(isDesktop) ',z,mdirs);' ],pa);
    end
end


% ==============================================
%%   paths
% ===============================================

% mdirs=antcb('getallsubjects')
mdirs=pa;

% ==============================================
%%   parameter
% ===============================================



v.metric            =z.metric; %1; %[1]R; [2]MI
v.report_dosave     =z.report_dosave;%0;
v.report_filename   =z.report_filename;%['QA_registration2.xlsx'];
v.report_addDate    =z.report_addDate;%1; 
v.report_type       =z.report_type;
v.forceReCreateImage=z.forceReCreateImage;%  ;

% --------------------
v.shiftedmetric_show  =1;
v.shiftedmetric_value =1;
ipa.isDesktop=usejava('desktop');

% ==============================================
%%   obtain parameter
% ===============================================
ss.image=char(z.imageType);%'gm';
[pastudy datcontainer]=fileparts(fileparts(mdirs{1}));

ss.pastudy=pastudy;
ss.pacheck=fullfile(pastudy,'checks');
if exist(ss.pacheck)~=7; mkdir(ss.pacheck); end

ss.patemplates =fullfile(pastudy,'templates');

if strcmp(ss.image,'gm')
    ss.refimg            =fullfile(ss.patemplates,'_b1grey.nii');
    ss.sourceimg         ='x_c1t2.nii';
    ss.sourceimgNative   ='c1t2.nii';
    ss.tag='GM';
elseif strcmp(ss.image,'avgt')
    ss.refimg      =fullfile(ss.patemplates,'AVGT.nii');
    ss.sourceimg         ='x_t2.nii';
    ss.sourceimgNative   ='t2.nii';
    ss.tag='AVGT';
end


% ==============================================
%%   deform GM
% ===============================================
% mdirs=antcb('getallsubjects')
% mtest=mdirs{1}
% pp.source     =  'intern';
% files='c1t2.nii';
% doelastix(1   ,mdirs,      files   ,1 ,'local',pp );
% ==============================================
%%
% ===============================================
% addpath('minf')



clear p;

p.animal={};
% f2=fullfile('H:\Daten-2\Imaging\AG_Harms\2020_Exp7_2020_Exp9_2021_Exp1_IntFasting\T2_24h_all','templates' ,'_b1grey.nii')
f2=ss.refimg;
p.m =[];
p.m2=[];
p.dr=[];
p.di=[];
n=0;
m=[];
b=[];

for i=1:length(mdirs)
    isok=1;
    pdisp(i,1);
    pam=mdirs{i};
    f1=fullfile(pam,ss.sourceimg);
    %f1=fullfile(pam,'x_c1t2.nii');
    %     f1=fullfile(pam,'x_t2.nii');
    %f2=fullfile(pam,'AVGT.nii');
    f3=fullfile(pam,'AVGTmask.nii');
    
    if exist(f1)==0 || v.forceReCreateImage==1 % x_c1t2.nii does not exist
        f1pre=fullfile(pam,ss.sourceimgNative);
        if exist(f1pre)==2 %file exist ...%warp here
            %warp here
            pp.source     =  'intern';
            files=ss.sourceimgNative;%'c1t2.nii';
            doelastix(1   ,pam,      files   ,1 ,'local',pp );
        else
            isok=0;    
        end    
    end
    
    if isok==1% all(existn({f1  f3})==2)
        n=n+1;
        if isempty(m)
            [hm m]=rgetnii(f3);
            m=round(m);
            md=imdilate(m,strel('sphere',5));
            %             ima=find(m(:)==1);
            %             % m2=m(ima);%check
            islice=find(sum(sum(m,1),3)>0);
            ixdillmask=find(md==1);
        end
        [ha a]=rgetnii(f1);
        if isempty(b)
            [hb b]=rgetnii(f2);
        end
        
        %         a2=a(ixdillmask);
        %         b2=b(ixdillmask);
        a2=a(:);
        b2=b(:);
        
        [~,animal]=fileparts(pam);
         p.animal{n,1}  =animal;
        if v.metric==1
            p.m(n,1)       =corr(a2,b2);
        elseif v.metric==2
            p.m(n,1)      =mi(a2,b2);
        end
        %% ============shifted version===================================
        
        if v.shiftedmetric_show==1
            % a3=imtranslate(a,[ 0 1]);
            a3=imtranslate(a,[1 1]);
            if v.metric==1
                p.m2(n,1)       =corr(a3(:),b2);
            elseif v.metric==2
                p.m2(n,1)       =mi(a3(:),b2);
            end
        end
       
      % ============slicewise===================================
        if 0
            for j=1:length(islice)
                ac=squeeze(a(:,islice(j),:));
                bc=squeeze(b(:,islice(j),:));
                mc=squeeze(md(:,islice(j),:));
                av=ac(mc==1);
                bv=bc(mc==1);
                p.dr(n,j)=corr(av,bv);
                p.di(n,j)=mi(av,bv);
            end
        end
        
    else%missing data
        n=n+1;
        [~,animal]=fileparts(pam);
         p.animal{n,1}  =animal;
         p.m(n,1)=0;
        if v.shiftedmetric_show==1
             p.m2(n,1)=0;
        end
    end
    
    
    
end

% ==============================================
%%
% ===============================================
% return

% ==============================================
%%
% ===============================================
if v.metric==1; 
    ss.ylabel=['R_{Pearson} ' ss.tag ];
    ss.metric='R';
elseif v.metric==2;
    ss.ylabel=['MI ' ss.tag];
    ss.metric='MI';
end
ss.sheetname1=['QA_metric'];
ss.sheetname2=['QA_sorted'];
% ==============================================
%%   table
% ===============================================
t0=[ num2cell([1:length(p.m)]')  p.animal num2cell(p.m)];


% ==============================================
%%   show sorted table
% ===============================================

%---sorted table
t1=sortrows(t0,3);
ht1={'ID' 'ANIMAL' 'R(Pearson)'};

hd={'ID' 'Animal' ss.metric, 'MissingData'};
% f11=fullfile(pwd,'QA_registration.xlsx');
t2=t1;
t2(:,4)={'-'};
t2(find(cell2mat(t1(:,3))==0),4)={'missing data'};

if 0
    if ipa.isDesktop==1
        uhelp(plog([],[hd; t2],0,['ANIMAL-registration, animals sorted after ' ss.metric]),...
            1,'name','QA_registration');
    end
end



% ==============================================
%%   make figure
% ===============================================
% delete(findobj(0,'tag','QA_registration'));
if ipa.isDesktop==1
   fg; 
else
   figure('visible','off'); 
end
hold on
hf=gcf;
set(hf,'numbertitle','off','name','QA_registration','tag','QA_registration');
% if length(p.m)<2
%     hp=bar(p.m,'facecolor',repmat([.5],[1 3]));
% else
    hp=plot((p.m),'-r.','color',['k']);
% end

for i=1:length(p.m)
   hp2(i) =plot(i, p.m(i),'-ro','color',['b'],'markerfacecolor','b','markersize',4);
    set(hp2(i),'ButtonDownFcn',{@showID,t0},'tag','dotqa');
end



ylim([min(p.m)-.0025 max(p.m)+.001]);
xlim([0 length(p.m)+1]);
% zs=zscore(p.r);
ylabel(ss.ylabel);
showID();

io=[];
if length(p.m)>2
    metvalid=p.m(find(p.m~=0));
    hl=hline(mean(metvalid),'color',repmat(.7,[3 1])); uistack(hl,'bottom');
    tr=mean(metvalid)-2*std(metvalid);
    hl2=hline(tr,'m'); uistack(hl2,'bottom');
    io=find(p.m<tr); %outlier
    for i=1:length(io)
        ho=plot(io(i),p.m(io(i)),'ro');
        set(ho,'ButtonDownFcn',{@showID,t0},'tag','dotqa');
    end
end
if exist('metvalid')==1
    ylim([min(metvalid)-.0025 max(metvalid)+.001]);
end

%missing data
for i=1:length(p.m)
    if p.m(i)==0
        hp2(i) =plot(i, p.m(i),'-ro','color',['m'],'markerfacecolor','m','markersize',4);
        set(hp2(i),'ButtonDownFcn',{@showID,t0},'tag','dotqa');
    end
end

% shifted version
if v.shiftedmetric_value==1
    col=[.7 .7 .7];
    for i=1:length(p.m2)
        hp2=plot(i, p.m2(i),'-rd','color',col,'markerfacecolor',col,'markersize',4);
        uistack(hp2,'bottom')
        %set(hp2(i),'ButtonDownFcn',{@showID,t0});
    end
    
    %vertical lines
    for i=1:length(p.m2)
        hp2=plot([i i ], [p.m(i) p.m2(i) ],'-r','color',col,'markerfacecolor',col,'markersize',4);
        uistack(hp2,'bottom')
        %set(hp2(i),'ButtonDownFcn',{@showID,t0});
    end
    
end

grid minor

%% ==userdata=============================================
u.ss=ss;
u.hd=hd;
u.t2=t2;
u.metric=ss.metric;
set(gcf,'userdata',u);

%% =======context menu========================================
figure(hf)
c = uicontextmenu;
% Set c to be the plot line's UIContextMenu
hdot=findobj(hf,'tag','dotqa');
m2 = uimenu(c,'Label','show animated-gif (obntained from registration)'            ,'Callback',{@context_cb,'animatedGif'});
m1 = uimenu(c,'Label','show overlay "x_t2" & "AVGT.nii" (MRIcron)'                ,'Callback',{@context_cb,'showmricron_t2'});
if strcmp(u.ss.sourceimg,'x_t2.nii')==0
    m2 = uimenu(c,'Label',['show overlay "' u.ss.sourceimg '" & "AVGT.nii" (MRIcron)'],'Callback',{@context_cb,'showmricron_sourceimg'});
end
m2 = uimenu(c,'Label','copy animal-name to clipboard '                             ,'Callback',{@context_cb,'clipboardanimal'});
m2 = uimenu(c,'Label','preselect animal in ANT-GUI'                                ,'Callback',{@context_cb,'preselect'});

m2 = uimenu(c,'Label','animated-gif of animal with best registration' ...
    ,'Callback',{@context_cb,'animatedGif_best'});

set(hdot,'UIContextMenu',c);

% Create menu items for the uicontextmenu


% ==============================================
%%   button
% ===============================================
%ylimit
hbu=uicontrol('style','pushbutton','units','norm');
set(hbu,'position',[0.04    0.005    0.1    0.0476],'backgroundcolor','w');
set(hbu,'string','y-limit','tooltipstring','toggle y-limit range');
set(hbu,'callback',{@set_ylimits},'tag','ylimit');
us.state=1;
set(hbu,'userdata',us);

% table unosrted
hbu=uicontrol('style','pushbutton','units','norm');
set(hbu,'position',[0.15    0.005    0.12    0.0476],'backgroundcolor','w');
set(hbu,'string','table ','tooltipstring','show table');
set(hbu,'callback',{@showtable,1});
% table
hbu=uicontrol('style','pushbutton','units','norm');
set(hbu,'position',[0.27    0.005    0.12    0.0476],'backgroundcolor','w');
set(hbu,'string','table sorted','tooltipstring','show table');
set(hbu,'callback',{@showtable,2});

% show in mricron

% ==============================================
%%   show potential outliers in cmd  
% ===============================================
if ~isempty(io)
    cprintf('*[1 0 1]',['animals with ' ss.metric '-values below 2SD of mean' '\n']);
    disp(t0(io,:));
end

% ==============================================
%%   show missing data in cmd  
% ===============================================
imiss=find(cell2mat(t2(:,3))==0);
if ~isempty(imiss)
    cprintf('*[1 0 1]',['animals with missing data' '\n']);
    disp(t2(imiss,:));
end




% ==============================================
%%   save REPORT
% ===============================================


if v.report_dosave==1
    % ==============================================
    %%  save AS EXCELFILE (+ EMBEDDED figS)
    % ===============================================
    % ts=plog([],[{'ID' 'Animal' 'R'}; [t1]],0,'sorted R');
%     hd={'ID' 'Animal' 'R', 'missingData'};
%     % f11=fullfile(pwd,'QA_registration.xlsx');
%     t2=t1;
%     t2(find(cell2mat(t1(:,3))==0),4)={'missing data'};
    [~ ,v.report_filename, ~]=fileparts(v.report_filename); %remove extension
    v.report_filename=stradd(v.report_filename,['_' ss.tag '-' ss.metric],2);
    if v.report_addDate==1
        date=regexprep(datestr(now),{' ',':'},{'_' '-'});
        v.report_filename=stradd(v.report_filename,['__' date],2);
    end
    
    if strcmp(v.report_type,'xlsx')
        f11=fullfile(ss.pacheck, [v.report_filename '.xlsx']);
        try; delete(f11); end
        pwrite2excel(f11,ss.sheetname2,hd,[],t2);
        pwrite2excel(f11,ss.sheetname1,hd,[],sortrows(t2,1));
        
        % writetable(table(Time, Data), 'QA_registration.xlsx', 'WriteVariableNames', true)
        
        %save all images (diff y-limits)
        xlswritefig(hf, f11, ss.sheetname1, 'G2');
        
        hb=findobj(gcf,'tag','ylimit');
        hgfeval(get(hb,'callback')); drawnow;
        xlswritefig(hf, f11, ss.sheetname1, 'G23');
        
        hgfeval(get(hb,'callback')); drawnow;
        xlswritefig(hf, f11, ss.sheetname1, 'G44');
        
        hgfeval(get(hb,'callback')); drawnow;
    elseif strcmp(v.report_type,'html')
        % ==============================================
        %%       HTML
        % ===============================================

         f11=fullfile(ss.pacheck, [v.report_filename '.html']);
         % ===============================================
         [pa_htmlmain pa_htmlname]=fileparts(f11);
         warning off;
         pa_htmlsub=fullfile(pa_htmlmain,pa_htmlname);
         mkdir(pa_htmlsub)
         for i=1:3
             fim1=fullfile(pa_htmlsub,['s' num2str(i) '.jpg']);
             hb=findobj(gcf,'tag','ylimit');
             hgfeval(get(hb,'callback')); drawnow;
             print(gcf, fim1,'-djpeg');
         end
         % ===============================================
         u=get(gcf,'userdata');
         tt=u.t2;
         tb1=plog([],[u.hd; sortrows(tt,1)],0,{['<b> ANIMAL-registration ' '(sorting: <mark>index)</mark>' '</b>' ];...
             [' <font color=blue> image : "' u.ss.sourceimg '"'];...
             [' <font color=green> metric: ' u.ss.metric '<font color=black>']});%,'plotlines=0'
         tb2=plog([],[u.hd; sortrows(tt,3)],0,{['<b> ANIMAL-registration ' ['(sorting: <mark>' u.metric '-metric)</mark>' '</b>'] ];...
             [' <font color=blue> image : "' u.ss.sourceimg '"'];...
             [' <font color=green> metric: ' u.ss.metric '<font color=black>']});
         tb1([1 ])={'<hr>'};
         tb2([1 ])={'<hr>'};
         %tb1([5 end ])={'=========================================================================='};
         
         tbx=['<pre>'; tb1; tb2 ;'</pre>'; ];
 
        imgsize=[400 300];
         img={...
             ['<img src="' pa_htmlname '/s1.jpg'  '" alt="Girl in a jacket" width="' num2str(imgsize(1)) '" height="' num2str(imgsize(2)) '">']
             ['<img src="' pa_htmlname '/s2.jpg'  '" alt="Girl in a jacket" width="' num2str(imgsize(1)) '" height="' num2str(imgsize(2)) '">']
             ['<img src="' pa_htmlname '/s3.jpg'  '" alt="Girl in a jacket" width="' num2str(imgsize(1)) '" height="' num2str(imgsize(2)) '">']
             };
   
         lh={'<html>'
             '<head>'
             '<style>'
             'h2{margin-bottom: 0px;}'
             'p{margin-top: 0px;}'
             '</style>'
             '</head>'
             '<body>'
             ['<font color=blue><h2>' 'QA Registration Metric' '</h2></font>']
             ['image:  <mark>'   ss.image ' (' ss.sourceimg ')' '</mark><br>']
             ['metric:  <mark>'  ss.metric                      '</mark><br>']
             ['path :  '   ss.pastudy   '<br>']
             ['date :  '   datestr(now) '<br>']
             };
         le={'</body></html>'};
  
         l=[lh;img; tbx; le];
         htmlfile=f11;
         pwrite2file(htmlfile,l);
         %web(['file:///' htmlfile],'-browser');
         
         %% ===============HTML-eng================================   
    end
    
    
end
disp('  ');
disp('Done!');


if v.report_dosave==1
    showinfo2('show report' ,f11);
end



% ==============================================
%%   subs
% ===============================================
function context_cb(e,e2,task)

u=get(gcf,'userdata');
u.iselected;
t0=sortrows(u.t2,1);
animal=t0(u.iselected,:);
t2=sortrows(u.t2,3);
if strcmp(task,'showmricron_t2')
    f1=fullfile(u.ss.pastudy,'dat',animal{2}, 'AVGT.nii');
    f2=fullfile(u.ss.pastudy,'dat',animal{2}, 'x_t2.nii');
    if exist(f1) && exist(f2)
        rmricron([],f1,f2,0);
    end
elseif strcmp(task,'showmricron_sourceimg')
    f1=fullfile(u.ss.pastudy,'dat',animal{2}, 'AVGT.nii');
    f2=fullfile(u.ss.pastudy,'dat',animal{2}, u.ss.sourceimg);
    if exist(f1) && exist(f2)
        rmricron([],f1,f2,0);
    end
elseif strcmp(task,'clipboardanimal')
    clipboard('copy',animal{2} );
elseif strcmp(task,'explorer')
    explorer(fullfile(u.ss.pastudy,'dat',animal{2}));
elseif strcmp(task,'preselect')
    antcb('selectdirs',animal{2});
elseif strcmp(task,'animatedGif');
    f1=fullfile(u.ss.pastudy,'dat',animal{2},'summary','x_t2_animated.gif');
    if exist(f1)
        web(f1,'-new');
    end
elseif strcmp(task,'animatedGif_best')
    
    f1=fullfile(u.ss.pastudy,'dat',t2{end,2},'summary','x_t2_animated.gif');
    web(f1,'-new');
%     n=5;
%     
%     for i=1:n
%       try;    f1=fullfile(u.ss.pastudy,'dat',t2{i,2},'summary','x_t2_animated.gif');web(f1,'-new');end
%     end
    
end



% m1 = uimenu(c,'Label','show overlay (MRIcron)','Callback',{@context_cb,'showmricron'});
% m2 = uimenu(c,'Label','copy to clipboard animal-name','Callback',{@context_cb,'clipboardanimal'});
% m2 = uimenu(c,'Label','preselect animal in ANT-GUI','Callback',{@context_cb,'preselect'});


function showtable(e1,e2,task)
u=get(gcf,'userdata');
 tt=u.t2;
if task==1
   tt=sortrows(tt,1); 
   ms='(sorting: index)';
else
   ms=['(sorting: ' u.metric '-metric)' ];
end
hd=u.hd;
uhelp(plog([],[hd; tt],0,{['ANIMAL-registration ' ms ];...
    [' #b image : "' u.ss.sourceimg '"'];...
    [' #g metric: ' u.ss.metric ]}),...
    1,'name','QA_registration');

function set_ylimits(e1,e2)

u=get(gcf,'userdata');
t2=u.t2;

 

val1=cell2mat(t2(find(cell2mat(t2(:,3))~=0),3));
val2=cell2mat(t2(:,3));
 
hb=findobj(gcf,'tag','ylimit');
us=get(hb,'userdata');
state=us.state+1;
    
if state==1
    val=val1;
%     w=setdiff(val2,val1);
%     if isempty(w)
% %        val=[0 1]; 
%        set(gca,'ylimmode','auto')
%        hl=findobj(gca,'type','line');
%        d=get(hl,'ydata');
%        dv=cell2mat(d(find(cell2mat(cellfun(@(a){[ length(a)]},d))==1)));
%        val=dv(find(dv~=0));
%     end
    if ~isempty(val)
        ylim([min(val)-.0025 max(val)+.001]);
    end
     set(hb,'backgroundcolor','w');
elseif state==2
%     val=val2;
%     if ~isempty(val)
%         ylim([min(val)-.0025 max(val)+.001]);
%     end
  hl=findobj(gca,'type','line');
       d=get(hl,'ydata');
       dv=cell2mat(d(find(cell2mat(cellfun(@(a){[ length(a)]},d))==1)));
       val=dv(find(dv~=0));
       try
 ylim([min(val)-.0025 max(val)+.001]);
       catch
           set(gca,'ylimmode','auto');
       end
 set(hb,'backgroundcolor','y');
elseif state==3
    set(gca,'ylimmode','auto');
    set(hb,'backgroundcolor',[  0.9294    0.6941    0.1255]);
end

us.state=state;
% us.state
if us.state>=3; us.state=0; end
set(hb,'userdata',us);


function showID(e1,e2,t)
if exist('t')==0
    ms='<b><div style="font-family:impact;color:gray"><center>Click onto a blue dot to see the animal-ID. ' ;
    fs=12;
else
    ix=e1.XData;
    if t{ix,3}~=0
        score= num2str(t{ix,3});
    else
        score='missing data!!!';
    end
    disp([ '[' num2str(t{ix,1})  ']'  ': ' t{ix,2} '  score: ' score    ]);
    
    title([ 'selected animal: '       ],'fontsize',7);
    
    ms=['<center>[' num2str(t{ix,1})  ']'  '&nbsp;&nbsp;&nbsp;' t{ix,2} ' &nbsp;&nbsp;&nbsp;     (' score ')'];
    fs=14;
    us=get(gcf,'userdata');
    us.iselected=ix;
    set(gcf,'userdata',us);
end

us=get(gcf,'userdata');
% if isfield(us,'hs')==0
try
    us.hs=addNote(us.hs,'text',ms);
catch
    us.hs=addNote(gcf,'text',ms,'pos',[.2 .925 .6 .07],'fs',fs);
end
set(gcf,'userdata',us);
%
%
% % ==============================================
% %%   powerpoint
% % ===============================================
% paWork=pwd;
% s.doc='new';
% s.bgcol=[1 1 1]
% paout=fullfile(pwd,'dummy')
% pptfile=fullfile(paout,'klaus2')
% paPPT=fileparts(pptfile)
%
%
% % [pax namex ]=fileparts(pptfile);
%
%
% if strcmp(s.doc,'add') && exist([pptfile,'.pptx'])
%     exportToPPTX('open',[pptfile,'.pptx'])
% else
%     exportToPPTX('new','Dimensions',[12 6], ...
%         'Title','Example Presentation', ...
%         'Author','MatLab', ...
%         'Subject','Automatically generated PPTX file', ...
%         'Comments','This file has been automatically generated by exportToPPTX');
% end
%
%  info=...
%         {
% %         %['Contrast: ' lb.String{lb.Value} ]
% %         ['Contrast: ' mspm.title ]
% %         ['MCP: ' get(findobj(hg,'tag','mcp'),'string')]
% %         ['TR: ' get(findobj(hg,'tag','thresh'),'string')]
% %         ['CLustersize: ' get(findobj(hg,'tag','clustersize'),'string')]
% %         ['DIR: '         foldername]
% %         ['statistic: '         mspm.stat]
%         ['study: '         pwd]
%         };
%
%
% cd(paPPT);
% slideNum = exportToPPTX('addslide','BackgroundColor',s.bgcol);
% fprintf('Added slide %d\n',slideNum);
% exportToPPTX('addpicture',gcf);
% exportToPPTX('addtext','klaus1');
% exportToPPTX('addtext',strjoin(info,char(10)),'FontSize',10,...
%     'Position',[0 1 3 3  ]);
%
% %exportToPPTX('addnote',sprintf('Notes data: slide number %d',slideNum));
% exportToPPTX('addnote',['source: '  pwd ]);
% % =====table==========================================
% ts=plog([],[{'ID' 'Animal' 'R'}; [t1]],0,'sorted R');
%
% slideNum = exportToPPTX('addslide','BackgroundColor',s.bgcol)
% exportToPPTX('addtext',strjoin(ts,char(10)),'FontSize',10,...
%     'Position',[0 1 10 10  ]);
% % ===============================================
%
% newFile = exportToPPTX('saveandclose',pptfile);
% fprintf('New file has been saved: <a href="matlab:open(''%s'')">%s</a>\n',newFile,newFile);
%
% cd(paWork);
%
%
%
%
%
%

function xlswritefig(hFig,filename,sheetname,xlcell)
% XLSWRITEFIG  Write a MATLAB figure to an Excel spreadsheet
%
% xlswritefig(hFig,filename,sheetname,xlcell)
%
% All inputs are optional:
%
%    hFig:      Handle to MATLAB figure.  If empty, current figure is
%                   exported
%    filename   (string) Name of Excel file, including extension.  If not specified, contents will
%                  be opened in a new Excel spreadsheet.
%    sheetname:  Name of sheet to write data to. The default is 'Sheet1'
%                       If specified, a sheet with the specified name must
%                       exist
%    xlcell:     Designation of cell to indicate the upper-left corner of
%                  the figure (e.g. 'D2').  Default = 'A1'
%
% Requirements: Must have Microsoft Excel installed.  Microsoft Windows
% only.
%
% Ex:
% Paste the current figure into a new Excel spreadsheet which is left open.
%         plot(rand(10,1))
%         drawnow    % Maybe overkill, but ensures plot is drawn first
%         xlswritefig
%
% Specify all options.
%         hFig = figure;
%         surf(peaks)
%         xlswritefig(hFig,'MyNewFile.xlsx','Sheet2','D4')
%         winopen('MyNewFile.xlsx')
% Michelle Hirsch
% The MathWorks
% mhirsch@mathworks.com
%
% Is this function useful?  Drop me a line to let me know!
if nargin==0 || isempty(hFig)
    hFig = gcf;
end
if nargin<2 || isempty(filename)
    filename ='';
    dontsave = true;
else
    dontsave = false;
    
    % Create full file name with path
    filename = fullfilename(filename);
end
if nargin < 3 || isempty(sheetname)
    sheetname = 'Sheet1';
end;
if nargin<4
    xlcell = 'A1';
end
% Put figure in clipboard
if ~verLessThan('matlab','9.8')
    copygraphics(hFig)
else
    % For older releases, use hgexport. Set renderer to painters to make
    % sure it looks right.
    r = get(hFig,'Renderer');
    set(hFig,'Renderer','Painters')
    drawnow
    hgexport(hFig,'-clipboard')
    set(hFig,'Renderer',r)
end
% Open Excel, add workbook, change active worksheet,
% get/put array, save.
% First, open an Excel Server.
Excel = actxserver('Excel.Application');
% Two cases:
% * Open a new workbook, save with given file name
% * Open an existing workbook
if exist(filename,'file')==0
    % The following case if file does not exist (Creating New File)
    op = invoke(Excel.Workbooks,'Add');
    %     invoke(op, 'SaveAs', [pwd filesep filename]);
    new=1;
else
    % The following case if file does exist (Opening File)
    %     disp(['Opening Excel File ...(' filename ')']);
    op = invoke(Excel.Workbooks, 'open', filename);
    new=0;
end
% set(Excel, 'Visible', 0);
% Make the specified sheet active.
try
    Sheets = Excel.ActiveWorkBook.Sheets;
    target_sheet = get(Sheets, 'Item', sheetname);
catch %#ok<CTCH>   Suppress so that this function works in releases without MException
    % Add the sheet if it doesn't exist
    target_sheet = Excel.ActiveWorkBook.Worksheets.Add();
    target_sheet.Name = sheetname;
end;
invoke(target_sheet, 'Activate');
Activesheet = Excel.Activesheet;
% Paste to specified cell
Paste(Activesheet,get(Activesheet,'Range',xlcell,xlcell))
% Save and clean up
if new && ~dontsave
    invoke(op, 'SaveAs', filename);
elseif ~new
    invoke(op, 'Save');
else  % New, but don't save
    set(Excel, 'Visible', 1);
    return  % Bail out before quitting Excel
end
invoke(Excel, 'Quit');
delete(Excel)
% end
function filename = fullfilename(filename)
[filepath, filename, fileext] = fileparts(filename);
if isempty(filepath)
    filepath = pwd;
end
if isempty(fileext)
    fileext = '.xlsx';
end
filename = fullfile(filepath, [filename fileext]);
% end



function n=hist2(A,B,L) 
%HIST2 Calculates the joint histogram of two images or signals
%
%   n=hist2(A,B,L) is the joint histogram of matrices A and B, using L
%   bins for each matrix.
%
%   See also MI, HIST.

%   jfd, 15-11-2006, working
%        27-11-2006, memory usage reduced (sub2ind)
%        22-10-2008, added support for 1D matrices
%        01-09-2009, commented specific code for sensorimotor signals
%        24-08-2011, speed improvements by Andrew Hill

ma=min(A(:)); 
MA=max(A(:)); 
mb=min(B(:)); 
MB=max(B(:));

% For sensorimotor variables, in [-pi,pi] 
% ma=-pi; 
% MA=pi; 
% mb=-pi; 
% MB=pi;

% Scale and round to fit in {0,...,L-1} 
A=round((A-ma)*(L-1)/(MA-ma+eps)); 
B=round((B-mb)*(L-1)/(MB-mb+eps)); 
n=zeros(L); 
x=0:L-1; 
for i=0:L-1 
    n(i+1,:) = histc(B(A==i),x,1); 
end


function I=mi(A,B,varargin) 
%MI Determines the mutual information of two images or signals
%
%   I=mi(A,B)   Mutual information of A and B, using 256 bins for
%   histograms
%   I=mi(A,B,L) Mutual information of A and B, using L bins for histograms
%
%   Assumption: 0*log(0)=0
%
%   See also ENTROPY.

%   jfd, 15-11-2006
%        01-09-2009, added case of non-double images
%        24-08-2011, speed improvements by Andrew Hill

if nargin>=3
    L=varargin{1};
else
    L=256;
end

A=double(A); 
B=double(B); 
     
na = hist(A(:),L); 
na = na/sum(na);

nb = hist(B(:),L); 
nb = nb/sum(nb);

n2 = hist2(A,B,L); 
n2 = n2/sum(n2(:));

I=sum(minf(n2,na'*nb)); 

% -----------------------

function y=minf(pab,papb)

I=find(papb(:)>1e-12 & pab(:)>1e-12); % function support 
y=pab(I).*log2(pab(I)./papb(I));



