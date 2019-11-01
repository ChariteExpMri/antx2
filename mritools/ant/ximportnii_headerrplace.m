
%% import files by replacing nifti-header


function ximportnii_headerrplace(showgui,x)


if 0
   % *** IMPORT DATA                  	 
% ------------------------------- 	 
x.refIMG=       { 'DTI_EPI_seg_30dir_sat_1.nii' };	% use the header from this file
x.reorienttype= [2];	% ---
x.renamestring= 'bla33';	% renamefile to
 ximport2(0,x)
    
end


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
    msg={'FILES TO IMPORT'
        'select the import files' 
        '..these files will be copied to the best-matching mouse-folders'};
    %     [maskfi,sts] = cfg_getfile2(inf,'image',msg,[],prefdir,'img');
    [fi2imp,sts] = cfg_getfile2(inf,'any',msg,[],prefdir,'img|nii');

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
    'inf97'      '*** IMPORT NIFTI &  REPLACE HEADER              '                                                       '' ''
    'inf98'      'imported niftis must:  either (a) contain the mousefolder-name as prefix! of the filename'            '' '' 
    'inf99'      '                           or (b) have to be located in a subfolder with the same mousefolder-name  '                         '' ''
    'inf100'      'here are examples of the two ways to solve the dataimport: '                         '' ''
    'inf101'      'example1:      (a) "20160623HP_M36_myMask.nii"     -->prefix  "20160623HP_M36" indicates the mousefolder-name    '            '' ''
    'inf102'      'example2:      (b) "..\20160623HP_M36\myMask.nii"  -->parent folder "20160623HP_M36" indicates the mousefolder-name    '            '' ''
    'inf1000'     '-------------------------------'                          '' ''
    'refIMG'     't2.nii'    'use the header from this file. This header replaces the header of the import files'        {@selector2,li2,li2h,'out','col-1','selection','single'}
    'reorienttype'  2       'select the reorientation-Type (click right icon for a preview)'          {@dumx,tb,ff}
    'renamestring'   ''    '(optional) enter a new filename for the imported files (without extention)'             '' 
    };

p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI

if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
        'figpos',[.15 .3 .8 .3 ],'title',[ 'IMPORT NIFTIS-replace Header [' mfilename ']'],'info',{'sss'});
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end




%———————————————————————————————————————————————
%%   ok-import that stuff
%———————————————————————————————————————————————


for i=1:size(tb,1)
    f1=fullfile(tb{i,1},[tb{i,2} tb{i,3}]);
    fi=[tb{i,2} tb{i,3}];
    fi=[regexprep(fi,'.nii','') '.nii'];
    
    if ~isempty(z.renamestring) &&  ~isempty(char(z.renamestring));
      fi=[regexprep(z.renamestring,'.nii','') '.nii'];
    end
    
    f2=fullfile(tb{i,4},fi);
    copyfile(f1,f2,'f');
    
    %% reorint
    if ischar(z.refIMG); z.refIMG=cellstr(z.refIMG); end
    [hr r]=rgetnii(fullfile(tb{i,4} , z.refIMG{1} ));
    [ha a]=rgetnii(f2);
    
    v=a;
    eval(ff{z.reorienttype});
    a=v;
    
    
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
    
   disp([pnum(i,4) '] imported file <a href="matlab: explorer('' ' fileparts(f2) '  '')">' f2 '</a>' '; SOURCE: ' '<a href="matlab: explorer('' ' fileparts(f1) '  '')">' f1  '</a>']);% show h<perlink

    
    
end


makebatch(z);



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
txt=(char(us.jCodePane.getText));
b=regexp(txt, '\n', 'split')';
 eval(b{regexpi2(b,'x.refIMG')});
 
 try
     if iscell(x.refIMG)
         refimg=x.refIMG{1};
     else
         refimg=x.refIMG;
     end
     fa =fullfile(tb{1,4},refimg) ; %refIMG
     fb =fullfile(tb{1,1},[tb{1,2} tb{1,3} ]); %importIMG
     [ha a]   =rgetnii(fa);
     [hb b]   =rgetnii(fb); %MASK
 catch
     disp('note: [reorientType] strongly depends on the existence of [refIMG]');
     disp('    -->select another [refIMG]');
     chk=2;
     return
 end
 
 a=a(:,:,:,1);
 ha=ha(1);
 b=b(:,:,:,1);
 hb=hb(1);
 
 a2=a(:,:, ceil(size(a,3)/2));
 b2=b(:,:, ceil(size(b,3)/2));


chk=reorient_check( a2,b2, ff);


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
tb={};
for i=1:size(fi2imp,1)
    [pas fis ext]=fileparts(fi2imp{i});
    tb(i,:)={pas fis ext};
end


tb2={};
for i=1:size(pa,1);
    [pas fis ext]=fileparts(pa{i});
    tb2(i,:)={pas fis };
end


for i=1:size(tb,1)
    
    %% mouse-name inside filename
    [ix,d]=strnearest([   tb{i,2}  ],tb2(:,2)) ;
    %% mouse-name is upper folder
    [pax fold]=fileparts(tb{i,1})
     [ix2,d2]=strnearest([   fold  ],tb2(:,2)) ;    
       
     %% use
     if d<d2
        id=ix ;
     else
        id=ix2;  
     end
 
    tb{i,4}=fullfile(tb2{id,1},tb2{id,2});
end



% id=selector2(tb,{'pa' 'fi' 'ext' 'TargetPath'})


%   'o:\data\pruess2\import\20160623HP_M36'
%     '20160623HP_M36_t222_dum - Kopie'
%     '.nii'
%     'o:\data\pruess2\dat\20160623HP_M36'
    
    
