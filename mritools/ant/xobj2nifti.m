%% #k convert local (*.obj) files TO NIFTIs
%  example: lesion masks delineated with Analyze software
% z=[];                                                                                                                                         
% z.objfile      : one or more OBJ-files , example    { 't1_mask.obj' };                                                                         
% z.refIMG       : reference image such as "t2.nii"
%                 - the header of the ref-image is used for the converted NIFTI-file
% z.reorienttype : reorientation type
%                 - click left icon for preview of different orientations, select the most usefull one                                            
% z.renamestring : - optional: change name of the new NIFTI-file
%                  -either empty: use original filename
%                    -or enter new filename
%                    -or add prefix to orig filename specified with "$p:_pref_" ...here '_pref' is the new prefix
%                    -or add suffix to orig filename specified with "$s:_suff"  ...here '_suff' is the new suffix
% xobj2nifti(1,z);
% 
% #ok EXAMPLES
% 
%% ------ example-1
% z=[];                                                                                                                                         
% z.objfile      = { 't1_mask.obj' };     % % one or more OBJ-files                                                                             
% z.refIMG       = 't2.nii';              % % ref image such as "t2.nii" (header-information is used here)                                      
% z.reorienttype = [1];                   % % select reorientation type; click left icon for preview                                            
% z.renamestring = '';                    % % if empty: use original filenme or enter new filename or prefix ("$p:pref_") or suffix ("$s:_suff")
% xobj2nifti(1,z);
% 
%% ------ example-2
% z=[];                                                                                                                                         
% z.objfile      = { 't1_mask.obj' 	't2_mask.obj' };     % % one or more OBJ-files                                                                             
% z.refIMG       = 't2.nii';              % % ref image such as "t2.nii" (header-information is used here)                                      
% z.reorienttype = [1];                   % % select reorientation type; click left icon for preview                                            
% z.renamestring = '$s: _aSuffix';        % % if empty: use original filenme or enter new filename or prefix ("$p:pref_") or suffix ("$s:_suff")
% xobj2nifti(1,z); 
% 
%% ------ example-2: no GUI, without graphic-support
% pa={'F:\data7\anastasia_maskcheck\dat\objFile_2021815_aj_T4_323_20G_d13'
%     'F:\data7\anastasia_maskcheck\dat\obj_File_202177_aj_T7_298_40G_d22'
% };
% z=[];                                                                                                                                
% z.objfile      = { 't1_mask.obj' };     % % obj-file                                                                                 
% z.refIMG       = 't2.nii';              % % ref image such as "t2.nii"                                                               
% z.reorienttype = [1];                   % % select the reorientation type (rec. for mouse space data; click right icon for a preview)
% z.renamestring = '';                    % % (optional) enter a new filename for the imported files (without extention)               
% xobj2nifti(0,z,pa);  
%% ------ example-3: convert multiple obj-files from another folder (new niftis will be stored in the obj-folder)
% z.objfile      = {...
%     'F:\data8\issue_obj_import_outsideAnimalDIr\dat\m1_obj_in_path\test_angio_3D.obj'
%     'F:\data8\issue_obj_import_outsideAnimalDIr\dat\m1_obj_in_path\test_angio2_3D.obj'};	% one or more OBJ-files
% z.refIMG       = {'F:\data8\issue_obj_import_outsideAnimalDIr\templates\AVGT.nii'};	% ref image such as "t2.nii" (header-information is used here)
% z.reorienttype =  [1];	% select reorientation type; click left icon for preview
% z.renamestring =  '';	% if empty: use original filenme or enter new filename or prefix ("$p:pref_") or suffix ("$s:_suff")
% xobj2nifti(0,z);  
%% ------ example-4: convert multiple obj-files studies animalfolder using local reference-image 
% z=[];                                                                                                                                            
% z.objfile      = { 'test_angio_3D.obj' 'test_angio2_3D.obj' };  % % one or more OBJ-files                                                                             
% z.refIMG       = 'AVGT.nii';               % % ref image such as "t2.nii" (header-information is used here)                                      
% z.reorienttype = [1];                      % % select reorientation type; click left icon for preview                                            
% z.renamestring = '';                       % % if empty: use original filenme or enter new filename or prefix ("$p:pref_") or suffix ("$s:_suff")
% xobj2nifti(0,z);                                                                                                                                 
%         

function xobj2nifti(showgui,x,pa)

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
    obj={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.obj$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        obj=[obj; fis];
    end
    obj=unique(obj);
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
    'inf97'    ''  '*** CONVERT LOCAL ANALYZE FILES (*.obj)'    ''
    'objfile'     ''                'one or more OBJ-files' ...
     {@getfilex,obj,'obj'}
    %{@selector2,obj,{'objectfile'},'out','list','selection','multi','position','auto','info','obj-file(s)'}
    
    'refIMG'      't2.nii'        'ref image such as "t2.nii" (header-information is used here)' ...
    {@getfilex,li,'ref'}
%     {@selector2,li,{'TargetImage'},'out','list','selection','single','position','auto','info','reference-image'}
    
    'reorienttype'   [1]       'select reorientation type; click left icon for preview'                              {@checkorientation,pa,ff}
    'renamestring'   ''        'if empty: use original filenme or enter new filename or prefix ("$p:pref_") or suffix ("$s:_suff")'            {'' '$p:bla_'  '$s:_bla'}
    };

p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI

if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
        'figpos',[.15 .41 .56 .2 ],'title',[ 'CONFERT OBJ-FILES [' mfilename ']'],'info',{@uhelp,[ mfilename '.m']}  );
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
        xmakebatch(z,p, mfilename,['xobj2nifti(' num2str(isDesktop) ',z);' ]);
    else
        xmakebatch(z,p, mfilename,['xobj2nifti(' num2str(isDesktop) ',z,mdirs);' ],pa);
    end
end


% ==============================================
%%   proc
% ===============================================
z.orient=ff;


if ischar(z.objfile);  z.objfile =cellstr(z.objfile); end
if ischar(z.refIMG);   z.refIMG  =cellstr(z.refIMG); end
useAnimaldir=1;
if exist(z.objfile{1})==2 && exist(z.refIMG{1})==2 
   useAnimaldir=0;
end

if useAnimaldir==1;
    for i=1:length(pa)
        proc(z,pa{i}) ;
    end
else
        proc(z,[]) ;
end
disp('Done!');



function proc(z,pam)
%% ===============================================
z.objfile=cellstr(z.objfile);
z.refIMG=char(z.refIMG);
pam=char(pam);

useAnimaldir=1;
if exist(z.refIMG)==2 && exist(z.objfile{1})==2 
    useAnimaldir=0;   
end

for i=1:length(z.objfile)
    if useAnimaldir==1;
        [~,animal]=fileparts(pam);
        try; cprintf('*[0 0 1]',[ 'working on [' animal ']' '\n'] );  catch; disp([ 'working on [' animal ']' ] );        end
        f1=fullfile(pam,z.refIMG) ;
        f2=fullfile(pam,z.objfile{i});
    elseif useAnimaldir==0;
        f1=z.refIMG;
        f2=z.objfile{i};
        [pam,imgname,ext]=fileparts(f2);
        try; cprintf('*[0 0 1]',[ 'working on [' [imgname,ext] ']' '\n'] );  catch; disp([ 'working on [' [imgname,ext] ']' ] );        end
        
    end
    
    if exist(f1)~=2 && exist(f2)~=2
        if exist(f1)~=2 && exist(f2)==2
            disp([ '  !!!: refIMG: ' '"' z.refIMG '"' 'not found']);
        elseif exist(f1)==2 && exist(f2)~=2
             disp([ '  !!!: objfile: ' '"' z.objfile{i} '"' ' not found']);
        else
            disp([ '  !!!: objfile:' '"' z.objfile{i} '" or refIMG:' '"' z.refIMG '" not found']);
        end
            
    else
        
        [hr r]=rgetnii(f1);
        [w1 w2]=obj2nifti(f2);
        v=w2;
        eval(z.orient{z.reorienttype});
        
        
        [~,outname]=fileparts(f2);
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
        
        %      disp(outname);
        %      return
        
        f3=fullfile(pam,[outname '.nii']);
        try; delete(f3); end
        rsavenii(f3, hr, v,64);
        showinfo2('..saved Nifti: ',f1,f3,2);
        
        
    end
    
end

%% ===============================================


% ==============================================
%%   subs
% ===============================================
function o=getfilex(im,imtype)
%% ===============================================
o='';
if strcmp(imtype,'obj')
    imtypeStr='obj-file';
    para='x.objfile';
    fmode='multi'; 
    fmode2='on';
    fmt='*.obj';
else
    imtypeStr='ref-file';
    para='x.refIMG';
    fmode='single';
    fmode2='off';
    fmt='*.nii';
end
 opts=struct('WindowStyle','modal','Interpreter','tex','Default','animalDir');
    msg={
        ['Please specify source of ' imtypeStr ':' ]
        ['\color{blue}animalDir: \color{black}.. is in study''s animal-folder(s)']
        ['\color{blue}other: \color{black} "' imtypeStr '" is in another folder']
        };

answer = questdlg(msg,[['Source of ' ] imtypeStr],...
        'animalDir','other','cancel',opts);
    
if strcmp(answer,  'animalDir')  
    list=selector2( im,{'objectfile'},'out','list','selection',fmode,'position','auto','info',['select:' imtypeStr  ]);  
elseif strcmp(answer,  'other') 
    [fi, pa] = uigetfile(fmt, ['select the ' imtypeStr ],'MultiSelect', fmode2);
    if isnumeric(pa); 
        return;
    end
    if ~iscell(fi)
       fi=cellstr(fi);
    end    
        list=stradd(fi(:), [pa filesep],1);
else
    return 
end

% paramgui('setdata',para,list); % reset the other "reorienttype"
o=list;
return


%% ===============================================


function chk=checkorientation(pa,ff)
us=get(gcf,'userdata');
% paramgui('setdata','x.reorienttype2',[]); % reset the other "reorienttype"
drawnow;

[cs x]=paramgui('getdata');
%% ===============================================
objfile=cellstr(x.objfile);
if isempty(regexprep(char(objfile),'\s+',''));
    error('obj-file not specified');
end
objfile=objfile{1};

reffile=cellstr(x.refIMG);
if isempty(regexprep(char(reffile),'\s+',''));
    error('obj-file not specified');
end
reffile=reffile{1};

% ==============================================
%%
% ===============================================
if  exist(reffile)==2 && exist(objfile)==2
    f1=reffile;
    f2=objfile;
else
    for i=1:length(pa)
        f1=fullfile(pa{i},reffile) ;
        f2=fullfile(pa{i},objfile) ;
        if exist(f1)==2 && exist(f2)==2
            break
        end
    end
end

if exist(f1)~=2 && exist(f2)~=2
    error([ 'error: objfile:' '"' objfile '" or refIMG:' '"' reffile '" not found'])
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
if islice==size(a,3) || islice==1
  islice=round(size(a,3)/2) ; %middle SLice
end

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


