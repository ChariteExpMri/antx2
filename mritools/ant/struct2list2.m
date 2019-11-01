


function out=struct2list2(p,name)

%———————————————————————————————————————————————
% make nicer
%———————————————————————————————————————————————

% eval([name '=' 'p' ';'])


in= struct2list(p ,name);

% fn1=who
% eval(strjoin(in,char(10)))
% fn2=who

v2=cellstr(in);

iq=regexpi(v2,'=');
inot=~cellfun('isempty',regexpi(v2,'=='));
iq(inot==1)={[]};
iq(cellfun('isempty',iq))={nan};


ip=cell2mat(cellfun(@(a){min(a)},iq));
imax=nanmax(ip);


v3=v2;
for i=1:size(v2,1)
    if ~isnan(iq{i})
        ipo=regexpi(v2{i},'=','once');
      v3{i}= regexprep(v2{i},'=',[ '=' repmat(' ',1,(imax+1)-ip(i))],'once' );
    end
end
qw3=v3;

% qw3=makenicer2(qw3);

in=qw3;


if ischar(in)
    tx5=strsplit(in,char(10))';
else
    tx5=in;
end
lincod=regexpi2(tx5, [name '.' '\w+=|\w+\s+=']);
lin=tx5(lincod);

% set '='
w1=regexpi(lin,'=','once')          ; %equal sign
w2=regexpi(lin,'\S=|\S\s+=','once') ;% %last char of fieldname %regexpi({'w.e=3';'wer   =  33'},'\S=|\S\s+=','once')
try; w1=cell2mat(w1); end
try; w2=cell2mat(w2); end
lin2=lin;
for i=1:size(lin2)
    is1=regexpi(lin2{i},'\S=|\S\s+=','once');
    is2=regexpi(lin2{i},'=','once');
    
  lin2{i} = ...
  [lin2{i}(1:is1) repmat(' ',[1 max(w2)-w2(i)]) ' ='  lin2{i}(is2+1:end) ];
end
% char(lin2)
lin=lin2;

%set field
w1=regexpi(lin,'(?<==\s*)(\S+)','once'); %  look back for "= & space"
try; w1=cell2mat(w1); end
lin2=lin;
spac=repmat(' ',[1 2]);
for i=1:size(lin2)
    is=regexpi(lin2{i},'=','once');
      if i==1
        extens=length([lin2{i}(1:is) spac]  );%used later for multiline
      end
      lin2{i} = [lin2{i}(1:is) spac   lin{i}(w1(i):end) ];
end
lin=lin2;

%place back
tx6=tx5;
tx6(lincod)=lin;

% multi-line array
for i=lincod(1):size(tx6,1)
    if isempty(find(lincod==i))% no first-line linecode or other stuff
        dx=tx6{i};
        if strcmp(regexpi(dx,'\S','match','once'),'%') ==0 ;% FIRST SIGN ASIDE SPACE is not COMMENTSIGN  regexpi(' ;%','\S','match','once')

        dx=[repmat(' ',[1 extens+1]) regexprep(dx,'^\s+','','once')];
        tx6{i}=dx;
        end
    end
    
end

if ischar(in)
    out=strjoin(tx6,char(10));
else
    out=tx6;
end









function [ls varargout]=struct2list(x,name)

op=struct();
% if nargin>1
%     c=varargin(1:2:end);
%     f=varargin(2:2:end);
%     op = cell2struct(f,c,2); %optional Parameters
%     %optional parameter: 'ntabs'  number of tabs after ''
%     
% end


if 0
    run('proj_harms_TESTSORDNER');
    [pathx s]=antpath;
    x= catstruct(x,s);
    clear s
    x.a.b='hallo'; x.x.e=[1 2 3];
    x.haus.auto = {
        'YPL-320', 'Male',   38, true,  uint8(176);
        'GLI-532', 'Male',   43, false, uint8(163);
        'PNI-258', 'Female', 38, true,  uint8(131);
        'MIJ-579', 'Female', 40, false, uint8(133) };
    x.O= {'hello', 123;pi, 'bye'};
    x.O2= {'hello', 123;pi, 'bye'}';
    
    % x=[]
    x.d1=1:5;
    x.d1v=[1:5]';
    x.d77= logical(round(rand(3,4)*2-.5));
    x.d3=rand(2,2,3);
    x.r=([0.045673 1 1000   1.56780e22 .000000045678]);
    x.r2=[[0.045673 1 1000   1.56780e22 .000000045678] ; -[[1 1 1000   1.56780e22 10.000000045678]]];
    
    % t='x';
end

% name=inputname(1);
eval([name '=x;'  ]);
% fn= fieldnamesr(dum,'prefix');
eval(['fn= fieldnamesr(' name ',''prefix'');'  ]);
s1={};
s77=s1;

if isfield(op,'ntabs')
    ntabs=repmat('\t',1,op.ntabs);
else
    ntabs='';
end



for i=1:size(fn,1)
    eval(['d76=' fn{i} ';']);
    
    
    if isnumeric(d76) | islogical(d76)
        
        %brackes empty, []
        if size(d76,1)==0
            d77='[]';
            s77{end+1,1}= sprintf(['%s=' ntabs '[%s];'],fn{i} , '');
        end
        
        if size(d76,1)==1
%             d77=sprintf('% 10.10g ' ,d76);
            d77=regexprep(num2str(d76),'\s+','  ');
            s77{end+1,1}= sprintf(['%s=' ntabs '[%s];'],fn{i} , d77);            
        elseif size(d76,1)>1 && ndims(d76)==2
            g77={};
            for j=1:size(d76,1)
                d77=sprintf('%10.5g ' ,d76(j,:));
                g77{end+1,1}= sprintf('%s%s ','' , d77)       ;
            end
            p1=sprintf(['%s=' ntabs '%s '],fn{i} ,  '[');
            p0=repmat(' ',[1 length(p1)]);
            
            g77=cellfun(@(g77) {[ p0 g77]}   ,g77) ;%space
            g77{1,1}(1:length(p1))=p1       ;%start
            g77{end}=[g77{end} '];']       ;      ;%end
            %    uhelp(g77);set(findobj(gcf,'tag','txt'),'fontname','courier')
            s77=[s77;g77];
        elseif size(d76,1)>1 && ndims(d76)==3
            g2={};
            for k=1:size(d76,3)
                g77={};
                for j=1:size(d76,1)
                    d77=sprintf('%10.10g ' ,squeeze(d76(j,:,k)));
                    g77{end+1,1}= sprintf('%s %s','' , d77)       ;
                end
                p1=sprintf([ '%s(:,:,%d76)=' ntabs '[' ],fn{i} ,  k);
                p0=repmat(' ',[1 length(p1)]);
                
                g77=cellfun(@(g77) {[ p0 g77]}   ,g77) ;%space
                g77{1,1}(1:length(p1))=p1       ;%start
                g77{end}=[g77{end} '];']       ;      ;%end
                %    uhelp(g77);set(findobj(gcf,'tag','txt'),'fontname','courier')
                g2=[g2;g77];
            end
            s77=[s77;g2];
        end 
    elseif ischar(d76)
        g77=[ '''d76'''];
        s77{end+1,1}=sprintf(['%s=' ntabs '''%s'';'],fn{i} , d76);
    elseif iscell(d76)
        
        if isempty(d76)
            g77= sprintf(['%s=' ntabs '{%s};'],fn{i} , '') ;
        else
            
            d77= (mat2clip(d76));
            s76=sort([strfind(d77,char(10)) 0  length(d77)+1]);
            g77={};
            for j=1: length(s76)-1
                g77{end+1,1}=d77(s76(j)+1:s76(j+1)-1);
            end
            p1=sprintf(['%s=' ntabs '%s '],fn{i} ,  '{');
            p0=repmat(' ',[1 length(p1)]);
            
            g77=cellfun(@(g77) {[ p0 g77]}   ,g77) ;%space
            g77{1,1}(1:length(p1))=p1       ;%start
            g77{end}=[g77{end} '};']       ;      ;%end
            %    uhelp(g77);set(findobj(gcf,'tag','txt'),'fontname','courier')
        end
        s77=[s77;g77];
    end
end
    
% uhelp(s77,1);set(findobj(gcf,'tag','txt'),'fontname','courier')
    
    ls=s77;
    
    function out = mat2clip(a, delim)
 
    
    
    % each element is separated by tabs and each row is separated by a NEWLINE
    % character.
    sep = {'\t', '\n', ''};
    
    if nargin == 2
        if ischar(delim)
            sep{1} = delim;
        else
            error('mat2clip:CharacterDelimiter', ...
                'Only character array for delimiters');
        end
    end
    
    % try to determine the format of the numeric elements.
    switch get(0, 'Format')
        case 'short'
            fmt = {'%s', '%0.5f' , '%d'};
        case 'shortE'
            fmt = {'%s', '%0.5e' , '%d'};
        case 'shortG'
            fmt = {'%s', '%0.5g' , '%d'};
        case 'long'
            fmt = {'%s', '%0.15f', '%d'};
        case 'longE'
            fmt = {'%s', '%0.15e', '%d'};
        case 'longG'
            fmt = {'%s', '%0.15g', '%d'};
        otherwise
            fmt = {'%s', '%0.5f' , '%d'};
    end
    fmt{1}='''%s'' ';
    
    if iscell(a)  % cell array
        a = a';
        
        floattypes = cellfun(@isfloat, a);
        inttypes = cellfun(@isinteger, a);
        logicaltypes = cellfun(@islogical, a);
        strtypes = cellfun(@ischar, a);
        
        classType = zeros(size(a));
        classType(strtypes) = 1;
        classType(floattypes) = 2;
        classType(inttypes) = 3;
        classType(logicaltypes) = 3;
        if any(~classType(:))
            error('mat2clip:InvalidDataTypeInCell', ...
                ['Invalid data type in the cell array. ', ...
                'Only strings and numeric data types are allowed.']);
        end
        sepType = ones(size(a));
        sepType(end, :) = 2; sepType(end) = 3;
        tmp = [fmt(classType(:));sep(sepType(:))];
        
        b=sprintf(sprintf('%s%s', tmp{:}), a{:});
        
    elseif isfloat(a)  % floating point number
        a = a';
        
        classType = repmat(2, size(a));
        sepType = ones(size(a));
        sepType(end, :) = 2; sepType(end) = 3;
        tmp = [fmt(classType(:));sep(sepType(:))];
        
        b=sprintf(sprintf('%s%s', tmp{:}), a(:));
        
    elseif isinteger(a) || islogical(a)  % integer types and logical
        a = a';
        
        classType = repmat(3, size(a));
        sepType = ones(size(a));
        sepType(end, :) = 2; sepType(end) = 3;
        tmp = [fmt(classType(:));sep(sepType(:))];
        
        b=sprintf(sprintf('%s%s', tmp{:}), a(:));
        
    elseif ischar(a)  % character array
        % if multiple rows, convert to a single line with line breaks
        if size(a, 1) > 1
            b = cellstr(a);
            b = [sprintf('%s\n', b{1:end-1}), b{end}];
        else
            b = a;
        end
        
    else
        error('mat2clip:InvalidDataType', ...
            ['Invalid data type. ', ...
            'Only cells, strings, and numeric data types are allowed.']);
        
    end
    
    % clipboard('copy', b);
    
    out = b;
    