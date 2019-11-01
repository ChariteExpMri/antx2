


%% #b create incidenzeMaps (heatmaps) based on masks (lesionmasks)
% incidencemaps can be stores as  -absolute values (sum of overlaps across masks;i.e. the logical-state of ones)
%                              or -percent values 
% the output is a nifti-file stored in the studie's results folder (results-folder is created if its not existing)
% additionally an infofile (same name.txt) with includers/excluders is stored in the results-folder
% % works via GUI
% #by INPUT PARAMETER (GUI)
% 
%     'type'              the output value type, either [abs] or [percent] for absolue (n) or percent
%                         values   (see icon)
%     'outputnamePrefix'  '<optional> a second Prefix for the output filename (nifti-file stored in 
%                         results-folder)'  (see also icon for examples)
%     'files'             selected the files, usually binary maskfiles, here  -->use the left icon to
%                         select the files 
%                         The file-selection is performed first via a file-filter (search for unique
%                         filename across mouse folders) 
%                         and than via a specific selector to allow to exclude cases
% #by OUTPUT
%  -the output is a nifti-file stored in the studie's results-folder (in case, this folder is created)
%__________________________________________________________________________________________
% #r ====================================================================================================
% #r NOTE: all masks must have the same world space (usually you hvae to transform the masks into Allen space) 
% #r       with identical voxelsize and bounding-box
% #r ====================================================================================================
% #yg EXAMPLE
% z=[];
% z.type='abs';                    % output in absulute values (sum)
% z.outputnamePrefix='MCAO';       % addtional prefix in the output-file
% z.files={ 'O:\harms1\harms3_lesionfill\dat\s20150505SM01_1_x_x\x_masklesion.nii' % masks used, note, this files have been transformed into Allen Space
%           'O:\harms1\harms3_lesionfill\dat\s20150505SM02_1_x_x\x_masklesion.nii' 
%           'O:\harms1\harms3_lesionfill\dat\s20150505SM03_1_x_x\x_masklesion.nii' 
%           'O:\harms1\harms3_lesionfill\dat\s20150505SM05_1_x_x\x_masklesion.nii' 
%           'O:\harms1\harms3_lesionfill\dat\s20150505SM09_1_x_x\x_masklesion.nii' 
%           'O:\harms1\harms3_lesionfill\dat\s20150505SM10_1_x_x\x_masklesion.nii' 
%           'O:\harms1\harms3_lesionfill\dat\s20150506SM12_1_x_x\x_masklesion.nii' 
%           'O:\harms1\harms3_lesionfill\dat\s20150506SM18_1_x_x\x_masklesion.nii' 
%           'O:\harms1\harms3_lesionfill\dat\s20150506SM19_1_x_x\x_masklesion.nii' 
%           'O:\harms1\harms3_lesionfill\dat\s20150507SM24_1_x_x\x_masklesion.nii' 
%           'O:\harms1\harms3_lesionfill\dat\s20150507SM27_1_x_x\x_masklesion.nii' 
%           'O:\harms1\harms3_lesionfill\dat\s20150507Sm25_1_x_x\x_masklesion.nii' };
% xincidencemap(1,z);  % run this function but show the GUI before ( set the first parameter to 0 to run without GUI)
% 
% #yg FUNCTION INFOS
% z=xincidencemap(showgui,x,pa)
% #by FUNCTION INPUT
% showgui: 0/1  :show the gui ; if [1] or []--> gui is opened
% x      : struct with config-parameters
% pa     : cell with mousepaths to process, if empty use current selection from ant-TBX
% #by FUNCTION OUTPUT
% cellaray, for batching




function xincidencemap(showgui,x,pa)


%———————————————————————————————————————————————
%%   PARAMS
%———————————————————————————————————————————————
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getallsubjects')  ;end

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
%             num2str(size(he,1))   
            num2str(length(regexpi2(fi2(:,1),fi2{b1(i),1}))) %No volumes
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
    'inf1'      '••• make incidence maps   •••             '                         '' ''
    'inf2'      'select mask files ' ,'' ''
    'inf100'      [repmat('—',[1,100])]                            '' ''
    'type'          'abs'    'choose the output type ([abs] absulute or [percent] percent values )'  {'abs','percent'}
    'outputnamePrefix'   ''    'additional Prefix for output (nifti-file stored in results-folder)'  {'imap' 'lesion','mcao'}
    'files'   ''   'select Maskfiles here (example select all x_masklesion.nii-files)'  {@uniquefiles,li,lih,fi2}
    
    };


p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[   0.3351    0.3039    0.6049    0.5200 ],...
        'title','••• MAKE INCIDENCEMAP   •••','info',{'FUNCTION TO MAKE INCIDENCEMAPS'});
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


%———————————————————————————————————————————————
%%   process
%———————————————————————————————————————————————

if isempty(z.files); disp(' no maskfiles selected') ;return ; end


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
clc;
n=0;
fiused={};
fierror={};
for i=1:size(z.files,1)
    [pax fix ext]=fileparts(z.files{i});
    [~, mpa   ]=fileparts(pax);
    S = sprintf(['reading [' num2str(i) '/' num2str(size(z.files,1))  '] :  %s'],  strrep(fullfile(mpa,[fix ext]),filesep,[filesep filesep]) );
    %   S = sprintf(['reading [' num2str(i) '//' num2str(size(z.files,1))  '] :  %s'],  [mpa] );
    fprintf(S);
    [ha a] =rgetnii(z.files{i});
        if i==1
            a2=single(zeros([size(a) 1]));
        end
    try
        a2=a2+a;
        n=n+1;
        fiused(end+1,1)=z.files(i);
        hb=ha;
    catch
        fierror(end+1,1)=z.files(i);
    end
    %     pause(0.1);
    fprintf(repmat('\b',1,numel(S))); 
end

if strcmp(z.type,'percent')
    a2=a2./n*100;
    vtype='perc';
else
    vtype='abs';
end

%———————————————————————————————————————————————
%%   save nifti
%———————————————————————————————————————————————
outdir=fullfile(fileparts(fileparts(pa{1})), 'results');
mkdir(outdir);

if ~isempty(z.outputnamePrefix);  z.outputnamePrefix=[ '_' z.outputnamePrefix ]; end

timex=timestr(1);
fiout=fullfile(outdir,[['imap' z.outputnamePrefix '_' vtype '_' timex '.nii' ] ]);
rsavenii(fiout,hb,a2);

fiout2=fullfile(outdir,[['imap' z.outputnamePrefix '_' vtype '_' timex '.txt' ] ]);

lg={};
lg{end+1,1}=['incidenceMaps: ' z.outputnamePrefix ];
lg{end+1,1}=['file: ' fiout ];
lg{end+1,1}=['type: ' z.type ];
lg{end+1,1}=['n included: ' num2str(size(fiused,1))  ];
lg{end+1,1}=['n excluded: ' num2str(size(fierror,1))  ];
lg{end+1,1}=['    '  ];
lg{end+1,1}=['** included files: ***'  ];
lg=[lg; fiused];
lg{end+1,1}=['** excluded files due to missing masks or world space deviances: ***'  ];
if isempty(fierror)
    lg=[lg; 'none'];
else
    lg=[lg; fierror];
end
pwrite2file(fiout2,lg);
    

try
%     explorerpreselect(fileout);
    disp(['created INCIDENCEMAP: <a href="matlab: explorerpreselect(''' fiout ''')">' 'show file' '</a>'  ]);
catch
    try
    explorer(outdir) ;
    end
end





%———————————————————————————————————————————————
%%   uniquefiles
%———————————————————————————————————————————————
function filex2=uniquefiles(li,lih,fi2)
% keyboard

filex=selector2(li,lih,'out','col-1','selection','multi','title','SELECTION FILTER: choose "mother-file(s)" to make IncidenceMaps [example "x_masklesion.nii"]');
ind=[];
for i=1:size(filex,1)
  ind=[ind; regexpi2(fi2(:,1),filex(i))];
end
fis=fi2(ind,2);
filex2=selector2(fis,{'files'},'out','col-1','selection','multi','title','Select files to make IncidenceMaps, (unselected files are not considered)');
% 
% 
% tbrename=[unique(filex(:))  ...                             %old name
%          repmat({''}, [length(unique(filex(:))) 1])  ...   %new name
%          repmat({'inf'}, [length(unique(filex(:))) 1])  ...  %slice
%          repmat({'c'}, [length(unique(filex(:))) 1])  ...  %suffix
%          ];
%      
% tb=     
% 
% f = fg; set(gcf,'menubar','none','units','normalized','position',[    0.3049    0.4933    0.6    0.3922]);
% t = uitable('Parent', f,'units','norm', 'Position', [0 0.1 1 .8], 'Data', tbrename,'tag','table');
% t.ColumnName = {'filename name                          ',...
%                 'new name        (no extension)         ',...
%                 'used volumes (inv,1,3:5),etc             ',...
%                 '(c)copy or (e)expand                  ',...
%                 
%                 };
% 
% t.ColumnEditable = [false true  true true];
% t.BackgroundColor = [1 1 1; 0.9451    0.9686    0.9490];
% 
% tx=uicontrol('style','text','units','norm','position',[0 .96 1 .03 ],...
%     'string','copy&rename or expand 4d data','fontweight','bold','backgroundcolor','w');
% pb=uicontrol('style','pushbutton','units','norm','position',[.05 0.02 .15 .05 ],'string','OK','fontweight','bold','backgroundcolor','w',...
%     'callback',   'set(gcf,''userdata'',get(findobj(gcf,''tag'',''table''),''Data''));'          );%@renameFile
% 
% 
% h={' #yg  ***COPY FILES or EXPAND 4D-files  ***'} ;
% h{end+1,1}=['# 1st column represents the original-name '];
% h{end+1,1}=['# 2nd column contains the new filename (no file extension !!)'];
% h{end+1,1}=['  -if cells in the 2nd column are empty, the original filenam is used, BUT BE CAREFUL!!!: '];
% h{end+1,1}=['  -for copy&renaming a file (see column-4) a new filename must be defined'];
% h{end+1,1}=['  -for extracting only one volume from a 4d-nifti a new filename must be defined, too ']; 
% h{end+1,1}=['  -for extracting 2 or more volumes  a new filename is OPTIONAL !!,  because a suffix ']; 
% h{end+1,1}=['   with the volumeNumber is added to the filename (irrespective whether this is the old']; 
% h{end+1,1}=['   or new filename']; 
% 
%                 
% h{end+1,1}=['# 3rd column specifies the used volumes: '];
% h{end+1,1}=['  -examples: '];
% h{end+1,1}=['     inv: take all volumes: if nifti-file has 3dims this is the same as taking the 1st volume '];
% h{end+1,1}=['       3: take volume number 3'];
% h{end+1,1}=['   [1:3]: take volumes 1,2 and 3'];
% h{end+1,1}=['#4th column specifies whether volumes should be (c)[COPIED-AND-RENAMED] or (e) [EXPANDED]  '];
% h{end+1,1}=['      - type: c  if you want to [copy&rename] a volume'];
% h{end+1,1}=['      - type: e  if you want to [expand] a volume, i.e extract volumes from a 4dim-nifit     '];
% h{end+1,1}=['      - if a nifit-file is expanded and more than 2 volumes are extracted (see column-3)'];
% h{end+1,1}=['        the new file (either with the old or the new filename) containes the  '];
% h{end+1,1}=['        suffix "_v with the volumeNumber, example: bold_v001.nii, bold_v002.nii   '];
% 
% h{end+1,1}=[' NOTE: [COPY&RENAME]:  FOR COPY&RENAME FILES A NEW FILENAME HAS TO BE SPECIFIED !!!  '];
% h{end+1,1}=[' NOTE: [VOLUMEEXPANSION]: IF ONLY ONE VOLUME IS EXPANDED FROM NIFTI, NEW FILENAME HAS TO BE SPECIFIED, TOO !!!  '];
% 
% 
% 
% h{end+1,1}=[' if cells in the 2nd column are empty, the original name is used (left column)'];
% %    uhelp(h,1);
% %    set(gcf,'position',[ 0.55    0.7272    0.45   0.1661 ]);
% 
% setappdata(gcf,'phelp',h);
% 
% pb=uicontrol('style','pushbutton','units','norm','position',[.85 0.02 .15 .05 ],'string','Help','fontweight','bold','backgroundcolor','w',...
%     'callback',   'uhelp(getappdata(gcf,''phelp''),1); set(gcf,''position'',[    0.2938    0.4094    0.6927    0.4933 ]);'          );%@renameFile
% % set(gcf,''position'',[ 0.55    0.7272    0.45   0.1661 ]);
% drawnow;
% waitfor(f, 'userdata');
% % disp('geht weiter');
% tbrename=get(f,'userdata');
% ikeep=find(cellfun('isempty' ,tbrename(:,2))) ;
% tbrename(ikeep,2)=tbrename(ikeep,1);
% he=tbrename;
% %     disp(tbrename);
% close(f);
    












