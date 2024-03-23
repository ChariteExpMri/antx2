
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
%%   confirem-issue/' V scan warning' on gdrive
% ===============================================
% k=dir(outfile0);
% if k.bytes>1e6  
fid=fopen(outfile0);
d={};
for j=1
    tline = fgetl(fid);
    d{j,1}=tline;
end
fclose(fid);

if isempty(strfind(char(d),'<html>'))  %direct download
    movefile(outfile0,outfile,'f')
else                                  %vireusscan
    
    
    
    a=preadfile(outfile0);
    a=char(a.all);
    a2=a(strfind(a,'<form id="download-form"'):end);
    
    q1=strfind(a2,'"uuid"');
    q2=strfind(a2,'value="'); q2= q2(min(find(q2>q1)));
    q3=strfind(a2,'"'); q3=q3(q3>q2);
    
    uuid=strrep(a2(q3(1):q3(2)),'"','');
    tag=['&export=download&authuser=0&confirm=t&uuid=' uuid];
    
    v66=['"https://drive.usercontent.google.com/download?id='  googleID tag '" '];
    
    v77=['-O "' outfile  '"'];
    
    ms=[v1 v2 v3 v4 v5 v66 v77];
    eval(ms);
    
    try; delete(outfile0); end
end


% !set http_proxy=http://proxy.charite.de:8080&&set https_proxy=https://proxy.charite.de:8080&&"D:\MATLAB\antx2\mritools\ant\gdriveTemplate\xget.exe" --no-check-certificate --no-hsts -r -e use_proxy=yes "drive.google.com/uc?export=download&id=1pEYNKuc_IunQfSj_feIhpaXbK3xlMnzN&export=download&authuser=0&confirm=t&uuid=fb91eef8-69aa-4e6e-97fa-d11608d197da" -O "D:\Paul\__dontKnow\mouse_hikishima_temp.zip"
% !set http_proxy=http://proxy.charite.de:8080&&set https_proxy=https://proxy.charite.de:8080&&D:\MATLAB\antx2\mritools\ant\gdriveTemplate\xget.exe --no-check-certificate --no-hsts -r -e use_proxy=yes "https://drive.usercontent.google.com/download?id=1buAx3ac52NarBK1vGrf4E7bGjMTa36hp&export=download&authuser=0&confirm=t&uuid=33dc0bd4-e3e9-4aad-8927-940d7491712e&at=APZUnTWx4ueEwBBGnbAliWpSxujW:1711119843723" -O "D:\Paul\__dontKnow\bla.zip"'

%% ===============================================
%% FROM THIS
% <form id="download-form" action="https://drive.usercontent.google.com/download" 
% method="get"><input type="submit" id="uc-download-link" 
% class="goog-inline-block jfk-button jfk-button-action" 
% value="Download anyway"/><input type="hidden" 
% name="id" value="1pEYNKuc_IunQfSj_feIhpaXbK3xlMnzN">
% <input type="hidden" name="export" value="download">
% <input type="hidden" name="confirm" value="t">
% <input type="hidden" name="uuid" value="fb91eef8-69aa-4e6e-97fa-d11608d197da">
% </form></div></div><div class="uc-footer"><hr class="uc-footer-divider"></div></body></html>





% % ==============================================
% %%   zip-issue in windows /google-confirm
% % ===============================================
% % xget --no-check-certificate -r -e use_proxy=yes "drive.google.com/uc?export=download&id=1nX0g2DaMIPIVgQGead97dCdeNEflFN6h" -O RR.txt']
% fclose('all');
% % pause(4);
% 
% a = fopen(outfile0,'r');
% c2 = fread(a,'uint8=>uint8');
% fclose(a);
% 
% q=(char(c2'));
% c3=c2';
% q2=q(max(strfind(q,'</html>'))+7:end);
% c3=c2(max(strfind(q,'</html>'))+7:end);
% 
% ipk=min(findstr(q2,'PK'));
% if ipk~=1
%     q2=q2(ipk:end);
%     c3=c3(ipk:end);
% end
% 
% try; delete(outfile); end
% fclose('all');
% fileID = fopen(outfile,'w');%,'n','UTF-8'
% % fileID = fopen(stradd(outfile,'_VV',2),'w');
% fwrite(fileID,c3);
% fclose(fileID);
% 
% % keyboard
% 
% %———————————————————————————————————————————————
% %%   delete temp-zip
% %———————————————————————————————————————————————
% try; delete(outfile0); end





