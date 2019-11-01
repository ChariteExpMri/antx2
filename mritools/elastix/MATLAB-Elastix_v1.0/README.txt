This very simple toolbox is intented to ease the use of elastix.exe 
and transformix.exe in a MATLAB friendly enviroment.

The main functions are run_elastix.m and run_transformix.m, which call
elastix.exe and transformix.exe, respectively.

There are also some functions to easily setup either parameters and
transformations text (ASCII) files:
- get_ix.m (gets properties from the files)
- set_ix.m (sets properties from the files)
- add_ix.m (adds new properties to the files)
- rm_ix.m  (removes properties from the files)

The rest of the functions are:
- invert_transformation.m (inverts a transformation)
- create_def_file.m (creates a transformation pointing to a deformation 
  field image)
- avg_transformations.m (creates a transformation which can be used to
  calculate the average trnasformation from several transformation files)

I hope this toolbox will be of help for those adicts to MATLAB

Any comment, suggestion and addition will be gratefully received

April 2011

Pedro Antonio Valdés Hernández
Neuroimaging Department
Cuban Neuroscience Center