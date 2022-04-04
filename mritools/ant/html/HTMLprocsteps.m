

function htmlfiles=HTMLprocsteps(pastudy,pin)
htmlfiles={};
w.refresh=1;
w.show   =0;
% if exist('w')==0
%     w.refresh=1;
% end
if exist('p')==0
   pin.dummi=1; 
end
w=catstruct2(w,pin);


% ==============================================
%%   summarx single registration steps
% ===============================================

%% ==============[dirs]=================================
warning off

% pastudy ='H:\Daten-2\Imaging\AG_Harms\2021_Exp6_Cx30Flex\2017_Cx30FlexIL6'
w.pastudy=pastudy;
% w.pastudy='F:\data5\nogui';
w.padat   =fullfile(w.pastudy,'dat');

%% =============[get dirs]==================================
w.mdirs=spm_select('FPList',w.padat,'dir','.'); 
w.mdirs=cellstr(w.mdirs);
%% ==========[ html-folder ]=====================================
w.paout=fullfile(w.pastudy,'summary_steps');
mkdir(w.paout);





%% ===========[summary_separateSteps ]====================================
% [bs]:bodyStart,[cr]:coregistration,[se]:segmentation,[wa]:warping,[be]:bodyEnd
if 0
    a=preadfile(which('summary_separateSteps.txt'));
    a=a.all;
    % ===========
    is=[regexpi2(a,'<!doctype hmtl>') regexpi2(a,'</head>')];
    he=a(is(1):is(2));
    % ===========
    is=[regexpi2(a,'<body>') regexpi2(a,'<!-- begin:INITIALIZATION -->')];
    bs=a(is(1):is(2));
    % ===========
    is=[regexpi2(a,'<!-- begin:INITIALIZATION -->') regexpi2(a,'<!-- end:INITIALIZATION -->')];
    in=a(is(1):is(2));
    % ===========
    is=[regexpi2(a,'<!-- begin:COREGISTRATION -->') regexpi2(a,'<!-- end:COREGISTRATION -->')];
    cr=a(is(1):is(2));
    % ===========
    is=[regexpi2(a,'<!-- begin:SEGMENTATION -->') regexpi2(a,'<!-- end:SEGMENTATION -->')];
    se=a(is(1):is(2));
    % ===========
    is=[regexpi2(a,'<!-- begin:WARPING -->') regexpi2(a,'<!-- end:WARPING -->')];
    wa=a(is(1):is(2));
    % ===========
    is=[regexpi2(a,'<!-- end:WARPING -->') regexpi2(a,'</html>')];
    be=a(is(1):is(2));
end

% ==============================================
%%   write css-file
% ===============================================
cssfilename=fullfile(w.paout,'styles.css' );
writeCSSfile(cssfilename);


% ==============================================
%%   write HTML-files
% ===============================================
F1=makeHTML_INIT(w);
F2=makeHTML_COREG(w);
F3=makeHTML_SEGM(w);
F4=makeHTML_WARP(w);
% 

htmlfiles={F1;F2;F3;F3};

if w.show==1
    web(F1,'-new');
    web(F2,'-new');
    web(F3,'-new');
    web(F4,'-new');
end





% ==========================================================================================================================================
%%   [1] INITIALIZATION
% ==========================================================================================================================================
function F1=makeHTML_INIT(w)
be=getHTML_endlines(); 
he=getHTML_header('INI', w.refresh);
% ===============title================================
title='INITIALIZATION';
ti={...
    ['<A NAME="codewordTOP">']
    ['<b><h2 style="color:green; margin-top:3;margin-bottom:0"> ' title ' </h2></b>']
    ['<pre>']
    ['study: ' w.pastudy]
    ['date : ' datestr(now)]
    ['</pre>']

    };
%  loop over mdirs% ==============================================
in={};
for i=1:length(w.mdirs)
    ianimal=i;
    adir=w.mdirs{ianimal};
    adir2=fullfile(adir,'summary');
    [~,animalName]=fileparts(adir);
    
    
%     isexist    =exist(fullfile(adir2,'_msk_animated.gif'  ))==2;
%     msgExist='';
%     if isexist==0
%        msgExist= '<pre style="color:fuchsia; margin-top:0;margin-bottom:0"><font size="2">---not processed yet---</font></pre>';
%     end
    if 1==0 %isexist==0
%         t={...
%             ['<h4 style="color:fuchsia; margin-bottom:0"              > ' [ num2str(ianimal)   ']' animalName ]  ' </h2>']
%             '<pre style="color:gray; margin-top:0;margin-bottom:0"><font size="2">'
%             '---not processed yet---'
%             '</font></pre>'
%             };
    else
        msk         =strrep(fullfile( strrep(adir2,w.pastudy,'..'),'_msk.gif'),'\','/');
        t2          =strrep(fullfile( strrep(adir2,w.pastudy,'..'),'t2.gif'),'\','/');
        mskanimated =strrep(fullfile( strrep(adir2,w.pastudy,'..'),'_msk_animated.gif'),'\','/');
        mskID=['_msk' num2str(ianimal) ];
        
        % date of creation
        k=dir(fullfile( adir2,'_msk.gif'));
        createdatestr='';
        try
            createdatestr=['(created: ' k.date ')'];
        end
        
        
        
        t={...

            ['<h4 style="color:blue; margin-bottom:0"              > ' [ num2str(ianimal)   ']' animalName  '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' createdatestr ]  ' </h2>']            
            '<b><font size="2"><span style="background-color:rgb(255,215,0);">  overlay: [t2.nii] and [_msk.nii] </span></font></b><br>'
            
            ['<input type="button" value="start animation" onclick="document.getElementById(''' mskID ''').src=''' mskanimated '''">' ]
            
            ['<input type="button" value="stop animation"  onclick="document.getElementById(''' mskID ''').src=''' msk '''">' ]
            ['<input type="button" onclick="zoomimage(1,200,''' mskID ''')" value="-zoom" />']
            ['<input type="button" onclick="zoomimage(2,200,''' mskID ''')" value="+zoom" />']
            '<font size="2"> click image to toggle images</font>'
            '<br>'
            ['<img src="' msk '" id="' mskID '" width="400" height="400" onclick="changeImage(''' mskID ''',''' t2 ''',''' msk ''' )" value="Change">']
            
            ['<div class="grid fixed"><style="border:none;><img src="' t2 '" width="400" height="400" /></div>']
            ['<div class="grid fixed"><style="border:none;><img src="' msk '" width="400" height="400" /></div>']
            '<pre style="color:green; margin-top:0;margin-bottom:0"><font size="2">'
            '<!--processing time: 1 min, 19.9 secs  -->'
            '</font></pre>'
            '<!-- end:INITIALIZATION -->'
            };
    end
    in=[in;  t] ; 
end
% ['<img src="' msk '" alt="HTML5 Icon" style="width:128px;height:128px;">']
% ['<img src="/images/html5.gif" alt="HTML5 Icon" style="width:128px;height:128px;">']
% =======[write webside]=======================
z=[ he;          ;ti ;in       ;be   ];
F1=fullfile(w.paout,['stp1_' lower(title) '.html'] );
pwrite2file(F1,z);

% ==========================================================================================================================================
%%   [2] COREGISTRATION
% ==========================================================================================================================================

function F2=makeHTML_COREG(w)
be=getHTML_endlines(); 
he=getHTML_header('COREG', w.refresh);
% ===============title================================
title='COREGISTRATION';
ti={...
    ['<A NAME="codewordTOP">']
    ['<b><h2 style="color:green; margin-top:3;margin-bottom:0"> ' title ' </h2></b>']
    ['<pre>']
    ['study: ' w.pastudy]
    ['date : ' datestr(now)]
    ['</pre>']

    };
%  loop over mdirs% ==============================================
in={};
for i=1:length(w.mdirs)
    ianimal=i;
    adir=w.mdirs{ianimal};
    adir2=fullfile(adir,'summary');
    [~,animalName]=fileparts(adir);
    
    %isexist    =exist(fullfile(adir2,'_b1grey_animated.gif'  ))==2;
    if 1==0%isexist==0
%         t={...
%             ['<h4 style="color:fuchsia; margin-bottom:0"              > ' [ num2str(ianimal)   ']' animalName ]  ' </h2>']
%             '<pre style="color:gray; margin-top:0;margin-bottom:0"><font size="2">'
%             '---not processed yet---'
%             '</font></pre>'
%             };
    else
        
        IM1         =strrep(fullfile( strrep(adir2,w.pastudy,'..'),'_b1grey.gif'),'\','/');
        t2          =strrep(fullfile( strrep(adir2,w.pastudy,'..'),'t2.gif'),'\','/');
        animated    =strrep(fullfile( strrep(adir2,w.pastudy,'..'),'_b1grey_animated.gif'),'\','/');
        IM1id=['_b1grey' num2str(ianimal) ];
        IM3        =strrep(fullfile( strrep(adir,w.pastudy,'..'),'coreg2.jpg'),'\','/');
        
        % date of creation
        k=dir(fullfile( adir2,'_b1grey.gif'));
        createdatestr='';
        try
            createdatestr=['(created: ' k.date ')'];
        end

        t={...
            ['<h4 style="color:blue; margin-bottom:0"              > ' [ num2str(ianimal)   ']' animalName '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' createdatestr ]  ' </h2>']
            '<b><font size="2"><span style="background-color:rgb(255,215,0);">  overlay: [t2.nii] and [_b1grey.nii] </span></font></b><br>'
            
            ['<input type="button" value="start animation" onclick="document.getElementById(''' IM1id ''').src=''' animated '''">' ]
            
            ['<input type="button" value="stop animation"  onclick="document.getElementById(''' IM1id ''').src=''' IM1 '''">' ]
            ['<input type="button" onclick="zoomimage(1,200,''' IM1id ''')" value="-zoom" />']
            ['<input type="button" onclick="zoomimage(2,200,''' IM1id ''')" value="+zoom" />']
            '<font size="2"> click image to toggle images</font>'
            '<br>'
            ['<img src="' IM1 '" id="' IM1id '" width="300" height="300" onclick="changeImage(''' IM1id ''',''' t2 ''',''' IM1 ''' )" value="Change">']
            
            ['<div class="grid fixed"><style="border:none;><img src="' t2 '" width="300" height="300" /></div>']
            ['<div class="grid fixed"><style="border:none;><img src="' IM1 '" width="300" height="300" /></div>']
            ['<div class="grid fixed"><style="border:none;><img src="' IM3 '" width="300" height="300" /></div>']
            '<pre style="color:green; margin-top:0;margin-bottom:0"><font size="2">'
            '<!--processing time: 1 min, 19.9 secs  -->'
            '</font></pre>'
            };
    end
    in=[in; t] ; 
end
% ['<img src="' msk '" alt="HTML5 Icon" style="width:128px;height:128px;">']
% ['<img src="/images/html5.gif" alt="HTML5 Icon" style="width:128px;height:128px;">']  
% =======[write webside]=======================
z=[ he;          ;ti ;in       ;be   ];
F2=fullfile(w.paout,['stp2_' lower(title) '.html'] );
pwrite2file(F2,z);

% ==========================================================================================================================================
%      [3]  SEGMENTATION
% ==========================================================================================================================================


function F3=makeHTML_SEGM(w)
be=getHTML_endlines(); 
he=getHTML_header('SEGM', w.refresh);
% ===============title================================
title='SEGMENTATION';
ti={...
    ['<A NAME="codewordTOP">']
    ['<b><h2 style="color:green; margin-top:3;margin-bottom:0"> ' title ' </h2></b>']
    ['<pre>']
    ['study: ' w.pastudy]
    ['date : ' datestr(now)]
    ['</pre>']

    };
%  loop over mdirs% ==============================================
in={};
for i=1:length(w.mdirs)
    ianimal=i;
    adir=w.mdirs{ianimal};
    adir2=fullfile(adir,'summary');
    [~,animalName]=fileparts(adir);
    
%     isexist    =exist(fullfile(adir2,'c1t2_animated.gif'  ))==2;
    if 1==0%isexist==0
%         t={...
%             ['<h4 style="color:fuchsia; margin-bottom:0"              > ' [ num2str(ianimal)   ']' animalName ]  ' </h2>']
%             '<pre style="color:gray; margin-top:0;margin-bottom:0"><font size="2">'
%             '---not processed yet---'
%             '</font></pre>'
%             };
    else
        
        IM1         =strrep(fullfile( strrep(adir2,w.pastudy,'..'),'c1t2.gif'),'\','/');
        t2          =strrep(fullfile( strrep(adir2,w.pastudy,'..'),'t2.gif'),'\','/');
        animated    =strrep(fullfile( strrep(adir2,w.pastudy,'..'),'c1t2_animated.gif'),'\','/');
        IM1id=['c1t2' num2str(ianimal) ];
        IM3        =strrep(fullfile( strrep(adir,w.pastudy,'..'),'coreg2.jpg'),'\','/');
        
        % date of creation
        k=dir(fullfile( adir2,'c1t2.gif'));
        createdatestr='';
        try
            createdatestr=['(created: ' k.date ')'];
        end

        t={...
            ['<h4 style="color:blue; margin-bottom:0"              > ' [ num2str(ianimal)   ']' animalName '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' createdatestr]  ' </h2>']
            '<b><font size="2"><span style="background-color:rgb(255,215,0);">  overlay: [t2.nii] and [c1t2.nii] </span></font></b><br>'
            
            ['<input type="button" value="start animation" onclick="document.getElementById(''' IM1id ''').src=''' animated '''">' ]
            
            ['<input type="button" value="stop animation"  onclick="document.getElementById(''' IM1id ''').src=''' IM1 '''">' ]
            ['<input type="button" onclick="zoomimage(1,200,''' IM1id ''')" value="-zoom" />']
            ['<input type="button" onclick="zoomimage(2,200,''' IM1id ''')" value="+zoom" />']
            '<font size="2"> click image to toggle images</font>'
            '<br>'
            ['<img src="' IM1 '" id="' IM1id '" width="400" height="400" onclick="changeImage(''' IM1id ''',''' t2 ''',''' IM1 ''' )" value="Change">']
            
            ['<div class="grid fixed"><style="border:none;><img src="' t2 '" width="400" height="400" /></div>']
            ['<div class="grid fixed"><style="border:none;><img src="' IM1 '" width="400" height="400" /></div>']
%             ['<div class="grid fixed"><style="border:none;><img src="' IM3 '" width="300" height="300" /></div>']
%             '<pre style="color:green; margin-top:0;margin-bottom:0"><font size="2">'
            '</font></pre>'
            };
    end
    in=[in; t] ; 
end
% ['<img src="' msk '" alt="HTML5 Icon" style="width:128px;height:128px;">']
% ['<img src="/images/html5.gif" alt="HTML5 Icon" style="width:128px;height:128px;">']
% =======[write webside]=======================
z=[ he;          ;ti ;in       ;be   ];
F3=fullfile(w.paout,['stp3_' lower(title) '.html'] );
pwrite2file(F3,z);

% ==========================================================================================================================================
%      [4]  WARPING
% ==========================================================================================================================================
function F4=makeHTML_WARP(w);
be=getHTML_endlines(); 
he=getHTML_header('WARP', w.refresh);
% ===============title================================
title='WARPING';
ti={...
    ['<A NAME="codewordTOP">']
    ['<b><h2 style="color:green; margin-top:3;margin-bottom:0"> ' title ' </h2></b>']
    ['<pre>']
    ['study: ' w.pastudy]
    ['date : ' datestr(now)]
    ['</pre>']

    };
%  loop over mdirs% ==============================================
in={};
for i=1:length(w.mdirs)
    ianimal=i;
    adir=w.mdirs{ianimal};
    adir2=fullfile(adir,'summary');
    [~,animalName]=fileparts(adir);
    
%     isexist    =exist(fullfile(adir2,'c1t2_animated.gif'  ))==2;
    if 1==0%isexist==0
%         t={...
%             ['<h4 style="color:fuchsia; margin-bottom:0"              > ' [ num2str(ianimal)   ']' animalName ]  ' </h2>']
%             '<pre style="color:gray; margin-top:0;margin-bottom:0"><font size="2">'
%             '---not processed yet---'
%             '</font></pre>'
%             };
    else
        
        IM1         =strrep(fullfile( strrep(adir2,w.pastudy,'..'),'AVGT.gif'),'\','/');
        t2          =strrep(fullfile( strrep(adir2,w.pastudy,'..'),'x_t2.gif'),'\','/');
        animated    =strrep(fullfile( strrep(adir2,w.pastudy,'..'),'x_t2_animated.gif'),'\','/');
        IM1id=['x_t2' num2str(ianimal) ];
        %IM3        =strrep(fullfile( strrep(adir,w.pastudy,'..'),'coreg2.jpg'),'\','/');
        
        % date of creation
        k=dir(fullfile( adir2,'AVGT.gif'));
        createdatestr='';
        try
            createdatestr=['(created: ' k.date ')'];
        end
        
        t={...
            ['<h4 style="color:blue; margin-bottom:0"              > ' [ num2str(ianimal)   ']' animalName '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' createdatestr]  ' </h2>']
            '<b><font size="2"><span style="background-color:rgb(255,215,0);">  overlay: [AVGT.nii] and [x_t2.nii] </span></font></b><br>'
            
            ['<input type="button" value="start animation" onclick="document.getElementById(''' IM1id ''').src=''' animated '''">' ]
            
            ['<input type="button" value="stop animation"  onclick="document.getElementById(''' IM1id ''').src=''' IM1 '''">' ]
            ['<input type="button" onclick="zoomimage(1,200,''' IM1id ''')" value="-zoom" />']
            ['<input type="button" onclick="zoomimage(2,200,''' IM1id ''')" value="+zoom" />']
            '<font size="2"> click image to toggle images</font>'
            '<br>'
            ['<img src="' IM1 '" id="' IM1id '" width="400" height="400" onclick="changeImage(''' IM1id ''',''' t2 ''',''' IM1 ''' )" value="Change">']
            
            ['<div class="grid fixed"><style="border:none;><img src="' t2 '" width="400" height="400" /></div>']
            ['<div class="grid fixed"><style="border:none;><img src="' IM1 '" width="400" height="400" /></div>']
%             ['<div class="grid fixed"><style="border:none;><img src="' IM3 '" width="300" height="300" /></div>']
%             '<pre style="color:green; margin-top:0;margin-bottom:0"><font size="2">'
            '</font></pre>'
            };
    end
    in=[in; t] ; 
end
% ['<img src="' msk '" alt="HTML5 Icon" style="width:128px;height:128px;">']
% ['<img src="/images/html5.gif" alt="HTML5 Icon" style="width:128px;height:128px;">']
% =======[write webside]=======================
z=[ he;          ;ti ;in       ;be   ];
F4=fullfile(w.paout,['stp4_' lower(title) '.html'] );
pwrite2file(F4,z);

function writeCSSfile(cssfilename)
% ==============================================
%%   css
% ===============================================
if exist(cssfilename)==2; return; end
css={...
    '*,'
    '*::before,'
    '::after {'
    '  margin: 1;'
    '  padding: 0;'
    '  box-sizing: border-box;'
    '}'
    '.grid img {'
    '  display: block;'
    '}'
    '.grid {'
    '  display: inline-block;'
    '  position: relative;'
    '  margin: -1px;'
    '  vertical-align: top;'
    '}'
    '.grid::before,'
    '.grid::after {'
    '  content: '''';'
    '  position: absolute;'
    '  top: 0;'
    '  left: 0;'
    '  width: 100%;'
    '  height: 100%;'
    '  background: linear-gradient(to right, rgba(255, 0,0,1) 0px, transparent 1px);'
    '  background-size: 10%;'
    '}'
    '.grid::before {'
    ' background-color: transparent;'
    '}'
    '.grid::after {'
    '  transform: rotate(90deg);'
    '}'
    '.fixed::before,'
    '.fixed::after {'
    '  background-size: 20px;'
    '}'
    };

pwrite2file(cssfilename,css);



function he=getHTML_header(title, refresh)
% ==============================================
%%  header
% title: string
% refresh: 0/1
% ===============================================
r='';
if refresh==1;
    r= '<meta http-equiv="refresh" content="5" >';
end




he={...
    '<!doctype hmtl>  '
    '<html>            '
    ['<title>' title '</title>']
    r
    '<head>            '
    '<link rel="stylesheet" href="styles.css">'
    '    <title>#20170207CH_SC01#</title>       '
    '    <!-- Do not display this at the momen--> '
    '        <meta http-equiv="refresh" content="1000" >'
    '    <style>                                        '
    '        blink {     '
    '        animation: blinker 2.0s linear infinite; '
    '        color: green;                             '
    '        }                                          '
    '        @keyframes blinker {        '
    '        50% { opacity:100; }        '
    '        }                          '
    '    </style>                       '
    '</head>  '
    };

function be=getHTML_endlines()
% ==============================================
%%  be
% ===============================================
be={...
'                                                                            '    
'    <A NAME="codewordEND">                                                   '   
'    <br><br><font size="3"><A HREF="#codewordTOP">[top]</A></font><br>       '   
'    <hr>                                                                     '   
'    <!-- ##############w2######################################################-->'
'                                                                               ' 
'    <!--font size="2">This is some text!</font-->                              ' 
'    <!--h5> bla bla </h5-->                                                    ' 
'    <script type="text/javascript">                               '              
'        function zoomimage()                                       '             
'        {                                                           '            
'        var task = parseInt(arguments[0]);   // 0,1 ..smaller larger '           
'        var SIZE = parseInt(arguments[1]);  //var SIZE = 200;      '             
'        var ID   = arguments[2];            //var ID   = "myImage";'             
'                                                                    '            
'                                                                    '      
'        if (task == 2){                                             '            
'        var myImg = document.getElementById(ID);                    '            
'        var currWidth = myImg.clientWidth;                          '            
'        if(currWidth == 2000){                                      '            
'        alert("Maximum zoom-in level reached.");                    '            
'        } else{                                                     '            
'        myImg.style.width = (currWidth + SIZE) + "px";              '            
'        myImg.style.height= (currWidth + SIZE) + "px";              '            
'        }                                                           '            
'        }                                                           '                                                                                            
'        else {                                                      '            
'        var myImg = document.getElementById(ID);                    '            
'        var currWidth = myImg.clientWidth;                          '            
'        if(currWidth-SIZE <= 150){                                  '            
'        myImg.style.width = 100 + "px";                             '            
'        myImg.style.height= 100 + "px";                             '            
'        } else{                                                     '            
'        myImg.style.width = (currWidth - SIZE) + "px";              '            
'        myImg.style.height = (currWidth -SIZE) + "px";              '            
'        }                                                           '            
'        }                                                           '            
'        }                                                           '            
'    </script>                                                       '            
'    <script>                                                        '            
'        function changeImage() {                                    '            
'                                                                    '            
'        var ID      = arguments[0];                                 '            
'        var BGimage = arguments[1]; //t2                            '            
'        var FGimage = arguments[2]; //c1t2                          '            
'                                                                    '            
'        var image = document.getElementById(ID);                    '            
'        if (image.src.match(FGimage)) {                             '            
'        image.src = BGimage;                                        '            
'        }                                                            '           
'        else {                                                       '           
'        image.src = FGimage;                                         '           
'        }                                                            '           
'        }                                                            '           
'    </script>                                                        '           
'    <script>                                                         '           
'        var minutesLabel = document.getElementById("minutes");       '           
'        var secondsLabel = document.getElementById("seconds");       '           
'        var totalSeconds = 0;                                        '           
'        setInterval(setTime, 1000);                                  '           
'                                                                     '           
'        function setTime() {                                         '           
'        ++totalSeconds;                                              '           
'        secondsLabel.innerHTML = pad(totalSeconds % 60);             '           
'        minutesLabel.innerHTML = pad(parseInt(totalSeconds / 60));   '           
'        }                                                            '           
'                                                                     '           
'        function pad(val) {                                          '           
'        var valString = val + "";                                    '           
'        if (valString.length < 2) {                                  '           
'        return "0" + valString;                                      '           
'        } else {                                                     '           
'        return valString;                                            '           
'        }                                                            '           
'        }                                                          '             
'    </script>                                                       '                                                                                          
'</body>                                                              '           
'</html>                                                         '                
};
