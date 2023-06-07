

function xdraw_caller(showgui,x,pa)



%===========================================
%%   PARAMS
%===========================================
if exist('showgui')==0 || isempty(showgui) ;    showgui=1                ;end
if exist('x')==0                          ;    x=[]                     ;end
if exist('pa')==0      || isempty(pa)      ;   try pa=antcb('getsubjects') ;catch; pa=[];end ;end

if ischar(pa);                      pa=cellstr(pa);   end
if isempty(x) || ~isstruct(x)  ;  %if no params spezified open gui anyway
    showgui  =1   ;
    x=[]          ;
end



%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
if isempty(pa)
    msg='select one/multiple animal folders';
    [t,sts] = spm_select(inf,'dir',msg,'',pwd,'[^\.]'); % do not include 'upper' dir
    if isempty(t); return; end
    pa=cellstr(t);
end

% ==============================================
%%
% ===============================================

%% fileList
if 1
    fi2={};
    for i=1:length(pa)
        [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
    end
    li=unique(fi2);
end



%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end

p={...
    'inf1' ''  '____SOURCE____'  ''
    'source'     1        'chose image source: [1] from selected animal folders [2] from another folder'  {1 2}
    
    'inf2' ''  ''  ''
    'inf0' ''  '____ONLY IF "SOURCE" IS [1] (ANIMAL FOLDERS)'  ''
    'bgImg'   {'t2.nii'}                '[SELECT] Background image to draw a mask'      {@selector2,li,{'BackgroundImage'},'out','list','selection','single'}
    'maskImg'      {''}                 'optional: [SELECT] mask image to modif...'         {@selector2,li,{'MaskImage(s)'},'out','list','selection','single'}
    };


p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[0.3535    0.4133    0.4479    0.1533 ],...
        'title',['***DRAW MASK*** ('  mfilename ')' ],'info',hlp);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end



%===========================================
%%   history
%===========================================
xmakebatch(z,p, mfilename);



% ==============================================
%%   process
% ===============================================
if z.source==1
    for i=1:length(pa)
        sprintf('%s' ,'draw mask: ');
        f1=fullfile(pa{i},char(z.bgImg));
        f2=fullfile(pa{i},char(z.maskImg));
        
        [~,animalname]=fileparts(pa{i});
        
        if exist(f1)
            if ~isempty(char(z.maskImg)) && exist(f2)
                cprintf('*[0 0 1]',['draw mask for ' '[' animalname ']: ']);
                cprintf(' [0 0 0]',[' BG: ' char(z.bgImg) '; MSK: ' char(z.maskImg)  '\n']);
                xdraw(f1,f2);
            else
                cprintf('*[0 0 1]',['draw mask for ' '[' animalname ']: ']);
                cprintf(' [0 0 0]',[' BG: ' char(z.bgImg)  '\n']);
                xdraw(f1,[]);
                
            end
        else
            cprintf(' [1 0 1]',[' BG-image: ' char(z.bgImg)  ' does not exist\n']);
        end
        
        disp('..READY to draw... ');
        drawnow;
        uiwait(findobj(0,'tag','xpainter'));
        
    end
    cprintf(' [0 .5 0]',['DONE!\n']);
elseif z.source==2
    xdraw;
end




% %% ===============================================
%
% mdirs=antcb('getsubjects');
%
% datpath=fileparts(mdirs{1})
%
%
%
%
% % ro=antcb('selectimageviagui', datpath, 'single');
%
%
% %===================================================================================================
% %% ===============================================
%
% ro=antcb('selectimageviagui', mdirs{1}, 'single');