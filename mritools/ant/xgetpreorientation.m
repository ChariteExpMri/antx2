% #wb xgetpreorientation :obtain preorientation 
                                            
                   


function xgetpreorientation(showgui,x,pa)


%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui  =1               ;end
if exist('x')==0                           ;    x        =[]              ;end
if exist('pa')==0      || isempty(pa)      ;    pa       =[]              ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x        =[]  ;
end

if isempty(pa)
    pa=antcb('getsubjects');
end
[tb tbh v]=antcb('getuniquefiles',pa);


% ==============================================
%%   get preorientation
% ===============================================


if exist('x')~=1;        x=[]; end

p={...
    'inf1'      '_getPreOrientaion_             '                         '' ''
    'target'      {''}                    'reference image'            {@selectFile,v}
    'source'      {''}                    'source image'               {@selectFile,v}                   
 
 };
p=paramadd(p,x);




% %% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .5 .3 ],...
        'title',['***'  mfilename '***'],'info',{@uhelp,[ mfilename '.m']});
    try
    fn=fieldnames(z);
    catch
       return 
    end
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

%% ________________________________________________________________________________________________
xmakebatch(z,p, mfilename)


for i=1:length(pa)
    process( pa{i}, z);   
end
% delete(findobj(gcf,'tag','Graphics'));


function process( px, z); 


%% ===============================================

% f1=fullfile(px,mov);%,'t2w.nii');   % SOURCE Original
% f2=fullfile(px,fix);%'t1_fistIMG_001.nii'); % REFIMAGE

f1=char(fullfile(px,z.source));   % SOURCE   .. 't2w.nii');   
f2=char(fullfile(px,z.target));   % REFIMAGE .. 't1_fistIMG_001.nii'); 
h1=spm_vol(f1);
h2=spm_vol(f2);

do_delete=0;
delfiles={};
if length(h1)~=1
    [ha a]=rgetnii(f1);
    hx=ha(1);
    x=a(:,:,:,1);
    f1n=stradd(f1,'__1stimage',2);
    rsavenii(f1n, hx, x,64);
    if do_delete==1
        delfiles{end+1,1}=f1n;
    end
else
    f1n=f1;
end
if length(h2)~=1
    [ha a]=rgetnii(f2);
    hx=ha(1);
    x=a(:,:,:,1);
    f2n=stradd(f2,'__1stimage',2)
    rsavenii(f2n, hx, x,64);
    if do_delete==1
        delfiles{end+1,1}=f2n;
    end
else
    f2n=f2;
end

%% ===============================================
cprintf('*[0 0 1]',[ 'GET PREORIENTATION'  '\n'] );
cprintf('[0 0 1]',[ 'set the 3 landmarks in each volume.'  '\n'] );
cprintf('[0 0 1]',[ 'When done, select MRICRON from pulldown and click [check]-button to inspect the overlay.'  '\n'] );
cprintf('[0 0 1]',[ 'If the overlay is "ROUGHLY" OK, hit [CLOSE]-button.'  '\n'] );
%% ===============================================

p.f1=f1n;
p.f2=f2n;
p.info=''; % info
p.info='';
p.showlabels=0;
p.wait=1;              % busy mode
manuorient3points(p);  % execute function
%% ===============================================


if do_delete==1
    for i=1:length(delfiles)
        delete(delfiles{i})
    end
end

%% ===============================================
%  1.2246e-16 -1.2246e-16 -3.1416
% [0 0 -3.1416]


% cprintf('*[0 0 1]',[ 'Insert the three "ROTATON"-values in the "xcoreg"-preorientation-field'  '\n'] );
% showinfo2(['mpm-config file:' ],mpm.mpm_configfile);

%% ===============================================



 %% ___SUBS_____________________________________________________________________________________________
function out=selectFile(v)
out='';
%  sdirs=antcb('getsubjects') 
% [tb tbh v]=antcb('getuniquefiles',sdirs);
he=selector2(v.tb,v.tbh, 'out','col-1','selection','single');
if isempty(he) || (isnumeric(he) && he==-1); 
    out=[];
else
    out=he;
end
% paramgui('setdata','x.reorienttype','[]')












