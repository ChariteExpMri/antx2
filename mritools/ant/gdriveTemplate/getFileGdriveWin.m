
function getFileGdriveWin(googleID,fiout,http_proxy,https_proxy)



if 0
    
    fiout ='f:\anttemplates_test\mouse_Allen2017HikishimaLR.zip'  ;
    googleID ='1nX0g2DaMIPIVgQGead97dCdeNEflFN6h'   ;
    http_proxy ='' ;
    https_proxy ='' ;
    getFileGdriveWin(googleID,fiout,http_proxy,https_proxy);
    
end


%———————————————————————————————————————————————
%%   PROXY
%———————————————————————————————————————————————
if any([~isempty(http_proxy) ~isempty(https_proxy)])==1
    useproxy=1;
else
    useproxy=0; 
end

% !set http_proxy=http://proxy.charite.de:8080&&set "https_proxy=https://proxy.charite.de:8080"&&xget --no-check-certificate -r -e use_proxy=yes "drive.google.com/uc?export=download&id=1nX0g2DaMIPIVgQGead97dCdeNEflFN6h" -O RR.txt
% ms=['!set http_proxy=http://proxy.charite.de:8080&&set "https_proxy=https://proxy.charite.de:8080"&&xget --no-check-certificate -r -e use_proxy=yes "drive.google.com/uc?export=download&id=1nX0g2DaMIPIVgQGead97dCdeNEflFN6h" -O RR.txt']

v1=['!'];
if useproxy==1
%     http_proxy='http://proxy.charite.de:8080'
%     https_proxy='https://proxy.charite.de:8080'
   if    ~isempty(http_proxy); v2=['set ' 'http_proxy=' http_proxy '&&'];
   else                      ; v2='';
   end
   if    ~isempty(http_proxy); v3=['set ' 'https_proxy=' https_proxy '&&'];
   else                      ; v3='';
   end
   v5=['-e use_proxy=yes '];
else
%     http_proxy=''
%     https_proxy=''
    [v2,v3,v5]=deal('');
end
%———————————————————————————————————————————————
%%   other params
%———————————————————————————————————————————————

outfile= fiout    ;         %fullfile(pwd,'temp.zip');
xget   = fullfile(fileparts(which('xdownloadtemplate.m')),'xget.exe');

% v4=['xget --no-check-certificate -r ' ]
 v4=['"' xget '" --no-check-certificate --no-hsts -r ' ];
%v4=['"' xget '" --no-check-certificate -r ' ];


% v5=['-e use_proxy=yes ']
v6=['"drive.google.com/uc?export=download&id='  googleID '" '];

outfile0=stradd(outfile,'_temp',2);
v7=['-O "' outfile0  '"'];

ms=[v1 v2 v3 v4 v5 v6 v7];



fclose('all');
try; delete(outfile0); end
eval(ms);
% ==============================================
%%   zip-issue in windows /google-confirm
% ===============================================
% xget --no-check-certificate -r -e use_proxy=yes "drive.google.com/uc?export=download&id=1nX0g2DaMIPIVgQGead97dCdeNEflFN6h" -O RR.txt']
fclose('all');
% pause(4);

a = fopen(outfile0,'r');
c2 = fread(a,'uint8=>uint8');
fclose(a);

q=(char(c2'));
c3=c2';
q2=q(max(strfind(q,'</html>'))+7:end);
c3=c2(max(strfind(q,'</html>'))+7:end);

ipk=min(findstr(q2,'PK'));
if ipk~=1
    q2=q2(ipk:end);
    c3=c3(ipk:end);
end

try; delete(outfile); end
fclose('all');
fileID = fopen(outfile,'w');%,'n','UTF-8'
% fileID = fopen(stradd(outfile,'_VV',2),'w');
fwrite(fileID,c3);
fclose(fileID);

% keyboard

%———————————————————————————————————————————————
%%   delete temp-zip
%———————————————————————————————————————————————
try; delete(outfile0); end





