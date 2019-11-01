function bruker_writeVisu( writepath, exportVisu)
% bruker_writeVisu( writepath, exportVisu)
% writes a visu_pars-file.
% Please keep in mind, that it's not possible to write a function, that
% supports every possible change in the data and also supports all
% ParaVision-functions.
% This function only provides the most necessary parameters to get an image
% to ParaVision.
%
% Out: only writes files onto harddisk
% IN:
%   writepath: type: string, path to the directory you want saving the Files
%       it's recommended to set the path in following syntax:
%       '/yourstudyname/expno/pdata/procno' where expno and procno are
%       numbers
%   exportVisu: contains the visu-parameters of the exportVisu-struct you want to import to the new
%       visu_pars-file

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2013
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: bruker_writeVisu.m,v 1.2.4.1 2014/05/23 08:43:51 haas Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Functioncall: write new visu-file
write_new_visu(writepath, exportVisu);
% perhaps in future releases it will be useful to add the generated Paramters to an existing File, therefore you can add more functions here.

end 

%% Function: write new visu-file
function write_new_visu(writepath, exportVisu)
try
    FileID=fopen([writepath, filesep, 'visu_pars'],'wb');
catch
    FileID = -1;
end
if FileID == -1
    error('Cannot create 2dseq file. Problem opening file %s.',[writepath, filesep, 'visu_pars']);
end


VisuCoreDim=exportVisu.VisuCoreDim;
VisuCoreFrameCount=exportVisu.VisuCoreFrameCount;

%% Header
     fprintf(FileID, '%s\n', '##TITLE=Parameter List, pvmatlab');
    fprintf(FileID, '%s\n', '##JCAMPDX=4.24'); 
    fprintf(FileID, '%s\n', '##DATATYPE=Parameter Values');
    fprintf(FileID, '%s\n', '##ORIGIN=Bruker BioSpin MRI GmbH');
    fprintf(FileID, '%s\n', ['##OWNER=', exportVisu.OWNER]);
    fprintf(FileID, '%s\n', ['$$ ', datestr(now, 'yyyy-mm-dd HH:MM:SS'), ' Matlab']);
    fprintf(FileID, '%s\n', ['$$', writepath, filesep, 'visu_pars']);
    fprintf(FileID, '%s\n', '$$ process Matlab');
    
    % VisuUID
    if isfield(exportVisu, 'VisuUid') && ~isempty(exportVisu.VisuUid)
        fprintf(FileID, '%s\n', '##$VisuUid=( 64 )');
        fprintf(FileID, '%s\n', ['<', exportVisu.VisuUid, '>']);
    end
    
    % VisuVersion
    fprintf(FileID, '%s\n', '##$VisuVersion=3');
    
    % VisuCreator
    fprintf(FileID, '%s\n', '##$VisuCreator=( 65 )'); 
    fprintf(FileID, '%s\n', ['<', exportVisu.VisuCreator, '>']); 
    
    % VisuCreatorVersion
    fprintf(FileID, '%s\n', '##$VisuCreatorVersion=( 65 )');
    fprintf(FileID, '%s\n', ['<', exportVisu.VisuCreatorVersion, '>']);
    
    % VisuCreationDate
    fprintf(FileID, '%s\n', ['##$VisuCreationDate=<', exportVisu.VisuCreationDate, '>']);
    
    % VisuInstanceModality
    fprintf(FileID, '%s\n', '##$VisuInstanceModality=( 65 )');
    fprintf(FileID, '%s\n', '<MR>');
    
    
    % VisuCoreFrameCount
    fprintf(FileID, '%s\n', ['##$VisuCoreFrameCount=', num2str(VisuCoreFrameCount)]);
    
    % VisuCoreDim
    fprintf(FileID, '%s\n', ['##$VisuCoreDim=', num2str(VisuCoreDim)]);
    
    % VisuCoreSize
    fprintf(FileID, '%s\n', ['##$VisuCoreSize=( ', num2str(VisuCoreDim), ' )']);
    fprintf(FileID, '%s\n', num2str(exportVisu.VisuCoreSize));
    
    % VisuCoreDimDesc   
    if isfield(exportVisu, 'VisuCoreDimDesc') && ~isempty(exportVisu.VisuCoreDimDesc)
        fprintf(FileID, '%s\n', ['##$VisuCoreDimDesc=( ', num2str(VisuCoreDim), ' )']);
        tmp='';
        for i=1:size(exportVisu.VisuCoreDimDesc,2)
            if iscell(exportVisu.VisuCoreDimDesc)
                tmp=[tmp, exportVisu.VisuCoreDimDesc{:,i}, ' '];
            elseif ischar(exportVisu.VisuCoreDimDesc)
                tmp=[tmp, exportVisu.VisuCoreDimDesc, ' '];
            end
        end
        fprintf(FileID, '%s\n', tmp(1:end-1));
        clear tmp;
    end
    
    % VisuCoreExtent   
    if isfield(exportVisu, 'VisuCoreExtent') && ~isempty(exportVisu.VisuCoreExtent)
        fprintf(FileID, '%s\n', ['##$VisuCoreExtent=( ', num2str(VisuCoreDim), ' )']);
        fprintf(FileID, '%s\n', num2str(exportVisu.VisuCoreExtent));
    end
    
    
    % VisuCoreFrameThickness
    if isfield(exportVisu, 'VisuCoreFrameThickness') && ~isempty(exportVisu.VisuCoreFrameThickness)
        fprintf(FileID, '%s\n', ['##$VisuCoreFrameThickness=( ', num2str(length(exportVisu.VisuCoreFrameThickness)), ' )']);
        if size(exportVisu.VisuCoreFrameThickness,2)==1
            exportVisu.VisuCoreFrameThickness=exportVisu.VisuCoreFrameThickness';
        end
        fprintf(FileID, '%s\n', num2str(exportVisu.VisuCoreFrameThickness));
    end
    
    % VisuCoreUnits   
    if isfield(exportVisu, 'VisuCoreUnits') && ~isempty(exportVisu.VisuCoreUnits)
        fprintf(FileID, '%s\n', ['##$VisuCoreUnits=( ', num2str(VisuCoreDim), ', 65 )']);
        if ischar(exportVisu.VisuCoreUnits) % very rare but e.g. [ppm]
            tmp=['<', exportVisu.VisuCoreUnits, '> '];
        else
            tmp='';
            for i=1:size(exportVisu.VisuCoreUnits,2)
                if size(exportVisu.VisuCoreUnits,1)==1  && ~iscell(exportVisu.VisuCoreUnits)
                    tmp=[tmp, exportVisu.VisuCoreUnits(i), ' '];
                else
                    tmp=[tmp, '<', exportVisu.VisuCoreUnits{i}, '> '];
                end           
            end
        end
        fprintf(FileID, '%s\n', tmp(1:end-1));
        clear tmp;
    end    
    
    % VisuCoreOrientation
    if isfield(exportVisu, 'VisuCoreOrientation') && ~isempty(exportVisu.VisuCoreOrientation)
        VisuCoreOrientation=reshape(exportVisu.VisuCoreOrientation.', 1, numel(exportVisu.VisuCoreOrientation));
        tmp='';
        for i=1:length(VisuCoreOrientation)
            tmp=[tmp, num2str(VisuCoreOrientation(i)), ' '];
        end
        fprintf(FileID, '%s\n', ['##$VisuCoreOrientation=( ', num2str(size(exportVisu.VisuCoreOrientation,1)), ', ',  num2str(size(exportVisu.VisuCoreOrientation,2)), ' )']);
        fprintf(FileID, '%s\n', tmp(1:end-1));
        clear tmp;
    end
    
    % VisuCorePosition
    if  isfield(exportVisu, 'VisuCorePosition') && ~isempty(exportVisu.VisuCorePosition)    
        VisuCorePosition=reshape(exportVisu.VisuCorePosition.', 1, numel(exportVisu.VisuCorePosition));
        tmp='';
        for i=1:length(VisuCorePosition)
            tmp=[tmp, num2str(VisuCorePosition(i)), ' '];
        end
        fprintf(FileID, '%s\n', ['##$VisuCorePosition=( ', num2str(size(exportVisu.VisuCorePosition,1)), ', ',  num2str(size(exportVisu.VisuCorePosition,2)), ' )']);
        fprintf(FileID, '%s\n', tmp(1:end-1));   
        clear tmp;
    end

    % VisuCoreInstanceType
    if isfield(exportVisu, 'VisuInstanceType')
        fprintf(FileID, '%s\n', ['##$VisuInstanceType=', exportVisu.VisuInstanceType ]);
    end
    
    % VisuCoreDataSlope
    if isfield(exportVisu, 'VisuCoreDataSlope') && ~isempty(exportVisu.VisuCoreDataSlope)
        fprintf(FileID, '%s\n', ['##$VisuCoreDataSlope=( ', num2str(VisuCoreFrameCount), ' ) ']);    
        fprintf(FileID, '%s\n', num2str(exportVisu.VisuCoreDataSlope',15));
    end

    % VisuCoreDataOffs
    if isfield(exportVisu, 'VisuCoreDataOffs') && ~isempty(exportVisu.VisuCoreDataOffs)
        fprintf(FileID, '%s\n', ['##$VisuCoreDataOffs=( ', num2str(VisuCoreFrameCount), ' ) ']);    
        fprintf(FileID, '%s\n', num2str(exportVisu.VisuCoreDataOffs',15));
    end

    % VisuCoreDataMin
    if isfield(exportVisu, 'VisuCoreDataMin') && ~isempty(exportVisu.VisuCoreDataMin)
        fprintf(FileID, '%s\n', ['##$VisuCoreDataMin=( ', num2str(VisuCoreFrameCount), ' ) ']);
        fprintf(FileID, '%s\n', num2str(exportVisu.VisuCoreDataMin',15));
    end

    % VisuCoreDataMax
    if isfield(exportVisu, 'VisuCoreDataMax') && ~isempty(exportVisu.VisuCoreDataMax)
        fprintf(FileID, '%s\n', ['##$VisuCoreDataMax=( ', num2str(VisuCoreFrameCount), ' ) ']);
        fprintf(FileID, '%s\n', num2str(exportVisu.VisuCoreDataMax',15));
    end

    % VisuCoreFrameType
    if isfield(exportVisu, 'VisuCoreFrameType') && ~isempty(exportVisu.VisuCoreFrameType)
        if iscell(exportVisu.VisuCoreFrameType)
            tmp='';
            for i=1:length(exportVisu.VisuCoreFrameType)
                tmp=[tmp, exportVisu.VisuCoreFrameType{i}, ' '];
            end
            fprintf(FileID, '%s\n', ['##$VisuCoreFrameType=( ', num2str(length(exportVisu.VisuCoreFrameType)), ' )'] );
            fprintf(FileID, '%s\n', tmp(1:end-1) );
            clear tmp;
        else
            fprintf(FileID, '%s\n', ['##$VisuCoreFrameType=', exportVisu.VisuCoreFrameType] );
        end
    end
    
    % VisuCoreWordType
    if isfield(exportVisu, 'VisuCoreWordType') && ~isempty(exportVisu.VisuCoreWordType)
        fprintf(FileID, '%s\n', ['##$VisuCoreWordType=', exportVisu.VisuCoreWordType]);
    end
    
    % VisuCoreByteOrder
    if isfield(exportVisu, 'VisuCoreByteOrder') && ~isempty(exportVisu.VisuCoreByteOrder)
        fprintf(FileID, '%s\n', ['##$VisuCoreByteOrder=', exportVisu.VisuCoreByteOrder]);
    end

    % VisuCoreTransposition
    if isfield(exportVisu, 'VisuCoreTransposition') && ~isempty(exportVisu.VisuCoreTransposition)
        fprintf(FileID, '%s\n', ['##$VisuCoreTransposition=( ', num2str(length(exportVisu.VisuCoreTransposition)), ' )']);
        fprintf(FileID, '%s\n', num2str(exportVisu.VisuCoreTransposition' ) );
    end
    
    %VisuCoreDiskSliceOrder
    if isfield(exportVisu, 'VisuCoreDiskSliceOrder') && ~isempty(exportVisu.VisuCoreDiskSliceOrder)
        fprintf(FileID, '%s\n', ['##$VisuCoreDiskSliceOrder=', exportVisu.VisuCoreDiskSliceOrder]);
    end
    
    % VisuFGOrderDescDim
    if isfield(exportVisu, 'VisuFGOrderDescDim') && ~isempty(exportVisu.VisuFGOrderDescDim)
        fprintf(FileID, '%s\n', ['##$VisuFGOrderDescDim=', num2str(size(exportVisu.VisuFGOrderDesc,2))]);
    end
    
    % VisuFGOrderDesc
    if isfield(exportVisu, 'VisuFGOrderDesc') && ~isempty(exportVisu.VisuFGOrderDesc)
        fprintf(FileID, '%s\n', ['##$VisuFGOrderDesc=( ', num2str(size(exportVisu.VisuFGOrderDesc,2)), ' )']);
        tmp='';
        for i=1:size(exportVisu.VisuFGOrderDesc,2)
            tmp=[tmp, sprintf('(%d, <%s>, <%s>, %d, %d) ', exportVisu.VisuFGOrderDesc{:,i})];
        end
        fprintf(FileID, '%s\n', tmp(1:end-1));
        clear tmp;
    end
    
    % VisuGroupDepVals
    if isfield(exportVisu, 'VisuGroupDepVals') && ~isempty(exportVisu.VisuGroupDepVals)
        fprintf(FileID, '%s\n', ['##$VisuGroupDepVals=( ', num2str(size(exportVisu.VisuGroupDepVals,2)), ' )']);
        tmp='';
        for i=1:size(exportVisu.VisuGroupDepVals,2)
            tmp=[tmp, sprintf('(<%s>, %d) ', exportVisu.VisuGroupDepVals{:,i})];
        end
        fprintf(FileID, '%s\n', tmp(1:end-1));
        clear tmp;
    end
    
    % VisuSubjectName
    if isfield(exportVisu, 'VisuSubjectName') && ~isempty(exportVisu.VisuSubjectName)
        fprintf(FileID, '%s\n', '##$VisuSubjectName=( 65 )');
        fprintf(FileID, '%s\n', ['<', exportVisu.VisuSubjectName, '>']);
    end
    
    % VisuSubjectId
    if isfield(exportVisu, 'VisuSubjectId') && ~isempty(exportVisu.VisuSubjectId)
        fprintf(FileID, '%s\n', '##$VisuSubjectId=( 65 )');
        fprintf(FileID, '%s\n', ['<', exportVisu.VisuSubjectId, '>']);
    end
    
    % VisuStudyUid
    if isfield(exportVisu, 'VisuStudyUid') && ~isempty(exportVisu.VisuStudyUid)
        fprintf(FileID, '%s\n', '##$VisuStudyUid=( 65 )');
        fprintf(FileID, '%s\n', ['<', exportVisu.VisuStudyUid, '>']);
    end  

    % VisuStudyId
    if isfield(exportVisu, 'VisuStudyId') && ~isempty(exportVisu.VisuStudyId)
        fprintf(FileID, '%s\n', '##$VisuStudyId=( 65 )');
        fprintf(FileID, '%s\n', ['<', exportVisu.VisuStudyId, '>']);
    end  
    
    % VisuStudyNumber
    if isfield(exportVisu, 'VisuStudyNumber') && ~isempty(exportVisu.VisuStudyNumber)
        fprintf(FileID, '%s\n', ['##$VisuStudyNumber=', num2str(exportVisu.VisuStudyNumber)]);
    end 
    
    % VisuExperimentNumber
    if isfield(exportVisu, 'VisuExperimentNumber') && ~isempty(exportVisu.VisuExperimentNumber)
        fprintf(FileID, '%s\n', ['##$VisuExperimentNumber=', num2str(exportVisu.VisuExperimentNumber)]);
    end
    
    % VisuProcesseingNumber
    if isfield(exportVisu, 'VisuProcessingNumber') && ~isempty(exportVisu.VisuProcessingNumber)
        fprintf(FileID, '%s\n', ['##$VisuProcessingNumber=', num2str(exportVisu.VisuProcessingNumber)]);
    end  
    
    % VisuSubjectPosition
    if isfield(exportVisu, 'VisuSubjectPosition') && ~isempty(exportVisu.VisuSubjectPosition)
        fprintf(FileID, '%s\n', ['##$VisuSubjectPosition=', exportVisu.VisuSubjectPosition]);
    end
    
    % VisuSeriesTypeId
    if isfield(exportVisu, 'VisuSeriesTypeId') && ~isempty(exportVisu.VisuSeriesTypeId)    
        fprintf(FileID, '%s\n', '##$VisuSeriesTypeId=( 65 )');
        fprintf(FileID, '%s\n', ['<', exportVisu.VisuSeriesTypeId, '>']);
    end
    


    fprintf(FileID, '%s\n', '##END=');
    fclose(FileID);
end    
    
    
    
    
    
    
    
    
    
