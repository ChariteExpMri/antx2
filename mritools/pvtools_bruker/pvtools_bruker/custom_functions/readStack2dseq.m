function stack=readStack2dseq(path,RO,PE,scanno,recono,frame,type);
%% readStack2dseq reads in many scans/slices from one paravision study and creates a single stack
% scanno/recono are vectors containing the scannumber and reco numbers,
% path is the path to the studyfolder (ends with filesep, RO, PE are the dimensions in
% readout/phase encoding, frame is a vector containing the slice to grab
% for each scan, type is a cell array with datatype strings (e.g. 'int16', see read2dseq.m)

stack=zeros(RO,PE,length(scanno));
for i=1:length(scanno)
    %display([path num2str(scanno(i)) filesep 'pdata' filesep num2str(recono(i)) filesep]);
    stack(:,:,i)=read2dseq([path num2str(scanno(i)) filesep 'pdata' filesep num2str(recono(i)) filesep],RO,PE,frame(i),type{i});
end
