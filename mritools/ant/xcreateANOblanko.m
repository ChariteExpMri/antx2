%  xcreateANOblanko: create modified ATLAS-excelfile (blanko-file) using the ANO.xlsx-file
%  xcreateANOblanko(showgui, x)
% This function saves a modifed ANO-excel-file with additional columns, 
% regions to include in the new Atlas must be tagged in this modified Excelfile in the "newID"-column.
% Different regions can be merged to one region if the same numeric new ID is given for the regions 
% that should be merged/aggregated. When finihed, this modified Excelfile can be used to gernate a new DTI-atlas
% via ANT-MENU:  atlas/masks //generate DTI-atlas// [2] generate DTI-atlas using the modified excel-file
% This modified Excel-file is simular to the original ANO-excelfile, except that additional columns are inserted: 
% "volume [qmm]": "newID", "hemisphereType", "myRegionName (optional)"
%            #r  -regions with a volumne of "0" do not exist in the corresponding NIFTI-file --> please omit these regions!
% "volume [qmm]": volume of region including it's children (in qmm)
% "newID"       : -insert a new numeric ID for regions to keep in the new DTI-atlas
%               -regions will be merged if the same ID is given for several regions
%               -try to start with number 1 as new numeric ID and use consecutive numbers
%               -  good: 1,2,3...40   ; bad: 1, 500, 7000... 
% "hemisphereType"  -code the hemisperic type {1,2,3,4}
%                (1): code left region only
%                (2): code right region only
%                (3): code left and right region together (same ID)
%                (4): code left and right region separated (different new IDs)
%    --> if hemispheric type is empty, hemisphereType-4 is used (code left and right region separated)
% "myRegionName (optional)": optional enter a new region name (as string) ...just for backup
%   
% #ga __ BATCH ________________
% % Using the standard ANO.xls-file from the studies template-folder as input.
% % Create a modifed ANO-excel-file, save it as 'ANO_modblanko.xlsx' in the folder 'atlas' 
% % within the study-directory:
% z=[];                                                                                                                                                                                                                             
% z.excelfile = 'ANO.xlsx';               % % select atlas-file (ANO.xlsx); if "ANO.xlsx", than the file from the templates-dir is used                                                                                             
% z.outname   = 'ANO_modblanko.xlsx';     % % name of the output excel-file (modified excel-file)                                                                                                                                   
% z.outpath   = 'atlas';                  % % output directory to save the modified excel-file                                                                                                                                      
% xcreateANOblanko(0,z);                        
% 
% #ba __ Command line ________________
% xcreateANOblanko();     % % open GUI with default settings 
% xcreateANOblanko(1,z);  % % open GUI with own settings 
% xcreateANOblanko(0,z);  % % run with own settings without GUI


function xcreateANOblanko(showgui, x)



if 0
    z=[];
    z.excelfile = 'ANO.xlsx';                                      % % select ANO.xlsx
    z.outname   = 'ANO_modblanko.xlsx';                            % % name of the output file
    z.outpath   = 'atlas';                                         % % output directory to save the modified Excel-file
    xcreateANOblanko(0,z);
end

% {'(1) left','(2) right','(3) both united' '(4) both separated '}
% ==============================================
%%   
% ===============================================
global an
atlas=fullfile(fileparts(an.datpath),'templates', 'ANO.xlsx');
if exist(atlas)~=2
    atlas='';
end


%===========================================
%%    GUI
%===========================================
if exist('showgui')~=1;    showgui=1; end
if exist('x')      ~=1;    x=[];      end
if isempty(x);             showgui=1; end

p={...
    'inf1'       'Save Atlas as Excelfile        '         ''               ''
    'excelfile'  atlas                          'select atlas-file (ANO.xlsx); if "ANO.xlsx", than the file from the templates-dir is used'          {  @selectexcelfile}
    'outname'   'ANO_modblanko.xlsx'             'name of the output excel-file (modified excel-file)'  ''
    'outpath'   'atlas'                          'output directory to save the modified excel-file'  'd'
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.2 .5 .8 .3 ],...
        'title','save modified ANO-Excelfile','info',{@uhelp, mfilename});
    if isempty(m);return; end
else
    z=param2struct(p);
end


%===========================================
%%   RUN
%===========================================
cprintf([1 0 1],['wait... '    '\n' ]);
xmakebatch(z,p, mfilename)
process(z);
cprintf([1 0 1],['done... '    '\n' ]);

%===========================================
%%   process
%===========================================
function process(z);



% ==============================================
%%   generate blanko excel-file for DTI-atlas
% ===============================================



xls=z.excelfile;
[pa fi ext]=fileparts(xls);
if isempty(pa)
   global an
   xls=fullfile(fileparts(an.datpath),'templates', [fi '.xlsx']);
end
ano=regexprep(xls,'.xlsx$','.nii');
if exist(ano)~=2;     error([ 'file does not exist: ' ano]);end
if exist(xls)~=2;     error([ 'file does not exist: ' xls]);end

% ==============================================
%%   read NII and xls
% ===============================================
cprintf([0 0 1],['reading NIFTI and EXCELfile..']);
[ha a]=rgetnii(ano);
av=a(:);

[~,~, at0]=xlsread(xls);
at0=xlsprunesheet(at0,1,1);
hat=at0(1,:);
at =at0(2:end,:);
% ==============================================
%%   calc volume
% ===============================================
cprintf([0 0 1],['calc regionwise volume..']);

id    =cell2mat(at(:,4));
childs=cellfun(@(a){[num2str(a)]} ,at(:,5) );
nvox=zeros(length(id),1);
for i=1:length(id)
     ch=[str2num(childs{i})];
     ch(isnan(ch))=[];
    allids= [id(i); ch];
    ix=ismember(av,allids);
    nvox(i,1)=sum(ix);
end
vol=nvox*det(ha.mat(1:3,1:3));
% ==============================================
%%   make table
% ===============================================
nanvec=repmat({nan}, [length(id) 1]);
hat2=[hat(1:4)   'volume [qmm]'   'newID'	'hemisphereType' 'myRegionName (optional)' 'Children' ];
at2= [ at(:,1:4) num2cell(vol)              nanvec      nanvec            nanvec                    at(:,5)];


% ==============================================
%%   save modified excelfile
% ===============================================
cprintf([0 0 1],['saving excelfile..']);

[pamain sdir]=fileparts(z.outpath);
if isempty(pamain)
    global an
    if isempty(sdir); sdir='atlas' ;end
    pamain=fullfile(fileparts(an.datpath));
end
[~, nameout]=fileparts(z.outname);

paout=fullfile(pamain, sdir);
if exist(paout)~=7
    mkdir(paout);
end


% [pa fis ext]=fileparts(xls)
f2=fullfile(paout,[ nameout '.xlsx']);
copyfile(xls,f2,'f');

pwrite2excel(f2,{1 'blanko'},hat2,{},at2);


ms={'"volume [qmm]": shows the volume of that region'
    'a volume of 0 does not exist. This region is not usefull to use as new region or to merge with other regions'
    '"newID": -enter new numeric value for those regions to keep in the new atlas'
    '         -same new ID can be given for several regions...those regions will be merged/aggreagted'
    'hemisphereType:  sets the hemispheric code'
    '  (1)left,(2)right,(3) both united,(4) both separated'
    '  default: (4) both separated...creating a mask for left and right hemisphere separately'
    '  if hemisphereType is keept empty..the hemisphereType-4 is used (both separated) '
    'myRegionName (optional) : you can optionally give another name for the new aggregated regions '
    ''
};
xlsinsertComment(f2,ms, 1, 3, 8);

cprintf([0 0 1],['DONE! \n']);
showinfo2('modifed ANO-file', f2);
%% ________________________________________________________________________________________________



%===========================================
%%   SUBS
%===========================================
% function he= selectatlas(e,e2)

function he= selectexcelfile(e,e2)
he=[];
[t,sts] = spm_select(1,'any','select modified ANO.xlsx file (*.xlsx)','',pwd,'.*.xlsx','');
if t==0; he='';
else;     he=(t);
end

