
function pwrite2file(name2wr, info,varargin  );
%___________________________________________________________________________
% function pwrite2file(name2wr, info  );
% function pwrite2file(name2wr, info,1  ); %OPENS WITH GUI
%___________________________________________________________________________
% pwrite2file(name2wr, info  );:
% 	IN____
% pathRT  :path (with endeslash)
% name2wr :filename  
% info  : -writes  info/data (must be a cell)
%           -can be empty,[]; 
%           -if info is 'VMRK', it writes the standard BA-VMRK-info
% _________________________________________________________________________
% see also preadfile pwrite2file,pwrite2file2
%___________________________________________________________________________
%     paul,BNIC, mar.2007
%___________________________________________________________________________

% 'l'  
if nargin==3
    [fi pa]= uiputfile;
    name2wr=[pa fi];
end     

a=whos('info');
clas=a.class;
% 'a'
%############################################# double2char
if strcmp(clas,'double')==1 | strcmp(clas,'single')==1
    for i=1:size(info,1)
        info2(i,:)={num2str(info(i,:))};
    end
    info=info2;
    a=whos('info');
    clas=a.class;
    
end    
%#############################################
fid = fopen([   name2wr ],'w','n');
%------info
if prod(size(info))==1 & ( strcmp(clas,'cell')==1 | strcmp(clas,'char')==1)
    i=1;
        dumh=char(  (info(i,:)) );
        fprintf(fid,'%s',dumh);
   
elseif prod(size(info))~=1 & ( strcmp(clas,'cell')==1 | strcmp(clas,'char')==1)
    for i=1:size(info,1)
        dumh=char(  (info(i,:)) );
        fprintf(fid,'%s\n',dumh);
        
    end
elseif prod(size(info))~=1 & (strcmp(clas,'double')==1 | strcmp(clas,'single')==1)
    for i=1:size(info,1)
        dumh=sprintf('%s', num2str((info(i,:))));
        fprintf(fid,'%s\n',num2str(dumh));
    end   
    
end
fclose(fid);











