%    Make nii structure specified by an N-D matrix. Usually, N is 3 for
%    3D matrix [x y z], or 4 for 4D matrix with time series [x y z t]. 
%    However, NIfTI allows a maximum of 7D matrix. For RGB24 datatype, an
%    extra dimension for RGB should be inserted immediately after [x y z].
%    Optional parameters can also be included, such as: voxel_size, 
%    origin, datatype, and description.
%    
%    Usage: nii = make_nii(img, [voxel_size], [origin], [datatype], ...
%  		[description])
%  
%    Where:
%  
%  	img:		Usually, img is a 3D matrix [x y z], or a 4D
%  			matrix with time series [x y z t]. However,
%  			NIfTI allows a maximum of 7D matrix. For RGB
%  			datatype, an extra dimension for RGB should
%  			be inserted immediately after [x y z].
%  
%  	voxel_size (optional):	Voxel size in millimeter for each
%  				dimension. Default is [1 1 1].
%  
%  	origin (optional):	The AC origin. Default is [0 0 0].
%  
%  	datatype (optional):	Storage data type:
%  		2 - uint8,  4 - int16,  8 - int32,  16 - float32,
%  		32 - complex64,  64 - float64,  128 - RGB24,
%  		256 - int8,  512 - uint16,  768 - uint32, 
%  		1792 - complex128
%  			Default will use the data type of 'img' matrix
%  
%  	description (optional):	Description of data. Default is ''.
%  
%    e.g.:
%       origin = [33 44 13]; datatype = 64;
%       nii = make_nii(img, [], origin, datatype);    % default voxel_size
%  
%    NIFTI data format can be found on: http://nifti.nimh.nih.gov
%  
%    - Jimmy Shen (jimmy@rotman-baycrest.on.ca)
%  
% 
%
