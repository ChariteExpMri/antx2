


function psavefigs(folder)
% function psavefigs(folder)
% 


o=regexprep(datestr(now),{':' ' ' },'_');
ch=flipud(get(0,'children'));

mkdir(folder);
for i=1:length(ch)
    tx=['save Image "' num2str(i) '" to folder "' folder '"' ];
    try
      cprintf(rand(1,3),[tx '\n']);  
    catch
       disp(tx); 
    end
    chi=ch(i);
    set(chi,'InvertHardcopy','off');
    name=[ num2str(chi) '_' get(chi,'name') '_'  o];
    if strcmp(get(chi,'tag'),'uhelp')

        %saveas(chi,fullfile(pwd,folder,name),'fig');
     try
         x=get(chi,'userdata');
         dataX=(x.e0);
         clas=class(dataX);
         fid = fopen(fullfile(pwd,folder,[name '.txt' ]),'w','n');
         if  ( strcmp(clas,'cell')==1 | strcmp(clas,'char')==1)
             for i=1:size(dataX,1)
                 dumh=char(  (dataX(i,:)) );
                 fprintf(fid,'%s\n',dumh);
             end
         end
         fclose(fid);
     catch
         try;  fclose(fid);end
     end
     
        
    else
        %saveas(chi,fullfile(pwd,folder,name),'jpg');
        print(chi,'-djpeg','-r200',fullfile(pwd,folder,name));
    end
    
end

