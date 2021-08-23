
% #yk convert image to SNR-image
% #k Using corrected SNR-calculation according to Gudbjartsson H, Patz S. 
% #k The Rician distribution of noisy MRI data. Magn Reson Med. 1995 Dec; 34(6): 910–914.
% #k  can be used for Fluorine-19 (19F)-contrast images 
%
% If specified ('showimage' set to 2), a HTML-file is generated displaying the fit,the input and
% output images and some image paramters. Per default the HTML-file is stored in the 'checks'-folder
% in the respsective study-folder.
% 
% - used subfunction: [snrAuto.m] 
% #r First select animals (directories) from left ANT-listbox before execution of this function

  
% 
% #ko PARAMETER
% 'file'         : image to convert to SNR-image (multiple files possible), 3D or 4D   
% 'fileoutname'  : output filename of the SNR-image. Number of output filenames must match the number of input files  
%                  -leave "fileoutname" empty when using the "suffix"-option 
% 'suffix'       : <optional> instead of "fileoutname" append a suffix-string to the input file name as output name.
% 
% 'histbinfactor': factor to increase the histogram-bins (internal: "fac") 
%                  default: 1  
% 'showimage'    : show image: [0]no;[1]show fitted image on the fly;[2]store images as HTML-file in "checks"-path {0,1,2} 
%                  default: 2 ...i.e a HTML-file is generated          
% 'checkspath'   : select path to write the HTMLfile with images for post-checks. 
%                  This selection is only necessary if "showimage" is set to 2
%                  Per default the HTML-file is stored in the 'checks'-folder in the study-folder but
%                  you can assign another folder
% 'outputstring' : <optional> Output string added (as prefix) to the HTML-filename
%                   This selection is only necessary if "showimage" is set to 2
% 
% #ko CMD
% xcalcSNRimage(1)  : % open GUI, without input parameters + specify paramters via GUI
% xcalcSNRimage(1,z); % open GUI, with defined parameters, you can specify paramters via GUI
% xcalcSNRimage(0,z); % execute with predefiend paramters defined in z without GUI
% 
% #ko EXAMPLE
% z=[];                                                                                                                                                               
% z.file          = { 'flour19f.nii' };                    % % [SELECT] image to convert to SNR-image (multiple files possible)                                       
% z.fileoutname   = { '' };                                % % output filename of the SNR-image. Number of output filenames must match the number of input files      
% z.suffix        = '_SNR';                                % % <optional> instead of "fileoutname" append a suffix-string to the input file name as output name.      
% z.histbinfactor = [1];                                   % % factor to increase the histogram-bins (internal: "fac")                                                
% z.showimage     = [2];                                   % % show image: [0]no;[1]show fitted image on the fly;[2]store images as HTML-file in "checks"-path {0,1,2}
% z.checkspath    = 'F:\data4\ernst_10aug21_2\checks';     % % [SELECT] checkspath: path to write HTMLfile with images. )                                             
% z.outputstring  = '';                                    % % <optional> Output string (prefix) added to the HTML-filename                       
% xcalcSNRimage(1,z);   % % execute with open GUI







function xcalcSNRimage(showgui,x,pa)


if 0
    % ==============================================
    %%
    % ===============================================
    
    pa={
        'F:\data4\ernst_10aug21_2\dat\snr_flour_calc'
        'F:\data4\ernst_10aug21_2\dat\snr_flour_calc2'
        };
    xcalcSNRimage(1,[],pa)
    
    %   % ==============================================
    %%
    % ===============================================
end

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



%===========================================
%%   %% test SOME INPUT
%===========================================


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

checkspath=fullfile(fileparts(fileparts(pa{1})),'checks');

%% ________________________________________________________________________________________________
%%  PARAMETER-gui
%% ________________________________________________________________________________________________
if exist('x')~=1;        x=[]; end

p={...
    'file'            {''}  '[SELECT] image to convert to SNR-image (multiple files possible)'    {@selector2,li,{'Image'},'out','list','selection','multi'}
    
    'fileoutname'   {''}    'output filename of the SNR-image. Number of output filenames must match the number of input files  '     ''
    'suffix'   ''           '<optional> instead of "fileoutname" append a suffix-string to the input file name as output name. '  {'_SNR' ''}
    
    'inf1' ''  '____PARAMETER____'  ''
    'histbinfactor'  1 'factor to increase the histogram-bins (internal: "fac")' {1 2 5 10}
    'showimage'     2 'show image: [0]no;[1]show fitted image on the fly;[2]store images as HTML-file in "checks"-path {0,1,2}' {0,1,2}
    'checkspath'      checkspath         '[SELECT] checkspath: path to write HTMLfile with images. )'  'd'
    'outputstring'    ''                  '<optional> Output string (prefix) added to the HTML-filename'  ''
%     'size'    300    'Image size in HTML file (in pixels)' {100 200 300 400 500}
    };


p=paramadd(p,x);%add/replace parameter
%     [m z]=paramgui(p,'uiwait',0,'close',0,'editorpos',[.03 0 1 1],'figpos',[.2 .3 .7 .5 ],'title','PARAMETERS: LABELING');

% %% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[0.0840    0.2711    0.62    0.3056 ],...
        'title',['***make SNR-image*** ('  mfilename ')' ],'info',hlp);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end


%===========================================
%%   checks
%===========================================
if isempty(char(z.checkspath))
    try
        global an
        z.checkspath= fullfile( fileparts(an.datpath),'checks');
    end
    if isempty(char(z.checkspath))
        [od]=uigetdir(pwd,'select/create+select output directory');
        if isnumeric(od);
            disp('canceled'); return;
        else
            z.checkspath=od ;
        end
    end
end

%===========================================
%%   history
%===========================================
xmakebatch(z,p, mfilename);


% ==============================================
%%   process
% ===============================================

z.file        =cellstr(z.file);
z.fileoutname =cellstr(z.fileoutname);
z.checkspath =char(z.checkspath);
pa=cellstr(pa);

isshowonline=z.showimage==1;
usesuffix   =1;
if max(cellfun(@isempty,z.fileoutname)) && cellfun(@isempty,cellstr(z.suffix))
    %% both filename empty and suffix empty
     usesuffix=1;
     z.suffix='__SNR';
     disp('no outputfilename or suffix specified ... using "__SNR" as suffix ');
elseif ~cellfun(@isempty,cellstr(z.suffix)) 
    usesuffix   =1;
elseif length(z.file) == length(z.fileoutname) 
    %% filename and suffix have SAME length --> no suffix used
    usesuffix=0;
end




% return


for j=1:length(z.file)
    for i=1:length(pa)
        pas  =pa{i} ;
        [~,animal]=fileparts(pas);
        filename =z.file{j};
        f1=fullfile(pas,  filename);
        
        
        if exist(f1)==2
            [ha a ]=rgetnii(f1);
            
            [snrMap,estStd,h,s] = snrAuto(a, isshowonline ,z.histbinfactor, ['input: ' f1]);
            
            % ------------------------
            if usesuffix==1
                suffix=z.suffix;
                filenameout=stradd(filename,suffix,2);
            else
                filenameout=z.fileoutname{j};
                filenameout=[strrep(filenameout,'.nii','') '.nii'];
                
            end
            % ------------------------
            
%             % output-filename
%             if ~isempty(z.fileoutname{j})
%                 filenameout=z.fileoutname{j};
%                 filenameout=[strrep(filenameout,'.nii','') '.nii'];
%             else
%                 suffix=z.suffix;
%                 if isempty(suffix)
%                     suffix='_SNR';
%                 end
%                 filenameout=stradd(filename,suffix,2);
%             end
            f2=fullfile(pas,  filenameout);
            rsavenii(f2 ,ha,snrMap);
            [~,shortnames]=fileparts2({f1,f2});
            showinfo2(['..SNR-image: ' animal ' '],f2,[],[], ...
                [ ' ..INPUT:"' shortnames{1} '.nii' '"; OUTPUT:"'  shortnames{2} '.nii"']);
            
            if z.showimage==2
                % HTML-file
                s.filename=filename;
                s.pas=pas;
                s.index=i;
                s.animal =animal;
                
                s.f1     =f1;
                s.f2     =f2;
                
                
                
                s.snrMap =snrMap;
                s.estStd =estStd;
                s.img    =a;
                s.isOK   = 1;
                makeHTMimagesL(z,s);
            end
            
        else %file does not exist
            
            if z.showimage==2
                s={};
                s.filename=filename;
                s.pas     =pas;
                s.index=i;
                s.animal =animal;
                
                s.f1 = f1;
                s.f2 =[];
                s.isOK   = 0;
                
            end
            
        end
        
        % make HTMLFILE
        if z.showimage==2
            if i==1 && j==1
                w=makeHTML([],z,s,'create');
            end
            w=makeHTML(w,z,s);
        end
        
        
    end %animal
    
end %file

if z.showimage==2
    w=makeHTML(w,z,s,'write');
end
disp(['Done.'])

% ==============================================
%%   make HTML
% ===============================================

function wout=makeHTML(w,z,s,task)
if exist('task')~=1; task=''; end

checkspath=char(z.checkspath);
mkdir(checkspath);
% paout=fullfile(checkspath, s.animal );
% mkdir(paout);

[~,filestr,ext]=fileparts(s.filename);
if isempty(z.outputstring)
    focusfile=[ filestr    ];
else
    focusfile=[ z.outputstring '_' filestr    ];
end
paout=fullfile(checkspath, focusfile ,s.animal);


htmlfile  =fullfile(checkspath, [focusfile  '.html']);
% htmlfolder=fullfile(checkspath, [ z.outputstring '_' filestr  ]);
% ==============================================
%%
% ===============================================
if strcmp(task,'create');
    w=...;
        {
        '<!DOCTYPE html>'
        '<html>'
        '<head>'
        '<meta name="viewport" content="width=device-width, initial-scale=1">'
        '<style>'
        '* {'
        '  box-sizing: border-box;'
        '}'
        '.row {'
        '  display: flex;'
        '}'
        'h1, h2, h3 h4, h5 {'
        'margin: 0px;'
        '}'
        '/* Create three equal columns that sits next to each other */'
        '.column {'
        '  flex: 33.33%;'
        '  padding: 1px;'
        '}'
        'pre.inline {'
        '  display: inline;margin: 0;padding: 0;line-height: 10px;font-size: 12px; background-color: blue;'
        '}'
        
        'ps{'
        '    font-size : 12px;'
        '    font-family: "Courier New";'
        '    background-color : white;'
        '    padding : 0;'
        '    margin : 0;'
        '    line-height : 12px;'
        '}'
        '#p2{'
        '    background-color : #fcc;'
        '}'
        
        
        '</style>'
        '</head>'
        '<body>'
        [ '<font color=blue>' '<h4><u>' s.filename '</u>' '</h4>'  '<font color=black>' ]
        };
    wout=w;
    %     pwrite2file(htmlfile,wout);
    
    % ==============================================
    %%
    % ===============================================
    
    return
    
elseif strcmp(task,'write');
    wout=w;
     %% ---
    l={'<br><hr>'
       '<font size="-2" color=gray>'
        [repmat('&nbsp',[1 10]) 'created: ' datestr(now)]
        '</font>'
        '</body>'
        '</html>'
        };
    %% ---
    wout=[w; l];
    pwrite2file(htmlfile,wout);
    showinfo2([' HTML-file: ' ' '],htmlfile);
    return
end

% ==============================================
%%
% ===============================================
aname=s.animal;
sp='&nbsp';
idx=s.index;
% siz=z.size;


% if isfield(z,)

% l={ [ '<font color=blue>' '<h4><u>' s.filename '</u>' '</h4>'  '<font color=black>' ];
%     %['</body>' ]
%     };
% l{end+1,1}=[ '<font color=green>' '<h5> ' num2str(idx) ']'  sp    aname   ' (source: ' s.f1 ')'  '<font color=black>' '</h5>'     ] ;

% .                  img_fit.png
% ..                 img_fitzoom.png
% img_ORIGimage.jpg
% img_SNRimage.jpg
% img=fullfile(paout,'img_fit.png');
% l{end+1,1}= ['<div class="grid fixed"><style="border:none;><img src="' img '" width="' num2str(siz) '" height="' num2str(siz) '" /></div>'] ;
%
% img=fullfile(paout,'img_fitzoom.png');
% l{end+1,1}= ['<div class="grid fixed"><style="border:none;><img src="' img '" width="' num2str(siz) '" height="' num2str(siz) '" /></div>'] ;


img1=fullfile(paout,'img_fit.png');
img2=fullfile(paout,'img_fitzoom.png');
img3=fullfile(paout,'img_ORIGimage.jpg');
img4=fullfile(paout,'img_SNRimage.jpg');

if s.isOK==0
    w2={...
        [ '<font color=green>' '<h5> ' num2str(idx) ']'  sp    aname    repmat(sp,[1 5]) '<font size="-2">'   '<font color=black> source: ' s.f1  '</h5>'     ]
        %         [  '<font size="-2">']
        [  '  <b> <font color="red">      IMAGE NOT FOUND!!!'  '<font color=black>'  '</b>'  '<br>']
        '</font>'
        '</font>'
        '</font>'
        '</font>'
        };
    
    
elseif s.isOK==1
    w2=...
        {
        [ '<font color=green>' '<h5> ' num2str(idx) ']'  sp    aname    repmat(sp,[1 5]) '<font size="-2">'   '<font color=black> source: ' s.f1  '</h5>'     ]
        %  '<p>How to create side-by-side images with CSS Flexbox:</p>'
        '<div class="row">'
        '  <div class="column">'
        [ '    <img src="' img1  ' " alt="missing file" style="width:100%">']
        '  </div>'
        '  <div class="column">'
        [ '    <img src="' img2  ' " alt="missing file" style="width:100%">']
        '  </div>'
        '  <div class="column">'
        [ '    <img src="' img3  ' " alt="missing file" style="width:100%">']
        '  </div>'
        '  <div class="column">'
        [ '    <img src="' img4  ' " alt="missing file" style="width:100%">']
        '  </div>'
        '</div>'
        
        '<ps>'
        '<font size="-2">'
        [ '<b>' 'file out: '  '</b>'  s.f2  '<br>']
        [ '<b>' 'histbinfactor: '  '</b>'  num2str(z.histbinfactor)   ]
        [ '<b>'  'estStd: '         '</b>' num2str(s.estStd) '<br>']
        
        '<div>'
        %  [ '<ps>' ['ORIG-IMAGE: ' '   MIN: ' num2str(min(s.img(:)))   '; MAX: ' num2str(max(s.img(:)))     '; MEAN: ' num2str(mean(s.img(:)))    '; MED: ' num2str(median(s.img(:)))    ] '</ps>' '<br>']
        %  [ '<ps>' ['SNR-IMAGE:  ' 'MIN:' num2str(min(s.snrMap(:))) '; MAX: ' num2str(max(s.snrMap(:)))  '; MEAN: ' num2str(mean(s.snrMap(:))) '; MED: ' num2str(median(s.snrMap(:))) ] '</ps>']
        %
        %  [ '<pre>' ...
        %  ['ORIG-IMAGE: ' 'MIN: ' num2str(min(s.img(:)))   ';<td> MAX: ' num2str(max(s.img(:)))     '; MEAN: ' num2str(mean(s.img(:)))    '; MED: ' num2str(median(s.img(:)))    ]  '<br>']
        %  [  ...
        %  ['SNR-IMAGE:  ' 'MIN:' num2str(min(s.snrMap(:))) '; MAX: ' num2str(max(s.snrMap(:)))  '; MEAN: ' num2str(mean(s.snrMap(:))) '; MED: ' num2str(median(s.snrMap(:))) ] '</pre>']
        %
        %
        
        %  '<table style="width:30%; align="center"> '
        ' <table border=".5" '
        '          align="left">'
        '  <tr>'
        [ '    <th>image</th>']
        [ '    <th>Mean</th>']
        [ '    <th>Median</th>']
        [ '    <th>Min</th>']
        [ '    <th>Max</th>']
        [ '    <th>SD</th>']
        '  </tr>'
        '  <tr>'
        [ '    <th>' 'Original-image' '</th>']
        [ '    <th>' num2str(mean(   s.img(:))) '</th>']
        [ '    <th>' num2str(median( s.img(:))) '</th>']
        [ '    <th>' num2str(min(    s.img(:))) '</th>']
        [ '    <th>' num2str(max(    s.img(:))) '</th>']
        [ '    <th>' num2str(std(    s.img(:))) '</th>']
        
        
        '  </tr>'
        '  <tr>'
        [ '    <th>' 'SNR-image' '</th>']
        [ '    <th>' num2str(mean(  s.snrMap(:))) '</th>']
        [ '    <th>' num2str(median(s.snrMap(:))) '</th>']
        [ '    <th>' num2str(min(   s.snrMap(:))) '</th>']
        [ '    <th>' num2str(max(   s.snrMap(:))) '</th>']
        [ '    <th>' num2str(std(   s.snrMap(:))) '</th>']
        '  </tr>'
        '</table>'
        '</div>'
        ['<br>' '<br>' '<br>' '<br>']
        %      '<font size="+0">'
        '</font>'
        '</font>'
        '</font>'
        %     '</body>'
        %     '</html>'
        };
end


% d=preadfile(htmlfile); d=d.all
wout=[w; w2];
% pwrite2file(htmlfile,wout);


% ==============================================
%%
% ===============================================


function makeHTMimagesL(z,s)

try
    
    checkspath=char(z.checkspath);
    mkdir(checkspath);
    % paout=fullfile(checkspath, s.animal );
    
    
    [~,filestr,ext]=fileparts(s.filename);
    % htmlfile  =fullfile(checkspath, [ z.outputstring '_' filestr  '.html']);
    if isempty(z.outputstring)
        focusfile=[ filestr    ];
    else
        focusfile=[ z.outputstring '_' filestr    ];
    end
    paout=fullfile(checkspath, focusfile ,s.animal);
    mkdir(paout);

    % ==============================================
    %%   make path
    % ===============================================
    
%     checkspath=char(z.checkspath);
%     mkdir(checkspath);
%     paout=fullfile(checkspath,'dat', s.animal );
%     mkdir(paout);
    
    if isempty(s.f2); return;end
    % ==============================================
    %%   figure
    % ===============================================
    
    px=s.p1;
    hf=figure('visible','off');
    hold on;
    plot(px.binLoc,px.binCount,'k.');
    plot(px.x,px.y,'b','LineWidth',1.5);
    xlabel(px.descr{1});
    ylabel(px.descr{2});
    title(px.descr{3});
    
    fimg=fullfile(paout,'img_fit.png');
    saveas(hf,fimg);
    
    
    px=s.p2;
    hf=figure('visible','off');
    hold on;
    plot(px.binLoc,px.binCount,'k.');
    plot(px.x,px.y,'b','LineWidth',1.5);
    xlabel(px.descr{1});
    ylabel(px.descr{2});
    title(px.descr{3});
    
    fimg=fullfile(paout,'img_fitzoom.png');
    saveas(hf,fimg)
    
    % --------------
    % ==============================================
    %%  orig image
    % ===============================================
    
    
    b=s.img(:,:,:,1);
    b2=montageout(permute(b,[1 2 4 3]));
    hf=figure('visible','off');
    imagesc(b2);
    colorbar;
    title('orig-image (..first 3D-volume)');
    
    fimg=fullfile(paout,'img_ORIGimage.jpg');
    saveas(hf,fimg);
    % print -djpeg fimg
    
    
    % ==============================================
    %%  SNR image
    % ===============================================
    
    
    b=s.snrMap(:,:,:,1);
    b2=montageout(permute(b,[1 2 4 3]));
    hf=figure('visible','off');
    imagesc(b2);
    colorbar;
    title('SNR-image (..first 3D-volume)');
    
    fimg=fullfile(paout,'img_SNRimage.jpg');
    saveas(hf,fimg);
    % print -djpeg fimg
    
    
    
end












