
function varargout=xmakebatch(z,p, callerfile,execCMD,mdirs)

% z: struct with parameter
% p: cellarray parameter x 4 cols (parameterName parameterValue info selectionOption )
% callerfile: function-name to execute (default: it is the parsed mfilename)
% execCMD: execution command for the function 
%          default: empty to obtain following execution command: dummy(1,z);
%            with: -1st arg: 0/1 to show the gui
%                  -2nd art: the struct with paramter
% varargout{1}: complete history (anth)
% varargout{2}: current function (+settings)

if isempty(callerfile)
   hlp='';  
else
    try
        hlp=help(callerfile);
        hlp=hlp(1:min(strfind(hlp,char(10)))-1);
    catch
        hlp='';
    end
end



hh={};
hh{end+1,1}=('%% =====================================================');
if isempty(callerfile)
     hh{end+1,1}=['%% #g FUNCTION:         <unknown>' ];
   % hh{end+1,1}=['%% info :                -     '  ];   
else
    hh{end+1,1}=['%% #g FUNCTION:    [' [callerfile '.m' ] ']' ];
    hh{end+1,1}=['%% ' regexprep(hlp,'^\s' ,'')];
end
hh{end+1,1}=('%% =====================================================');
% hh=[hh; 'z=[];' ];
% uhelp(hh,1);
he={'z=[];'};



% ----------
if isempty(p)
   p=repmat({''},1,4 ) ;
end
% ----------
% hh=[hh; struct2list(z)];
zz=struct2list(z);
ph=repmat({' '},[size(zz,1) 1]);%{};
spa=[];
fnames=fieldnames(z);
infox={};

fnames2={};%multiple lines per parameter/fname
for i=1:length(fnames)
    %is=regexpi2(zz,['^z.' fnames{i}  ]);
     is=regexpi2(zz,['^z.' fnames{i} '[=\s]' ]); %debug: end with '=' or blank
    
    if isempty(is)
    fnames2{is,1}='';    
    else
    fnames2{is,1}=fnames{i};
    end
end

for i=1:length(fnames2)
    ix=find(cellfun('isempty',regexpi(p(:,1),['^' fnames2{i} '$']))==0);
    if ~isempty(ix) & length(ix)==1
        ph{i,1}=['     % % ' p{ix,3}];
    else
        ph{i,1}=['       '         ];
    end
    % = sep
    is=strfind(zz{i},'=');
    if ~isempty(is)
        spa(i,1)=is(1);
    else
        spa(i,1)=nan;
    end
end

% z0=zz;
spaceadd=nanmax(spa)-spa;
for i=1:length(fnames2)
    if ~isnan(spaceadd(i))
        zz{i,1}= [ regexprep(zz{i} ,'=',[repmat(' ',1,1+spaceadd(i)) '= '],'once')  ];
    end
end

%% multicell cell - shift row containing multicell list
inan=find(isnan(spaceadd));
dum=zz;
for i=1:length(inan)
    
    row= inan(i);
    ispa=min(cell2mat(regexpi(dum(row-1),'=' )));
    if ~isempty(ispa)
        ispa2=ispa;
    end
    ival=min(regexpi(dum{row},'\S'));
    
    %dum=zz;
    dum{row ,1}=[repmat(' ',[1 ispa2-ival+4]) dum{row}];
    
end
zz=dum;



sizx=size(char(zz),2);
zz=cellfun(@(a,b) {[a repmat(' ' ,1,sizx-size(a,2)) b ]}, zz,ph);

% REMOVE [inv]-fields
iinf=regexpi2(zz,'^[A-z].inf\d+\s{0,1000}=');
zz(iinf)=[];

if exist('mdirs')==1 && ~isempty(char(mdirs))
    mdirs=cellstr(mdirs);
    mdirs=mdirs(:);
    hdirs=[['mdirs={'  repmat(' ',[1 35]) ' % % used animal folders'] ...
        ;(cellfun(@(a){[ repmat(' ',[1 4 ])  '''' a '''']} ,mdirs)); '    };' ; ' '];
else
    hdirs={};
end


hh=[hh;hdirs; he; zz];
isDesktop=usejava('desktop');
% ----------
if exist('execCMD')==0
    hh(end+1,1)={[callerfile '(' num2str(isDesktop),  ',z' ');' ]};
else
    hh(end+1,1)={[execCMD ]};
end
% disp(char(hh));
% uhelp(hh,1);

try
    v = evalin('base', 'anth');
catch
    v={};
    assignin('base','anth',v);
    v = evalin('base', 'anth');
end
v=[v; hh; {'                '}];
assignin('base','anth',v);

if nargout==1 ;    varargout{1}=v ;end
if nargout==2 ;    varargout{2}=hh;end
