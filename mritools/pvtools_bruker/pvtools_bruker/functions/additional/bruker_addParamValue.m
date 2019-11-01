function [Output_args, out ] = bruker_addParamValue( Input_args, name, allowed_string, default)
% [Output_args, out ] = bruker_addParamValue( Input_args, name, allowed_string, default)
% This is a function for an input-parser, it's meant to parse arguments like << 'yourParametername', yourParameter >> 
% Does: 
% -> search within a varagin-argument a defined string (the string in name)
% -> reads the value after the found string
% -> checks if the value fits to the allowed_string
% -> if ok -> set Variable to output and delete the 2 parts in the varagin-argument and give it back
% if ParameterName doesn't exist give default-Value back
%
% Example: [varargin, myValue ] = bruker_addParamValue( varargin, 'MyParameterName', '@(x) ischar(x) || isnumeric(x)', '[ 1 2 3]')
% with an varargin={variable1, 'thisisasting, 'MyParameterName', [ 0 5 8; 4 9 2], 'anotherstring', 5, 7}
% output: 
%   Output_args={variable1, 'thisisasting, 'anotherstring', 5, 7}
%   out = [ 0 5 8; 4 9 2]
% Important is @ with ( ) because of text-detection 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2012
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: bruker_addParamValue.m,v 1.1 2012/09/11 14:22:10 pfre Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %% Input_args contains the searched argument?
    if sum(strcmpi(Input_args, name))==1 
        
        pos=find(strcmpi(Input_args, name)==1); %postion with name of argument
        
        %% Check if value is allowewd
        % if allowed -> mytestbool=true
        [identifier, command]=strtok(allowed_string, ')'); % -> ['@(x' , ') (ischar(x))'] 
        [trash,identifier]=strtok(identifier, '('); % -> '(x'
        clear trash;
        identifier=identifier(2:end); % -> x
        command=command(2:end);
        try
            eval([identifier, '=Input_args{pos+1};']); % -> x=Input_args(pos+1);
            eval(['mytestbool=', command, ';']); % -> mytestbool=(ischar(x));
        catch
            error(['Your argument-description of ', name, ' is not correct!']);
        end
        
        %% if allowed: save variable, else: error
        if mytestbool
            out=Input_args{pos+1};
            % Remove fields:
            Input_args(pos+1)=[];
            Input_args(pos)=[];
        else
            error(['Input ', name, ' is not correct!']);
        end
        clear pos;
        
    %% Input_args doesn't contains the searched argument !! -> default values?    
    else 
        if (~(isempty(default))) || isnumeric(default) %=default defined?
            out=default;
        end
    end
    
    Output_args=Input_args;

end

