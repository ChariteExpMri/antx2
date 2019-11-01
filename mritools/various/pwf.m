 
function  varargout =pwf

%PWF Show+CLIPBOARD filename+PATH+description of Editor's on top file

% % % print working file (print currently opened file  in editor)
try
    % Matlab 7
    desktop = com.mathworks.mde.desk.MLDesktop.getInstance;
    jEditor = desktop.getGroupContainer('Editor').getTopLevelAncestor;
    % we get a com.mathworks.mde.desk.MLMultipleClientFrame object
catch
    % Matlab 6
    % Unfortunately, we can't get the Editor handle from the Desktop handle in Matlab 6:
    %desktop = com.mathworks.ide.desktop.MLDesktop.getMLDesktop;
 
    % So here's the workaround for Matlab 6:
    openDocs = com.mathworks.ide.editor.EditorApplication.getOpenDocuments;  % a java.util.Vector
    firstDoc = openDocs.elementAt(0);  % a com.mathworks.ide.editor.EditorViewContainer object
    jEditor = firstDoc.getParent.getParent.getParent;
    % we get a com.mathworks.mwt.MWTabPanel or com.mathworks.ide.desktop.DTContainer object
end


title = jEditor.getTitle;
currentFilename = char(title.replaceFirst('Editor - ',''));

txt=help(currentFilename);
txt=txt(1:min(strfind(txt,char(10))));
out=[' ' currentFilename ' - ' txt];
disp(out);
clipboard('copy',out);

txt=help(currentFilename);
txt=txt(1:min(strfind(txt,char(10))));
% out=[' ' currentFilename ' - ' txt];

[pa fi ext]=fileparts(currentFilename);
stuff=[[fi ext ' - ' txt] sprintf('\t\t')  currentFilename ];
clipboard('copy',stuff);
disp(stuff);

if nargout~=0
    varargout{1}=out;
end


return
%% get all open files
if 0

% Alternative #1:
edhandle = com.mathworks.mlservices.MLEditorServices;
allEditorFilenames = char(edhandle.builtinGetOpenDocumentNames);
 
% Alternative #2:
openFiles = desktop.getWindowRegistry.getClosers.toArray.cell;
allEditorFilenames = cellfun(@(c)c.getTitle.char,openFiles,'un',0);
end


% % Equivalent actions via properties:
% set(jEditor, 'Resizable', 'on');
% set(jEditor, 'StatusText', 'testing 123...');
% set(jEditor, 'Title', 'This is the Matlab Editor');
% 

