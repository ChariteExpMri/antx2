




function conmanhook(ra,r0,val)
%  hook in the spm_contrastmanager
% [1]    conmanhook('hook')  ;%hook & modify spm_conman
% [2]    conmanhook('unhook') ; %remove modification in spm_conman

%============================================================================
% hook to spm_conman
%============================================================================

if ~exist('ra')
  help conmanhook;
  return
end

if strcmp(ra,'hook')|| strcmp(ra,'unhook')  %hook to spm_conman

    file=which('spm_conman.m')  ;
    fid=fopen(file);
    j=1;
    while 1
        tline = fgetl(fid);
        if ~ischar(tline), break, end
        v{j,1}=tline;
        j=j+1;
    end
    fclose(fid);

    del=[];
    %check existence of [conmanhook]
    ixcheck=find(~cellfun('isempty',regexpi(v,...
        {'conmanhook\(hh,\[\],0\)'}  ))==1);
    for i=1:length(ixcheck)
        i1=min(regexpi(v{ixcheck(i)},'%'));
        i2=min(regexpi(v{ixcheck(i)},'conmanhook'));
        if i2>i1;       del(i)=1; end
    end
    ixcheck(del==1)=[];
    %     ixcheck

    if strcmp(ra,'hook')
        % '\sconmanhook\(hh,\[\],0\)|
        if  ~isempty(ixcheck)
            disp(['conmanhook: in [spm_conman.m] line ' num2str(ixcheck) ' already exists']);
            return;
        end

        ix1=find(~cellfun('isempty',regexpi(v,'hh = uicontextmenu'))==1);
        ix2=find(strcmp(v,''));
        ix2=ix2(min(find(ix2>ix1)));
        v2=[v(1:ix2); {'conmanhook(hh,[],0);'}          ; v(ix2+1:end)  ];
       disp(['conmanhook: in [spm_conman.m] line ' num2str(ix2+1) ' created']);
    else
        if isempty(ixcheck);              return  ;        end
        v2=v;
        v2(ixcheck)=[];
        disp(['conmanhook: in [spm_conman.m] line ' num2str(ixcheck(:)') ' removed']); 
    end


    fid = fopen([ file ],'w','n');% 'muell.m'
    for i=1:size(v2,1)
        dumh=char(  (v2(i,:)) );
        fprintf(fid,'%s\n',dumh);
    end
    fclose(fid);



    return
end

%============================================================================
% initialize during spm_results ui
%============================================================================

if val==0 %initialize
    hh=ra;
    uimenu(hh,'Label','delete contrast...',...
        'Tag','deleteC',...
        'CallBack', {@conmanhook,1},...
        'Interruptible','off','BusyAction','Cancel');
    uimenu(hh,'Label','move to TOP...',...
        'Tag','moveupC',...
        'CallBack', {@conmanhook,2},...
        'Interruptible','off','BusyAction','Cancel');
    uimenu(hh,'Label','move to BOTTOM...',...
        'Tag','movedownC',...
        'CallBack', {@conmanhook,3},...
        'Interruptible','off','BusyAction','Cancel');

    return

end


F = gcbf;

hConList = findobj(F,'Tag','ConList');
Q        = get(hConList,'UserData');
i        = get(hConList,'Value');

%-Make sure there's only one selected contrast
%------------------------------------------------------------------
% if length(i)~=1
%     msgbox('Can only rename a single contrast!',...
%         sprintf('%s%s: %s...',spm('ver'),...
%         spm('GetUser',' (%s)'),mfilename),'error','modal')
%     return
% end

%-Get contrast structure array and indicies of current contrast
%------------------------------------------------------------------
SPM      = get(F,'UserData');
xCon     = SPM.xCon;
I      = Q(i);

%-Get new name
%------------------------------------------------------------------
% str = sprintf('Enter new name for contrast %d (currently "%s"):',I,xCon(I).name);
% nname  = inputdlg(str,'SPM: Rename contrast',1,{xCon(I).name},'off');
% if isempty(nname), return, end

if val==1 %delete
    %-Change name in ConList
    %------------------------------------------------------------------
    tmp    = get(hConList,'String');
    tmp(i) =[];% strrep(tmp{i},xCon(I).name,nname{1});
    set(hConList,'Value',1);
    try
        sep=regexpi(tmp,'{');
        for j=1:size(tmp,1)
            str=repmat('0',[1 3]);
            str(end-length(num2str(j))+1:end)=num2str(j);
            tmp{j}=[str tmp{j}(sep{j}-1:end)];
        end
    end

    set(hConList,'String',tmp)

    %-Change name in contrast structure
    %------------------------------------------------------------------
    % xCon(I).name = nname{1};
    
    for c=1:length(I)
        con=xCon(I(c));
        try; delete(          con.Vcon.fname); catch; 'a';end 
        try; delete(regexprep(con.Vcon.fname,'.img','.hdr')); catch; 'a';end 
        try; delete(          con.Vspm.fname); catch; 'a';end
        try; delete(regexprep(con.Vspm.fname,'.img','.hdr')); catch; 'a';end
    end
    
    %....rename files and contrast-linkage
    ds={};
    del=zeros(length(xCon),1);
    del(I)=1;
    newnum=zeros(length(xCon),1);
    newnum(find(del==0))=[1:length(find(del==0))];
    for d=1:length(xCon);
        try; d1=xCon(d).Vcon.fname; catch; d1='';end
        try; d2=xCon(d).Vspm.fname; catch; d2='';end
       ds(end+1,:)={del(d)  newnum(d) d1  d2  };
    end
    ds
    id=min(find(del==1))
    id=id+1:length(xCon)
    for d=1 :length(id)
        this=id(d)
        if ~isempty(ds{this,3})
          newID=ds{this,2}
          
          img=ds{this,3}  
          lim=[strfind(img,'_')  strfind(img,'.')]
          str=repmat('0',[1 4]);
          str(end-length(num2str(newID))+1:end)=num2str(newID)  ;
          ds{this,5}=  [img(1:lim(1)) str  img(lim(2):end) ]
          
          img=ds{this,4}  
          lim=[strfind(img,'_')  strfind(img,'.')]
          str=repmat('0',[1 4]);
          str(end-length(num2str(newID))+1:end)=num2str(newID)  ;
          ds{this,6}=  [img(1:lim(1)) str  img(lim(2):end) ]
          
        try;  movefile(        ds{this,3}               ,       ds{this,5});end
        try;  movefile(strrep(ds{this,3},'.img','.hdr') ,strrep(ds{this,5},'.img','.hdr'));end
        try;  movefile(        ds{this,4}               ,       ds{this,6});end
        try;  movefile(strrep(ds{this,4},'.img','.hdr') ,strrep(ds{this,6},'.img','.hdr'));end

     
          xCon(this).Vcon.fname= ds{this,5};
          xCon(this).Vspm.fname= ds{this,6};
          
          xCon(this).Vcon.descrip=regexprep(xCon(this).Vcon.descrip,...
              [num2str(this) ':'],[num2str(newID) ':'])
        
          xCon(this).Vspm.descrip=regexprep(xCon(this).Vspm.descrip,...
              [num2str(this) ':'],[num2str(newID) ':'])
          end
        
    end
    
    
    
    
    xCon(I)=[];
    SPM.xCon = xCon;

elseif val==2 | val==3 %on top  | down
    tmp    = get(hConList,'String');
    if val==2
        ord=[ i  setdiff(1:size(tmp,1) , i )   ];
        pointer=1;
    else
        ord=[  setdiff(1:size(tmp,1) , i )  i ];
        pointer=length(ord);
    end
    tmp=tmp(ord);
%     sep=regexpi(tmp,'{');
%     for i=1:size(tmp,1)
%         str=repmat('0',[1 3]);
%         str(end-length(num2str(i))+1:end)=num2str(i);
%         tmp{i}=[str tmp{i}(sep{i}-1:end)];
%     end
    set(hConList,'String',tmp);
    
    xCon=reorder(xCon,ord);
    
;
    SPM.xCon = xCon;
    set(hConList,'Value',pointer);
    % set(hConList,'Value',1);

end
% ord
% val
set(F,'UserData',SPM);

function  xCon=reorder(xCon,ord)


list={};
xCon2=xCon(ord);
for i=1:length(xCon2)
   newID= (i);
   
   if ~isempty(xCon2(i).Vcon);
   
   img=xCon2(i).Vcon.fname;
   lim=[strfind(img,'_')  strfind(img,'.')];
   str=repmat('0',[1 4]);
   str(end-length(num2str(newID))+1:end)=num2str(newID)  ;
   img2=  [img(1:lim(1)) str  img(lim(2):end) ];
   xCon2(i).Vcon.fname =img2;
   
     img3=xCon2(i).Vspm.fname;
   lim=[strfind(img3,'_')  strfind(img3,'.')];
   str=repmat('0',[1 4]);
   str(end-length(num2str(newID))+1:end)=num2str(newID)  ;
   img4=  [img3(1:lim(1)) str  img3(lim(2):end) ];
   xCon2(i).Vspm.fname =img4;
   
        xCon2(i).Vcon.descrip=regexprep(xCon2(i).Vcon.descrip,...
              [num2str(i) ':'],[num2str(newID) ':']);
        
           xCon2(i).Vspm.descrip=regexprep(xCon2(i).Vspm.descrip,...
              [num2str(i) ':'],[num2str(newID) ':']);
    list(end+1,:)= {img img2 img3 img4}     ;
          
   end
   

end

list2=[list(:,1:2);list(:,3:4);];
list2=[list2; regexprep(list2,'.img','.hdr')];

%rename
for i=1:size(list2,1)
   movefile( [  list2{i,1} ],['TPM_' list2{i,2} ]);
end      
for i=1:size(list2,1)
   movefile( [ 'TPM_' list2{i,2} ],[   list2{i,2} ]);
end         
 

xCon=xCon2;%(ord);















