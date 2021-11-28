


%% #b create MAPS across animals (heatmaps/IncidenceMaps/MeanImage Maps etc)
% Choose one of the following Map-type: {percent|sum|mean|median|min|max|sd|mode|rms|*specific*}
% #m EXAMPLE USAGE
%  "percent": to create incidenceMaps from binary images such as lesionsMasks across animals
%             --> output-unit: percent
%  "mean"   : create mean-image across animals 
% The resulting NIFTI-file is stored in the studie's results folder (if the output-directory is not changed).
% Additionally a "txt"-file with information (includers/missing files) is stored.
% #r ----------------------------------------------------------
% #r SELECT ANIMALS IN LEFT LISTBOX BEFORE RUNNING THIS FUNCTION
% #r ----------------------------------------------------------
% 
% #lk  ___PARAMETER___
% 'file'             Select image here: the Image to create maps across selected animals
%                    -examlpe "x_masklesion.nii" (binary image) or any other image
% 'type'            the voxelwise math. operation to perform across images: 
%        percent
%        sum       : sum across images (animals) 
%        mean      : mean across images (animals)  
%        median    : median across images (animals)
%        min       : minimum across images (animals)
%        max       : maximum across images (animals)
%        sd        : standard deviation across images (animals)
%        mode      : mode across images (animals)
%        rms       : root-mean-square across images (animals)
%        *specific*: specific string which will be evaluated across images (animals)
%                   The data is internally stored in the "d" variable (2D-array: voxels-by-animals
%                   EXAMPLES:  z.type='sqrt(mean((d.^2),2))'  --> ..would calculate RMS across animals 
%                              z.type='mean(d,2)'             --> ..would calculate the mean across animals 
%                   
% 'outdir'           output-folder where the resulting NIFTI is stored
% 'outputnameSuffix' <optional> Add a suffix. The suffix-string is appended to output fileName (NIFTI-file)
% 
% 
% #lk  ___EXAMPLE___
% % ===========================================================================                                                                                                        
% % #g CREATE MEAN-IMAGE of 'x_flour19f_TR3.nii' ACROSS animals
% % #B select images before running this function
% % ===========================================================================                                                                                                        
% z=[];                                                                                                                                                            
% z.file             = { 'x_flour19f_TR3.nii' };              % % Select image (example select "x_masklesion.nii")                                                
% z.type             = 'mean';                                % % choose math. operation across images: {percent|sum|mean|median|min|max|sd|mode|rms|*specific*} )
% z.outdir           = 'F:\data4\flour_felix_roi\results';    % % output-folder where resulting NIFTI is stored                                                   
% z.outputnameSuffix = '';                                    % % <optional> suffix-string appended to output fileName (NIFTI-file)                               
% xcreateMaps(1,z); 

% % ===========================================================================                                                                                                        
% % #g CREATE INCIDENCEMAP of 'x_masklesion.nii' ACROSS animals (percent-unit) 
% % #B select images before running this function
% % ===========================================================================                                                                                                        
% z=[];                                                                                                                                                            
% z.file             = { 'x_masklesion.nii' };               % % Select image (example select "x_masklesion.nii")                                                
% z.type             = 'percent';                            % % choose math. operation across images: {percent|sum|mean|median|min|max|sd|mode|rms|*specific*} )
% z.outdir           = 'F:\data4\flour_felix_roi\results';   % % output-folder where resulting NIFTI is stored                                                   
% z.outputnameSuffix = '';                                   % % <optional> suffix-string appended to output fileName (NIFTI-file)                               
% xcreateMaps(1,z); 









function xcreateMaps(showgui,x,pa)


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
%%  generate list of nifit-file within pa-path
%________________________________________________
if 1
    fi2={};
    for i=1:length(pa)
        [file,~] = spm_select('FPList',pa{i},['.*.nii$']);
        if ischar(file); file=cellstr(file);   end;
        fis=strrep(file,[pa{i} filesep],'');
        fi2=[fi2; [[fis file] ]   ];
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

global an
respath=fullfile(fileparts(an.datpath),'results');
% ==============================================
%%    PARAMETER-gui
% ===============================================
if exist('x')~=1;        x=[]; end
hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
p={...
    'file'            ''          'Select image (example select "x_masklesion.nii")'  {@uniquefiles,li,lih,fi2}
    'type'            'percent'   'choose math. operation across images: {percent|sum|mean|median|min|max|sd|mode|rms|*specific*} )'  {'percent' 'abs' 'sum' 'mean','median','max'}
    
    'outdir'            respath   'output-folder where resulting NIFTI is stored' 'd' 
    'outputnameSuffix'   ''       '<optional> suffix-string appended to output fileName (NIFTI-file)'  {'imap' 'lesion','mcao'}
    };


p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[   0.3351    0.3039    0.6    0.2 ],...
        'title',mfilename,'info',hlp);
    if isempty(z); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


%———————————————————————————————————————————————
%%   process
%———————————————————————————————————————————————

if isempty(z.file); disp(' no maskfiles selected') ;return ; end

xmakebatch(z,p, mfilename); % ## BATCH
process(z,pa);
%  makebatch(z);


%% ==============================================================================================
%% =============================================== subs  ========================================
%% ==============================================================================================







function process(z,pa)

% ==============================================
%%   [1] check existence of file across folders
% ===============================================
z.file=char(z.file);
fis=stradd(pa,[filesep z.file],2);
iexist   =find(existn(fis)==2);
inoexist =find(existn(fis)~=2);

if ~isempty(inoexist)
    cprintf('-[1 0 1]' ,[  'THESE FILES WERE NOT FOUND:' '\n']);
    disp(char(fis(inoexist)));
    disp('--------------------');
    missFiles=[fis(inoexist) ];
else
    cprintf('*[0 .5 0]' ,[  '.. all FILES found..' '\n']); 
end

fis2=fis(iexist);
% ==============================================
%%   [2] load data
% ===============================================
N=size(fis2,1);
ha=spm_vol(fis2{1});   %PREALLOC
a2=zeros(prod(ha.dim),N); 
for i=1:N
    fi=fis2{i};
    [~,animal,~]=fileparts(fileparts(fi));
    
     %----display-SET----
    str=([' .. (' num2str(i) ') reading file from: [' animal ']'  ]);
    fprintf(str);
    
    %-----load-------
    [ha a] =rgetnii(fi);
    %-----INSERT into BIG 2Dim-arry -------
    a2(:,i)=a(:); 
    
    %----display-RESET----
    %pause(0.3);
    fprintf(repmat('\b',1,numel(str)));
end
% ==============================================
%%   [3] perform operation
% ===============================================
% {percent|sum|mean|median|min|max|sd|mode|rms|*specific*} )'
typestr=z.type;
if strcmp(z.type,'percent')
    a3=sum(a2,2)/N*100;
elseif strcmp(z.type,'sum')
    a3=sum(a2,2);
elseif strcmp(z.type,'mean')
    a3=mean(a2,2);
elseif strcmp(z.type,'median')
    a3=median(a2,2);
elseif strcmp(z.type,'min')
    a3=min(a2,[],2);
elseif strcmp(z.type,'max')
    a3=max(a2,[],2);
elseif strcmp(z.type,'sd')
    a3=std(a2,[],2);
elseif strcmp(z.type,'mode')
    a3=mode(a2,[],2);
elseif strcmp(z.type,'rms')
    a3=sqrt(mean((a2.^2),2))
else                         %arbitrary
    d=a2;
    code=['a3=' z.type ';'];   % using [d] as 2D-array -->  z.type='sqrt(mean((d.^2),2))'
    eval(code);
    typestr='specific';
end

a4=reshape(a3,ha.dim);

% ==============================================
%%   [4] save data
% ===============================================
suffix='';
if ~isempty(z.outputnameSuffix)
    suffix=['_' z.outputnameSuffix];
end
[~,imageName]=fileparts(z.file);

if exist(z.outdir)~=7;    mkdir(z.outdir)  ; end
NameOut=  ['MAP' typestr '_' imageName  suffix '.nii' ];
Fout=fullfile(z.outdir, NameOut);

if 1
  rsavenii(Fout,ha,a4,[ 16 0]);  
end
showinfo2('MAP' ,Fout,[],[], [ '>> ' Fout ]);

% ==============================================
%%   [5] log results
% ===============================================

lg={};
lg{end+1,1}=['MAP: ' NameOut ];
lg{end+1,1}=['FILE: ' z.file ];
lg{end+1,1}=['TYPE: ' z.type ];
lg{end+1,1}=['N-included: ' num2str(length(iexist))  ];
lg{end+1,1}=['N-excluded: ' num2str(length(inoexist))  ];
lg{end+1,1}=['    '  ];
lg{end+1,1}=['___[included files]___'  ];
lg=[lg; fis2];
lg{end+1,1}=['    '  ];
lg{end+1,1}=['___[missing files]___'  ];
if isempty(inoexist)
    lg=[lg; 'none'];
else
    lg=[lg; missFiles];
end
lg{end+1,1}=['    '  ];
lg{end+1,1}=['___[output image parameter]___'  ];
lg{end+1,1}=['ME:  ' num2str(mean(a3))];
lg{end+1,1}=['SD:  ' num2str(std(a3))];
lg{end+1,1}=['MED: ' num2str(median(a3))];
lg{end+1,1}=['MIN: ' num2str(min(a3))];
lg{end+1,1}=['MAX: ' num2str(max(a3))];
lg{end+1,1}=['Nvox_Zero : ' num2str(    length(find(a3==0))  )];
lg{end+1,1}=['Nvox_>Zero: ' num2str(    length(find(a3>0))  )];
lg{end+1,1}=['Nvox_<Zero: ' num2str(    length(find(a3<0))  )];

% abs(det(ha.mat(1:3,1:3)) *(nvox))
% char(lg)

Fout2=regexprep(Fout,'.nii$','.txt');
pwrite2file(Fout2,lg);



return

                % 
                % %% ===============================================
                % 
                % n=0;
                % fiused={};
                % fierror={};
                % for i=1:size(z.files,1)
                %     [pax fix ext]=fileparts(z.files{i});
                %     [~, mpa   ]=fileparts(pax);
                %     S = sprintf(['reading [' num2str(i) '/' num2str(size(z.files,1))  '] :  %s'],  strrep(fullfile(mpa,[fix ext]),filesep,[filesep filesep]) );
                %     %   S = sprintf(['reading [' num2str(i) '//' num2str(size(z.files,1))  '] :  %s'],  [mpa] );
                %     fprintf(S);
                %     [ha a] =rgetnii(z.files{i});
                %         if i==1
                %             a2=single(zeros([size(a) 1]));
                %         end
                %     try
                %         a2=a2+a;
                %         n=n+1;
                %         fiused(end+1,1)=z.files(i);
                %         hb=ha;
                %     catch
                %         fierror(end+1,1)=z.files(i);
                %     end
                %     %     pause(0.1);
                %     fprintf(repmat('\b',1,numel(S))); 
                % end
                % 
                % if strcmp(z.type,'percent')
                %     a2=a2./n*100;
                %     vtype='perc';
                % else
                %     vtype='abs';
                % end
                % 
                % %———————————————————————————————————————————————
                % %%   save nifti
                % %———————————————————————————————————————————————
                % outdir=fullfile(fileparts(fileparts(pa{1})), 'results');
                % mkdir(outdir);
                % 
                % if ~isempty(z.outputnameSuffix);  z.outputnameSuffix=[ '_' z.outputnameSuffix ]; end
                % 
                % timex=timestr(1);
                % fiout=fullfile(outdir,[['imap' z.outputnameSuffix '_' vtype '_' timex '.nii' ] ]);
                % rsavenii(fiout,hb,a2);
                % 
                % fiout2=fullfile(outdir,[['imap' z.outputnameSuffix '_' vtype '_' timex '.txt' ] ]);
                % 
                % lg={};
                % lg{end+1,1}=['incidenceMaps: ' z.outputnameSuffix ];
                % lg{end+1,1}=['file: ' fiout ];
                % lg{end+1,1}=['type: ' z.type ];
                % lg{end+1,1}=['n included: ' num2str(size(fiused,1))  ];
                % lg{end+1,1}=['n excluded: ' num2str(size(fierror,1))  ];
                % lg{end+1,1}=['    '  ];
                % lg{end+1,1}=['** included files: ***'  ];
                % lg=[lg; fiused];
                % lg{end+1,1}=['** excluded files due to missing masks or world space deviances: ***'  ];
                % if isempty(fierror)
                %     lg=[lg; 'none'];
                % else
                %     lg=[lg; fierror];
                % end
                % pwrite2file(fiout2,lg);
                %     
                % 
                % try
                % %     explorerpreselect(fileout);
                %     disp(['created INCIDENCEMAP: <a href="matlab: explorerpreselect(''' fiout ''')">' 'show file' '</a>'  ]);
                % catch
                %     try
                %     explorer(outdir) ;
                %     end
                % end





%———————————————————————————————————————————————
%%   uniquefiles
%———————————————————————————————————————————————
function filex2=uniquefiles(li,lih,fi2)
% keyboard

filex=selector2(li,lih,'out','col-1','selection','multi','title','SELECTION FILTER: choose "mother-file(s)" to make IncidenceMaps [example "x_masklesion.nii"]');
filex2=filex;

return

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
    











