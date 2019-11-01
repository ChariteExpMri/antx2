classdef ImageDataObject < BrukerDataSuperclass
% ImageDataObject
% this class can 
% - read-in images from disk  
% - store images and parameters
% - write images in ParaVision-format to disk
% - use the viewer to view images
% - handles transposition
% 
% [...] means: this is an optional argument
%
% 3 versions to create an object:
% 1.) generate an empty object: obj = ImageDataObject();
% 2.) use 'import'-mode to read all data from another object or struct: 
%       obj = ImageDataObject(importObject);
%       -> Does: import the importObject from another object or struct
% 3.) use the 'read'-mode to read the image from disk: 
%       obj=ImageDataObject('path_to_your_ImageData_withoutFilename', ['noImageRead']);
%       OR obj=ImageDataObject('path_to_2dseq_incl_filename', 'path_to_visu_pars_incl_filename');
%       -> Requires: (only fist variant) standard PV-directory-structure
%       -> Does: reads visu_pars and 2dseq-file from disk
%       -> Try: reading subject-file (necessary for writing images)
%
% Parameters
%
%    Required
%       importObject - (2.) 
%           Type: some object or struct that contains the same variables
%           like the other DataObject's
%       'path_to_your_ImageData_withoutFilenamey' - (3.)
%           Type: string, the path to your Paravision data directory with the 2dseq and visu_pars file e.g. '../Testfiles/10/pdata/1'
%
%    Optional
%       ['noImageRead'] - (3.)
%               Type: defined string 
%               You can use this string to exclude the read process of the image, you can run it later or create
%               the data yourself
%               e.g. obj = ImageDataObject('yourpath', 'noImageRead'); will
%               only set Filespath, and read the parameter-struct
%
% See also RawDataObject, FrameDataObject, CKDataObject, readBrukerParamFile,
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
% $Id: ImageDataObject.m,v 1.2.4.1 2014/05/23 08:43:51 haas Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Variables
% for more variables please see BrukerDataClass
properties (SetAccess = public) 
    data; % Matrix with dimensions (Dim1, Dim2, Dim3, Dim4, FrameGroup1, FrameGroup2, ...)
    dataDimensions; % Cellarry with the names of the Framegroups in dimension 5 to n
    FrameGroupParams; % Structmatrix with the FrameGroup-dimensions, contains the dependent parameters
end
properties (SetAccess = protected )
    exportVisu=struct(); % Struct with Visu-parameters generated for writing;    
end
properties (SetAccess = public, Hidden)
    exportVisu_readonly_list; % list with read-only template variables - needed for generating visu-parameters by writing
    original_slope_offset; % struct: contains the original slope and offset values before reading the image-data
end



methods
    %% Contructor
    function obj=ImageDataObject(varargin)
        if isempty(varargin)
            %nothing happens
        elseif ischar(varargin{1})
            obj=ImageDataRead(obj, varargin);
        elseif isobject(varargin{1}) || isstruct(varargin{1})
            obj=ImageDataImport(obj, varargin);
        end
            
    end
    
    
    
    %% Methods
    function obj=readImage(obj, varargin)
        % read the image from disk: obj.data = obj.readImage( obj.Filespath.path_to_2dseq, obj.Visu, ['complex_real_matrix', 'yourForcedType'], ['dim5_n', your_3D_DimArray])
        if isempty(fieldnames(obj.Visu))
            error('It''s necesarry to read vius_pars first - please use readVisu')
        end
        [varargin, imageType ] = bruker_addParamValue( varargin, 'imageType', ['@(x) (strcmp(x,''complex'') || strcmp(x,''real'') || strcmp(x,''reel'') ||', ... 
                                                                   ' strcmp(x,''magnitude'') || strcmp(x,''phase'') || strcmp(x,''imaginary'') || strcmp(x,''auto''))'], 'auto');
        [varargin, dim5_n ] = bruker_addParamValue( varargin, 'dim5_n', '@(x) isnumeric(x)', []);
        
        
        if prod(obj.Visu.VisuCoreDataSlope(:))==1 && sum(abs(obj.Visu.VisuCoreDataOffs(:)))==0 && ~(prod(obj.original_slope_offset.VisuCoreDataSlope)==1) && ~sum(obj.original_slope_offset.VisuCoreDataOffs)==0 
            warning('MATLAB:bruker_warning', 'It''s not recommended to set VisuCoreDataSlope and VisuCoreDataOffs to 1 and 0 before reading - please use ''keepSlopeAndOffset'' as argument in ImageDataObject.readVisu');
        end

        
        % read:
        [obj.data, obj.Visu]=readBruker2dseq(obj.Filespath.path_to_2dseq, obj.Visu, 'imageType', imageType, 'dim5_n', dim5_n);
        [obj.FrameGroupParams, obj.dataDimensions]=bruker_getFrameGroupParams(obj.Visu);
    end
    
    function frame=getTransposedFrame(obj, varargin)
        % returns one frame from a dataset - considering the transposition obj=obj.setTransposedFrame( frame, framegroupindex1, framegroupindex2, framegroupindex3,  ...)
        
        % if varagin is empty -> convert data to transposed cell-array
       if ~exist('varargin', 'var') || isempty(varargin)        
           dims=size(obj.data);
           if length(dims)>5
               localdata=reshape(obj.data,[size(obj.data,1), size(obj.data,2), size(obj.data,3), size(obj.data,4), prod(dims(5:end))]);
           else
               localdata=obj.data;
           end
           frame=cell(size(localdata,5),1);
           for i=1:size(localdata,5);
               frame{i}=bruker_getTranspositionFrame( localdata, obj.Visu, i );   
           end

           
        % if there are no framegroups or only one and one input -> get the frame directly   
       elseif length(varargin)==1 && (~isfield(obj.Visu, 'VisuFGOrderDescDim') || obj.Visu.VisuFGOrderDescDim==1 || size(obj.Visu.VisuFGOrderDesc,2)==1)
           frame = bruker_getTranspositionFrame( obj.data, obj.Visu, varargin{1} );
           
        % if there are multiple framgroups and varagin is indexing the framegroup -> convert the framegroupindex first   
       elseif length(varargin)>=1 && isfield(obj.Visu, 'VisuFGOrderDesc') && size(obj.Visu.VisuFGOrderDesc,2)==length(varargin)
           % convert group-index to frameindex:
           count=1;
           for i=1:size(obj.Visu.VisuFGOrderDesc,2)
               if obj.Visu.VisuFGOrderDesc{1,i}>1
                   dim5_n(count)=obj.Visu.VisuFGOrderDesc{1,i};
                   if (~isnumeric(varargin{count})) && length(varargin{count})==1 && varargin{count}<=dim5_n(count)
                       error('Your dimension input is not correct');
                   end
                   count=count+1;
               end
           end
           clear count;

           groupIndex=[varargin{:}]'-ones(length(varargin),1);
           frameIndex=0;
           frameIndex=frameIndex+groupIndex(i);
           for i=2:size(obj.Visu.VisuFGOrderDesc,2)
              frameIndex=frameIndex+groupIndex(i)*prod(dim5_n(1:i-1));
           end
           frameIndex=frameIndex+1;
           % generate the frame:
           dims=size(obj.data);
           if length(dims)>5
               localdata=reshape(obj.data,[size(obj.data,1), size(obj.data,2), size(obj.data,3), size(obj.data,4), prod(dims(5:end))]);
           else
               localdata=obj.data;
           end
           frame = bruker_getTranspositionFrame( localdata, obj.Visu, frameIndex );
           
       else
           error('Error with Input arguments')
       end      
    end
    
    function obj=setTransposedFrame(obj, frame, varargin)
       % adds one frame to a dataset - considering the transposition obj=obj.setTransposedFrame( frame, framegroupindex1, framegroupindex2, framegroupindex3,  ...)
        
       % if varagin is empty -> convert data to transposed cell-array
       if ~exist('varargin', 'var') || isempty(varargin)        
           dims=size(obj.data);
           if length(dims)>5
               localdata=reshape(obj.data,[size(obj.data,1), size(obj.data,2), size(obj.data,3), size(obj.data,4), prod(dims(5:end))]);
           else
               localdata=obj.data;
           end
           for i=1:size(localdata,5);
               [ localdata ] = bruker_setTranspositionFrame( localdata, frame{i}, obj.Visu, i );   
           end
           obj.data=reshape(localdata, size(obj.data));
           
        % if there are no framegroups or only one framgroup and one input -> get the frame directly   
       elseif length(varargin)==1 && (~isfield(obj.Visu, 'VisuFGOrderDescDim') || obj.Visu.VisuFGOrderDescDim==1 || size(obj.Visu.VisuFGOrderDesc,2)==1)
           obj.data = bruker_setTranspositionFrame( obj.data, frame, obj.Visu, varargin{1} );
           
        % if there are multiple framgroups and varagin is indexing the framegroup -> convert the framegroupindex first   
       elseif length(varargin)>=1 && isfield(obj.Visu, 'VisuFGOrderDesc') && size(obj.Visu.VisuFGOrderDesc,2)==length(varargin)
           % convert group-index to frameindex:
           count=1;
           for i=1:size(obj.Visu.VisuFGOrderDesc,2)
               if obj.Visu.VisuFGOrderDesc{1,i}>1
                   dim5_n(count)=obj.Visu.VisuFGOrderDesc{1,i};
                   if (~isnumeric(varargin{count})) && length(varargin{count})==1 && varargin{count}<=dim5_n(count)
                       error('Your dimension input is not correct');
                   end
                   count=count+1;
               end
           end
           groupIndex=[varargin{:}]'-ones(length(varargin),1);
           frameIndex=0;
           frameIndex=frameIndex+groupIndex(i);
           for i=2:size(obj.Visu.VisuFGOrderDesc,2)
              frameIndex=frameIndex+groupIndex(i)*prod(dim5_n(1:i-1));
           end
           frameIndex=frameIndex+1;
           % generate the frame:
           dims=size(obj.data);
           if length(dims)>5
               localdata=reshape(obj.data,[size(obj.data,1), size(obj.data,2), size(obj.data,3), size(obj.data,4), prod(dims(5:end))]);
           else
               localdata=obj.data;
           end
           localdata = bruker_setTranspositionFrame( localdata, frame, obj.Visu, frameIndex );
           obj.data=reshape(localdata, size(obj.data));           
           
       else
           error('Error with Input arguments')
       end 
    end    

    function obj=importDataObject(obj,prev_obj)
        % integrate headerInformation, Acqp, Method, Visu, Reco and Filespath of a RawDataObject, FrameDataObject or CKDataObject into this instance
       obj=obj.import_parameters_filespath(prev_obj);
    end
        
    function obj=genExportVisu(obj, varargin)
       % generates the exportVisu-parameterstruct: obj=obj.genExportVisu(['genmode', 'yourImportParamStructName' ]);
       
       % Attention: generates autamatically the Transposition
       
       [varargin, genmode] =bruker_addParamValue(varargin, 'genmode', '@(x) strcmp(x, ''Visu'') || strcmp(x, ''Template'') || strcmp(x, ''Subject'') || strcmp(x, ''auto'')', 'auto');
       [varargin, templatepath] =bruker_addParamValue(varargin, 'TemplatePath', '@(x) ischar(x)', []);
       if ~isempty(templatepath)
           obj.Filespath.path_to_visu_template=templatepath;
       end
       % Read template if necessary
       if strcmp(genmode, 'auto') 
           try
               template=readBrukerParamFile(obj.Filespath.path_to_visu_template);
           catch
              template=struct(); 
              warning('MATLAB:bruker_note', 'Template can''t be read. Proceeding without template.'); 
           end
       elseif strcmp(genmode, 'Template')
           try
               template=readBrukerParamFile(obj.Filespath.path_to_visu_template);
           catch
              error('Visu-Template can''t be read.'); 
           end
       else
           template=struct();
       end
       % Read subject if necessary
       if strcmp(genmode, 'auto')
           try
               obj=obj.readSubject;
           catch
              warning('MATLAB:bruker_note', 'Subject can''t be read. Proceeding without Subject.'); 
           end
       elseif strcmp(genmode, 'Subject')
           try
               obj=obj.readSubject;
           catch
              error('Subject can''t be read.'); 
           end
       else
           subject=struct();
       end
       
       if isempty(fieldnames(obj.Visu)) && isempty(fieldnames(obj.Subject)) && isempty(fieldnames(template))
           error('You have to read either the template, the Visu-File or the Subject-File before generating the exportVisu');
       end
       [obj.exportVisu, obj.exportVisu_readonly_list]=bruker_genVisu(obj.data, genmode, obj.Filespath.path_to_imagewrite, obj.Visu, template, obj.Subject, obj.HeaderInformation, obj.PackageParameters, obj.FrameGroupParams, 'importAll');
    end
    
    function obj=setExportVisu(obj, varargin)
        % makes it possible to change the generated exportVisu-parameterstruct: obj=obj.setExportVisu( 'Variablename', VariableValue );
        % obj=obj.setExportVisu('Variablename', 'clear'); will delete the value of the field Variablename
        % obj=obj.setExportVisu('all', 'clear'); will delete all containing fields of the exportVisu
        
        if strcmpi(varargin{2}, 'clear') && isfield(obj.exportVisu, varargin{1})
            obj.exportVisu.(varargin{1})=[];
            return;
        end
        if strcmpi(varargin{2}, 'clear') && strcmpi(varargin{1}, 'all')
            obj.exportVisu=struct();
            return;
        end
        
        force_override=false;
        if strcmpi(varargin{1}, 'overrideExportVisu')
            force_override=true;
            varargin(1)=[];
        end
        if ~(length(varargin)==2)
            error('You are using too much input arguments');
        end
        if force_override
            obj.exportVisu.(varargin{1})=varargin{2};
        elseif sum(strcmpi(varargin{1}, obj.exportVisu_readonly_list))>=1
            error('The requested parameter is write-protected');
        else
            
            VisuCoreDim=sum([size(obj.data,1) size(obj.data,2) size(obj.data,3) size(obj.data,4)]>[0 1 1 1]);
            dims=size(obj.data);
            if length(obj.data)>5
                FrameCount=prod(dims(5:end));
            else
                FrameCount=size(obj.data,5);
            end
            if ~isreal(obj.data)
                FrameCount=FrameCount*2;
            end
            clear dims
            
            % writepath
            if strcmpi(varargin{1}, 'imagewrite_path')
                if ischar(varargin{2})
                    obj.exportVisu.imagewrite_path=varargin{2};
                else
                    error('imagewrite_path has to be a string');
                end
                
            % OWNER
            elseif strcmpi(varargin{1}, 'OWNER')
                if ischar(varargin{2})
                    obj.exportVisu.OWNER=varargin{2};
                else
                    error('OWNER has to be a string');
                end
                           
            % VisuCoreFrameCount
            elseif strcmpi(varargin{1}, 'VisuCoreFrameCount')              
                ref=FrameCount;
                if isnumeric(varargin{2}) && length(varargin{2})==1 && varargin{2}==ref
                    obj.exportVisu.VisuCoreFrameCount=varargin{2};
                elseif isnumeric(varargin{2}) && length(varargin{2})==1
                    warning('MATLAB:bruker_note', 'Your VisuCoreFrameCount does not match the size of obj.data');
                    obj.exportVisu.VisuCoreFrameCount=varargin{2};
                else
                    error('VisuCoreFrameCount has to be a scalar')
                end
                clear ref;
                
            % VisuCoreDim    
            elseif strcmpi(varargin{1}, 'VisuCoreDim')
                ref=VisuCoreDim;
                if prod(varargin{2}==ref)==1 && isnumeric(varargin{2})
                    obj.exportVisu.VisuCoreDim=varargin{2};
                elseif isnumeric(varargin{2})
                    warning('MATLAB:bruker_note', 'Your VisuCoreDim does not match obj.data');
                    obj.exportVisu.VisuCoreDim=varargin{2};
                else
                    error('VisuCoreDim has to be a numeric')
                end
                clear ref;
                
            % VisuCoreSize    
            elseif strcmpi(varargin{1}, 'VisucoreSize')
                [d(1) d(2) d(3) d(4)]=size(obj.data);
                ref=d(1:VisuCoreDim);
                if isnumeric(varargin{2}) && length(ref)==length(varargin{2}) && prod(ref==varargin{2})==1
                    obj.exportVisu.VisuCoreSize=varargin{2};
                elseif isnumeric(varargin{2})
                    warning('MATLAB:bruker_note', 'Your VisuCoreSize does not match obj.data');
                    obj.exportVisu.VisuCoreSize=varargin{2};
                else
                    error('VisuCoreSize has to be a numeric')
                end               
                clear d ref;
                
            % VisuCoreDimDesc    
            elseif strcmpi(varargin{1}, 'VisuCoreDimDesc')
                test=varargin{2};
                if iscell(varargin{2}) && size(varargin{2},2)==1 && size(varargin{2},1)==VisuCoreDim && ischar(test{1})
                    obj.exportVisu.VisuCoreDimDesc=varargin{2};
                elseif iscell(varargin{2}) && size(varargin{2},2)==1 && ischar(test{1})
                    warning('MATLAB:bruker_note', 'Your VisuCoreDimDesc does not match obj.data');
                    obj.exportVisu.VisuCoreDimDesc=varargin{2};
                else
                    error('VisuCoreDimDesc has to be a n x 1 - cellarray with strings')
                end
                clear test;
                
            % VisuCoreExtent    
            elseif strcmpi(varargin{1}, 'VisuCoreExtent')   
                if isnumeric(varargin{2}) && length(varargin{2})==VisuCoreDim
                    obj.exportVisu.VisuCoreExtent=varargin{2};
                elseif isnumeric(varargin{2})
                    warning('MATLAB:bruker_note', 'Your VisuCoreExtent does not match obj.data');
                    obj.exportVisu.VisuCoreExtent=varargin{2};
                else
                    error('VisuCoreExtent has to be a numeric')
                end
            % VisuCoreFrameThickness    
            elseif strcmpi(varargin{1}, 'VisuCoreFrameThickness')   
                if isnumeric(varargin{2})
                    obj.exportVisu.VisuCoreExtent=varargin{2};
                else
                    error('VisuCoreFrameThickness has to be a numeric')
                end    
                    
            % VisuCoreUnits    
            elseif strcmpi(varargin{1}, 'VisuCoreUnits')
                test=varargin{2};
                if iscell(varargin{2}) && size(varargin{2},1)==1 && size(varargin{2},2)==VisuCoreDim && ischar(test{1})
                    obj.exportVisu.VisuCoreUnits=varargin{2};
                elseif iscell(varargin{2}) && size(varargin{2},1)==1 && ischar(test{1})
                    warning('MATLAB:bruker_note', 'Your VisuCoreUnits does not match obj.data');
                    obj.exportVisu.VisuCoreUnits=varargin{2};
                else
                    error('VisuCoreUnits has to be a 1 x VisuCoreDim - cellarray with strings')
                end
                clear test;
                
            % VisuCoreOrientation   
            elseif strcmpi(varargin{1}, 'VisuCoreOrientation')
                if isnumeric(varargin{2}) && size(varargin{2},1)==9 && ( size(varargin{2},2)==1 || size(varargin{2},2)== FrameCount)
                    obj.exportVisu.VisuCoreOrientation=varargin{2};
                elseif isnumeric(varargin{2}) && size(varargin{2},1)==9
                    warning('MATLAB:bruker_note', 'Your VisuCoreOrientation does not match obj.data');
                    obj.exportVisu.VisuCoreOrientation=varargin{2};
                else
                     error('VisuCoreOrientation has to be a numeric with a 9 x VisuCoreFrameCount Matrix or 9 x 1')
                end
             
            % VisuCorePosition   
            elseif strcmpi(varargin{1}, 'VisuCorePosition') 
                if isnumeric(varargin{2}) && size(varargin{2},1)==3 && ( size(varargin{2},2)==1 || size(varargin{2},2)== FrameCount)
                    obj.exportVisu.VisuCorePosition=varargin{2};
                elseif isnumeric(varargin{2}) && size(varargin{2},1)==3
                    warning('MATLAB:bruker_note', 'Your VisuCorePosition does not match obj.data');
                    obj.exportVisu.VisuCorePosition=varargin{2};
                else
                     error('VisuCorePosition has to be a numeric with a 3 x VisuCoreFrameCount Matrix or 3 x 1')
                end
                               
            % VisuCoreInstanceType   
            elseif strcmpi(varargin{1}, 'VisuCoreInstanceType') 
                if strcmp(varargin{2}, 'MINIMAL_INSTANCE')
                    obj.exportVisu.VisuCoreInstanceType='MINIMAL_INSTANCE';
                else
                    if isfield(obj.exportVisu, 'VisuCoreInstanceType')
                        disp('VisuCoreInstanceType removed');
                        obj.exportVisu=rmfield(obj.exportVisu, 'VisuCoreInstanceType');
                    end
                end
                
            % VisuCoreDataSlope    
            elseif strcmpi(varargin{1}, 'VisuCoreDataSlope')
                if isnumeric(varargin{2}) && size(varargin{2},2)==1 && ( size(varargin{2},1)==1 || size(varargin{2},1)== FrameCount)
                    obj.exportVisu.VisuCoreDataSlope=varargin{2};
                elseif isnumeric(varargin{2}) && size(varargin{2},2)==1
                    warning('MATLAB:bruker_note', 'Your VisuCoreDataSlope does not match obj.data');
                    obj.exportVisu.VisuCoreDataSlope=varargin{2};
                else
                     error('VisuCoreDataSlope has to be a numeric with a VisuCoreFrameCount x 1 Matrix or 1 x 1')
                end
                
            % VisuCoreDataOffs    
            elseif strcmpi(varargin{1}, 'VisuCoreDataOffs')   
                if isnumeric(varargin{2}) && size(varargin{2},2)==1 && ( size(varargin{2},1)==1 || size(varargin{2},1)== FrameCount)
                    obj.exportVisu.VisuCoreDataOffs=varargin{2};
                elseif isnumeric(varargin{2}) && size(varargin{2},2)==1
                    warning('MATLAB:bruker_note', 'Your VisuCoreDataOffs does not match obj.data');
                    obj.exportVisu.VisuCoreDataOffs=varargin{2};
                else
                     error('VisuCoreDataOffs has to be a numeric with a VisuCoreFrameCount x 1 Matrix or 1 x 1')
                end
                
            % VisuCoreFrameType    
            elseif strcmpi(varargin{1}, 'VisuCoreFrameType') 
                if iscell(varargin{2})
                    error('Please insert only MAGNITUDE_IMAGE, REAL_IMAGE, PHASE_IMAGE, IMAGINARY_IMAGE or COMPLEX_IMAGE. If you set COMPLEX_IMAGE a FrameGroup will generated autmatically.');
                elseif sum(strcmp(varargin{2}, {'MAGNITUDE_IMAGE', 'REAL_IMAGE', 'PHASE_IMAGE', 'IMAGINARY_IMAGE'}))>=1
                    if isfield(obj.exportVisu, 'VisuFGOrderDescDim')
                        obj.exportVisu=rmfield(obj.exportVisu, 'VisuFGOrderDescDim');
                        obj.exportVisu=rmfield(obj.exportVisu, 'VisuFGOrderDesc');
                        obj.exportVisu=rmfield(obj.exportVisu, 'VisuGroupDepVals');                        
                    end
                    obj.exportVisu.VisuCoreFrameType=varargin{2};
                elseif strcmp(varargin{2}, 'COMPLEX_IMAGE')
                    exportVisu.VisuCoreFrameType={'REAL_IMAGE', 'IMAGINARY_IMAGE'}';
                    exportVisu.VisuFGOrderDescDim=2;
                    exportVisu.VisuFGOrderDesc={2, 'FG_COMPLEX', '', 0, 1; exportVisu.VisuCoreFrameCount/2, 'FG_OTHER', '', 0, 0}';
                    exportVisu.VisuGroupDepVals={'VisuCoreFrameType', 0}';
                else
                    error('VisuCoreFrameType has to be ''MAGNITUDE_IMAGE'', ''COMPLEX_IMAGE'', ''REAL_IMAGE'', ''PHASE_IMAGE'' or ''IMAGINARY_IMAGE'' ');
                end
                                
            % VisuCoreWordType   
            elseif strcmpi(varargin{1}, 'VisuCoreWordType')
                if sum(strcmp(varargin{2}, {'_32BIT_SGN_INT', '_16BIT_SGN_INT', '_32BIT_FLOAT', '_8BIT_UNSGN_INT'}))==1
                    obj.exportVisu.VisuCoreWordType=varargin{2};
                    warning('MATLAB:bruker_note', 'VisuCoreDataSlope, VisuCoreDataOffs, VisuCoreDataMax and VisuCoreDataMin are overwritten');
                    VisuCore=bruker_genSlopeOffsMinMax(varargin{2}, obj.data, 1, 0);
                    obj.exportVisu.VisuCoreDataSlope=VisuCore.VisuCoreDataSlope;
                    obj.exportVisu.VisuCoreDataOffs=VisuCore.VisuCoreDataOffs;
                    obj.exportVisu.VisuCoreDataMin=VisuCore.VisuCoreDataMin;
                    obj.exportVisu.VisuCoreDataMax=VisuCore.VisuCoreDataMax;
                else
                    error('VisuCoreWordType has to be ''_32BIT_SGN_INT'', ''_16BIT_SGN_INT'', ''_32BIT_FLOAT'' or ''_8BIT_UNSGN_INT'' ');
                end
             
            % VisuCoreByteOrder    
            elseif strcmpi(varargin{1}, 'VisuCoreByteOrder') 
                if sum(strcmp(varargin{2}, {'littleEndian', 'bigEndian'}))==1
                    obj.exportVisu.VisuCoreByteOrder=varargin{2};
                else
                    error('VisuCoreByteOrder has to be ''littleEndian'' or ''bigEndian'' ');
                end
            
            % VisuCoreTransposition  
            elseif strcmpi(varargin{1}, 'VisuCoreTransposition') 
                if isnumeric(varargin{2}) && size(varargin{2},1)== FrameCount && size(varargin{2},2)==1
                    obj.exportVisu.VisuCoreTransposition=varargin{2};
                elseif isnumeric(varargin{2}) && size(varargin{2},1)==1
                    warning('MATLAB:bruker_note', 'Your VisuCoreTransposition does not match VisuCoreFrameCount');
                    obj.exportVisu.VisuCoreTransposition=varargin{2};
                else
                     error('VisuCoreTransposition has to be a numeric with VisuCoreFrameCount x 1 Matrix')
                end                    
                
            % VisuFGOrderDescDim
            elseif strcmpi(varargin{1}, 'VisuFGOrderDescDim')                
               error('This variable will be set autmatically by changing VisuFGOrderDescDim.')

           % VisuFGOrderDesc
           elseif strcmpi(varargin{1}, 'VisuFGOrderDesc')
               test=varargin{2};
               if ~(size(test,1)==5) || ~iscell(test)
                   error('Your dimensions are not correct');
               end
               try 
                   check1=isnumeric([test{[1 4 5],:}]);
                   check2=ischar([test{[2 3],:}]);
               catch
                   check1=false; check2=false;
               end
               if ~(check1 && check2)
                   error('Your description of VisuFGOrderDesc is not correct');
               end
               if ~( prod([test{1,:}])==obj.exportVisu.VisuCoreFrameCount )
                   warning('MATLAB:bruker_note', 'The product of all FrameGroup-length''s has to be VisuCoreFrameCount');
               end
               
               if ~isreal(obj.data) && ~(isequal(test(:,end), {2, 'FG_COMPLEX', '', 0, 1}'))
                  error('Your last framegroup has to be: {2, ''FG_COMPLEX'', '''', 0, 1}'' ')
               end
               obj.exportVisu.VisuFGOrderDesc=varargin{2};
               obj.exportVisu.VisuFGOrderDescDim=size(varargin{2},2);   
                       
            % VisuGroupDepVals
            elseif strcmpi(varargin{1}, 'VisuGroupDepVals')
                test=varargin{2};
               if ~(size(test,1)==2) || ~iscell(test)
                   error('Your dimensions are not correct');
               end
               try 
                   check1=ischar([test{1,:}]);
                   check2=isnumeric([test{2,:}]);
               catch
                   check1=false; check2=false;
               end
               if ~(check1 && check2)
                   error('Your description of VisuGroupDepVals is not correct');
               end
               if ~isreal(obj.data) && ~isequal(test(:,1), {'VisuCoreFrameType', 0})
                  warning('MATLAB:bruker_warning', 'Your first entry hast to be {''VisuCoreFrameType'', 0}'); 
               end
               obj.exportVisu.VisuGroupDepVals=varargin{2};

            % VisuSubjectName   
            elseif strcmpi(varargin{1}, 'VisuSubjectName')
                if ischar(varargin{2})
                    obj.exportVisu.VisuSubjectName=varargin{2};
                else
                    error('VisuSubjectName has to be a string')
                end   
               
            % VisuSubjectID    
            elseif strcmpi(varargin{1}, 'VisuSubjectId')
                if ischar(varargin{2})
                    obj.exportVisu.VisuSubjectId=varargin{2};
                else
                    error('VisuSubjectId has to be a string')
                end
                
            % VisuStudyUid   
            elseif strcmpi(varargin{1}, 'VisuStudyUid')
                if ischar(varargin{2}) && length(varargin{2})<64
                    obj.exportVisu.VisuStudyUid=varargin{2};
                else
                    error('VisuStudyUid has to be a string with less than 64 characters')
                end
             
            % VisuStudyId   
            elseif strcmpi(varargin{1}, 'VisuStudyId')
                if ischar(varargin{2})
                    obj.exportVisu.VisuStudyId=varargin{2};
                else
                    error('VisuStudyId has to be a string')
                end
                
            % VisuStudyNumber    
            elseif strcmpi(varargin{1}, 'VisuStudyNumber')
                if isnumeric(varargin{2}) && length(varargin{2})==1
                    obj.exportVisu.VisuStudyNumber=varargin{2};
                else
                    error('VisuStudyNumber has to be a scalar')
                end
                
            % VisuExperimentNumber   
            elseif strcmpi(varargin{1}, 'VisuExperimentNumber')
                if isnumeric(varargin{2}) && length(varargin{2})==1
                    obj.exportVisu.VisuExperimentNumber=varargin{2};
                else
                    error('VisuExperimentNumber has to be a scalar')
                end
             
            % VisuProcessingNumber   
            elseif strcmpi(varargin{1}, 'VisuProcessingNumber')  
                if isnumeric(varargin{2}) && length(varargin{2})==1
                    obj.exportVisu.VisuProcessingNumber=varargin{2};
                else
                    error('VisuProcessingNumber has to be a scalar')
                end
                
            % VisuSubjectPosition    
            elseif strcmpi(varargin{1}, 'VisuSubjectPosition')
                if ischar(varargin{2})
                    obj.exportVisu.VisuSubjectPosition=varargin{2};
                else
                    error('VisuSubjectPosition has to be a string')
                end
              
            end    
            
        end
        
        
    end
    
    function writeImage(obj, varargin)
        % writes an Image readable by ParaVision to disk: genertes a 2dseq and a visu_pars file. obj.writeImage
        
        [varargin, exportVisu] =bruker_addParamValue(varargin, 'overrideExportVisu', '@(x) isstruct(x)', []);      
        if isempty(exportVisu)
            exportVisu=obj.exportVisu;
        end
        
        if ~exist(exportVisu.imagewrite_path,'file')
            mkdir(exportVisu.imagewrite_path);
        end
        [VisuCoreData]=bruker_write2dseq( [exportVisu.imagewrite_path, filesep, '2dseq'], obj.exportVisu, obj.data );
        obj.exportVisu.VisuCoreDataMax=VisuCoreData.VisuCoreDataMax;
        obj.exportVisu.VisuCoreDataMin=VisuCoreData.VisuCoreDataMin;
        bruker_writeVisu( exportVisu.imagewrite_path, exportVisu);
    end
    
    function obj=readVisu(obj, varargin)
        % reads the visu_pars-file: e.g. obj=obj.readVisu(); optional: path to visu file -> the path is also saved to Filespath.path_to_visu
        
        % Read Arguments:
        changeSlopeOffset=true;
        if isempty(obj.data)
            changeSlopeOffset=false;
        end
        if sum(strcmpi(varargin, 'keepSlopeAndOffset'))==1
            pos=find(strcmpi(input, 'keepSlopeAndOffset')==1);
            changeSlopeOffset=false;
            varargin(pos)=[];
            clear pos;
        end
        if ~isempty(varargin) && ischar(varargin{1})
           obj.Filespath.path_to_visu=varargin{1};
        end
        [obj.Visu, obj.HeaderInformation]=readBrukerParamFile(obj.Filespath.path_to_visu);
        
        % Backup 2 important visu-parameters in ImageDataObject:
        if isfield(obj.Visu, 'VisuCoreDataOffs') && isfield(obj.Visu, 'VisuCoreDataSlope')          
            obj.original_slope_offset.VisuCoreDataOffs=obj.Visu.VisuCoreDataOffs;
            obj.original_slope_offset.VisuCoreDataSlope=obj.Visu.VisuCoreDataSlope;
        end
        
        if changeSlopeOffset && isfield(obj.Visu, 'VisuCoreDataOffs') && isfield(obj.Visu, 'VisuCoreDataSlope')
            obj.Visu.VisuCoreDataOffs=zeros(obj.Visu.VisuCoreFrameCount,1);
            obj.Visu.VisuCoreDataSlope=ones(obj.Visu.VisuCoreFrameCount,1);
            warning('MATLAB:bruker_note', 'Visu.VisuCoreDataOffs is set to 0 and Visu.VisuCoreDataSlope is set to 1, because writing operations may fail')
        end
        
    end     
       
    function viewer(obj, varargin)
       % opens the brViewer with the imageData, obj.viewer([figuretitle', 'yourFigurName'], obj.viewer([figuretitle', 'yourFigurName'], ['imscale', imscale ], ['res_factor', res_factor])
       % imscale           : scale image using imagesc(), e.g. imscale=double(threshold_min, threshold_max)
       %
       % res_factor        : scalar, multiplication-factor on the imageresolution for saving as tiff 
       %                     e.g. res_factor=2 and image (256x128) -> saved tiff has (512x256) pixel. Advantage: rendering with opengl
       %                     default value is set to 2
       
       [varargin, figuretitle] =bruker_addParamValue(varargin, 'figuretitle', '@(x) ischar(x)', 'ImgObject');
       brViewer(obj.data, 'figuretitle', figuretitle, varargin{:});          
    end
    
    function obj=load(obj, load_struct)
        % loading an Object from a struct, saved with struct(obj);
        obj=obj.load_superclass(load_struct);
        obj.data=load_struct.data;
        obj.dataDimensions=load_struct.dataDimensions;
        obj.FrameGroupParams=load_struct.FrameGroupParams;
        obj.exportVisu=load_struct.exportVisu;
        obj.exportVisu_readonly_list=load_struct.exportVisu_readonly_list;
        obj.original_slope_offset=load_struct.original_slope_offset;
    end
    
end

methods (Access=protected)
    %% Import-Constructorfunction
    function obj=ImageDataImport(obj, input)
        % Part of the constructor, implements the (2.) mode.
    
        obj=obj.importDataObject(input{1});
        obj.data=input{1}.data;
                 
    end

    %% Read-Constructorfunctiomn
    function obj=ImageDataRead(obj, input)
        % Part of the constructor, implements the (3.) mode.
        
        % imageType at this position is an undocumented special argument,
        % because there was an DTI bug in PV, and VisuCoreFrameType was not
        % set
        [input, imageType ] = bruker_addParamValue( input, 'imageType', ['@(x) (strcmp(x,''complex'') || strcmp(x,''real'') || strcmp(x,''reel'') ||', ... 
                                                                   ' strcmp(x,''magnitude'') || strcmp(x,''phase'') || strcmp(x,''imaginary'') || strcmp(x,''auto''))'], 'auto');
        % Read Arguments:
        readImage=true;
        if sum(strcmpi(input, 'noImageRead'))==1
            pos=find(strcmpi(input, 'noImageRead')==1);
            readImage=false;
            input(pos)=[];
            clear pos;
        end
        % Set paths
        % Set paths in auto-mode:
        if length(input)==1
            obj=obj.setDataPath('auto', input{1});

        elseif length(input)==2 % set paths manually:
            obj.Filespath.path_to_2dseq=[input{1}];
            obj.Filespath.path_to_visu=[input{2}];

        else
           error('Your input-arguments to ImageDataObject are not correct') 
        end
        [obj.Visu, obj.HeaderInformation]=readBrukerParamFile(obj.Filespath.path_to_visu);
        
        % Backup 2 important visu-parameters in ImageDataObject:
        if isfield(obj.Visu, 'VisuCoreDataOffs') && isfield(obj.Visu, 'VisuCoreDataSlope')           
            obj.original_slope_offset.VisuCoreDataOffs=obj.Visu.VisuCoreDataOffs;
            obj.original_slope_offset.VisuCoreDataSlope=obj.Visu.VisuCoreDataSlope;
        end
        
        if readImage
            obj=obj.readImage('imageType', imageType);
        end

    end
end
end
