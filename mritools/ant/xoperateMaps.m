

%% #b arithmetic operations on maps (heatmaps/IncidenceMaps/MeanImage Maps etc)
% function to perform math operations (+,-,*,/) of two maps, such as incidence-maps
% example usage: subtract two incidence(lesion)-maps from each other
%
% #lk  ___PARAMETER___
% 'maps'         select several maps to perform math. operations (number of maps>=2)
%                These maps are usually stored in the 'results'-folder
%                Run 'xcreateMaps.m' to create such maps before running this function
%
% 'mapPairs'     indices of maps to pair; mathematical operation will be done on these pairs; use "allcombs" to create all possible pair-combinations
%                 -n-by-2  pairwise indices refering to files in 'maps', where n is the number of math ops
%         example:   [1 2]             math op(map1,map2)
%                    [1 2; 1 3]        math op(map1,map2) and math op(map1,map3)
%                    [1 2; 1 3; 2 3]   math op(map1,map2) and math op(map1,map3) and math op(map2,map3)
%                  or use:
%                    'allcombs'        math op of all possible pairs of map-files
%
% 'mathOP'        mathematical operation performed on paired maps
%                   option: {'subtract' 'add' 'multiply' 'divide' }
%                   default: 'subtract'
%
% 'reverseOrder'  additionally create output of operation on reverse map-pair-order
%                   option: {0|1} , default: [1]
%                   i.e. if [1]: for example if a difference map mapA-mapB (subtraction) is created, the
%                           difference map mapB-mapA is also created
%
% 'mask'          use brain mask (e.g. AVGTmask.nii) to stamp-out results
%                   if 'mask' is empty no mask is used'
%                   default: ''
%
%  '___SPEICFY OUTPUT___'
% 'outDir'       output directory where maps are stored
%                 if empty, the folder of the 1st file in 'maps' is used as output folder
%                 default: ''
% 'prefixFN'     prefix of output filename
%                 options: {'inc' 'op' }; default: 'op'
% 'shortenFN'     shorten output filename by removing similar prefixes from pairs of input map-files
%                  options: {0|1}'; default: [1]
% 'timestampFN'   add timestamp as suffix to the output filename
%                  options: {0|1}'; default: [0]
%
%
% #lk  ___RUN___
% xoperateMaps(1) or  xoperateMaps    ... open PARAMETER_GUI
% xoperateMaps(0,z)             ...NO-GUI,  z is the predefined struct
% xoperateMaps(1,z)             ...WITH-GUI z is the predefined struct
%
% #lk  ___EXAMPLE___
% #lm     ___EXAMPLE-1___
% % ===========================================================================
% % #g subtract (mathOP) all three incidenceMaps from each other (files defined via 'maps', pairs
% % defined via 'mapPairs'). The diffmap is stored in 'z.outDir'
% % Aside subtraction of mapA-mapB also the reverse subtraction mapB-mapA ('reverseOrder') is created and stored in the same folder
% % The output filenames are shortend based on similar prefixes, no timestamp is added to the filename
% % No mask is used to stamp-out the result
% % ===========================================================================
% z=[];
% z.maps         = { 'F:\data5\nogui\results\MAPpercent_x_masklesion_het_d7.nii'   % % select several maps to perform operations
%                    'F:\data5\nogui\results\MAPpercent_x_masklesion_wt_d7.nii'    % %
%                    'F:\data5\nogui\results\MAPpercent_x_masklesion_ko_24h.nii'   % %
%                   };                                                             % %
% z.mapPairs     = [1  2; 1 3; 2 3 ];                                              % % indices of maps to pair; mathematical operation will be done on these pairs
% z.mathOP       = 'subtract';                                                     % % mathematical operation performed on paired maps
% z.reverseOrder = [1];                                                            % % additionally create output of reverse map-pair-order {0|1}
% z.mask         = '';                                                             % % use brain mask (e.g. AVGTmask.nii) to stamp-out results; if empty no mask is used
% z.outDir       = 'F:\data5\nogui\results';                                       % % output directory;  if empty same Dir is used as map1
% z.prefixFN     = 'op';                                                          % % prefix of output filename
% z.shortenFN    = [1];                                                            % % shorten output filename by removing similar prefixes of in input filenames {0|1}
% z.timestampFN  = [0];                                                            % % add timestamp as suffix {0|1}
% xoperateMaps(1,z);
% #lm     ___EXAMPLE-2___
% % ===========================================================================
% % #g similar to example-1, differences:
% % - all possible difference-maps are created (z.mapPairs='allcombs')
% % - a brainmask is used to stamp out the outer brain
% % - no-GUI mode (1st arg of 'xoperateMaps' is [0])
% % ===========================================================================
% z=[];
% z.maps         = { 'F:\data5\nogui\results\MAPpercent_x_masklesion_het_d7.nii'   % % select several maps to perform operations
%                    'F:\data5\nogui\results\MAPpercent_x_masklesion_wt_d7.nii'    % %
%                    'F:\data5\nogui\results\MAPpercent_x_masklesion_ko_24h.nii'   % %
%                    'F:\data5\nogui\results\MAPpercent_x_masklesion_het_24h.nii'  % %
%                    'F:\data5\nogui\results\MAPpercent_x_masklesion_wt_24h.nii'   % %
%                   };                                                             % %
% z.mapPairs     = 'allcombs';                                                     % % indices of maps to pair; mathematical operation will be done on these pairs
% z.mathOP       = 'subtract';                                                     % % mathematical operation performed on paired maps
% z.reverseOrder = [1];                                                            % % additionally create output of reverse map-pair-order {0|1}
% z.mask         = 'F:\data5\nogui\templates\AVGTmask.nii';                        % % use brain mask (e.g. AVGTmask.nii) to stamp-out results; if empty no mask is used
% z.outDir       = '';                                                             % % output directory;  if empty same Dir is used as map1
% z.prefixFN     = 'op';                                                          % % prefix of output filename
% z.shortenFN    = [1];                                                            % % shorten output filename by removing similar prefixes of in input filenames {0|1}
% z.timestampFN  = [0];                                                            % % add timestamp as suffix {0|1}
% xoperateMaps(0,z);




function xoperateMaps(showgui,x)




%===========================================
%%   PARAMS
%===========================================
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end

%% ===============================================
pasource=pwd;
global an
try
    tmp=fullfile(fileparts(an.datpath),'results');
    if exist(tmp)==7
        pasource=tmp;
    end
end


%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end

p={...
    'inf1'      '--- arithmetic operations on maps (incidenceMaps)   ---             '                         '' ''
    'maps'          ''      'select several maps to perform math. operations (number of maps>=2)'   'mf'
    
    'mapPairs'    [1 2]      'indices of maps to pair; mathematical operation will be done on these pairs; use "allcombs" to create all possible pair-combinations '     ...
    {'all combinations' 'allcombs'; ...
    'first two maps', [1 2]; 'map1&map2; map1&map3', [1 2; 1 3];...
    'map1&map2 AND map1&map3 AND map2&map3', [1 2; 1 3; 2 3];...
    }
    
    'mathOP'    'subtract'     'mathematical operation performed on paired maps {''subtract'',''add'',''multiply'',''divide''}'     ...
    {'subtract' 'subtract'; 'add' 'add'; ; 'multiply' 'multiply'; 'divide' 'divide';  }
    
    'reverseOrder'  1         'additionally create output of operation on reverse map-pair-order {0|1} ' 'b'
    'mask'   ''   'use brain mask (e.g. AVGTmask.nii) to stamp-out results; if empty no mask is used' 'f'
    
    'inf22' ' ' '' ''
    'inf33' '___OUTPUT___' '' ''
    'outDir'       ''     'output directory;  if empty, the same Dir is used as map1 '  'd'
    'prefixFN'     'op'  'prefix of output filename '   {'inc' 'op' }
    'shortenFN'     1     'shorten output filename by removing similar prefixes of in input map-filenames {0|1}' 'b'
    'timestampFN'   0     'add timestamp as suffix {0|1}'  'b'
    
    
    };


p=paramadd(p,x);%add/replace parameter


% %% show GUI
if showgui==1
    %hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],...
        'figpos',[   0.34   0.3    0.6    0.4 ],...
        'title',['***arithmetic operations on maps ***' '[' mfilename '.m]'],'info',{@uhelp, [mfilename '.m']});
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

% ==============================================
%%   BATCH
% ===============================================
try
    isDesktop=usejava('desktop');
    %  xmakebatch(z,p, mfilename,isDesktop)
    xmakebatch(z,p, mfilename,[mfilename  '(' num2str(isDesktop) ',z);' ]);
end

% ==============================================
%%   proc
% ===============================================

timex=tic;
cprintf('*[0 0 1]',[ ' operate on maps/incidencemaps  [' mfilename '.m]'  '\n'] );
proc(z);
cprintf('*[0 0 1]',[ ' DONE!  [ELA: ' sprintf('%2.0fs', toc(timex) )  ']'  '\n'] );



function proc(z)

%% =====[sanity checks + fill vars]    ======================
% check length of maps
z.maps=cellstr(z.maps);
if length(z.maps)<2; disp([ ' ' mfilename ':  [z.maps] at least two maps are required!..proc cancelled']); return; end

%map existence
isexist=find((existn(z.maps)==2)==0);
if ~isempty(isexist)
    disp([ ' ' mfilename ':  [z.maps] the following maps do not exist!..proc cancelled']);
    disp(char(z.maps(isexist)));
    return;
end


% check pairs
if ischar(z.mapPairs) && ~isempty(cell2mat(regexp(z.mapPairs,{'allcombs' ,'all'})))
    z.mapPairs=allcomb(1:length(z.maps),1:length(z.maps));
    idel=find((z.mapPairs(:,1)-z.mapPairs(:,2))==0);
    z.mapPairs(idel,:)=[];
    z.mapPairs=unique(sort(z.mapPairs,2),'rows');
end
si=size(z.mapPairs);
is=find(si==2);
if isempty(is);
    disp([ ' ' mfilename ':  [z.mapPairs] pairs of indices must be defined, no pairs found (' sprintf('size: [%d,%d]', si) ')' ]);
    return;
end

if si(1)==2 && si(2)~=2 %transpose
    z.mapPairs=z.mapPairs';
end

%outdir
if isempty(z.outDir)
    [paout]=fileparts(z.maps{1});
    z.outDir=paout;
end

%mask
z.mask=char(z.mask);

%% operationTag
optable={...
    'subtract' 'SUB'  '__SUB__'
    'add'      'ADD'  '__ADD__'
    'multiply' 'MUL'  '__MUL__'
    'divide'   'DIV'  '__DIV__'
    };
optag=optable{strcmp(optable(:,1),z.mathOP),2};
% if ~isempty(z.prefixFN) && strcmp(z.prefixFN(end),'_')
%   optag(1)=[];  
% end
    
%% ===============================================
comp=z.mapPairs;
maps=z.maps;

if exist(z.mask)==2  %LOAD MASK
    [hm m]=rgetnii(z.mask);
end

for i=1:size(comp,1)
    %% ===============================================
    fpname1=maps{comp(i,1)};
    fpname2=maps{comp(i,2)};
    
    [pam1 fname1 ext1]=fileparts(fpname1);
    [pam2 fname2 ext2]=fileparts(fpname2);
    
    disp(['---[map-operation]: ' num2str(i) '/' num2str(size(comp,1)) '  [OP]:' z.mathOP '; [maps]: "'  fname1 '" & "'  fname2 '"' ]);
    
    nametag1=fname1;
    nametag2=fname2;
    common_prefix='';
    if z.shortenFN==1
        try
            dname1=double(fname1);
            dname2=double(fname2);
            minstr=min([length(dname1) length(dname2)]);
            
            idiff=min(find((dname1(1:minstr)==dname2(1:minstr))==0));
            nametag1=fname1(idiff:end);
            nametag2=fname2(idiff:end);
            %common_prefix=fname1(1:idiff-1);
            common_prefix='';
            if isempty(nametag1) || isempty(nametag2)
                nametag1=fname1;
                nametag2=fname2;
            end
        end
        
    end
    
    f1=fpname1;
    f2=fpname2;
    
    prefix=z.prefixFN;
    timestamp='';  % 2013-04-01T13:01:02 https://softwareengineering.stackexchange.com/questions/61683/standard-format-for-using-a-timestamp-as-part-of-a-filename
    if z.timestampFN==1
        timestamp= datestr(now,'_yyyy-mm-dd_THHMMSS');
    end
    %     cname=[prefix common_prefix nametag1   optag nametag2  timestamp];
    %     dname=[prefix common_prefix nametag2   optag nametag1  timestamp];
    %
%     cname=[prefix common_prefix '[' nametag1 ']'   optag '[' nametag2 ']'  timestamp];
%     dname=[prefix common_prefix '[' nametag2 ']'   optag '[' nametag1 ']'  timestamp];
    
    cname=[prefix optag common_prefix '[' nametag1 ']'    '[' nametag2 ']'  timestamp];
    dname=[prefix optag common_prefix '[' nametag2 ']'    '[' nametag1 ']'  timestamp];


    f3=fullfile(z.outDir,[cname '.nii']);
    f4=fullfile(z.outDir,[dname '.nii']);
    %% ===============================================
    
    
    [ha a]=rgetnii(f1);
    [ha b]=rgetnii(f2);
    
    if     strcmp(z.mathOP,'subtract');         c=a-b;     d=b-a;
    elseif strcmp(z.mathOP,'add');              c=a+b;     d=b+a;
    elseif strcmp(z.mathOP,'multiply');         c=a.*b;    d=b.*a;
    elseif strcmp(z.mathOP,'divide');           c=a./b;    d=b./a;
    end
    
    c(isinf(c))=0;
    c(isnan(c))=0;
    
    
    if exist(z.mask)==2
        c=c.*m;
        if z.reverseOrder==1;       d=d.*m;   end
    end
    
    rsavenii(f3,ha,c,64);
    showinfo2('newFile',f3);
    
    if z.reverseOrder==1;
        rsavenii(f4,ha,d,64);
        showinfo2('newFile',f4);
    end
    
    
    
    %% ===============================================
end












