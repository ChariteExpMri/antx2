%% extract 2d-slices from 3D or 4D-volume
% 
% 
% #yk xextractslice.m
%% #b extract 2d-slices from 3D or 4D-volume
% - This function extracts one/more 2d slices from a 3d or 4d volume
% - each single slice is stored in a new nifti, 
% - name of the new nifti:  name of old nifti + 'Slice_00#', where # is the index of the slice
% DIRS:  works on preselected mouse dirs, i.e. mouse-folders in [ANT] have to be selected before
% ______________________________________________________________________________________________
%
%% #ky PARAMETER:
% 'file'           - nifti-file, from which slices should be extracted (example: t2.nii) 
%                  - nifti-volume is 3D or 4D
% 'slicenumber'    -  index of the slice(s) to extract   
%                  EXAMPLES: [1]        : 1st slice,             [1:3]      : slices 1 to 3
%                           '[1:2:end]' : every 2nd slice        'all'      : all slices
%                           'end'       : last slice             'end-2:end': last three slices
% 'volumenumber'   - for 4D-volume only: select index of volume inanth 4th dimension (default: 1, for 3D)
% 'slicedim'       - dimension to slice from: 'x','y','z', (for 1st.,2nd.,3rd. Dimension), 'allen' or 'native' 
%                  Note:    'allen' refers to 'y'     anf   'native' to 'z' for coronar slices        
% 'iscolocated'    - volume contains slices from the same location (different  parameters acquired
%                    from same location) or not (one parameter is measured and slices come from 
%                    different locations)
%                  [1] all slices in the volume have the same location   
%                  [0] all slices in the volume have different locations (this is the usual mode)
% ______________________________________________________________________________________________
%% #ky RUN-def:
% xextractslice(showgui,x)
% with inputs:
% showgui: (optional)  :  0/1   :no gui/open gui
% x      : (optional)  : struct with one/more specified parameters from above:
%
% xextractslice(1) or  FUNCTION    ... open PARAMETER_GUI with defaults
% xextractslice(0,z)                ...run without GUI with specified parametes (z-struct)
% xextractslice(1,z)                ...run with opening GUI with specified parametes (z-struct)
% ______________________________________________________________________________________________
%% #ky BATCH EXAMPLE
% 
% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••                                                                                     
% % #g FUNCTION:     [xextractslice.m]       
% % #b info :        extract 2d-slices from 3D or 4D-volume                                                                                                                                                   
% % EXAMPLE-1: extract every 3rd slice from JD.nii, 
% % coronar slices in 'allen'-space                                                         
% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••                                                                                     
% z=[];                                                                                                                                          
% z.file         = { 'JD.nii' };     % % SELECT IMAGE to extract 2d-slice(s) (example: t2.nii)                                             
% z.slicenumber  = '[1:3:end]';     % % select index of slice(s) to extract   (EXAMPLES: [1],'[1:2:end]',[1:3],'all','end','end-2:end')         
% z.volumenumber = [1];              % % for 4D-volume only: select index of volume in 4th dimension (default: 1, for 3D)                        
% z.slicedim     = 'allen';          % % dimension to slice from: [x],[y],[z][allen][native] for 1st.,2nd.,3rd. Dim,                             
% z.iscolocated  = [0];              % % [1] all slices have the exact same location, [0] no, slices spaced based on vox-size in hdr.mat         
% xextractslice(1,z);                                                                                                            
%      
% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••                                                                                     
% % #g FUNCTION:        [xextractslice.m]     
% % #b info :           extract 2d-slices from 3D or 4D-volume                                                                                                                                                   
% % EXAMPLE-2:  slice-3 from nan_4_3.nii is used to  
% % register (2d) a cbf-slice, NOTE : Here 'z.iscolocated'
% % is set to [1] since nan_4_3.nii contains slices measured
% % with different parameters from the same location
% % ••••••••••••••••••••••••••••••••••••••••••••••••••••••
% z=[];                                                                                                                                               
% z.file         = { 'nan_4_3.nii' };     % % (<<) SELECT IMAGE, to extract 2d-slice(s) (example: t2.nii)                                             
% z.slicenumber  = [3];                   % % select index of slice(s) to extract   (EXAMPLES: [1],'[1:2:end]',[1:3],'all','end','end-2:end')         
% z.volumenumber = [1];                   % % for 4D-volume only: select index of volume in 4th dimension (default: 1, for 3D)                        
% z.slicedim     = 'native';              % % dimension to slice from: [x],[y],[z][allen][native] for 1st.,2nd.,3rd. Dim,                             
% z.iscolocated  = [1];                   % % [1] all slices have the exact same location, [0] no, slices spaced based on vox-size in hdr.mat         
% xextractslice(1,z);   
% ______________________________________________________________________________________________
%
%% #r RE-USE BATCH: see 'anth' [..anthistory] -variable in workspace
%
%

function xextractslice(showgui,x)





if 0
    
    x.file=         { 'JD.nii' };	% << SELECT IMAGE, to extract 2d-slice(s) (example: t2.nii)
    x.slicenumber=  '[1:10:end]';	% select index of slice(s) to extract   (EXAMPLES: [1],'[1:2:end]',[1:3],'all','end','end-2:end')
    x.volumenumber=[1];	% for 4D-volume only: select index of volume in 4th dimension (default: 1, for 3D)
    x.slicedim=     'allen'	;% dimension to slice from: [x],[y],[z][allen][native] for 1st.,2nd.,3rd. Dim,
    x.iscolocated=  [0];	% [1] all slices have the exact same location, [0] no, slices spaced based on vox-size in hdr.mat
    xextractslice(1,x)
    
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




%———————————————————————————————————————————————
%%   example
%———————————————————————————————————————————————
if 0
     mdir='O:\data\slicewise_susanne2\dat\20171025MM_C8_M17'
     
    %g.file         ='nan_2_2.nii'
 g.file         ='nan_4_3.nii'
%   g.file         ='t2.nii'
%   g.file         ='JD.nii'
g.slicenumber  ='[1 end]'      % [1],''[1:2:end]'',[1:3],''all'',''end'',''end-2:end''
g.volnumber    =1
g.slicedim     ='z'       % ['y'] ALLEN SPACE, ['z'] mouseSpace
g.iscolocated  =1

   
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  PARAMETER-gui
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if exist('x')~=1;        x=[]; end
p={...
    'inf0'      '*** EXTRACT 2D-SLICES      ****     '         '' ''
    'inf1'      ['routine: [' mfilename '.m]']                         '' ''
    'inf7'     '====================================================================================================='        '' ''
    'file'          {''}       '(<<) SELECT IMAGE, to extract 2d-slice(s) (example: t2.nii)'  {@selectfile,v,'single'}
    'slicenumber'    1         'select index of slice(s) to extract   (EXAMPLES: [1],''[1:2:end]'',[1:3],''all'',''end'',''end-2:end'')     '  {'all',1,2,3,'end',['1:2:end']}
    'volumenumber'   1         'for 4D-volume only: select index of volume in 4th dimension (default: 1, for 3D)'    ''
    'slicedim'       'native'  'dimension to slice from: [x],[y],[z][allen][native] for 1st.,2nd.,3rd. Dim,          '  {'native' 'allen' 'x' 'y' 'z'}
    'iscolocated'    1         '[1] all slices have the exact same location, [0] no, slices spaced based on vox-size in hdr.mat         '  'b'
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .5 .35 ],...
        'title',' ','info',{@uhelp, [mfilename '.m']});
    if isempty(m);    return ;    end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


%———————————————————————————————————————————————
%%   SUB  PROCESS
%———————————————————————————————————————————————

g=z;

xmakebatch(z,p, mfilename);

% return
%% running trough MOUSEfolders
disp('*** read out 2d slices ***');
for i=1:size(pa,1)
    task(pa{i}, g);
end








%———————————————————————————————————————————————
%%   SUB  PROCESS
%———————————————————————————————————————————————

function task(mdir,g)

%% READ FILE, deal with 4d  
g.file=g.file{1};
file=fullfile(mdir,g.file);

if exist(file)~=2; return; end

[ha a]=rgetnii(file);
ha = ha(g.volumenumber);
a  = a(:,:,:,g.volumenumber);

%% DIMENSION TO SLICE
if     strcmp(lower(g.slicedim),'x'); slicedim=1;
elseif strcmp(lower(g.slicedim),'y'); slicedim=2;
elseif strcmp(lower(g.slicedim),'z'); slicedim=3;
    
elseif strcmp(lower(g.slicedim),'allen') ; slicedim=2;
elseif strcmp(lower(g.slicedim),'native'); slicedim=3;
end



%% convert slicenumber
% g.slicenumber ='1:3:end'
% 
% g.slicenumber ='[end-1:end]'
% g.slicenumber ='end'
% g.slicenumber ='[end-4 end]'
% g.slicenumber =1:1:7
% g.slicenumber =3

if isnumeric(g.slicenumber )
    sl=[ '[' num2str(g.slicenumber)  ']' ];
elseif ischar(g.slicenumber )
    sl=g.slicenumber;
end

if strcmp(lower(sl),'all')           % ALL SLICES
    sl=[ '[' num2str([1:size(a,slicedim)])  ']' ];
end

%% extract data (d) and get real slice index (sno)
if slicedim==1;     eval(['d   =  a(' sl  ',  :    ,:        );'       ]);      end
if slicedim==2;     eval(['d   =  a(:      ,' sl ' ,:        );'       ]);      end
if slicedim==3;     eval(['d   =  a(:      ,  :    , '  sl ' );']);      end

svec=1:size(a,slicedim);
eval(['sno = svec('  sl ' );']);


%% LOOP
disp('[read out SINGLE SLICE] busy..');
for i=1:length(sno)
    fout=fullfile(mdir, stradd(g.file,['_Slice' pnum(sno(i),3)],2) );
    
    hd=ha;
    %hd.dim=[hd.dim(1:2) 1]
    hd.dim=hd.dim;
    hd.dim(slicedim)=1;
    hd.n  =[1 1];
    
    mat=ha.mat;
    
    if g.iscolocated==0
%         %%%%of=[0:ha.dim(3)-1].*ha.mat(3,3)+ha.mat(3,4)+ha.mat(3,3)/2
%         of=[1:ha.dim(3)].*ha.mat(3,3)+ha.mat(3,4)-ha.mat(3,3)
%         mat(3,4)=of(sno(i))
        
        of=[1:ha.dim(slicedim)].*ha.mat(slicedim,slicedim)+ha.mat(slicedim,4)-ha.mat(slicedim,slicedim);
        mat(slicedim,4)=of(sno(i));
    end
    
    
    hd.mat=mat;
    if     slicedim==1 ; dx=d(i,:,:);
    elseif slicedim==2 ; dx=d(:,i,:);
    elseif slicedim==3 ; dx=d(:,:,i); 
    end
    
    %hd.mat
    rsavenii(fout,hd, (dx));
    
    try
        if i==1
        disp(['2d-registered image: <a href="matlab: explorerpreselect(''' ...
            fout ''')">' fout '</a>']);
        end
    end
    
end


disp('done');




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

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function he=selectfile(v,selectiontype)
he=selector2(v.tb,v.tbh,...
    'out','col-1','selection',selectiontype);
