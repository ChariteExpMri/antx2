
%% #b replace header of within-path file(s) using refIMG (simple method - )
% simple routine to replace the header:
% NOTE: -specifically ,the 4x4 REORIENT-MAT IS REPLACED, and with it the vox-resolution, affine parameters and the origin
% dirs:  works on preselected dirs, i.e. mouse-folders in [ANT] have to be selected before
% ===========================================================================
% 
%% #r HOW-TO: 
% select: one reference-image
% select one/several images, where the header should be replaces 
% note: new file(s) are created by header-replacement
% options: -rename file(s) or use prefix
%          -option: use [data-type] from reference-image  , <default: 0>
% -works with 3d & 4 d-data
%
%% #r RUN-def: 
% function xreplaceheader(showgui,x)
% showgui: (optional)  :  0/1   :no gui/open gui
% x      : (optional)  : struct with following parameters:
%          x.refIMG       : cell with the one REFERENCE IMAGE <must be defined>
%          x.applyIMG     : cell with the image(s), where the header should be replaced  <must be defined>
%          x.renameIMG    : rename files: pairwise (column)  old & newname <optional> 
%          x.fileprefix   : used prefix of new files..prefix is only applied if x.renameIMG is empty
%                           -if x.fileprefix is empty and x.renameIMG is empty ...header is directly replaces in original files (not tested, not recommended)
%          x.keep_dt      : keep applyIMG's DATATYPE    (0,1) ..no/yes   , <optional> default is 1
%          x.recyclebin   : move deleted files to recycle bin ? (0/1)    <optional>, default is 1
% 
%% #r RUN: 
% xreplaceheader(1) or  xreplaceheader    ... open PARAMETER_GUI 
% xreplaceheader(0,z)                     ...NO-GUI, where z is predefined struct 
% xreplaceheader(1,z)                     ...where z is predefined struct 
% 
%% #r BATCH EXAMPLE
% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••                           
% % BATCH:        [xreplaceheader.m]                                                 
% % descr:  replace header of within-path file(s) using refIMG (simple method - )    
% % •••••••••••••••••••••••••••••••••••••••••••••••••••••• 
% z=[];
% z.refIMG={ 'c_MSME-T2-map_20slices_1.nii' };        %REFERENCE IMAGE                                
% z.applyIMG={ 'msme2neu_1.nii'                                                      
%              'nan2neu_2.nii' };                     %images on which the header is replaced                                       
% z.renameIMG='';                                     %<optional> give names new names -->see GUI                                                          
% z.fileprefix='h_';                                  %<optional> use prefix
% z.keep_dt=[1];                                      % keep applyIMG's DATATYPE    (0,1)                                                                 
% xreplaceheader(1,z);                                % run function with GUI
% 
%% #r RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace
% 
% 

function xreplaceheader(showgui,x)


%———————————————————————————————————————————————
%%   example
%———————————————————————————————————————————————
if 0
  
    
    
    
end

%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                           ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ; 
    x=[]          ;
end 

%% get unique-files from all data
% pa=antcb('getsubjects'); %path
v=getuniquefiles(pa);  

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  PARAMETER-gui
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if exist('x')~=1;        x=[]; end
p={...
    'inf0'      '*** REPLACE HEADER      ****     '         '' ''
    'inf1'      ['routine: [' mfilename '.m]']                         '' ''    
    'inf7'     '====================================================================================================='        '' ''
    'refIMG'       {''}      '(<<) SELECT THE REFERENCE IMAGE (headerInformation extracted from this file)'  {@selectfile,v,'single'}
    'applyIMG'     {''}      '(<<) SELECT ONE OR MORE IMAGES where headerInformation should be changed'  {@selectfile,v,'multi'}
    'renameIMG'     ''       '(<<) Rename files (renaming is optional, using GUI)'  {@renamefiles,[],[]}
    'fileprefix'    'h_'     'add a file-prefix to output-files (this is only used if "renameIMG" is empty )'   '' 
    'keep_dt'       1        '(<<) keep [data type, dt] from applyIMG' 'b'
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .8 .3 ],...
           'title','PARAMETERS: replaceheader','info',{'replace header from one/several files by another file'});
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


%———————————————————————————————————————————————
%%   PROCESS
%———————————————————————————————————————————————
%% use-fileprefix 
g=z;
if isempty(g.renameIMG)
    g.fnew=stradd(g.applyIMG, g.fileprefix  ,1);
else
   g.fnew= g.renameIMG(:,2);
end
g.fold=g.applyIMG;

disp('*** REPLACE-HEADER ***');
%% get list
for i=1:size(pa,1)
    ref=fullfile(pa{i},z.refIMG{1});
    if exist(ref)==2
        for j=1:length(g.fold)
            img =fullfile(pa{i},g.fold{j});
            if exist(img)==2
%                 disp('---------');
%                 disp(['ref: ' ref]);
%                 disp(['img: ' img]);
%                 disp('---------');
                 imgnew = fullfile(pa{i},g.fnew{j});
                replaceheader(ref,img,imgnew, g   );
            end
        end
    end
end



 makebatch(z);

 
 
 
 
 
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% subs
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function  replaceheader(ref,img,imgnew, g   );

hr=spm_vol(ref);     hr=hr(1);
ha=spm_vol(img);

copyfile(img,imgnew,'f');
hb = spm_vol(imgnew);
for i = 1:size(hb,1)
    hc     = hb(i)       ; %get orig header
    hc.mat = hr.mat      ; % REPLACE -[mat]
    if g.keep_dt==0
        hc.dt   =hr.dt   ; % replace [dt]
    end
    spm_create_vol(hc);
end
try; delete( strrep(imgnew,'.nii','.mat')  ) ;     end


[~,imgs]=fileparts(img); imgs=[imgs ];
[~,refs]=fileparts(ref); refs=[refs ];


disp([...
    'NEW: <a href="matlab: explorerpreselect(''' imgnew ''')">' imgnew '</a>' ...
    ' OLD: <a href="matlab: explorerpreselect(''' img    ''')">' imgs    '</a>'...
    ' REF: <a href="matlab: explorerpreselect(''' ref    ''')">' refs    '</a>' ]);


% disp(['NEW: <a href="matlab: explorerpreselect(''' imgnew ''')">' imgnew '</a>' ]);
% disp(['OLD: <a href="matlab: explorerpreselect(''' img    ''')">' img    '</a>' ]);
% disp(['REF: <a href="matlab: explorerpreselect(''' img    ''')">' img    '</a>' ]);


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
function v=getuniquefiles(pa)
% keyboard
% global an
% pa=antcb('getallsubjects'); %path
% pa=antcb('getsubjects'); %path

li={};
     fi2={};
     fifull={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii*$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
        fifull=[fifull; files];
    end
    li=unique(fi2);
    [li dum ncountid]=unique(fi2);
    %% count files
    ncount=zeros(size(li,1),1);
    for i=1:size(li,1)
       ncount(i,1) =length(find(ncountid==i));
    end
    %% get properties spm_vol
    fifull2=fifull(dum);
    tb  = repmat({''},[size(fifull2,1)  ,4]);
    tbh ={'Ndims' 'size' 'resolution' 'origin'} ;
    for i=1:size(fifull2,1)
        ha=spm_vol(fifull2{i});
        ha0=ha;
        ha=ha(1);
        if length(ha0)==1
          tb{i,1}='3';
          tag='';
        else
          tb{i,1}='4' ;
          tag= length(ha0);
        end
        tb{i,2}=sprintf('%i ',[ha.dim tag]);
        tb{i,3}=sprintf('%2.2f ',diag(ha.mat(1:3,1:3))');
        tb{i,4}=sprintf('%2.2f ',ha.mat(1:3,4)')  ;
    end
 
    
 v.tb =[li cellstr(num2str(ncount)) tb];
 v.tbh=[{'Unique-Files-In-Study', '#found'} tbh];
 
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function he=selectfile(v,selectiontype)
he=selector2(v.tb,v.tbh,...
    'out','col-1','selection',selectiontype);

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%________________________________________________
%%  rename files
%________________________________________________
function he=renamefiles(li,lih)
% keyboard

%% get parameter from paramgui
hpara = findobj(0,'tag','paramgui');
us    = get(hpara,'userdata');
txt   = char(us.jCodePane.getText);
eval(txt);

filex    = x.applyIMG(:)   ; 
tbrename = [unique(filex(:))  repmat({''}, [length(unique(filex(:))) 1])  ]; % old name & new name

    
%% make figure
f = fg; set(gcf,'menubar','none','units','normalized','position',[    0.3049    0.4933    0.6    0.3922]);
t = uitable('Parent', f,'units','norm', 'Position', [0 0.1 1 .8], 'Data', tbrename,'tag','table',...
    'ColumnWidth','auto');
t.ColumnName = {'distributed files                          ',...
                'new name        (without path and without extension)         ',...
%                 'used volumes (inv,1,3:5),etc             ',...
%                 '(c)copy or (e)expand                  ',...
                };
            
%columnsize-auto            
set(t,'units','pixels');
pixpos=get(t,'position')  ;
set(t,'ColumnWidth',{pixpos(3)/2});
set(t,'units','norm');


t.ColumnEditable = [false true  ];
t.BackgroundColor = [1 1 1; 0.9451    0.9686    0.9490];

tx=uicontrol('style','text','units','norm','position',[0 .95 1 .05 ],...
    'string',      '..new filenames can be given here...',...
    'fontweight','bold','backgroundcolor','w');
pb=uicontrol('style','pushbutton','units','norm','position',[.05 0.02 .15 .05 ],'string','OK','fontweight','bold','backgroundcolor','w',...
    'callback',   'set(gcf,''userdata'',get(findobj(gcf,''tag'',''table''),''Data''));'          );%@renameFile


h={' #yg  ***COPY FILES or EXPAND 4D-files  ***'} ;
h{end+1,1}=['# 1st column represents the original-name '];
h{end+1,1}=['# 2nd column contains the new filename (without file-path and without file-extension !!)'];
h{end+1,1}=['  -if cells in the 2nd column are empty (no new filename declared), the original filename is used '];
 

%    uhelp(h,1);
%    set(gcf,'position',[ 0.55    0.7272    0.45   0.1661 ]);

setappdata(gcf,'phelp',h);

pb=uicontrol('style','pushbutton','units','norm','position',[.85 0.02 .15 .05 ],'string','Help','fontweight','bold','backgroundcolor','w',...
    'callback',   'uhelp(getappdata(gcf,''phelp''),1); set(gcf,''position'',[    0.2938    0.4094    0.6927    0.4933 ]);'          );%@renameFile
% set(gcf,''position'',[ 0.55    0.7272    0.45   0.1661 ]);
drawnow;
waitfor(f, 'userdata');
% disp('geht weiter');
tbrename=get(f,'userdata');
ikeep=find(cellfun('isempty' ,tbrename(:,2))) ;
ishange=find(~cellfun('isempty' ,tbrename(:,2))) ;

oldnames={};
for i=1:length(ikeep)
    [pas fis ext]=fileparts(tbrename{ikeep(i),1});
    tbrename(ikeep(i),2)={[fis ext]};
end
oldnames={};
for i=1:length(ishange)
    [pas  fis  ext]=fileparts(tbrename{ishange(i),1});
    [pas2 fis2 ext2]=fileparts(tbrename{ishange(i),2});
    tbrename(ishange(i),2)={[fis2 ext]};
end
he=tbrename;
%     disp(tbrename);
close(f);
    




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
hh=[hh; 'z=[];' ];
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

