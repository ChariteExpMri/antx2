%    Save NIFTI dataset. Support both *.nii and *.hdr/*.img file extension.
%    If file extension is not provided, *.hdr/*.img will be used as default.
%    
%    Usage: save_nii(nii, filename, [old_RGB])
%    
%    nii.hdr - struct with NIFTI header fields (from load_nii.m or make_nii.m)
%  
%    nii.img - 3D (or 4D) matrix of NIFTI data.
%  
%    filename - NIFTI file name.
%  
%    old_RGB    - an optional boolean variable to handle special RGB data 
%         sequence [R1 R2 ... G1 G2 ... B1 B2 ...] that is used only by 
%         AnalyzeDirect (Analyze Software). Since both NIfTI and Analyze
%         file format use RGB triple [R1 G1 B1 R2 G2 B2 ...] sequentially
%         for each voxel, this variable is set to FALSE by default. If you
%         would like the saved image only to be opened by AnalyzeDirect 
%         Software, set old_RGB to TRUE (or 1). It will be set to 0, if it
%         is default or empty.
%    
%    Tip: to change the data type, set nii.hdr.dime.datatype,
%  	and nii.hdr.dime.bitpix to:
%   
%       0 None                     (Unknown bit per voxel) % DT_NONE, DT_UNKNOWN 
%       1 Binary                         (ubit1, bitpix=1) % DT_BINARY 
%       2 Unsigned char         (uchar or uint8, bitpix=8) % DT_UINT8, NIFTI_TYPE_UINT8 
%       4 Signed short                  (int16, bitpix=16) % DT_INT16, NIFTI_TYPE_INT16 
%       8 Signed integer                (int32, bitpix=32) % DT_INT32, NIFTI_TYPE_INT32 
%      16 Floating point    (single or float32, bitpix=32) % DT_FLOAT32, NIFTI_TYPE_FLOAT32 
%      32 Complex, 2 float32      (Use float32, bitpix=64) % DT_COMPLEX64, NIFTI_TYPE_COMPLEX64
%      64 Double precision  (double or float64, bitpix=64) % DT_FLOAT64, NIFTI_TYPE_FLOAT64 
%     128 Red-Green-Blue            (Use uint8, bitpix=24) % DT_RGB24, NIFTI_TYPE_RGB24 
%     256 Signed char            (schar or int8, bitpix=8) % DT_INT8, NIFTI_TYPE_INT8 
%     512 Unsigned short               (uint16, bitpix=16) % DT_UNINT16, NIFTI_TYPE_UNINT16 
%     768 Unsigned integer             (uint32, bitpix=32) % DT_UNINT32, NIFTI_TYPE_UNINT32 
%    1024 Signed long long              (int64, bitpix=64) % DT_INT64, NIFTI_TYPE_INT64
%    1280 Unsigned long long           (uint64, bitpix=64) % DT_UINT64, NIFTI_TYPE_UINT64 
%    1536 Long double, float128  (Unsupported, bitpix=128) % DT_FLOAT128, NIFTI_TYPE_FLOAT128 
%    1792 Complex128, 2 float64  (Use float64, bitpix=128) % DT_COMPLEX128, NIFTI_TYPE_COMPLEX128 
%    2048 Complex256, 2 float128 (Unsupported, bitpix=256) % DT_COMPLEX128, NIFTI_TYPE_COMPLEX128 
%    
%    Part of this file is copied and modified under GNU license from
%    MRI_TOOLBOX developed by CNSP in Flinders University, Australia
%  
%    NIFTI data format can be found on: http://nifti.nimh.nih.gov
%  
%    - Jimmy Shen (jimmy@rotman-baycrest.on.ca)
%    - "old_RGB" related codes in "save_nii.m" are added by Mike Harms (2006.06.28) 
%  
% 
%
