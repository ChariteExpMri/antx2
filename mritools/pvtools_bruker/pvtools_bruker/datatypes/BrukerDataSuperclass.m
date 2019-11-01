classdef BrukerDataSuperclass
    % BrukerDataSuperclass - superclass
    % This class only contains variables and functions used in multiple
    % DataObjects - for inheritance.

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Copyright (c) 2013
    % Bruker BioSpin MRI GmbH
    % D-76275 Ettlingen, Germany
    %
    % All Rights Reserved
    %
    % $Id: BrukerDataSuperclass.m,v 1.2.4.3 2015/01/12 10:54:55 haas Exp $
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties (SetAccess = public) 
        HeaderInformation=cell(1,1); % Cell-Matrix with additional experiment information
        Acqp=struct(); %Struct with acqp-parameters
        Method=struct(); %Struct with method-parameters
        Visu=struct(); % Struct with visu_pars-parameters
        Reco=struct(); % Struct with reco-parameters
        Subject=struct(); % Struct with subject-parameters
              
        Filespath=struct('path_to_acqp', [], 'path_to_fid',[], 'path_to_method', [], 'path_to_visu', [], 'path_to_reco', [], 'path_to_2dseq', [], 'path_to_subject', [], 'path_to_visu_template', [], 'path_to_imagewrite', [], 'auto', [], 'mode', 'manual'); %Struct with the paths
    end
     
    properties (SetAccess=protected, Hidden)
        PackageParameters=struct( 'MatlabPackageName', 'pvmatlab - MATLAB package for handling ParaVision data', 'MatlabPackageVersion', '0.CVS.3'); % Packagename, Version etc.
        % Format: MatlabPackageVersion=Number.(Number|Name){.(Number|Name)} e.g. 0.preAlhpa.10
        % if changes are made: also change bruker_version-function
    end
    
    methods
        function obj=setDataPath(obj, varargin)
            % Sets the datapaths to the FilespathStruct. obj=obj.setDataPath('FileName', 'path_to_paramfile') OR obj=obj.setDataPath('auto', 'path_to_your_Target_ParaVisionDirectory')
            if sum(strcmp(varargin, 'imagewrite'))>=1
                [varargin, obj.Filespath.path_to_imagewrite] =bruker_addParamValue(varargin, 'imagewrite', '@(x) ischar(x)', []);
            else
                [varargin, obj.Filespath.path_to_acqp] =bruker_addParamValue(varargin, 'acqp', '@(x) ischar(x)', []);
                [varargin, obj.Filespath.path_to_method] =bruker_addParamValue(varargin, 'method', '@(x) ischar(x)', []);
                [varargin, obj.Filespath.path_to_fid] =bruker_addParamValue(varargin, 'fid', '@(x) ischar(x)', []);
                [varargin, obj.Filespath.path_to_visu] =bruker_addParamValue(varargin, 'visu', '@(x) ischar(x)', []);
                [varargin, obj.Filespath.path_to_visu] =bruker_addParamValue(varargin, 'visu_pars', '@(x) ischar(x)', []);
                [varargin, obj.Filespath.path_to_reco] =bruker_addParamValue(varargin, 'reco', '@(x) ischar(x)', []);
                [varargin, obj.Filespath.path_to_2dseq] =bruker_addParamValue(varargin, '2dseq', '@(x) ischar(x)', []);
                [varargin, obj.Filespath.path_to_subject] =bruker_addParamValue(varargin, 'subject', '@(x) ischar(x)', []);
                [varargin, obj.Filespath.path_to_visu_template] =bruker_addParamValue(varargin, 'visu_template', '@(x) ischar(x)', []);
                if sum(strcmpi(varargin, 'auto'))>=1
                    [varargin, obj.Filespath.auto] =bruker_addParamValue(varargin, 'auto', '@(x) ischar(x)', []);
                    pdata_pos=strfind(obj.Filespath.auto, 'pdata');
                    if length(pdata_pos)>1
                        error('The string pdata is only allowed once in your path')
                    end
                    if ~isempty(pdata_pos)
                        pos2=strfind(obj.Filespath.auto(1:pdata_pos-1), filesep);
                        expno=obj.Filespath.auto(1:pos2(end)-1);
                        clear pos2;
                        obj.Filespath.path_to_acqp=[expno, filesep, 'acqp'];
                        obj.Filespath.path_to_method=[expno, filesep, 'method'];
                        obj.Filespath.path_to_fid=[expno, filesep, 'fid'];
                        obj.Filespath.path_to_visu_template=[expno, filesep, 'visu_pars'];
                        pos3=strfind(expno,filesep);
                        if ~isempty(pos3)
                            obj.Filespath.path_to_subject=[expno(1:pos3(end)-1), filesep, 'subject'];
                        else % only 2 or ''
                            tmp=dir;
                            for i=1:length(tmp)
                                if strcmp(tmp(i).name, 'subject')
                                    obj.Filespath.path_to_subject='subject';
                                end
                            end
                        end

                        clear pos3;
                        obj.Filespath.path_to_visu=[];
                        obj.Filespath.path_to_reco=[];
                        obj.Filespath.path_to_2dseq=[];
                        obj.Filespath.mode='expno';
                        if length(obj.Filespath.auto)>=pdata_pos+6 % pos=p of pdata -> pos+6-> is the X in pdata/X
                            pos4=strfind(obj.Filespath.auto,filesep);
                            while pos4(end)>pdata_pos+5
                                obj.Filespath.auto=obj.Filespath.auto(1:pos4(end)-1);
                                pos4(end)=[];
                            end                       
                            obj.Filespath.path_to_visu=[obj.Filespath.auto, filesep, 'visu_pars'];
                            obj.Filespath.path_to_reco=[obj.Filespath.auto, filesep, 'reco'];
                            obj.Filespath.path_to_2dseq=[obj.Filespath.auto, filesep, '2dseq'];
                            obj.Filespath.mode='procno';
                        else
                            obj.Filespath.auto=expno;
                        end
                    else % String doesn't contain 'pdata'
                        pos2=strfind(obj.Filespath.auto, filesep);
                        if ~isempty(pos2) && pos2(end)==length(obj.Filespath.auto) % path ends with /
                            expno=obj.Filespath.auto(1:end-1);
                        else
                            expno=obj.Filespath.auto;
                        end
                        obj.Filespath.path_to_acqp=[expno, filesep, 'acqp'];
                        obj.Filespath.path_to_method=[expno, filesep, 'method'];
                        obj.Filespath.path_to_fid=[expno, filesep, 'fid'];
                        obj.Filespath.path_to_visu_template=[expno, filesep, 'visu_pars'];
                        obj.Filespath.auto=expno;
                        pos3=strfind(expno,filesep);
                        if ~isempty(pos3)
                            obj.Filespath.path_to_subject=[expno(1:pos3(end)-1), filesep, 'subject'];
                        else
                            tmp=dir;
                            for i=1:length(tmp)
                                if strcmp(tmp(i).name, 'subject')
                                    obj.Filespath.path_to_subject='subject';
                                end
                            end
                        end
                        obj.Filespath.path_to_visu=[];
                        obj.Filespath.path_to_reco=[];
                        obj.Filespath.path_to_2dseq=[];
                        obj.Filespath.mode='expno';
                    end

                end
            end
        end
        
        function obj=setPrecision(obj, precision)
            % you can change the default setting from single precision to double precision it also changes the precision of the data: obj=obj.setPrecision(obj, 'double') or obj=obj.setPrecision(obj, 'single')
            if isa(obj, 'RawDataObject')
                if (strcmpi(precision,'double') || strcmpi(precision,'single'))
                    if(strcmpi(precision,'double'))
                        for i=1:length(obj.data)
                            obj.data{i}=double(obj.data{i});
                        end
                    end
                    if(strcmpi(precision,'single'))
                        for i=1:length(obj.data)
                            obj.data{i}=single(obj.data{i});
                        end
                    end
                else
                    disp('your input is not correct, choose single or double')
                end
                
            else % of isa(obj, 'RawDataObject')
                if (strcmpi(precision,'double') || strcmpi(precision,'single'))
                    if(strcmpi(precision,'double'))
                        obj.data=double(obj.data);
                    end
                    if(strcmpi(precision,'single'))
                        obj.data=single(obj.data);
                    end
                else
                    disp('your input is not correct, choose single or double')
                end
            end % of if,else: isa(obj, 'RawDataObject')
        end
        
        function obj=readAcqp(obj, varargin)
            % reads the acqp-file: e.g. obj=obj.readAcqp(); optional: path to acqp file -> the path is also saved to Filespath.path_to_acqp
            if ~isempty(varargin) && ischar(varargin{1})
               obj.Filespath.path_to_acqp=varargin{1};
            end
            [obj.Acqp, obj.HeaderInformation]=readBrukerParamFile(obj.Filespath.path_to_acqp);
        end     

        function obj=readMethod(obj, varargin)
            % reads the method-file: e.g. obj=obj.readAcqp(); optional: path to method file -> the path is also saved to Filespath.path_to_method
            if ~isempty(varargin) && ischar(varargin{1})
               obj.Filespath.path_to_method=varargin{1};
            end
            [obj.Method, trash]=readBrukerParamFile(obj.Filespath.path_to_method);
            clear trash;
        end
        
        function obj=readVisu(obj, varargin)
            % reads the visu_pars-file: e.g. obj=obj.readVisu(); optional: path to visu file -> the path is also saved to Filespath.path_to_visu
            if ~isempty(varargin) && ischar(varargin{1})
               obj.Filespath.path_to_visu=varargin{1};
            end
            [obj.Visu, obj.HeaderInformation]=readBrukerParamFile(obj.Filespath.path_to_visu);     
        end     

        function obj=readReco(obj, varargin)
            % reads the reco-file: e.g. obj=obj.readReco(); optional: path to reco file -> the path is also saved to Filespath.path_to_reco
            if ~isempty(varargin) && ischar(varargin{1})
               obj.Filespath.path_to_reco=varargin{1};
            end
            [obj.Reco, trash]=readBrukerParamFile(obj.Filespath.path_to_reco);
            clear trash;
        end
        
        function obj=readSubject(obj, varargin)
            % reads the subject-file: e.g. obj=obj.readSubject(); optional: path to subject file -> the path is also saved to Filespath.path_to_subject
            if ~isempty(varargin) && ischar(varargin{1})
               obj.Filespath.path_to_subject=varargin{1};
            end
            [obj.Subject, trash]=readBrukerParamFile(obj.Filespath.path_to_subject);
            clear trash;
        end
        
    end
    
    
    
    methods (Access=protected, Hidden)
        
        
        function obj=import_parameters_filespath(obj, prev_obj)
           if numel(obj.HeaderInformation)==1 && isempty(obj.HeaderInformation{1,1})
               obj.HeaderInformation=prev_obj.HeaderInformation;
           else
               disp('Error: HeaderInformation is not empty, proceed without overwrite!');
           end
           names=fieldnames(obj.Acqp);
           if isempty(names)
               obj.Acqp=prev_obj.Acqp;
           else
               disp('Error: Acqp is not empty, proceed without overwrite!');
           end
           clear names;
           names=fieldnames(obj.Method);
           if isempty(names)
               obj.Method=prev_obj.Method;
           else
               disp('Error: Method is not empty, proceed without overwrite!');
           end
           clear names;
           names=fieldnames(obj.Visu);
           if isempty(names)
               obj.Visu=prev_obj.Visu;
           else
               disp('Error: Visu is not empty, proceed without overwrite!');
           end
           clear names;
           names=fieldnames(obj.Reco);
           if isempty(names)
               obj.Reco=prev_obj.Reco;
           else
               disp('Error: Reco is not empty, proceed without overwrite!');
           end
           clear names;
           if isempty(obj.Filespath.path_to_acqp)
               obj.Filespath.path_to_acqp=prev_obj.Filespath.path_to_acqp;
           else
               disp('Error: Filespath.path_to_acqp is not empty, proceed without overwrite!');
           end
           if isempty(obj.Filespath.path_to_method)
               obj.Filespath.path_to_method=prev_obj.Filespath.path_to_method;
           else
               disp('Error: Filespath.path_to_method is not empty, proceed without overwrite!');
           end
           if isempty(obj.Filespath.path_to_fid)
               obj.Filespath.path_to_fid=prev_obj.Filespath.path_to_fid;
           else
               disp('Error: Filespath.path_to_fid is not empty, proceed without overwrite!');
           end
           
           if isempty(obj.Filespath.path_to_visu)
               obj.Filespath.path_to_visu=prev_obj.Filespath.path_to_visu;
           else
               disp('Error: Filespath.path_to_visu is not empty, proceed without overwrite!');
           end
           if isempty(obj.Filespath.path_to_reco)
               obj.Filespath.path_to_reco=prev_obj.Filespath.path_to_reco;
           else
               disp('Error: Filespath.path_to_reco is not empty, proceed without overwrite!');
           end                  
           if isempty(obj.Filespath.path_to_2dseq)
               obj.Filespath.path_to_2dseq=prev_obj.Filespath.path_to_2dseq;
           else
               disp('Error: Filespath.path_to_2dseq is not empty, proceed without overwrite!');
           end
           if isempty(obj.Filespath.path_to_subject)
               obj.Filespath.path_to_subject=prev_obj.Filespath.path_to_subject;
           else
               disp('Error: Filespath.path_to_subject is not empty, proceed without overwrite!');
           end
           if isempty(obj.Filespath.path_to_imagewrite)
               obj.Filespath.path_to_imagewrite=prev_obj.Filespath.path_to_imagewrite;
           else
               disp('Error: Filespath.path_to_imagewrite is not empty, proceed without overwrite!');
           end
           if isempty(obj.Filespath.auto)
               obj.Filespath.auto=prev_obj.Filespath.auto;
           else
               disp('Error: Filespath.auto is not empty, proceed without overwrite!');
           end
           if ~(strcmpi(obj.Filespath.mode, prev_obj.Filespath.mode))
               obj.Filespath.mode=prev_obj.Filespath.mode;
           else
               disp('Warning: Filespath.mode is overwriten!');
           end
        end       
        
        function obj=load_superclass(obj, load_struct)
            
            % check if PackageParameters are correct:
            % ...
            
            obj.HeaderInformation=load_struct.HeaderInformation;            
            obj.Acqp=load_struct.Acqp;
            obj.Method=load_struct.Method;
            obj.Visu=load_struct.Visu;
            obj.Reco=load_struct.Reco;
            obj.Subject=load_struct.Subject;
           
            obj.Filespath=load_struct.Filespath;
            
        end
    end
    
end
