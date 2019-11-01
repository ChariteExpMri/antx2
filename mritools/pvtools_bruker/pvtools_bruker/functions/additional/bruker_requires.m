function all_here = bruker_requires(cellstruct, varargin)
% all_here = bruker_requires(cellstruct, varargin)
% Fast check if some structs contain some variables. 
%
% all_here = boolean
% cellstruct: cellarray with multiple structs: cellstruct={genericAcqp, genericMethod}
% varargin: itself cellarray the elements are called Varibleblock.  Everey
% Variableblock is again a cellarray with strings.
%   These strings are the names of the search variables.
%   The first position of every Variableblock should be the name of the
%   file or struct, which is displayed when a variablecheck is failing
%   eg.: varargin={'genericAcqp''ACQ_size', 'ACQ_dim'}, {'genericMethod', 'PVM_coil', 'PVM_dsecnd'}
%
% Attention: every arrayPosition in varargin corresponds with the position in varargin
%   eg.: cellstruct={Acqp, Method} then varargin{1} has to be
%   the Variablenames of Acqp
%
% Expample: 
%   cellstruct{1}=Acqp;
%   cellstruct{2}=Method;
%   all_here = bruker_requires(cellstruct, {'Acqp','NI','NR','ACQ_size', 'ACQ_dim'}, {'Method', 'PVM_Matrix', 'PVM_EncSteps1'});
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2012
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: bruker_requires.m,v 1.1 2012/09/11 14:22:10 pfre Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


all_here=true;
for i1=1:length(cellstruct)
    stringlist=varargin{i1}; %list with names to be checked !
    %check if struct is empty:
    if isempty(cellstruct{i1})
        warning('MATLAB:bruker_warning', ['The struct ', stringlist{1}, ' is completely empty !'])
    else % struct is not empty proceed with checking variables
        for i2=2:length(varargin{i1})
            varname=stringlist{i2};
            if ~isfield(cellstruct{i1}, varname);
                warning('MATLAB:bruker_warning', ['In struct ', stringlist{1}, ' is the variable ', varname, ' missing!']);
                all_here=false;
            end
        end
    end
end

end