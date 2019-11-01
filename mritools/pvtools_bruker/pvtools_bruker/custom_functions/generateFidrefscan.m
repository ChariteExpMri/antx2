%%  generateFidrefscan
%
%   Generates a fid.refscan file for water scaling using LCModel, which is
%   missing under PV6.0
%
%   Requirements:
%   Bruker pvtools (readBrukerParamFile function)
%
%   Philipp Boehm-Sturm 07/2015

%%  Add relevant paths (change accordingly on your system)
addpath('~/Documents/MATLAB/pvtools_bruker/custom_functions/');
addpath('~/Documents/MATLAB/pvtools_bruker');
addpath(genpath('~/Documents/MATLAB/pvtools_bruker'));

standardpath='/Volumes/MFZ-CSB/#MFZ-CSB-Public/Tier-MRT/MRS_AG Brandenburg/';

%   Ask for fid file of the study, check if relevant files exist
[FileName_fid,PathName_fid] = uigetfile('fid.*','Select Bruker fid file',standardpath);
if ~exist(fullfile(PathName_fid,'fid'))
    error('Bruker fid file not found in selected directory')
end
if ~exist(fullfile(PathName_fid,'method'))
    error('Bruker method file not found in selected directory')
end

if ~exist(fullfile(PathName_fid,'acqp'))
    error('Bruker acqp file not found in selected directory')
end

if ~exist(fullfile(PathName_fid,'pdata','1','reco'))
    error('Bruker reco file not found in selected directory')
end
    
path_to_method=fullfile(PathName_fid,'method');    
path_to_acqp=fullfile(PathName_fid,'acqp');    
path_to_reco=fullfile(PathName_fid,'pdata','1','reco');

method=readBrukerParamFile(path_to_method);
acqp=readBrukerParamFile(path_to_acqp);
reco=readBrukerParamFile(path_to_reco);

%   Get important parameters to generate fid.reference

%   fid size
fid_size=acqp.ACQ_size;
%   Number of receiver channels
noRec=length(method.PVM_ArrayPhase);
%   consistency check
if noRec~=size(method.PVM_RefScan)
    error('Number of receive channels does not match with size of reference scan raw data');
end

%   Extract complex scale factor for each channel
scaleChan=reco.RecoScaleChan;
phaseChan=method.PVM_ArrayPhase;
phaseChanRad=pi/180.*phaseChan;
scaleFactor=scaleChan.*exp(phaseChanRad*1i);
if noRec==1
    fidRef=method.PVM_RefScan;
else
    compFidRef=complex(zeros(1,acqp.ACQ_size/2),0);
    for j=1:noRec
        compFidRef=compFidRef+scaleFactor(j).*...
            (method.PVM_RefScan(j,1:2:end)+1i*method.PVM_RefScan(j,2:2:end));
    end
    fidRef=zeros(1,acqp.ACQ_size);
    fidRef(1:2:acqp.ACQ_size)=real(compFidRef);
    fidRef(2:2:acqp.ACQ_size)=imag(compFidRef);
end

%%  Get data format to store fid.reference

%   transform the Number-Format to Matlab-format (=format) and save the
%   number of bits per value
switch(acqp.GO_raw_data_format)
    case ('GO_32BIT_SGN_INT')
        precision='int32';
        bits=32;
    case ('GO_16BIT_SGN_INT')
        precision='int16';
        bits=16;
    case ('GO_32BIT_FLOAT')
        precision='float32';
        bits=32;
    otherwise
        precision='int32';
        disp('Data-Format not correct specified! Set to int32')
        bits=32;
end

%   transform the machinecode-format to matlab-format (=endian)
switch(acqp.BYTORDA)
    case ('little')
        machineformat='l';
    case ('big')
        machineformat='b';
    otherwise 
        machineformat='l';
        disp('MacineCode-Format not correct specified! Set to little-endian')
end

%%  Create fid.reference file
fileID=fopen(fullfile(PathName_fid,'fid.refscan'),'w',machineformat);
fwrite(fileID, fidRef, precision,machineformat);
fclose(fileID);


%%  Final consistency check (size of fid needs to be equal size of fid.refscan)
fidInfo=dir(fullfile(PathName_fid,'fid'));
fidRefInfo=dir(fullfile(PathName_fid,'fid.refscan'));
if fidInfo.bytes~=fidRefInfo.bytes
    error('sth. went wrong. fid file does not have the same size as fid.reference');
end
display(['Generated ',fullfile(PathName_fid,'fid.refscan')]);
clear;

