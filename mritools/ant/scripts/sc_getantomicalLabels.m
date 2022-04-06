

% <b> get anaotmical labels; examples   </b>          
% <font color=fuchsia><u>select from below examples:</u></font>
% - EXAMPLE-1: 
%   - extract parameters from several images in native space, 
%   - here, another atlas is used
%   - the resulting excelfiles are stored in the study's results-folder
%   - the extraction is performed for all selected animals in the ANT-listbox  



%% ======================================================================================
%%  [example-1]  get anatomical labels for several images in native space
%%  using another atlas                                                      
%% ======================================================================================
% extract parameters from these images
files={'t2.nii'  'c1t2.nii'  'ad.nii' 'adc.nii' 'fa.nii' 'rd.nii'}; 

% filenames of the resulting excel-files
finames=regexprep(files,{'.nii' ''},{''});
finames=cellfun(@(a){['rw_' a  '.xlsx']},finames); %output-filename

% loop over files
for i=1:length(files)
    z=[];
    z.files        = { files{i} };  % % files used for calculation
    z.masks        = '';            % % optional; corresponding maskfiles (order is irrelevant)or mask from templates folder
    z.atlasOS      = '';            % % The atlas in "other space". IMPORTANT ONLY IF "SPACE"-PARAMER IS SET TO "other">
    z.hemimaskOS   = '';            % % The hemispher mask in "other space". IMPORTANT ONLY IF "SPACE"-PARAMER IS SET TO "other">
    z.atlas        = 'H:\Daten-2\Imaging\AG_Boehm_Sturm\ERA-Net_topdownPTSD\allanimals_stat\PTSDatlas_01dec20\PTSDatlas.nii';     % % select atlas here (default: ANO.nii), atlas has to be the standard space atlas
    z.space        = 'native';      % % use images from "standard","native" or "other" space
    z.hemisphere   = 'both';        % % hemisphere used: [left,right or both]
    z.threshold    = '';            % % lower intensity threshold value (values >=threshold will be excluded); leave field empty when using a mask
    z.fileNameOut  = finames{i};    % % optional; specific name of the output-file. EMPTY FIELD: use timestamp+paramter for file name
    z.frequency    = [1];           % % frequency: number of voxels within an anatomical region
    z.percOverlapp = [1];           % % percent overlapp between mask and anatomical region
    z.volref       = [1];           % % volume [qmm] of anatomical region (REFERENCE)
    z.vol          = [1];           % % volume [qmm] of (masked) anatomical region
    z.volPercBrain = [1];           % % percent volume [percent] of anatomical region relative to brain volume
    z.mean         = [1];           % % mean of values (intensities) within anatomical region
    z.std          = [1];           % % standard deviation of values (intensities) within anatomical region
    z.median       = [1];           % % median of values (intensities) within anatomical region
    z.min          = [1];           % % min of values (intensities) within anatomical region
    z.max          = [1];           % % max of values (intensities) within anatomical region
    xgetlabels4(0,z); % perform task, (silent mode/no GUI) 
end

