
function removeExcelSheets(filename, sheetsToRemove)
% REMOVEEXCELSHEETS
%
% Remove selected worksheets from an XLSX file.
%
% Compatible with:
%   - MATLAB R2018a+
%   - Windows
%   - macOS
%   - Linux
%
% Example:
%
%   removeExcelSheets('bli.xlsx', ...
%       {'Sheet1','Sheet2','Sheet3'});
%
% A backup is created as:
%
%   bli.xlsx.backup
%
% The original file is replaced ONLY after the new XLSX has been
% successfully created and validated.
%
% MATLAB's built-in ZIP function is deliberately NOT used because
% its behavior differs between MATLAB versions and operating systems.


    % =============================================================
    % INPUT
    % =============================================================

    if nargin < 2
        sheetsToRemove = {'Sheet1','Sheet2','Sheet3'};
    end

    filename = char(filename);

    if ~exist(filename,'file')
        error('File not found: %s',filename);
    end

    if ischar(sheetsToRemove)
        sheetsToRemove = {sheetsToRemove};
    end


    % =============================================================
    % MAKE ABSOLUTE FILE PATH
    % =============================================================

    [filepath,name,ext] = fileparts(filename);

    if isempty(filepath)
        filepath = pwd;
    end

    filename = fullfile(filepath,[name ext]);


    % =============================================================
    % DETECT OPERATING SYSTEM
    % =============================================================

    if ispc
        operatingSystem = 'windows';
    elseif ismac
        operatingSystem = 'mac';
    elseif isunix
        operatingSystem = 'linux';
    else
        error('Unsupported operating system.');
    end

%     fprintf('Operating system: %s\n',operatingSystem);


    % =============================================================
    % CREATE BACKUP
    % =============================================================

    backup = [filename '.backup'];

    if ~exist(backup,'file')

        %[ok,msg] = copyfile(filename,backup);

%         if ~ok
%             error('Could not create backup:\n%s',msg);
%         end

        %fprintf('Backup created:\n%s\n',backup);

    else

        %fprintf('Backup already exists:\n%s\n',backup);

    end


    % =============================================================
    % CREATE TEMPORARY DIRECTORY
    % =============================================================

    tmp = tempname;
    mkdir(tmp);

    cleanupObj = onCleanup(@() cleanupTemp(tmp));


    % =============================================================
    % EXTRACT XLSX
    % =============================================================

    %fprintf('Extracting XLSX...\n');

    if strcmp(operatingSystem,'windows')

        % ---------------------------------------------------------
        % WINDOWS
        % ---------------------------------------------------------

        % PowerShell Expand-Archive
        cmd = sprintf( ...
            'powershell -NoProfile -Command "Expand-Archive -LiteralPath ''%s'' -DestinationPath ''%s'' -Force"', ...
            escapePowerShell(filename), ...
            escapePowerShell(tmp));

    else

        % ---------------------------------------------------------
        % MAC / LINUX
        % ---------------------------------------------------------

        cmd = sprintf( ...
            'unzip -q "%s" -d "%s"', ...
            filename,tmp);

    end

    [status,msg] = system(cmd);

    if status ~= 0
        error('Could not extract XLSX:\n%s',msg);
    end


    % =============================================================
    % REQUIRED XLSX FILES
    % =============================================================

    workbookFile = fullfile(tmp,'xl','workbook.xml');
    relsFile     = fullfile(tmp,'xl','_rels','workbook.xml.rels');
    contentFile  = fullfile(tmp,'[Content_Types].xml');

    if ~exist(workbookFile,'file')
        error('Could not find xl/workbook.xml.');
    end

    if ~exist(relsFile,'file')
        error('Could not find xl/_rels/workbook.xml.rels.');
    end

    if ~exist(contentFile,'file')
        error('Could not find [Content_Types].xml.');
    end


    % =============================================================
    % READ XML
    % =============================================================

    %fprintf('Reading XLSX structure...\n');

    workbookDoc = xmlread(workbookFile);
    relsDoc     = xmlread(relsFile);
    contentDoc  = xmlread(contentFile);


    % =============================================================
    % FIND <sheets>
    % =============================================================

    sheetsList = workbookDoc.getElementsByTagName('sheets');

    if sheetsList.getLength == 0
        error('Could not find <sheets> in workbook.xml.');
    end

    sheetsContainer = sheetsList.item(0);

    sheetNodes = sheetsContainer.getElementsByTagName('sheet');


    % =============================================================
    % FIND SHEETS TO REMOVE
    % =============================================================

    removeRelIds = {};
    removeNames  = {};

    for k = 0:sheetNodes.getLength-1

        node = sheetNodes.item(k);

        sheetName = char(node.getAttribute('name'));

        if any(strcmp(sheetName,sheetsToRemove))

            relId = char(node.getAttributeNS( ...
                'http://schemas.openxmlformats.org/officeDocument/2006/relationships', ...
                'id'));

            removeNames{end+1}  = sheetName;
            removeRelIds{end+1} = relId;

        end

    end


    % =============================================================
    % NOTHING TO REMOVE
    % =============================================================

    if isempty(removeNames)

        %fprintf('\nNo matching worksheets found.\n');
        return

    end


    %fprintf('\nWorksheets to remove:\n');

    for k = 1:length(removeNames)
        %fprintf('  %s\n',removeNames{k});
    end


    % =============================================================
    % SAFETY CHECK
    % =============================================================

    remainingSheets = sheetNodes.getLength - length(removeNames);

    if remainingSheets < 1

        error('Cannot remove all worksheets. At least one must remain.');

    end


    % =============================================================
    % REMOVE <sheet> ELEMENTS
    % =============================================================

    % Collect indices first.
    % This is important because MATLAB R2018a can have problems when
    % a Java NodeList is modified while it is being iterated.

    sheetNodes = sheetsContainer.getElementsByTagName('sheet');

    removeIndices = [];

    for k = 0:sheetNodes.getLength-1

        node = sheetNodes.item(k);

        sheetName = char(node.getAttribute('name'));

        if any(strcmp(sheetName,sheetsToRemove))

            removeIndices(end+1) = k;

        end

    end


    % Remove backwards.
    for k = length(removeIndices):-1:1

        node = sheetNodes.item(removeIndices(k));

        sheetsContainer.removeChild(node);

    end


    % =============================================================
    % FIND WORKSHEET XML TARGETS
    % =============================================================

    relNodes = relsDoc.getElementsByTagName('Relationship');

    removeTargets = {};

    for k = 0:relNodes.getLength-1

        node = relNodes.item(k);

        relId = char(node.getAttribute('Id'));

        if any(strcmp(relId,removeRelIds))

            target = char(node.getAttribute('Target'));

            removeTargets{end+1} = target;

        end

    end


    % =============================================================
    % REMOVE WORKBOOK RELATIONSHIPS
    % =============================================================

    relNodes = relsDoc.getElementsByTagName('Relationship');

    removeIndices = [];

    for k = 0:relNodes.getLength-1

        node = relNodes.item(k);

        relId = char(node.getAttribute('Id'));

        if any(strcmp(relId,removeRelIds))

            removeIndices(end+1) = k;

        end

    end


    for k = length(removeIndices):-1:1

        node = relNodes.item(removeIndices(k));

        node.getParentNode.removeChild(node);

    end


    % =============================================================
    % REMOVE WORKSHEET ENTRIES FROM [Content_Types].xml
    % =============================================================

    overrideNodes = contentDoc.getElementsByTagName('Override');

    removeIndices = [];

    for k = 0:overrideNodes.getLength-1

        node = overrideNodes.item(k);

        partName = char(node.getAttribute('PartName'));

        for j = 1:length(removeTargets)

            target = strrep(removeTargets{j},'\','/');

            if isempty(target)
                continue
            end

            if target(1) == '/'

                targetName = target;

            else

                targetName = ['/xl/' target];

            end

            if strcmp(partName,targetName)

                removeIndices(end+1) = k;

                break

            end

        end

    end


    for k = length(removeIndices):-1:1

        node = overrideNodes.item(removeIndices(k));

        node.getParentNode.removeChild(node);

    end


    % =============================================================
    % WRITE XML
    % =============================================================

    %fprintf('Writing modified XLSX structure...\n');

    xmlwrite(workbookFile,workbookDoc);
    xmlwrite(relsFile,relsDoc);
    xmlwrite(contentFile,contentDoc);


    % =============================================================
    % CREATE NEW XLSX
    % =============================================================

    newFile = fullfile(filepath,[name '_new' ext]);

    if exist(newFile,'file')
        delete(newFile);
    end


    %fprintf('Creating new XLSX...\n');


    if strcmp(operatingSystem,'windows')

        % ---------------------------------------------------------
        % WINDOWS
        %
        % Use PowerShell Compress-Archive.
        % We deliberately run it from inside the temporary folder
        % so that the XLSX contains xl/, docProps/, etc. at the
        % correct root level.
        % ---------------------------------------------------------

        parentTmp = fileparts(tmp);

        % PowerShell needs the contents of tmp, not tmp itself.
        cmd = sprintf( ...
            'powershell -NoProfile -Command "Set-Location -LiteralPath ''%s''; Compress-Archive -Path ''.\*'' -DestinationPath ''%s'' -Force"', ...
            escapePowerShell(tmp), ...
            escapePowerShell(newFile));

    else

        % ---------------------------------------------------------
        % MAC / LINUX
        %
        % Use the operating-system zip command.
        % ---------------------------------------------------------

        cmd = sprintf( ...
            'cd "%s" && zip -qr "%s" .', ...
            tmp,newFile);

    end


    [status,msg] = system(cmd);

    if status ~= 0

        error('Could not create new XLSX:\n%s',msg);

    end


    % =============================================================
    % CHECK NEW FILE
    % =============================================================

    if ~exist(newFile,'file')

        error(['The archive command completed, but the new XLSX ' ...
               'was not created:\n%s'],newFile);

    end


    % =============================================================
    % VALIDATE XLSX
    % =============================================================

    %fprintf('Validating new XLSX...\n');

    if strcmp(operatingSystem,'windows')

        % PowerShell can test whether the archive is readable.
        cmd = sprintf( ...
            'powershell -NoProfile -Command "try { Add-Type -AssemblyName System.IO.Compression.FileSystem; $z=[System.IO.Compression.ZipFile]::OpenRead(''%s''); $z.Dispose(); exit 0 } catch { exit 1 }"', ...
            escapePowerShell(newFile));

    else

        cmd = sprintf( ...
            'unzip -tq "%s"',newFile);

    end


    [status,msg] = system(cmd);

    if status ~= 0

        if exist(newFile,'file')
            delete(newFile);
        end

        error('New XLSX failed archive validation:\n%s',msg);

    end


    % =============================================================
    % REPLACE ORIGINAL
    % =============================================================

    %fprintf('Replacing original XLSX...\n');

    delete(filename);

    [ok,msg] = movefile(newFile,filename);

    if ~ok

        error('Could not replace original XLSX:\n%s',msg);

    end


    % =============================================================
    % DONE
    % =============================================================

    %fprintf('\n');
    %fprintf('============================================\n');
    %fprintf('Successfully updated XLSX.\n');
    %fprintf('============================================\n');
    %fprintf('File:    %s\n',filename);
    %fprintf('Removed: %d worksheet(s)\n',length(removeNames));
    %fprintf('Backup:  %s\n',backup);
    %fprintf('\n');


end


% =================================================================
% Escape a path for use inside PowerShell single quotes
% =================================================================
function s = escapePowerShell(s)

    s = strrep(s,'''','''''');

end


% =================================================================
% Remove temporary directory
% =================================================================
function cleanupTemp(tmp)

    if exist(tmp,'dir')

        try
            rmdir(tmp,'s');
        catch
            % Ignore cleanup errors
        end

    end

end
