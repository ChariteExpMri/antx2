

% #wo Allows to 3d colorize user-specific regions by scores/values (percentages/statistical scores) 
% #wo For this, an existing excel-file with selected region-ids and user-specific values/scores will be
% #bo converted. The output (another excel-file) can be used to display the color-coded regions via xvol3d/"myselection"-excel-file
% ====================================================================================================
% function: xvol3d_convertscores.m
% #k Purpose: A selection of atlas-based regions should be displayed using user-specific value/scores.
% # value/scores   : can be derived e.g. from statistic (percent, t-value etc.
% # Input-excelfile: must contain: 
%         1) a column with atlas-based ID's (for each reagion one ID), (arbitrary column name and index)
%         2) a column with values/scores (one value for each region), (arbitrary column name and index) 
% # Output-excelfile: -An output-excel file will be generated. This file can be used in "xvol3d"; ...
%                   - "xvol3d" load this file via "load selection"-button*
%                   * before that you have to load the atlas; to display the regions click "plot regions"
% # Pending user-inputs for conversion:  
% [1] selection of Input-excelfile; [2] sheet-number; [3] column specifying the IDs; 
% [4] column specifying the values/scores; [5] dynamic range; [6] colormap; 
% [4] column specifying the values/scores; [5] dynamic range; [6] colormap
% [7] used atlas [8] filename to store the Output-excelfile
% 
% #b PARAMETER
% 'atlas'    Atlas: this atlas is used here; example fullpath of "ANO.nii"             
% 'file'     This excel file contains region-IDs and values/scores'; which should be plotted
% 'sheet'    select sheet name (string) ; sheet-selection is updated when excelfile is selected 
% 'ID'       index of the column containing region-specific IDs in "file"   
% 'score'    index of the column containing scores/values in "file"  
%            Regions will be color-coded based on the value of the respective region
% 'crange'   color limit range (2 values: lower and upper intensity value)
% 'cmap'     colormap: select on of the available colormaps (string)
% 'fileout'  Excel output filename (can be used later for xvol3d)'     {@uiputfile2}
% 
% #b BATCH
% z=[];                                                                                                                                                                                                                                      
% z.atlas   = 'O:\harms_staircase2\celldetection3\taskC_celldensPerformance\ANOleft.xlsx';                                                           % % Atlas: this atlas is used here                                                      
% z.file    = 'O:\harms_staircase2\celldetection3\taskC_celldensPerformance\input_xvol3d_c_corr_CELLDENS_initialperformance_fdr05sigsOnly.xlsx';     % % Excel file containing region-IDs and values/scores                                  
% z.sheet   = 'initialperformance';                                                                                                                  % % sheet: select sheet; sheet-selection is updated when excelfile is selected          
% z.ID      = [2];                                                                                                                                   % % index of the column containing region-specific IDs in "file"  ...type icon for Info 
% z.score   = [5];                                                                                                                                   % % index of the column containing scores/values in "file" ...type icon for Info        
% z.crange  = [0  1];                                                                                                                                % % color limit range (2 values: lower and upper intensity value ...type icon for Info) 
% z.cmap    = 'PiYG';                                                                                                                                % % colormap: select the colormap                                                       
% z.fileout = 'O:\harms_staircase2\celldetection3\taskC_celldensPerformance\dum35.xlsx';                                                             % % Excel output filename (can be used later for xvol3d)                                
% xvol3d_convertscores(1,z);  % run this; 1st arg (0|1) is silent/visible GUI mode



function xvol3d_convertscores(showgui,x)
% blablo

%===========================================
%%   PARAMS
%===========================================
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end

if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end


p={...
    'inf98'      '*** converter for value-based region coloring (used for "xvol3d") '                         '' ''
    'inf100'     ''                          '' ''
    
    'atlas'     ''          'Atlas: this atlas is used here'                 'f'
    'file'      ''          'Excel file containing region-IDs and values/scores' {@getinputfile}
    'sheet'     ''          'sheet: select sheet; sheet-selection is updated when excelfile is selected '  {'1' '2' '3'}
    'ID'        []          'index of the column containing region-specific IDs in "file"  ...type icon for Info'          {@getinfo}
    'score'     []          'index of the column containing scores/values in "file" ...type icon for Info'       {@getinfo}
    'crange'    [0 1]       'color limit range (2 values: lower and upper intensity value ...type icon for Info) ' {@getinfo}
    'cmap'      'parula'    'colormap: select the colormap' sub_intensimg('getcmap')
    'fileout'   ''          'Excel output filename (can be used later for xvol3d)'     {@uiputfile2}
    };

p=paramadd(p,x);
% %% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .8 .3 ],...
        'title',[mfilename],'info',hlp);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end



disp('..conversion..');
xmakebatch(z,p, mfilename); % ## BATCH


process(z); %process


disp('..done.');





function getinputfile(e,e2)
% paramgui('setdata','x.sheet',{'ee' 'eeed' 'fgffd'})


% ==============================================
%%  input-1. excelfile
% ===============================================
% if ~(isfield(p,'file') && exist(p.file)==2)
msg='Select the input excelfile. This file must contain a column with region-IDs and a column with intensities/scores';
[fi pa]=uigetfile('*.xlsx',msg);
if isnumeric(fi); return; end
p.file=fullfile(pa,fi);
% end
[~,sheets]=xlsfinfo(p.file);
% sheets=cellfun(@(a,b) {[num2str(a) ') ' b]} ,num2cell(1:length(sheets)),sheets);
paramgui('setchoice','x.sheet',sheets);
paramgui('setdata','x.file', p.file);

return

function uiputfile2(e,e2)

msg='save output (as excelfile)';
[fi pa]=uiputfile(fullfile(pwd,'*.xlsx'),msg);
if isnumeric(fi); disp('..not saved'); return; end
p.fileout=fullfile(pa,fi);
paramgui('setdata','x.fileout', p.fileout);
return


function getinfo(e,e2)


lg1={[' #b File              : ' '-not specified -']};
lg2={[' #g Sheet             : ' '-not specified -']};
lg3={[' #r Column names      :   -not specified -']};
lg4={[' #m ID column index   :   -not specified -']};
lg5={[' #m value column index:   -not specified -']};


hfig=gcf;
[w x]=paramgui('getdata');
if exist(x.file)==2
    lg1={[' #b File           : ' x.file]};
    [~,sheets]=xlsfinfo(char(x.file));
end
if exist('sheets') && ~isempty(x.sheet)
    lg2={[' #g Sheet          : "' sheets{find(strcmp(sheets,x.sheet))}  '"'  ]};
    
    [~,~,a]=xlsread(x.file,x.sheet);
    ha=a(1,:);
    a=a(2:end,:);
    head=cellfun(@(a,b) {[num2str(a) ') ' b]} ,num2cell(1:length(ha)),ha)';
end

if exist('head')==1
    lg3={[' #r Column names   : ']};
    lg3=[lg3; head];
end

if exist('head')==1 && ~isempty(x.ID)
    lg4={[' #m ID column index: ' num2str(x.ID) ]};
end
if exist('head')==1 && ~isempty(x.score)
    if ischar(x.score)
        x.score=str2num(x.score);
    end
    lg5={[' #m value column index: '  num2str(x.score)]};
    try
        vals=cell2mat(cellfun(@(a) {[str2num(num2str(a))]} ,a(:,(x.score))));
        dynrange={[' #m Data Info (using column index: ' num2str(x.score)  '): ']};
        dynrange{end+1,1}=sprintf('DATA: n=%d' ,[length(vals)]);
        dynrange{end+1,1}=sprintf('DATA: Min=%2.3f, Max=%2.3f (ME=%2.3f, MED=%2.3f)' ,[min(vals) max(vals) mean(vals) median(vals)]);
    catch
        dynrange={[' #m Data Info (using column index: ' num2str(x.score)  '):  check the index...maybe not correct?']};
    end
    
    lg5=[lg5;dynrange ];
else
    dynrange={' #m Data Info: -unknown, one of the variables are not specified: excelfile/sheet/id/score'};
    lg5=[lg5;dynrange ];
    
end


msg=[[' #wb INPUT-FILE-INFO'];lg1;lg2;lg3;lg4;lg5];
uhelp(msg);
figure(hfig);
return


% ==============================================
%%   process
% ===============================================

function process(p)
'running..';


%check
if isfield(p,'ID')
    if ischar(p.ID)==1;   p.ID=str2num(p.ID);end
end
if isfield(p,'score')
    if ischar(p.score)==1;   p.score=str2num(p.score);end
end

line=repmat('=',[1 100]);



% ==============================================
%%   INFO
% ===============================================
% clc;
% 
% cprintf([ 0 0 1],[line '\n']);
% 
% cprintf([ 0 0 1],['convert excel-file with region-ids and values/scores to color-coded "myselection"-excel-file' '\n']);
% cprintf([ 0 0 1],[line '\n']);
% 
% disp('# Purpose: A selection of atlas-based regions should be displayed using user-specific value/scores.');
% disp('# value/scores   : can be derived e.g. from statistic (percent, t-value etc.');
% disp('# Input-excelfile: must contain: ');
% disp('        1) a column with atlas-based ID''s (for each reagion one ID), (arbitrary column name and index)');
% disp('        2) a column with values/scores (one value for each region), (arbitrary column name and index) ');
% disp('# Output-excelfile: -An output-excel file will be generated. This file can be used in "xvol3d"; ...');
% disp('                  - "xvol3d" load this file via "load selection"-button*');
% disp('                  * before that you have to load the atlas; to display the regions click "plot regions"');
% disp('# Pending user-inputs for conversion:  ');
% disp( '[1] selection of Input-excelfile; [2] sheet-number; [3] column specifying the IDs; ');
% disp( '[4] column specifying the values/scores; [5] dynamic range; [6] colormap; ');
% disp( '[4] column specifying the values/scores; [5] dynamic range; [6] colormap');
% disp( '[7] used atlas [8] filename to store the Output-excelfile');
% 
% cprintf([ 0 0 1],[line '\n']);




% ==============================================
%%   INPUTS
% ===============================================

% ==============================================
%%  input-1. excelfile
% ===============================================
if ~(isfield(p,'file') && exist(p.file)==2)
    msg='[1/8] Select the input excelfile. This file must contain a column with region-IDs and a column with intensities/scores';
    cprintf([ 0 .5 0],[line '\n']);
    cprintf([ 0 .5 0],[msg '\n']);
    
    [fi pa]=uigetfile('*.xlsx',msg);
    if isnumeric(fi); return; end
    p.file=fullfile(pa,fi);
end


[~,sheets]=xlsfinfo(p.file);
sheets=cellfun(@(a,b) {[num2str(a) ') ' b]} ,num2cell(1:length(sheets)),sheets);

% ==============================================
%%  input-2. sheet number
% ===============================================
if ~isfield(p,'sheet')
    cprintf([ 0 .5 0],[line '\n']);
    cprintf([ 0 .5 0],'[2/8] Available SHEETs.\n');
    disp(sheets');
    dum=input('ENTER the sheet-number: ','s');
    p.sheet=str2num(dum);
end

% ==============================================
%%   load xlsfile
% ===============================================
[~,~,a]=xlsread(p.file,p.sheet);
ha=a(1,:);
a=a(2:end,:);
head=cellfun(@(a,b) {[num2str(a) ') ' b]} ,num2cell(1:length(ha)),ha);

% ==============================================
%%  input-3. AtlasID column
% ===============================================
if ~isfield(p,'ID')
    cprintf([ 0 .5 0],[line '\n']);
    cprintf([ 0 .5 0],'[3/8] Available columns names of this sheet.\n');
    disp(head');
    
    dum=input('ENTER column-number refering to the IDs: ','s');
    p.ID=str2num(dum);
end

% ==============================================
%%   input-4. score/value column
% ===============================================
if ~isfield(p,'score')
    cprintf([ 0 .5 0],[line '\n']);
    cprintf([ 0 .5 0],'[4/8] Available columns in this sheet.\n');
    disp(head');
    
    dum=input('ENTER column-number refering to the values/scores to use: ','s');
    p.score=str2num(dum);
end
% ==============================================
%%  input-5. dynamical range to display
% ===============================================
if ~isfield(p,'crange')
    vals=cell2mat(cellfun(@(a) {[str2num(num2str(a))]} ,a(:,p.score)));
    
    cprintf([ 0 .5 0],[line '\n']);
    cprintf([ 0 .5 0],'[5/8] DYNAMIC RANGE.\n');
    disp(sprintf('DATA: n=%d' ,[length(vals)]));
    disp(sprintf('DATA: Min=%2.3f, Max=%2.3f (ME=%2.3f, MED=%2.3f)' ,[min(vals) max(vals) mean(vals) median(vals)]));
    dum=input('ENTER the used dynamic range to display..2 values [min,max]: ','s');
    p.crange=str2num(dum);
end
% ==============================================
%%  input-6. get cmap
% ===============================================

cmaps=sub_intensimg('getcmap')';
cmapsnumber=cellfun(@(a,b) {[num2str(a) ') ' b]} ,num2cell([1:length(cmaps)]'),cmaps);

if isfield(p,'cmap') && ~isempty(p.cmap)
    p.cmapname=p.cmap;
end

if ~isfield(p,'cmapname')
    cprintf([ 0 .5 0],[line '\n']);
    cprintf([ 0 .5 0],'[6/8] AVAILABLE COLORMAPS.\n');
    disp(cmapsnumber);
    dum=input('ENTER the colormap-number: ','s');
    p.cmapname=cmaps{str2num(dum)};
end
if isnumeric(p.cmapname)
    p.cmapname=cmaps{p.cmapname};
end

% ==============================================
%%  input-7. get atlasfile
% ===============================================
if ~(isfield(p,'atlas') && exist(p.atlas)==2)
    msg='[7/8] select the used atlas file (such as ANO.nii)..needed to identify the used region IDs';
    cprintf([ 0 .5 0],[line '\n']);
    cprintf([ 0 .5 0],[msg '\n']);
    
    [fi pa]=uigetfile(fullfile(pwd,'*.xlsx'),msg);
    p.atlas=fullfile(pa,fi);
end



% ==============================================
%%  get making table
% ===============================================

p.cmap=sub_intensimg('getcolor',p.cmapname);

tb1=[a(:,p.ID) a(:,p.score)];
tb1=cell2mat(cellfun(@(a) {[str2num(num2str(a))]} ,tb1));

dynrange=[tb1(:,2); p.crange(:)];
dynrange2=dynrange-min(dynrange);
dynrange2=dynrange2./max(dynrange2); %0-1-range
colidx=round((size(p.cmap,1)-1).*dynrange2)+1;

p.cmapapply   =p.cmap(colidx(1:size(tb1,1)),:);
p.cmapapplyRGB=round(p.cmapapply*255);


% ==============================================
%%  read atlas and find columns with ID
% ===============================================

[~,~,b]=xlsread(p.atlas);
hb=b(1,:);
b=b(2:end,:);

%del nan-columns
idelcol=find(strcmp(cellfun(@(a) {[(num2str(a))]} ,hb),'NaN'));
hb(:,idelcol)=[];
 b(:,idelcol)=[];

% ==============================================
%%  find rows with matching IDs
% ===============================================
aID=find(strcmp(hb,'ID'));
idall=cell2mat(cellfun(@(a) {[str2num(num2str(a))]} ,b(:,aID)));
icolRGB=find(strcmp(hb,'colRGB'));

tb2={};
for i=1:size(tb1,1)
    ix=find(idall==tb1(i,1));
    if ~isempty(ix)
        dx=b(ix,:);
        %change color
          colstr=num2str(p.cmapapplyRGB(i,:));
          colstr=regexprep(colstr,'\s+',' ');
          dx{icolRGB}=colstr;
        %update
        tb2(end+1,:)=dx;
    end
end

% ==============================================
%% input-8. add selection column
% ===============================================
col_selection=repmat({1},[size(tb2,1) 1]);
tb3=[tb2 col_selection];
htb3=[hb 'selection'];

if ~isfield(p,'fileout')
    msg='[8/8] save output (as excelfile). This file can be later loaded via "load selection"-button';
    cprintf([ 0 .5 0],[line '\n']);
    cprintf([ 0 .5 0],[msg '\n']);
    
    [fi pa]=uiputfile(fullfile(pwd,'*.xlsx'),msg);
    if isnumeric(fi); disp('..not saved'); return; end
    p.fileout=fullfile(pa,fi);
end

pwrite2excel(p.fileout,{1 'myTable'},htb3,[],tb3);
disp(['saved as: ' p.fileout]);



















