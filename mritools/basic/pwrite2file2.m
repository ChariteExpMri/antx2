
function pwrite2file2(pathname, dataX,header , varargin  );
%___________________________________________________________________________
% function pwrite2file2(pathname, dataX ,header );
% function pwrite2file2(pathname, dataX,header,1  ); %OPENS WITH GUI
%___________________________________________________________________________
% pwrite2file2(pathname, dataX,header  );:
% 	IN____
% pathRT  :path (with endeslash)
% pathname :filename  
% dataX  : -writes  dataX/data (must be a cell/double)
% header : =headerline(s) as char or /CELL-array /or empty,[]; 
%
%  example
%      a=rand(10,3); b={'nr' 'pb' 'val'};
%      pwrite2file2('aaa14.txt',a,b );
% _________________________________________________________________________
% see also preadfile pwrite2file
%___________________________________________________________________________
%     paul,BNIC, mar.2007
%___________________________________________________________________________

% 'l'  
if nargin==4
    [fi pa]= uiputfile;
    pathname=[pa fi];
end     

a=whos('dataX');
clas=a.class;
% 'a'
%############################################# double2char
if strcmp(clas,'double')==1 | strcmp(clas,'single')==1
    for i=1:size(dataX,1)
        dataX2(i,:)={num2str(dataX(i,:))};
    end
    dataX=dataX2;
    a=whos('dataX');
    clas=a.class;
    
end    
%#############################################
fid = fopen([   pathname ],'w','n');

if ~isempty(header)
    if ~iscell(header) ;%if char
        for i=1:size(header,1)
            dumh=char(  (header(i,:)) );
            fprintf(fid,'%s\n',dumh);
        end
    elseif iscell(header) ;%%CELL
        if size(header,2)==1 %only one element in a cellline
            for i=1:size(header,1)
                dumh=char(  (header(i,:)) );
                fprintf(fid,'%s\n',dumh);
            end
        else %more elements per line
            for i=1:size(header,1)
                dl=(header(i,:));
                dnew='';
                for j=1:length(dl)
                    dele=[char(dl(j)) ' '];
                    dnew(end+1:end+length(dele))=dele;
                end
                
               dumh= dnew ;
               fprintf(fid,'%s\n',dumh);
            end


        end
        
        
        
    end
    
end


%------dataX
if  ( strcmp(clas,'cell')==1 | strcmp(clas,'char')==1)
    for i=1:size(dataX,1)
        dumh=char(  (dataX(i,:)) );
        fprintf(fid,'%s\n',dumh);
    end
elseif   (strcmp(clas,'double')==1 | strcmp(clas,'single')==1)
    for i=1:size(dataX,1)
        dumh=sprintf('%s', num2str((dataX(i,:))));
        fprintf(fid,'%s\n',num2str(dumh));
    end   
    
end
fclose(fid);