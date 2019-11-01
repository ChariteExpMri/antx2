classdef CKDataObject < BrukerDataSuperclass
% CKDATAOBJECT = Cartesian-Kspace-Data-Object
% this class can 
% - create and store kSpace-data 
% - store paremeterstructs
% - use the preview-function to view images
% 
% [...] means: this is an optional argument
%
% 3 versions to create an object:
% 1.) generate an empty object: obj = CKDataObject();
% 2.) use 'import'-mode to create all data from an frameDataObject: 
%       obj = CKDataObject(frameDataObject, ['dataPrecision', yourPrecisionString], ['useMethod', logical], ['noCalc']);
%       -> Requires: path to methodFile & frameDataObject.
%       -> Does: import frameDataObject & if neccessary -> reads method-file & calculates kspace (only if 'noCalc' is not set)
% 3.) use the 'shortcut'-mode to read the frameDataObject directly without frameDataObject: 
%       obj=CKDataObject('path_to_your_PVdata', ['dataPrecision', yourPrecisionString], ['useMethod', logical]);
%       -> Requires: Requires: standard PV-directory-structure
%       -> Does: creates directly an CKDataObject & if neccessary -> reads method-file
%
% Parameters
%
%    Required
%       frameDataObject - (2.) 
%           Type: FrameDataObject, it's an object of the class FrameDataObject
%       'path_to_PV_data_directory' - (3.)
%           Type: string, the path to your Paravision data directory with the fid and acqp file e.g. '../Testfiles/10'
%
%    Optional
%       ['dataPrecision', yourPrecisionString] - (2) & (3) 
%           Type: defined string followed by 'single' or 'double', default is 'double'.
%           e.g. ckObj = CKDataObject(frameObj, 'dataPrecision', 'single' );
%       ['useMethod', logical ] - (2.) & (3.)
%               Type: defined string followed by true or false
%               Defines if the calculation-process uses the method-parameters
%               If you don't use the argument the object tries to create an auto-value based on the existence 
%               of PVM_Matrix and PVM_EncSteps in Method
%       ['specified_NRs', your_NR_array] - (2.) 
%               Type: defined string followed by an array 
%               You only need to insert it, IF you readed your fidFile with specified_NRs AND the rawDataClass didn't 
%               stored your specified_NRs in the .Acqp-struct
%               e.g. obj = CKDataObject(rawObj, 'specified_NRs', [1 5 7] );
%       ['noCalc'] - (2.)
%               Type: defined string 
%               You can use this string to exclude the calculation-process for kspaceData, you can run it later or create
%               the data yourself
%               e.g. obj = CKDataObject(frameObj, 'noCalc'); will only import Filespath, HeaderInformation, 
%               Acqp and Method from the frameDataObject
%
% See also RawDataObject, FrameDataObject, ImageDataObject, readBrukerParamFile,
% readBrukerRaw, convertRawToFrame, convertFrameToCKData,
% readBruker2dseq

%================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2013
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: CKDataObject.m,v 1.2 2013/05/24 13:29:27 haas Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Variables
% for more variables please see BrukerDataClass
properties (SetAccess = public) 
    data; %Matrix with dimensions (Dim1, Dim2, Dim3, Dim4, NumberOfChannels, NumberOfObjects, NumberOfRepetitions)     
end

properties (SetAccess = private)          
    useMethod=true; % Boolean, defines if the method-parameters are used in the calculation-process
end


methods

    %% Constructor
    function obj=CKDataObject(varargin)
        % Usage and arguments see above

        if isempty(varargin) % -> only create empty object           
            %nothing happens !

        % import object from prev.Class and execute all calculations
        elseif isa(varargin{1}, 'FrameDataObject')
            obj=obj.cKDataImport(varargin);

        % 'shortcut'    
        elseif ischar(varargin{1})
            obj=obj.cKDataShortcut(varargin);  

        % Error    
        else
            error('Your arguments are not correct ! ');

        end % end: varargin is not empty
    end


    %% Methods
    function obj=calcKData(obj, frameMatrix, varargin)
        % Calculates cartesian kSpace-matrix: ckObj=obj.calcKData( frameMatrix, ['specified_NRs', your_NR_array])
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
        obj.data = convertFrameToCKData( frameMatrix, obj.Acqp,  obj.Method, 'specified_NRs', specified_NRs, 'useMethod', obj.useMethod);         
    end        

    function obj=importFrameDataObject(obj, fdo) % fdo=FrameDataObject
       % integrate headerInformation, Acqp, Method, Visu, Reco and Filespath of a FrameDataObject into this instance
       obj=import_parameters_filespath(obj, fdo); % see superclass: BrukerDataClass
    end

    function obj=setUseMethod(obj, useMethod)
        % with this method you can set the useMethod-parameter manually: ckObj=ckObj.setUseMethod(true) or ckObj=ckObj.setUseMethod(false) or you can try to auto generate the value with ckObj=ckObj.setUseMethod('auto')
        if islogical(useMethod)
            obj.useMethod=useMethod;
        elseif strcmpi(useMethod, 'auto')
            if isfield(obj.Method, 'PVM_Matrix') && isfield(obj.Method, 'PVM_EncSteps1')  % errorcheck
                obj.useMethod=true;
            else
                obj.useMethod=false;
            end
        end
    end
    
    function out_obj=reco(obj, recopart, varargin)
        % Performs a reconstruction: if specified with 'image' the outobj will be ab ImagDataObject otherweise it will stay an CKDataObject outobj = obj.reco( recopart, ['image'], ['RECO_Parametername', ParameterValues], ['RECO_Parametername2', ParameterValues2], ... )
        % This function performs the steps of a reco based on the Bruker reco-Parameters.
        % Normally you insert to this function the Reco-Parameter-struct and overwrite some variables with additional arguments.
        %
        % E.g. kdataObj = kdataObj.reco( 'all' ,'RECO_ft_size', [512; 512],  'RECO_size', [128; 128], 'RECO_offset', [192 192; 192 192]);
        %   OR imageObj = kdataObj.reco( 'all' , 'image', 'RECO_ft_size', [512; 512],  'RECO_size', [128; 128], 'RECO_offset', [192 192; 192 192]);
        % The additonal arguments will overwrite the Reco-Parameters.
        %
        % IN:
        %   recopart: There are some recosteps, you can choose the steps with the recopart-variable:
        %           recopart can be a string or an cellarray with multiple strings.
        %           Your Options:
        %           'quadrature': uses RECO_qopts to set the phase korrekt to use the FT
        %                         required Parameters: RECO_qopts
        %           'phase_rotate': in some cases it's necessarry to shift the image. This option adds a pahse-offset to the frequency-data to do this,
        %                           therefore it uses the RECO_rotate variable. This method is recommended, because it also support subpixel-shift.
        %                         required Parameters: RECO_rotate
        %           'zero_filling': Makes first zero-filling and after that it allowes to cut a part of the image.
        %                         required Parameters: RECO_ft_size, RECO_size, RECO_offset and signal_position
        %           'FT': The Fourier-Transformation
        %                         required Parameters: RECO_ft_mode
        %           'image_rotate': in some cases it's necessarry to shift the image. This option shifts the image data to do this,
        %                           therefore it uses the RECO_rotate variable.
        %                         required Parameters: RECO_rotate
        %           'sumOfSquares': makes a sum of squares out of the receiver-channels.
        %                         required Parameters: no
        %           'transposition': generates the transposition.
        %                         required Parameters: RECO_transposition
        %           'all' : it's the same like recopart={'quadrature', 'phase_rotate', 'zero_filling', 'FT', 'sumOfSquares', 'transposition'};
        %                         required Parameters: all listed above
        %
        %   varargin: You can add the Reco-parametername as string, followed by the value you want to set. Take a look at the example above.
        %
        % OUT:
        %   object: if 'image' specified in the arguments: it will be an ImageDataObject else it will be an CKDataObject
        %
        %
        %   Parameters:
        %   ------------
        %       
        %    RECO_qopts - cellarray with string. This parameter determines the quadrature options that will be applied to the data in each dimension.
        %        The possible allowed values are:
        %        •  NO_QOPTS - meaning is obvious.
        %        •  COMPLEX_CONJUGATE - is the normal complex conjugate in which the imaginary component of each complex number is negated.
        %                             - implies that every second complex point will be QUAD_NEGATION negated.
        %        •  CONJ_AND_QNEG - combines both of the preceding two options. This will have the effect of alternately negating the real and imaginary
        %                           component of the complex data points.
        %        The default quadrature options are:
        %        RECO_qopts{1} = 'QUAD_NEGATION' if AQ_mod = 'qseq',
        %        RECO_qopts{1} = 'CONJ_AND_QNEG' if AQ_mod = 'qsim',
        %        RECO_qopts{1}) = 'NO_QOPTS' otherwise.
        %        i > 1 -> RECO_qopts{i} = 'NO_QOPTS'.
        %
        %     RECO_rotate - double array This parameter specifies a ‘roll’ of the data row which is carried out after the Fourier transformation 
        %         and before the reduction implied by the RECO_size and RECO_offset parameters. This will shift all points
        %         in the data row towards the end of the row. Those points that ‘fall off’ the end will be reinserted at the start. This parameter must
        %         satisfy the relationship 0 ≤ RECO_rotate(i) < 1.
        %         If the user enters a value for this parameter which is greater than 1 and less than RECO_ft_size(i), the value for the parameter
        %         will be corrected by dividing the input by RECO_ft_size(i).
        %
        %     RECO_ft_size - int array. This array contains the sizes of the complex data matrix in each direction after the FT but before it is output. 
        %         The following two conditions must be satisfied:
        %         if i = 1 -> RECO_ft_size(i) ≥ ACQ_size(i)/2 
        %         otherwise -> RECO_ft_size(i) ≥ ACQ_size(i)  and RECO_ft_size(i) = 2^n .
        %         If FT processing is being done in the i-th dimension and if RECO_ft_size(i) ≠ ACQ_size(i)/2 if i = 0, RECO_ft_size(i) ≥ ACQ_size(i) otherwise, 
        %         then zero-filling will be performed to expand the input dataset to the specified size.
        %
        %     signal_position - column-vektor with NumberOfDimensions elements (maximum: 4) between 0 and 1. It defines the position of your data between the zeros. 
        %          0 means it's at the start of the line, and 1 means the data is at the end of the line. Default is a symmetric, means only values of 0.5
        %
        %     RECO_size - int array. This array contains the sizes of the data matrix in each direction after output from the reconstruction. 
        %         This parameter will specify the resolution of the image matrix in the reconstructed images. 
        %         The following conditions must be satisfied:
        %         RECO_ft_size(i) ≥ RECO_size(i) > 0.
        %         Reducing the output size will also significantly reduce the required reconstruction time. Reducing the output size in the first 
        %         direction will reduce the memory requirements for the reconstruction.
        %
        %     RECO_offset - int array. When RECO_ft_sizei ≠ RECO_sizei the parameter RECO_sizei determines the length of the output data row. 
        %         The parameter RECO_offset(i,j) gives the starting point of the output for all rows in the i-th direction for the jth image. 
        %         This must be a two dimensional array since the desired offsets can change from one image to the next. The frequency offsets in a
        %         standard multi-slice experiment are a typical example. The following conditions must be satisfied:
        %         RECO_ft_size(i) > RECO_offset(i,j) ≥ 0 and
        %         RECO_ft_size(i) ≥ RECO_offset(i,j) + RECO_size(i)
        %
        %     RECO_ft_mode - defined string. This parameter determines the type of FT to be performed in each direction.
        %         The allowed values for this parameter are:
        %         •  NO_FT - meaning is obvious.
        %         •  COMPLEX_FT - means that the input data is treated as complex. The results
        %            will be complex.
        %         •  COMPLEX_IFT - means that the input data is treated as complex and an inverse Fourier transformation is performed.
        %         The default value for the FT mode is: RECO_ft_mode{i} = 'COMPLEX_FT', if i > 0 or AQ_mod = 'qsim'.
        %
        %     RECO_transposition - array. This parameter can be used to transpose the final image matrix for each object during the reconstruction. 
        %         The following conditions must be satisfied:
        %         0 ≤ RECO_transposition(i) ≤ ACQ_dim, 0 ≤ i ≤ NI.
        %         A value of 0 (zero) implies that no transposition is desired. A value of 1 implies transposition of the first and 
        %         second (read and phase) directions. A value of 2 implies transposition of the second and third (phase and slice) directions. 
        %         A value of ACQ_dim implies transposition of the first and last directions. 
        %         This parameter is ignored for all setup pipelines (e.g. GSP, GS Auto etc.). It will be forced to the value 0 (zero) if ACQ_dim = 1.
        %         Please note that the value of this parameter does not affect the interpretation of other reconstruction parameters. 
        %         For example, the entries in the output parameter RECO_fov are not reordered to reflect the transposition. 
        %         Also, the values of all other RECO parameters (RECO_ft_size, RECO_size, etc.) refer to the non-transposed data ordering. 
        %         When the image processing parameters (the D3 class) are written to disk at the end of the reconstruction they are filled in
        %         so as to describe the transposed image matrix.

        
        input=varargin;
        if isempty(fieldnames(obj.Reco))
            try
                obj=obj.readReco;
            catch
                warning('MATLAB:bruker_note', 'It''s recommended to read the reco-file first.');
            end
        end
        
        % Init: image?
        image=false;
        if sum(strcmpi(input, 'image'))==1
            pos=find(strcmpi(input, 'image')==1);
            image=true;
            input(pos)=[];
            clear pos;
        end
              
       if image
           out_obj=ImageDataObject(obj);
           out_obj.data=bruker_Reco(recopart, obj.data, obj.Reco, input{:});
       else
           out_obj=obj;
           out_obj.data=bruker_Reco(recopart, obj.data, obj.Reco, input{:});
       end
    end

    function viewer(obj, varargin)
       % opens the brViewer with the cartesian k-space-data, obj.viewer([figuretitle', 'yourFigurName'], ['imscale', imscale ], ['res_factor', res_factor])
       % imscale           : scale image using imagesc(), e.g. imscale=double(threshold_min, threshold_max)
       %
       % res_factor        : scalar, multiplication-factor on the imageresolution for saving as tiff 
       %                     e.g. res_factor=2 and image (256x128) -> saved tiff has (512x256) pixel. Advantage: rendering with opengl
       %                     default value is set to 2

       [varargin, figuretitle] =bruker_addParamValue(varargin, 'figuretitle', '@(x) ischar(x)', obj.Acqp.ACQ_method);    
       brViewer(obj.data, 'figuretitle', figuretitle, varargin{:});          
    end

    function obj=load(obj, load_struct)
        % loading an Object from a struct, saved with struct(obj);
        obj=obj.load_superclass(load_struct);
        obj.data=load_struct.data;
        obj.useMethod=load_struct.useMethod;
    end
end

methods (Access=protected)
    %% Import-Constructorfunction
    function obj=cKDataImport(obj, input)
        % Part of the constructor, implements the (2.) mode.

        % Init:
        if sum(strcmpi(input, 'useMethod'))==1
            useMethodManualSet=true; % will be used later to check if we choose the parameter appending the ACQ_method
        else % if the parameter is not set manually try choosing it autmatically
            useMethodManualSet=false; % will be used later to check if we choose the parameter appending the ACQ_method                  
        end
        % [Output_args, out ] = bruker_addParamValue( Input_args, name, allowed_string, default) 
        [input, dataPrecision] =bruker_addParamValue(input, 'dataPrecision', '@(x) strcmp(x, ''single'') || strcmp(x, ''double'')', 'no change');
        [input, obj.useMethod] =bruker_addParamValue(input, 'useMethod', '@(x) islogical(x)', true);
        [input, specified_NRs] =bruker_addParamValue(input, 'specified_NRs', '@(x) isnumeric(x)', [-1] );


        % Init: calculateKspaceData?
        calculate=true;
        if sum(strcmpi(input, 'noCalc'))==1
            pos=find(strcmpi(input, 'noCalc')==1);
            calculate=false;
            input(pos)=[];
            clear pos;
        end

        obj=importFrameDataObject(obj, input{1});

        % if useMethod not specified: try using auto-settings: 
        if ~useMethodManualSet
           obj=setUseMethod(obj, 'auto');
        end

        % read method file:
        if obj.useMethod && (~isempty(obj.Filespath.path_to_method))
            names=fieldnames(obj.Method);
            if isempty(names) % read if method-struct is empty
                obj.Method=readBrukerParamFile(obj.Filespath.path_to_method);
            end
            clear names;
        elseif obj.useMethod
           error('Can''t find method-path in .Filespath'); 
        end % end read MEthod

        % read precision & change if neccessary:
        testvalue=input{1}.data(1,1,1);
        rawprec=whos('testvalue');
        clear testvalue;
        rawprec=rawprec.class;
        if strcmpi(dataPrecision, 'single') && strcmpi(rawprec, 'double')
            input{1}.data=single(input{1}.data);
        elseif strcmpi(dataPrecision, 'double') && strcmpi(rawprec, 'single')
            input{1}.data=double(input{1}.data);
        end

        if calculate
            if specified_NRs==[-1]
                obj=obj.calcKData(input{1}.data, 'useMethod', obj.useMethod);
            else
                obj=obj.calcKData(input{1}.data, 'useMethod', obj.useMethod, 'specified_NRs', specified_NRs);
            end
        end

        input{1}=[]; % Delete struct in input{2} for saving memory           
    end

    %% Shortcut-Constructorfunctiomn
    function obj=cKDataShortcut(obj, input)
        % Part of the constructor, implements the (3.) mode.

        %Init:
        if sum(strcmpi(input, 'useMethod'))==1
            useMethodManualSet=true; % will be used later to check if we choose the parameter appending the ACQ_method
        else % if the parameter is not set manually try choosing it autmatically
            useMethodManualSet=false; % will be used later to check if we choose the parameter appending the ACQ_method                  
        end
        % [Output_args, out ] = bruker_addParamValue( Input_args, name, allowed_string, default) 
        [input, dataPrecision] =bruker_addParamValue(input, 'dataPrecision', '@(x) strcmp(x, ''single'') || strcmp(x, ''double'')', 'double');
        [input, obj.useMethod] =bruker_addParamValue(input, 'useMethod', '@(x) islogical(x)', true);
        
        % incorrect input:
        if length(input)>1
            error('Your input argument is not correct');
        end
        
        % create FrameDataObject with shortcut: 
        frameObj=FrameDataObject(input{1}, 'dataPrecision', 'single');
        % import frameDataObject
        obj=importFrameDataObject(obj, frameObj);

        % set useMethod if not specified manually with arguments:
        if ~useMethodManualSet
           obj=setUseMethod(obj, 'auto');
        end 

        % read method file if necessary:
        if obj.useMethod && (~isempty(obj.Filespath.path_to_method))
            names=fieldnames(obj.Method);
            if isempty(names) % read if method-struct is empty
                obj.Method=readBrukerParamFile(obj.Filespath.path_to_method);
            end
            clear names;
        elseif obj.useMethod
           error('Can''t find method-path in .Filespath'); 
        end % end read MEthod     
        
        try
            obj=obj.calcKData(frameObj.data, 'useMethod', obj.useMethod);
            clear('frameObj');
        catch
            error('It''s not possible to sort your data to kspace. Perhaps the acqusition method is not supported.');
        end
        % read precision & change if neccessary:
        if strcmpi(dataPrecision, 'double')
            obj.data=double(obj.data);
        end
        
        % Only for future additions to the Code:
        method_value=strtok(obj.Acqp.ACQ_method, 'Bruker:'); % PV6:e.g. Bruker:FLASH -> remove Bruker:
        if ~(strcmpi(method_value, 'RARE') || strcmpi(method_value, 'MSME') || strcmpi(method_value, 'FLASH') || strcmpi(method_value, 'FISP') || ...
             strcmpi(method_value, 'CSI') || strcmpi(method_value, 'MGE'))
                warning('MATLAB:bruker_note', 'You are using an unsupported acquisition method.\n Most probably your result will be incorrect. \n \n If you added additional method-support, please check if you still can use single precision in shortcut in CKDataObject.calcKData(). ');
        end
    

    end
end
end