
% get referenrence path for templates
% function [ref ]=getReferencePath

function [ref ]=getReferencePath
ref=[];

us.animals= {'mouse' ,'rat','etruscianshrew'};
makefigure(us);


% return
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
    [t,sts] = spm_select(1,'dir','select reference path','',paextern, '.*');
    if sts==0;
        set(findobj(gcf,'tag','edpath'),'string',[us.pathSTR0 ]);
        return;
    end
    if strcmp(t(end),filesep)
        t=t(1:end-1) ;
    end
    
    % using recursion to find 'AVGT.nii'
    [files,dirs] = spm_select('FPListRec',t,[ '^AVGT.nii$']);
    files=cellstr(files);
    dirs=strrep(files,[filesep 'AVGT.nii'],'');
    
    if isempty(char(files))
        warndlg({...
            'NO TEMPLATE SELECTED' ...
            'The selected folder is not a template folder.'...
            ['..."AVGT.nii" not found in folder: "' t '"' ]...
            ['Select another template.']...
            },'!! Warning !!','modal');
        return
    end
    
    dirs=dirs{1};
    dirsshort=replacefilepath(dirs,'');
    t=dirs;
    if strcmp(t(end),filesep)
        t=t(1:end-1) ;
    end
    
    msg={[us.pathSTR  dirsshort  ]
        ['path: '  fileparts(t)   ]
        };
    
else
    %t=get(e,'userdata');
    fp=get(e,'userdata');
    va=get(e,'value');
    li=get(e,'string');
    
    t=fp{va};
    msg={[us.pathSTR  li{va}   ]  
         ['path: '  fileparts(t)   ]  
         };
    
end


% t=cellstr(t)
infofile=fullfile(t,'parameter.m');
if exist(infofile)==2
    run(infofile)
    
    hs=findobj(gcf,'tag','species');
    li=get(hs,'string');
    set(hs,'value',regexpi2(li,species));
    
    if exist('voxsize')
        us.voxsize=voxsize;
        msg{end+1,1}=sprintf('default voxel-size: [%2.3f %2.3f %2.3f] mm',us.voxsize);
    end
else
    disp(['parameterfile not found: ' infofile]) ;
    disp(['please check the following fields [voxelsize],[species]']);
    
end
set(findobj(gcf,'tag','edpath'),'string',[ msg']);
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

% ==============================================
%%   
% ===============================================


try; delete(findobj(gcf,'tag','species')); end

fg;
set(gcf,'menubar','none','units','norm','position',[0.5222    0.5489    0.3646    0.2972]);%[ 0.4573    0.5694    0.2365    0.2972]);
set(gcf,'name',['template-reference path [' mfilename ']' ],'NumberTitle','off','tag','setAtlasReference');
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
% info
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
set(hu,'string',(lg),'HorizontalAlignment','left','position',[.005 .55 1-.005 .45])
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
    
    
    % using recursion to find 'AVGT.nii'
    [files,dirs] = spm_select('FPListRec',paextern,[ '^AVGT.nii$']);
    files=cellstr(files);
    dirs=strrep(files,[filesep 'AVGT.nii'],'');
    dirsshort=replacefilepath(dirs,'');
    %%  regexpi2({'ee' '#ee' '@ee' '__w'}, '^[#|@|_]' )
    idel=regexpi2(dirsshort, '^[#|@|_]' );
    dirs(idel)     =[];
    dirsshort(idel)=[];
    
    if ~isempty(dirs)
        hb=uicontrol('style','listbox','units','norm','position',[ 0 0 .5 .5]);
        %set(hb,'position',[ 0.45 0.1 .55 .44]);
        set(hb,'position',[ 0.005 0.1 .5 .44]);

        set(hb,'string',dirsshort);
        
        set(hb,'tooltipstring',[ ...
            '<html><font color="green"><b> Found templates (references) in the anttemplates-folder </b><br>' ...
            '<font color="blue"> select the proper template here <br>'...
             '<font color="black"> The selected template is then used as reference in this project. '...
            '</font></html>'
            ]);
         set(hb,'userdata',dirs,'callback' ,{@useotherref,0});
        
    end %non-empty-dir
    
    if 0 %old-button-style
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
            j=1;
            do=0.025;
            ri=.5;
            
            
            if ~isempty(dirs)
                k=length(dirs);
                downlowest=0.1600;
                nbuts=k+1 ;% atlases+select other button
                %nbuts=13
                ncols=(nbuts-mod(nbuts,2))/2-1;
                if mod(nbuts,2)==1; ncols=ncols+1; end
                
                %stepdown=0.05;
                stepdown=((.42+do)-downlowest)./ncols;
                
                delete(findobj(gcf,'tag','pbref'));
                for j=1:k
                    if mod(j,2)==1; ri=.005; else ri=0.5; end
                    
                    hu2=uicontrol('style','push','units','norm','tag','pbref');
                    set(hu2,'position',[ri .42+do, .49 stepdown],'string',[' [' num2str(j) '] ' dirsshort{j} ] ,...
                        'callback' ,{@useotherref,0});
                    set(hu2,'TooltipString',['<html>' 'use this reference template/atlas' '<br /><i><b><font color="green">' dirs{j}  '</font></b></i></html>'])
                    set(hu2,'userdata',dirs{j},'fontsize',fs-1);
                    % set(hu2,'HorizontalAlignment','left');
                    % [' [' num2str(j) '] -' char(70+round(rand(1,10)*10)) ]
                    if mod(j,2)==0; do=do-stepdown;end
                end
            end
            % ==============================================
            %%
            % ===============================================
        end %non-empty-dir
    end  %old-button-style
    
end

% ==============================================
%%   select reference manually
% ===============================================

if 0 %OLD STYLE
    j=j+1;
    if mod(j,2)==1; ri=.005; else ri=0.5; end
    hu2=uicontrol('style','push','units','norm','tag','pbref');
    set(hu2,'position',[ri .42+do, .49 stepdown],'string', 'select another reference' ,...
        'callback' ,{@useotherref,1},'fontsize',fs-1,'foregroundcolor','b');
    set(hu2,'TooltipString',['select reference folder manually']);
end

hu2=uicontrol('style','push','units','norm','tag','pbref');
set(hu2,'position',[.3 .42, .49 .08],'string', 'select another reference' ,...
    'callback' ,{@useotherref,1},'fontsize',fs-1,'foregroundcolor','b');
set(hu2,'position',[.005 .0, .5 .08]);
set(hu2,'TooltipString',['select reference folder manually']);
set(hu2,'tooltipstring',[ ...
    '<html><font color="green"><b> Select a template (reference) manually </b><br>' ...
    '<font color="blue"> select a template from local drive/network <br>'...
    '<font color="black"> The selected template is then used as reference in this project. '...
    '</font></html>'
    ]);


% [' [' num2str(j) '] -' char(70+round(rand(1,10)*10)) ]
% if mod(j,2)==0; do=do-stepdown;end
if 0
    hu=uicontrol('style','push','units','norm');
    set(hu,'position',[.05 .3, .45 .1],'string','"choose reference"','callback' ,{@useotherref,0});
    set(hu,'position',[.005 .1, .25 .08]);
end


% ==============================================
%%   selected template indicator
% ===============================================
hu=uicontrol('style','text','units','norm');
set(hu,'position',[.01 .1, .8 .06],'string',us.pathSTR0,'fontsize',8,'backgroundcolor','w',...
    'foregroundcolor',[.5 .5 .5],'HorizontalAlignment','left','tag','edpath');
set(hu,'position',[ 0.5100    0.3000    0.4900    0.2000]);
set(hu,'tooltipstring',[ ...
    '<html><font color="green"><b> Currently selected template </b><br>' ...
    '<font color="black"> This template will be used as reference in this project. '...
    '</font></html>'
    ]);

% ==============================================
%%   animal
% ===============================================
animals=us.animals;
hu=uicontrol('style','popupmenu','units','norm');
set(hu,'position',[.1 .1, .4 .1],'string',animals,'TooltipString','select species here');
set(hu,'tag','species','fontsize',fs);
set(hu,'position',[.005 .02, .25 .08]);
set(hu,'position',[0.5100    0.2000    0.2500    0.0800]);

set(hu,'tooltipstring',[ ...
    '<html><font color="green"><b> Species of the currently selected template.  </b><br>' ...
    '<font color="blue"> Usually, the species is auto-detected, so no need to modify this..  <br>'...
    '<font color="black"> If modified, the selected species-type will override the detected species-type'...
    '</font></html>'
    ]);


hu=uicontrol('style','push','units','norm');
set(hu,'position',[.7 .02, .15 .08],'string','OK','TooltipString','Use this template as reference in this project','tag','ok')
set(hu,'callback',{@finish,1},'fontsize',fs);
set(hu,'position',[.68 .02, .15 .08]);

hu=uicontrol('style','push','units','norm');
set(hu,'position',[.55 .02, .15 .08],'string','Cancel','TooltipString','Cancel');
set(hu,'callback',{@finish,0},'fontsize',fs);
set(hu,'position',[.84 .02, .15 .08]);


