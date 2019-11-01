
%% #b DELETE within-path file(s)  
%  delete one/several images from study-mouse-folders
%  NOTE: file-deletion works on PRESELECTED DIRECTORIES, i.e.: select the mouse-folders in [ANT] in advance 
%  to delete the files OF these folders
% **********************************************
%% #by FUNCTION 
% function xdeletefiles(showgui,x)
%% #by INPUT
% showgui: (optional)   % : 0/1   :no gui/open gui
% x      : (optional)   % : struct with following parameters
%          x.files      % : cell with filenames thas should be deleted   <must be defined>
%          x.recyclebin % : move deleted files to recycle bin ? (0/1)    <optional>, default is 1
%% #by RUN
% xdeletefiles(1) or  xdeletefiles     % ... open PARAMETER_GUI 
% xdeletefiles(0,z)                    % ...NO-GUI, z is the predefined struct 
% xdeletefiles(1,z)                    % ...with GUI, z is the predefined struct 
% 
%% #by BATCH EXAMPLE
% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••                           
% % BATCH:        [xdeletefiles.m]                                                   
% % descr:  DELETE within-path file(s)                                               
% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••                           
% z.files={ 'mist.nii'                                                               
%           'mist1.nii' };    %delete this two files                                                          
% z.recyclebin=[1];           %move files to recycle-bin ('papierkorb')                                                  
% xdeletefiles(1,z)           %ok, do it but also open the gui
% 
%% #by RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace

function xdeletefiles(showgui,x)


%———————————————————————————————————————————————
%%   example
%———————————————————————————————————————————————
 

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
    'inf0'      '***  DELETE FILES      ****     '         '' ''
    'inf1'      ['routine: [' mfilename '.m]']                         '' ''    
    'inf7'     '====================================================================================================='        '' ''
    'files'          {''}      '(<<) SELECT FILES TO DELETE '  {@selectfile,v,'multi'}
    'recyclebin'     0         '(<<) use RECYCLE-BIN (1), OR DELETE PERMANENTLY (0) '     'b'
%     'applyIMG'     {''}      '(<<) SELECT ONE OR MORE IMAGES where headerInformation should be changed'  {@selectfile,v,'multi'}
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .8 .3 ],...
           'title','PARAMETERS: DELETE FILES','info',{'DELETE ONE/SEVERAL FILES, BASED ON PRESELECTED MOUSE-PATHS'});
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


%———————————————————————————————————————————————
%%   PROCESS
%———————————————————————————————————————————————
if ischar(z.files); z.files=cellstr(z.files); end
if isempty(z.files{1}) ;
    return
end

%% recycle bin
if z.recyclebin==1
    recycle('on');
else
    recycle('off');
end

for i=1:size(pa,1)
    for j=1:length(z.files)
        fi=fullfile(pa{i},z.files{j});
        if exist(fi)==2
            try; delete(fi); 
                disp(['deleted:' fi]);
            end
        end
    end
end


 makebatch(z);

 
 
 
 
 
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% subs
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
 


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


function makebatch(z)
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
hh=[hh; 'z.files=[];' ];
hh=[hh; struct2list(z)];
hh(end+1,1)={[mfilename '(' '1',  ',z' ');' ]};
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

