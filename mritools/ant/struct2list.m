
%% convert struct to (executable) cell list (inDepth)
%% function ls=struct2list(x)
% -works with char, 1-2-3D numeric array, mixed cells
%% example
% w.project=	  'TEST'	  ;                                               
% w.voxsize=	  [0.07  0.07  0.07]  ;                                    
% w.datpath=	  'O:\harms1\harmsTest_ANT\dat'	  ;                        
% w.brukerpath=	  'O:\harms1\harmsTest_ANT\pvraw'	  ;                   
% w.refpa=	  'V:\mritools\ant\templateBerlin_hres'	  ;                  
% w.refTPM =  { 'V:\mritools\ant\templateBerlin_hres\_b1grey.nii'       
%               'V:\mritools\ant\templateBerlin_hres\_b2white.nii'      
%               'V:\mritools\ant\templateBerlin_hres\_b3csf.nii' };     
% w.refsample=	  'V:\mritools\ant\templateBerlin_hres\_sample.nii'	  ;  
% w.a.b=	  'hallo'	  ;                                                  
% w.x.e=	  [1  2  3]  ;                                                 
% w.haus.auto =  { 'YPL-320' 	'Male' 	38.00000	1.00000	176.00000        
%                  'GLI-532' 	'Male' 	43.00000	0.00000	163.00000        
%                  'PNI-258' 	'Female' 	38.00000	1.00000	131.00000      
%                  'MIJ-579' 	'Female' 	40.00000	0.00000	133.00000};    
% w.O =  { 'hello' 	123.00000                                           
%          3.14159	'bye' };                                             
% w.O2 =  { 'hello' 	3.14159                                            
%           123.00000	'bye' };                                          
% w.d1=	  [1  2  3  4  5]  ;                                            
% w.d1v =  [          1                                                 
%                     2                                                 
%                     3                                                 
%                     4                                                 
%                     5  ];                                             
% w.d2 =  [          1          0          1          1                 
%                    0          1          1          1                 
%                    1          1          1          1  ];             
% w.d3(:,:,1) = [ 0.5800903658 0.1208595711                             
%                 0.01698293834 0.8627107187 ];                         
% w.d3(:,:,2) = [ 0.4842965112 0.209405084                              
%                 0.8448556746 0.5522913415 ];                          
% w.d3(:,:,3) = [ 0.6298833851 0.6147134191                             
%                 0.03199101576 0.3624114623 ];                         
% w.r=	  [0.045673  1  1000  1.5678e+022  4.5678e-008]  ;               
% w.r2 =  [   0.045673          1       1000 1.5678e+022 4.5678e-008    
%                   -1         -1      -1000 -1.5678e+022        -10  ];
% ls=struct2list(w)

function [ls varargout]=struct2list(x,varargin)

op=struct();
if nargin>1
    c=varargin(1:2:end);
    f=varargin(2:2:end);
    op = cell2struct(f,c,2); %optional Parameters
    %optional parameter: 'ntabs'  number of tabs after ''
    
end


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
    x.d2= logical(round(rand(3,4)*2-.5));
    x.d3=rand(2,2,3);
    x.r=([0.045673 1 1000   1.56780e22 .000000045678]);
    x.r2=[[0.045673 1 1000   1.56780e22 .000000045678] ; -[[1 1 1000   1.56780e22 10.000000045678]]];
    
    % t='x';
end

name=inputname(1);
eval([name '=x;'  ]);
% fn= fieldnamesr(dum,'prefix');
eval(['fn= fieldnamesr(' name ',''prefix'');'  ]);
s1={};
s2=s1;

if isfield(op,'ntabs')
    ntabs=repmat('\t',1,op.ntabs);
else
    ntabs='';
end



for i=1:size(fn,1)
    eval(['d=' fn{i} ';']);
    
    
    if isnumeric(d) | islogical(d)
        
        %brackes empty, []
        if size(d,1)==0
            d2='[]';
            s2{end+1,1}= sprintf(['%s=' ntabs '[%s];'],fn{i} , '');
        end
        
        if size(d,1)==1
%             d2=sprintf('% 10.10g ' ,d);
            d2=regexprep(num2str(d),'\s+','  ');
            s2{end+1,1}= sprintf(['%s=' ntabs '[%s];'],fn{i} , d2);            
        elseif size(d,1)>1 && ndims(d)==2
            g={};
            for j=1:size(d,1)
                d2=sprintf('%10.5g ' ,d(j,:));
                g{end+1,1}= sprintf('%s%s ','' , d2)       ;
            end
            p1=sprintf(['%s=' ntabs '%s '],fn{i} ,  '[');
            p0=repmat(' ',[1 length(p1)]);
            
            g=cellfun(@(g) {[ p0 g]}   ,g) ;%space
            g{1,1}(1:length(p1))=p1       ;%start
            g{end}=[g{end} '];']       ;      ;%end
            %    uhelp(g);set(findobj(gcf,'tag','txt'),'fontname','courier')
            s2=[s2;g];
        elseif size(d,1)>1 && ndims(d)==3
            g2={};
            for k=1:size(d,3)
                g={};
                for j=1:size(d,1)
                    d2=sprintf('%10.10g ' ,squeeze(d(j,:,k)));
                    g{end+1,1}= sprintf('%s %s','' , d2)       ;
                end
                p1=sprintf([ '%s(:,:,%d)=' ntabs '[' ],fn{i} ,  k);
                p0=repmat(' ',[1 length(p1)]);
                
                g=cellfun(@(g) {[ p0 g]}   ,g) ;%space
                g{1,1}(1:length(p1))=p1       ;%start
                g{end}=[g{end} '];']       ;      ;%end
                %    uhelp(g);set(findobj(gcf,'tag','txt'),'fontname','courier')
                g2=[g2;g];
            end
            s2=[s2;g2];
        end 
    elseif ischar(d)
        g=[ '''d'''];
        s2{end+1,1}=sprintf(['%s=' ntabs '''%s'';'],fn{i} , d);
    elseif iscell(d)
        
        if isempty(d)
            g= sprintf(['%s=' ntabs '{%s};'],fn{i} , '') ;
        else
            
            d2= (mat2clip(d));
            s=sort([strfind(d2,char(10)) 0  length(d2)+1]);
            g={};
            for j=1: length(s)-1
                g{end+1,1}=d2(s(j)+1:s(j+1)-1);
            end
            p1=sprintf(['%s=' ntabs '%s '],fn{i} ,  '{');
            p0=repmat(' ',[1 length(p1)]);
            
            g=cellfun(@(g) {[ p0 g]}   ,g) ;%space
            g{1,1}(1:length(p1))=p1       ;%start
            g{end}=[g{end} '};']       ;      ;%end
            %    uhelp(g);set(findobj(gcf,'tag','txt'),'fontname','courier')
        end
        s2=[s2;g];
    end
end
    
% uhelp(s2,1);set(findobj(gcf,'tag','txt'),'fontname','courier')
    
    ls=s2;
    
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
    
 
    
    