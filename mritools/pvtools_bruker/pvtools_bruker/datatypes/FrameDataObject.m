classdef FrameDataObject < BrukerDataSuperclass
% FrameDataOobject
% this class can create and store framedata and store paremeterstructs
% 
% [...] means: this is an optional argument
%
%
% Constructor:
% 3 versions to crate an object:
% 1.) generate an empty object: obj = FrameDataObject(); 
% 2.) To create data from a RawDataObject, use the 'import'-Mode:
%       frameObj = FrameDataObject(rawDataObject, ['dataPrecision', yourPrecisionString], [specified_NRs', yourNRArray], ['noCalc']);
%       -> Requires: rawDataObject
%       -> Does: import rawDataObject & convert the fid-Matrix to an frameMatrix
% 3.) To create an object without RawDataObject, use the 'shortcut'-mode: 
%       frameObj=FrameDataObject('path_to_your_PVdata', ['dataPrecision', yourPrecisionString]);
%       -> Requires: standard ParaVision directorystructure
%       -> Does: creates directly an frameDataObject
%
% Parameters
%
%    Required
%      rawDataObject - (2.)
%           Type: rawDataObject, it's an object of the class RawDataObject
%      'path_to_PV_data_directory' - (3.)
%           Type: string, the path to your Paravision data directory with the fid and acqp file e.g. '../Testfiles/10'
%
%    Optional
%      ['dataPrecision', yourPrecisionString] - (2.) & (3.)
%         Type: defined string followed by 'single' or 'double', default is 'double'
%         You can change the precision of the data to single if your memory is not enough for double calculations.
%         e.g. obj = FrameDataObject('../Testfiles/10', 'dataPrecision', 'single' );
%      ['specified_NRs', your_NR_array] - (2.) & (3.) 
%          Type: defined string followed by an array, default is [] (= read all NRs)
%          You only need to insert it, IF you read your fidFile with specified_NRs AND the rawDataClass didn't stored your specified_NRs in the .Acqp-struct
%          Keep in mind, the first NR loop starts with an 1
%          e.g. obj = FrameDataObject('../Testfiles/10', 'specified_NRs', [1 5 7] );
%      ['specified_Job', the_choosenJob] - (2.) & (3.) 
%          Type: defined string followed by integer-value, default is 1 (= read the first job in the cellstruct)
%          Why use: ParaVision 6 supports an new kind for acquirering data, therefor it uses jobs. Normally you work with the fid-file, 
%          this is stored (if it exist) in rawDataObject.data{1} (=default), but sometimes it can be necessary to choose another datamatrix
%          e.g. obj = FrameDataObject('../Testfiles/10', 'specified_Job', 2 );
%       ['noCalc'] - (2.)
%           Type: defined string, 
%           You can use this string to exclude the calculation-process for frameData, you can run it later or create the data yourself.
%           e.g. obj = FrameDataObject(rawObj, 'noCalc'); will only import Filespath, HeaderInformation, Acqp and Method from the rawDataObject
%
%
% See also RawDataObject, CKDataObject, ImageDataObject, readBrukerParamFile,
% readBrukerRaw, convertRawToFrame, convertFrameToCKData,
% readBruker2dseq

%================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2012
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: FrameDataObject.m,v 1.1 2012/09/11 14:22:10 pfre Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Variables
% for more variables please see BrukerDataClass
properties (SetAccess = public) 
    data; % Matrix with dimensions (Scansize, NumberOfScansPerFrame, NumberOfChannels, NumberOfObjects, NumberOfRepetitions)
end   

methods
    %% Constructor
    % Description in classdescription
    function obj=FrameDataObject(varargin)
        % Usage and arguments see above

        % create empty object
        if isempty(varargin) % -> only create empty object           
            %nothing happens !

        % import object from prev.Class and execute all calculations
        elseif isa(varargin{1}, 'RawDataObject')
            obj=frameDataImport(obj, varargin);

        % 'shortcut':
        elseif ischar(varargin{1})
            obj=frameDataShortcut(obj, varargin);

        % Error:    
        else
            error('Your arguments are not correct ! ');
        end  
    end

    %% Methods

    function obj=calcFrameData(obj, rawMatrix, varargin)
        %Calculates the data: frameObj=frameObj.calcFrameData(rawMatrix, ['specified_NRs', your_NR_array])

        if ~isnumeric(rawMatrix)
            error('rawData has to be an matrix');
        end
        if sum(strcmpi(varargin, 'specified_NRs'))==1 % specified_NRs comes with input arguments?
            pos=find(strcmpi(varargin, 'specified_NRs')==1);
           if isnumeric(varargin{pos+1})
                specified_NRs=varargin{pos+1};
           else
               error('Input specified_NRs is not correct!');
           end
           clear pos;
        elseif isfield(obj.Acqp, 'specified_NRs') % specified_NRs are written to .Acqp by RawDataObject?
            specified_NRs=obj.Acqp.specified_NRs;
        else % No definition of NRs found, set to: use all = []
            specified_NRs=[];
        end
        obj.data = convertRawToFrame( rawMatrix, obj.Acqp, 'specified_NRs', specified_NRs);           
    end

    function obj=importRawDataObject(obj, rdo) % RDO=RawDataObject
        % integrate headerInformation, Acqp, Method, Visu, Reco and Filespath of a RawDataObject into this instance
        obj=import_parameters_filespath(obj, rdo); % see superclass: BrukerDataClass
    end
    
    function obj=load(obj, load_struct)
        % loading an Object from a struct, saved with struct(obj);
        obj=obj.load_superclass(load_struct);
        obj.data=load_struct.data;
    end


end

methods (Access = protected)
    %% Import Constructorfunction
    function obj=frameDataImport(obj, input)
        % Part of the constructor, implements the (2.) mode.

        % Init: dataPrecision, 'no change'=do not change precision
        % [Output_args, out ] = bruker_addParamValue( Input_args, name, allowed_string, default) 
        [input, dataPrecision] =bruker_addParamValue(input, 'dataPrecision', '@(x) strcmp(x, ''single'') || strcmp(x, ''double'')', 'no change');
        [input, specified_NRs] =bruker_addParamValue(input, 'specified_NRs', '@(x) isnumeric(x)', -1 );
        [input, specified_Job] =bruker_addParamValue(input, 'specified_Job', '@(x) isnumeric(x) && (length(x)==1) ', 1 );

        % Init: calculateFrameData?
        calculate=true;
        if sum(strcmpi(input, 'noCalc'))==1
            pos=find(strcmpi(input, 'noCalc')==1);
            calculate=false;
            input(pos)=[];
            clear pos;
        end


        % import RawDataObject & calcFrameData & change precision if necessary
        obj=importRawDataObject(obj, input{1});

        % Error check
        if (isfield(obj.Acqp, 'ACQ_jobs')) && (~(obj.Acqp.ACQ_jobs(1,1)==0))
            error('Your data only contains jobs, jobs are not supported by this object !');
        end

        % read precision
        testvalue=input{1}.data{specified_Job}(1,1,1);
        rawprec=whos('testvalue');
        clear testvalue;
        rawprec=rawprec.class;
        % memory saving: if change double -> single do it now, if single -> double
        % do it after calcFrameData
        if strcmpi(dataPrecision, 'single') && strcmpi(rawprec, 'double')
            input{1}.data{specified_Job}=single(input{1}.data{specified_Job});
        end

        % calc frameData, prefered as single data
        if calculate
            if specified_NRs==-1
                obj=obj.calcFrameData(input{1}.data{1});
            else
                obj=obj.calcFrameData(input{1}.data{1}, 'specified_NRs', specified_NRs);
            end
        end
        input{1}=[]; % Delete struct in input for saving memory

        % if change single -> double:
        if strcmpi(dataPrecision, 'double') && strcmpi(rawprec, 'single')
            obj=obj.setPrecision('double');
        end

    end

    %% Shortcut Constructorfunction
    function obj=frameDataShortcut(obj, input)
        % Part of the constructor, implements the (3.) mode.

        % Init: dataPrecision
        [input, dataPrecision] =bruker_addParamValue(input, 'dataPrecision', '@(x) strcmp(x, ''single'') || strcmp(x, ''double'')', 'double');

        rawObj=RawDataObject(input{1}, 'dataPrecision', 'single'); %generate RawDataObject
        obj=importRawDataObject(obj, rawObj); % import in FrameDataObject
        if (isfield(obj.Acqp, 'ACQ_jobs')) && (~(obj.Acqp.ACQ_jobs(1,1)==0)) % Error check
            error('Your data only contains jobs, jobs are not supported by this object !');
        end
        obj=obj.calcFrameData(rawObj.data{1}); % calc data
        clear('rawObj');
        if strcmpi(dataPrecision, 'double') % 'double' is default
            obj=obj.setPrecision('double'); % convert to double (shortcut)
        end      
    end

end


end