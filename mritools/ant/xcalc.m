

%% #ko image calculations within or across mouse folders [xcalc.m ]
% -this function allows to fuse images, threshold an image, average images
% -you can do image manipulations within a mouse folder or across mouse folders
%% #yg GUI PARAMETERS
% #b niftis 
%        - select one or more images, depending on the tasks:
%         [1] to fuse images: select the respective images here
%            example: make a mask from 3 images --> select the 3 images here
%         [2] to threshold one/more images independently from each other: select the respective image(s)
%         [3] to average image(s) across mosefolders independently: select the respective image(s)
% #b  evalstring
%      -matematical operation  to evaluate (as string)
%      -the operations must be in line with the matlab style and allow to call matlab build-in or costum functions
%      * USE PLACEHOLDERS TO ASSIGN the repective image or images:
%      [1] WITHIN MOUSE FOLDER  & SINGLE IMAGE OPERATION (niftis-parameter contain one image):        
%          use #r "@i"
%         example: -average 4d-image in the 4th. dimension:    "mean(@i,4)"
%         other examples:    "std(@i,[],4)" (to calculate the  STD over 4th dim)  or  "nanstd(@i,[],4)"
%         see also:  median, mode, max,min, sum, var,  etc...
%      [2] WITHIN MOUSE FOLDER  & MULTIPLE IMAGE OPERATION (niftis-parameters contain more than 1 image):  
%          use #r "@i1","@i2",..,"@iN"
%          where the number addresses the respective image in the "niftis"-array
%          example:   "(@i1+@i2)/2"                  : average the first two images defined in niftis-array
%                     "(@i1>.2)+(@i2>.2)+(@i3>.2)"   : threshold 3 input images at >0.2  and summate the result
%      [3] ACROSS MOUSE FOLDERS:  
%          use  #r "@m"  
%          example: "mean(@m,4)"    : average 3d-input image across all mousefolders (average is done along 4th dimension, which is the mouse-id)
% #b outName (filename outputformats)
% #g file extension (".nii") allowed to add but not necessary
% #g use "^" to indicate prefix/suffix or any substrings in combination with @i/@inum image placeholder
% #g use "@i", "@inum", or "@m" for files as indicated above
% FORMAT EXAMPLES____________________
% 'mean'         just a new file name (identical to '^mean')
% '^mean@i'      prefix "mean" added to 1st image name
% '^mean@i1'     same as '^mean@i' 
% '^mean@i2'     prefix "mean" added to 2nd image name
% '@i1'          same output name as 1st image, THIS WILL OVERWRITE THE 1st IMAGE !!!!
% '@i1^masked    suffix "masked" added to 1st image name
% '^just@i1^_@i2^masked'   prefix("just")+Img1Name+substring("_")+Img2Name+suffix("masked")
% '^mean@m'     "mean" added to 1st image name FOR ACROSS-MOUSE-DIRS-SCENARIO
% 
% #b outDir
%        specify the output directory, 2 options:
%         [1] 'local': type 'local' to save in the respective mouse folder (this is in "WITHIN MOUSE FOLDER OPERATIONS" the usual way)
%         [2] a fullpath directory: only usefull when doing operations ACROSS MOUSE FOLDERS
%
%% #yg EXAMPLES-1: OPERATIONS WITHIN MOUSE FOLDERS
%
%% #r for each of 3D-NIFTI-file (separately), average over 4rd dimension and save this in the local mouse-directory
%% #r as prefix "MEAN"+ inputName
% z=[];
% z.niftis         = { 'epi_mre_1.nii'    'epi_mre_2.nii' };      % % (<<) SELECT IMAGE(S) (volumes) to manipulate
% z.evalstring     =   'mean(@i,4)';            % % string to evaluate
% z.outName        =  '@MEAN'                  % % outputname: prefix 'MEAN' + inputName
% z.outDir         =   'local';                 % % select the output directory:  [empty] refers to local mouseDir
% xcalc(1,z);
% ______________________________________________________________________________________________________________________
%% #r same as above but save results as 'abc1.nii' and 'abc2.nii', respectively
% z=[];
% z.niftis         = { 'epi_mre_1.nii'    'epi_mre_2.nii' };               % % (<<) SELECT IMAGE(S) (volumes) to manipulate
% z.evalstring     =   'mean(@i,4)';             % % string to evaluate
% z.outName        =  {'abc1.nii' 'abc2.nii'}    % % respective output names
% z.outDir         =   'local';                  % % select the output directory:  [empty] refers to local mouseDir
% xcalc(1,z);
% ______________________________________________________________________________________________________________________
%% #r threshold image (>20 here) , save output in local mouse Folder as 'MASK_t2.nii'
% z=[];
% z.niftis         = { 't2.nii'  };               % % (<<) SELECT IMAGE(S) (volumes) to manipulate
% z.evalstring     =   'double(@i>20)';           % % string to evaluate
% z.outName        =  '@MASK'                    % % outputname: prefix 'MASK'+ inputName
% z.outDir         =   'local';                   % % select the output directory:  [empty] refers to local mouseDir
% xcalc(1,z);
% ______________________________________________________________________________________________________________________
%% #r APPLY MASK TO IMAGE: using the "AVGTmask.nii" only within brain data of "x_t2.nii" is extracted, the resulting
%% #r file ("brainonly.nii") is stored in the respective mouse folder 
% z=[];
% z.niftis     = { 'AVGTmask.nii'   'x_t2.nii' };    % %  << select IMAGE(S) to manipulate
% z.evalstring = '@i2.*(@i1>0)';       % % string to evaluate-> @i1 refers to 'AVGTmask.nii',   @i2 refers to 'x_t2.nii'
% z.outName    = 'brainonly';          % % resulting file name 
% z.outDir     = 'local';              % % select the output directory:  ["local"] refers to local mouseDir
% xcalc(1,z);
% ______________________________________________________________________________________________________________________
%% #r multiply 1st vol by 5 than add 2nd volume and devide all by 2, save output as "fuse.nii" in local mouse directory
% z=[];
% z.niftis         = { 'epi_mre_1.nii'   'epi_mre_2.nii' };           % % INPUT IMAGES
% z.evalstring     =   '((@i1.*5)+@i2)./2';                           % % string to evaluate
% z.outName        =  'fuse'                                          % % output name
% z.outDir         =  'local';                                        % % select the output directory:  [empty] refers to local mouseDir
% xcalc(1,z);
% 
%% #yg EXAMPLES-2: OPERATIONS ACROSS MOUSE FOLDERS
% ______________________________________________________________________________________________________________________
%% #r calculate standard deviation across mousedirs of a 3d input volume, save as "average_c_t2.nii" in "O:\data2\jing"
% z=[];
% z.niftis         = { 'c_t2.nii'  };              % % INPUT IMAGE  
% z.evalstring     =   'std(@m,[],4)';             % % string to evaluate
% z.outName        =  'average_c_t2'               % % output name
% z.outDir         =  'O:\data2\jing';             % % select the output directory:  [empty] refers to local mouseDir
% xcalc(1,z);
% ______________________________________________________________________________________________________________________
%% #r calulate the average  of a 4d input image across mousedirs, save as "average_c_t2.nii" in "O:\data2\jing"
% z=[];
% z.niftis         = { 'epi_mre_1.nii'         };  % % INPUT IMAGE  
% z.evalstring     =   'mean(@m,5)';               % % string to evaluate
% z.outName        =  'average_c_t2'               % % output name
% z.outDir         =  'O:\data2\jing';             % % select the output directory:  [empty] refers to local mouseDir
% xcalc(1,z);
% ______________________________________________________________________________________________________________________
%% #r create a volume that represents the percent overlapp of a 3D input image (thresholded at>10) across mouse folders
% z=[];                                                                                                                                                                                                                            
% z.niftis     = { 't2.nii' };                        % % INPUT IMAGE                                                                                                                                                                          
% z.evalstring = '100.*sum(@m>10,4)./size(@m,4)';     % % string to evaluate->see help                                                                                                                                                
% z.outName    = '_t2overlappPercent.nii';            % % outputname: <string><cell> or  use "@xxx" to use the prefix "xx", otherwise define N-outputNames                                                                            
% z.outDir     = pwd;                                 % % output directory                                                                                                         
% xcalc(1,z);                  
% 
%% #wb BATCH
% possible: see examples above
% xcalc(1,z);    the 1st input argument defines whether to open the gui [1] or work in background [0]
%                2nd input (z) struct with parameters see examples above
                

% rev: 31Oct2019_12-43-04 outputname: imageplaceholder+prefix/suffic


function xcalc(showgui,x,pa)


%———————————————————————————————————————————————
%%   example
%———————————————————————————————————————————————
if 0
    
    
    
    
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




% v=getuniquefiles(pa);
[tb tbh v]=antcb('getuniquefiles',pa);


%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
%%  PARAMETER-gui
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
if exist('x')~=1;        x=[]; end
p={...
    'inf0'      ['*** ' mfilename '     ****     ']         '' ''
    'inf7'     '====================================================================================================='        '' ''
    'niftis'        {''}           ' << select IMAGE(S) to manipulate'  {@selectfile,v,'multi'}
    'evalstring'     ''            'string to evaluate->see help'   ''
    'outName'        ''            'outputname: <string><cell> or  use "@xxx" to use the prefix "xx", otherwise define N-outputNames  ' ''
    'outDir'         'local'       '<<select the output directory:  ["local"] refers to local mouseDir'   'd'
    %     'inf8'           '__ alternatively use a costumized function (see help) _______________________________________________'        '' ''
    
    %     'costumfunction'      ''       '(<<) SELECT your own function ("evalstring" must be empty)' 'f'
    
    
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .5 .35 ],...
        'title','PARAMETERS: replaceheader','info',{@uhelp, mfilename});
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end



xmakebatch(z,p, mfilename);
calcit(z,pa);


%———————————————————————————————————————————————
%%
%———————————————————————————————————————————————
if 0
    
    
    %% for each of the NIFTI-files, average over the 4rd dimension and save this in the local mouse-directory
    % with the inputname+prefix "MEAN_"
    z=[];
    z.niftis         = { 'epi_mre_1.nii'    'epi_mre_2.nii' };               % % (<<) SELECT IMAGE(S) (volumes) to manipulate
    z.evalstring     =   'mean(@i,4)';             % % string to evaluate
    % z.outName        =  {'abc1.nii' 'abc2.nii'}
    z.outName        =  '@MEAN_'
    z.outDir         =   'local';                 % % select the output directory:  [empty] refers to local mouseDir
    z.costumfunction =   '';                      % % (<<) SELECT your own function ("evalstring" must be empty)
    xcalc(1,z);
    
    %% same as above but save result as 'abc1.nii' and 'abc2.nii', respectively
    z=[];
    z.niftis         = { 'epi_mre_1.nii'    'epi_mre_2.nii' };               % % (<<) SELECT IMAGE(S) (volumes) to manipulate
    z.evalstring     =   'mean(@i,4)';             % % string to evaluate
    z.outName        =  {'abc1.nii' 'abc2.nii'}
    z.outDir         =   'local';                 % % select the output directory:  [empty] refers to local mouseDir
    z.costumfunction =   '';                      % % (<<) SELECT your own function ("evalstring" must be empty)
    xcalc(1,z);
    
    %% threshold image , save in local mouseDir as 'MASK_t2.nii'
    z=[];
    z.niftis         = { 't2.nii'  };               % % (<<) SELECT IMAGE(S) (volumes) to manipulate
    z.evalstring     =   'double(@i>20)';             % % string to evaluate
    % z.outName        =  {'abc1.nii' 'abc2.nii'}
    z.outName        =  '@MASK_'
    z.outDir         =   'local';                 % % select the output directory:  [empty] refers to local mouseDir
    z.costumfunction =   '';                      % % (<<) SELECT your own function ("evalstring" must be empty)
    xcalc(1,z);
    
    %% multiply 1st vol by 5 than add 2nd volume and devide all by 3, save as "fuse.nii" in local mouse directory
    z=[];
    z.niftis         = { 'epi_mre_1.nii'           'epi_mre_2.nii' };
    z.evalstring     =   '((@i1.*5)+@i2)./2';             % % string to evaluate
    z.outName        =  'fuse'
    z.outDir         =  'local';                 % % select the output directory:  [empty] refers to local mouseDir
    z.costumfunction =   '';                      % % (<<) SELECT your own function ("evalstring" must be empty)
    xcalc(1,z);
    
    %%  std across mousedirs of 3dvolumes , save as "average_c_t2.nii" in "O:\data2\jing"
    
    z=[];
    z.niftis         = { 'c_t2.nii'         };
    z.evalstring     =   'std(@m,[],4)';             % % string to evaluate
    z.outName        =  'average_c_t2'
    z.outDir         =  'O:\data2\jing';                 % % select the output directory:  [empty] refers to local mouseDir
    z.costumfunction =   '';                      % % (<<) SELECT your own function ("evalstring" must be empty)
    xcalc(1,z);
    
    %%  average across mousedirs of 4dvolumes , save as "average_c_t2.nii" in "O:\data2\jing"
    z=[];
    z.niftis         = { 'epi_mre_1.nii'         };
    z.evalstring     =   'mean(@m,5)';             % % string to evaluate
    z.outName        =  'average_c_t2'           % % output name
    z.outDir         =  'O:\data2\jing';         % % select the output directory:  [empty] refers to local mouseDir
    z.costumfunction =   '';                      % % (<<) SELECT your own function ("evalstring" must be empty)
    xcalc(1,z);
    
    
end



%———————————————————————————————————————————————
%%   calcit
%———————————————————————————————————————————————

function calcit(z,pa)

% if ~isempty(z.costumfunction);
%     costumfunction(z,pa)
%     return
% end
if ischar(z.niftis);  z.niftis  =cellstr(z.niftis ); end
if ischar(z.outName); z.outName =cellstr(z.outName); end
if ischar(z.outDir);  z.outDir  =cellstr(z.outDir ); end


estr=z.evalstring;
% mod4=regexpi(estr, '@iiii' )
% mod3=regexpi(estr, '@iii' )
% mod2=regexpi(estr, '@ii' )


mod1=regexpi(estr, '@i' );
mod5=regexpi(estr, '@i\d+');
mod6=regexpi(estr, '@m');


disp(['xcalx-evalstr: '  estr ]);
str=estr;


% replacenames
%———————————————————————————————————————————————
%%   mod6
%———————————————————————————————————————————————
if ~isempty(mod6)
    for j=1:length(z.niftis)%IMAGE
        for i=1:size(pa,1) %MOUSE
            
            fi=fullfile(pa{i},z.niftis{j});
            [ha a]=rgetnii(fi);
            
            if i==1
                m=nan([size(a) size(pa,1) ]) ;
            end
            if ndims(a)==3
                m(:,:,:,i)=a;
            elseif ndims(a)==4
                m(:,:,:,:,i)=a;
            end
        end
        
        str2=['v=' regexprep(str,'@', '') ';'];
        eval(str2);
        hv=ha;
        if length(z.outName)==length(z.niftis);
            outfi=z.outName{j};
        else
            outfi=z.outName{1};
        end
        %if ~isempty(strfind(outfi,'@')) %prefix
        %    outfi=[regexprep(regexprep(outfi,'\@',''),'\s','') z.niftis{j} ];
        %end
        %outfi=[strrep(outfi,'.nii','') '.nii'];
         outfi=replacenames(outfi,z); %replacePLACEHOLDERS BY NAMES 
        
        
        if strcmp(lower(z.outDir),'local')
            fiout=fullfile(pa{i}, outfi);
        else
            fiout=fullfile(z.outDir{1}, outfi);
        end
        
        
        rsavenii(fiout, hv,v);
%         disp(['xcalc result: <a href="matlab: explorerpreselect(''' ...
%             fiout ''')">' fiout '</a>']);
        showinfo2('xcalc result:',fiout);
        
    end
end



%———————————————————————————————————————————————
%%   mod5
%———————————————————————————————————————————————
if ~isempty(mod5)
    for i=1:size(pa,1) %MOUSE
        for j=1:length(z.niftis)%IMAGE
            fi=fullfile(pa{i},z.niftis{j});
            [ha a]=rgetnii(fi);
            eval(['i' num2str(j) '=a;' ]);
        end
        
        str2=['v=' regexprep(str,'@', ' ') ';'] ;
        eval(str2);
        
        
        hv=ha;
        if length(z.outName)==length(z.niftis)  ;
            outfi=z.outName{j};
        else
            outfi=z.outName{1};
        end
        %if ~isempty(strfind(outfi,'@')) %prefix
        %    outfi=[regexprep(regexprep(outfi,'\@',''),'\s','') z.niftis{j} ];
        %end
        %outfi=[strrep(outfi,'.nii','') '.nii'];
        outfi=replacenames(outfi,z); %replacePLACEHOLDERS BY NAMES 
        if strcmp(lower(z.outDir),'local')
            fiout=fullfile(pa{i}, outfi);
        else
            fiout=fullfile(z.outDir{1}, outfi);
        end
        
        rsavenii(fiout, hv,v);
%         disp(['xcalc result: <a href="matlab: explorerpreselect(''' ...
%             fiout ''')">' fiout '</a>']);
        showinfo2('xcalc result:',fiout);
    end
end


%———————————————————————————————————————————————
%%   mod1
%———————————————————————————————————————————————
if ~isempty(mod1) && isempty(mod5)
    for i=1:size(pa,1) %MOUSE
        for j=1:length(z.niftis)%IMAGE
            fi=fullfile(pa{i},z.niftis{j});
            [ha a]=rgetnii(fi);
            str2=['v=' regexprep(str,'@i', 'a') ';'];
            eval(str2);
            hv=ha(1);
            if length(z.outName)==length(z.niftis);
                outfi=z.outName{j};
            else
                outfi=z.outName{1};
            end
            
        outfi=replacenames(outfi,z); %replacePLACEHOLDERS BY NAMES 
            
            
            if strcmp(lower(z.outDir),'local')
                fiout=fullfile(pa{i}, outfi);
            else
                fiout=fullfile(z.outDir{1}, outfi);
            end
            
            rsavenii(fiout, hv,v);
%             disp(['xcalc result: <a href="matlab: explorerpreselect(''' ...
%                 fiout ''')">' fiout '</a>']);
            showinfo2('xcalc result:',fiout);
        end
    end
end





%———————————————————————————————————————————————
%%   use costum function
%———————————————————————————————————————————————

function costumfunction(z,pa)



disp('not implemented yet');


% stradd(z.niftis,)

%[i]: for each volume separately
%[ii]: across multiple volumes defined in z.niftis (separately for each mouse)
%[iii]: for each volume separately and than across each mouse
%[iiii]: across multiple volumes defined in z.niftis and than across each mouse)







function he=selectfile(v,selectiontype)
he=selector2(v.tb,v.tbh,...
    'out','col-1','selection',selectiontype);






function outfi2=replacenames(outfi,z)

%% filename outputformats
% file extension (".nii") allowed to add but not necessary
% #b use "^" to indicate prefix/suffix or any substrings in combination with @i/@inum image placeholder
% #b use "@i", "@inum", or "@m" for files as indicated above
% FORMAT EXAMPLES____________________
% 'mean'         just a new file name (identical to '^mean')
% '^mean@i'      prefix "mean" added to 1st image name
% '^mean@i1'     same as '^mean@i' 
% '^mean@i2'     prefix "mean" added to 2nd image name
% '@i1'          warning same output name as 1st image, this will overwrite the 1st image !!!!
% '@i1^masked    suffix "masked" added to 1st image name
% '^just@i1^_@i2^masked'   prefix("just")+Img1Name+substring("_")+Img2Name+suffix("masked")
% '^mean@m'     "mean" added to 1st image name FOR ACROSS-MOUSE-DIRS-SCENARIO

%% tests
%  outfi='mean'; % new name, identical to '^mean'
% outfi='mean@i';
%  outfi='^mean@i'; %prefix "mean" added to 1st image name
% outfi='^mean@i1'; %same as above
%  outfi='^mean@i2'; %prefix "mean" added to 2nd image name
% outfi='@i1.nii'; % !warning same name as 1st image, this will overwrite the 1st image !!!!
% outfi='@i1^masked'; %suffix "masked" added to 1st image name
% outfi='^just@i1^_@i2^masked'; %prefix("just")+Img1Name+substring("_")+Img2Name+suffix("masked")
% 
% outfi='^mean@m'; %prefix "mean" added to 1st image name


% outfi='^mean_@i.nii';
% outfi='hiluulo.nii';
% outfi='^mean';
% outfi='@i^post'
% outfi='^mean@i1@i2';
% outfi='ww^mean@i1@i2^post.nii';
splitt=regexp(outfi,'@|\^','split');
if length(splitt)>1
    % splitt=strsplit(outfi,'@')
    for i3=1:length(splitt)
        if strfind(splitt{i3},'^')
            splitt{i3}= strrep(splitt{i3},'^','');
        elseif strfind(splitt{i3},'i')
            if length(splitt{i3})==1   % @i-image
                [~,fidx]=fileparts(z.niftis{1});
                splitt{i3}= fidx;
            elseif ~isempty(regexpi(splitt{i3},'i\d{1}')) % @number-image
                tokn=regexpi([splitt{i3}],'i\d*','match');
                if ~isempty(tokn)
                    ifilenum=str2num(char(strrep(tokn{1},'i','')));
                    [~,fidx]=fileparts(z.niftis{ifilenum});
                    splitt{i3}= fidx;
                end
            end
          elseif strfind(splitt{i3},'m')
            if length(splitt{i3})==1   % @m-image (across mouse dirs)
                [~,fidx]=fileparts(z.niftis{1});
                splitt{i3}= fidx;  
            end
        end
    end
else
    splitt=cellstr(outfi);
end
outfi2=[regexprep(sprintf('%s' ,splitt{:}),{'.nii','\s+'},{''}) '.nii'];
% disp(outfi2);






