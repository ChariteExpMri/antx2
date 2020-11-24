
%% #b split data-sets based on tube-segementation
% DIRS:  works on preselected mouse dirs, i.e. mouse-folders in [ANT] have to be selected before
% ______________________________________________________________________________________________
%
%% #ky PARAMETER:                                                                                                                                               
% z.segmentfile :  (<<) SELECT SEGMENTED IMAGE (mask) from tube-segmentation                               
%                  deafult file: 'seganimal.nii';                         
% z.file        :  (<<) SELECT IMAGE that is used as basis for registration "t2.nii")                      
%                  -->optional...if so, this image is masked by the respsective mask of "segmentfile"
% z.volnumber   :  for 4D-volume only: select index of volume in 4th dimension of "file" (default: 1)      
%                 default: 1
% z.outdir      : select a meta-output directory (create a new folder; do not use the current "dat"-folder)        
% z.savename    : output name for the masked image (inputs is "file" which is masked by "segmentfile") 
%                 default: "t2.nii"
% z.mask_suffix :  output mask-file: the suffix is added to  "segmentfile"-name to denote the current mask 
%                this: 
% ______________________________________________________________________________________________
%% #ky RUN-def:
% xsplittubedata(showgui,x)
% with inputs:
% showgui: (optional)  :  0/1   :no gui/open gui
% x      : (optional)  : struct with one/more specified parameters from above:
%
% xsplittubedata(1) or  FUNCTION    ... open PARAMETER_GUI with defaults
% xsplittubedata(0,z)                ...run without GUI with specified parametes (z-struct)
% xsplittubedata(1,z)                ...run with opening GUI with specified parametes (z-struct)
% ______________________________________________________________________________________________
%% #ky BATCH EXAMPLE
% ______________________________________________________________________________________________
%
%% #r RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace
% z=[];                                                                                                                                                
% z.segmentfile = 'seganimal.nii';                         % % (<<) SELECT SEGMENTED IMAGE (mask) from tube-segmentation                               
% z.file        = 't0.nii';                                % % (<<) SELECT IMAGE that is used as basis for registration "t2.nii")                      
% z.volnumber   = [1];                                     % % for 4D-volume only: select index of volume in 4th dimension of "file" (default: 1)      
% z.outdir      = 'F:\data1\WU_segmenttube\segmented';     % % meta-output directory (create a new folder; do not use the current "dat"-folder)        
% z.savename    = 't2.nii';                                % % output name for the masked image (inputs is "file" which is masked by "segmentfile")    
% z.mask_suffix = '_this';                                 % % output mask-file: the suffix is added to  "segmentfile"-name to denote the current mask 
% xsplittubedata(1,z);  

function xsplittubedata(showgui,x)


if 0
    z=[];
    z.segmentfile = 'seganimal.nii';                         % % (<<) SELECT SEGMENTED IMAGE (mask) from tube-segmentation
    z.file        = 't0.nii';                                % % (<<) SELECT IMAGE that is used as basis for registration "t2.nii")
    z.volnumber   = [1];                                     % % for 4D-volume only: select index of volume in 4th dimension of "file" (default: 1)
    z.outdir      = 'F:\data1\WU_segmenttube\segmented';     % % meta-output directory (create a new folder; do not use the current "dat"-folder)
    z.savename    = 't2.nii';                                % % output name for the masked image (inputs is "file" which is masked by "segmentfile")
    z.mask_suffix = '_this';                                 % % output mask-file: the suffix is added to  "segmentfile"-name to denote the current mask
    xsplittubedata(1,z);
    
    
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

% z.mask_suffix ='_this';
% z.savename    ='t2.nii';

% ==============================================
%%    PARAMETER-gui
% ===============================================
if exist('x')~=1;        x=[]; end
p={...
    'inf0'      '*** segment animals in tube     ****     '         '' ''
    'inf1'      ['routine: [' mfilename '.m]']                         '' ''
    'inf7'     '====================================================================================================='        '' ''
    'segmentfile'              'seganimal.nii'    '(<<) SELECT SEGMENTED IMAGE (mask) from tube-segmentation'  {@selectfile,v,'single'}
    'file'                     't0.nii'           '(<<) SELECT IMAGE that is used as basis for registration "t2.nii")'  {@selectfile,v,'single'}
    'volnumber'   1            'for 4D-volume only: select index of volume in 4th dimension of "file" (default: 1)'    ''
    ...
     'outdir'     ''           'meta-output directory (create a new folder; do not use the current "dat"-folder)'       'd'
    'savename'     't2.nii'    'output name for the masked image (inputs is "file" which is masked by "segmentfile")'  ''
    'mask_suffix'  '_this'     'output mask-file: the suffix is added to  "segmentfile"-name to denote the current mask '   {'this', 'current'}
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .475 .6 .2 ],...
         'title',[ 'split multitube data' '[' mfilename '.m]'],'info',{@uhelp, [mfilename '.m']});
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

% return
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


pas=antcb('getsubjects');


for i=1:length(pas)
    %disp(i);
    z.i=i;
    process2(pas{i},z)
end

function process2(pas,z)
pa=pas;
[~,mdir]=fileparts(pa);
cprintf([0 .5 0],[ repmat('=',[1 length(mdir)*2]) '\n']);
cprintf([0 .5 0],[num2str( z.i)  '] '  mdir '\n'])
cprintf([0 .5 0],[ repmat('=',[1 length(mdir)*2]) '\n']);

% ==============================================
%%   
% ===============================================

warning off;

% z.mask_suffix ='_this';
% z.savename    ='t2.nii';



f1=fullfile(pa,z.segmentfile);
if iscell(f1);     f1=char(f1); end

[hm m] =rgetnii(f1);
uni=unique(m(:)); uni(uni==0)=[];

if ~isempty(z.file)
    f2=fullfile(pa,z.file);
    if iscell(f2);     f2=char(f2); end

    [ha a] =rgetnii(f2);
    ha=ha(z.volnumber);
    a=a(:,:,:,z.volnumber);
end

for i=1:length(uni)
    mdir2=[mdir '_' num2str(i)];
    disp([ '***   '  mdir2  '***' ]);
    pa2=fullfile(z.outdir,mdir2);
    mkdir(pa2)
    copyfile(pa,pa2,'f');
    
    m2=double(m==uni(i));  %save current mask
    f3=fullfile(pa2,stradd(z.segmentfile,z.mask_suffix ,2) );
    f3=char(f3);
    rsavenii( f3,hm, m2 );
    showinfo2('new tube segmented mask: ',f1,f3);
    
    %save t2w
    if ~isempty(z.file)
        a2=a.*m2;
        cl=reshape(otsu(a(:),2),[ha.dim]);
        me=median(a(cl==1));
        a3=me.*double((m2==0));
        
        a4=a2+a3;
%         cl=reshape(otsu(a(:),2),[ha.dim]);
%         bg=a.*m2==0;
%         bg=(cl==1).*a;
%         montage2(bg)
      f4=fullfile(pa2,[regexprep(z.savename,'.nii','') '.nii']  );
        hb=ha;
        hb.n=[1 1];
        rsavenii( f4,ha, a4 );
        showinfo2('new tube segmented file: ',f2,f4);
    end

end







return
[pa name ext ]=fileparts(fi);
if isempty(ext); ext='.nii'; end
k=dir(fullfile(pa, [name ext]));
if isempty(k)
    return
end
file= k(1).name;
fi2=fullfile( pa,file );

volnum      =z.volnumber;  %1
extmin      =z.extmin      ;%def:4
expectclass =z.animalnumber; %'auto'
sortmode    =1; 
showit      =z.showresult;

v=fsegtube(fi2,volnum, extmin,expectclass,sortmode, showit);


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
    showinfo2('shwo segmented tube: ',fi2,fiout);
end












