
%% #ko MASK-GENERATOR (create masks using an anatomical atlas)
%
%% #by STRUCT PARAMETERS
% atlas     : select atlas
%            - 'ANO.nii'  -the local atlas "ANO.nii" is used from template-path
%              of the actual study (default)
%            - atlernative: use UI to select another Atlas
% labelID   : one/more Ids from Atlas (numeric IDS as array)
%          -example: id of Caudoputamen in allenAtlas is 672 (compare webside
%           "http://atlas.brain-map.org/atlas?atlas=1", ..
%          - if a region is selected on the webside, the link contains the ID
%            after "structure.." )
% hemisphere: specifies hemispheric information
%             (1): use left hemisphere only
%             (2): use right hemisphere only
%             (3): use both hemispheres united
%             (4): use both hemispheres separated
% merge    : merge regions (0|1)    (only if several regions were selected)
%             0: do not merge:   IDs are not be merged
%             1: merge: regions will be merged (all regions get ID "1" or
%             "1"/"2" depending on the hemisphere parameter:
%                - If the hemisphere paramter is 1,2 or 3 the merged regions
%                   obtain the ID "1".
%                - If the hemisphere paramter is 4, the merged regions obtain
%                  the ID "1" for the left, and "2" fot the right hemisphere.
% saveas    : string used for the output name of the mask volume (*.nii)
%             and the corresponding textfile
%  The output (nii+txt file) is saved in the folder of the used atlas.
%  Accordingly, for "ANO.nii" the output is in the studie's template folder.
%
%_____________________________________________________________________________
%% #by calling function
%  xmaskgenerator(1,z)    ;%%run this function in (0)silent or (1) GUI -mode
%
%_____________________________________________________________________________
%% #by EXAMPLE BATCH
% z=[];
% z.atlas      = 'ANO.nii';              % % ANO.nii is used as atlas
% z.labelID    = [549  672  698];        % % select anatomical LABELS (IDs)
% z.hemisphere = [4];                    % % HEMISPHERE: define mask & relation to hemisphere
% z.merge      = [0];                    % % MERGE IDs: (1) merge IDs, (0) preserve IDs
% z.saveas     = 'dummy.nii';            % % FILENAME string of the output file
% xmaskgenerator(1,z);                   % % run function with open gui

%_______________________________________________________________________________________________
%% #wb History: type anth in comand window




function xmaskgenerator2(showgui, x)




clear global atl
fprintf('..reading standard atlas..wait..');
prepatatlas('ANO.nii');
fprintf('done\n');





%———————————————————————————————————————————————
%%   GUI
%———————————————————————————————————————————————
if exist('showgui')~=1;    showgui=1; end
if exist('x')      ~=1;    x=[];      end
if isempty(x);             showgui=1; end

p={...
    'inf1'      '*** MASK-GENERATOR                '         '' ''
    'inf2'      ['[' mfilename ']']                         '' ''
    'inf3'     '==================================='        '' ''
    'atlas'     'ANO.nii'      'select ATLAS here (ANO.nii is the default atlas)'   {  @selectatlas}
    'labelID'    ''            'select anatomical LABELS (IDs) '   {  @selectlabels}
    'hemisphere'   '(3) both united'    'HEMISPHERE: define mask & relation to hemisphere' {'(1) left','(2) right','(3) both united' '(4) both separated '}
    'merge'        1                    'MERGE IDs: (1) merge IDs, (0) preserve IDs'                       'b'
    'saveas'     'dummyMask'            'FILENAME string of the output file (..stored in the "templates" folder"'                       'f'
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    [m z]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.5 .5 .4 .2 ],'title','MASK-GENERATOR');
    if isempty(m);return; end
else
    z=param2struct(p);
end

%% ________________________________________________________________________________________________


fprintf('....wait..\n');
prepatatlas(z.atlas); %prepare data if gui is/isnot not used
global atl
ix=find(ismember([atl.tb{:,4}],z.labelID));
showx(ix); %fill selected regions
global atl


sel     =reshape(atl.selected,size(atl.ano)); %get filled regions
atlasID =cell2mat(atl.tb(ix,4));
lab     =atl.tb(ix,1);


global an

% ==============================================
%%   hemisphere
% ===============================================

if ~isnumeric(z.hemisphere)
    z.hemisphere=str2num(z.hemisphere(regexpi(z.hemisphere,'\d')));
end



% msk = mxm.mask;
% lab = mxm.masklabels;

%% make labelinfo
lax  = [ num2cell(1:length(atlasID))'  lab num2cell(atlasID(:))  ];
hemi = atl.hemi;
img  = sel;


if z.merge==1
    img=(img>0);
    lax(:,1)={1};
    mergestr='m1';
else
    mergestr='m0';
end


if z.hemisphere==1;
    img=(img.*(hemi==1));
    hemistr='hL'; %left HEMISPHERE
elseif z.hemisphere==2;
    img=(img.*(hemi==2));
    hemistr='hR'; %right HEMISPHERE
elseif z.hemisphere==3
    hemistr='hB'; %botj Hemispheres
elseif z.hemisphere==4;   %both HEMISPHERES SEPARATED
    dum1 = (img.*(hemi==1));
    mx=max(dum1(:))
    dum2 = (img.*(hemi==2))+mx;
    dum2(dum2==mx)=0;
    img=dum1+dum2;
    
    laxLe=lax;
    laxLe(:,2)=cellfun(@(a){[ 'L ' a]}, laxLe(:,2));
    
    laxRi=lax;
    laxRi(:,2)=cellfun(@(a){[ 'R ' a]}, laxRi(:,2));
    
    if z.merge==0
        lax=[laxLe;laxRi];
        lax(:,1)=num2cell(1:size(lax,1));
    else
        laxRi=[ repmat({2},[size(laxRi,1) 1])  [laxRi(:,2:3 )]];
        lax=[laxLe;laxRi];
    end
    
    hemistr='hBS';
end

%% ________________________________________________________________________________________________
% ==============================================
%%   save
% ===============================================
paout  =fileparts(atl.atlas);
outstr =regexprep(z.saveas,'\..*','');

hd   =atl.hhemi;
% hd=rmfield(hd,{'pinfo' 'private'});
fiout=fullfile(paout,[outstr ['_' mergestr '_' hemistr ] '.nii']);
rsavenii(fiout,hd,(img),[2 0]);





%% write info;
fioutinfo=fullfile(paout,[outstr  ['_' mergestr '_' hemistr ] '.txt']);
for i=1:size(lax,1)
    labx{i,1}=[ sprintf('%4d\t',lax{i,1})   lax{i,2}  sprintf('\t%4d\t',lax{i,3})  ];
end
pwrite2file2(fioutinfo,labx,[]);


showinfo2( 'mask-volume '  ,atl.havgt.fname,fiout,'13');
showinfo2( 'mask-info   '  ,fioutinfo);


% ==============================================
%%   batch
% ===============================================

xmakebatch(z,p, mfilename);





%% ________________________________________________________________________________________________
function he= selectatlas(e,e2)
he=[];
do=1;
while do==1
    inputOptions={'ANO.nii', 'select another atlas', 'Help', 'Cancel'};
    defSelection=inputOptions{1};
    isel=bttnChoiseDialog(inputOptions, 'select atlas volume' ,defSelection, 'Select Atlas');
    drawnow;
    if isel==2
        [t,sts] = spm_select(1,'any','select atlas image (*.nii)','',pwd,'.*.nii','');
        if t==0; he='ANO.nii';
        else
            he=cellstr(t);
        end
        do=0;
    elseif isel==3
        uhelp([mfilename '.m']);
    else
        he='ANO.nii';
        do=0;
    end
end
%% ________________________________________________________________________________________________

function selectlabels(e,e2)
% he=[];


[s ss]=paramgui('getdata');
global atl
global an
s1=fullfile(fileparts(an.datpath),'templates',ss.atlas);
s2=atl.atlas;
if strcmp(s1,s2)==0
    pop_prepatatlas;
    disp('loading atlas' );
end




global atl
% lenlab=size(char(atl.tb(:,1)),2)
% labs=cellfun(@(a,col){[...
%     '<style="background-color:#'  col '"><font size="6">'...
%     a repmat('&nbsp',[1 lenlab-length(a)])   ...
%     ]}, atl.tb(:,1),atl.tb(:,2)  );
% %
% % colbg=cellfun(@(col){[...
% %     '<style="background-color:#'  col '"><font size="6">' repmat('&nbsp',[1 5])   ...
% %     ]}, atl.tb(:,2)  );
%
%
% ['<style bgcolor=#ffff00><font size="5">ddd']

lenlab=size(char(atl.tb(:,1)),2);
% labs=cellfun(@(a,col){[...
%     ['<style bgcolor=#' col '><font size="6">' repmat('&nbsp ',[1 1]) a  repmat('&nbsp ',[1 lenlab-length(a)]) ]...
%     ]}, atl.tb(:,1),atl.tb(:,2)  );

labs=cellfun(@(a,col){[...
    ['<style bgcolor=#' col '><font weight="normal">' repmat('&nbsp ',[1 1]) a  repmat('&nbsp ',[1 lenlab-length(a)]) ]...
    ]}, atl.tb(:,1),atl.tb(:,2)  );

% labs=atl.tb(:,1);
id=cellfun(@(a){ num2str(a) },atl.tb(:,4));
tb=[id  labs]; tbh={'ID'   'label'};
ix = selector2(tb,tbh,'selfun',{@showx},'iswait',1,'position',[0.0778  0.0772  0.4  0.8644]);

% ix=showlist();
try; close(11); end
% try; delete(findobj(gcf,'tag','selector')); end


ix=ix(:)';
figure(findobj(gcf,'tag','paramgui'));
if length(ix)==1 && (ix==-1)
    [s ss]=paramgui('getdata');
    %    he=ss.labelID;
    paramgui('setdata','x.labelID',ss.labelID);
else
    id=cell2mat(atl.tb(ix,4));
    %he=id(:)';
    paramgui('setdata','x.labelID',id(:)');
end

return




%% ________________________________________________________________________________________________

function pop_prepatatlas
[s ss]=paramgui('getdata');
atlas=ss.atlas;
if isempty(atlas); error('no atlas selected: select atlas first'); end
prepatatlas(atlas);

%% ________________________________________________________________________________________________
function prepatatlas(atlas)

atlas=char(atlas);

global atl
[pa fi ext]=fileparts(atlas);
if isempty(pa)
    global an
    atl.atlas=fullfile(fileparts(an.datpath),'templates','ANO.nii');
else
    atl.atlas=char(atlas);
end
[pa fi ext]=fileparts(atl.atlas);


atl.atlastable=fullfile(pa,[fi '.xlsx']);
atl.hemi      =fullfile(pa,['AVGThemi.nii']);
atl.avgt      =fullfile(pa,['AVGT.nii']);

%% read atlastable
[~,~,a]=xlsread(atl.atlastable);
a(regexpi2(cellfun(@(a){ num2str(a) }, a(:,1)  ),'NaN'),:)=[]; %del empty ROWS
a(:,regexpi2(cellfun(@(a){ num2str(a) }, a(1,:)  ),'NaN'))=[]; %del empty COLS


% remove FIB if exist
if size(a,1)==1206
    ifib=min(regexpi2(a(:,1),'fiber tracts'));
    if ~isempty(ifib)
        a=a(1:ifib-1,:); %remove FIB atlas
    end
    
end

he=a(1,:);
a=a(2:end,:);
a=cellfun(@(a){ num2str(a) }, a  ); %to string

% check colors
inohex=regexpi2(a(:,2),'NaN');
inoRGB=regexpi2(a(:,3),'NaN');
colst=[1 1];
if size(a,1)==length(inohex);     colst(1)=0; end
if size(a,1)==length(inoRGB);     colst(2)=0; end

if sum(colst)==0 ;% no colors defined
    a(:,3)=repmat({'255 255 255'},[size(a,1) 1]);
    t=str2num(char(a(:,3)));
    t2=[dec2hex(t(:,1)) dec2hex(t(:,2)) dec2hex(t(:,3))];
    a(:,2)=cellstr(t2);
elseif colst(1)==0 %no hex
    t=str2num(char(a(:,3)));
    t2=[dec2hex(t(:,1)) dec2hex(t(:,2)) dec2hex(t(:,3))];
    a(:,2)=cellstr(t2);
elseif colst(2)==0    %noRGB
    t=(char(a(:,2))) ;
    t2=[hex2dec(t(:,1:2)) hex2dec(t(:,3:4)) hex2dec(t(:,5:6))];
    a(:,3)=cellstr(num2str(t2));
end

a(:,4)=cellfun(@(a){ str2num(a) }, a(:,4)  ); %ID to numeric
a(:,5)=cellfun(@(a){ str2num(a) }, a(:,5)  ); %children to numeric
tb=a;

atl.tb=tb;
[atl.hano  atl.ano  ]  =rgetnii(atl.atlas);  %atlas
[atl.hhemi atl.hemi ]  =rgetnii(atl.hemi);   %hemo mask
[atl.havgt atl.avgt ]  =rgetnii(atl.avgt);   %hemo mask

%% make RGB COLUME
atl.anoRGB =rgbvolume(atl.ano,tb);%build RGB volume buildColLabeling2


%% ________________________________________________________________________________________________
function v3rgb =rgbvolume(ANO,tb)%buildColLabeling2
ANO(isnan(ANO)) = 0;
id=cell2mat(tb(:,4));
I = sparse([id]+1,ones(size(tb,1),1),1:size(tb,1));
cmap=str2num(char(tb(:,3)));
cmap = [0 0 0 ; cmap]/255;
try                            %% ANO has no more IDs than in table
    w = full(I(ANO+1));
catch                          %% ANO has    more IDs than in table
    si=size(ANO);
    ano2=ANO(:);
    uni=unique(ano2);
    dif=setdiff(uni,[0; id]);
    for i=1:length(dif)
        ano2(ano2==dif(i)) =0;
    end
    ANO2=reshape(ano2,si);
    w = full(I(ANO2+1));
end

v3rgb = reshape(cmap(w+1,:),[size(ANO) 3]);
%% ________________________________________________________________________________________________



%———————————————————————————————————————————————
%%   show volume
%———————————————————————————————————————————————

function showx(idx)

if exist('idx')~=1
    us=get(gcf,'userdata');
    id0=find(us.sel);
    idx=str2num(char(us.raw(id0,1)));
    %fprintf('wait..');
end


% ==============================================
%%   bla
% ===============================================
global atl

% BACKGROUND
G = atl.avgt;
C = colormap(gray);  % Get the figure's colormap.
L = size(C,1);
Gs = round(interp1(linspace(min(G(:)),max(G(:)),L),1:L,G));
H = reshape(C(Gs,:),[size(Gs) 3]); % Make RGB image from scaled.

si  =size(atl.avgt);
atl.a2  =reshape(atl.ano,[prod(si(1:3)) 1]); %ANO-2d
atl.h2  =reshape(H,[prod(si(1:3)) 3]);     ; %AVGT-2d RGB
atl.c2  =reshape(atl.anoRGB,[prod(si(1:3)) 3]);%ANO-2d RGB ALL

atl.selected  =zeros(size(atl.a2)); %ANO-2d selected

%-------------------montage of ano to get ID for mousePointer ---
ff=atl.a2;
f4=rot90(permute(reshape(ff,[si [1] ]),[1 3 2 4]));
atl.anomontage=montageout(permute(f4(:,:,:,1),[1 2 4 3]));

%----------------------------------

atl.s2  =atl.h2  ;       % ANO-2d RGB SELECTION of regions RESET TO BG-image



%% slow version 
% tic
% logs={''};
% logs(end+1,1)={['<HTML><FONT color="Maroon"><b>' 'SELECTED REGIONS' '</FONT></HTML>']};
% for i=1:length(idx)
%     idthis=idx(i);
%     id=atl.tb{idthis,4};
%     ch=atl.tb{idthis,5};
%     idall=[id;ch(:)];
%     idall(isnan(idall))=[];
%     idall=sort(idall);
%     
%     ico = ismember(atl.a2, idall);
%     ix=find(ico>0);
%     %     logs(end+1,1)={[ num2str(i) ') ' atl.tb{idthis,1}  ' [' num2str(id) ']']};
%     
%     logs(end+1,1)= {['<HTML><FONT color="grey">' num2str(i)  ') <FONT color="blue"><b>' atl.tb{idthis,1}  ' [' num2str(id) ']'  '</FONT></HTML>']};
%     logs(end+1,1)={['   Childs: '  regexprep(num2str(ch(:)'),'\s+', ',') ]};
%     if length(ix)>0
%         %logs(end+1,1)={['    Nvox  : '  num2str(length(ix))]};
%         logs(end+1,1)= {['<HTML><FONT color="green">'  '&nbsp;&nbsp;&nbsp;'  'Nvox  : '  num2str(length(ix))  '</FONT></HTML>']};
%     else
%         logs(end+1,1)= {['<HTML><FONT color="red">'    '&nbsp;&nbsp;&nbsp;'   'Nvox  : '  num2str(length(ix))  '</FONT></HTML>']};
%     end
%     
%     atl.s2(ix,1)=atl.c2(ix,1);
%     atl.s2(ix,2)=atl.c2(ix,2);
%     atl.s2(ix,3)=atl.c2(ix,3);
%     atl.selected(ix,1)=i;
% end
% if size(logs,1)==2; %EMPTY MSG
%     logs(end+1,1)= {['<HTML><FONT color="Orange">' '   EMPTY..no regions selected- '   '</FONT></HTML>']};
% end
% toc
%% end


%% faster version 
% tic
logs={''};
logs(end+1,1)={['<HTML><FONT color="Maroon"><b>' 'SELECTED REGIONS' '</FONT></HTML>']};

AT=atl.a2;
inozero=find(AT>0);
AT=AT(inozero);
for i=1:length(idx)
    idthis=idx(i);
    id=atl.tb{idthis,4};
    ch=atl.tb{idthis,5};
    idall=[id;ch(:)];
    idall(isnan(idall))=[];
    idall=sort(idall);
    
%     ico = ismember(atl.a2, idall);
%     ix=find(ico>0);
%     length(ix)
    
    ico2 = ismember(AT, idall);
%     %ix2   =inozero(ico2);
%     length(ix2)
%     sum(abs(ix-ix2))
    ix   =inozero(ico2);

    

    %     logs(end+1,1)={[ num2str(i) ') ' atl.tb{idthis,1}  ' [' num2str(id) ']']};
    
    logs(end+1,1)= {['<HTML><FONT color="grey">' num2str(i)  ') <FONT color="blue"><b>' atl.tb{idthis,1}  ' [' num2str(id) ']'  '</FONT></HTML>']};
    logs(end+1,1)={['   Childs: '  regexprep(num2str(ch(:)'),'\s+', ',') ]};
    if length(ix)>0
        %logs(end+1,1)={['    Nvox  : '  num2str(length(ix))]};
        logs(end+1,1)= {['<HTML><FONT color="green">'  '&nbsp;&nbsp;&nbsp;'  'Nvox  : '  num2str(length(ix))  '</FONT></HTML>']};
    else
        logs(end+1,1)= {['<HTML><FONT color="red">'    '&nbsp;&nbsp;&nbsp;'   'Nvox  : '  num2str(length(ix))  '</FONT></HTML>']};
    end
    
    atl.s2(ix,1)=atl.c2(ix,1);
    atl.s2(ix,2)=atl.c2(ix,2);
    atl.s2(ix,3)=atl.c2(ix,3);
    atl.selected(ix,1)=i;
end
if size(logs,1)==2; %EMPTY MSG
    logs(end+1,1)= {['<HTML><FONT color="Orange">' '   EMPTY..no regions selected- '   '</FONT></HTML>']};
end
% toc

%% end











% -------------------------------
ff=atl.s2;
f4=rot90(permute(reshape(ff,[si 3 ]),[1 3 2 4]));
% f5=[];
f5(:,:,1) = montageout(permute(f4(:,:,:,1),[1 2 4 3]));
f5(:,:,2) = montageout(permute(f4(:,:,:,2),[1 2 4 3]));
f5(:,:,3) = montageout(permute(f4(:,:,:,3),[1 2 4 3]));

% return
if isempty(findobj(0,'tag','maskimg'))
    figure(11);
    set(gcf,'tag','maskimg','color','k','units','norm',...
        'position',[ 0.4309    0.3994    0.3889    0.4667],...
        'NumberTitle','off');
    

    h = uitabgroup; drawnow;
    t1 = uitab(h, 'title', 'REGIONS','ButtonDownFcn',{@tab,1});
    a = axes('parent', t1); surf(peaks);

    
    im=image(f5);
    set(im,'tag','mask');
    axis image
    set(gcf,'WindowButtonMotionFcn',@figmotion);
    set(gcf,'units','normalized'); set(gca,'position',[0 0 1 1]);
    set(gcf,'menubar','none');
    set(gcf,'toolbar','figure');
    axis off;
    
    %% courcour
    cr=[...
        NaN    1       1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        1     2       2     1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        1     2       2     1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   1       1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN
        NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN];
    set(gcf,'Pointer','custom');
    set(gcf,'PointerShapeCData',cr);
    
    t2 = uitab(h, 'title', 'LABELS','ButtonDownFcn',{@tab,2});
    hv=uicontrol(t2, 'style','listbox','units','normalized','position',[0 0 1 1]);
    set(hv,'tag','lbmaskgen','string',logs,'value',1);
     c = uicontextmenu;
     m1 = uimenu(c,'Label','show selected region online -Browser (Allen Mouse Atlas only)','Callback',{@showWEB,1});
     m2 = uimenu(c,'Label','show selected region online -MATLAB Browser (Allen Mouse Atlas only)','Callback',{@showWEB,2});
    set(hv,'UIContextMenu',c)
    
else
    im=findobj(0,'tag','mask');
    set(im,'cdata',single(f5));
   set( findobj(0,'tag','lbmaskgen')    ,'string',logs,'value',1);
end

function tab(e,e2,arg)
if arg==1
    set(gcf,'WindowButtonMotionFcn',@figmotion);
else
    set(gcf,'WindowButtonMotionFcn',[]);
    set(gcf,'name','go to contextmenu to compare with ALLEN ATLAS online');
end

function showWEB(e,e2,arg)
hl=findobj(0,'tag','lbmaskgen');
li=get(hl,'string');
va=get(hl,'value');

try
    in=0;
    do=1;
    while do==1
        va2=va+in;
        str=li{va2};
        if isempty(regexpi(str,'>\d+)'));
            in=in-1;
        else
            do=0;
        end
    end
    str=li{va2};
    id=char(regexprep(regexpi(str,'\[\d+\]','match'),{'[',']'},{''}));
    
    html=['http://atlas.brain-map.org/atlas#atlas=1&plate=100960301&structure=' id '&x=5279.875&y=3743.875&zoom=-3&resolution=16.75&z=6'];
    if arg==1
        web(html,'-browser') ;
    else
        web(html);web(html);
    end
end
% ________________________________________________________________________________________________
function figmotion(h,e)
try
    pos=get(gca,'CurrentPoint');
    pos=round(pos(1,1:2));
    pos=fliplr(pos);
    d= (get(findobj(gcf, 'type','image'),'cdata'));;
    if (pos(1)>0 && pos(1)<=size(d,1)) &&  (pos(2)>0 && pos(2)<=size(d,2))
        global atl
        id=atl.anomontage(pos(1),pos(2));
        if id==0; return; end
        label=atl.tb{find([atl.tb{:,4}]==id),1};
        
        %         return
        %         msg=['   '  mxm.idlabel{mxm.idvol2(pos(1),pos(2))}];
        %         msg2=sprintf('#VoxMsk=%i ',(length(find(mxm.mask(:)>0))));
        if isempty(label); return; end
        msg=[{label};{['ID: ' num2str(id)]}];
        msg2=[['ID: ' num2str(id) ' ' label] ];
        
        mn=[pos(2) pos(1)];
        te=findobj(gcf,'tag','posmagn');
        if isempty(te)
            te=text(mn(1), mn(2),msg ,'tag','posmagn' ,'color','w');
            set(te,'fontsize',6,'color','w','fontname','courier','fontweight','bold',...
                'verticalalignment','center','horizontalalignment','left',...
                'hittest','off');
        else
            set(te,'position',[mn(1), mn(2) .1 ]);
        end
        set(te,'string',msg);
        %disp([ '[' msg{2}   ']' msg{1}]);
        set(gcf,'name',[ '[' msg{2}   '] ' msg{1}]); drawnow
    end
end
return