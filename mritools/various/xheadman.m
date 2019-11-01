%% #yk image header manipulation: main gui (this gui is called via xheadmanfiles)
% #r  IMAGE SET: 
% - the ["set-num/num"] string (middle-top) displays the current set from n-selected sets 
% - there exist n-sets if a source image from n folders were selected previously
% - there exist also n-sets if for n-selected source images, there is a acorresponding reference image 
%   and optional correponding apply images   
%   Example: There exist two sets if the images 'S.nii' (source), 't2.nii' (reference), 
%   'A1.nii' (applyimage) and 'A2.nii'(applyimage)  were selected for each folder 'M1' and 'M2' 
% - you can hover over the  ["set-num/num"] string to examine the current set's source image (and
%   if selected, the reference image and apply image(s))
% -use green arrows to change the set
%% #by CONTROLS
% #g [FILE INFORMATION] of the current set (top part)
% - The left and right panel depict the image name, header information, the transformation parameter matrix (left matrix)
%   and orthogonal transformation parameters (right matrix) fro the SOURCE and REFERENCE, respectively
% - disentagled Parameter Matrix displays [Tra]..translation, [Rot]..rotation, [Vox]..voxel size and [Sca] scaling
% #g [APPLY MAT] matrices
% -the transformation parameter matrix (left) and  orthogonal parameter matrix (right matrix) can be modified
%  Examples: 
%   - mouse is 1/20th in size: --> set voxelsize to 1/20 --> set each [vox]-element in orthogonal parameter matrix (right matrix)  to 1/20
%   - shift x-dimenension by 4 units --> set 1st [Tra] element in orthogonal parameter matrix to 4  
% #g [reset matrix] #k resets the [APPLY MAT]-matrices
% #g [show overlay] #k displayes the overlay of source/source or source/reference (if reference exists)
%   -You can translate and rotate the source image in the overlay figure. 
%   -Any rigid parameter changes from the overlay figure will be displaed in the [APPLY MAT] matrices.
% #r ============================================================================================================        
% #r RADIO BUTTONS
% #g [apply mat]     #k if selected, apply the [apply mat] matrix to all sources and apply images of all (!!) sets
% #g [use reference] #k if selected, than explicitly use the reference
% #g [remove flips]  #k if selected, remove flips (L/R swaps) from the image
% #g [replace HDR]   #k if selected, the header of the source image and all apply image will be replaced
% #k                    by the header of the reference image
% #g [center origin] #k if selected, centers each image to it's geometrical center (This is image specific!).
% #g [interactive]   #k if selected, shows an interactive overlay of source/source or source/reference (if reference exists)
% #k                    -Any parameter changes from this overlay  will be applied to the source image and all 
% #k                     other apply images of the set
% #g [show final image] #k same as [interactive] but at the very end of all header manipulation steps (i.e. also after resizing)
% #g [resize]        #k if selected, resizes the image ..see below..
% #g [run all sets]  #k if selected the [RUN]-button will execute the header manipulation for all sets
% #k                     - otherwise header manuipulation is done only for the current set
% #r ============================================================================================================        
% #r RESIZE OPTIONS (radio [resize] must be selected)
%  -from pulldown menu select (a) 'to reference'         ..to reslice to reference
%                             (b) 'to source + edit'     ..to reslice to source but make some changes 
%                             (c) 'to reference + edit'  ..to reslice to reference but make some changes
%  * for (a) you can only change the interpolation: {auto,0,1}:
%                 [auto] autodetect interpolation, [0] next neighbour [1] trilinear interpolation
%  * for (b) and (c) you can change: 
%        - the lower and upper bounding box (termed here: BB1 and BB2)
%        - either the voxel size or the dim-parameter
%        - the interpolation: ..see (a)
%      #b  [UIP] use imput parameter  *****  
%       - use the [UIP] radio icon with care !!!
%       - if a parameter's [UIP] (use imput parameter) is selected than the input image parameter is used,
%         otherwise the data from the corresponding edit field is used for all images !!!
%       - EXAMPLE: -The task is to change the voxelsize to [.1 .1 .1]: 
%                  -Solution: deselect the [UIP] for the [vox] paramter, enter [.1 .1 .1] in the[vox] paramter edit field. 
%                  -The [UIP]s from all other parameters must be set to 'true'
% #r ============================================================================================================        
% #r OTHERS
% #g [data type]     #k choose the data type. If source is used the datatype won't change
% #g [prefix]        #k enter a prefix (default is 'h') that will be prepend to the output image name
%                      -it is recommended to define a prefix
%                      -if empty the input file (source/apply image) file will be overwritten and is lost !!
% #g [RUN]           #k hit [RUN] button to do the header manipulation for all images of the current set
%                      - Note: if radio [run all sets] was selected, all sets will be processed by hitting the [RUN] button



function xheadman(task,pars)

% if 0
%     p.img= { 'O:\harms1\harms3_lesionfill_20stack\dat\s20150908_FK_C1M04_1_3_1_1\_msk.nii'
%         'O:\harms1\harms3_lesionfill_20stack\dat\s20150909_FK_C2M06_1_3_1_1\_msk.nii'}
%     xheadman2('setimage',p)
%     
% end


% delete(findobj(0,'tag','headman2'))
hf=(findobj(0,'tag','headman'));
if isempty(hf)
    makefig();
end

if exist('task')
    figure(findobj(0,'tag','headman'))
    if strcmp(task,'setimage')
        u=get(gcf,'userdata');
        %         u.img=pars.img;
        set(gcf,'userdata',u);
        
        set(u.sv3,'string','');
        set(u.sm3,'string','');
        set(findobj(gcf,'tag','iref'),'string','REFERENCE:-');
        set(findobj(gcf,'tag','iref_info'),'string','..');
        set(u.rm1,'string','');
        set(u.rv1,'string','');
        
        setimages(pars);
        checkgui
        
        
    end
    
end

function checkgui(e,e2)
u=get(gcf,'userdata');
if size(u.img,1)==1
    set(findobj(gcf,'tag','useref'),'enable','off','value',0);
    set(findobj(gcf,'tag','rb_replacehdr'),'enable','off');
    
    set(findobj(gcf,'tag','resl_resize2what'),'value',2,'enable','off');
    hgfeval(get(  findobj(gcf,'tag','resl_resize2what')   ,'callback'));
    
else
       set(findobj(gcf,'tag','useref'),'enable','on') ;
    %     set(findobj(gcf,'tag','resl_resize2what'),'value',1,'enable','on');
       set(findobj(gcf,'tag','rb_replacehdr'),'enable','on');
end




function nextset(e,e2,arg)
pars.nextset=arg;
setimages(pars);
checkgui;

function setimages(pars)
u=get(gcf,'userdata');
if isfield(pars,'nextset')
    if isnumeric(pars.nextset)
        if u.n+pars.nextset ==0; return ;end
        if u.n+pars.nextset>size(u.list,1) return ;end
        u.n=u.n+pars.nextset;
        %set(findobj(gcf,'tag','setnumber'),'string', ['set-' num2str(u.n) '/' num2str(size(u.list,1))] );
    else
        %% specific set is chosen
        setnum=str2num(pars.nextset);
        if setnum>size(u.list,1); return; end
        if setnum<1; return   ; end
        u.n=setnum;
        
        
    end
    u.img={};
    u.img{1,1}=u.list{u.n,1};
    if ~isempty(u.list{u.n,2});  u.img{2,1}=u.list{u.n,2}; end
    
    %f1=u.img{1};
    
else
    hinfo=findobj(gcf,'tag','info');
    set(hinfo,'string',{' '});
    
    u.n=1;
    %set(findobj(gcf,'tag','setnumber'),'string', ['set-' num2str(u.n)] );
    fn=fieldnames(pars);
    for i=1:length(fn)
        u= setfield(u,fn{i},    getfield(pars,fn{i}) );
    end
    
    u.img={};
    u.img{1,1}=u.list{u.n,1};
    if ~isempty(u.list{u.n,2});  u.img{2,1}=u.list{u.n,2}; end
    
    %f1=pars.img{1};
    %f1=u.img{1};
    
end
hsetnumber=findobj(gcf,'tag','setnumber');
msgSetnumber=['set-' num2str(u.n) '/' num2str(size(u.list,1))];
set(hsetnumber,'string', msgSetnumber );
set(hsetnumber,'tooltipstr','hallo')


f1=u.img{1};
h1=spm_vol(f1);
size4d=size(h1,1);
h1=h1(1);

m=h1.mat; m2=m(:);  mv=spm_imatrix(m);
% findobj(gcf,)
for i=1:length(u.sm1);     set(u.sm1(i),'string',m2(i));end
for i=1:length(u.sv1);     set(u.sv1(i),'string',mv(i));end
hi=findobj(gcf,'tag','isource');
[pa di ext]=fileparts(f1);
[~,pa]=fileparts(pa);
ms={[' ' pa ('      [PATH]') ]};
ms(end+1,1)={[ 'DIM: [' sprintf('%d ',h1.dim)   ']          4th. Dim: [' sprintf('%d',size4d)    ']           dt: [' sprintf('%d',h1.dt)  ']']};
set(findobj(gcf,'tag','isource'),'string',[[di ext]  ' (SOURCE)']);
set(findobj(gcf,'tag','isource_info'),'string',ms);


% ----- refIMG
if size(u.img,1)==2
    f2=u.img{2};
    
    h2=spm_vol(f2);
    size4d=size(h2,1);
    h2=h2(1);
    m=h2.mat; m2=m(:);  mv=spm_imatrix(m);
    % findobj(gcf,)
    for i=1:length(u.rm1);     set(u.rm1(i),'string',m2(i));end
    for i=1:length(u.rv1);     set(u.rv1(i),'string',mv(i));end
    
    [pa di ext]=fileparts(f2);
    [~,pa]=fileparts(pa);
    ms={[' ' pa ('      [PATH]') ]};
    ms(end+1,1)={[ 'DIM: [' sprintf('%d ',h2.dim) ']      4th. Dim: [' sprintf('%d',size4d)    ']           dt: [' sprintf('%d',h2.dt)  ']']};
    set(findobj(gcf,'tag','iref'),'string',[[di ext]  ' (REFERENCE)']);
    set(findobj(gcf,'tag','iref_info'),'string',ms);
end

set(gcf,'userdata',u);

%% INFO
hinfo=findobj(gcf,'tag','info');
info=get(hinfo,'string');
% info(end+1,1)={'                '};
info=[info;{repmat('_',[1 50])}];

% newinfo={[['<HTML><FONT color="#3eb200"><b>' ['SET [' num2str(u.n) '/' num2str(size(u.list,1)) ']' ]  '</Font></html>']]};
newinfo={['SET [' num2str(u.n) '/' num2str(size(u.list,1)) ']' ]};

[pas fis exs]=fileparts(u.img{1});
sourcename=[fis exs];

newinfo(end+1,1)=     {[  ' SOURCE: [' sourcename  '] ... ' u.img{1}   ]};%'   ... useREF [' num2str(useref) ']'
if size(u.img,1)==2
    [pas fis exs]=fileparts(u.img{2});
    refname=[fis exs];
    newinfo(end+1,1)={[   ' REFIMG: [' refname '] ... ' u.img{2}   ]};%'   ... useREF [' num2str(useref) ']'
end
if size(u.list,2)==3
    appim=u.list{u.n,3};
    apim= {};    apimHead=' APPIMG: ';
    if ~isempty(appim)
        for i=1:size(appim,1)
            %[paa,fia exa]=fileparts(appim{i});
            if i==1 ; add=apimHead; else; add=repmat(' ',[1 length(apimHead)+8]); end
            apim(end+1,1)={[ add  '[' num2str(i) '/' num2str(size(appim,1))   '] ' appim{i}]};%  [appimmsg   ['<' fia exa '>;']  ];
        end
        newinfo=[newinfo; apim];
    end
end
% char(info)
newMSG=newinfo;
newMSG(1,1)={[['<HTML><FONT color="#3eb200"><b>' ['SET [' num2str(u.n) '/' num2str(size(u.list,1)) ']' ]  '</Font></html>']]};
MSG=[info;newMSG ];

info=[info; newinfo];

% info=[info; info2];
set(hinfo,'string',MSG); set(hinfo,'value',size(MSG,1),'FontName','courier new');
set(hsetnumber,'TooltipString', strjoin(([newinfo]),char(10)) );



function check(e,e2)
u=get(gcf,'userdata');
disp(u)
disp('-----');
disp(u.list);
char(u.list(:,1))
char(u.list(:,2))
try; char(u.list(:,3)), end


function makefig
clear u

delete(findobj(gcf,'tag','headman'));
f=figure;
set(f,'units','normalized','menubar','none','tag','headman','color','w');
set(f,'position',[ 0.0010    0.0689    0.4913    0.8989]);%[  0.0132    0.4100    0.9656    0.4667]);
% 0    0.0333    1.0000    0.9417
set(f ,'name',['header manipulation - Manin gui (' mfilename '.m)' ],'NumberTitle','off');




hu=uicontrol('style','text','tag','isource','units','norm');
set(hu,'position', [.01 0.96 .5 .04 ],'string','SOURCE: -','HorizontalAlignment','left','backgroundcolor','w');
set(hu,'fontsize',12,'fontweight','bold','foregroundcolor',[0    0.4980         0]);

hu=uicontrol('style','text','tag','iref','units','norm');
set(hu,'position', [.501 0.96 .5 .04 ],'string','REF: -','HorizontalAlignment','left','backgroundcolor','w');
set(hu,'fontsize',12,'fontweight','bold','foregroundcolor',[1 0         0]);



hu=uicontrol('style','text','tag','isource_info','units','norm');
set(hu,'position', [.01 0.88 .5 .08 ],'string','SOURCE: -','HorizontalAlignment','left','backgroundcolor','w');

hu=uicontrol('style','text','tag','iref_info','units','norm');
set(hu,'position', [.501 0.88 .5 .08 ],'string','REF: -','HorizontalAlignment','left','backgroundcolor','w');



%% HELP
hu=uicontrol('style','pushbutton','tag','zhelp','units','norm');
set(hu,'position', [0.85 .65 .1 .025 ],'string','Help','HorizontalAlignment','left','backgroundcolor','w',...
    'callback',@zhelp);
% -----------

% hu=uicontrol('style','pushbutton','tag','check','units','norm');
% set(hu,'position', [0 0 .1 .05 ],'string','check(u)','HorizontalAlignment','left','backgroundcolor','w',...
%     'callback',@check);


hu=uicontrol('style','pushbutton','tag','reset','units','norm');
set(hu,'position', [0.45 .65 .1 .025 ],'string',['reset matrix'],'HorizontalAlignment','left','backgroundcolor','w',...
    'callback',@reset);

%% NEXT IMG
hu=uicontrol('style','text','units','norm');
set(hu,'position', [0.38 .99 .1 .015],'string',['image set'],'fontsize',7,'backgroundcolor','w');

hico=fullfile(matlabroot,'/toolbox/matlab/icons/greenarrowicon.gif');
[icon cmap]=imread(hico);
% previous set
hu=uicontrol('style','pushbutton','tag','otherset','units','norm');
set(hu,'position', [0.38 .965 .05 .024 ],'string',[' '],'HorizontalAlignment','left','backgroundcolor','w');
set(hu, 'callback',{@nextset,-1},'cdata',ind2rgb(fliplr(icon),cmap),'tooltipstring','previous set');
% next set
hu=uicontrol('style','pushbutton','tag','otherset','units','norm');
set(hu,'position', [0.43 .965 .05 .024 ],'string',[' '],'HorizontalAlignment','left','backgroundcolor','w');
set(hu, 'callback',{@nextset,+1},'cdata',ind2rgb(icon,cmap),'tooltipstring','next set');

%SET NUMBER
hu=uicontrol('style','text','tag','setnumber','units','norm');
set(hu,'position', [0.4 .94 .075 .024 ],'string',['set-xx'],'fontsize',10,'fontweight','bold','HorizontalAlignment','center','backgroundcolor','w');



%% —————————————————————————————————————————————————————————————————————————————————————————————————
u.sm1=[];
pos=[ .0 .85 .06 .035];
for j=1:4
    for i=1:4
        hu=uicontrol('style','edit','tag','w','units','norm','string','');
        set(hu,'position',[pos(1)+pos(3)*j-pos(3)  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)])
        
        %set(hu,'string',[num2str(i) '-' num2str(j)]);
        u.sm1(end+1)=hu;
        %pause(.1)
    end
end
u.rm1=[];
pos=[ .5 .85 .055 .035];
for j=1:4
    for i=1:4
        hu=uicontrol('style','edit','tag','w','units','norm','string','');
        set(hu,'position',[pos(1)+pos(3)*j-pos(3)  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)])
        
        %set(hu,'string',[num2str(i) '-' num2str(j)]);
        u.rm1(end+1)=hu;
        % pause(.1)
    end
end

try;delete(u.sv1);end
u.sv1=[];
pos=[ .28 .85 .055 .035];
parm={'Tra' 'Rot' 'Vox' 'Sca'};
for i=1:4
    for j=1:3
        hu=uicontrol('style','edit','tag','w','units','norm','string','');
        set(hu,'position',[pos(1)+pos(3)*j-pos(3)  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)])
        u.sv1(end+1)=hu;
        if j==1
            hl=uicontrol('style','text','tag','wl','units','norm','string',parm{i},'backgroundcolor','w','fontweight','bold','fontsize',6);
            set(hl,'position',[pos(1)-pos(3)/2   pos(2)-pos(4)*i+pos(4)  pos(3)/2 pos(4)])
            set(hl,'HorizontalAlignment','right');
        end
        
    end
end

try;delete(u.rv1);end
u.rv1=[];
pos=[ .78 .85 .055 .035];
parm={'Tra' 'Rot' 'Vox' 'Sca'};
for i=1:4
    for j=1:3
        hu=uicontrol('style','edit','tag','w','units','norm','string','');
        set(hu,'position',[pos(1)+pos(3)*j-pos(3)  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)])
        u.rv1(end+1)=hu;
        if j==1
            hl=uicontrol('style','text','tag','wl','units','norm','string',parm{i},'backgroundcolor','w','fontweight','bold','fontsize',6);
            set(hl,'position',[pos(1)-pos(3)/2   pos(2)-pos(4)*i+pos(4)  pos(3)/2 pos(4)])
            set(hl,'HorizontalAlignment','right');
        end
        
    end
end

%% —————————————————————————————————————————————————————————————————————————————————————————————————
%%   MANIP-MAT/VEC
%% —————————————————————————————————————————————————————————————————————————————————————————————————

he=uicontrol('style','text','units','norm','string','apply mat');
set(he,'position',[0 0.72 .1 .015],'backgroundcolor','w','fontweight','bold');



mat=eye(4);
mv=spm_imatrix(mat);

try;delete(u.sm2);end
u.sm2=[];
pos=[ .0 .68 .06 .035];
for j=1:4
    for i=1:4
        hu=uicontrol('style','edit','tag','w','units','norm','string','');
        set(hu,'position',[pos(1)+pos(3)*j-pos(3)  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)])
        
        %set(hu,'string',[num2str(i) '-' num2str(j)]);
        u.sm2(end+1)=hu;
        set(hu,'string',mat(j,i),'foregroundcolor','b');
        set(hu,'callback',@cb_mat);
        % pause(.1)
    end
end

try;delete(u.sv2);end
u.sv2=[];
pos=[ .28 .68 .055 .035];
parm={'Tra' 'Rot' 'Vox' 'Sca'};
for i=1:4
    for j=1:3
        hu=uicontrol('style','edit','tag','w','units','norm','string','');
        set(hu,'position',[pos(1)+pos(3)*j-pos(3)  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)]);
        set(hu,'callback',@cb_vec,'foregroundcolor','b');
        u.sv2(end+1)=hu;
        % set(hu,'string',mat2())
        %pause(.1)
        if j==1
            hl=uicontrol('style','text','tag','wl','units','norm','string',parm{i},'backgroundcolor','w','fontweight','bold','fontsize',6);
            set(hl,'position',[pos(1)-pos(3)/2   pos(2)-pos(4)*i+pos(4)  pos(3)/2 pos(4)])
            set(hl,'HorizontalAlignment','right');
        end
    end
end
for i=1:length(u.sv2)
    set(u.sv2(i),'string',mv(i));
end

%% —————————————————————————————————————————————————————————————————————————————————————————————————
%%   output
%% —————————————————————————————————————————————————————————————————————————————————————————————————

try;delete(u.sm3);end
u.sm3=[];
pos=[ .0 .5 .06 .035];
for j=1:4
    for i=1:4
        hu=uicontrol('style','edit','tag','w','units','norm','string','');
        set(hu,'position',[pos(1)+pos(3)*j-pos(3)  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)])
        
        %set(hu,'string',[num2str(i) '-' num2str(j)]);
        u.sm3(end+1)=hu;
        %set(hu,'string',mat(j,i));
        % pause(.1)
    end
end

try;delete(u.sv3);end
u.sv3=[];
pos=[ .28 .5 .055 .035];
parm={'Tra' 'Rot' 'Vox' 'Sca'};
for i=1:4
    for j=1:3
        hu=uicontrol('style','edit','tag','w','units','norm','string','');
        set(hu,'position',[pos(1)+pos(3)*j-pos(3)  pos(2)-pos(4)*i+pos(4)  pos(3) pos(4)])
        u.sv3(end+1)=hu;
        % set(hu,'string',mat2())
        %pause(.1)
        if j==1
            hl=uicontrol('style','text','tag','wl','units','norm','string',parm{i},'backgroundcolor','w','fontweight','bold','fontsize',6,...
                'tag','sv3label');
            set(hl,'position',[pos(1)-pos(3)/2   pos(2)-pos(4)*i+pos(4)  pos(3)/2 pos(4)])
            set(hl,'HorizontalAlignment','right');
        end
    end
end
u.n=1;

set(u.sm3,'visible','off');                            % RESULTING MATS --> INVISIBLE
set(u.sv3,'visible','off');
set(findobj(gcf,'tag','sv3label'),'visible','off');

set(gcf,'userdata',u);

%% —————————————————————————————————————————————————————————————————————————————————————————————————
%%   buttons
%% —————————————————————————————————————————————————————————————————————————————————————————————————
ipo=.56:-.025:0;


%% applyMAT
hu=uicontrol('style','radio','tag','applymat','units','norm','string','v');
set(hu,'position',[ .5 ipo(1) .15 .025],'string','apply mat', 'value',1,'backgroundcolor','w');

%% useREF
hu=uicontrol('style','radio','tag','useref','units','norm','string','v');
set(hu,'position',[ .5 ipo(2) .15 .025],'string','use reference','backgroundcolor','w');

%% remove flips
hu=uicontrol('style','radiobutton','tag','rb_removeflips','units','norm','string','##');
set(hu,'position',[ .5 ipo(3) .15 .025],'string','remove flips','value',1,'backgroundcolor','w',...
    'callback',@removeflips);

%%  replace header
hu=uicontrol('style','radiobutton','tag','rb_replacehdr','units','norm','string','##');
set(hu,'position',[ .65 ipo(3) .15 .025],'string','replace HDR ','value',0,'backgroundcolor','w',...
    'callback',@replaceHDR);


%% center2origin
hu=uicontrol('style','radiobutton','tag','rb_origin2center','units','norm','string','##');
set(hu,'position',[ .5 ipo(4) .15 .025],'string','center origin','value',0,'backgroundcolor','w');

%% interactive
hu=uicontrol('style','radiobutton','tag','rb_interactive','units','norm','string','##');
set(hu,'position',[ .5 ipo(5) .15 .025],'string','interactive','value',0,'backgroundcolor','w');

%% showfinal volume
hu=uicontrol('style','radiobutton','tag','rb_showfinalvolume','units','norm','string','##');
set(hu,'position',[ .5 ipo(6) .15 .025],'string','show final image','value',0,'backgroundcolor','w');


%% RUN ALL SETS
hu=uicontrol('style','radiobutton','tag','rb_runallsets','units','norm','string','##');
set(hu,'position',[ .5 ipo(9) .15 .025],'string','run all sets','value',0,'backgroundcolor','w');

%% show-it mricron
hu=uicontrol('style','radiobutton','tag','rb_showit','units','norm','string','##');
set(hu,'position',[ .61 .3 .15 .025],'string','show it','value',0,'backgroundcolor','w','fontsize',6);

%===================================================================
%% RESIZE
hu=uicontrol('style','radiobutton','tag','resl_resize','units','norm','string','##');
set(hu,'position',[ .5 ipo(7) .15 .025],'string','resize','value',0,'backgroundcolor','w','callback',@resl_resize);


hu=uicontrol('style','popupmenu','tag','resl_resize2what','units','norm','string','##');
set(hu,'position',[ .57 ipo(7) .15 .025],...
    'string',{'to reference','to source + edit..' 'to ref. + edit..' },...
    'backgroundcolor','w','callback',@resl_resize2what)

% ------BBOX1---
hu=uicontrol('style','text' ,'tag','resl_txt',   'units','norm','string','##');
set(hu,'position',[ .73 ipo(7) .03 .023],'string','BB1','value',0,'backgroundcolor','w');
hu=uicontrol('style','edit','tag','resl_bbox1','units','norm','string','##');
set(hu,'position',[ .76 ipo(7) .19 .023],'string','#BBOX-low###','value',0,'backgroundcolor','w');
% ------BBOX2---
hu=uicontrol('style','text',  'tag','resl_txt'   ,'units','norm','string','##');
set(hu,'position',[ .73 ipo(7)-.023*1 .03 .023],'string','BB2','value',0,'backgroundcolor','w');
hu=uicontrol('style','edit','tag','resl_bbox2','units','norm','string','##');
set(hu,'position',[ .76 ipo(7)-.023*1 .19 .023],'string','#BBOX-high###','value',0,'backgroundcolor','w');

%radios UIP
hu=uicontrol('style','radio','tag','resl_bbox1UIP','units','norm','string','##','callback',@uip);
set(hu,'position',[ .95 ipo(7)  .05 .023],'string','UIP','value',0,'backgroundcolor','w','fontsize',6,'value',1);
set(hu,'tooltipstring', ['UIP INPUT IMAGE PARAMETER' char(10) '[x] use UIP.. i.e. use the image-spectic parameter from the respective image' char(10) '[] no, use the exact value(s) edited/modified here for this image and all other images too']);

hu=uicontrol('style','radio','tag','resl_bbox2UIP','units','norm','string','##','callback',@uip);
set(hu,'position',[ .95 ipo(7)-.023*1 .05 .023],'string','UIP','value',0,'backgroundcolor','w','fontsize',6,'value',1);
set(hu,'tooltipstring', ['UIP INPUT IMAGE PARAMETER' char(10) '[x] use UIP.. i.e. use the image-spectic parameter from the respective image' char(10) '[] no, use the exact value(s) edited/modified here for this image and all other images too']);

% ------VOX---
hu=uicontrol('style','text',  'tag','resl_txt',                     'units','norm','string','##');
set(hu,'position',[ .76 ipo(7)-.023*2 .03 .023],'string','vox','value',0,'backgroundcolor','w');
hu=uicontrol('style','edit','tag','resl_voxsi','units','norm','string','##');
set(hu,'position',[.79 ipo(7)-.023*2 .16 .023],'string','VOX','value',0,'backgroundcolor','w');

%radios UIP
hu=uicontrol('style','radio','tag','resl_voxsiUIP','units','norm','string','##','callback',@uip);
set(hu,'position',[ .95 ipo(7)-.023*2  .05 .023],'string','UIP','value',0,'backgroundcolor','w','fontsize',6,'value',1);
set(hu,'tooltipstring', ['UIP INPUT IMAGE PARAMETER' char(10) '[x] use UIP.. i.e. use the image-spectic parameter from the respective image' char(10) '[] no, use the exact value(s) edited/modified here for this image and all other images too']);

% -----DIM----
hu=uicontrol('style','text'     ,'tag','resl_txt',                'units','norm','string','##');
set(hu,'position',[ .76 ipo(7)-.023*3 .03 .023],'string','dim','value',0,'backgroundcolor','w')
hu=uicontrol('style','edit','tag','resl_dim','units','norm','string','##');
set(hu,'position',[ .79 ipo(7)-.023*3 .16 .023],'string','DIM','value',0,'backgroundcolor','w');

%radios UIP
hu=uicontrol('style','radio','tag','resl_dimUIP','units','norm','string','##','callback',@uip);
set(hu,'position',[ .95 ipo(7)-.023*3  .05 .023],'string','UIP','value',0,'backgroundcolor','w','fontsize',6,'value',1);
set(hu,'tooltipstring', ['UIP INPUT IMAGE PARAMETER' char(10) '[x] use UIP.. i.e. use the image-spectic parameter from the respective image' char(10) '[] no, use the exact value(s) edited/modified here for this image and all other images too']);


% -----vox vs dim----
hu=uicontrol('style','radio','tag','resl_voxvsdim','units','norm','string','##');
set(hu,'position',[ .71 ipo(7)-.023*2 .05 .023],'string','V','value',1,'backgroundcolor','w',...
    'callback',@resl_voxvsdim);

set(findobj(gcf,'tag','resl_dim'),'enable','off');

% % -----vox vs dim selector----
%  hu=uicontrol('style','text'     ,'tag','resl_txt',                'units','norm','string','##');
% set(hu,'position',[ .73 ipo(7)-.023*3 .03 .023],'string','dim','value',0,'backgroundcolor','w')
%  hu=uicontrol('style','edit','tag','resl_dim','units','norm','string','##');
% set(hu,'position',[ .76 ipo(7)-.023*3 .24 .023],'string','DIM','value',0,'backgroundcolor','w');
% set(findobj(gcf,'tag','resl_dim'),'enable','off');

% ----interp-----
hu=uicontrol('style','text',       'tag','resl_txt',              'units','norm','string','##');
set(hu,'position',[ .76 ipo(7)-.023*4 .03 .023],'string','inp','value',0,'backgroundcolor','w')
hu=uicontrol('style','popupmenu','tag','resl_interp','units','norm','string','##');
set(hu,'position',[ .79 ipo(7)-.023*4 .21 .023],'string',{'auto' ,'0','1'},'value',1,'backgroundcolor','w');



%% RESIZE
% hu = uidropdown(gcf);

% position = [10,100,90,20];  % pixels
% hContainer = gcf;  % can be any uipanel or figure handle
% options = {'source','b','c'};
% model = javax.swing.DefaultComboBoxModel(options);
% [jCombo hcombo]= javacomponent('javax.swing.JComboBox', position, hContainer);
% jCombo.setModel(model);
% jCombo.setEditable(true);
%
% set(hContainer, 'Units','norm');
% set(hcombo,'units','norm','position',[.68 .4 .1 .025])
% set(jCombo,'ActionPerformedCallback',@hi)



%  hCombo = uicontrol('Style','popup', 'String',{'a','b','c'});
%  jCombo = findjobj(hCombo)
%  jCombo.setEditable(true);
% jCombo.Editable = true;          % equivalent alternative
%   set(jCombo,'setEditable',true);  % equivalent alternative
% https://undocumentedmatlab.com/blog/editable-combo-box

%   0.5600    0.5350    0.5100    0.4850    0.4600    0.4350    0.4100
%   Columns 8 through 14
%     0.3850    0.3600    0.3350    0.3100    0.2850    0.2600    0.2350

%  hu=uicontrol('style','radiobutton','tag','rb_datatype','units','norm');
% set(hu,'position',[ .51 .55 .15 .025],'string','use REF-dataType','value',0,'backgroundcolor','w');






%% getMATRIX
hu=uicontrol('style','pushbutton','tag','pb_showmatrix','units','norm','string','##');
set(hu,'position',[.5 .3 .1 .025],'string','RUN','callback',@runthis,...
    'foregroundcolor',[0 .5 0],'fontweight','bold');

%% OVL
hu=uicontrol('style','pushbutton','tag','pb_showovl','units','norm','string','v');
set(hu,'position',[.65 .65 .1 .025],'string','show overlay','callback',{@show_ovl,1});

%% color
r=[ 0.9922    0.9176    0.7961];
set(u.sm1(1:5:end-1),'backgroundcolor',r); set(u.sv1(7:9),'backgroundcolor',r);
set(u.rm1(1:5:end-1),'backgroundcolor',r); set(u.rv1(7:9),'backgroundcolor',r);
set(u.sm2(1:5:end-1),'backgroundcolor',r); set(u.sv2(7:9),'backgroundcolor',r);
set(u.sm3(1:5:end-1),'backgroundcolor',r); set(u.sv3(7:9),'backgroundcolor',r);
r=[  0.8392    0.9098    0.8510];
set(u.sm1(end-3:end-1),'backgroundcolor',r); set(u.sv1(1:3),'backgroundcolor',r);
set(u.rm1(end-3:end-1),'backgroundcolor',r); set(u.rv1(1:3),'backgroundcolor',r);
set(u.sm2(end-3:end-1),'backgroundcolor',r); set(u.sv2(1:3),'backgroundcolor',r);
set(u.sm3(end-3:end-1),'backgroundcolor',r); set(u.sv3(1:3),'backgroundcolor',r);

%% DATATYPE
hu=uicontrol('style','text','units','norm');
set(hu,'position',[ .0 .3 .08 .02],'string','dataType','backgroundcolor','w','HorizontalAlignment','right');

hu=uicontrol('style','popupmenu','tag','ed_dt','units','norm');
set(hu,'position',[ .08 .3 .1 .025],'string','##','backgroundcolor','w');
types  = [    2      4       8          16     64       256      512           768];
set(findobj(gcf,'tag','ed_dt'),'string',['source';'ref';cellstr(num2str(types'))]);

%% PREFIX
hu=uicontrol('style','text','units','norm');
set(hu,'position',[ .0 .28 .08 .02],'string','prefix','backgroundcolor','w','HorizontalAlignment','right');
hu=uicontrol('style','edit','tag','ed_prefix','units','norm');
set(hu,'position',[ .08 .28 .1 .025],'string','h','backgroundcolor','w');


%% infobox
hu=uicontrol('style','listbox','units','norm');
set(hu,'position',[0.001 0 .999 .26],'string','info','backgroundcolor','w','foregroundcolor','b','tag','info');

hu=uicontrol('style','pushbutton','units','norm');
set(hu,'position',[0.94 .26 .06 .015],'string','clear','backgroundcolor','w','tag','clear',...
    'tooltipstr','clear message box','callback',@clearMsgBox);


hgfeval(get( findobj(gcf,'tag','resl_resize')  ,'callback'));  % resize invisible

hs=findobj(gcf,'tag','resl_resize2what');
set(hs,'value',1);
% hgfeval(get(hs,'callback'));

function clearMsgBox(e,e2)
hinfo=findobj(gcf,'tag','info');
set(hinfo,'value',1,'string',{''});

function zhelp(e,e2)
uhelp(mfilename);
figure(findobj(0,'tag','uhelp'));



function removeflips(e,e2)
if get(findobj(gcf,'tag','rb_removeflips'),'value')==1
    set(findobj(gcf,'tag','rb_replacehdr'),'value',0);
else
    %     set(findobj(gcf,'tag','rb_replacehdr'),'value',1)
end

function replaceHDR(e,e2)
if get(findobj(gcf,'tag','rb_replacehdr'),'value')==1
    set(findobj(gcf,'tag','rb_removeflips'),'value',0);
    set(findobj(gcf,'tag','useref'),'value',1);
    
else
    %     set(findobj(gcf,'tag','rb_removeflips'),'value',1)
end

function resl_voxvsdim(e,e2)

% if get(findobj(gcf,'tag','resl_resize2what'),'value') ~=1
val=get(findobj(gcf,'tag','resl_voxvsdim'),'value');
if val==1;     parm={'on' 'off'};else;    parm={ 'off' 'on'}; end
set(findobj(gcf,'tag','resl_voxsi'),'enable',parm{1});
set(findobj(gcf,'tag','resl_dim'),'enable',parm{2});
% end



function resl_resize(e,e2)

set(findobj(gcf,'tag','resl_voxvsdim'),'visible','off');


isresize=get(findobj(gcf,'tag','resl_resize'),'value');
hs={'resl_resize2what' 'resl_txt' 'resl_bbox1' 'resl_bbox2'  'resl_voxsi','resl_dim' 'resl_interp'};
hs=[hs {'resl_bbox1UIP' 'resl_bbox2UIP' 'resl_voxsiUIP' 'resl_dimUIP'}];
for i=1:length(hs)
    if isresize==1
        set(findobj(gcf,'tag',hs{i}),'visible','on');
        
    else
        set(findobj(gcf,'tag',hs{i}),'visible','off');
    end
end
if isresize==1
    if  get(findobj(gcf,'tag','resl_resize2what'),'value') ==1
        set(findobj(gcf,'tag','resl_bbox1'),'enable','off');
        set(findobj(gcf,'tag','resl_bbox2'),'enable','off');
        set(findobj(gcf,'tag','resl_voxsi'),'enable','off');
        set(findobj(gcf,'tag','resl_dim'),'enable','off');
        
        set(findobj(gcf,'tag','resl_voxvsdim'),'enable','off');
        
        set(findobj(gcf,'tag','resl_bbox1UIP'),'visible','off');
        set(findobj(gcf,'tag','resl_bbox2UIP'),'visible','off');
        set(findobj(gcf,'tag','resl_voxsiUIP'),'visible','off');
        set(findobj(gcf,'tag','resl_dimUIP'),'visible','off');
    end
else
    
    %         set(findobj(gcf,'tag','resl_bbox1UIP'),'visible','off');
    %         set(findobj(gcf,'tag','resl_bbox2UIP'),'visible','off');
    %         set(findobj(gcf,'tag','resl_voxsiUIP'),'visible','off');
    %         set(findobj(gcf,'tag','resl_dimUIP'),'visible','off');
end
try
    resl_resize2what();
end

function uip(e,e2)
if get(e,'value')==1
    set(findobj(gcf,'tag',strrep(get(e,'tag'),'UIP','')),'enable','off');
else
    set(findobj(gcf,'tag',strrep(get(e,'tag'),'UIP','')),'enable','on');
end


function resl_resize2what(e,e2)

if get(findobj(gcf,'tag','resl_resize'),'value')==0; return; end


u=get(gcf,'userdata');
val=get(findobj(gcf,'tag','resl_resize2what'),'value');   % VAL == TYPE OF REF
if val==1
    ha=u.img{2};
elseif val==2
    ha=u.img{1};
elseif val==3
    ha=u.img{2};
end

hs ={ 'resl_bbox1'    'resl_bbox2'    'resl_voxsi'   ,'resl_dim'};
hs2={ 'resl_bbox1UIP' 'resl_bbox2UIP' 'resl_voxsiUIP','resl_dimUIP'};

if val==1
    for i=1:length(hs);
        has=findobj(gcf,'tag',hs{i});       set(has,'enable','off');
        has=findobj(gcf,'tag',hs2{i});      set(has,'visible','off');
    end
else
    for i=1:length(hs);
        has=findobj(gcf,'tag',hs{i});       set(has,'enable','off');
        has=findobj(gcf,'tag',hs2{i});      set(has,'visible','on','value',1);
    end
end

% return


% if val==1;     editable='off';            else;   editable='on'; end
% for i=1:length(hs);
%     has=findobj(gcf,'tag',hs{i});
%     set(has,'enable',editable);
% end


% if val~=1
%     hgfeval(get( findobj(gcf,'tag','resl_voxvsdim')  ,'callback'));
% end


ha=spm_vol(ha);
[BB vox] = world_bb(ha);

set(findobj(gcf,'tag','resl_bbox1'),'string', regexprep(num2str(BB(1,:)),'\s+','  '));
set(findobj(gcf,'tag','resl_bbox2'),'string', regexprep(num2str(BB(2,:)),'\s+','  '));
set(findobj(gcf,'tag','resl_voxsi'),'string', regexprep(num2str(vox),'\s+','  '));
set(findobj(gcf,'tag','resl_dim'),'string', regexprep(num2str(ha(1).dim),'\s+','  '));

% if val==1
%     set(findobj(gcf,'tag','resl_voxvsdim'),'enable','off');
% else
%     set(findobj(gcf,'tag','resl_voxvsdim'),'enable','on');
% end


function show_ovl(e,e2,arg)
u=get(gcf,'userdata');

w.col=get(e,'backgroundcolor');
w.string=get(e,'string');
w.fs=get(e,'fontsize');
set(e,'string',[w.string '..wait..' ],'backgroundcolor',[1 .8 0],'fontsize',7);
drawnow;


msgDK={'SHOW OVERLAY'};
%msgDK(end+1,1)={[['#moving IMG: ' fout]]};
params=struct();
params.msg=msgDK;
if size(u.img,1)==1
    r= displaykey2(u.img{1},u.img{1},1,params);
else
    r= displaykey2(u.img{1},u.img{2},1,params);
end
set(e,'string',[w.string   ],'backgroundcolor',w.col,'fontsize',w.fs);
if isempty(r); return; end
m3=spm_matrix(r);

m4=m3(:);
for i=1:length(u.sm2)
    set(u.sm2(i),'string',m4(i));
end
m5=r;
for i=1:length(m5)
    set(u.sv2(i),'string',m5(i));
end


function cb_vec(e,e2)
u=get(gcf,'userdata');
m=[];
for i=1:length(u.sv2)
    m(i)=str2num(get(u.sv2(i),'string'));
end
m2=spm_matrix(m); m2=m2(:);
for i=1:length(u.sm2)
    set(u.sm2(i),'string',m2(i));
end


function cb_mat(e,e2)
u=get(gcf,'userdata');
m=[];
for i=1:length(u.sm2)
    m(i)=str2num(get(u.sm2(i),'string'));
end
m2=spm_imatrix(reshape(m,[4 4]));
for i=1:length(u.sv2)
    set(u.sv2(i),'string',m2(i));
end

function reset(e,e2)
u=get(gcf,'userdata');
m3=eye(4);
m4=m3(:);
for i=1:length(u.sm2);     set(u.sm2(i),'string',m4(i));end
m5=spm_imatrix(m3);
for i=1:length(u.sv2);     set(u.sv2(i),'string',m5(i));end


%#############################################################################

%#############################################################################
%%   APPLYMAT
%#############################################################################
%#############################################################################

function runthis(e,e2)



if get(  findobj(gcf,'tag','rb_runallsets')   ,'value')==0
    applymat();
else
    disp( '..running all SETS');
    u=get(gcf,'userdata');
    n=u.n;
    norig=n;
    nall=1:size(u.list,1);
    df=setdiff(nall,n);
    setorder=[n df];
    
    for i=1:length(setorder)
        %disp([setorder(i)])
        nextset([],[],num2str(setorder(i)));
        u=get(gcf,'userdata');
        pause(.3);
        %disp(u.n);
        applymat();
    end
    
    
    % going to original set
%     nextset([],[],num2str(norig));
    
end

% disp('..done');
cprintf([1 0 1 ], ['  DONE '  '\n']);


function [hy yy] = checkHDR4d(hy,yy);
%update "n"
ht=hy(1);
if size(yy,4)>1
    for i=2:size(yy,4)
        ht(i,1)=hy(1);
        ht(i,1).n(1)=i;
    end
end
hy=ht;

   
    
    

function applymat(e,e2)
% arg


u=get(gcf,'userdata');

cprintf(-[1,0,1], ['running set-No-' num2str(u.n) '\n']);
% disp(['running set-No-' num2str(u.n)]);


%% PARAMETER
r=[];
r.applymat      = get(findobj(gcf,'tag','applymat'),'value');
r.useref        = get(findobj(gcf,'tag','useref'),'value');
r.removeflips   = get(findobj(gcf,'tag','rb_removeflips'),'value');
r.replaceHDR    = get(findobj(gcf,'tag','rb_replacehdr'),'value');
r.origin2center = get(findobj(gcf,'tag','rb_origin2center'),'value');

r.interactive     = get(findobj(gcf,'tag','rb_interactive'),'value');
r.showfinalvolume = get(findobj(gcf,'tag','rb_showfinalvolume'),'value');

r.resize          = get(findobj(gcf,'tag','resl_resize'),'value');
r.origin2center   = get(findobj(gcf,'tag','rb_origin2center'),'value');

r.datatypeStr     = get(findobj(gcf,'tag','ed_dt'),'string'); r.datatypeStr=r.datatypeStr{get(findobj(gcf,'tag','ed_dt'),'value')};
r.pref            = get(findobj(gcf,'tag','ed_prefix'),'string');

r.showit          = get(findobj(gcf,'tag','rb_showit'),'value');


%% INFO
hinfo=findobj(gcf,'tag','info');
% info={[ '[' num2str(u.n) '/' num2str(size(u.list,1)+1) ']'  ' source: ' u.img{1}   '   ... useREF [' num2str(useref) ']']};





%% —————————————————————————————————————————————————————————————————————————————————————————————————
%%   prepare images
%% —————————————————————————————————————————————————————————————————————————————————————————————————
list=u.list(u.n,:);
w.s =list{1};
w.r =list{2};
w.a =list{3};

cprintf([0 .5 0], ['SOURCE: ' strrep(w.s,[filesep],[filesep filesep]) '\n']);
cprintf([1 0 0 ], ['   REF: ' strrep(w.r,[filesep],[filesep filesep]) '\n']);



nimg=1+size(w.a,1); % number of images to apply headerManip including sourceImg

for jj=1:nimg
    if jj==1 ;        source=w.s;      else ;        source=w.a{jj-1} ;    end
    if jj==1 ;        ref   =w.r;       end
    
    info=get(hinfo,'string');
    %info{end+1,1}=['..from set ['  num2str(u.n) '/' num2str(size(u.list,1)) '] processing [' source ' ]' ];
    info{end+1,1}=['.. processing [' source ' ]' ];
    set(hinfo,'string',info); set(hinfo,'value',size(info,1));
    
    %===================================================== [ other pars  ]============================
    %% set DATATYPE
    
    if strcmp(  r.datatypeStr,'source')
        h=spm_vol(source);  h=h(1);       r.datatype=    h(1).dt(1);
    elseif strcmp(r.datatypeStr,'ref')
        if ~isempty(ref)
            href=spm_vol(ref);            r.datatype=     href(1).dt(1);
        else
            disp('no reference selected..using source');
            h=spm_vol(source);            r.datatype=     h(1).dt(1);
        end
    else
        r.datatype=str2num(char(r.datatypeStr));
    end
    
    %     disp(r)
    %    return
    %=================================================================================
    
    %% SOURCE OR REF
    if r.useref==1
        if isempty(ref); disp('there is no reference image..canceled'); return; end
        m1=[];
        for i=1:length(u.rm1);         m1(i)=str2num(get(u.rm1(i),'string'));     end
        m1=reshape(m1,[4 4]);
        hr=spm_vol(ref);    hr=hr(1);
    else
        m1=[];
        for i=1:length(u.sm1);         m1(i)=str2num(get(u.sm1(i),'string'));     end
        m1=reshape(m1,[4 4]);
        hr=spm_vol(source); hr=hr(1);
    end
    
    %====================================================================================
    %% APPLYMATRIX
    %====================================================================================
    if r.applymat==1
        for i=1:length(u.sm2);         m2(i)=str2num(get(u.sm2(i),'string'));    end
        m2=reshape(m2,[4 4]);
    else
        m2=eye(4);
    end
    
    %====================================================================================
    %% FLIPS
    %====================================================================================
    if r.removeflips  ==1
        if r.useref==0
            [hy yy]=reslicevol(source );
        elseif r.useref==1
            [hy yy]=reslicevol(source,ref );
        end
    else
        [hy yy]=rgetnii(source );
    end
    
    %====================================================================================
    %% REPLACE HDR
    %====================================================================================
    if r.replaceHDR  ==1
        if isempty(ref)
            warning('..could not replaceHDR ..no referenceIMG selected');
        else
            %[hr2 rd]=rgetnii(ref);
            hr=spm_vol(ref);
            hr=hr(1);
            %[ha a]=rgetnii(fs);
            is=spm_imatrix(hy(1).mat);
            ir=spm_imatrix(hr(1).mat);
            ssign=sign(is(7:9));
            rsign=sign(ir(7:9));
            iflip= (ssign~=rsign);
            
            a=yy;
            if iflip(1)==1;  a=flipdim(a,2); end
            if iflip(2)==1;  a=flipdim(a,1); end
            if iflip(3)==1;  a=flipdim(a,3); end
            yy=a;
            for i=1:length(hy)
                hy(i).mat = hr(1).mat;
            end
            
            
            %     hr.dt=ha.dt;
            %     try; hr=rmfield(hr,'pinfo'); end
            %     try; hr=rmfield(hr,'private');end
            %     rsavenii(fs, hr,a);
            %     rmricron('O:\data3\hedermanip\dat\M_1\', 't2.nii','hmasklesion.nii' , 2,[20 -1])
        end
    end
    
    %====================================================================================
    %% save volume
    %====================================================================================
    hy=hy(1);
    hy.dt=[ r.datatype hy.dt(2)  ];
%     try; hy=rmfield(hy,'pinfo'); end
%     try; hy=rmfield(hy,'private');end
    
    [hy yy] = checkHDR4d(hy,yy);
    
    if ~isempty(r.pref)                       % PREFIX assigned
        fout=stradd(source,  r.pref ,1);
    else
        fout=source;
    end
    
    %====================================================================================
    %% apply MAT
    %====================================================================================
    
    if r.applymat==1
        for i=1:size(yy,4)
            hy(i).mat  =            m2*hy(i).mat ;
        end
    end
    rsavenii(fout,hy,yy);
    
    %check
%     chk=spm_check_orientations(r);
%     if chk~=1
%         keyboard        
%     end
    
% %     %====================================================================================
% %     %% apply MAT
% %     %====================================================================================
% %     
% %     mx=spm_get_space(fout);
% %     if r.applymat==1
% %         spm_get_space(fout, m2*mx);
% %     end
% %     
    %====================================================================================
    %% interactive mode
    %====================================================================================
    
    if jj==1
        paraminteractive=[];
    end
    if r.interactive ==1 && jj==1
        %params.mat=m2;
        params.empty=1;
        
        
        msgDK={'INTERACTIVE MODE'};
        %msgDK(end+1,1)={[['#moving IMG: ' fout]]};
        params.msg=msgDK;
        if isempty(ref)
            paraminteractive= displaykey2(fout,source,1,params);
        else
            paraminteractive= displaykey2(fout,ref,1,params);
        end
    end
    
    if ~isempty(paraminteractive)% only if not cancel pressed
        if all(paraminteractive==[zeros(1,6) ones(1,3)])==0  % only if changes were made
            m2=spm_matrix(paraminteractive);
            mx=spm_get_space(fout);
            spm_get_space(fout, m2*mx);
        end
    end
    
    
    % m3=m2*spm_get_space(fout);
    
    
    
    %====================================================================================
    %% SET GUI-MATRIZES         HAS TO BE DONE
    %====================================================================================
    if 0
        m4=m3(:);
        for i=1:length(u.sm3);     set(u.sm3(i),'string',m4(i));  end
        m5=spm_imatrix(m3);
        for i=1:length(u.sv3);     set(u.sv3(i),'string',m5(i));  end
    end
    
    
    %====================================================================================
    %% RESIZE/RESLICE IMAGE
    %====================================================================================
    %%
    if r.resize  == 1
        disp('..reslicing..');
        targval   = get(findobj(gcf,'tag','resl_resize2what'),'value') ;
        interpval = get(findobj(gcf,'tag','resl_interp'),'string') ;
        interpval = interpval{get(findobj(gcf,'tag','resl_interp'),'value')};
        
        if strcmp(interpval,'auto')
            [ha a]=rgetnii(fout);
            unival=unique(a(:));
            if all([round(unival*10)/10 ==unival])==1 % binary
                interpval='0';
            else
                interpval='1';
            end
            disp(['interpolation (autodetect): '  interpval]);
        else
            disp(['interpolation              : '  interpval]);
        end
        
        fout2=stradd(fout,'r',1);
        if targval==1
            rreslice2target(fout, ref, fout2, str2num(interpval));
            disp('ref: reference');
        elseif targval==2 || targval==3
            
            if     targval==2
                disp('ref: source(+edit)');
                ftar=fout;
            else
                disp('ref: reference(+edit)');
                ftar=ref;
            end
            
            htar      = spm_vol(ftar);
            %mvec      =spm_imatrix(htar.mat);
            
            [bbo vox] = world_bb(ftar);
            dim       = htar.dim;
            
            usevox=1;
            if get(findobj(gcf,                         'tag',    'resl_bbox1UIP'    ),'value')  ==0 % user input otherwise use UIP
                bbo(1,:) = str2num(get(findobj(gcf,     'tag',    'resl_bbox1'       ),'string'));
            end
            if get(findobj(gcf,                         'tag',    'resl_bbox2UIP'    ),'value')  ==0 % user input otherwise use UIP
                bbo(2,:) = str2num(get(findobj(gcf,     'tag',    'resl_bbox2'       ),'string'));
            end
            if get(findobj(gcf,                         'tag',    'resl_voxsiUIP'    ),'value')  ==0 % user input otherwise use UIP
                vox      = str2num(get(findobj(gcf,     'tag',    'resl_voxsi'       ),'string'));
            end
            if get(findobj(gcf,                         'tag',    'resl_dimUIP'      ),'value')  ==0 % user input otherwise use UIP
                dim      = str2num(get(findobj(gcf,     'tag',    'resl_dim'         ),'string'));
                usevox=2;
            end
            
            %resize_img6('t2.nii','ht2.nii',[.12 .12 .3], [],bb*2, [], 3)
            if usevox==1
                disp('..using vox-size');
                resize_img6(fout,fout2,vox, [],bbo, [], str2num(interpval));
            else
                disp('..using dim');
                resize_img6(fout,fout2,[], dim,bbo, [], str2num(interpval));
            end
        end
        
        
        
        % TESTER
        if 0
            h1=fout2;
            if targval==1 || targval==3  %REF
                h2=ref;
            else
                h2=source;
            end
            hm1=spm_vol(h1);     hm2=spm_vol(h2);
            [pax,fi1 ext1]=fileparts(h1);     name1=[fi1 ext1];
            [pax,fi2 ext2]=fileparts(h2);     name2=[fi2 ext2];
            [BB1 vox1] = world_bb(h1);    [BB2 vox2] = world_bb(h2);
            
            %% DISPL
            disp('--------------OUTPUTS [(s)source-output (r)reference of recliced image] --------------');
            disp(['[s]: ' name1    '   [r]: ' name2]);
            disp(['DIM:: [s]: ' num2str(hm1.dim)  '    [r]: ' num2str(hm2.dim)]);
            disp(['DT::  [s]: ' num2str(hm1.dt)  '     [r]: ' num2str(hm2.dt)]);
            
            disp(['BOUNDING BOX:: [s] ..'     ]);
            disp([num2str(BB1)   ]);
            disp(['BOUNDING BOX:: [r] ..'     ]);
            disp([num2str(BB2)   ]);
            
            disp(['MAT:: [s] ..'     ]);
            disp([num2str(hm1.mat)   ]);
            disp(['MAT:: [r] ..'     ]);
            disp([num2str(hm2.mat)   ]);
            
            
            %% end
            %pause(.3);
            rmricron(fileparts(h1), name1,name2 , 2,[20 -1])
        end
        %% DELETE TEMPORARY RESLICING FILE
        if 1 %%
            delete(fout);
            movefile(fout2,fout,'f');
        end
    end
    
    
    
    %====================================================================================
    %% GEOM CENTER
    %====================================================================================
    
    if r.origin2center  ==1
        
        hce=spm_vol(fout);
        mci   =spm_imatrix(hce(1).mat);
        voxsi =mci([8 7 9]);
        %disp(hce.mat); disp(hce.dim/2);
        cent= -(voxsi).*(hce(1).dim/2);
        signvox=sign(voxsi);
        if signvox(1)==-1;   cent(1)=cent(1)-voxsi(1); end
        if signvox(2)==-1;   cent(2)=cent(2)-voxsi(2); end
        if signvox(3)==-1;   cent(3)=cent(3)-voxsi(3); end
        
        mc=    hce.mat;
        mc(1:3,4)=cent;
        spm_get_space(fout, mc);
        
        for i=1:length(hce)% 4dim-data
            spm_get_space([fout ',' num2str(i) ], mc);
        end
        
    end
    
    
    %====================================================================================
    %% rb_showfinalvolum
    %====================================================================================
    if jj==1
        paramfinal=[];
    end
    if r.showfinalvolume == 1 && jj==1  % show only the real SOURCE IMAGE
        
        msgDK={'SHOW FINAL IMAGE'};
        %msgDK(end+1,1)={[['#moving IMG: ' fout]]};
        params=struct();
        params.msg=msgDK;
        
        if size(u.img,1)==1
            paramfinal= displaykey2(fout,u.img{1},1,params);
        else
            paramfinal= displaykey2(fout,u.img{2},1,params);
        end
    end
    
    if ~isempty(paramfinal)% only if not cancel pressed
        if all(paramfinal==[zeros(1,6) ones(1,3)])==0  % only if changes were made
            m2=spm_matrix(paramfinal);
            mx=spm_get_space(fout);
            %spm_get_space(fout, m2*mx);
            
            hxx=spm_vol(fout);
            for i=1:length(hxx)% 4dim-data
                spm_get_space([fout ',' num2str(i) ], m2*mx);
            end
            
            
        end
    end
    
    
    
    %====================================================================================
    %% finalized, update etc
    %====================================================================================
    
    
    info{end}=[info{end} ' [DONE]'];
    set(hinfo,'string',info); set(hinfo,'value',size(info,1));
    
    if 0
        
        disp('ref ***');
        if r.useref==0;
            disp(['** SOURCE VOL: ' source]);
            disp(spm_get_space(source));
        else;
            disp(['** REFERENCE VOL: ' ref]);
            disp(spm_get_space(ref));
        end
        disp(['** OUTPUT VOL: ' fout]);
        disp(spm_get_space(fout));
    end
    
    
    if 1
        if r.useref==0;
            h2=source;
        else;
            h2=ref;
        end
        
        h1=fout;
        hm1=spm_vol(h1); dim41=size(hm1,1); hm1=hm1(1);
        hm2=spm_vol(h2); dim42=size(hm2,1); hm2=hm2(1);
        [pax1,fi1 ext1]=fileparts(h1);     name1=[fi1 ext1]; [~, pax1short ] =fileparts(pax1);
        [pax2,fi2 ext2]=fileparts(h2);     name2=[fi2 ext2];
        [BB1 vox1] = world_bb(h1);      [BB2 vox2] = world_bb(h2);
        
        spa=20; %space
        %% DISPL
        msg={};
        msg{end+1,1}=['--- OUTPUT:  [o] output image [r] refIMG or orig. source image ---'];
        msg{end+1,1}=['         +' repmat('=',[1 length(name1)+2])    '+       +'  repmat('=',[1 length(name2)+2])  '+' ];
        msg{end+1,1}=['NAME [o] | ' name1    ' |   [r] | ' name2 ' | '];
        msg{end+1,1}=['         +' repmat('=',[1 length(name1)+2])    '+       +'  repmat('=',[1 length(name2)+2])   '+'];
        
        msg{end+1,1}=['DIM      : ' num2str(hm1.dim) repmat(' ',[1 spa-length(num2str( hm1.dim ))]) ' : ' num2str(hm2.dim)];
        msg{end+1,1}=['4th.DIM  : ' num2str(dim41)   repmat(' ',[1 spa-length(num2str( dim41 ))])   ' : ' num2str(dim42)  ];
        msg{end+1,1}=['DT       : ' num2str(hm1.dt)  repmat(' ',[1 spa-length(num2str( hm1.dt ))])  ' : ' num2str(hm2.dt)];
        msg{end+1,1}=['BOUNDING BOX'];
        dum= plog([],[;num2cell(BB1) repmat({' | '},[2 1]) num2cell(BB2)],0,'','s=0;style=1');
        msg=[msg; dum];
        msg{end+1,1}=['MAT'];
        dum= plog(msg,[;num2cell(hm1.mat) repmat({' | '},[4 1]) num2cell(hm2.mat)],0,'','s=0;style=1');
        msg=[msg; dum];
        disp(char(msg));
        
        %% end
        
        
        if isempty(ref)
            refimg=  source ; [pax3,fi3 ext3]=fileparts(refimg);     name3=[fi3 ext3];
        else
            refimg=  ref    ; [pax3,fi3 ext3]=fileparts(refimg);     name3=[fi3 ext3];
        end
        
        if r.showit==1
            rmricron(fileparts(h1), name1,name3 , 0,[20 -1]);
        end
        
        %         disp([' check: <a href="matlab: rmricron([],''' h2 ''',''' fout ''' , 1,[20 -1])">' '[' name1 ']' '</a>']);
        
        disp([...
            ' OVL([o+r]) <a href="matlab: rmricron([],''' fout ''',''' h2 ''' , 0,[20 -1])">' '[' name1 ']' '</a>;' ...
            ' OVL([r+o]) <a href="matlab: rmricron([],''' h2 ''',''' fout ''' , 0,[20 -1])">' '[' name1 ']' '</a> ' ...
            ' or explorer <a href="matlab: explorer(''' fileparts(fout) ''')">' '[' pax1short ']' '</a>']);
        
        disp([' copy filename to clipboard <a href="matlab:  clipboard(''copy'',[''''''' fout '''''''])  ">' '[' name1 ']' '</a>;']);

        
        
    end
    
    % UPDATE LISTBOX-MSG
    %disp('processing done');
    hinfo=findobj(gcf,'tag','info');
    msg=get(hinfo,'string');
    msg=[msg;{['<HTML><FONT color="#ff00ff"><b>..DONE</Font></html>']}];
    set(hinfo,'string',msg,'value',size(msg,1));

    
end% JJ
