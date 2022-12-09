% #b shows the main functions of ANT
%  antfun('updatemethods')

function do= antfun(task, varargin)


do=[];

fun={}; % {cell with 4 columns:  1:visible in listbox, 2:identifier to call&Run, 3:toolTip,   4: 0/1  LOOP functions over subjects}
% fun(end+1,:)={'list'                                                 ''      ''};
% fun(end+1,:)={'Import from Broker'                                'brukerImport'     'import BrukerDATA'                                                                                                                 0 };%@xbruker2nifti

fun(end+1,:)={'[1]  xwarp-initialize'                                        'xwarp-1'   ['copy templates & skullstrip <br> this has to be done only once' ]                                        1};
fun(end+1,:)={'[2a] xwarp-coregister auto'                            'xwarp-21'   ['coregister volumes automatically <br> use this approach for a bunch of mouses (..to save time)'  ]   1};
fun(end+1,:)={'[2b] xwarp-coregister manu'                          'xwarp-20'   ['coregister volumes manually <br> ..use this if "autoMethod"[=2a],  fails or if you want to have more df''s <br>on the coregistration process ' ] 1 };
fun(end+1,:)={'[3] xwarp-segment'                                        'xwarp-3'   'segment T2.nii into GM,WM,CSF <> ..this calls the SPMMOUSE-PIPELINE , (modified SPM''s "Unified Approach <br> this might take 5-15min <br>'   1 };
fun(end+1,:)={'[4] xwarp-ELASTIX'                                           'xwarp-4'   'add on: use ELASTICS DEFORMATION<br>this might take ~5-7 addit. minutes<br>'                         1 };

% fun(end+1,:)={'importmasks'                                               'importmasks'  'IMPORT MASK or other volumes to specified mouseFolders'   0};
fun(end+1,:)={'deform Volumes SPM'                                'deformSPM'    ' deform files using SPMMOUSE     <br> xwarp[1-3] has to be run before'   0};
fun(end+1,:)={'deform Volumes ELASTIX'                                'deformELASTIX'    ' deform files using ELASTIX <br> xwarp[1-4] has to be run before'    0};

fun(end+1,:)={'get anatomical labels'                                  'getlabels'      'get anatomical labels from warped mouse' 0};

% fun(end+1,:)={'resizeAtlas'                                     ''  ''};
% fun(end+1,:)={'segment'                                        ''   '' };
% fun(end+1,:)={'segmentManuReorient'                 ''  ''};

global an

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if strcmp(task,  'funlist' )
    %     varargout{ 1}
    do=fun;
    % disp(do);
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% brookerimport
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if strcmp(task,  'brukerImport' )
    % xbruker2nifti( 'O:\harms1\harmsTest_ANT\pvraw', 'Rare' )  %METAFOLDER is explicitly defined, read Rare, trmb is 1Mb
    % xbruker2nifti({'guidir' 'O:\harms1\harmsTest_ANT\'}, 'Rare' ) %startfolder for GUI is defined,  read Rare, trmb is 1Mb
    if isfield(an,'brukerpath') ;
        xbruker2nifti( an.brukerpath, 'Rare' ) ;
        %fun={@xbruker2nifti , an.brukerpath, 'Rare'   };
        %  feval(fun{1},fun{2:end})
    else
        xbruker2nifti( {'guidir' fileparts(an.datpath)}  , 'Rare' ) ;
        %   fun={@xbruker2nifti ,{'guidir' fileparts(an.datpath)}, 'Rare'   };
    end
    do.fun=fun;
    do.los=0;
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%                          segmentation
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if strcmp(task,  'segment' ) ||  strcmp(task,  'segmentManuReorient' )
    %get PATH
    if ~isfield(an,'mdirs'); disp('mousefolder not loaded/converted'); return; end
    t2path0=an.mdirs;
    lb3=findobj(gcf,'tag','lb3');
    ids=get(lb3,'value');
    t2path=t2path0(ids);
    
    if  strcmp(task,  'segment' ) ;     manualorient=0                 ; else;        manualorient=1    ;end
    
    voxres=an.voxsize;%[0.0700    0.0700    0.0700 ]
    
    %     prefdir=an.datpath;%'O:\harms1\harmsStaircaseTrial\dat';
    %     %     prefdir=pwd;
    %     msg={'SEGEMNTATION STEP' 'select mouseFolders with  T2images '};
    %     [t2path,sts] = cfg_getfile2(inf,'dir',msg,[],prefdir,'^s');
    
    
    for i=1:  size(t2path,1),i
        xnormalize(t2path{i}, voxres ,manualorient);
    end
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%                          import masks
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if strcmp(task,  'importmasks' )
    t2rootpath=an.datpath;
    xcopyimg2t2( fileparts(t2rootpath)  ,t2rootpath,[],1); % BUGS in  ImageJ/ANALYZE-SOFTWARE
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%                       resizeAtlas
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if strcmp(task,  'resizeAtlas' )
    xresizeAtlas(an.voxsize);
    
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%                       DEFORM       SPM
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if strcmp(task,  'deformSPM' )
    disp('deformSPM' );
    
    paths=varargin{1};
    s= xdeformpop(   paths  ,[1],[nan],[4],[],struct('showgui',1));
    if ~isempty(s) & ~isempty(s.files)
        xdeform2(   s.files  ,s.direction,  s.resolution, s.interpx)
    end
    disp('..done');
    
    
    %xdeformpop(   an.mdirs{1},[-1],[nan],[3],'^t2.nii' ,struct('showgui',1))
    %     xdeform2(an.datpath,1, an.voxsize);
    % xdeform2(   files  ,direction,  resolution, interpx)
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%                       DEFORM       ELASTIX
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

if strcmp(task,  'deformELASTIX' )
    disp(  '..deform Files using Elastix' );
    
    paths=varargin{1};
    if isempty(paths)
       disp('..no cases selectd') ;
       return
    end
    
    s= xdeformpop(   paths  ,[1],[nan],[4],[],struct('showgui',1));
    %--------
    pars=[]; %addititional parameter
    if any(find(isnan([s.resolution])==0))
        pars.resolution=s.resolution;
    end
   
    
    pars.source     =s.source;
    if isfield(s,'isparallel') && s.isparallel==1  %PARALLEL-PROC
         pars.isparallel=1;
    end
    try; s= rmfield(s,'isparallel');end
    
    if any(find(isnan([s.imgSize])==0))
        pars.imgSize=s.imgSize;
    end
    
    if any(find(isnan([s.imgOrigin])==0))
        pars.imgOrigin=s.imgOrigin;
    end
    
     if ~isempty(s.fileNameSuffix)
        pars.fileNameSuffix=s.fileNameSuffix;
    end
    %--------
    
    if ~isempty(s) && ~isempty(s.files)
        %  xdeform2(   s.files  ,s.direction,  s.resolution, s.interpx)
        fis=doelastix(s.direction    , [],      s.files                      ,s.interpx ,'local',pars );
        
%         for jj=1:length(fis)
%             fpdir=fileparts(fis{jj});
%             [~,ID,~ ]=fileparts(fpdir);
%             showinfo2( ['[' ID '] new volume' ] ,fis{jj},s.direction) ; drawnow;
%         end
        %          doelastix('transform'  , pa,    {fullfile(pa,'t2.nii')}  ,3           ,M )
    end
    disp('..done');
    %     xdeform2(an.datpath,1, an.voxsize);
    % xdeform2(   files  ,direction,  resolution, interpx)
    
    %% history
%     if 1
%         lg={'%% DEFORM VIA ELASTIX '};
%         s.files=cellstr(s.files);
%         if length(s.files )==1
%             lg{end+1,1} =[ 'files = ' '{' '''' s.files{1} '''' '};'  ];
%         else
%             lg{end+1,1}=[ 'files = ' '{' '''' s.files{1} ''''   ];
%             dum=cellfun(@(a){[ repmat(' ',1, length(['files = ' '{']) ) '''' a  ''' ' ]}, s.files(2:end));
%             dum{end}=[dum{end} '};'];
%             lg=[lg;dum];
%             
%         end
%         
%         if ~isempty(pars)
%            lg{end+1,1}= 'pars.resolution=[0.06  0.06  0.06];';
%         end
%         
%         if ~isempty(pars)
%             lg{end+1,1}=...
%                 ['fis=doelastix(' num2str(s.direction) ', [],' 'files' ',' num2str(s.interpx) ',''local'', pars );'];
%         else
%             lg{end+1,1}=...
%             ['fis=doelastix(' num2str(s.direction) ', [],' 'files' ',' num2str(s.interpx) ',''local'');'];
%             
%         end
%         
%         if 0 % TEST: run it
%             lg
%             rr=strjoin(lg,char(10))
%             eval(rr)
%         end
%         
%         
%         
%         try
%             v = evalin('base', 'anth');
%         catch
%             v={};
%             assignin('base','anth',v);
%             v = evalin('base', 'anth');
%         end
%         v=[v; lg; {'                '}];
%         assignin('base','anth',v);
% 
%         
%         %disp([' [f: doelastix.m]: <a href="matlab: uhelp(anth)">' 'batch' '</a>' ]);
%         disp(sprintf([' \b \b \b \b                  [f: doelastix.m]: <a href="matlab: uhelp(anth)">' 'batch' '</a>' ]));
%         
%     end
        
 
    
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%                       getlabels
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if strcmp(task,  'getlabels' )
    if isfield(an,'la')
        xgetlabels4(1,an.la);
    else
        xgetlabels4(1);
    end
    
    %outpath=fullfile(fileparts(an.datpath),'results');
    %try; system(['explorer ' outpath]); ;end
    %     [Stat, excvec] = xgetlabels2(w, 'both',4,  'O:\harms1\koeln\templates')
end

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%                          xwarp
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

if     strfind(task,'xwarp')
    pam=varargin{1};
    
    %     task
    %     varargin'
    %
    %
    %     varargin
    
    %   disp([pam  '  & '  task]);
    
    a=1;
    %    save('dum','a');
    %   save('dum','task','varargin')
    %      return
    
    %      global an;
    %      s=an.wa;
    %      s.voxsize=an.voxsize;
    %      s.task=[4]
    %      s.t2=pam ;%'O:\TOMsampleData\study4\dat\s20160623_RosaHDNestin_eml_29_1_x_x'
    %      s.autoreg=1;
    % %     [success]=xwarp3(s)
    
    
    
    
    if strcmp(task,'xwarp') %all functions over MOUSE (run-1)
        
        an     =varargin{4};
        pam    =varargin{1};
        autoreg=varargin{3};
        subtask=varargin{2};
        
        %         an
        %         pam
        %         autoreg
        %         subtask
        
        
        s=an.wa;
        s.voxsize=an.voxsize;
        s.t2     =pam         ;%'O:\TOMsampleData\study4\dat\s20160623_RosaHDNestin_eml_29_1_x_x'
        s.autoreg=autoreg;
        s.task=subtask   ;
        
        %save('dum','s','s');
        tic
        xwarp3(s) ;
        toc
        
        
        %         return
        %         try; subtask=(varargin{2}); end
        %         try; autoreg=(varargin{3}); end
        %         try; an          =(varargin{4}); end
        %
        %        %    save('mist1' )
        %         %         disp([pam  '  & '  num2str(subtask)  ' & ' num2str(autoreg)  ]);
        %         xwarp(struct('task',subtask,'voxres',an.voxsize,'t2',pam,'autoreg',autoreg));
        
    else
        %% RUN2-buuton
        subtask=str2num(strrep(task,'xwarp-',''));
        
        %         disp([pam  '  & '  num2str(subtask)]);
        global an;
        s=an.wa;
        s.voxsize=an.voxsize;
        s.t2=pam ;%'O:\TOMsampleData\study4\dat\s20160623_RosaHDNestin_eml_29_1_x_x'
        s.autoreg=1;
        
        if subtask>=20
            cod=num2str(subtask)
            s.task   =str2num(cod(1));
            s.autoreg=str2num(cod(2));
        else
            s.task=subtask;
        end
        
        xwarp3(s);
        
        return
        
        %         if subtask==1
        %             xwarp(struct('task',1,'voxres',an.voxsize,'t2',pam,'autoreg',0,'an',an));
        %         elseif subtask==21
        %             xwarp(struct('task',2,'voxres',an.voxsize,'t2',pam,'autoreg',1,'an',an));
        %         elseif subtask==20
        %             xwarp(struct('task',2,'voxres',an.voxsize,'t2',pam,'autoreg',0,'an',an));
        %         elseif subtask==3
        %             xwarp(struct('task',3,'voxres',an.voxsize,'t2',pam,'autoreg',0,'an',an));
        %         elseif subtask==4
        %             xwarp(struct('task',4,'voxres',an.voxsize,'t2',pam,'autoreg',0,'an',an));
        %         end
    end
    
    
end

% if     strfind(task,'xwarp')
%     pam=varargin{1};
%     %   disp([pam  '  & '  task]);
%
%     global an
%
%     if strcmp(task,'xwarp')
%         try; subtask=(varargin{2}); end
%         try; autoreg=(varargin{3}); end
%         try; an          =(varargin{4}); end
%
%        %    save('mist1' )
%         %         disp([pam  '  & '  num2str(subtask)  ' & ' num2str(autoreg)  ]);
%         xwarp(struct('task',subtask,'voxres',an.voxsize,'t2',pam,'autoreg',autoreg));
%     else
%         [evalfun subtask]=strtok(task,'-');
%         subtask=str2num(strrep(subtask,'-',''));
%         %         disp([pam  '  & '  num2str(subtask)]);
%
%
%         if subtask==1
%             xwarp(struct('task',1,'voxres',an.voxsize,'t2',pam,'autoreg',0,'an',an));
%         elseif subtask==21
%             xwarp(struct('task',2,'voxres',an.voxsize,'t2',pam,'autoreg',1,'an',an));
%         elseif subtask==20
%             xwarp(struct('task',2,'voxres',an.voxsize,'t2',pam,'autoreg',0,'an',an));
%         elseif subtask==3
%             xwarp(struct('task',3,'voxres',an.voxsize,'t2',pam,'autoreg',0,'an',an));
%         elseif subtask==4
%             xwarp(struct('task',4,'voxres',an.voxsize,'t2',pam,'autoreg',0,'an',an));
%         end
%     end
%
%
% end


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%                          others
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

if strcmp(task,  'updatemethods' )
    funtb=antfun('funlist');
    funs=funtb(:,1);
    set(findobj(gcf, 'tag','lb1'),'string',funs);
end



return
%
%
%
% function list
% 'a'
%
%
% function fh=antfun
% fh.msub=@msub;
% fh.madd=@madd;
% fh.minfo=@minfo;
% fh.fbruker2nifti2=@fbruker2nifti2 ;
%
%
% function r=fbruker2nifti2(varargin)
%
%
%
% xbruker2nifti2
%
%
% function r=msub(a,b)
% r=a-b;
%
% function r=madd(a,b)
% r=a+b;
%
%
% function [x y z]=minfo(a,b,c)
% x='hallo'
% y=[1:3]
% z=b
%