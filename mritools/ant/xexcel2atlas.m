% #ko make new ATLAS from modifed "ANO.xlx"-EXCELFILE
% #k Prerequisites: ATLAS(nifti-file) such as ANO.nii and a corresponding but modified excelfile (ANO.xls).
% #k The modified excelfile (ANO.xls) must contain two additional columns (newIDs and HemisphereType)...
% #k ...see parameter/'excelfile' (below)
% ___________________________________________________________________________________________________
%% #ko PARAMETER
% #k 'atlas'      select ATLAS (NIFTI-file) for example "ANO.nii" from the template folder
%              default: empty, #b ..and must be selected
% #k 'excelfile'  a modified version of the "ANO.xlsx"-Excel file, corresponding to the atlas
%             This modifed "ANO.xlsx" file contains 2 additional columns (position and header name of the
%             two columns is you choice):
%          [1]  [NEW ID COLUMN] a column that sparsely contains new IDs for regions that should appear 
%               in the new atlas
%              -the new IDs must be numeric
%              -the same new ID can be given for several regions--> The idea is to merge/fuse regions, 
%               i.e. regions with the same new ID will be merged
%              -the new IDs should be increasing without gaps (rather 1,2,3,4,5 instead of 1,2,10,11,50) 
%              -rows with no new IDs should be kept empty 
%          [2]  [HEMISPHERE TYPE COLUMN] a column that indicates the type of hemispheric setting
%              -the hemisperhic type must be numeric: 1,2,3 or 4: 
%                   -(1): use only the left hemisphere
%                   -(2): use only the right hemisphere
%                   -(3): use the left and right hemisphere together  (combine hemispheres)
%                   -(4): use the left and right hemispheres, separately: In this case regions of the 
%                         left hemisphere obtian the "newIDs" whereas regions of the right hemisphere
%                         obtain a new ID which is "newID"+ a number defined by "hemisphereIDstyle" (see below)
%              -the hemisperhic code has to be befinded for regions with a newID in the "newID" column  
%              -it is possible to use different hemisperhic types for different regions: 
%                 Example: AIM is to keep the "corpus_callosum" as it is (no separation in left and right
%                     hemispheric parts)  --> thus hemisperhic type for "corpus_callosum" is [3], additionally
%                     the "caudoputamen" should be separated for each hemisphere  -->thus the hemisperhic type
%                     for the "caudoputamen" is [4].
%           default: empty, ..and .. #b must be selected                   
%                         
% #k 'columnNewID'         Column index in the "excelfile" containing the new IDs #b (default: 2).
% #k 'columnHemispherType' Column index in the "excelfile" containing the hemisphere Type #b (default: 3).
% 
% #k 'hemisphereIDstyle'  If regions from left and right hemispheres are treated separately, define the numeric "gap"
%                       for the new right hemispheric IDs (right hemispheric ID-offset).
%                      #b options: {successive|gap100|gap1000|gap2000} or any numeric value 
%                       successive: new right Hemispheric IDs start with maximum of newIDs+1
%                                example:  new IDs in excelfile: 1,2,3
%                                 --> new output IDs:    left hemisphere: 1,2,3
%                                 --> new output IDs:   right hemisphere: 4,5,6  
%                       gap100   : the right hemispheric ID-offset is 100
%                                example:  new IDs in excelfile: 1,2,3
%                                 --> new output IDs:    left hemisphere:   1,  2,  3
%                                 --> new output IDs:   right hemisphere: 101,102,103                        
%                       gap1000   : the right hemispheric ID-offset is 1000
%                                example:  new IDs in excelfile: 1,2,3
%                                 --> new output IDs:    left hemisphere:    1,   2,   3
%                                 --> new output IDs:   right hemisphere: 1001,1002,1003 
%                       gap2000    : the right hemispheric ID-offset is 2000
%                       any numeric value:  a numeric value that defines the gap
%                #r The numeric gap must be larger than the maimum value of the new IDs
%                                  
% #k 'outputName'          The filename (string) of the output file #b (must be defined, default: 'dummyMask').
% #k 'outputDir'           The output directory, #b must be selected, if empty the location of the "excelfile" is used.
% #k 'saveSingleMasks'       For debugging purpose #b {0|1}: 
%                          (1): additionally saves the input regions as separate masks, in a new subfolder 
%                          (0): don't save single masks
% #k 'singleMasksType'     Specify the 'intensity' value of the single masks #b {1|2|3}:
%                         (1) mask contains binary values (inmask=1    , outmask=0)
%                         (2) mask contains the new ID    (inmask=newID, outmask=0)
%                         (3) both,  (1) binary mask and (2) newID masks will be separately generated
%                     #r "saveSingleMasks" must be set to "1"' to apply "singleMasksType"
% #k 'LRstringPosition'   Position of the output label substring denoting the LEFT/RIGHT hemishere #b {prefix|suffix}:
%                     'prefix'  : example:  "L_caudoputamen"/  "R_caudoputamen"
%                     'suffix'  : example:  "caudoputamen_L"/  "caudoputamen_R"
% ___________________________________________________________________________________________________
%% #ko RUN: 
% xexcel2atlas(1) or  xexcel2atlas    ... open PARAMETER_GUI 
% xexcel2atlas(0,z)             ...NO-GUI,  z is the predefined struct 
% xexcel2atlas(1,z)             ...WITH-GUI z is the predefined struct 
% 
%% #ko BATCH EXAMPLE
% z=[];                                                                                                                                                                                                                            
% z.atlas               = { 'f:\data1\AtlasGenerator\templates\ANO.nii' };     % % select ATLAS (must be a NIFTI-file, such as "ANO.nii" in template folder)                                                                       
% z.excelfile           = { 'f:\data1\AtlasGenerator\WU_newAtlas.xlsx' };      % % select modified ANO.xlsx file (corresponding, but modified EXCELFILE of the "atlas")                                                            
% z.columnNewID         = [2];                                                 % % which column in "excelfile" contains the new IDs (column index)                                                                                 
% z.columnHemispherType = [3];                                                 % % which column in "excelfile" contains the hemisphere Type (column index)                                                                         
% z.hemisphereIDstyle   = 'successive';                                        % % for hemispeheric separation, define right hemispheric ID-offset {successive|gap100|gap1000|gap2000} or a numeric value                          
% z.outputName          = 'dummyMask';                                         % % filename (string) of the output file"                                                                                                           
% z.outputDir           = 'F:\data1\AtlasGenerator';                           % % select outputdirectory, if empty output is stored where "excelfile" is located                                                                  
% z.saveSingleMasks     = [1];                                                 % % for debugging {0|1}: (1) saves also the input regions as separate masks (in new created subfolder)                                              
% z.singleMasksType     = [3];                                                 % % specify single mask value {1|2|3}: (1) binary,(2) new ID ,(3) both as separate outputs ("saveSingleMasks" must be "1")                          
% z.LRstringPosition    = 'prefix';                                            % % position of the output label string denoting the LEFT/RIGHT hemishere {prefix|suffix}                                                           
% xexcel2atlas(1,z);    


function xexcel2atlas(showgui, x)

if 0
    z=[];
    z.atlas               = { 'f:\data1\AtlasGenerator\templates\ANO.nii' };     % % select ATLAS (must be a NIFTI-file, such as "ANO.nii" in template folder)
    z.excelfile           = { 'f:\data1\AtlasGenerator\WU_newAtlas.xlsx' };      % % select modified ANO.xlsx file (corresponding, but modified EXCELFILE of the "atlas")
    z.columnNewID         = [2];                                                 % % which column in "excelfile" contains the new IDs (column index)
    z.columnHemispherType = [3];                                                 % % which column in "excelfile" contains the hemisphere Type (column index)
    z.hemisphereIDstyle   = 'successive';                                        % % for hemispeheric separation, define right hemispheric ID-offset {successive|gap100|gap1000|gap2000} or a numeric value
    z.outputName          = 'TEST2';                                           % % filename (string) of the output file"
    z.outputDir           = 'F:\data1\AtlasGenerator';                           % % select outputdirectory, if empty output is stored where "excelfile" is located
    z.saveSingleMasks     = [1];                                                 % % for debugging {0|1}: (1) saves also the input regions as separate masks (in new created subfolder)
    z.singleMasksType     = [3];                                                 % % specify single mask value {1|2|3}: (1) binary,(2) new ID ,(3) both as separate outputs ("saveSingleMasks" must be "1")
    z.LRstringPosition    = 'prefix';                                            % % position of the output label string denoting the LEFT/RIGHT hemishere {prefix|suffix}
    xexcel2atlas(1,z);
    
end



% {'(1) left','(2) right','(3) both united' '(4) both separated '}


%===========================================
%%    GUI
%===========================================
if exist('showgui')~=1;    showgui=1; end
if exist('x')      ~=1;    x=[];      end
if isempty(x);             showgui=1; end

p={...
    'inf1'      'Make Atlas From Excelfile        '         '' ''
    'inf2'      ['[' mfilename '.m]']                         '' ''
    'inf3'     '==================================='        '' ''
    'atlas'       ''      'select ATLAS (must be a NIFTI-file, such as "ANO.nii" in template folder)'   {  @selectatlas}
    'excelfile'   ''      'select modified ANO.xlsx file (corresponding, but modified EXCELFILE of the "atlas")'   {  @selectexcelfile}
    'columnNewID'         2     'which column in "excelfile" contains the new IDs (column index)'   { 1:10}
    'columnHemispherType' 3     'which column in "excelfile" contains the hemisphere Type (column index)'   { 1:10}
    'hemisphereIDstyle'   'gap100' 'for hemispeheric separation, define right hemispheric ID-offset {successive|gap100|gap1000|gap2000} or a numeric value'  {'successive' 'gap100' 'gap1000'  'gap2000'}
    ...
    %     'hemisphere'   '(3) both united'    'HEMISPHERE: define mask & relation to hemisphere' {'(1) left','(2) right','(3) both united' '(4) both separated '}
    'outputName'  'dummyMask'      'filename (string) of the output file"'   ''
    'outputDir'   ''               'select outputdirectory, if empty output is stored where "excelfile" is located'   {'d'}
    'saveSingleMasks'   1          'for debugging {0|1}: (1) saves also the input regions as separate masks (in new created subfolder)' {'b'}        
    'singleMasksType'   3          'specify single mask value {1|2|3}: (1) binary,(2) new ID ,(3) both as separate outputs ("saveSingleMasks" must be "1")' {1,2,3}        
    'LRstringPosition'   'prefix'  'position of the output label string denoting the LEFT/RIGHT hemishere {prefix|suffix}' {'prefix','suffix'}
    ...
    };
p=paramadd(p,x);%add/replace parameter
%% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.2 .5 .8 .25 ],...
        'title','Make Atlas From Excelfile','info',hlp);
    if isempty(m);return; end
else
    z=param2struct(p);
end


%===========================================
%%   process
%===========================================
xmakebatch(z,p, mfilename)

process(z);


%===========================================
%%   SUBS
%===========================================
function he= selectatlas(e,e2)
he=[];
[t,sts] = spm_select(1,'any','select atlas image (*.nii)','',pwd,'.*.nii','');
if t==0; he='';
else;     he=(t);
end
%% ________________________________________________________________________________________________
function he= selectexcelfile(e,e2)
he=[];
[t,sts] = spm_select(1,'any','select modified ANO.xlsx file (*.xlsx)','',pwd,'.*.xlsx','');
if t==0; he='';
else;     he=(t);
end


%% ________________________________________________________________________________________________
function process(z)

z.atlas    =char(z.atlas);
z.excelfile=char(z.excelfile);
z.outputName =char(z.outputName);
z.outputDir  =char(z.outputDir);

if isempty(z.outputDir);     z.outputDir=fileparts(z.excelfile);  end
[~,z.nameout]=fileparts(z.outputName);  %OUTPUTNAME



% [1] load ANO.nii
[ha a ci ind]=rgetnii(z.atlas);

% [2] get HEMImask if exist, otherwise create one..
paAno=fileparts(z.atlas);
hemimask=fullfile(paAno,'AVGThemi.nii');
if exist(hemimask)==2
    [hm m]=rgetnii(hemimask);
else
    m2=ones(size(a));
    m2((find(ci(1,:)>=0)))=2;
    %montage2(m+m2);
    m=m2;
end

%[3] load excelfile
[~,~,e0]=xlsread(z.excelfile);
he=e0(1,:);
he=cellfun(@(a){ [num2str(a)]},he); %convert to string (no 'NAN')
e=e0(2:end,:);

%remove NAN-columns;
idel=find(strcmp(he,'NaN'));
he(idel) =[];
e(:,idel)=[];


ireg=regexpi2(he,['^' 'region' '$']);
e(:,ireg)=cellfun(@(a){ [num2str(a)]},e(:,ireg));  %convert to string (no 'NAN')
e(find(strcmp(e(:,ireg),'NaN')),:) =[];            %remove NAN-rows

% GET NECESSARY COLUMNS
v.iregion=regexpi2(he,['^' 'region' '$']);
v.ichild=regexpi2(he,['^' 'children' '$']);
v.iID   =regexpi2(he,['^' 'ID' '$']);
v.inewID          =z.columnNewID;
v.ihemisphereType =z.columnHemispherType;

%% get NEW IDS
newIDCOL=e(:,v.inewID);
newIDCOL=cellfun(@(a){ [num2str(a)]},newIDCOL); %convert to string (no 'NAN')
newIDCOL=cellfun(@(a){ [str2num(a)]},newIDCOL); %convert to numeric
newIDCOL=cell2mat(newIDCOL);

uni=unique(newIDCOL); uni(isnan(uni))=[]; %NEW IDS

% ==============================================
%%   make table, 
% ===============================================

%% REDUCE TABLE
tb={};
for i=1:length(uni)
    ix=find(newIDCOL==uni(i));
    tb=[tb; e(ix,:)];
end
% ==============================================
%%   determine order of writing the atlas
% ===============================================
% numnodes=zeros(size(tb,1),1); % id+children
nodes   =cell(size(tb,1),2); % id+children
for i=1:size(tb,1)
    ch=(tb{i,v.ichild});
    if ischar(ch); ch=str2num(ch); end
    ch(isnan(ch))=[];
    
    nodesThis=[tb{i,v.iID}; ch];
    nodes(i,:)={length(nodesThis) nodesThis};
end
[~,isort]=sort(cell2mat(nodes(:,1)),'descend'); % sort
nodes=nodes(isort,:);
tb2  =tb(isort,:);



% ====================================================================
%%   TABLE: set "modif tag" if several regions exist in a new ID
%% the "child in parent"-problem is checked
% =====================================================================


tb3=[ tb2(:,[v.iregion v.inewID v.ihemisphereType v.iID  ])  nodes(:,1) nodes(:,2)];
htb3={         'label' 'newID'   'hemisphereType'  'id'     'numnodes' 'nodes'  };

newids      =cell2mat(tb3(:,2));
newidsuni   =unique(newids);
newLabel    ={};
oldLabel    ={};
clustnum    ={};
numid2merge ={};
allchild    ={};
imeta=zeros(size(tb3,1),1);
for i=1:length(newidsuni)
    il =find(newids==newidsuni(i));
    nnodes =cell2mat(tb3(il,5));
    imax   =max(find(nnodes==max(nnodes)));  % region with max NODES
    imeta(il(imax),1)=1;
    
    tag_modif='';
    if length(il)>1 % check if child
        chomax  =cell2mat(tb3(il(imax),6));
        chother =cell2mat(tb3(setdiff(il,il(imax)),6));
        chall   =unique([chomax; chother]);
        chrest = setdiff(chall,chomax); % rest of children not in max region
        if isempty(chrest) % all children of mother used, thus "not modified"
            tag_modif='';
        else
            tag_modif=' MODIF';
        end
    else
        %chall  =cell2mat(tb3(il(imax),6));
    end
    newLabel(il,1)    = { [tb3{il(imax),1} tag_modif]};
    clustnum(il,1)    = { i };
    numid2merge(il,1) = {length(il)};
    %allchild(il,:)    = repmat({length(chall) chall},[length(il) 1]);
end

htb4={'label'  'oldlabel' 'cluster' 'labelDOnator'   'members' ...
     'newID'    'HemiType' 'oldID'   'nodescount'    'nodes' };
tb4 =[newLabel  tb3(:,1) clustnum num2cell(imeta) numid2merge    tb3(:,2:6) ];

if 0 %TEST
    % uhelp( plog([],[  htb4; sortrows(tb4,2)] ),1);
    uhelp( plog([],[  htb4; tb4] ),1);
    
end


% ==============================================
%%   TABLE2: determine the reduced nodes due to "overpainting" by other regions
% note: tb4 is already sorted according nodescounts (many nodes ...to 1 node)
% IDEA: pool all nodes..than start with id with only 1 node and extract the the node... go to
% next id with more nodes
% ===============================================

w.inodecount =find(strcmp(htb4,'nodescount'));
w.inode      =find(strcmp(htb4,'nodes'     ));
w.ilabel     =find(strcmp(htb4,'label'     ));
w.icluster   =find(strcmp(htb4,'cluster'     ));
w.ioldlabel  =find(strcmp(htb4,'oldlabel'     ));
w.ioldID     =find(strcmp(htb4,'oldID'     ));


allnodes=unique(cell2mat(tb4(:,w.inode))); % UNIQUENESS OF ALL NODES
reducednodes={};
reducednodescount={};
labelold=tb4(:,w.ilabel);
labelnew=labelold;
clustervec =cell2mat(tb4(:,w.icluster));
whogetswhat={};
for i=size(tb4,1)  : -1 : 1
    thisnodes=cell2mat(tb4(i,w.inode));
    %[IDredu ia]=intersect(allnodes,[ 1 2 3 4]);
    [IDredu ia]=intersect(allnodes,thisnodes);
   reducednodes(i,1)      = {       IDredu};
   reducednodescount(i,1) = {length(IDredu)};
   
   
   whogetswhatThis=...
   [   repmat( tb4(i,w.ioldID)  ,[length(IDredu) 1])  repmat(tb4(i,w.ioldlabel),[length(IDredu) 1]) num2cell(IDredu)];
   whogetswhat=[whogetswhat; whogetswhatThis];
   
   allnodes(ia)=[];                 %remove this nodes
   
   
   if length(thisnodes)>length(IDredu)          % if fewer nodes than originally in region
       thiscluster=tb4{i,w.icluster};           % give cluster a modifed-tag (if not already done)
       isameclust=find(clustervec==thiscluster);
        thisnewlabel= {[ strrep(labelnew{i},' MODIF',''),  ' MODIF']};
       labelnew(isameclust)=thisnewlabel;
   end
end
% uhelp(plog([],[labelold labelnew tb4(:,w.inodecount) reducednodescount ]),1)
% GET WHO STOLE WHAT REGION
% whogetswhat: {'oldID' 'label' 'regionThatStoled'}
allnodes2=cell2mat(whogetswhat(:,3));
stealerTB={};
for i=1:size(tb4,1)
    thisnodes=cell2mat(tb4(i,w.inode));
    %[IDredu ia]=intersect(allnodes,[ 1 2 3 4]);
    [IDredu ia]=intersect(allnodes2,thisnodes);
    distri=(whogetswhat(ia,:));
    distri(find(cell2mat(distri(:,1))== tb4{i,w.ioldID} ),:)=[]; %remove IDS that are owned by
    distri=[num2cell([1:size(distri,1)]')  sortrows(distri,1)]; %sort and add countNUMBER
   
    dv =[tb4(i,w.ioldlabel) tb4(i,w.ioldID)];
    dv2=[repmat(dv,[size(distri,1) 1] ) distri];
    stealerTB=[stealerTB; dv2];
end
hstealerTB={'region' 'regionID' 'stealerCount' 'stealerID' 'stealerRegion', 'stoledID'};


htb5=[htb4                 'nodescountreduced' 'nodesreduced'  ];
tb5 =[labelnew tb4(:,2:end) reducednodescount reducednodes     ];

% TEST
if 0
    idel=regexpi2(htb5,['^nodes$' '|' '^nodesreduced$'],'match') ;
    iuse=setdiff(1:length(htb5),idel);
    hxx=htb5(iuse);
    xx = tb5(:,iuse);
    uhelp( plog([],[  hxx; xx] ),1);
end





% ==============================================
%%   gap-issue (right side)
% ===============================================
if isnumeric(z.hemisphereIDstyle)                   %gap as numeric
    gap=z.hemisphereIDstyle;
else
    z.hemisphereIDstyle=char(z.hemisphereIDstyle);   %gap
    if ~isempty(strfind(z.hemisphereIDstyle,'gap'))
        gap=str2num(regexprep(z.hemisphereIDstyle,'\D',''));
    else
        gap=max(cell2mat(tb2(:,v.inewID)));   %SUCCESSIVE
    end
end
% ==============================================
%%   CREATE ATLAS
% ===============================================
warning off;
u=[];
u.inodes              = find(strcmp(htb5,'nodes'));
u.inodescountreduced  = find(strcmp(htb5,'nodescountreduced'));
u.ihemisphereType     = find(strcmp(htb5,'HemiType'));
u.inewID              = find(strcmp(htb5,'newID'));
u.ilabel              = find(strcmp(htb5,'label'));
u.ioldlabel           = find(strcmp(htb5,'oldlabel'));
u.ioldID              = find(strcmp(htb5,'oldID'));

tic
al=a(:).*(m(:)==1);
ar=a(:).*(m(:)==2);

s  =zeros(size(al)); %atlas 3d
sm =zeros(size(al)); %singular masks 3d
sa =zeros(size(al)); %index 3d --> to get reduzed volume afterwards
tx ={};
tb6={};
vol_orig={};
voxvol = abs(det(ha.mat(1:3,1:3)));
count=1;
for i=  1:size(tb5,1)
    
   if z.saveSingleMasks==1
       sm =zeros(size(al)); 
   end
    
    xnodes         = cell2mat(tb5(i,u.inodes));
    hemispheretype =          tb5{i,u.ihemisphereType};
    
    
    kl=ismember(al, xnodes);      il=find(kl==1);
    kr=ismember(ar, xnodes);      ir=find(kr==1);
    
     dum=[tb5(i,:)  tb5(i,u.inewID) ] ; %TB5 and newID
    if hemispheretype==1 %LEFT
        s(il,1) = tb5{i,u.inewID} ;
        dum2    = dum;          dum2(u.ilabel) =  {[dum2{u.ilabel } ' L']};
        origvol = voxvol .*[length([il])  ];
        tb6     = [tb6; [dum2 {origvol} ] ];
        
        sa(il,1) = count ;  count=count+1;
        
        if z.saveSingleMasks==1
            sm(il,1)  =tb5{i,u.inewID} ;
        end
    elseif hemispheretype==2 %RIGHT
        s(ir,1) = tb5{i,u.inewID} ;
        dum2    = dum;          dum2(u.ilabel) =  {[dum2{u.ilabel } ' R']};
        origvol = voxvol .*[length([ir])  ];
        tb6     = [tb6; [dum2 {origvol} ] ];
        
        sa(ir,1) =count ;  count=count+1;
        
        if z.saveSingleMasks==1
            sm(ir,1)  =tb5{i,u.inewID} ;
        end
    elseif hemispheretype==3 %united
        s(il,1)  = tb5{i,u.inewID} ;
        s(ir,1)  = tb5{i,u.inewID} ;
        dum2     = dum;          dum2(u.ilabel) =  {[dum2{u.ilabel } '']};
        origvol  = voxvol .*[length([ir;il])  ];
        tb6      = [tb6; [dum2 {origvol} ] ];
       
        sa(il,1) = count ; 
        sa(ir,1) = count ;  count=count+1; %same count left,right..both hemispheres united
        
       if z.saveSingleMasks==1 
           sm(il,1)  =tb5{i,u.inewID} ;
           sm(ir,1)  =tb5{i,u.inewID} ; 
        end
    elseif hemispheretype==4 %both separated
        s(il,1)  =tb5{i,u.inewID} ;
        s(ir,1)  =tb5{i,u.inewID}+gap ;
        
        dum2     = dum;          dum2(u.ilabel) =  {[dum2{u.ilabel } ' L']}; %LEFT
        origvol  = voxvol .*[length([il])  ];
        tb6      = [tb6; [dum2 {origvol} ] ];
        
       dum2=dum;   dum2(u.ilabel) =  {[dum2{u.ilabel } ' R']};  %RIGHT
       dum2(end) =  {[dum2{u.inewID }+gap]};
       origvol  = voxvol .*[length([ir])  ];
       tb6      = [tb6; [dum2 {origvol} ] ];
       
       sa(il,1) = count ;  count=count+1;
       sa(ir,1) = count ;  count=count+1;
       
      if z.saveSingleMasks==1 
           sm(il,1)  =tb5{i,u.inewID} ;
           sm(ir,1)  =tb5{i,u.inewID}+gap ; 
      end
    end
    
    if z.saveSingleMasks==1
       MaskName      =['msk_ID_' num2str(dum{u.inewID})  '_' strrep(dum{u.ioldlabel},' ','_') '.nii'];
       outdirPath    =fullfile(z.outputDir, [z.nameout '_singleMasks' ]);
       disp([ num2str(i) '  ' MaskName]);
       if exist(outdirPath)~=7 ; 
           mkdir(outdirPath);
       end 
       if 1
           %binarize
           fileout=fullfile( outdirPath, MaskName);
           if z.singleMasksType==1
               sm(sm>0)=1;
               rsavenii(fileout, ha,(reshape(sm,ha.dim)),[2 0]); %binary mask
           elseif z.singleMasksType==2
               rsavenii(fileout, ha,(reshape(sm,ha.dim)),[16 0]);
           elseif z.singleMasksType==3
               rsavenii(fileout, ha,(reshape(sm,ha.dim)),[16 0]);
               
               fileout2=strrep(fileout,'.nii','_binary.nii');
               sm(sm>0)=1;
               rsavenii(fileout2, ha,(reshape(sm,ha.dim)),[2 0]); %binary mask
           end
           
       end
       
    end
end
% toc

% ==============================================
%   volume after "overpainting"
% ===============================================
VOLnew=zeros(size(tb6,1),1);
for i=1:size(tb6,1)
    nvox=length(find(sa==i));
    VOLnew(i,1)=voxvol*nvox;
end
tb6=[tb6 num2cell(VOLnew)];

% ==============================================
%%   fill table with new "finalID"
% ===============================================

htb6=[htb5 'finalID' 'VOLorig' 'VOLnew'];

   
if 0
    idel=regexpi2(htb6,['^nodes$' '|' '^nodesreduced$'],'match') ;
    iuse=setdiff(1:length(htb6),idel);
    
    hxx=htb6(iuse);
    xx = tb6(:,iuse);
    isort=find(strcmp(hxx,'finalID'));
    uhelp( plog([],[  hxx; sortrows(xx,isort)] ),1);
end

% ==============================================
%%   change "L/R"-tag from suffix to prefix position (if selected)  
% ===============================================
if strcmp(z.LRstringPosition,'prefix')
    ilabel=find(strcmp(htb6,'label'));
    for i=1:size(tb6,1)
        if ~isempty(regexp(tb6{i,ilabel},' L$'))
            tb6(i,ilabel)={['L ' regexprep(tb6{i,ilabel},' L$','')]};
        end
        if ~isempty(regexp(tb6{i,ilabel},' R$'))
            tb6(i,ilabel)={['R ' regexprep(tb6{i,ilabel},' R$','')]};
        end
    end
    
end

% ==============================================
%%   save [0] save merged mask (nifti)
% ===============================================
% % if isempty(z.outputDir)
% %     z.outputDir=fileparts(z.excelfile);
% % end
% % [~,z.nameout]=fileparts(z.outputName);
niftifile=fullfile( z.outputDir, [ z.nameout '.nii']);
rsavenii(niftifile, ha,(reshape(s,ha.dim)));

% ==============================================
%%   make FINAL  INFO Table
% ===============================================

idel=regexpi2(htb6,['^nodes$' '|' '^nodesreduced$'],'match') ;
iuse=setdiff(1:length(htb6),idel);
hxx=htb6(iuse);
xx = tb6(:,iuse);
icounts        =sort(regexpi2(hxx,['^nodescount$' '|' '^nodescountreduced$'])) ;
nodecountsDiff =([cell2mat(xx(:,icounts(1)))-cell2mat(xx(:,icounts(2)))]);
xx  =[xx  num2cell(nodecountsDiff)];
hxx =[hxx  'nodecountsDiff'];

isel        =sort(regexpi2(hxx,['^nodescount$' '|' '^nodescountreduced$' '|' '^nodecountsDiff$'])) ;
ioth        =setdiff([1:length(hxx)],isel);
xx  =[xx(:,ioth) xx(:,isel)];
hxx =[hxx(ioth)   hxx(isel)];


ifinalID=find(strcmp(hxx,'finalID'));
iother=setdiff(1:length(hxx),ifinalID);
hxx=hxx([ifinalID iother]);
xx= xx(:,[ifinalID iother]);
xx=sortrows(xx,1);

% ==============================================
%%   save txt-file
% ===============================================
disp('...writing tables');

% uhelp( plog([],[  hxx; xx] ),1);

iuse=find(cell2mat(xx(:,find(strcmp(hxx,'labelDOnator'))))==1);
b =xx(iuse,:);
hb=hxx;
isel        = (regexpi2(hxx,['^finalID$' '|' '^label$' ])) ;
ioldID      = (regexpi2(hxx,['^oldID$' ])) ;


b2  =b(:,isel);
hb2={'# ID' 'Labelname'  };
% -------------------------------
% COLOR columns get RGB
icolinE =find(strcmp(he,'colRGB'));
iIDinE  = (regexpi2(he,['^ID$' ])) ;
color=[];
if ~isempty(icolinE)
    IDe =cell2mat(e(:,iIDinE));
   for i=1:size(b,1)
       is=find(IDe==b{i,ioldID});
       color(i,:)=str2num(e{is,icolinE});
       %disp([e(is,1)  b(i,3) 'ismatch:'  strcmp(e(is,1),b(i,3)) ]);
       %disp([  'ismatch:'  num2str(strcmp(e(is,1),b(i,3))) ]);
   end
end


if ~isempty(color)
    b2=[b2 num2cell(color) repmat({255},[size(color,1) 1]) ];
    hb2=[hb2   'R'   'G'   'B'   'A'];
end
% -------------------------------

%remove spaces
b2(:,2)=regexprep(b2(:,2),{'\s+'},{'_'});

% uhelp( plog([],[  hb2; b2] ),1);

txt=plog([],[  hb2; b2],0,'','plotlines=0' );
while isempty(char((regexprep((cellfun(@(a){ a(1)},txt)),'\s+',''))))  ==1 % remove starting space column
    txt=cellfun(@(a){ a(2:end)},txt);
end

fileout=fullfile( z.outputDir, [ z.nameout '_INFO.txt']);
pwrite2file(fileout ,txt );

% ==============================================
%%   determine exceltype
% ===============================================
% isexcel=0;
isexcel=ispc;

% ==============================================
%%   save [1]   INFO Table
% ===============================================

% xx=sortrows(xx,)
% uhelp( plog([],[  hxx; xx] ),1);

fileout=fullfile( z.outputDir, [ z.nameout '_INFO.xlsx']);
if isexcel==1
    pwrite2excel(fileout,{1 'INFO' },hxx,[],xx);
else
    sub_write2excel_nopc(fileout,'INFO',hxx,xx);
end

%———————————————————————————————————————————————
%%  save [2] new ID table (reduced version)
%———————————————————————————————————————————————
allnewIDs=cell2mat(xx(:,1));
[newIDsuni, io]=unique(allnewIDs);

yy=xx(io,1:2);
newIDsuni=cell2mat(yy(:,1));

[hac ac]=rgetnii(niftifile);
ac=ac(:);

counts=histc(ac,newIDsuni);
volreg=voxvol.*counts;
% counts2=zeros(length(newIDsuni) ,1);
% for i=1:length(newIDsuni)
%    counts2(i,1)= length(find(ac==newIDsuni(i)));
% end
% disp(['diff in countMethods: ' num2str(sum(abs([counts-counts2])))]);

TB4 =[yy num2cell(volreg)];
hTB4=[hxx(1:2) 'volume'];

if isexcel==1
    pwrite2excel(fileout,{2 'NEW_IDS' },hTB4,[],TB4);
else
    sub_write2excel_nopc(fileout,'NEW_IDS',hTB4,TB4);
end

% ==============================================
%%   save [3] stealer Table
% ===============================================
if isexcel==1
    try
        pwrite2excel(fileout,{3 'RegionStealer' },hstealerTB,[],stealerTB);
    end
else
   try
        sub_write2excel_nopc(fileout,'RegionStealer',hstealerTB,stealerTB);
    end 
end

% ==============================================
%%   save [4] reduced INPUT table
% ===============================================
hTBreduced=he;
TBreduced=tb2;
% ichild=find(strcmp(hTBreduced,'Children'));
% if ~isempty(ichild)
%
% end
if isexcel==1
    pwrite2excel(fileout,{4 'INPUT' },hTBreduced,[],sortrows( TBreduced,z.columnNewID ));
else
    sub_write2excel_nopc(fileout,'INPUT',hTBreduced,sortrows( TBreduced,z.columnNewID ));
end
    
% ==============================================
%%   save [5-6] OUTPUT tables
% ===============================================
if isexcel==1
    pwrite2excel(fileout,{5 'output1' },{' SET to FONT to "COURIER NEW" to modify'},[],txt);
    pwrite2excel(fileout,{6 'output2' },hb2,[],b2);
else
    sub_write2excel_nopc(fileout,'output1',[],[{'SET to FONT to "COURIER NEW" to modify'};txt]);
    sub_write2excel_nopc(fileout,'output2',['ID' hb2(2:end)],[b2]);
end


% ==============================================
%%   warning DLG
% ===============================================
warning off;

% -------------------check NEW IDS and their volume--------------------------
lg3={};
volnewIDS=cell2mat(TB4(:,3));   %NEW ID get VOLUME TO check if nonfinder-newDs found in new ATLAS
inovol   =find(volnewIDS==0);
if ~isempty(inovol)
    lg3={' #kr PROBLEM  '};
    for i=1:length(inovol)
        lg3{end+1,1}=  [ 'newID[' num2str(TB4{inovol(i),1}) '] "' num2str(TB4{inovol(i),2}) '" has no volume!'];
    end
    lg3=[lg3; ['  ...please inspect "' [ z.nameout '_INFO.xlsx'] '" to find the reason']];
end
% -----------------------------------------------------------------


ivolorig=find(strcmp(hxx,'VOLorig'));
ivolnew =find(strcmp(hxx,'VOLnew'));
inovolorig=find(cell2mat(xx(:,[ivolorig]))==0);
inovolnew =find(cell2mat(xx(:,[ivolnew]))==0);
isel        =sort(regexpi2(hxx,['^oldlabel$' '|' '^oldID$'  ])) ;



i2ID       =find(strcmp(hTBreduced,'ID'));
i2Children =find(strcmp(hTBreduced,'Children'));

% inovolnew=[inovolnew ;1]
% inovolorig=[];
% inovolnew=[];

if ~isempty(inovolorig) %check L/R-doublettes
  dum3= [inovolorig  [xx{inovolorig,isel(2)}]'] ;
    [~, iuni]=unique(dum3(:,2)); %REMOVE DOUBLETTS;idices of  unique IDS (not doublettes from right hemisphere);
    inovolorig=inovolorig(iuni);
end

lg0=[' #ky WARNING  ';...
    { 'explanation: line consist of [ID in ATLAS],[infovector] and the LABEL' };...
    { '[infovector] element-1:  {0|1} Is ID found in ATLAS?  ' };...
    { '[infovector] element-2:  {0|1} IS ID found in the excelfile in the ID-column ' };...
    { '[infovector] element-3:  if element-2 is true: {0|1} Does this ID have children  ' };...
    { ' #b EXAMPLE1 [0 1 0]: ID is not found in atlas, but found in the  ID-column in the excelfile,' };...
    { ' #b    this ID has no childs' };...
    { ' #b EXAMPLE2 [0 1 1]: same as before, but now childs are found #r THAT MEANS THAT ' };...
    { '  #r EVERYTHING IS OK WITH THIS ID, because mostlikely the ID''s children have been found' };...
    { '  #r  and incorporated into the ATLAS' };...
    ];
if ~isempty([(inovolorig(:)) ;(inovolnew(:))])
    lg={};lgm='';
    if ~isempty(inovolorig)
        for i=1:length(inovolorig)
            
            
            
            foundInATL  =0;
            ismother    =0;
            hasChildren =0;
            
            nvox=length(find(a==xx{inovolorig(i),isel(2)}));
            if nvox>0; foundInATL=1; end
            
            inode=find(cell2mat(TBreduced(:,i2ID))==xx{inovolorig(i),isel(2)});
            if ~isempty(inode); 
                ismother=1;
            end
            if ismother==1
                childs=TBreduced{inode,i2Children};
               if ~isnumeric(childs)
                 childs=str2num(childs);  
               end
               nchild=length(find(~isnan(childs)));
               if nchild>0; hasChildren=1; end
            end
            info3=[regexprep(num2str([nvox ismother hasChildren]),'\s+',' ')];
            
      
             spac=repmat('.', [1 15-length(['[ID ' num2str(xx{inovolorig(i),isel(2)}) ']'])]);    
            dumx= {['[ID ' num2str(xx{inovolorig(i),isel(2)}) ']' spac '[' info3 '] ' xx{inovolorig(i),isel(1)} ]};
            lg=[lg;dumx];
        end
        lgm=[' #wg REGIONS/IDs not found in the INPUT-Volume.';...
            ''; ...
            unique(lg,'rows')];
    end
    
    iadd=setdiff([inovolnew],[inovolorig ]);
    lg2={}; lgm2='';
    if ~isempty(iadd)
        dum3= [iadd  [xx{iadd,isel(2)}]'] ;
        [~, iuni]=unique(dum3(:,2)); %REMOVE DOUBLETTS;idices of  unique IDS (not doublettes from right hemisphere);
        iadd=iadd(iuni);
        
        
        for i=1:length(iadd)
            
            foundInATL  =0;
            ismother    =0;
            hasChildren =0;
            
            nvox=length(find(a==xx{iadd(i),isel(2)}));
            if nvox>0; foundInATL=1; end
            
            inode=find(cell2mat(TBreduced(:,i2ID))==xx{iadd(i),isel(2)});
            if ~isempty(inode);
                ismother=1;
            end
            if ismother==1
                childs=TBreduced{inode,i2Children};
                if ~isnumeric(childs)
                    childs=str2num(childs);
                end
                nchild=length(find(~isnan(childs)));
                if nchild>0; hasChildren=1; end
            end
            info3=[regexprep(num2str([nvox ismother hasChildren]),'\s+',' ')];
            
            
            nvox=length(find(a==xx{iadd(i),isel(2)}));
            if nvox>0; foundInATL='1'; else; foundInATL='0'; end
            spac=repmat('.', [1 15-length(['[ID ' num2str(xx{iadd(i),isel(2)}) ']'])]);
           dumx= {['[ID ' num2str(xx{iadd(i),isel(2)}) ']' spac '[' info3 '] ' xx{iadd(i),isel(1)} ]};
          % dumx={['[ID ' num2str(xx{iadd(i),isel(2)}) '] ' xx{iadd(i),isel(1)} ]}
            lg2=[lg2; dumx];
        end
        lgm2=['  ';...
            ' #wg  REGIONS/IDs/CHILDREN have with final "Zero" OUTPUT-Volume.';...
            '  REASONS:'
            ' (1) ID/CHILD not found in ATLAS (NIFTI-file) ';...
            ' (2) other parental regions stole this region '; ...
            ' (3) is parental node, while childs are found '; ...
            ' Thus, regions with [0 1 0] vector do not appear in the new Atlas:'; ...
            unique(lg2,'rows')];
    end
    msg=[[lg3; lg0; lgm; lgm2]];
    
    %     h=warndlg(msg);
    uhelp(plog([],[msg],'style=1'),1);
    
   % fileout=fullfile( z.outputDir, [ z.nameout '_WARNING.txt']);
   % pwrite2file(fileout ,msg );
    
    if isexcel==1
        pwrite2excel(fileout,{7 'WARNING' },{'importantNote'},[],msg);
    else
        sub_write2excel_nopc(fileout,'WARNING',{'importantNote'},msg);
    end
    
end

% ==============================================
%%   end here
% ===============================================
% disp('...done');
disp(sprintf('DONE (%2.2fs)',toc  ));
return


