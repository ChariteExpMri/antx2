function fid=read2dseq(path,RO,PE,frame,type);

%reads Bruker data
%path:  path to 2dseq file, ends with filesep
%RO:    Readout matrix size
%PE:    Phase encoding matrix size
%frame: frame to open (equals the slice for 3D data)
%type:  'int16'/'int32' for 16/32 bit signed integer
%
%SUBFUNCTION
%slopefind retrieves the PV slope factor from the RECO file
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
fid=fid';

%extract slope factor and correct image for it
slope=slopefind(path);
fid=(1/slope)*fid;
end

%%%%%%%%%%%%%%%%%%%%%%%SUBFUNCTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function slope=slopefind(path);
%slopefind extracts the slope factor off the RECO file stored in the path

a=fopen([path,'reco']);
line1=1;
position=0;
line2=['##$RECO_map_slope=( 2 )'];
line22=line2(1:19);

while line1~=-1
    fseek(a,position,'bof');
    line1=fgets(a);   %Read line from file, keep newline character
%   line1=fgetl(a);   %Read line from file, discard newline character
    k=length(line1);
if k>=19
    line11=line1(1:19);
else
    line11=line1;
end
  if strcmp(line22,line11)==1		%string compare
      line1=-1;
      position=ftell(a);
      line3=fgets(a);
  else
      position=ftell(a);
  end

end
fclose(a);

l=length(line3);
j=0;
i=1;
while i<=l 
    if isspace(line3(i))==1	%looks for space (end of paramater)
      j=i-1;
      i=l+1;
    else
      i=i+1;
    end
end
 
line4=line3(1:j);
slope=str2num(line4);
end