% shows 'explorer' and 'mricron' as hyperlink for single or two overlayed images
% shows 'explorer' and 'open' as hyperlink for an excelfile (.xls or .xlsx)
% function showinfo2(msg,im1,im2)
% msg: just a message
%
% EXAMPLE
% msg=' new vol.';
% px='/media/parallels/M/data4/CT_Oelschlegel3/dat/ALinuxtest1'
% showinfo2(msg,fullfile(px,'AVGT.nii'))    ;  % shows AVGT alone
% showinfo2(msg,fullfile(px,'ANO.nii') ,1)  ;  % shows ANO in AllenSpace (1) with AVGT as BG-image
% showinfo2(msg,fullfile(px,'c1t2.nii'),-1) ;  % shows c1t2.nii in mouseSpace (1) with t2.nii as BG-image
% showinfo2(msg,fullfile(px,'t2.nii') ,fullfile(px,'c1t2.nii'));% shows t2.nii with c1t2.nii on top
%---excelfile
% showinfo2('new excelfile',fullfile(pwd,'test.xls'))
%
% no message:
% showinfo2('..reoriented',fi2,g1,1,'');


function showinfo2(msg,im1,im2,colorstr,msg2)

isdekstop=usejava('desktop');

if 0
    clear
    msg=' result';
    px='/media/parallels/M/data4/CT_Oelschlegel3/dat/ALinuxtest1';
    im1=fullfile(px,'c1t2.nii');
    im2=fullfile(px,'t2.nii');
    showinfo2(msg,im1,im2);
end

%% --------------------------------------------
% XLS/EXCEL
%% CHECK TYPE
[pa fi ext]=fileparts(im1);
if strcmp(ext,'.nii')==0 ;%~isempty(regexp(im1,'.xls|.xlsx'))
    if exist('msg2')~=1; msg2='';end
    name=[fi ext];
    if isdekstop==1
        if ispc
            disp([msg ' [' name ']: <a href="matlab: explorerpreselect(''' im1 ''');">' 'Explorer' '</a>' ...
                ' or <a href="matlab: system(''start ' im1 ''');">' 'open' '</a>' ' '  msg2 ]);
        elseif ismac
            disp([msg ' [' name ']: <a href="matlab: explorerpreselect(''' im1 ''');">' 'Explorer' '</a>' ...
                ' or <a href="matlab: system(''open ' im1 ''');">' 'open' '</a>' ' '  msg2  ]);
        elseif isunix
            disp([msg ' [' name ']: <a href="matlab: explorerpreselect(''' im1 ''');">' 'Explorer' '</a>' ...
                ' or <a href="matlab: system(''xdg-open ' im1 ''');">' 'open' '</a>'  ' '  msg2 ]);
        end
    else
        disp([msg '[' name ']:' im1 ',' msg2 ]);
    end
    
    
    return
    
end


%% --------------------------------------------
if exist('colorstr')==0
    colorstr='0';
else
    colorstr= num2str(colorstr);
end

if exist('im2')~=1; im2=''; end

if exist('im2')==1
    if isnumeric(im2)==1
        direc= im2;
    else
        direc= 1;
    end
end
if exist('direc')~=1; direc=1; end


a.img              =im1;
[a.pa  a.fil a.ext]=fileparts(a.img);
a.name             =[a.fil a.ext];



do=1;
if ~ isempty(im2)
    swap=0;
    if isnumeric(im2);
        if direc==1 %forward
            im2=fullfile(a.pa,'AVGT.nii');
        elseif direc==-1  %backward
            im2=fullfile(a.pa,'t2.nii');
        end
    else
        if strcmp(im1,im2)==1
            do=0;
        else
            swap=1;
        end
    end
    
    if do==1 % OVL-2 mages
        b.img              =im2;
        [b.pa  b.fil b.ext]=fileparts(b.img);
        b.name             =[b.fil b.ext];
        
        if direc    ==  -1 %forward
            c=a;
            a=b;
            b=c;
            name1=a.name;
            name2=b.name;
            if exist('msg2')==0
                msg2=[' [' name1 ' - ' name2 ']:'];
            end
            if isdekstop==1
                disp([msg  msg2 '<a href="matlab: explorerpreselect(''' b.img ''');">' 'Explorer' '</a>' ...
                    ' or <a href="matlab: rmricron([],''' a.img ''' ,''' b.img ''', ' colorstr ')">' 'MRicron' '</a>'   ]);
            else
                disp([msg msg2 ':"' a.img '","' b.img '"' ]);
            end
        else
            name1=a.name;
            name2=b.name;
            if exist('msg2')==0
                msg2=[' [' name1 ' - ' name2 ']:'];
            end
            if isdekstop==1
                disp([msg msg2 ' <a href="matlab: explorerpreselect(''' b.img ''');">' 'Explorer' '</a>' ...
                    ' or <a href="matlab: rmricron([],''' a.img ''' ,''' b.img ''', ' colorstr ')">' 'MRicron' '</a>'   ]);
            else
                disp([msg msg2 ':"' a.img '","' b.img '"' ]);
            end
        end
        
        
        
        
    end
end

if isempty(im2)
    if exist('msg2')~=1
        msg2='';
    end
    %SINGLE IMG
    if isdekstop==1
        disp([msg ' [' a.name ']: <a href="matlab: explorerpreselect(''' a.img ''');">' 'Explorer' '</a>' ...
            ' or <a href="matlab: rmricron([], ''' a.img ''',[], 0)">' 'MRicron' '</a>' ' ' msg2  ]);
    else
        disp([msg ' [' a.name ']: "' a.img '", ' msg2]);
    end
end















