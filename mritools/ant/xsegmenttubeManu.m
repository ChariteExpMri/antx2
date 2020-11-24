%% #b manually segment several animals from the same image /tube
% output is a mask-file with a cluster-number (indices 1..to x) for each animal in the image
% DIRS:  works on preselected mouse dirs, i.e. mouse-folders in [ANT] have to be selected before
% #r Masks ar drawned manually! 
% #g For information how to segment manually see 'fsegtubeManu.m' or type uhelp('fsegtubeManu.m')
% #g or hit [help] button in the subsquent UI when running this function
% ______________________________________________________________________________________________
%
%% #ky PARAMETER:
%    file        : IMAGE to segment or use filestring with wildcards (example:  "*t0*.nii")
%                  use icon to select the respective file
%    volnumber   : for 4D-volume ,select index of volume in 4th dimension (default: 1)
%                  default: 1
%    showresult  : show the resulting segmented image {0,1}; (default: 1)
%    saveresult  : save resulting segmented image {0,1}; (default: 1)
%    savename    : name of the output filename; default is 'seganimal'
% ______________________________________________________________________________________________
%% #ky RUN-def:
% xsegmenttubeManu(showgui,x)
% with inputs:
% showgui: (optional)  :  0/1   :no gui/open gui
% x      : (optional)  : struct with one/more specified parameters from above:
%
% xsegmenttubeManu(1) or  FUNCTION    ... open PARAMETER_GUI with defaults
% xsegmenttubeManu(0,z)                ...run without GUI with specified parametes (z-struct)
% xsegmenttubeManu(1,z)                ...run with opening GUI with specified parametes (z-struct)
% ______________________________________________________________________________________________
%% #ky BATCH EXAMPLE
% 
% % =====================================================                                                                                            
% % #g FUNCTION:        [xsegmenttubeManu.m]                                                                                                         
% % #b info :              #b manually segment several animals from the same image /tube                                                             
% % =====================================================                                                                                            
% z=[];                                                                                                                                                
% z.file       = {'t0.nii'};        % % SELECT IMAGE to segment or filestring with wildcards                                                      
% z.volnumber  = [1];               % % for 4D-volume only: select index of volume in 4th dimension (default: 1)                                       
% z.showresult = [1];               % % show resulting segmented image {0,1}                                                                           
% z.saveresult = [1];               % % save resulting segmented image {0,1}                                                                           
% z.savename   = 'seganimal';       % % name of the output filename                                                                                    
% xsegmenttubeManu(1,z);            % % run function with visible GUI 
% ______________________________________________________________________________________________
%
%% #r RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace

function xsegmenttubeManu(showgui,x)




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


% ==============================================
%%    PARAMETER-gui
% ===============================================
if exist('x')~=1;        x=[]; end
p={...
    'inf0'      '*** Manually segment animals in tube     ****     '         '' ''
    'inf1'      ['routine: [' mfilename '.m]']                         '' ''
    'inf7'     '====================================================================================================='        '' ''
    'file'          {''}    '(<<) SELECT IMAGE to segment or filestring with wildcards'  {@selectfile,v,'single'}
    'volnumber'   1         'for 4D-volume only: select index of volume in 4th dimension (default: 1)'    ''
     ...
    'showresult'   1            'show resulting segmented image {0,1} '    'b'
    'saveresult'   1            'save resulting segmented image {0,1} '    'b'
    'savename'     'seganimal'  'name of the output filename'  {'seganimal'}
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .475 .6 .2 ],...
        'title',[ 'segment multitube image manually' '[' mfilename '.m]'],'info',{@uhelp, [mfilename '.m']});
    if isempty(m);    return ;    end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


% ==============================================
%%    BATCH
% ===============================================
g=z;
xmakebatch(z,p, mfilename);

% ==============================================
%%    subprocess
% ===============================================


process(z);





% ==============================================
%%   generate list of nifit-files within pa-path
% ===============================================


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
%REMOVE FILE if empty folder found
idel        =find(cell2mat(cellfun(@(a){[ isempty(a)]},fifull)));
fifull(idel)=[];
fi2(idel)   =[];


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

% ==============================================
%%
% ===============================================
function he=selectfile(v,selectiontype)
he=selector2(v.tb,v.tbh,...
    'out','col-1','selection',selectiontype);



function process(z)


z.file=char(z.file);
pas=antcb('getsubjects');
fis=stradd(cellstr(pas),[ filesep z.file ],2);

for i=1:length(fis)
    %disp(i);
    z.i=i;
    process2(fis{i},z)
end

function process2(fi,z)

[pa name ext ]=fileparts(fi);
if isempty(ext); ext='.nii'; end
k=dir(fullfile(pa, [name ext]));
if isempty(k)
    return
end
file= k(1).name;
fi2=fullfile( pa,file );
[~,mdir]=fileparts(pa);

cprintf([0 .5 0],[ repmat('=',[1 length(mdir)*2]) '\n']);
cprintf([0 .5 0],[num2str( z.i)  '] '  mdir '\n'])
cprintf([0 .5 0],[ repmat('=',[1 length(mdir)*2]) '\n']);

volnum      =z.volnumber;  %1
showit      =z.showresult;


% if 0
% v=fsegtube(fi2,volnum, extmin,expectclass,sortmode, showit);
% end

v=fsegtubeManu(fi2,volnum);

if isempty(v)
    disp(['..cancelled segmentation: ' fi2 ]);
    disp(['   Reason: no areas specified']);
   return 
end

% ==============================================
%%  make plot
% ===============================================

 ro=ovlhidden(v.dat,v.mask,0.5,0);
%ro=ovlhidden(mat2gray(v.dat),mat2gray(v.mask),[],.5);
tx=text2im([mdir ' : ' file ]);
fc=[size(ro,1) size(ro,2)]./[size(tx,1) size(tx,2)];

tx=imresize(tx,[ size(tx)*floor(min(fc)) ]);
tx=repmat(tx,[1 1 3]);
ro2= [  zeros([size(tx,1) size(ro,2) 3])  ;  ro  ];
ro2(1:size(tx,1), 1:size(tx,2),:)=tx;
% fg,image(ro2)


% 
% ro3=ro2./max(ro2(:));
% 
% ro3=round(ro2.*255);
% ro3=ro3
fiout=fullfile(pa,[z.savename '.jpg']);
imwrite(ro2,fiout);

% ==============================================
%%  SAVE SEGMENTED MASK
% ===============================================
    
%%
if z.saveresult==1
    
    
    hd=spm_vol(fi2);
    hd=hd(1);
    hm=hd;
    hm.dt=[2 0];
    hm.n=[1 1];
    fiout=fullfile(pa, [regexprep(z.savename,'.nii','') '.nii']);
    rsavenii(fiout,hm,v.mask);   %save mask with all mice
    showinfo2('shwo segmented tube: ',fi2,fiout,13);
end












