%% #k merge masks
% MERGE MULTIPLE MASKS
% #ko __INPUT___
% z.maskfiles    : several maskfiles-files                                                                                                                 
%                                                                                                                                                                 
% z.value        : used mask-value (different values can be assigned for different masks)                                                                                                                         
% z.so           : set operation:[u]:union, [i]:intersection, [1-2]: 1st or all masks without 2nd-mask, [2-1]: 2nd-mask without 1st mask or all other masks
%                       -'u'  : union of 2 or more maskfiles
%                       -'i'  : intersection of 2 or more maskfiles
%                       -'1-2':  -two maskfiles:  complement,  1st mask without 2nd-mask
%                                -more maskfiles: complement,  all masks without 2nd-mask
%                       -'2-1':  -two maskfiles:  complement,  2nd mask without 1st-mask
%                                -more maskfiles: complement,  all masks without 1st-mask
% z.isBrain      : within brain-mask: [0]no [1]yes, mask must be in inside brain 
%                    -[1]: resulting mask is inside the brain-mask, i.e.  cleaned based on 'AVGTmask.nii'
%                    -[0]: no
% z.renamestring : 'outputstring,
%                   -'if empty:  original filename + suffix based on z.so is used
%                   - or enter output-filename here
%                   - or prefix ("$p:pre_") ..here 'pre_' is used as prefix 
%                   - or suffix ("$s:_suff") ...here '_suff' is used as suffix                                     
% 
% 
% 
% 
% #ko __EXAMPLES___
%% example-1: union of the two masks (both with mask value=1)
% z=[];                                                                                                                                                                                      
% z.maskfiles    = { 'x_t2_mask.nii'             % % several maskfiles-files                                                                                                                 
%                    'x_t2_mask_flip.nii' };                                                                                                                                                 
% z.value        = [1];                          % % used mask-value                                                                                                                         
% z.so           = 'u';                          % % set operation:[u]:union, [i]:intersection, [1-2]: 1st or all masks without 2nd-mask, [2-1]: 2nd-mask without 1st mask or all other masks
% z.isBrain      = [0];                          % % within brain-mask: [0]no [1]yes, in inside brain                                                                                        
% z.renamestring = '';                           % % if empty: use original filename or enter new filename or prefix ("$p:pref_") or suffix ("$s:_suff")                                      
% xmergemasks(1,z);  
% 
%% example-2: use complement: 'x_t2_mask_flip.nii' without 'x_t2_mask.nii', inside brain-boundary   
% z=[];                                                                                                                                                                                      
% z.maskfiles    = { 'x_t2_mask.nii'             % % several maskfiles-files                                                                                                                 
%                    'x_t2_mask_flip.nii' };                                                                                                                                                 
% z.value        = [1];                          % % used mask-value                                                                                                                         
% z.so           = '2-1';                        % % set operation:[u]:union, [i]:intersection, [1-2]: 1st or all masks without 2nd-mask, [2-1]: 2nd-mask without 1st mask or all other masks
% z.isBrain      = [1];                          % % within brain-mask: [0]no [1]yes, in inside brain                                                                                        
% z.renamestring = '';                           % % if empty: use original filename or enter new filename or prefix ("$p:pref_") or suffix ("$s:_suff")                                      
% xmergemasks(1,z);
% 
%% example-3: from multi-valued mask, keep mask with value=1, inside brain-boundary
% z=[];                                                                                                                                                                                      
% z.maskfiles    = { 'x_t2_mask.nii'   };        % % several maskfiles-files                                                                                                                                                                                                                                                             
% z.value        = [1];                          % % used mask-value                                                                                                                         
% z.so           = 'u';                          % % set operation:[u]:union, [i]:intersection, [1-2]: 1st or all masks without 2nd-mask, [2-1]: 2nd-mask without 1st mask or all other masks
% z.isBrain      = [1];                          % % within brain-mask: [0]no [1]yes, in inside brain                                                                                        
% z.renamestring = 'newMask';                    % % if empty: use original filenme or enter new filename or prefix ("$p:pref_") or suffix ("$s:_suff")                                      
% xmergemasks(1,z);
% 
%% example-4: no GUI/no graphic support 
% pa={'F:\data7\anastasia_maskcheck\dat\maskunion'
%     'F:\data7\anastasia_maskcheck\dat\maskunion_2'};
% z=[];                                                                                                                                                                                      
% z.maskfiles    = { 'x_t2_mask.nii'             % % several maskfiles-files                                                                                                                 
%                    'x_t2_mask_flip.nii' };                                                                                                                                                 
% z.value        = [1];                          % % used mask-value                                                                                                                         
% z.so           = 'u';                          % % set operation:[u]:union, [i]:intersection, [1-2]: 1st or all masks without 2nd-mask, [2-1]: 2nd-mask without 1st mask or all other masks
% z.isBrain      = [0];                          % % within brain-mask: [0]no [1]yes, in inside brain                                                                                        
% z.renamestring = '';                           % % if empty: use original filename or enter new filename or prefix ("$p:pref_") or suffix ("$s:_suff")                                      
% xmergemasks(0,z,pa); 



function xmergemasks(showgui,x,pa)

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



ff={'v=v;'
    'v=flipud(fliplr(v));'
    'v=flipud(      v);'
    'v=fliplr(      v);'};

% ==============================================
%%   GUI
% ===============================================
if exist('x')~=1;        x=[]; end


p={...
    'maskfiles'     ''                'several maskfiles-files' ...
    {@selector2,fi2,{'maskfiles'},'out','list','selection','multi','position','auto','info','maskfiles'}
    'value'        1           'used mask-value'    {1 'm>1' 'm>0'  [1 1]  'm1>0;m2>0;'  'm1>0;m2>0;m3>0;' }
    'so'           'u'         'set operation:[u]:union, [i]:intersection, [1-2]: 1st or all masks without 2nd-mask, [2-1]: 2nd-mask without 1st mask or all other masks' {'u' 'i' '1-2' '2-1'}
    'isBrain'      [1]         'within brain-mask: [0]no [1]yes, in inside brain'  'b'
    
    %     'reorienttype'   [1]       'select reorientation type; click left icon for preview'                              {@checkorientation,pa,ff}
    'renamestring'   ''        'if empty: use original filenme or enter new filename or prefix ("$p:pref_") or suffix ("$s:_suff")'            {'' '$p:bla_'  '$s:_bla'}
    };

p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI

if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
        'figpos',[.15 .41 .56 .2 ],'title',[ 'merge masks [' mfilename ']'],'info',{@uhelp,[ mfilename '.m']}  );
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

% return
% ==============================================
%%   proc
% ===============================================
z.orient=ff;
if z.isBrain==1
    fbrain=fullfile(fileparts(fileparts(pa{1})),'templates','AVGTmask.nii');
    [hb b]=rgetnii(fbrain);
    z.info1='__brainMask';
    z.hb=hb;
    z.b=b;
end
for i=1:length(pa)
    proc(z,pa{i}) ;
end
disp('Done!');



function proc(z,pam)
%% ===============================================
fi =cellstr(z.maskfiles);
pam=char(pam);

[~,animal]=fileparts(pam);
try; cprintf('*[0 0 1]',[ '[' animal ']' '\n'] );
catch; disp([ '[' animal ']' ] );
end
%% ====code values===========================================
val=z.value;
%  val='<0,blo>2';
% val='klaus1>0;kl=5';
% val=[1 2];
% val=1;
if ischar(val)
    val=regexprep(val,',',';');
    val=strsplit(val,';');
    val(strcmp(val,''))=[];
    %    val=regexprep(val,'[A-z]\d+','');
    val=regexprep(val,'^\w+','');
else
    val=cellfun(@(a){[   '==' num2str(a) ]}, num2cell(val));
    
end

if length(val)<length(fi)
    val=repmat(val(end),[1 length(fi)]);
    val=val(1:length(fi));
end
% disp(val)
%% ========load maskfiles =======================================
isok=1;
for i=1:length(fi)
    f1=fullfile(pam,fi{i});
    if exist(f1)~=2
        isok=0;
        disp([ 'file "' fi{i} '" does not exist...' ]);
    end
end

if isok==0;
    return ;
end

for i=1:length(fi)
    f1=fullfile(pam,fi{i});
    [ha a]=rgetnii(f1);
    if i==1
        d= zeros(numel(a),length(fi));
    end
    a=a(:);
    eval([ 'av=a' val{i} ';']);
    d(:,i)=av;
end
%% =========set operation ======================================
so=z.so;
% so='i'
if strcmp(so,'u')
    v=double(sum(d,2)>0);
    str='_union';
elseif  strcmp(so,'i')
    v=double(sum(d,2)==size(d,2));
    str='_isect';
elseif  strcmp(so,'1-2')
    dx=d;
    dx(:,[2:end])=dx(:,[2:end]).*10;
    dy=sum(dx,2);
    v=dy==1;
    str='_complB';
    %fg,plot(v)
elseif  strcmp(so,'2-1')
    dx=d;
    dx(:,[1 3:end])=dx(:,[1 3:end]).*10;
    dy=sum(dx,2);
    v=dy==1;
    str='_complA';
end

% fg,plot(v)
if z.isBrain==1
   b= z.b(:);
   v=sum([b v],2)==2; 
end

% ===save============================================
[~,outname]=fileparts(fi{1});
outname=regexprep([outname str],'.nii$','');
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


f1=fullfile(pam,[z.maskfiles{1} ]);
f4=fullfile(pam,[outname '.nii']);
x=reshape(v,ha.dim);

rsavenii(f4, ha, x,64);
showinfo2('..saved Nifti: ',f1,f4,2);


if 0
frev=fullfile(pam,'AVGT.nii');
rmricron([],frev,f4,2);
end








