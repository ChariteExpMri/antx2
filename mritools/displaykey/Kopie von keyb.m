
function keyb(src,evnt)

if nargin==0
    helphelp;
    return
end

if length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:},'control') & strcmp(evnt.Key, 'control')
    return
end
if length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:},'shift') & strcmp(evnt.Key, 'shift')
    return
end


 box=getappdata(gcf,'box');

if evnt.Character == 'h'
    helphelp
 elseif evnt.Character == 'd'
    spm_image2('setparams','col',box.col,'wt',box.wt);
elseif evnt.Character == 'f'    %flipdim
    global st
    if isfield(st.overlay,'orig')==0;
        st.overlay.orig=st.overlay
    end
    
    prompt = {'order of dims,use[-] to flip dir of this dim, e.g. [1 3 -2], [] for orig. settup '};
    dlg_title = 'Input for peaks function';
    num_lines = 1;
    def = {num2str([1 2 3])};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    
    if isempty(char(answer)); %orig settup
       st.overlay= st.overlay.orig;
        spm_orthviews2('Redraw');
        return
    elseif length(str2num(char(answer)))==3
        vc=[str2num(char(answer)) ];
        flips=sign(vc);
        perms=abs(vc);
        
        v=spm_vol(st.overlay.fname)
        d=spm_read_vols(v); % r
        
        isflip=find(flips==-1);
        dia=diag(v.mat(1:3,1:3))
        dc=zeros(3,1);
        for i=1:length(isflip)
             vsiz=dia(isflip(i))
            a=[vsiz:vsiz:vsiz*(size(d,isflip(i))+1)]+v.mat(isflip(i),4); 
            %a=[0:vsiz:vsiz*(size(d,isflip)-1)]+v.mat(isflip(i),4); 
            dc(isflip(i))=-[a([ end]) ] ;
            d=flipdim(d,isflip(i));
        end
        %permute
        d=permute(d,[perms]);

%         dsh=round(size(d)/2)  ;
%         subplot(3,3,7); imagesc( squeeze(d(dsh(1),:     ,:) )   )     ;title(['2 3']);
%         subplot(3,3,8); imagesc( squeeze(d(:     ,dsh(2),:) )   )     ; title(['1 3']);
%         subplot(3,3,9); imagesc( squeeze(d(:     ,:     ,dsh(3)) )   );  title(['1 2']);
%         
%         
        v2=v;
        [pa fi fmt]=fileparts(v2.fname);
        v2.fname=fullfile(pa ,['p' fi  fmt]);
        v2.dim=size(d);
        mat=v2.mat;
        dia=diag(mat);
        mat(1:4+1:end)=dia([perms 4]);
        
        orig=mat(1:3,4);
        orig(find(dc~=0) )=dc(find(dc~=0));
%         orig=orig.*flips'
%         orig(2)=orig(2)+3
        orig=orig(perms);
        
        mat(:,4)=[orig; 1];
%         mat(3,4)=mat(3,4)+2
        v2.mat=mat;
        
        spm_write_vol(v2, d); % write data to an image file.
        
        
        backup= st.overlay.orig;
        st.overlay =v2;
        st.overlay.col=backup.col;
        st.overlay.wt=backup.wt;
        st.overlay.orig =backup;
          spm_orthviews2('Redraw');
        
    end
    
    
%     v.mat
% 
% ans =
% 
%     0.0699         0         0   -5.9951
%          0    0.0700         0   -9.5589
%          0         0    0.0700   -8.7410
%          0         0         0    1.0000
% 
% v2.mat
% 
% ans =
% 
%     0.0699         0         0   -5.9951
%          0    0.0700         0   -8.7410
%          0         0    0.0700   -6.5589
%          0         0         0    1.0000
%     
    
    
    
    
    
    
    
    
    
    
    
 elseif (strcmp(evnt.Character, '+')   | strcmp(evnt.Character, '-'))   && isempty(evnt.Modifier)
     global st
       stp=.1;
     if evnt.Character == '-'
        stp=-stp; 
     end
   
     try
         st.overlay.wt=st.overlay.wt+stp;
     catch
         st.overlay.wt=st.overlay.wt+stp;
     end
%      if st.overlay.wt>1; st.overlay.wt=1; end
     if st.overlay.wt<0; st.overlay.wt=0; end
    spm_image2('setparams','wt',st.overlay.wt) ;
    
    box=getappdata(gcf,'box');
    box.wt=st.overlay.wt;
     setappdata(gcf,'box',box);
      

%   elseif (evnt.Character == '+'  || evnt.Character=='-' )   && strcmp(evnt.Modifier{:},'control')
%      global st
%        stp=.1;
%      if evnt.Character == '-'
%         stp=-stp; 
%      end
%    
%      try
%          st.overlay.wt=st.overlay.wt+stp;
%      catch
%          st.overlay.wt=st.overlay.wt+stp;
%      end
%      if st.overlay.wt>1; st.overlay.wt=1; end
%      if st.overlay.wt<0; st.overlay.wt=0; end
%     spm_image2('setparams','wt',st.overlay.wt) ;
%     'jjjjj'
    
elseif evnt.Key == '1'
    
    
    prompt = {'Enter StepSize-->Translation:','Enter StepSize-->Rotation:'};
    dlg_title = 'Input for peaks function';
    num_lines = 1;
    def = {num2str(box.stpshift),num2str(box.stpangle)};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    
    box.stpshift=str2num(answer{1});
    box.stpangle=str2num(answer{2});
    setappdata(gcf,'box',box);
   
elseif evnt.Key == '2'    
   if box.isBackgroundOnly==0; 
       box.isBackgroundOnly=1;
      spm_image2('setparams','col',box.col,'wt',0);
      setappdata(gcf,'box',box);
      getappdata(gcf,'box');
   else
       box.isBackgroundOnly=0;
      spm_image2('setparams','col',box.col,'wt',box.wt);
      setappdata(gcf,'box',box);
      getappdata(gcf,'box');
   end
elseif evnt.Key == '3'    
   if box.isOverlayOnly==0; 
       box.isOverlayOnly=1;
      spm_image2('setparams','col',box.col,'wt',5);
      setappdata(gcf,'box',box);
      getappdata(gcf,'box');
   else
       box.isOverlayOnly=0;
      spm_image2('setparams','col',box.col,'wt',box.wt);
      setappdata(gcf,'box',box);
      getappdata(gcf,'box');
   end 
 
   elseif evnt.Key == '4'    
   if box.isOverlayOnly==0; 
       box.isOverlayOnly=1;
      spm_image2('setparams','col',box.col,'wt',5);
      setappdata(gcf,'box',box);
      getappdata(gcf,'box');
   else
       box.isOverlayOnly=0;
      spm_image2('setparams','col',box.col,'wt',0);
      setappdata(gcf,'box',box);
      getappdata(gcf,'box');
   end 
   
elseif evnt.Character == 't'      
   global st
    r1=st.vols{1};
    r2=st.overlay;
    try
  adjuest=round(-(r1.dim/2)'.*diag(r1.mat(1:3,1:3)));
    catch
      disp('no overlay selected..');
        return
    end
  
  for i=1:3
      hfig=findobj(0,'tag','Graphics');
      ex=findobj(hfig,'callback',['spm_image(''repos'',' num2str(i) ')' ]);
      set(hfig,'CurrentObject',ex  );
      set(ex,'string',num2str(adjuest(i)) );
      hgfeval(get(ex,'callback'));
  end
  spm_orthviews2('Redraw');
  
  
  
  
  
  
    
elseif evnt.Character == 'c'      
     col=colorui;
     spm_image2('setparams','col',col) ;
elseif strcmp(evnt.Key , 'o'  )   &  length(evnt.Modifier) == 0
    spm_image2('addoverlay')
     spm_image2('setparams','col',box.col,'wt',box.wt);
   
   global st
   name2save=st.overlay.fname;
   tx=textread(which('keyb.m'),'%s','delimiter','\n');
i1=find(strcmp(tx,'%% pprivate-path'))+1;
i2=find(strcmp(tx,'%% pprivate-pathEND'))-1;
paths =tx(i1:i2);
paths2=[paths; {['% ' name2save ]}];
iredun=find(strcmp(paths2,paths2(end)));
if length(iredun)>1
   paths2(iredun(2:end))=[]; 
end
tx2=[tx(1:i1-1); paths2; tx(i2+1:end)] ; 

fid = fopen([   'muell.m' ],'w','n');
    for i=1:size(tx2,1)
        dumh=char(  (tx2(i,:)) );
        fprintf(fid,'%s\n',dumh);        
    end
fclose(fid);











elseif strcmp(evnt.Key , 'o'  ) & strcmp(evnt.Modifier{:},'shift') & length(evnt.Modifier) == 1 
 

tx=textread(which('keyb.m'),'%s','delimiter','\n');
i1=find(strcmp(tx,'%% pprivate-path'))+1
i2=find(strcmp(tx,'%% pprivate-pathEND'))-1
paths=tx(i1:i2);
paths=regexprep(paths,{'%','''' ,' '}, {'','' ,''});
if isempty(char(paths))
   disp('no paths in memory');
   return
end

str =paths;
[s,v] = listdlg('PromptString','Select a file:',...
    'SelectionMode','single',...
    'ListString',str)
if v==0; return; end
img2overlay=paths(v)
global st
st.overlay=spm_vol(char(img2overlay));

spm_orthviews2('Redraw');            

  elseif evnt.Character == 'u' 
    spm_orthviews2('Redraw');
% elseif length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:},'control') & evnt.Key == 't'
%  'a' 
 
 
 
 
elseif   strcmp(evnt.Key,'leftarrow')           && isempty(evnt.Modifier)
    do('l', 'spm_image(''repos'',1)' , box.stpshift )
elseif   strcmp(evnt.Key,'rightarrow')           && isempty(evnt.Modifier)
    do('r', 'spm_image(''repos'',1)' ,-box.stpshift )
 
elseif   strcmp(evnt.Key,'uparrow')               && isempty(evnt.Modifier)
    do('l', 'spm_image(''repos'',3)' ,-box.stpshift )
elseif   strcmp(evnt.Key,'downarrow')              && isempty(evnt.Modifier)
    do('r', 'spm_image(''repos'',3)' , box.stpshift )   


elseif length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:},'control') & strcmp(evnt.Key ,'uparrow'    )
    do('l', 'spm_image(''repos'',2)' ,-box.stpshift )
elseif length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:},'control') & strcmp(evnt.Key , 'downarrow'    )
    do('l', 'spm_image(''repos'',2)' , box.stpshift )
elseif length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:},'control') & strcmp(evnt.Key ,'leftarrow'    )
    do('l', 'spm_image(''repos'',2)' ,-box.stpshift )
elseif length(evnt.Modifier) == 1 & strcmp(evnt.Modifier{:},'control') & strcmp(evnt.Key , 'rightarrow'    )
    do('l', 'spm_image(''repos'',2)' , box.stpshift )


%% ANGLES
elseif   strcmp(evnt.Key,'p')           && isempty(evnt.Modifier)
    do('l', 'spm_image(''repos'',4)' , box.stpangle )
elseif  strcmp(evnt.Key , 'p'    ) & strcmp(evnt.Modifier{:},'shift') & length(evnt.Modifier) == 1 
   do('l', 'spm_image(''repos'',4)' , -box.stpangle )
   
elseif   strcmp(evnt.Key,'r')           && isempty(evnt.Modifier)
    do('l', 'spm_image(''repos'',5)' , -box.stpangle )
elseif  strcmp(evnt.Key , 'r'    ) & strcmp(evnt.Modifier{:},'shift') & length(evnt.Modifier) == 1 
   do('l', 'spm_image(''repos'',5)' ,  box.stpangle )   

elseif   strcmp(evnt.Key,'y')           && isempty(evnt.Modifier)
    do('l', 'spm_image(''repos'',6)' , -box.stpangle )
elseif  strcmp(evnt.Key , 'y'    ) & strcmp(evnt.Modifier{:},'shift') & length(evnt.Modifier) == 1 
   do('l', 'spm_image(''repos'',6)' ,  box.stpangle )     
   
end


function helphelp
a={};
a{end+1,1}=' +++DISPLAY SHORTCUTS +++';
a{end+1,1}='[h]    shortcuts help';
a{end+1,1}='[o]    overlay reference image (userinput/dialog)';
a{end+1,1}='[c]    color selection for overlay)';
a{end+1,1}='[d]    default settings for color and overlay Transparency)';
a{end+1,1}='[t]    initial transpose (rough))';
a{end+1,1}='[u]    update overlay)';
a{end+1,1}='[+/-]  change transparency of overlay)';
a{end+1,1}=' ';
a{end+1,1}='[arrow up/down]           up/down';
a{end+1,1}='[arrow left/right]        left/right';
a{end+1,1}='[ctrl]+[arrow up/down]    backward/forward';
a{end+1,1}='[ctrl]+[arrow left/right] backward/forward';
a{end+1,1}=' ';
a{end+1,1}='[p] / [ctrl]+[p]          -/+pitch';
a{end+1,1}='[r] / [ctrl]+[r]          -/+roll';
a{end+1,1}='[y] / [ctrl]+[y]          -/+yaw';
a{end+1,1}='[1] change stepSize of translation & rotation';
a{end+1,1}='[2] toggle blendedIMG /Background ';
a{end+1,1}='[3] toggle blendedIMG /Overlay ';
a{end+1,1}='[4] toggle Background /Overlay ';
disp(char(a));

function do(key,callback, stp )

% stp=callback;
e=sort(findobj(gcf,'style','edit'));
% stp
% if strcmp(key,'l')
    ex=findobj(gcf,'callback' ,callback);

    val0=str2num(get(ex,'string'));
    val=val0+stp  ;
    set(1,'CurrentObject',ex)
%     try
        set(ex,'string',num2str(val) );
        hgfeval(get(ex,'callback'));
        spm_orthviews2('Redraw');
%     catch
%         set(ex,'string',num2str(val0) );
%         hgfeval(get(ex,'callback'));
%         spm_orthviews2('Redraw');
%     end
% end

% e=sort(findobj(gcf,'style','edit'))
% get(e,'string')
% ans = 
%     '2'
%     '1'
%     '0.5'
%     '0.001'
%     '0.002'
%     '0.003'
%     '1'
%     '1'
%     '1'
%     '4.9 1.7 -2.5'
%     '127.7 147.0 89.8'
% get(e,'callback')
% ans = 
%     'spm_image('repos',1)'
%     'spm_image('repos',2)'
%     'spm_image('repos',3)'
%     'spm_image('repos',4)'
%     'spm_image('repos',5)'
%     'spm_image('repos',6)'
%     'spm_image('repos',7)'
%     'spm_image('repos',8)'
%     'spm_image('repos',9)'
%     'spm_image('setposmm')'
%     'spm_image('setposvx')'



%% pprivate-path
% V:\mritools\tpm\pwhiter62.nii
%% pprivate-pathEND











