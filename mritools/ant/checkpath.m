
% checks whether paths-names of ANTx-TBX, a study-project/template and data-sets contain special characters 
% special characters might result in errors & crashes
function checkpath

% ==============================================
%%   check spaces in  path
% ===============================================
global an
if isempty(an)
    cprintf([1 0 1],['[checkpath]: Please load an ANTx-project first. '  '\n']);
    return
end
% ==============================================
%%
% ===============================================

tb={};
try; tb(end+1,:)={'path configfile'  an.configfile}; end
try; tb(end+1,:)={'path template'    an.templatepath}; end
try; tb(end+1,:)={'path original template'   an.wa.refpath}; end
try; tb(end+1,:)={'path datasets'   an.datpath}; end

try
    tb=[ tb;  [cellfun(@(a){[ 'path of animal-'  num2str(a) ]}, num2cell([1:length(an.mdirs) ]'))  an.mdirs]
        ];
end

%trafoFiles ----
try; tb(end+1,:)={'path rigidTrafoFile'       an.wa.orientelxParamfile}; end
try; tb(end+1,:)={'path affineTrafoFile'      an.wa.elxParamfile{1}}; end
try; tb(end+1,:)={'path nonlinearTrafoFile'   an.wa.elxParamfile{2}}; end
try; tb(end+1,:)={'path ANTx2'   which('ant.m')}; end

% -----------TEST
if 0
    try; tb(end+1,:)={'path Test'   [pwd ' d  d']}; end
    try; tb(end+1,:)={'path Test2'   [pwd ' d  d <"|?*']}; end
end

% tb=[tb repmat({'dum ### OK'},[size(tb,1)  1])];


% uhelp( plog([],[ tb],0, 'Paths','al=1' ),0);

% ==============================================
%%  check paths (spaces)
% ===============================================
tes={
    '\s'  'space-character (" ")'
    '<'   'less than (<)-character'
    '>'   'greater than (>)-character'
    '"'   'double quote (")-character'
    '\|'  'vertical bar or pipe (|)-character'
    '\?'  'question mark (?)-character'
    '\*'  'asterisk (*)-character'
    };


chk=repmat({''},[size(tb,1) 1]) ;
for i=1:size(tb,1)
    isOK=ones(1,size(tes,1)) ;
    for j=1:size(tes,1)
        is= regexpi(tb{i,2},tes{j,1});
        if ~isempty(is)
            isOK(j)=0;
            chk(i,1)=...
                {[chk{i,1} '' tes{j,2}  ' found*; ' ]};
        end
    end
    
    
    %------------
    if sum(isOK)==size(tes,1)
        chk(i,1)={' #g OK'};
    else
       chk(i,1)={[' #m ' chk{i,1}]};
    end
    
end
%% ===============================================

tb2=[ tb chk];
m=plog([],[ tb chk],0, {' #wb Check paths names';...
    ' special characters in path-names such as spaces,"<",">",double quote,vertical bar, question mark and asterisk are not allowed'},'al=1' );
% m(end+1,1)={'<html><h1 style="color:red;font-size:15px;"> *If found please remove the special characters from the respective path(s).  '}
m(end+1,1)={' #r  *If found please remove the special characters from the respective path(s).  '};
uhelp(m,'1','name','check paths');
%% ===============================================

% uhelp( plog([],[ tb chk],0, {' #wb Check paths names';...
%     ' special characters in path-names such as spaces,"<",">",double quote,vertical bar, question mark and asterisk are not allowed'},'al=1' ),0);
