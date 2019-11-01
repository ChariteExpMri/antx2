function seemore(varargin)
% SEEMORE displays the content of the last statement in the history
% with clicklable links that allows users to interactively expand
% subcomponents of structured data.
%
% SEEMORE VARIABLE displays the content of the variable.
%
% This tool is usefull to anyone who works with the structured data
% types, i.e. MATLAB's struct() command. It provides an improved 
% display on the MATLAB console screen and is more clearly laid out
% than the built-in variable viewer.
%
% Example:
%   X=struct('a',struct('aa',1,'ab',2),'b',struct('ba',3,'bb',4))
%   seemore X

% determine variable to be displayed
if nargin<1
    name= 'ans';
    history= com.mathworks.mlservices.MLCommandHistoryServices.getSessionHistory;
    lastcmd= length(history);
    while lastcmd>1 && history(lastcmd).startsWith('seemore')
        lastcmd = lastcmd-1;
    end
    if lastcmd>1
        history= char(history(lastcmd));
        if ~isempty(find(history=='=',1))
            history= history(1:find(history=='=',1)-1);
        end
        if isvarname(history)
            name= history;
        end
    end
    if strcmp('ans',name) && isempty(evalin('base','who(''ans'')'))
        error('See more of what?');
    end
else
    name= varargin{1};
end

% print the header for the inspected variable
fprintf('\n');
if ischar(name)
    % simply print the name
    fprintf('%s',name);
    try
        obj= evalin('base', ['{',name,'}']);
    catch e
        error('Command can not be evaluated: %s', name);
    end
    name={name};
else
    % print the sequence of hierarchical fields
    for i=1:length(name)
        if i==1
            fprintf('%s',name{i});
            obj= {evalin('base', name{i})};
        else
            if isnumeric(name{i})
                obj= {obj{name{i}}};
                fprintf('(%d)',name{i});
            elseif strcmp(name{i},'*')
                % convert a array of structs into cells
                newobj= cell(1,prod(size(obj{1})));
                for j=1:length(newobj)
                    newobj{j}= obj{1}(j);
                end
                obj= newobj;
            else
                obj={obj{1}.(name{i})};
                fprintf('.%s',name{i});
            end
        end 
    end
    fprintf('')
end

if length(obj)==1 && isstruct(obj{1}) && length(obj{1})>1
    fprintf('= <a href="matlab:seemore(%s)"><%d elements></a>\n', ...
               cell2str({name{:},'*'}), prod(size(obj{1})));
else
    fprintf(' =\n');
end

if length(obj)>1
    % object value is a sequence
    for i=1:prod(size(obj))
        fprintf('%5d : %s\n', i, getLink({obj{i}}, i, name));
            
    end
else
    % Value is a simple
    obj= obj{1};
    if isstruct(obj)
        fields= fieldnames(obj);

        % find the indentation length
        indent= 4;
        for i=1:length(fields)
            field= fields{i};
            indent= max(4+length(field), indent);
        end

        % print all struct fields
        for i=1:length(fields)
            field= fields{i};
            value= {obj.(field)};
            fprintf('%s%s: %s\n', ...
                char(ones(1,indent-length(field))*' '), field, ...
                getLink(value, field, name));
        end
    elseif ischar(obj)
        fprintf('    %s\n', obj);
    else
        disp(obj);
    end
end
end

% generate a link with a short description
function nest= getLink(value, field, name)
    % build the output line for a struct field
    if length(value)==1
        [nest,islink] =shortform(value{1});
    else
        nest= ['<',mat2str(length(value)), ' elements>'];
        islink= true;
    end

    % present a string or a link
    if islink
        nest= sprintf('<a href="matlab:seemore(%s)">%s</a>',...
               cell2str({name{:},field}), nest);
    end
end

% generate a short form of the viewed variable
function [value,link]= shortform(value)
    link= true;
    if ischar(value)
        link= length(value)>80;
    elseif isnumeric(value)
        if sum(size(value))<10
            value= mat2str(value);
            link= false;
        end
    elseif islogical(value) && length(value)==1
        if value
            value='true';
        else
            value='false';
        end
        link= false;
    end
    if link
        % object can be expanded on click
        post='';
        if isstruct(value)
            post=[' with ',mat2str(length(fieldnames(value))),' fields'];
        end

        % format dimensions (e.g. 10x10)
        dim= size(value);
        link= prod(dim)>0;
        dimstr= '';
        for i=1:length(dim);
            if i>1
                dimstr= strcat(dimstr,'x');
            end
            dimstr= [dimstr, mat2str(dim(i))];
        end
    
        % format final
        type= class(value);
        value= ['[',dimstr,' ',type,post,']'];
    end
end

% format a cell into a Matlab source string
function str= cell2str(value)
    str='{';
    for i=1:length(value)
        if i>1
            str= strcat(str,',');
        end
        str= strcat(str, mat2str(value{i}));
    end
    str= strcat(str,'}');
end
        
