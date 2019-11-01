%% #b copy/rename or expand nifti-files
% #by FUNCTION 
% z=xcopyrenameexpand(showgui,x,pa)
% #by INPUT
% showgui: 0/1  :show the gui ; if [1] or []--> gui is opened
% x      : struct with config-parameters
% pa     : cell with mousepaths to process, if empty use current selection from ant-TBX
% #by OUTPUT
% cellaray, for batching

function xcopyrenameexpand(showgui,x,pa)


%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getsubjects')  ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end





%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
if 1
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; [[fis files] ]   ];
    end
    [a1 b1 ]=unique(fi2(:,1));
    niparas={};
    for i=1:length(b1)
        he=spm_vol(fi2{b1(i),2});
        niparas(i,:)= {
            [num2str(length(he(1).dim) +(size(he,1)>1)) '-D']    % 3d vs 4d
            num2str(size(he,1))                                 %No volumes
            regexprep(num2str(he(1).dim),' +',' ')              %first 3dims
          he(1).descrip };                                      %descript
    end
    li=[a1 niparas];
    lih={'nifti'  '3d/4d'  '#Vol' 'dims_1-3' 'descript'};
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  PARAMETER-gui
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if exist('x')~=1;        x=[]; end

p={...
    'inf1'      '••• COYP/RENAME OR EXPAND VOLUMES   •••             '                         '' ''
    'inf2'      'select files and follow gui-instructions' ,'' ''
    'inf100'      [repmat('—',[1,100])]                            '' ''
    'files'   ''   'SELECT ONE/MORE FILES HERE'  {@renamefiles,li,lih}
    };


p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[    0.3351    0.6644    0.3035    0.1594 ],...
        'title','••• COYP/RENAME OR EXPAND VOLUMES   •••','info',{'sss'});
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


%———————————————————————————————————————————————
%%   process
%———————————————————————————————————————————————

process(z,pa);

makebatch(z);


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%•••••••••••••••••••••••••••••••	subs        •••••••••••••••••••••••••••••••••••••••••••••••••••••
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

try
    v = evalin('base', 'anth');
catch
    v={};
    assignin('base','anth',v);
    v = evalin('base', 'anth');
end
v=[v; hh; {'                '}];
assignin('base','anth',v);



function process(z,pa)

if 0
    z.files={    'nan_4d.nii'    'a'    '2'    'e'
                 'rare4d.nii'    'b'    '2'    'e'
                 't1.nii'        'c'    '1'    'e'}
    pa={   'O:\data\karina\dat\_axax_01'}
%         'O:\data\karina\dat\_axax_02'
%         'O:\data\karina\dat\_axax_03'
%         'O:\data\karina\dat\_axax_04'
end


%% chck existence of files in highlighted folder
tb={};
for i=1:size(pa,1)
    for j=1:size(z.files,1)
        tp=fullfile(pa{i},z.files{j,1});
        if exist(tp)==2
            tb(end+1,:) =   [ tp z.files(j,:) ];
        end
    end
end
if isempty(tb);   return   ;    end

%% OK now copy&rename or exapnd
for c=1:size(tb,1)
    [ha a]=rgetnii(tb{c,1});      %%SOURCE
    [pax fix ext]=fileparts(tb{c,1});
    newname=fullfile(pax , [ strrep(tb{c,3},'.nii','') ext ]); %NEWNAME
    
    %% THIS VOLUMES
    vol=str2num(tb{c,4});
    if isinf(vol);
        vol=1:size(ha,1);
    end
    
    %% use this data
    hr=ha(vol);
    r=a(:,:,:,vol);
    
    %% COPY N RENAME  (C)
    if strcmp(tb{c,5},'c')
        for k=1:size(hr,1);
            hr(k).fname=newname;
            hr(k).n=[k 1];
            spm_create_vol(hr(k));
            spm_write_vol(hr(k),r(:,:,:,k));
        end
        %% delete MAT-file
        try ;         delete( strrep(newname,'.nii','.mat')  ); end
        disp([pnum(i,4) '] copy&renamed file <a href="matlab: explorer('' ' fileparts(newname) '  '')">' newname '</a>'  ]);
    end
    
    
    %% expand  (e)
    if strcmp(tb{c,5},'e')
        for k=1:size(hr,1);
            he=hr(k);
            if size(hr,1)==1 %ONLY ONE VOL EXPANDED -->NO NUMMERATIVE SUFFIX
                he(k).fname=newname;
            else
                he.fname=stradd(newname,['_' pnum(hr(k).n(1),3)],2);
            end
            he.n=[1 1];
            
            spm_create_vol(he);
            spm_write_vol(he,r(:,:,:,k));
        end
        %% delete MAT-file
        disp([pnum(i,4) '] expaned sourcefile <a href="matlab: explorer('' ' fileparts(newname) '  '')">' newname '</a>'  ]);
    end
    
    
end
















function he=renamefiles(li,lih)
% keyboard

filex=selector2(li,lih,'out','col-1','selection','multi');


tbrename=[unique(filex(:))  ...                             %old name
         repmat({''}, [length(unique(filex(:))) 1])  ...   %new name
         repmat({'inf'}, [length(unique(filex(:))) 1])  ...  %slice
         repmat({'c'}, [length(unique(filex(:))) 1])  ...  %suffix
         ];

f = fg; set(gcf,'menubar','none','units','normalized','position',[    0.3049    0.4933    0.6    0.3922]);
t = uitable('Parent', f,'units','norm', 'Position', [0 0.1 1 .8], 'Data', tbrename,'tag','table');
t.ColumnName = {'filename name                          ',...
                'new name        (no extension)         ',...
                'used volumes (inv,1,3:5),etc             ',...
                '(c)copy or (e)expand                  ',...
                
                };

t.ColumnEditable = [false true  true true];
t.BackgroundColor = [1 1 1; 0.9451    0.9686    0.9490];

tx=uicontrol('style','text','units','norm','position',[0 .96 1 .03 ],...
    'string','copy&rename or expand 4d data','fontweight','bold','backgroundcolor','w');
pb=uicontrol('style','pushbutton','units','norm','position',[.05 0.02 .15 .05 ],'string','OK','fontweight','bold','backgroundcolor','w',...
    'callback',   'set(gcf,''userdata'',get(findobj(gcf,''tag'',''table''),''Data''));'          );%@renameFile


h={' #yg  ***COPY FILES or EXPAND 4D-files  ***'} ;
h{end+1,1}=['# 1st column represents the original-name '];
h{end+1,1}=['# 2nd column contains the new filename (no file extension !!)'];
h{end+1,1}=['  -if cells in the 2nd column are empty, the original filenam is used, BUT BE CAREFUL!!!: '];
h{end+1,1}=['  -for copy&renaming a file (see column-4) a new filename must be defined'];
h{end+1,1}=['  -for extracting only one volume from a 4d-nifti a new filename must be defined, too ']; 
h{end+1,1}=['  -for extracting 2 or more volumes  a new filename is OPTIONAL !!,  because a suffix ']; 
h{end+1,1}=['   with the volumeNumber is added to the filename (irrespective whether this is the old']; 
h{end+1,1}=['   or new filename']; 

                
h{end+1,1}=['# 3rd column specifies the used volumes: '];
h{end+1,1}=['  -examples: '];
h{end+1,1}=['     inv: take all volumes: if nifti-file has 3dims this is the same as taking the 1st volume '];
h{end+1,1}=['       3: take volume number 3'];
h{end+1,1}=['   [1:3]: take volumes 1,2 and 3'];
h{end+1,1}=['#4th column specifies whether volumes should be (c)[COPIED-AND-RENAMED] or (e) [EXPANDED]  '];
h{end+1,1}=['      - type: c  if you want to [copy&rename] a volume'];
h{end+1,1}=['      - type: e  if you want to [expand] a volume, i.e extract volumes from a 4dim-nifit     '];
h{end+1,1}=['      - if a nifit-file is expanded and more than 2 volumes are extracted (see column-3)'];
h{end+1,1}=['        the new file (either with the old or the new filename) containes the  '];
h{end+1,1}=['        suffix "_v with the volumeNumber, example: bold_v001.nii, bold_v002.nii   '];

h{end+1,1}=[' NOTE: [COPY&RENAME]:  FOR COPY&RENAME FILES A NEW FILENAME HAS TO BE SPECIFIED !!!  '];
h{end+1,1}=[' NOTE: [VOLUMEEXPANSION]: IF ONLY ONE VOLUME IS EXPANDED FROM NIFTI, NEW FILENAME HAS TO BE SPECIFIED, TOO !!!  '];



h{end+1,1}=[' if cells in the 2nd column are empty, the original name is used (left column)'];
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
tbrename(ikeep,2)=tbrename(ikeep,1);
he=tbrename;
%     disp(tbrename);
close(f);
    












