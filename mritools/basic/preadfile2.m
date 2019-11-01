
function d=preadfile2(fil)
%___________________________________________________________________________
% % function [dat ]=preadfile(fil);
%___________________________________________________________________________
% Rread file (e.g *.vmrk/*.m/*.txt) 
% _________________________________________________________________________
% see also preadfile pwrite2file
%___________________________________________________________________________
%======================1.1 READ=====================================================
fid=fopen(fil);
j=1;
while 1
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    d{j,1}=tline;  
    j=j+1;
end
fclose(fid);

if exist('d')==0
    d=' ';
end


return


%=====================1.2 separate header and real markers (no 'new segments')=================================================

if nargin==3
    FSheadend=varargin{1};
    FSfileend=varargin{2};
    % FSheadend='#DATA BEGINS';     clear HTIS;
    % FSfileend='#DATA ENDS'
    Fadditheadline=2;
    FSline=' ' ;
    markALL=char(d);
    % markALL(100:7400,:)=[];

    %==========================================================================
    %   llinewise check
    %==========================================================================
    %=

    h=1; k=1;
    for j=1:size(markALL)
        if h==1 %HEADER
            if  isempty(findstr(markALL(j,:),FSheadend))==1
                header(j,:)=markALL(j,:);
            else
                h=0;T=j;
            end
        elseif h==0  %MARKER
            if  isempty(findstr(markALL(j,:),FSline))==0 &...
                    isempty(findstr(markALL(j,:),FSfileend))==1;  
%                 disp(markALL(j,:));
                mrk{k,:}=markALL(j,:);                        %
                k=k+1;
            else
%                 part=mrk(k,:);
%                 part
                h=999;
            end
        end
    end
%=====================%=====================
% out- 2 
%=====================%=====================    
dat.header=(header);
dat.dat= (mrk);  
% dat.header=char(header);
% dat.dat=char(markALL);  

end
%=====================%=====================
% out- 2 
%=====================%===================== 
dat.all=(d);
% dat.all=char(d);
%#############################################





% if 1
% 
% % infmrk.mrktyp=unique(mark(:,1));
% end

% % 
% % 
% % % BK
% % 
% % h=1; k=1;
% % for j=1:size(markALL)
% %     if h==1 %HEADER
% %         if  isempty(findstr(markALL(j,:),'Mk1'))==1
% %             header(j,:)=markALL(j,:);
% %         else
% %             h=0;
% %         end
% %     elseif h==0  %MARKER
% %         if  isempty(findstr(markALL(j,:),'Stimulus'))==0; %select ONLY STIMULUS nothing else 
% %             mrk(k,:)=markALL(j,:);                        %'no NEW SEGMENTS or RESPONSE'
% %             k=k+1;     
% %         end
% %     end
% % end
% % 
% % 
% % %===================== 1.3  extract mrk and timecolumn as double     =================================================
% % for j=1:size(mrk)
% %     dum=findstr(mrk(j,:),',');
% %     mark(j,:)=[ str2num(mrk(j,dum(1)+2:dum(2)-1))   str2num(mrk(j,dum(2)+1:dum(3)-1))  ]; 
% % end
% % 
% % 
% % infmrk.header=header;
% % infmrk.mrkALL=markALL;
% % infmrk.mrktyp=unique(mark(:,1));