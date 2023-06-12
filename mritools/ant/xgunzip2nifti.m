%% #k convert local *.gzip-files TO NIFTIs
%  xgunzip2nifti(showgui,x,pa)
% x-struct filds:
% gzfile:       ONE/MORE GZIP-FILES
% refIMG:       OPTIONAL: ref image such as "t2.nii", if exist, the header-information will be used 
% renamestring: if empty: use original filenme or enter new filename or prefix ("$p:pref_") or suffix ("$s:_suff")
% 
% 
%% EXAMPLE-1: CONVERT GZIP TO NIFTI ..USE HEADER OF REFERENCE IMAGE 
% z=[];                                                                                                                                                        
% z.gzfile       = { '_T4_400_ERV2_d14_t1.nii.gz' };     % % one or more gz-files                                                                              
% z.refIMG       = 't1.nii';                             % % OPTIONAL: ref image such as "t2.nii", if exist, the header-information will be used               
% z.renamestring = 'blob';                               % % if empty: use original filenme or enter new filename or prefix ("$p:pref_") or suffix ("$s:_suff")
% xgunzip2nifti(1,z);                                                                                                                                          
%                      
%% EXAMPLE-2: CONVERT GZIP TO NIFTI
% z=[];                                                                                                                                                        
% z.gzfile       = { '_T4_400_ERV2_d14_t1.nii.gz' };     % % one or more gz-files                                                                              
% z.refIMG       = 't1.nii';                             % % OPTIONAL: ref image such as "t2.nii", if exist, the header-information will be used               
% z.renamestring = 'blob';                               % % if empty: use original filenme or enter new filename or prefix ("$p:pref_") or suffix ("$s:_suff")
% xgunzip2nifti(1,z);                                                                                                                                          
                     



function xgunzip2nifti(showgui,x,pa)

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


%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
%% fileList
%refimage-file
if 1
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=unique(fi2);
end
%obj-file
if 1
    gfile={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii.gz$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        gfile=[gfile; fis];
    end
    gfile=unique(gfile);
end


ff={'v=v;'
    'v=flipud(fliplr(v));'
    'v=flipud(      v);'
    'v=fliplr(      v);'};

% ==============================================
%%   GUI
% ===============================================
if exist('x')~=1;        x=[]; end


p={...
    'inf97'    ''  '*** CONVERT LOCAL nii.gz-FILES'    ''
    'gzfile'     ''                'one or more gz-files' ...
    {@selector2,gfile,{'gzip-file'},'out','list','selection','multi','position','auto','info','gzip-file(s)'}
    'refIMG'      't1.nii'        'OPTIONAL: ref image such as "t2.nii", if exist, the header-information will be used' ...
    {@selector2,li,{'TargetImage'},'out','list','selection','single','position','auto','info','reference-image'}
    
%     'reorienttype'   [1]       'select reorientation type; click left icon for preview'                              {@checkorientation,pa,ff}
    'renamestring'   ''        'if empty: use original filenme or enter new filename or prefix ("$p:pref_") or suffix ("$s:_suff")'            {'' '$p:bla_'  '$s:_bla'}
    };

p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI

if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
        'figpos',[.15 .41 .56 .2 ],'title',[ 'CONFERT gzip-FILES [' mfilename ']'],'info',{@uhelp,[ mfilename '.m']}  );
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
%%   proc
% ===============================================
z.orient=ff;
for i=1:length(pa)
    proc(z,pa{i}) ;
end
disp('Done!');



function proc(z,pam)
%% ===============================================
z.gzfile=cellstr(z.gzfile);
pam=char(pam);
z.refIMG=char(z.refIMG);

for i=1:length(z.gzfile)
    [~,animal]=fileparts(pam);
    try; cprintf('*[0 0 1]',[ '[' animal ']' '\n'] );
    catch; disp([ '[' animal ']' ] );
    end
    
    f1=fullfile(pam,z.refIMG) ;
    f2=fullfile(pam,z.gzfile{i});
    
    if exist(f1)~=2
       disp('...reference image not found..convert to NIFTI without replacing the header'); 
    end
    
    if exist(f2)~=2
         disp([ '  !!!: refIMG: ' '"' z.refIMG '"' 'not found']);
%         if exist(f1)~=2 && exist(f2)==2
%             disp([ '  !!!: refIMG: ' '"' z.refIMG '"' 'not found']);
%         elseif exist(f1)==2 && exist(f2)~=2
%              disp([ '  !!!: gzfile: ' '"' z.gzfile{i} '"' ' not found']);
%         else
%             disp([ '  !!!: gzfile:' '"' z.gzfile{i} '" or refIMG:' '"' z.refIMG '" not found']);
%         end
            
    else
        
        
        f3=gunzip(f2);
        if iscell(f3); f3=char(f3); end
        [hx x]=rgetnii(f3);
        
        
%         [w1 w2]=obj2nifti(f2);
%         v=w2;
%         eval(z.orient{z.reorienttype});
        
        
        [~,outname]=fileparts(f2);
        outname=regexprep(outname,'.nii$','');
        if ~isempty(z.renamestring)
            if ~isempty(strfind(z.renamestring,'$p:'))
                str=regexprep(z.renamestring,{'\$p:' '\s+'},{''});
                outname=[ str outname];
            elseif ~isempty(strfind(z.renamestring,'$s:'))
                str=regexprep(z.renamestring,{'\$s:' '\s+'},{''});
                outname=[ outname str];
            else
                outname=z.renamestring;
            end
        end
        
        if isempty(f1) || exist(f1)~=2
            f4=fullfile(pam,[outname '.nii']);
            %try; delete(f4); end
            
            rsavenii(f4, hx, x,64);
            showinfo2('..saved Nifti: ',f4);
            
        else
            [hr r]=rgetnii(f1);
            f4=fullfile(pam,[outname '.nii']);
            try; delete(f4); end
            
            rsavenii(f4, hr, x,64);
            showinfo2('..saved Nifti: ',f1,f4,2);
        end
        
        
        
    end
    
end

%% ===============================================


% ==============================================
%%   subs
% ===============================================
function chk=checkorientation(pa,ff)
us=get(gcf,'userdata');
% paramgui('setdata','x.reorienttype2',[]); % reset the other "reorienttype"
drawnow;

[cs x]=paramgui('getdata');
%% ===============================================
gzfile=cellstr(x.gzfile);
if isempty(regexprep(char(gzfile),'\s+',''));
    error('obj-file not specified');
end
gzfile=gzfile{1};

reffile=cellstr(x.refIMG);
if isempty(regexprep(char(reffile),'\s+',''));
    error('obj-file not specified');
end
reffile=reffile{1};

% ==============================================
%%
% ===============================================
for i=1:length(pa)
    f1=fullfile(pa{i},reffile) ;
    f2=fullfile(pa{i},gzfile) ;
    if exist(f1)==2 && exist(f2)==2
        break
    end
end

if exist(f1)~=2 && exist(f2)~=2
    error([ 'error: objfile:' '"' gzfile '" or refIMG:' '"' reffile '" not found'])
end





%% ===============================================


try
    [ha a]   =rgetnii(f1);
    [hb b]=obj2nifti(f2);
catch
    disp('note: [reorientType] reuqnest a reference Image [refIMG]');
    disp('    -->select another [refIMG]');
    chk=2;
    return
end
a=a(:,:,:,1);    ha=ha(1);
b=b(:,:,:,1);    hb=hb(1);
ivec=squeeze(sum(sum(b>0,1),2));
islice=max(find(ivec==max(ivec)));

a2=a(:,:, islice);
b2=b(:,:, islice);
chk=reorient_check( a2,b2, ff);

function chk=checkorientation2(tb,ff)
us=get(gcf,'userdata');
paramgui('setdata','x.reorienttype',[]); % reset the other "reorienttype"
drawnow;

txt=(char(us.jCodePane.getText));
b=regexp(txt, '\n', 'split')';
eval(b{regexpi2(b,'x.refIMG')});
try
    if iscell(x.refIMG);          refimg=x.refIMG{1};
    else                          refimg=x.refIMG;
    end
    fa =fullfile(tb{1,4},refimg) ; %refIMG
    fb =fullfile(tb{1,1},[tb{1,2} tb{1,3} ]); %importIMG
    [ha a]   =rgetnii(fa);
    %[hb b]   =rgetnii(fb); %MASK
    [hb b]=obj2nifti(fb);
catch
    disp('note: [reorientType] reuqnest a reference Image [refIMG]');
    disp('    -->select another [refIMG]');
    chk=2;
    return
end
%chk=reorient_check( a2,b2, ff);
chk=reorient_check2(a,b);


%———————————————————————————————————————————————
%%   reorient_check
%———————————————————————————————————————————————
function chk=reorient_check( a2,b2, ff)

if 0
    [ha a]   =rgetnii('DTI_EPI_seg_30dir_sat_1.nii'); %MASK
    [hb b]   =rgetnii('_orig.nii'); %MASK
    
    a=a(:,:,:,1);
    ha=ha(1)
    b=b(:,:,:,1);
    hb=hb(1)
    
    a2=a(:,:, ceil(size(a,3)/2));
    b2=b(:,:, ceil(size(b,3)/2));
    
    
    ff={'v=v;'
        'v=flipud(fliplr(v));'
        'v=flipud(      v);'
        'v=fliplr(      v);'}
    chk=snip_checkbox( a2,b2, ff)
    
end


nrc=[ceil(sqrt(size(ff,1))) ceil(sqrt(size(ff,1)))];
N=   prod(nrc);
vec=zeros(prod(nrc),1);
vec([1:size(ff,1)]')=[1:size(ff,1)]';

% fg;
% hs = tight_subplot(nrc(1),nrc(2),[.0 .0],[0 0],[.0 .0]);
hs =axslider([nrc], 'checkbox',1,'num',1 );
set(gcf,'numbertitle','off',...
    'name','select best matching orientation ');
% delpanel=hs(find(vec==0));
% delete(delpanel);
% hs(hs==delpanel)=[];


for i=1:N
    if vec(i)==0;           continue  ;   end
    %________________________________________________
    % i=2
    
    
    
    
    ca=single(rot90(a2));
    v=b2;
    eval(ff{i});
    cb=single(rot90(v));
    
    axes(hs(i));
    imagesc(ca); % colormap gray
    hold on;
    % contour(ca,'color','w')
    contour(cb,'color','r');
    axis off;
    
    yl=ylim;
    xl=xlim;
    yl=round(yl(2));
    sp=yl-yl*.85;
    xs=linspace(1,sp,3)+sp/5;
    t1=text(mean(xl), xs(1),  [  ff{i} ],'color','w','fontsize',9,'tag','tx','interpreter','none','fontweight','bold',...
        'horizontalalignment','center');
end

set(hs,'XTickLabel','','YTickLabel','');
set(findobj(gcf,'tag','chk1'),'tooltipstring','..use this trafo');
hok=uicontrol('style','pushbutton','units','norm','position',[0 0 .05 .05],'string','ok',...
    'tooltipstring','OK select this trafo','callback',@cb_ok);

ax1=findobj(gcf,'tag','chk1');
set(ax1,'callback', 'set(setdiff(findobj(gcf,''tag'',''chk1''),gco),''value'',0)' );
set(gcf,'tag','slices');
uiwait(gcf);

hf=findobj(0,'tag','slices');
ax1=findobj(hf,'tag','chk1');
chk=get(ax1(find(cell2mat(get(ax1,'value')))) ,'userdata');
if isempty(chk)
    chk=1;
else
    close(hf);
end
function cb_ok(h,e)
uiresume(gcf)


