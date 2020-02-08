
% get referenrence path for templates
% function [ref ]=getReferencePath

function [ref ]=getReferencePath
ref=[];

us.animals= {'mouse' ,'rat','etruscianshrew'};
makefigure(us);

uiwait(gcf);
% -------------
us=get(findobj(gcf,'tag','setAtlasReference'),'userdata') ;





if ~isempty(us) && isfield(us,'isOK')==1 && us.isOK==1
    
    hsp=findobj(gcf,'tag','species');
    va=get(hsp,'value');
    li=get(hsp,'string');
    ref.species=li{va};  %species
    
    %     ref.path=get(findobj(gcf,'tag','edpath'),'string');
    %     ref.path=strrep(ref.path,'ref path: - ','');
    ref.path=us.refpath;
    try;     ref.voxsize =us.voxsize; end

    if isempty(ref.path)
        ref=[];
    end
end


close(gcf);


% ==============================================
%%   subs
% ===============================================


function finish(e,e2,arg)
us=get(gcf,'userdata');
if arg==1;    us.isOK=1;
else          us.isOK=0;
end
set(gcf,'userdata',us);
uiresume(gcf);



function useotherref(e,e2,useotherref)
us=get(gcf,'userdata');
paextern=fullfile( fileparts(fileparts(fileparts(fileparts(which('ant'))))), 'anttemplates');
if exist(paextern)~=7
    paextern=fileparts(paextern);
    
end
    
if useotherref==1
    [t,sts] = spm_select(1,'dir','select reference path','',paextern, '.*','');
    if sts==0;
        set(findobj(gcf,'tag','edpath'),'string',[us.pathSTR0 ]);
        return;
    end
    if strcmp(t(end),filesep)
        t=t(1:end-1) ;
    end
else
    t=get(e,'userdata');
    
end


% t=cellstr(t)
set(findobj(gcf,'tag','edpath'),'string',[us.pathSTR t]);
infofile=fullfile(t,'parameter.m');
if exist(infofile)==2
    run(infofile)
    
    hs=findobj(gcf,'tag','species');
    li=get(hs,'string');
    set(hs,'value',regexpi2(li,species));
    
    if exist('voxsize')
        us.voxsize=voxsize;
    end
else
   disp(['parameterfile not found: ' infofile]) ;
   disp(['please check the following fields [voxelsize],[species]'])
    
end
us.refpath=t;
set(gcf,'userdata',us);


function templateBerlinIntern(e,e2);
us=get(gcf,'userdata');

refpath=fullfile(antpath('antpath'),'templateBerlin_hres');

set(findobj(gcf,'tag','edpath'),'string',['ref path: ' refpath]);
hs=findobj(gcf,'tag','species');
li=get(hs,'string');
set(hs,'value',regexpi2(li,'mouse'));

us.refpath=refpath;
set(gcf,'userdata',us);




function makefigure(us)

try; delete(findobj(gcf,'tag','species')); end

fg;
set(gcf,'menubar','none','units','norm','position',[0.5222    0.5489    0.3646    0.2972]);%[ 0.4573    0.5694    0.2365    0.2972]);
set(gcf,'name','template-reference path','NumberTitle','off','tag','setAtlasReference');
us.isOK   =0;
us.pathSTR0  ='Reference: <empty>';
us.pathSTR   ='Reference: ';
us.refpath=[];
set(gcf,'position',[0.5222    0.5489    0.4    0.2972]);
set(gcf,'userdata',us);

fs=9;

hu=uicontrol('style','edit','units','norm');
set(hu,'min',0,'max',2,'enable','inactive');
set(hu,'position',[.05 .5, .9 .4],'string','"templateBerlin_hres" from ant-tbx');

% ==============================================
%%   
% ===============================================

set(hu,'string',['sss' char(10) 'eee'])

lg={['***  SELECT THE REFERENCE SYSTEM (reference template folder). *** ' ]... char(10) ...
    [repmat('=',1,60)]...
    ['This reference folder contains the template, atlas and tissue compartments.']  ...
    ['# Please note that the original refernce templates folder is relocated and no longer within the ANT-TBX.  ']...
    [   'This allows to use other references (templates/atlases). Unfortunately, you have to specify the reference template ' ...
    'from now on.' ]... 
    [ 'It is recommended to create an "anttemplates" folder at the same location as the "ANTx-TBX" ' ...
    '(example: "o:\antx" where the tbx is located, and "o:\anttemplates" where the templates are located).'... 
    ' The "anttemplates" folder can contain different reference templates (organized in folders in the "anttemplates" folder).'...
    ]...
    []...
  };
set(hu,'string',(lg),'HorizontalAlignment','left','position',[.005 .5 1-.005 .5])
set(hu,'backgroundcolor','w','fontsize',fs-1);
% smart_scrollbars;


% ==============================================
%%   
% ===============================================




% hu=uicontrol('style','push','units','norm');
% set(hu,'position',[.1 .4, .8 .1],'string','"templateBerlin_hres" from ant-tbx','callback' ,@templateBerlinIntern);



paextern=fullfile( fileparts(fileparts(fileparts(fileparts(which('ant'))))), 'anttemplates');

j=1;
do=0;
ri=.5;

if exist(paextern)
    
    [files,dirs] = spm_select('FPList',paextern,'.*');
    if ~isempty(dirs)
        dirs=cellstr(dirs);
        dirsshort=replacefilepath(dirs,'');
        
        %%  regexpi2({'ee' '#ee' '@ee' '__w'}, '^[#|@|_]' )
        idel=regexpi2(dirsshort, '^[#|@|_]' );
        dirs(idel)     =[];
        dirsshort(idel)=[];
        
        % ==============================================
        %%
        % ===============================================
        
        if ~isempty(dirs)
            k=length(dirs);
            
            delete(findobj(gcf,'tag','pbref'));
            for j=1:k
                if mod(j,2)==1; ri=.005; else ri=0.5; end
                
                hu2=uicontrol('style','push','units','norm','tag','pbref');
                set(hu2,'position',[ri .42+do, .49 .08],'string',[' [' num2str(j) '] ' dirsshort{j} ] ,...
                    'callback' ,{@useotherref,0});
                set(hu2,'TooltipString',['<html>' 'use this reference template/atlas' '<br /><i><b><font color="green">' dirs{j}  '</font></b></i></html>'])
                set(hu2,'userdata',dirs{j},'fontsize',fs);
                % [' [' num2str(j) '] -' char(70+round(rand(1,10)*10)) ]
                if mod(j,2)==0; do=do-.08;end
            end
        end
        % ==============================================
        %%
        % ===============================================
end
    
    
end

% ==============================================
%%   select reference manually
% ===============================================

j=j+1;
if mod(j,2)==1; ri=.005; else ri=0.5; end
hu2=uicontrol('style','push','units','norm','tag','pbref');
set(hu2,'position',[ri .42+do, .49 .08],'string', 'select another reference' ,...
    'callback' ,{@useotherref,1},'fontsize',fs);
set(hu2,'TooltipString',['select reference folder manually'])

% [' [' num2str(j) '] -' char(70+round(rand(1,10)*10)) ]
if mod(j,2)==0; do=do-.08;end
if 0
    hu=uicontrol('style','push','units','norm');
    set(hu,'position',[.05 .3, .45 .1],'string','"choose reference"','callback' ,{@useotherref,0});
    set(hu,'position',[.005 .1, .25 .08]);
end


% ==============================================
%%   path indicator
% ===============================================
    hu=uicontrol('style','text','units','norm');
    set(hu,'position',[.01 .1, .8 .06],'string',us.pathSTR0,'fontsize',8,'backgroundcolor','w',...
        'foregroundcolor',[.5 .5 .5],'HorizontalAlignment','left','tag','edpath');
%     set(hu,'position',[.4 .1, .25 .08],'HorizontalAlignment','left');
    
    % hu=uicontrol('style','edit','units','norm');
    % set(hu,'position',[.3 .2, .65 .06],'string','"other reference" from ant-tbx');

% ==============================================
%%   animal
% ===============================================
animals=us.animals;
 

hu=uicontrol('style','popupmenu','units','norm');

set(hu,'position',[.1 .1, .4 .1],'string',animals,'TooltipString','select species here');
set(hu,'tag','species','fontsize',fs);
set(hu,'position',[.005 .02, .25 .08]);



hu=uicontrol('style','push','units','norm');
set(hu,'position',[.7 .02, .15 .08],'string','OK','TooltipString','ok, use this template reference','tag','ok')
set(hu,'callback',{@finish,1},'fontsize',fs);

hu=uicontrol('style','push','units','norm');
set(hu,'position',[.55 .02, .15 .08],'string','Cancel','TooltipString','cancel this');
set(hu,'callback',{@finish,0},'fontsize',fs);



