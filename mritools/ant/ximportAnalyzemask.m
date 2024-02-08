%% #k IMPORT ANALYZE (*.obj) files (lesionmasks)
% this function imports masks/lesionmasks created with the ANALYZE-Software.
% the ANALYZE *.obj-files will be imported, converted to nifti-file, assigned to the
%  belonging mouse folder,finally the header of the file is replaced by the header of a
%  a reference file (such as the "t2.nii" for mouseSpace-Data or "AVGT.nii" for AllenSpace-Data) 
%  since the information of the origin and voxelsize is not stored in the obj-file
% for multi-object obj-files a nifti is created with all objects. Addionally, for each objects a
% separate nifti is stored  with suffix "_objectNumber"
%_______________________________________________________________________________________________
%% #g [1] IMPORT OF OBJECT_FILES
%% #g imported obj-files must:  either (a) contain the mousefolder-name as prefix(!) in the filename'            (i.e. files can be located anywhere)
%% #g                               or (b) can be located anywhere, but the the mouse-specific subfolder name is 
%%                                         identical to  mousefolder-name defined in ../dat/                     (i.e. files can be located anywhere)
%% #g                               or (c) are  already located in the respective mouseFolder in ../dat/         (i.e. files located in the mouseSpecific folder)
%% #g          here are examples of the two ways to solve the dataimport:
%% #g              example1:      (a) "20160623HP_M36_myMask.obj"     -->prefix  "20160623HP_M36" indicates the mousefolder-name
%% #g              example2:      (b) "c:\anywhere\anywhere\20160623HP_M36\myMask.obj"  -->parent folder "20160623HP_M36" indicates the mousefolder-name
%% #g              example2:      (c) ..same as (b) but located in in  mouseSpecific analysis folder (../dat/)
%%_______________________________________________________________________________________________
%% #r     NOTE: mouse folders don't have to be selected in advance
% _______________________________________________________________________________________________
% #by  OTHER PARAMETER ACCESSIBLE VIA GUI
% refIMG      :   a reference image. The header of this file is used to replaces the header of the imported file   <default: t2.nii>
%                 for example use -  "t2.nii" for mouseSpace-Data 
%                                 -  "AVGT.nii" for AllenSpace-Data  
%                 NOTE: ## !!! (don't use mixed spaces for  "refIMG" and obj-file.. bust must be either in mouse-or AllenSpace   
% reorienttype:   different reorientations. click the right icon in the gui for a preview and select the optimal reorientation <default: 1>
%                 <1> should be fine in most cases
%
% reorienttype2:   or select for more complex reorientation type (recommended for Allen space data;click right icon for a preview)'
%                  use "reorienttype2" for more complex reorientations
%                 - for Allen-Space data use:  'flipdim(permute(g,[1  3  2]),3);'   (button-4 in the overlay panel ) 
% renamestring:   (optional) enter a new filename for the imported files (without extention)
%
% #yk BATCH EXAMPLES
% EXAMPLE OBJETCFILE IS IN MOUSE-SPACE
% z.refIMG={ '2_T2_ax_mousebrain_1.nii' };          % %% reference Image      (in all selected Mouse folders)
% z.reorienttype=[1];                               % %% reorientation type  (how to reorient the obj image relative to the reference image)
% z.renamestring='mask';                            % %% (optional) renaming the output nifti to "mask"
% ximportAnalyzemask(0,z);                          % %% run import in with GUI
% _______________________________________________________________________________________________
% [obj_files] = spm_select('FPListRec',pwd,'.*.obj$') ;  % %% collect all object files
% z=[];                                        % %%  ..
% z.refIMG={ '2_T2_ax_mousebrain_1.nii' };     % %% reference Image      (in all selected Mouse folders)
% z.obj_files=obj_files;                       % %% import these object-files
% z.reorienttype=[1];                          % %% reorientation type  (how to reorient the obj image relative to the reference image)
% z.renamestring='mask';                       % %% (optional) renaming the output nifti to "mask"
% ximportAnalyzemask(0,z)                      % %% run import in silent mode (no GUI)
% _______________________________________________________________________________________________
% EXAMPLE OBJETCFILE IS IN ALLEN-SPACE
% z=[];
% z.refIMG        = { 'AVGT.nii' };                                    % % use the header from this file. This header replaces the header of the imported files
% z.reorienttype  = [];                                                % % select the reorientation type (rec. for mouse space data; click right icon for a preview)
% z.reorienttype2 = 'flipdim(flipdim(permute(g,[1  3  2]),1),3);';     % % or select for more complex reorientation type (rec. for Allen space data;click right icon for a preview)
% z.renamestring  = '';                                                % % (optional) enter a new filename for the imported files (without extention)
% ximportAnalyzemask(1,z);
% _______________________________________________________________________________________________
% Update  19-Apr-2018 17:31:57 : multi-obj obj-file  possible to import, batch possible for obj-files
%        obj imoprtable from allenspace

function ximportAnalyzemask(showgui,x)


% if 0
%
%     [obj_files] = spm_select('FPListRec',pwd,'.*.obj$') ;  % %% collect all object files
%     z=[];
%     z.refIMG={ '2_T2_ax_mousebrain_1.nii' };     % %% reference Image      (in all selected Mouse folders)
%     z.obj_files=obj_files;                       % %% import these object-files
%     z.reorienttype=[1];                          % %% reorientation type  (how to reorient the obj image relative to the reference image)
%     z.renamestring='mask2';                       % %% (optional) renaming the output nifti to "mask"
%     ximportAnalyzemask(0,z)                      % %% run import in silent mode (no GUI)
%
%
%
% end




global an
prefdir=fileparts(an.datpath);


%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                           ;    x=[]                     ;end
% if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end

% if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end


%———————————————————————————————————————————————
%%   get files to import
%———————————————————————————————————————————————
msg={'IMPORT ANALYZE (*.obj) FILES (lesionmasks)'
    'select *.obj-files (MASK files from ANALZYESOFTWARE) to import'
    '..these files will be converted to NIFTIs and assignd to the best-matching mouse-folders'
    '____HOWTO'
    '1) if obj-files are located in one folder --> navigate to the folder and select the files or...'
    '2) <optional> select [fileSTR] to select the filter for the obj-files'
    '.. the filter-field must contain ".obj$" to find the *.obj-files  '
    '3) select [Rec] to recursively select all obj-files'
    '4) <optional> deselect unwanted files from lower panel'
    
    };

try
    if isfield(x,'obj_files')
        fi2imp= x.obj_files;
        if ischar(fi2imp); fi2imp=cellstr(fi2imp); end
    end
end

if exist('fi2imp')==0
    %     [maskfi,sts] = cfg_getfile2(inf,'image',msg,[],prefdir,'img');
    [fi2imp,sts] = cfg_getfile2(inf,'any',msg,[],prefdir,'.obj$');
end

if isempty(char(fi2imp)); return ; end
%———————————————————————————————————————————————
%%   over mousepaths and fileList
%———————————————————————————————————————————————
if exist('pa')==0      || isempty(pa)      ;
    pa=antcb('getallsubjects')  ;
end
if 1
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=unique(fi2);
    
    %% get additional info from first PATH
    ad=repmat({'-'},[size(li,1) 4]);
    for i=1:size(li,1)
        
        
        try
            hh=spm_vol(fullfile(pa{1}, li{i} ));
            hh=hh(1);
            
            vmat=spm_imatrix(hh.mat);
            ori=regexprep(num2str(vmat(1:3)),' +',' ');
            res=regexprep(num2str(vmat(7:9)),' +',' ');
            dim=regexprep(num2str(hh.dim),['\W*'],'-');
            dt=regexprep(num2str(hh.dt),['\W*'],' ');
            ad(i,:)={dim res ori dt};
        end
    end
    
    li2 =[li ad];
    li2h={'ReferenceImage' 'Dim' 'origin','rsolution' 'dt'};
end

%% zuordnen
tb=zurodnen(fi2imp , pa);



% id=selector2(tb,{'pa' 'fi' 'ext' 'TargetPath'})
% return

%———————————————————————————————————————————————
%%   reorienttype
%———————————————————————————————————————————————


ff={'v=v;'
    'v=flipud(fliplr(v));'
    'v=flipud(      v);'
    'v=fliplr(      v);'};


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  PARAMETER-gui
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if exist('x')~=1;        x=[]; end


p={...
    'inf97'      '*** IMPORT ANALYZE (*.obj) files (lesionmasks)              '                                                       '' ''
    'inf98'      'imported obj-files must:  either (a) contain the mousefolder-name as prefix! in the filename'            '' ''
    'inf99'      '                               or (b) must be located in a subfolder with the same mousefolder-name  '                         '' ''
    'inf100'      'here are examples of the two ways to solve the dataimport: '                         '' ''
    'inf101'      'example1:      (a) "20160623HP_M36_myMask.obj"     -->prefix  "20160623HP_M36" indicates the mousefolder-name    '            '' ''
    'inf102'      'example2:      (b) "..\20160623HP_M36\myMask.obj"  -->parent folder "20160623HP_M36" indicates the mousefolder-name    '            '' ''
    'inf1000'     '-------------------------------'                          '' ''
    'refIMG'     't2.nii'    'use the header from this file. This header replaces the header of the imported files'        {@selector2,li2,li2h,'out','col-1','selection','single'}
    'reorienttype'   [1]       'select the reorientation type (rec. for mouse space data; click right icon for a preview)'                              {@dumx,tb,ff}
    'reorienttype2'  [0]       'or select for more complex reorientation type (rec. for Allen space data;click right icon for a preview)'          {@dumx2,tb,[]}
    'renamestring'   ''    '(optional) enter a new filename for the imported files (without extention)'             ''
    };

p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI

if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
        'figpos',[.15 .3 .8 .3 ],'title',[ 'IMPORT NIFTIS-replace Header [' mfilename ']'],'info',{@uhelp,[ mfilename '.m']}  );
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


%———————————————————————————————————————————————
%%   makebatch
%———————————————————————————————————————————————
% z.obj_files  =fi2imp; %obj files
% makebatch(z);

xmakebatch(z,p,mfilename);



%———————————————————————————————————————————————
%%   ok-import that stuff
%———————————————————————————————————————————————


for i=1:size(tb,1)
    f1=fullfile(tb{i,1},[tb{i,2} tb{i,3}]);
    fi=[tb{i,2} tb{i,3}];
    fi=regexprep(fi,'.obj$','');
    fi=[regexprep(fi,'.nii','') '.nii'];
    
    if ~isempty(z.renamestring) &&  ~isempty(char(z.renamestring));
        fi=[regexprep(z.renamestring,'.nii','') '.nii'];
    end
    
    %———————————————————————————————————————————————
    %%  get data
    %———————————————————————————————————————————————
    f2=fullfile(tb{i,4},fi);
    obj2nifti(f1,f2);
    %     copyfile(f1,f2,'f');
    
    if ischar(z.refIMG); z.refIMG=cellstr(z.refIMG); end
    [hr r]=rgetnii(fullfile(tb{i,4} , z.refIMG{1} ));
    [ha a]=rgetnii(f2);
    %  [ha a]=obj2nifti(f2);
    
    
    %———————————————————————————————————————————————
    %% reorient
    %———————————————————————————————————————————————
    reorType=[0];
    if isnumeric(z.reorienttype2) && z.reorienttype2==0
        reorType=1;
    else
        reorType=2;
    end

%     reorType=[0 0];
%     if isfield(z,'reorienttype' ); if ~isempty(char(z.reorienttype ))  ; reorType(1)=1; end;end
%     if isfield(z,'reorienttype2'); if ~isempty(char(z.reorienttype2))  ; reorType(2)=1; end;end
%     if sum(reorType)==2
%         error('..no reorientType defined,.. set either "reorienttype" or "reorienttype2"');
%     end
    
    if reorType(1)==1
        v=a;
        eval(ff{z.reorienttype});
        a=v;
    else  % reorienttype2
        g=a;
        eval(['v=' z.reorienttype2]);
        a=v;
        
    end
    
    
    
    
    %———————————————————————————————————————————————
    %%
    %———————————————————————————————————————————————
    hr = hr(1);
    hh = ha;
    for j=1:size(hh,1)
        hh(j).mat = hr.mat;
        hh(j).dim = hr.dim;
    end
    
    
    si=length(hh(1).dim);
    if si==3
        hh=spm_create_vol(hh);
        hh=spm_write_vol(hh,  a);
    elseif si==4
        clear hh2
        for j=1:size(a,4)
            dum=hh(j);
            %dum.n=[j 1];
            hh2(j,1)=dum;
            if j==1
                %mkdir(fileparts(hh2.fname));
                spm_create_vol(hh2);
            end
            spm_write_vol(hh2(j),a(:,:,:,j));
        end
    end
    
    
    
    [~,obf objfmt]=fileparts(f1);
    [~, mousefolder]=fileparts(fileparts(f2));
    
    cprintf([0,0,0],[pnum(i,4) '] mouseDir & OBJ-file ' ]);
    cprintf([0,0.5,0],['[' mousefolder ']' ]);
    cprintf([1 0 1],['[' [obf objfmt] ']' '\n']);
    % disp([' ....import obj-file <a href="matlab: explorer('' ' fileparts(f2) '  '')">' f2 '</a>' '; SOURCE: ' '<a href="matlab: explorer('' ' fileparts(f1) '  '')">' f1  '</a>']);% show h<perlink
    disp(['    obj-file        : <a href="matlab: explorerpreselect(''' f1 ''')">' f1 '</a>']);
    disp([' ..imported obj-file: <a href="matlab: explorerpreselect(''' f2 ''')">' f2 '</a>']);
    
    
    
    %%_mutliMask: extract single masks -->add prefix
    unimnum=unique(a); unimnum(unimnum==0)=[];
    if length(unimnum)>1
        
        
        classtype=class(a);
        maskno   =length(unimnum);
        
        disp([' ..... obj-file contains [' num2str(maskno) '] objects ..' ...
            '  creating [' num2str(maskno)...
            '] additional files with suffix "_objectNumber" ' ]);
        for j=1:length(unimnum)
            b=cast(a==unimnum(j),classtype);
            fname=stradd(hh.fname,['_' pnum(j,length(num2str(maskno))+1)],2);
            hm=hh;
            hm.fname=fname;
            hm=spm_create_vol(hm);
            hm=spm_write_vol(hm,  b);
        end
        
        
    end
    
    
    
    
    
end
disp('..done');




%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% subs
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

function makebatch(z)

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

try
    hlp=help(mfilename);
    hlp=hlp(1:min(strfind(hlp,char(10)))-1);
catch
    hlp='';
end

hh={};
hh{end+1,1}=('% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
hh{end+1,1}=[ '% BATCH:        [' [mfilename '.m' ] ']' ];
hh{end+1,1}=[ '% descr:' hlp];
hh{end+1,1}=('% ••••••••••••••••••••••••••••••••••••••••••••••••••••••');
hh=[hh; struct2list(z)];
hh(end+1,1)={[mfilename '(' '1',  ',z' ')' ]};
% disp(char(hh));
% uhelp(hh,1);

try
    v = evalin('base', 'anth');
catch
    v={};
    assignin('base','anth',v);
    v = evalin('base', 'anth');
end
v=[v; hh; {'                '}];
assignin('base','anth',v);




function chk=dumx(tb,ff)
us=get(gcf,'userdata');
paramgui('setdata','x.reorienttype2',[]); % reset the other "reorienttype"
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
a=a(:,:,:,1);    ha=ha(1);
b=b(:,:,:,1);    hb=hb(1);
a2=a(:,:, ceil(size(a,3)/2));
b2=b(:,:, ceil(size(b,3)/2));
chk=reorient_check( a2,b2, ff);

function chk=dumx2(tb,ff)
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
set(gcf,'name','select the reorientation with the best match behavior (use the checkbox) ');
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
    
    %
    %     ca=(imresize(ca,[75 75]));
    %     cb=(imresize(cb,[75 75]));
    
    %     resize_si=[50 50];
    %     ca=(imresize(ca,[resize_si]));
    %     cb=(imresize(cb,[resize_si]));
    %
    %%
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
    
    if 0
        [pat fit ]=fileparts(s.t); [~,pat]=fileparts(pat);
        [paa fia ]=fileparts(s.a); [~,paa]=fileparts(paa);
        
        % bla
        ns=(2*9*1.0);
        re=20;
        [qd qr]=find(grid== vec(i));
        %disp(['qd-qp' num2str([qd qr])]);
        %% ddew
        
        %   delete(findobj(gcf,'tag','tx'));
        yl=ylim;
        yl=round(yl(2));
        sp=yl-yl*.85;
        xs=linspace(1,sp,3)+sp/5;
        cshift=sp/50;
        
        
        %     if 1
        %         [o0 u0]=voxcalc([0 0 0],s.a,'mm2idx');
        %        v(1)=vline(o0(1),'color','c');v(2)=hline(yl-o0(2),'color','c')
        v(1)=vline(o(1),'color','c');v(2)=hline(yl-o(2),'color','c') ;
        %     end
        
        
        if qr==1
            t1=text(sp/5, xs(1),  ['...\' pat '\'],'color','w','fontsize',9,'tag','tx','interpreter','none','fontweight','bold');
            
            
        end
        hline((xs(1)+xs(2))/2,'color','w');
        t1=text(sp*.75,        xs(2),       [ fit '.nii'],'color',[0.3020    0.7451    0.9333],'fontsize',9,'tag','tx','interpreter','none');
        %      t1=text(sp*.75+cshift, xs(2), [ fit '.nii'],'color','w','fontsize',9,'tag','tx','interpreter','none');
        %      t1=text(sp*.75,        xs(3),       [ fia '.nii'],'color','r','fontsize',9,'tag','tx','interpreter','none');
        t1=text(sp*.75+cshift ,xs(3), [ fia '.nii'],'color','w','fontsize',9,'tag','tx','interpreter','none');
        
        t1=text(sp*.75-sp/2, xs(2), ['\otimes' ],'color',[0.3020    0.7451    0.9333],'fontsize',11,'tag','tx','fontweight','bold');
        t1=text(sp*.75-sp/2, xs(3),[ '\leftrightarrow'],'color','r','fontsize',11,'tag','tx','fontweight','bold');
        
        
        
        %% cdcd
        yl=ylim;
        hline(min(yl(2)),'color','w','linewidth',5);
        
    end
    
    
end

set(hs,'XTickLabel','','YTickLabel','');
set(findobj(gcf,'tag','chk1'),'tooltipstring','..use this trafo');
hok=uicontrol('style','pushbutton','units','norm','position',[0 0 .05 .05],'string','ok',...
    'tooltipstring','OK select this trafo','callback',@cb_ok);

ax1=findobj(gcf,'tag','chk1');
set(ax1,'callback', 'set(setdiff(findobj(gcf,''tag'',''chk1''),gco),''value'',0)' );

uiwait(gcf);

ax1=findobj(gcf,'tag','chk1');
chk=get(ax1(find(cell2mat(get(ax1,'value')))) ,'userdata');
close(gcf);

function cb_ok(h,e)
uiresume(gcf)





%———————————————————————————————————————————————
%%   zuordnung
%———————————————————————————————————————————————

function tb=zurodnen(fi2imp , pa)
tb={};  %OBJ files
for i=1:size(fi2imp,1)
    [pas fis ext]=fileparts(fi2imp{i});
    tb(i,:)={pas fis ext};
end


tb2={}; %MOUSE FOLDERS
for i=1:size(pa,1);
    [pas fis ext]=fileparts(pa{i});
    tb2(i,:)={pas fis };
end


for i=1:size(tb,1)
    
    %% mouse-name inside filename
    [ix,d]=strnearest([   tb{i,2}  ],tb2(:,2)) ;
    %% mouse-name is upper folder
    [pax fold]=fileparts(tb{i,1});
    [ix2,d2]=strnearest([   fold  ],tb2(:,2)) ;
    
    
    if length(ix)~=length(ix2)
        if exist(tb{i,1})
            %% use
            if d<d2
                id=ix ;
            else
                id=ix2;
            end
        else
            id=ix;
        end
    else
        %% use
        if d<d2
            id=ix ;
        else
            id=ix2;
        end
    end
    
    tb{i,4}=fullfile(tb2{id,1},tb2{id,2});
end

%% vabity check: check whether mouse-folder exists
isexist=zeros(size(tb,1),1);
for i=1:size(tb,1)
    isexist(i,1)= (exist(tb{i,4})==7);
end
tbmiss=tb(isexist==0,:);  %missing assignment
tb=tb(isexist==1,:);

% disp(' *** OBJfile-MOUSEFOLDER-ASSIGNMENT       (..please check assignment)');
cprintf([0,0.5,0],[' *** OBJfile-MOUSEFOLDER-ASSIGNMENT       (..please check assignment)' '\n']);
if exist(fullfile(tb{1,1},[ tb{1,2} tb{1,3} ]))==2  %# NOTE:  tb(1)+tb(2)+tb(3) form fullpath of objectFile
   % disp(char(cellfun(@(a,b,c,d) {[ fullfile(a,[b c])  ': '  ' >---> ' d]} ,tb(:,1),tb(:,2),tb(:,3),tb(:,4))));
   
   %% ===============================================
   [~,animalDirs]=fileparts2(tb(:,4));
   %    disp(char(cellfun(@(a,b,c,d) {[ fullfile([b c])  ': '  ' >---> ' d]} ,tb(:,1),tb(:,2),tb(:,3), animalDirs  )));
   for i=1:size(tb,1)
       cprintf('*[0 0 1]', [ [ '*ASSIGNMENT: ' num2str(i)  '  ___'  ] '\n']);
       space1=repmat(' ',[1 length(animalDirs{i})-length([tb{i,2} tb{i,3}])]);
       disp([ [tb{i,2} tb{i,3}]   space1 ' [INPUT]'  ]);
       disp([ animalDirs{i}              ' [OUTPUT]' ]);
       [q1 q2]=deal(nan(1,200));
       q1(1:length(double([tb{i,2} tb{i,3}])))=double([tb{i,2} tb{i,3}]);
       q2(1:length(double([animalDirs{i}  ])))=double([animalDirs{i}]);
       isimchar=find((q1-q2)==0);
       simchar=char(q1(isimchar));
       space=repmat(' ',[1 length(animalDirs{i})-length(simchar)]);
       cprintf('[1 0 1]', [  simchar  space ' [similar substring]\n']);
   end
   %% ===============================================

   
   
else
    disp(char(cellfun(@(a,b,c) {[': ' a b ' >---> ' c]} ,tb(:,2),tb(:,3),tb(:,4))));
end

if ~isempty(tbmiss)
    cprintf([1,0,1],[' *** >COULD NOT ASSIGN THE FOLLOWING   (..check existence of obj-file and mousefolder' '\n']);
    if exist(fullfile(tb{1,1},[ tb{1,2} tb{1,3} ]))==2  %# NOTE:  tb(1)+tb(2)+tb(3) form fullpath of objectFile
        disp(char(cellfun(@(a,b,c,d) {[ fullfile(a,[b c])  ': '  ' >---> ' d]} ,tbmiss(:,1),tbmiss(:,2),tbmiss(:,3),tbmiss(:,4))));
    else
        disp(char(cellfun(@(a,b,c) {[': ' a b ' >---> ' c]} ,tbmiss(:,2),tbmiss(:,3),tbmiss(:,4))));
    end
else
    cprintf([0,0.5,0],['.. all OBJfiles assigned successfully to folders' '\n']);
end


% id=selector2(tb,{'pa' 'fi' 'ext' 'TargetPath'})


%   'o:\data\pruess2\import\20160623HP_M36'
%     '20160623HP_M36_t222_dum - Kopie'
%     '.nii'
%     'o:\data\pruess2\dat\20160623HP_M36'


