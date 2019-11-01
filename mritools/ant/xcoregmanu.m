% #wb xcoregmanu : manually coregister images 
% A source image is manually registered to a target image. 
% The respective reorientation can be applied to the source image and other images
% via [reorient image] button.
% 
% #r (1) Please select the respective animals from ANT main gui (left panel) before calling this function
% #r (2) Don't forget do click the [reorient image] button and select the source image (and other images)
% #r     to apply theses changes (i.e. changes in the reorientation will be not applied to these images by
% #r     just clicking the "END" button)
% ________________________________________
% #wb PARAMETER
% 'target' : this is the reference image 
% 'source' : this is the moving image, which should finally match with the target
%
% #wb RUN function 
% xmergedirs  or xmergedirs(1); %      open gui
% xmergedirs(1,z); open gui with parameter settings
%
% #wb History
%  after running type anth or char(anth) or uhelp(anth) to get the parameter
% ________________________________________
% #wb EXAMPLE
% xcoregmanu(1,struct('target','t2.nii','source','RCT.nii'))  ;                                            
                   


function xcoregmanu(showgui,x,pa)


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


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  PARAMETER-gui
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if exist('x')~=1;        x=[]; end

p={...
    'inf1'      '••• manual registration  •••             '                         '' ''
    'target'      {''}                    'reference/static image'         {@selectFile,v}
    'source'      {''}                    'source/moving image'               {@selectFile,v}                   
 
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
delete(findobj(gcf,'tag','Graphics'));


function process( pa, z); 

% f1=fullfile(pwd,'RCT.nii')
% f2=fullfile(pwd,'t2.nii'); 
% displaykey3inv(f1,f2,1,struct('addautoregister',0,'addpreviousorients',0,'addreorientTPM',0,'addreorientIMG',1))
% 

source=char(z.source);
target=char(z.target);

f1=fullfile(char(pa),  source)  ;%source
f2=fullfile(char(pa),  target)  ;%reference (e.g. t2.nii)
existfile=[exist(f1)==2  exist(f2)==2];
if sum(existfile)~=2
    [~,name] =fileparts(pa);
    msg='';
   if existfile(1)  ==0; msg=[msg '[' source '] ' ]; end
   if sum(existfile)==0; msg=[msg ' & ' ]; end
   if existfile(2)  ==0; msg=[msg '[' target '] ' ]; end
   
   disp([ '[' name ']' ' skipped: missing files: ' msg]);
    return
end

p.addautoregister    = 0;
p.addpreviousorients = 0;
p.addreorientTPM     = 0;
p.addreorientIMG     = 1;
p.close              = 0;
displaykey3inv(f1,f2,1,p);




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












