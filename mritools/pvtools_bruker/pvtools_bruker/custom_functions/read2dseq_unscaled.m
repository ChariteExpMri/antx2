function fid=read2dseq_unscaled(path,RO,PE,frame,type);

%reads Bruker data
%path:  path to 2dseq file, ends with filesep
%RO:    Readout matrix size
%PE:    Phase encoding matrix size
%frame: frame to open (equals the slice for 3D data)
%type:  'int16'/'int32' for 16/32 bit signed integer
%
%

%full path to file
filepath=fullfile(path,'2dseq');

%Open 2dseq
%FC=fopen([filepath,'2dseq'] );             % for SG
[FC, message]=fopen(filepath,'r+','l');         %for PC
%FC=fopen([filepath,'2dseq'], 'r','l');               %for CD

%Read file

%for 16 bit images
if strcmp(type,'int16')==1
    fseek(FC,RO*PE*(frame-1)*2,'bof');
    ftell(FC);
    fid=fread(FC,[RO,PE],'int16');
end

%for 32 bit images
if strcmp(type,'int32')==1
    fseek(FC,RO*PE*(frame-1)*4,'bof');
    ftell(FC);
    fid=fread(FC,[RO,PE],'int32');
end

fclose(FC);
%fid=fid';

end