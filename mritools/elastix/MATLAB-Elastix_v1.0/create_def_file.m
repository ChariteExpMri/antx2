function def_tfile = create_def_file(tfile)

% create_def_file creates a text(ASCII) transformation file ("def_tfile") 
% pointing to the deformation field (stored in an image) of a standard 
% transformation file ("tfile").
% This approach is useful when the transformation in "tfile" consists on 
% the concatenation of multiple transformation files and it is desired to
% evaluated many times, e.g. in the construction of a template. In such
% cases the final concatenated transformation must be interpolated each
% time it is evaluated while the transformation in "def_tfile" is already 
% interpolated and saved once.
% Applying either "tfile" or "def_tfile" to an image produces the same
% result, but the latter is faster when the former consists on multiple
% concatenations
%
% Usage:
% def_tfile = create_def_file(tfile)
% 
% ------------------------------Inputs-------------------------------------
% tfile: text(ASCII) transformation file
%
% ------------------------------Outputs------------------------------------
% def_tfile: text(ASCII) transformation file pointing to the deformation
%            field of "tfile" (the same name of "tfile" postfixed by '-def') 
%
% 5/3/2011
% version 1.0b
% 
% Pedro Antonio Valdés Hernández
% Neuroimaging Department
% Cuban Neuroscience Center

[junk,def_file] = run_transformix('','',tfile,'','def');
[pp,nn,ee] = fileparts(def_file); %#ok<NASGU>
def_tfile = fullfile(pp,[nn '.txt']);
copyfile(tfile,def_tfile);
%---
set_ix(def_tfile,'Transform','DeformationFieldTransform');
add_ix(def_tfile,'DeformationFieldFileName',def_file,3);
set_ix(def_tfile,'NumberOfParameters',1);
add_ix(def_tfile,'DeformationFieldInterpolationOrder',1,4);
warning off %#ok<WNOFF>
% removing known properties that should not be in the file, more can be
% added
rm_ix(def_tfile,'TransformParameters');
rm_ix(def_tfile,'InitialTransformParametersFileName');
rm_ix(def_tfile,'NormalizeCombinationWeights');
rm_ix(def_tfile,'SubTransforms');
warning on %#ok<WNON>