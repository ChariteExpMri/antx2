
%example: reslice image: apply the image's transformation matrix from the NIFTI-header (hdr.mat) of the
% inputfile with rotation/flips. The resulting output file (outputfile) is resliced in this way 
% and the off-diagonal elements of the hrd.mat contains only zeros:
% - the "0" refers to verbose off
% reslice_nii2(inputfile, outputfile,[],0)
%% ===============================================
%  The basic application of the 'reslice_nii.m' program is to perform
%  any 3D affine transform defined by a NIfTI format image.
%
%  In addition, the 'reslice_nii.m' program can also be applied to
%  generate an isotropic image from either a NIfTI format image or
%  an ANALYZE format image.
%
%  The resliced NIfTI file will always be in RAS orientation.
%
%  This program only supports real integer or floating-point data type.
%  For other data type, the program will exit with an error message 
%  "Transform of this NIFTI data is not supported by the program".
%
%  Usage: reslice_nii(old_fn, new_fn, [voxel_size], [verbose], [bg], ...
%			[db], [img_idx], [preferredForm]);
%
%  old_fn  -	filename for original NIfTI file
%
%  new_fn  -	filename for resliced NIfTI file
%
%  voxel_size (optional)  - size of a voxel in millimeter along x y z
%		direction for resliced NIfTI file. 'voxel_size' will use
%		the minimum voxel_size in original NIfTI header,
%		if it is default or empty.
%
%  verbose (optional) - 1, 0
%			1:  show transforming progress in percentage
%			2:  progress will not be displayed
%			'verbose' is 1 if it is default or empty.
%
%  bg (optional)  -	background voxel intensity in any extra corner that
%			is caused by 3D interpolation. 0 in most cases. 'bg'
%			will be the average of two corner voxel intensities
%			in original image volume, if it is default or empty.
%
%  method (optional)  -	1, 2, or 3
%			1:  for Trilinear interpolation
%			2:  for Nearest Neighbor interpolation
%			3:  for Fischer's Bresenham interpolation
%			'method' is 1 if it is default or empty.
%
%  img_idx (optional)  -  a numerical array of image volume indices. Only
%		the specified volumes will be loaded. All available image
%		volumes will be loaded, if it is default or empty.
%
%	The number of images scans can be obtained from get_nii_frame.m,
%	or simply: hdr.dime.dim(5).
%
%  preferredForm (optional)  -  selects which transformation from voxels
%	to RAS coordinates; values are s,q,S,Q.  Lower case s,q indicate
%	"prefer sform or qform, but use others if preferred not present". 
%	Upper case indicate the program is forced to use the specificied
%	tranform or fail loading.  'preferredForm' will be 's', if it is
%	default or empty.	- Jeff Gunter
%
%  NIFTI data format can be found on: http://nifti.nimh.nih.gov
%  
%  - Jimmy Shen (jshen@research.baycrest.org)
%
function reslice_nii(old_fn, new_fn, voxel_size, verbose, bg, method, img_idx, preferredForm)

   if ~exist('old_fn','var') | ~exist('new_fn','var')
      error('Usage: reslice_nii(old_fn, new_fn, [voxel_size], [verbose], [bg], [method], [img_idx])');
   end

   if ~exist('method','var') | isempty(method)
      method = 1;
   end

   if ~exist('img_idx','var') | isempty(img_idx)
      img_idx = [];
   end

   if ~exist('verbose','var') | isempty(verbose)
      verbose = 1;
   end

   if ~exist('preferredForm','var') | isempty(preferredForm)
      preferredForm= 's';				% Jeff
   end

   nii = load_nii_no_xform(old_fn, img_idx, 0, preferredForm);

   if ~ismember(nii.hdr.dime.datatype, [2,4,8,16,64,256,512,768])
      error('Transform of this NIFTI data is not supported by the program.');
   end

   if ~exist('voxel_size','var') | isempty(voxel_size)
      voxel_size = abs(min(nii.hdr.dime.pixdim(2:4)))*ones(1,3);
   elseif length(voxel_size) < 3
      voxel_size = abs(voxel_size(1))*ones(1,3);
   end

   if ~exist('bg','var') | isempty(bg)
      bg = mean([nii.img(1) nii.img(end)]);
   end

   old_M = nii.hdr.hist.old_affine;

   if nii.hdr.dime.dim(5) > 1
      for i = 1:nii.hdr.dime.dim(5)
         if verbose
            fprintf('Reslicing %d of %d volumes.\n', i, nii.hdr.dime.dim(5));
         end

         [img(:,:,:,i) M] = ...
		affine(nii.img(:,:,:,i), old_M, voxel_size, verbose, bg, method);
      end
   else
      [img M] = affine(nii.img, old_M, voxel_size, verbose, bg, method);
   end

   new_dim = size(img);
   nii.img = img;
   nii.hdr.dime.dim(2:4) = new_dim(1:3);
   nii.hdr.dime.datatype = 16;
   nii.hdr.dime.bitpix = 32;
   nii.hdr.dime.pixdim(2:4) = voxel_size(:)';
   nii.hdr.dime.glmax = max(img(:));
   nii.hdr.dime.glmin = min(img(:));
   nii.hdr.hist.qform_code = 0;
   nii.hdr.hist.sform_code = 1;
   nii.hdr.hist.srow_x = M(1,:);
   nii.hdr.hist.srow_y = M(2,:);
   nii.hdr.hist.srow_z = M(3,:);
   nii.hdr.hist.new_affine = M;

   save_nii(nii, new_fn);

   return;					% reslice_nii


%--------------------------------------------------------------------
function [nii] = load_nii_no_xform(filename, img_idx, old_RGB, preferredForm)

   if ~exist('filename','var'),
      error('Usage: [nii] = load_nii(filename, [img_idx], [old_RGB])');
   end
   
   if ~exist('img_idx','var'), img_idx = []; end
   if ~exist('old_RGB','var'), old_RGB = 0; end
   if ~exist('preferredForm','var'), preferredForm= 's'; end     % Jeff

   v = version;

   %  Check file extension. If .gz, unpack it into temp folder
   %
   if length(filename) > 2 & strcmp(filename(end-2:end), '.gz')

      if ~strcmp(filename(end-6:end), '.img.gz') & ...
	 ~strcmp(filename(end-6:end), '.hdr.gz') & ...
	 ~strcmp(filename(end-6:end), '.nii.gz')

         error('Please check filename.');
      end

      if str2num(v(1:3)) < 7.1 | ~usejava('jvm')
         error('Please use MATLAB 7.1 (with java) and above, or run gunzip outside MATLAB.');
      elseif strcmp(filename(end-6:end), '.img.gz')
         filename1 = filename;
         filename2 = filename;
         filename2(end-6:end) = '';
         filename2 = [filename2, '.hdr.gz'];

         tmpDir = tempname;
         mkdir(tmpDir);
         gzFileName = filename;

         filename1 = gunzip(filename1, tmpDir);
         filename2 = gunzip(filename2, tmpDir);
         filename = char(filename1);	% convert from cell to string
      elseif strcmp(filename(end-6:end), '.hdr.gz')
         filename1 = filename;
         filename2 = filename;
         filename2(end-6:end) = '';
         filename2 = [filename2, '.img.gz'];

         tmpDir = tempname;
         mkdir(tmpDir);
         gzFileName = filename;

         filename1 = gunzip(filename1, tmpDir);
         filename2 = gunzip(filename2, tmpDir);
         filename = char(filename1);	% convert from cell to string
      elseif strcmp(filename(end-6:end), '.nii.gz')
         tmpDir = tempname;
         mkdir(tmpDir);
         gzFileName = filename;
         filename = gunzip(filename, tmpDir);
         filename = char(filename);	% convert from cell to string
      end
   end

   %  Read the dataset header
   %
   [nii.hdr,nii.filetype,nii.fileprefix,nii.machine] = load_nii_hdr(filename);

   %  Read the header extension
   %
%   nii.ext = load_nii_ext(filename);
   
   %  Read the dataset body
   %
   [nii.img,nii.hdr] = ...
        load_nii_img(nii.hdr,nii.filetype,nii.fileprefix,nii.machine,img_idx,'','','',old_RGB);
   
   %  Perform some of sform/qform transform
   %
%   nii = xform_nii(nii, preferredForm);

   %  Clean up after gunzip
   %
   if exist('gzFileName', 'var')

      %  fix fileprefix so it doesn't point to temp location
      %
      nii.fileprefix = gzFileName(1:end-7);
      rmdir(tmpDir,'s');
   end


   hdr = nii.hdr;

   %  NIFTI can have both sform and qform transform. This program
   %  will check sform_code prior to qform_code by default.
   %
   %  If user specifys "preferredForm", user can then choose the
   %  priority.					- Jeff
   %
   useForm=[];					% Jeff

   if isequal(preferredForm,'S')
       if isequal(hdr.hist.sform_code,0)
           error('User requires sform, sform not set in header');
       else
           useForm='s';
       end
   end						% Jeff

   if isequal(preferredForm,'Q')
       if isequal(hdr.hist.qform_code,0)
           error('User requires sform, sform not set in header');
       else
           useForm='q';
       end
   end						% Jeff

   if isequal(preferredForm,'s')
       if hdr.hist.sform_code > 0
           useForm='s';
       elseif hdr.hist.qform_code > 0
           useForm='q';
       end
   end						% Jeff
   
   if isequal(preferredForm,'q')
       if hdr.hist.qform_code > 0
           useForm='q';
       elseif hdr.hist.sform_code > 0
           useForm='s';
       end
   end						% Jeff

   if isequal(useForm,'s')
      R = [hdr.hist.srow_x(1:3)
           hdr.hist.srow_y(1:3)
           hdr.hist.srow_z(1:3)];

      T = [hdr.hist.srow_x(4)
           hdr.hist.srow_y(4)
           hdr.hist.srow_z(4)];

      nii.hdr.hist.old_affine = [ [R;[0 0 0]] [T;1] ];

   elseif isequal(useForm,'q')
      b = hdr.hist.quatern_b;
      c = hdr.hist.quatern_c;
      d = hdr.hist.quatern_d;

      if 1.0-(b*b+c*c+d*d) < 0
         if abs(1.0-(b*b+c*c+d*d)) < 1e-5
            a = 0;
         else
            error('Incorrect quaternion values in this NIFTI data.');
         end
      else
         a = sqrt(1.0-(b*b+c*c+d*d));
      end

      qfac = hdr.dime.pixdim(1);
      i = hdr.dime.pixdim(2);
      j = hdr.dime.pixdim(3);
      k = qfac * hdr.dime.pixdim(4);

      R = [a*a+b*b-c*c-d*d     2*b*c-2*a*d        2*b*d+2*a*c
           2*b*c+2*a*d         a*a+c*c-b*b-d*d    2*c*d-2*a*b
           2*b*d-2*a*c         2*c*d+2*a*b        a*a+d*d-c*c-b*b];

      T = [hdr.hist.qoffset_x
           hdr.hist.qoffset_y
           hdr.hist.qoffset_z];

      nii.hdr.hist.old_affine = [ [R * diag([i j k]);[0 0 0]] [T;1] ];

   elseif nii.filetype == 0 & exist([nii.fileprefix '.mat'],'file')
      load([nii.fileprefix '.mat']);	% old SPM affine matrix
      R=M(1:3,1:3);
      T=M(1:3,4);
      T=R*ones(3,1)+T;
      M(1:3,4)=T;
      nii.hdr.hist.old_affine = M;

   else
      M = diag(hdr.dime.pixdim(2:5));
      M(1:3,4) = -M(1:3,1:3)*(hdr.hist.originator(1:3)-1)';
      M(4,4) = 1;
      nii.hdr.hist.old_affine = M;
   end

   return					% load_nii_no_xform

%  Save NIFTI dataset. Support both *.nii and *.hdr/*.img file extension.
%  If file extension is not provided, *.hdr/*.img will be used as default.
%  
%  Usage: save_nii(nii, filename, [old_RGB])
%  
%  nii.hdr - struct with NIFTI header fields (from load_nii.m or make_nii.m)
%
%  nii.img - 3D (or 4D) matrix of NIFTI data.
%
%  filename - NIFTI file name.
%
%  old_RGB    - an optional boolean variable to handle special RGB data 
%       sequence [R1 R2 ... G1 G2 ... B1 B2 ...] that is used only by 
%       AnalyzeDirect (Analyze Software). Since both NIfTI and Analyze
%       file format use RGB triple [R1 G1 B1 R2 G2 B2 ...] sequentially
%       for each voxel, this variable is set to FALSE by default. If you
%       would like the saved image only to be opened by AnalyzeDirect 
%       Software, set old_RGB to TRUE (or 1). It will be set to 0, if it
%       is default or empty.
%  
%  Tip: to change the data type, set nii.hdr.dime.datatype,
%	and nii.hdr.dime.bitpix to:
% 
%     0 None                     (Unknown bit per voxel) % DT_NONE, DT_UNKNOWN 
%     1 Binary                         (ubit1, bitpix=1) % DT_BINARY 
%     2 Unsigned char         (uchar or uint8, bitpix=8) % DT_UINT8, NIFTI_TYPE_UINT8 
%     4 Signed short                  (int16, bitpix=16) % DT_INT16, NIFTI_TYPE_INT16 
%     8 Signed integer                (int32, bitpix=32) % DT_INT32, NIFTI_TYPE_INT32 
%    16 Floating point    (single or float32, bitpix=32) % DT_FLOAT32, NIFTI_TYPE_FLOAT32 
%    32 Complex, 2 float32      (Use float32, bitpix=64) % DT_COMPLEX64, NIFTI_TYPE_COMPLEX64
%    64 Double precision  (double or float64, bitpix=64) % DT_FLOAT64, NIFTI_TYPE_FLOAT64 
%   128 uint RGB                  (Use uint8, bitpix=24) % DT_RGB24, NIFTI_TYPE_RGB24 
%   256 Signed char            (schar or int8, bitpix=8) % DT_INT8, NIFTI_TYPE_INT8 
%   511 Single RGB              (Use float32, bitpix=96) % DT_RGB96, NIFTI_TYPE_RGB96
%   512 Unsigned short               (uint16, bitpix=16) % DT_UNINT16, NIFTI_TYPE_UNINT16 
%   768 Unsigned integer             (uint32, bitpix=32) % DT_UNINT32, NIFTI_TYPE_UNINT32 
%  1024 Signed long long              (int64, bitpix=64) % DT_INT64, NIFTI_TYPE_INT64
%  1280 Unsigned long long           (uint64, bitpix=64) % DT_UINT64, NIFTI_TYPE_UINT64 
%  1536 Long double, float128  (Unsupported, bitpix=128) % DT_FLOAT128, NIFTI_TYPE_FLOAT128 
%  1792 Complex128, 2 float64  (Use float64, bitpix=128) % DT_COMPLEX128, NIFTI_TYPE_COMPLEX128 
%  2048 Complex256, 2 float128 (Unsupported, bitpix=256) % DT_COMPLEX128, NIFTI_TYPE_COMPLEX128 
%  
%  Part of this file is copied and modified from:
%  http://www.mathworks.com/matlabcentral/fileexchange/1878-mri-analyze-tools
%
%  NIFTI data format can be found on: http://nifti.nimh.nih.gov
%
%  - Jimmy Shen (jimmy@rotman-baycrest.on.ca)
%  - "old_RGB" related codes in "save_nii.m" are added by Mike Harms (2006.06.28) 
%
function save_nii(nii, fileprefix, old_RGB)
   
   if ~exist('nii','var') | isempty(nii) | ~isfield(nii,'hdr') | ...
	~isfield(nii,'img') | ~exist('fileprefix','var') | isempty(fileprefix)

      error('Usage: save_nii(nii, filename, [old_RGB])');
   end

   if isfield(nii,'untouch') & nii.untouch == 1
      error('Usage: please use ''save_untouch_nii.m'' for the untouched structure.');
   end

   if ~exist('old_RGB','var') | isempty(old_RGB)
      old_RGB = 0;
   end

   v = version;

   %  Check file extension. If .gz, unpack it into temp folder
   %
   if length(fileprefix) > 2 & strcmp(fileprefix(end-2:end), '.gz')

      if ~strcmp(fileprefix(end-6:end), '.img.gz') & ...
	 ~strcmp(fileprefix(end-6:end), '.hdr.gz') & ...
	 ~strcmp(fileprefix(end-6:end), '.nii.gz')

         error('Please check filename.');
      end

      if str2num(v(1:3)) < 7.1 | ~usejava('jvm')
         error('Please use MATLAB 7.1 (with java) and above, or run gunzip outside MATLAB.');
      else
         gzFile = 1;
         fileprefix = fileprefix(1:end-3);
      end
   end
   
   filetype = 1;

   %  Note: fileprefix is actually the filename you want to save
   %   
   if findstr('.nii',fileprefix) & strcmp(fileprefix(end-3:end), '.nii')
      filetype = 2;
      fileprefix(end-3:end)='';
   end
   
   if findstr('.hdr',fileprefix) & strcmp(fileprefix(end-3:end), '.hdr')
      fileprefix(end-3:end)='';
   end
   
   if findstr('.img',fileprefix) & strcmp(fileprefix(end-3:end), '.img')
      fileprefix(end-3:end)='';
   end

   write_nii(nii, filetype, fileprefix, old_RGB);

   %  gzip output file if requested
   %
   if exist('gzFile', 'var')
      if filetype == 1
         gzip([fileprefix, '.img']);
         delete([fileprefix, '.img']);
         gzip([fileprefix, '.hdr']);
         delete([fileprefix, '.hdr']);
      elseif filetype == 2
         gzip([fileprefix, '.nii']);
         delete([fileprefix, '.nii']);
      end;
   end;

   if filetype == 1

      %  So earlier versions of SPM can also open it with correct originator
      %
      M=[[diag(nii.hdr.dime.pixdim(2:4)) -[nii.hdr.hist.originator(1:3).*nii.hdr.dime.pixdim(2:4)]'];[0 0 0 1]];
      save([fileprefix '.mat'], 'M');
   end
   
   return					% save_nii


%-----------------------------------------------------------------------------------
function write_nii(nii, filetype, fileprefix, old_RGB)

   hdr = nii.hdr;

   if isfield(nii,'ext') & ~isempty(nii.ext)
      ext = nii.ext;
      [ext, esize_total] = verify_nii_ext(ext);
   else
      ext = [];
   end

   switch double(hdr.dime.datatype),
   case   1,
      hdr.dime.bitpix = int16(1 ); precision = 'ubit1';
   case   2,
      hdr.dime.bitpix = int16(8 ); precision = 'uint8';
   case   4,
      hdr.dime.bitpix = int16(16); precision = 'int16';
   case   8,
      hdr.dime.bitpix = int16(32); precision = 'int32';
   case  16,
      hdr.dime.bitpix = int16(32); precision = 'float32';
   case  32,
      hdr.dime.bitpix = int16(64); precision = 'float32';
   case  64,
      hdr.dime.bitpix = int16(64); precision = 'float64';
   case 128,
      hdr.dime.bitpix = int16(24); precision = 'uint8';
   case 256 
      hdr.dime.bitpix = int16(8 ); precision = 'int8';
   case 511,
      hdr.dime.bitpix = int16(96); precision = 'float32';
   case 512 
      hdr.dime.bitpix = int16(16); precision = 'uint16';
   case 768 
      hdr.dime.bitpix = int16(32); precision = 'uint32';
   case 1024
      hdr.dime.bitpix = int16(64); precision = 'int64';
   case 1280
      hdr.dime.bitpix = int16(64); precision = 'uint64';
   case 1792,
      hdr.dime.bitpix = int16(128); precision = 'float64';
   otherwise
      error('This datatype is not supported');
   end
   
   hdr.dime.glmax = round(double(max(nii.img(:))));
   hdr.dime.glmin = round(double(min(nii.img(:))));
   
   if filetype == 2
      fid = fopen(sprintf('%s.nii',fileprefix),'w');
      
      if fid < 0,
         msg = sprintf('Cannot open file %s.nii.',fileprefix);
         error(msg);
      end
      
      hdr.dime.vox_offset = 352;

      if ~isempty(ext)
         hdr.dime.vox_offset = hdr.dime.vox_offset + esize_total;
      end

      hdr.hist.magic = 'n+1';
      save_nii_hdr(hdr, fid);

      if ~isempty(ext)
         save_nii_ext(ext, fid);
      end
   else
      fid = fopen(sprintf('%s.hdr',fileprefix),'w');
      
      if fid < 0,
         msg = sprintf('Cannot open file %s.hdr.',fileprefix);
         error(msg);
      end
      
      hdr.dime.vox_offset = 0;
      hdr.hist.magic = 'ni1';
      save_nii_hdr(hdr, fid);

      if ~isempty(ext)
         save_nii_ext(ext, fid);
      end
      
      fclose(fid);
      fid = fopen(sprintf('%s.img',fileprefix),'w');
   end

   ScanDim = double(hdr.dime.dim(5));		% t
   SliceDim = double(hdr.dime.dim(4));		% z
   RowDim   = double(hdr.dime.dim(3));		% y
   PixelDim = double(hdr.dime.dim(2));		% x
   SliceSz  = double(hdr.dime.pixdim(4));
   RowSz    = double(hdr.dime.pixdim(3));
   PixelSz  = double(hdr.dime.pixdim(2));
   
   x = 1:PixelDim;

   if filetype == 2 & isempty(ext)
      skip_bytes = double(hdr.dime.vox_offset) - 348;
   else
      skip_bytes = 0;
   end

   if double(hdr.dime.datatype) == 128

      %  RGB planes are expected to be in the 4th dimension of nii.img
      %
      if(size(nii.img,4)~=3)
         error(['The NII structure does not appear to have 3 RGB color planes in the 4th dimension']);
      end

      if old_RGB
         nii.img = permute(nii.img, [1 2 4 3 5 6 7 8]);
      else
         nii.img = permute(nii.img, [4 1 2 3 5 6 7 8]);
      end
   end

   if double(hdr.dime.datatype) == 511

      %  RGB planes are expected to be in the 4th dimension of nii.img
      %
      if(size(nii.img,4)~=3)
         error(['The NII structure does not appear to have 3 RGB color planes in the 4th dimension']);
      end

      if old_RGB
         nii.img = permute(nii.img, [1 2 4 3 5 6 7 8]);
      else
         nii.img = permute(nii.img, [4 1 2 3 5 6 7 8]);
      end
   end

   %  For complex float32 or complex float64, voxel values
   %  include [real, imag]
   %
   if hdr.dime.datatype == 32 | hdr.dime.datatype == 1792
      real_img = real(nii.img(:))';
      nii.img = imag(nii.img(:))';
      nii.img = [real_img; nii.img];
   end

   if skip_bytes
      fwrite(fid, zeros(1,skip_bytes), 'uint8');
   end

   fwrite(fid, nii.img, precision);
%   fwrite(fid, nii.img, precision, skip_bytes);        % error using skip
   fclose(fid);

   return;					% write_nii

