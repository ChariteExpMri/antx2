% determine orientation for an image relative to a reference image
% the selected orientation-id can be used in the  #r parameter settings file, field: 'orientType'
% [id rotstring]=getorientation(varargin)
%
% #g MANUAL MODE
% if in manual mode, the rotations of the last row can be modified manually. For this, click one of the
% images and enter three rotations values.
% 
% 
% #b pairwise parameter input:
% ref: reference image
% img: image to use
% #b optional inputs
% info: string placed in the figure title, such as a directory name, default: empty
% wait: [0,1] waiting mode, default figure waits [1]
% mode: [1,2] mode of orientation , default:  [1]
%         [1]: img is oriented using orientation table, ref-img remains static
%              -aim: how to get the ref-image to the img-orientation
%         [2]: img remains static, ref-img is oriented using orientation table
%              -aim: how to get the ref image to the img-orientation
%         [1]&[2] produce the same results, [1] is faster than [2]
% rot : cell array of rotations such as {'pi/2 pi pi'; '0 0 0'; '0 pi 0'}
%       if not specified rot-table from findrotation2 is used
% disp: displaymodus [1] (default), fast version
%                    [2] slower version
% colormap: (string) one of matalb colormaps (default: 'parula')
% manualmode: [0,1]: if [1] the last row allows a manual selection of rotation parameters
% 
% 
% #b output
% id       : selected num-id based on 'findrotation2'-table --> see 'findrotation2'
% rotstring: rotation parameter (pitch,roll,ywa)-> see 'spm_matrix'
%
% #b usage
% select the orientation type (radio) with the best match between image and ref image
% #b example
% [id rotstring]=getorientation; % use file selection via gui
% [id rotstring]=getorientation('ref',ref,'img',f1); % ref image and image defined
% [id rotstring]=getorientation('ref',refimg,'img',img,'info', name,'mode',2,'wait',0,'rot',rot(1:3),'disp',1);


function [id rotstring]=getorientation(varargin)

% tic
%==============================================================
if 0 %test
    ref='O:\data5\ct_magdeburg2\templates\AVGT.nii'
    f1='O:\data5\fun_getorientation\dat\m06_1\t2.nii'
    [id rotstring]=getorientation('ref',ref,'img',f1,'info', 'f1','mode',2,'wait',0);
    
end

%==============================================================


s = {varargin{:}};
p = cell2struct(s(2:2:end),s(1:2:end),2);

if isfield(p,'wait')==0;          p.wait=1; end
if isfield(p,'mode')==0;          p.mode=1; end
if isfield(p,'info')==0;          p.info=''; end
if isfield(p,'rot')==0;           p.rot=''; end
if isfield(p,'disp')==0;          p.disp=1; end
if isfield(p,'colormap')==0;      p.colormap='parula'; end
if isfield(p,'manualmode')==0;    p.manualmode=1; end
if isfield(p,'slices')==0;        p.slices=5; end

if isfield(p,'img')==0 || isempty(p.img)
    [t,sts] = spm_select(1,'image','select image',[],pwd,'.*.nii',1);
    p.img=t;
end
if isfield(p,'ref')==0 || isempty(p.ref)
    [t,sts] = spm_select(1,'image','select reference image',[],pwd,'.*.nii',1);
    p.ref=t;
end

if isempty(p.rot)
    [arg,rot]=evalc(['' 'findrotation2' '']);
    %rot=rot(1:3);
else
    rot=p.rot;
end

% check files
filesOK=1;
if isempty(p.ref)
    filesOK=0;
end
if isempty(p.img)
    filesOK=0;
end

if filesOK==0
    %% this
    errlog=[ 'examine orientation[' mfilename '.m] aborted..' char(10)...
        'PROBLEM: source and reference image must be specified' char(10) ...
        'SOLUTION:' char(10) ...
        '  1) Check existence of the "templates"-folder in the study-folder.' char(10)...
        '     otherwise: create templates (MAIN/create study templates)' char(10)...
        '     The "AVGT.nii" image in the "templates"-folder is the reference-image per default.. thus, there is no need to specify the reference image.'  char(10)...
        '  2) Select the proper source image (ie. a structural image such as "t2.nii").' char(10)...
        ];
   error(errlog ) ;
   %% this end
   id='';
   rotstring='';
   return
end


% ================================================================
%% temporary 
% if 0
%    p.wait=0; 
% end

%==================================================================

% ref='V:\Graham\mpm_pilot_19\antanalysis2\templates\AVGT.nii'
% f1='I:\AG_Wu\studyLo\analysis_2jul19\dat\m05_3\t2.nii'
% ref='O:\data5\ct_magdeburg2\templates\AVGT.nii'

% f1='I:\AG_Wu\studyLo\analysis_2jul19\dat\m17_1\t2.nii'
% f1='O:\data5\fun_getorientation\dat\m06_1\t2.nii'

% o=get_orthoview(ref,[0 0 0 0 0 0],1);
% rotm=str2num(char(rot{10}))
% o=get_orthoview(ref,[0 0 0 rotm],1);
% o=get_orthoview(f1,[0 0 0 ],1);
% o=get_orthoview(ref,[0 0 0 rotm],1);
% o=get_orthoview(f1,[0 0 0 ],1);

delete(findobj(0,'tag','findorientation'));


%add manual rotation
rot{end+1,1}='0 0 0';
np=size(rot,1);


[hs, rb] =axslider2([np 6],  'checkbox',6,'selection','single' );%  %[5x4 pannel], each 4th image gets a checkbox, singleSelection
%    [hs rb] =axslider2([5 4],  'checkbox',2,'selection','multi' );%  %[5x4 pannel], each 2nd image gets a checkbox, numtiSelection
%
set(gcf,'name','..BUSY..WAIT', 'NumberTitle','off');
set(gcf,'KeyPressFcn',@keysx);
set(rb,'fontsize',6);
for i=1:length(rb)
    pos=get(rb(i),'position');
    set(rb(i),'position',[pos(1:2) .1 0.03]);
end

%% ================================
% reverse
% fg

nax=0;

if p.mode==2
    ref=p.ref;
    p.ref=p.img;
    p.img=ref;
end


p.rot =rot;
p.np  =np;
p.hs  =hs;
p.rb  =rb;
set(gcf,'userdata',p);


for i=1:np
    plotimage(i);  
end
colormap gray;
set(gcf,'menubar','none','NumberTitle','off','name',['Select Orientation: '  char(p.info) ],...
    'tag','findorientation');


%========== controls ===============================

hu=uicontrol('style','pushbutton','units','norm');
set(hu,'position',[.65 0 .1 .04],'string','Help','tooltipstring','further information');
set(hu,'callback',@cb_help);

hu=uicontrol('style','pushbutton','units','norm');
set(hu,'position',[.75 0 .1 .04],'string','OK','tooltipstring','close gui finished');
set(hu,'callback',@cb_ok);

%colormap
colmaps={'gray'  'parula' 'jet' 'hsv' 'hot' 'cool' 'spring' 'summer' 'autumn' 'winter' 'bone' 'copper'};
colnum=1;
try;     colnum=find(strcmp(colmaps,p.colormap)); end
hu=uicontrol('style','popupmenu','units','norm');
set(hu,'position',[.55 0 .1 .04],'string',colmaps,...
    'tooltipstring','change colormap or use keys [c] or [shift+c] to cycle between cmaps',...
    'fontsize',7,'value',colnum);
set(hu,'callback',@cb_colormap,'tag','cb_colormap');
cb_colormap([],[]);


hu=uicontrol('style','edit','units','norm');
set(hu,'position',[.51 0 .04 .04],'string',num2str(p.slices) ,'tooltipstring','number of slices used for max projection');
set(hu,'callback',@cb_numberSlices,'tag','cb_numberSlices','fontsize',7);

set(gcf,'userdata',p);

%========== waiting mode ===============================
if p.wait==1
    uiwait(gcf);
end


%========== output ===============================
try
    p=get(gcf,'userdata');
    rot=p.rot;
    
    ic=findobj(gcf,'tag','chk1','-and','visible','on','-and','value',1);
    id       =[];
    rotstring='';
    if ~isempty(ic)
        string=get(ic,'string');
        id        = str2num(strtok(string,')'));
        rotstring = rot{id};
        
    end
catch
    rotstring='';
    id      =[];
    return
end

%========== close win ===============================

if p.wait==1
    delete(findobj(0,'tag','findorientation'));
end



%================================================
%% SUBS
function keysx(e,e2)

if strcmp(e2.Key,'c')
    if  ~isempty(e2.Modifier) && strcmp(e2.Modifier{1},'shift')
        add=-1;
    else
    add=+1;
    end
    hcb=findobj(gcf,'tag','cb_colormap');
    va=get(hcb,'value')+add;
    if va>length(get(hcb,'string')); va=1;                        end
    if va<1;                         va=length(get(hcb,'string')); end
    set(hcb,'value',va);
    cb_colormap([],[]);
end




function cb_colormap(e,e2)
e=findobj(gcf,'tag','cb_colormap');
li=get(e,'string');
va=get(e,'value');
eval(['colormap ' li{va} ';']);



function cb_ok(e,e2)
us=get(gcf,'userdata');

if us.wait==1
    ic=findobj(gcf,'tag','chk1','-and','visible','on','-and','value',1);
    if isempty(ic)
        msgbox('please select an orientation','','','','','modal');
    else
        uiresume(gcf);
    end
else
    close(gcf);
end

function cb_help(e,e2)
uhelp('getorientation.m');


















function plotimage(i)

p=get(gcf,'userdata');
%de-pack
rot=p.rot;
hs =p.hs;
rb =p.rb;

ipl=length(p.hs)./p.np; %IMAGE PER LINE

rotm   = str2num(char(rot{i}));
vecinv = spm_imatrix(inv(spm_matrix([0 0 0 rotm 1 1 1 0 0 0])));
rotinv = vecinv(4:6);

%p.mode=2; %mode what is rotated [1] img is rotated [2] ref is rotated

%     if p.mode==1
o = get_orthoview(     p.img,[0 0 0 rotinv],0,'max',p.slices);
if i==1
    u = get_orthoview( p.ref,[0 0 0 ],0,'max',p.slices);
    u.imgc=imadjust(mat2gray(u.imgc));
    u.imgs=imadjust(mat2gray(u.imgs));
    u.imgt=imadjust(mat2gray(u.imgt));
end

o.imgc=imadjust(mat2gray(o.imgc));
o.imgs=imadjust(mat2gray(o.imgs));
o.imgt=imadjust(mat2gray(o.imgt));



%     elseif p.mode==2
%         o = get_orthoview(     p.img,[0 0 0     ],0,'max',5);
%         %         if i==1
%         u = get_orthoview( p.ref,[0 0 0 rotm],0);
%         %         end
%
%
%     end


%
%     nax=nax+1;     axes(hs(nax));
%     imagesc(o.imgc);
%     set(gca,'ydir','normal');
%     vline(o.cent(2)-o.bb(1,2)+1,'color','r');
%     hline(o.cent(3)-o.bb(1,3)+1,'color','r');
%     axis off;
%     rotnumstr=get(rb(nax),'string');
%     cpos= get(rb(nax),'position');
%     set(rb(nax),'position',[cpos(1) cpos(2) .2 cpos(4)]) ;
%     set(rb(nax),'string', [ get(rb(nax),'string') ')  ' char(rot{i})   ]  );
%
%
%     nax=nax+1;     axes(hs(nax));
%     imagesc(o.imgs);
%     set(gca,'ydir','normal');
%     vline(o.cent(2)-o.bb(1,2)+1,'color','r');
%     hline(o.cent(3)-o.bb(1,3)+1,'color','r');
%     axis off;
%
%     nax=nax+1;     axes(hs(nax));
%     imagesc(o.imgt);
%     set(gca,'ydir','normal');
%     vline(o.cent(2)-o.bb(1,2)+1,'color','r');
%     hline(o.cent(2)-o.bb(1,2)+1,'color','r');
%     axis off;



if p.disp==1
    
    if 1%p.mode==1
        nax=ipl*i-ipl+1 ; 
        %nax=nax+1;  
        
        axes(hs(nax));
        imagesc(o.imgc);
        set(gca,'ydir','normal');
        vline(o.cent(2)-o.bb(1,2)+1,'color','r');
        hline(o.cent(3)-o.bb(1,3)+1,'color','r');
        axis off;
        %rotnumstr=get(rb(nax),'string');
        cpos= get(rb(nax),'position');
        %             set(rb(nax),'position',[cpos(1) cpos(2) .2 cpos(4)]) ;
        %set(rb(nax),'string', [ get(rb(nax),'string') ')  ' char(rot{i})   ]  ,...
        %    'tooltipstring', [ get(rb(nax),'string') ')  ' char(rot{i})   ]  );
        
        rbstring=[ num2str(i)  ')' char(rot{i}) ];
        set(rb(nax),'string',rbstring, 'tooltipstring', rbstring);
        
         nax=ipl*i-ipl+2 ;    
        axes(hs(nax));
        imagesc(o.imgs);
        set(gca,'ydir','normal');
        vline(o.cent(2)-o.bb(1,2)+1,'color','r');
        hline(o.cent(3)-o.bb(1,3)+1,'color','r');
        axis off;
        
         nax=ipl*i-ipl+3 ;   
        axes(hs(nax));
        imagesc(o.imgt);
        set(gca,'ydir','normal');
        vline(o.cent(2)-o.bb(1,2)+1,'color','r');
        hline(o.cent(2)-o.bb(1,2)+1,'color','r');
        axis off;
        
        % callback for manual orientation
        if p.manualmode==1
            if i==p.np
                hi=[findobj(hs(ipl*i-ipl+1),'type','image')
                    findobj(hs(ipl*i-ipl+2),'type','image')
                    findobj(hs(ipl*i-ipl+3),'type','image')];
                set(hi,'ButtonDownFcn',@cb_manualinput);
                
                nax=ipl*i-ipl+1; 
                set(rb(nax),'backgroundcolor',[ 1.0000    0.8431         0]);
                
                
              rbstring=[ num2str(nax)  ')' char(rot{i}) char(10) '***MANUAL MODE**' char(10) '..click image to change rotation...'];
              set(rb(nax),'tooltipstring', rbstring);
              
%             ttmm=get(rb(nax),'tooltipstring');    
%                 if isempty(strfind(ttmm,char(10)))
%                    % ttmm=['***MANUAL MODE**' char(10) '..click image to change rotation...' char(10) ttmm];
%                       ttmm=[ttmm char(10) '***MANUAL MODE**' char(10) '..click image to change rotation...' ];
%                 end
%                 set(rb(nax),'tooltipstring',ttmm);
            end
        end
        
        
        if i==1
            nax=ipl*i-ipl+4 ;      
            pos2=get(hs(nax),'position');
            axa=axes('position',pos2,'tag','axa');
            imagesc(u.imgc);
            set(gca,'ydir','normal');
            vline(u.cent(2)-u.bb(1,2)+1,'color','r');
            hline(u.cent(3)-u.bb(1,3)+1,'color','r');
            axis off;
            vline(1,'color','w','linewidth',2);
            axis off;
            set(hs(nax),'visible','off');
            
            
             nax=ipl*i-ipl+5 ;   
            pos2=get(hs(nax),'position');
            axa=axes('position',pos2,'tag','axa');
            imagesc(u.imgs);
            set(gca,'ydir','normal');
            vline(u.cent(2)-u.bb(1,2)+1,'color','r');
            hline(u.cent(3)-u.bb(1,3)+1,'color','r');
            axis off;
            set(hs(nax),'visible','off');
            
             nax=ipl*i-ipl+6 ;   
            pos2=get(hs(nax),'position');
            axa=axes('position',pos2,'tag','axa');
            imagesc(u.imgt);
            set(gca,'ydir','normal');
            vline(u.cent(2)-u.bb(1,2)+1,'color','r');
            hline(u.cent(2)-u.bb(1,2)+1,'color','r');
            axis off;
            set(hs(nax),'visible','off');
            
        else
            for j=1:3
               % nax=nax+1; 
                nax=ipl*i-ipl+3+j ; 
                axes(hs(nax));
                set(hs(nax),'visible','off');
            end
        end
        
        
    end
    
    
else% no-fast
     nax=ipl*i-ipl+1 ; 
    %nax=nax+1;     
    axes(hs(nax));
    imagesc(o.imgc);
    set(gca,'ydir','normal');
    vline(o.cent(2)-o.bb(1,2)+1,'color','r');
    hline(o.cent(3)-o.bb(1,3)+1,'color','r');
    axis off;
    rotnumstr=get(rb(nax),'string');
    cpos= get(rb(nax),'position');
    set(rb(nax),'position',[cpos(1) cpos(2) .2 cpos(4)]) ;
    set(rb(nax),'string', [ get(rb(nax),'string') ')  ' char(rot{i})   ] ,...
        'tooltipstring' , [ get(rb(nax),'string') ')  ' char(rot{i})   ]  );
    
    
     nax=ipl*i-ipl+2;   
    axes(hs(nax));
    imagesc(o.imgs);
    set(gca,'ydir','normal');
    vline(o.cent(2)-o.bb(1,2)+1,'color','r');
    hline(o.cent(3)-o.bb(1,3)+1,'color','r');
    axis off;
    
     nax=ipl*i-ipl+3 ;    
    axes(hs(nax));
    imagesc(o.imgt);
    set(gca,'ydir','normal');
    vline(o.cent(2)-o.bb(1,2)+1,'color','r');
    hline(o.cent(2)-o.bb(1,2)+1,'color','r');
    axis off;
    
    
    if 1 % REF IMG
         nax=ipl*i-ipl+4 ; 
        axes(hs(nax));
        imagesc(u.imgc);
        set(gca,'ydir','normal');
        vline(u.cent(2)-u.bb(1,2)+1,'color','r');
        hline(u.cent(3)-u.bb(1,3)+1,'color','r');
        axis off;
        vline(1,'color','w','linewidth',2);
        
         nax=ipl*i-ipl+5 ;      
        axes(hs(nax));
        imagesc(u.imgs);
        set(gca,'ydir','normal');
        vline(u.cent(2)-u.bb(1,2)+1,'color','r');
        hline(u.cent(3)-u.bb(1,3)+1,'color','r');
        axis off;
        
        nax=nax+6;    
        axes(hs(nax));
        imagesc(u.imgt);
        set(gca,'ydir','normal');
        vline(u.cent(2)-u.bb(1,2)+1,'color','r');
        hline(u.cent(2)-u.bb(1,2)+1,'color','r');
        axis off;
    end
end




function cb_manualinput(e,e2)

p=get(gcf,'userdata');

if p.manualmode==1
    prompt = {'Enter rotations (3 values):'};
    dlgtitle = 'Input';
    dims = [1 35];
    definput = {p.rot{end}} ;%{'0 0 0'};
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    if isempty(answer); return; end
    if iscell(answer)
        thisrot=answer{1};
    else
        thisrot=answer;
    end
    
    p.rot(end,1)={thisrot};
    set(gcf,'userdata',p);
    plotimage(p.np);
    
    ipl=length(p.hs)./p.np;
    
     hrb=p.rb(length(p.rb)-ipl+1);
     set(hrb,'backgroundcolor','r', 'string',[num2str(p.np) ') ' thisrot],...
         'tooltipstr',[num2str(p.np) ') ' thisrot]);
     
     
     ttmm=get(hrb,'tooltipstring');
     if isempty(strfind(ttmm,char(10)))
         % ttmm=['***MANUAL MODE**' char(10) '..click image to change rotation...' char(10) ttmm];
         ttmm=[ttmm char(10) '***MANUAL MODE**' char(10) '..click image to change rotation...' ];
     end
     set(hrb,'tooltipstring',ttmm);
end




function cb_numberSlices(e,e2)
hmsg=findobj(gcf,'tag','msg'); %messagebox
msg.txt=get(hmsg,'string');
msg.bgcol=get(hmsg,'backgroundcolor');
msg.fgcol=get(hmsg,'foregroundcolor');
msg.fontweight=get(hmsg,'fontweight');


set(hmsg,'string','..busy..','foregroundcolor',[0.9294    0.6941    0.1255],'fontweight','bold',...
    'backgroundcolor',[1 0 0]);

hn=findobj(gcf,'tag','cb_numberSlices');
ns=get(hn,'string');
ns=str2num(ns);
if isnumeric(ns)
    p=get(gcf,'userdata');
    p.slices=ns;
    set(gcf,'userdata',p);
end

for i=1:p.np
    plotimage(i);  
end

set(hmsg,'string',msg.txt,'foregroundcolor',msg.fgcol,'fontweight',msg.fontweight,...
    'backgroundcolor',msg.bgcol);














