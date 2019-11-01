function pa2=stradd(pa, str,pos)
%% add prefix/suffix to filename(s) ;  (str or cell of filename(s))
% pa: filenames
% str: str to add
% pos: 1,2 ..prefix or suffix (posis 1 if omitted )
% EXAMPLE
% stradd(fis,'DD',1)
% stradd(fis,'DD',2)
% stradd({'C:\R\1.txt' 'C:\R\2.txt'},'DD')

if exist('pos')==0; pos=1; end %default is prefix
ischar2=0;
if ischar(pa)
    pa={pa};
    ischar2=1;
end
    
pa=pa(:);
for i=1:size(pa,1)
     [pax fi2 ext]=fileparts(pa{i});
    
     if pos==1 
       pa{i}=  fullfile(pax,[ str fi2 ext]);
     elseif pos==2 
       pa{i}=  fullfile(pax,[  fi2 str ext]);  
     else
         error('position must be 1 or 2 (prefix or suffix)');
     end
end

    
if  ischar2==1;
    pa2=char(pa);
else
    pa2=(pa); 
end
    