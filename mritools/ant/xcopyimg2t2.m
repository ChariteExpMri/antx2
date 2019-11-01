
%% copy images/masks to T2 folders [auto/GUI]
%%   function xcopyimg2t2(maskfi,t2rootpath,mode, renamestr,verbose)
%% IN
% maskfi        : [optional] cell with all inputfiles/maskfiles 
%                  ..if empty: then it opens a GUI with PWD
%                 folderName of masks : then it opens a GUI with folderName-directory
% t2rootpath: [optional] root path containing all mouseFolders ...in these folders die files/masks will be copied
% mode       : [optional]  [-1]testModus, without copying files
%                                      [0]copy files without changes  
%                                      [1]reorient images due to  BUGS in  ImageJ/ANALYZE-SOFTWARE,e ,g, when making a MASK 
%                                           ---->[1] seems to be mandatory for MASK-creation with the above software
% renamestr   : [optional] string used to rename the output file  . e.g. 'masklesion' instead of '20150909_FK_C2M07_lesion_total_mask.img'
%%  OUT: a LOGFILE is displayed, but must be saved manually
%% EXAMPLE -fully determined input
% maskfi= {'O:\harms1\harmsStaircaseTrial\copyOfLesionMasks_forRegistration_paul\20150505SM01_lesion_total_mask.img'
% 'O:\harms1\harmsStaircaseTrial\copyOfLesionMasks_forRegistration_paul\20150505SM02_lesion_total_mask.img'
% 'O:\harms1\harmsStaircaseTrial\copyOfLesionMasks_forRegistration_paul\20150505SM03_lesion_total_mask.img'}
% t2rootpath ='O:\harms1\harmsStaircaseTrial\dat'
% xcopyimg2t2(maskfi,t2rootpath,1); % BUGS in  ImageJ/ANALYZE-SOFTWARE
% xcopyimg2t2(maskfi,t2rootpath,-1)  ;%testmode without copying files
% xcopyimg2t2         %use GUI for all inputs
% xcopyimg2t2([],[],1)  ;%use GUI, use BUGmode 
%  xcopyimg2t2([],'O:\harms1\harmsStaircaseTrial\dat')
%% STUDY example
% xcopyimg2t2(fileparts('O:\harms1\harmsStaircaseTrial\dat'),'O:\harms1\harmsStaircaseTrial\dat'); %
% 
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

 function xcopyimg2t2(maskfi,t2rootpath,mode,renamestr,verbose)

 

 gui.fi        =0;
 gui.t2       =0;
 guiparams=0;
 
 
 if ~exist('maskfi','var')         || isempty(maskfi) ;                   gui.fi      =1   ;   end
 if ~exist('t2rootpath','var') || isempty(t2rootpath) ;            gui.t2      =1  ;    end
 if ~exist('mode','var')          || isempty(mode) ;                    guiparams=1 ;     end

  if exist('renamestr','var')==1 ; 
      if ~isempty(renamestr) ; 
          try
          if renamestr==1
              guiparams=1; renamestr='';
          end
          catch
              guiparams=0; renamestr='';
          end
      end
  else
      renamestr='';
  end
  if ~exist('verbose','var')          || isempty(verbose) ;                    verbose=1 ;     end

  
  
  
  %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
 prefdir=pwd;
 %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
 %%  GUIS
 if ischar(maskfi);  %% ONLY MaskFOLDERNAME IS GIVEN-->open GUI
     if isdir(maskfi)==1; 
         prefdir=maskfi ; 
         gui.fi =1;
     end
 end
  if iscell(maskfi);  %% ONLY MaskFOLDERNAME IS GIVEN--open GUI 
     if isdir(maskfi{1})==1; 
         prefdir=maskfi{1} ; 
         gui.fi =1;
     end
 end

if  gui.fi ==1
%     clc
 %      prefdir='O:\harms1\harmsStaircaseTrial\copyOfLesionMasks_forRegistration_paul';
%   prefdir=pwd;
    msg={'select the MASK files' '..which will be copied to the T2-folders'};
    %     [maskfi,sts] = cfg_getfile2(inf,'image',msg,[],prefdir,'img');
    [maskfi,sts] = cfg_getfile2(inf,'any',msg,[],prefdir,'img|nii');
end
    
if  gui.t2  ==1
   %     prefdir='O:\harms1\harmsStaircaseTrial\';
%  prefdir=pwd;
    msg={'select the T2-root-path [UEBERORDNER] ' '..where all mouseFolders with T2images are located','!!! not the single MousePath !!!'};
    [t2rootpath,sts] = cfg_getfile2(inf,'dir',msg,[],prefdir);
    t2rootpath=char(t2rootpath);
end


%———————————————————————————————————————————————
%%   over paths
%———————————————————————————————————————————————
if exist('pa')==0      || isempty(pa)      ;    pa=antcb('getallsubjects')  ;end
if 1
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=unique(fi2);
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  PARAMETER-gui
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if exist('x')~=1;        x=[]; end
showgui=1;

p={...
    'inf98'      '*** IMPORT DATA                 '                         '' ''
    'inf100'     '-------------------------------'                          '' ''
    'mode'        0            '[0]just copy, [1]from ANALYZE [2]from ImageJ, [3] replace header'  {1 2 3 4}
    'imageHeader'   't2.nii'    'use the header from this file'        {@selector2,li,{'headerFile'},'out','list','selection','single'}
    'renamestring'   ''    'renamefile to'       '' 
    };

p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI

if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .8 .6 ],'title','PARAMETERS: LABELING','info',{'sss'});
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

% prompt = {[...
%     'CHANGE ORIENTATION of INPUT DATA ' char(10) ...
%     'Enter mode: ' char(10)  ...
%     '[-1] test mode, checks file to path assignments without copying the files ,' char(10) ...
%     '[0]  just copy files ,' char(10) ...
%     '[1]  DATA SOURCE: ANALYZE-software ' char(10) ...
%     '[2]  DATA SOURCE: ImageJ-software ' char(10) ...
%     '[3]  replace header using  the corresponding "t2.nii"-header  ' char(10)  ...
%     '[4]  userdefined ' ] ...
%     'RENAME FILE:  give a new name (exmples: "mask"/"masklesion")'};
% dlg_title = 'PARAMS: import Images (Masks etc) ';
% num_lines = 1;
% def = {'1' renamestr};
% answer = inputdlg(prompt,dlg_title,num_lines,def);
% mode      =str2num(answer{1});
% renamestr=             (answer{2});


mode      =z.mode;
renamestr =z.renamestring
imageHeader=char(z.imageHeader);



if isempty(mode) | isempty(maskfi) | isempty(t2rootpath)
    return
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  check zuordnung   lessionfile is searched across  all T2path-->created "mafi" cell
% comparison made by removing all letters [A-z]

[emp,t2path]=cfg_getfile('FPList',t2rootpath,'');
[emp,t2short]=cfg_getfile('List',t2rootpath,'');

t2shortNUM=regexprep(t2short,'[A-z]','');
mafi={};
match        ={' #gy *** FILES  copied to target directory***'};
nonmatch={' #gy *** FILES that could not be copied to target directory***'};
ncase=[0 0];
idxall=[];
for i=1:size(maskfi,1);
    try
        mask=maskfi{i};
        [pa fi ext]=fileparts(mask);
        tag=regexprep(fi,'[A-z]','');
        
        idx=regexpi2(t2shortNUM,tag);
        if isempty(idx)
            [index0,dist]=strnearest(tag,t2shortNUM);
            
            if ~isempty(index0)
               if length(index0)==1 & dist<5;
                   idx=index0;
               end
                
            end
        end
        
        %checkfoldername
        [pat2 fit2 extt2]= fileparts(t2path{idx});
        mafi(end+1,:)={ [fi ext]  fit2     mask   t2path{idx}  t2shortNUM{idx}};
        match(end+1,1)={sprintf('%s \t-->\t[FLD] %s',[fi '.nii'] , fit2)};
        ncase(1)=ncase(1)+1;
        idxall(end+1,1)=idx;
    catch
        nonmatch(end+1,1)={mask} ;
        ncase(2)=ncase(2)+1;
    end
end
if size(nonmatch,1)==1      ;     nonmatch(end+1,1)={'<empty>'};        end
if size(match,1)==1;                  match(end+1,1)={'<empty>'};               end
untouchedfolders={' #gy *** untouched target directories (no files were copied in this session to the following folders, in the current process)  ***'};
untouchedfoldersx=setdiff(t2path,t2path(idxall));
if isempty(untouchedfoldersx);        untouchedfolders(end+1,1)={'<empty>'};               end
untouchedfolders=[untouchedfolders;untouchedfoldersx ];
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%% make logfile
log=[];
log{end+1,1}=['––––––––––––––––––––––––––––––––––––––––––––––––––––'];
log{end+1,1}=[' #yg  log: IMPORT FILES              '  ['date: '  datestr(now)] ];
log{end+1,1}=' ## ...use contextmenu to save this logfile                               ';
log{end+1,1}=sprintf('%d/%d files copied to targetDIRs \t    (%d files failed to copy)' ,ncase(1) ,size(maskfi,1),ncase(2));
log{end+1,1}=['––––––––––––––––––––––––––––––––––––––––––––––––––––'];
% log{end+1,1}=' ';
log=[log;  match];
log{end+1,1}=['––––––––––––––––––––––––––––––––––––––––––––––––––––'];
% log{end+1,1}=' ';
log=[log;  nonmatch];
log{end+1,1}=['––––––––––––––––––––––––––––––––––––––––––––––––––––'];
% log{end+1,1}=' ';
log=[log;  untouchedfolders];
log{end+1,1}=['––––––––––––––––––––––––––––––––––––––––––––––––––––'];




%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if mode==-1
    uhelp([' #rk TESTMODE (no files copied) !!!' ;log] );
    return
end


%% modify outputIMAGE


%% loop over mafi-structur

if verbose==1
    uhelp(log); drawnow;pause(.1);
    set(findobj(gcf,'style','listbox'),'fontsize',9);
    disp('---start IMPORT');
end

%% userdefined transformation-mat
if mode==4
    prompt2 = {[...
        'USER DFINED AFFINE TRANSFORMATION MATRIX' char(10) ...
        ' 9 element vector with:' char(10) ...
        'P(1-3)  - x,y,z, translation' char(10) ...
        'P(4-6)  - x,y,z rotation {pitch,roll,yaw} (radians)' char(10) ...
        'P(7-9)  - x,y,z scaling' ...
        ]};
    dlg_title = 'USER DFINED AFFINE TRANSFORMATION';
    num_lines = 1;
    def = {['0 0 0 0 0 0 1 1 1']};
    answer = inputdlg(prompt2,dlg_title,num_lines,def);
    mat      =str2num(answer{1}); 
end

for i=1:size(mafi,1)
    
    this=mafi(i,:);
     cprintf([0 .5 0],(['copy: ' strrep(this{1},'.img' ,'.nii') '  >> to:  [FLD]:  '  this{2} '\n']  ));
    f1=this{3}; %fullfile(pwd,'20150505SM01_lesion_total_mask.img') ;            %MASK
    t2=fullfile(this{4}, [strrep(char(z.imageHeader),'.nii','') '.nii'] );                                                                                 %t2file in TARGETDIR
    
    %% IMGAEJ/ANALYZE ISSUE
    [ha a]   =rgetnii(f1); %MASK
    [hd d]   =rgetnii(t2);
    
%     ha=spm_vol(f1)  ; a=spm_read_vols(ha);
%     hb=spm_vol(f2)  ; a=spm_read_vols(ha);
       
if size(ha,1)>1
    ha=ha(1);
end

if size(hd,1)>1
    hd=hd(1);
end


    ha2=ha;
    ha2=rmfield(ha2,'private');
      if mode==1 | mode==4
%           if length(hd.dim)==1
          ha2.mat=hd.mat;
%           else
              
%           end
          
      end
    
      %% SET ORIGNAME
      ha.descrip=['origNAME:  '  mafi{1}];
      
    % ha2.mat(2,2)=-ha2.mat(2,2)%
    % ha2.mat(1,1)=-ha2.mat(1,1)
    %  ha2.mat(3,3)=-ha.mat(3,3)
    % ha2.pinfo=hd.pinfo
    % a=flipdim(a,2);
    % a=flipdim(a,1);
    
    %% remove timeSTAMP
    msktag=this{1};
    fldtag   =this{2}(2:end)  ;%first letter is  's'
    
    if isempty(renamestr)
    token=['20\d\d\d\d\d\d_'];
    outname=regexprep(msktag,token,'');
    outname=['m' outname];
    else
        [par fir exr]=fileparts(msktag);
        outname=[renamestr   exr];
    end
%     mx= max(length(msktag) ,      length(fldtag) );
%     same=zeros(2,mx);
%     same(1, 1:length(msktag))  =double(msktag);
%      same(2,  1:length(fldtag))  =double(fldtag);
%     outname=this{1}(min(find(diff(same,[],1)~=0)):end)
    
    
    %••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
    outfile=fullfile( this{4}, strrep(outname,'.img','.nii') )     ;       %fullfile(pwd,'maskHDRcopy3.nii')
    rsavenii(outfile,ha2,a);
    
    %% mode=1:  SUSANNE orientBUG due to ImageJ/ANALYZE-SOFTWARE
    if mode==1
        predef=[ [[0 0 0   0 0 0 ]]  1 -1 1 0 0 0];
        fsetorigin(outfile, predef);  %ANA
    end
     if mode==2 %imageJ
        predef=[ [[0 0 0   0 0 0 ]]  -1 1 1 0 0 0];
        fsetorigin(outfile, predef);  %ANA
    end 
    if mode==3 %copy header
        href=spm_vol(fullfile(fileparts(outfile),'t2.nii'));
        [himg hdat]=rgetnii(outfile);
        himg.mat=href.mat; %Copy REORIENT MAP
        rsavenii(outfile,himg,hdat);
    end
    
      if mode==4
        predef=[ [mat]   0 0 0];
        fsetorigin(outfile, predef);  %ANA
    end
    
end

