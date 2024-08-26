

% ==============================================
%%
% ===============================================

bg=fullfile(pwd,'RS_AVGT.nii.gz')
f1=fullfile(pwd,'lev3_ICcomp0010__tfce_corrp_tstat1.nii.gz')
f2=fullfile(pwd,'lev3_ICcomp0010__tstat1.nii.gz')


[ha a mm]=rgetnii(f1);
% [hb b bmm]=rgetnii(bg2);
a2=a(:);
ic=max(find(a2==max(a2)));
ce=mm(:,ic)'


% ==============================================
%%   save sginif
% ===============================================
a2=a(:);
ix=find(a2>0.95);
[hb b mm2]=rgetnii(f2);
b2=b(:);
z=zeros(size(b2));
z(ix)=b2(ix);
z2=reshape(z,hb.dim);

[pax fix ext]=fileparts(f2)
f3=fullfile(pax,[ stradd(fix , '_signif',2 ) '.gz' ]);
rsavenii(f3,hb,z2);




% ==============================================
%%
% ===============================================

q=orthoslice({bg, f3},'ce',ce(:)','mode','ovl','clim', [3 5] ,'cmap','hot', 'alpha',1,'cursorcol','w','fs',16,'cblabel','t-value');

% ==============================================
%%
% ===============================================
bg=fullfile(pwd,'RS_AVGT.nii.gz')
f3=fullfile(pwd,'lev3_ICcomp0010__tstat1_signif.nii.gz');
q=orthoslice({bg, f3},'ce','max','mode','ovl','clim', [3 5] ,'cmap','hot', 'alpha',1,'cursorcol','w','fs',16,'cblabel','t-value');

%% ===============================================

bg=fullfile(pwd,'RS_AVGT.nii.gz')
% f3=fullfile(pwd,'lev3_ICcomp0010__tstat1_signif.nii.gz');
f2=fullfile(pwd,'lev3_ICcomp0010__tstat1.nii.gz')

% q=orthoslice({bg, f2},'ce','max','mode','ovl','clim', [0 5] ,'cmap','hot', 'alpha',1,'cursorcol','w','fs',16,'cblabel','t-value');
q=orthoslice({bg, f2},'ce','max','mode','ovl','cmap','hot', 'alpha',1,'cursorcol','w','fs',16,'cblabel','t-value');


%% ===============================================

q=orthoslice({bg, f2},'ce','max','mode','ovl','clim', [0.0001 5] ,'cmap','hot', 'alpha',1,'cursorcol','w','fs',16,'cblabel','t-value');



%% ===============================================

q=orthoslice({bg, f2},'ce','max','mode','ovl','clim', [0.0001 5] ,'cmap','hot', 'alpha',1,'cursorcol','w','fs',16,'cblabel','t-value');

%% ===============================================



q=orthoslice({fullfile(pwd,'AVGT.nii') fullfile(pwd,'JD.nii')},'ce','max','mode','ovl','clim', [0.0001 5] ,'cmap','hot', 'alpha',1,'cursorcol','w','fs',16,'cblabel','t-value');

%% ===============================================

q=orthoslice({fullfile(pwd,'AVGT.nii') fullfile(pwd,'ANO.nii')},'mode','ovl','clim', [0 1000] ,'cmap','jet', 'alpha',1,'fs',14,'cblabel','t-value','panel',2,'bgcol','w','labelcol','b','blobthresh',1000);
%% ===============================================

q=orthoslice({fullfile(pwd,'AVGT.nii')},'mode','ovl','clim', [0 1000] ,'cmap','jet', 'alpha',.5,'fs',14,'cblabel','t-value','panel',2,'bgcol','w','labelcol','b');

%% ===============================================
bg=fullfile(pwd,'RS_AVGT.nii.gz')
f1=fullfile(pwd,'lev3_ICcomp0010__tstat1.nii.gz');
f2=fullfile(pwd,'lev3_ICcomp0010__tstat1_signif.nii.gz');
q=orthoslice({bg, f1},'panel',2);

% q=orthoslice({bg, f1},'ce','max','mode','ovl','clim', [3 5] ,'cmap','hot', 'alpha',1,'cursorcol','w','fs',16,'cblabel','t-value','panel',2);

%% ===============================================
bg=fullfile(pwd,'RS_AVGT.nii.gz')
f1=fullfile(pwd,'lev3_ICcomp0010__tstat1.nii.gz');
f2=fullfile(pwd,'lev3_ICcomp0010__tstat1_signif.nii.gz');
q=orthoslice({bg f1 f2},'panel',2);

q=orthoslice({bg f1 f2},'panel',2,'mslicemm',[-0.39 0 ],'bgcol','w','labelcol','r','mroco',[1 nan],'mcbarfs',5,'alpha',[1],'clim',[ nan nan; -1 1  ;nan nan]);

%% ===============================================
q=orthoslice({fullfile(pwd,'AVGT.nii') },'bgcol','w','panel',2);
%% ===============================================
q=orthoslice({fullfile(pwd,'RS_AVGT.nii.gz') },'bgcol','w','panel',2);



%% ===============================================
bg=fullfile(pwd,'AVGT.nii')
f1=fullfile(pwd,'_b1grey.nii');
f2=fullfile(pwd,'_b2white.nii');
f3=fullfile(pwd,'_b3csf.nii');
q=orthoslice({bg f1 f2 f3},'panel',1,'cmap',{'gray','Oranges','Greens'});

% q=orthoslice({bg f1 f2},'panel',2,'bgcol','w','labelcol','r','mroco',[1 nan])


%% ===============================================

q=orthoslice({bg f1 f2},'panel',1,'cmap',{'gray','Oranges','Greens'});







% ==============================================
%%
% ===============================================
files =  { 'F:\data8\ortoslice_tests\RS_AVGT.nii.gz'
    'F:\data8\ortoslice_tests\lev3_ICcomp0010__tstat1.nii.gz'
    'F:\data8\ortoslice_tests\lev3_ICcomp0010__tstat1_signif.nii.gz' };
r=[];
r.alpha       =  [1  0.6  1];
r.blobthresh  =  [];
r.cbarvisible =  [0  1  1];
r.cblabel     =  '';
r.ce          =  [0.030002  -0.29  2.4];
r.clim        =  [          0       1500
    -3          3
    3.5        4.5  ];
r.cmap        =  { 'gray' 	'RdYlGn_flip' 	'winterFLIP' };
r.figwidth    =  [680];
r.mbarlabel   =  { '' 	't-uncorrected' 	't-survived' };
r.mcbarpos    =  [-100  20  10  100];
r.mroco       =  [NaN  NaN];
r.mslicemm    =  [];
r.saveas      =  'F:\data8\ortoslice_tests\test2.png';
r.saveres     =  [400];
r.thresh      =  [        NaN        NaN
    NaN        NaN
    NaN        NaN  ];
r.visible     =  [1  1  1];
orthoslice(files,r);


% ==============================================
%%
% ===============================================
files =  { 'F:\data8\ortoslice_tests\RS_AVGT.nii.gz'
    'F:\data8\ortoslice_tests\icaAtlas.nii.gz,1'
    'F:\data8\ortoslice_tests\icaAtlas.nii.gz,2' };
r=[];
r.alpha       =  [1  0.6  1];
r.blobthresh  =  [];
r.cbarvisible =  [0  1  1];
r.cblabel     =  '';
r.ce          =  [0.030002  -0.29  2.4];
r.clim        =  [          0       1500
    nan nan
    nan nan ];
r.cmap        =  { 'gray' 	'RdYlGn_flip' 	'winterFLIP' };
r.figwidth    =  [680];
r.mbarlabel   =  { '' 	't-uncorrected' 	't-survived' };
r.mcbarpos    =  [-100  20  10  100];
r.mroco       =  [NaN  NaN];
r.mslicemm    =  [];
r.saveas      =  'F:\data8\ortoslice_tests\test2.png';
r.saveres     =  [400];
r.thresh      =  [        NaN        NaN
    NaN        NaN
    NaN        NaN  ];
r.visible     =  [1  1  1];
orthoslice(files,r);


% ==============================================
%%
% ===============================================
for num=1:18
    % num=1
    files =  { 'F:\data8\ortoslice_tests\RS_AVGT.nii.gz'
        ['F:\data8\ortoslice_tests\icaAtlas.nii.gz,' num2str(num)   ]
        };
    r=[];
    r.alpha       =  [1  0.5  1];
    r.blobthresh  =  [];
    r.cbarvisible =  [0  1  1];
    r.cblabel     =  '';
    r.ce          =  [0.030002  -0.29  2.4];
    r.clim        =  [0  1500
        6 15
        nan nan ];
    r.cmap        =  { 'gray' 	'YlOrRd' 	 };
    r.figwidth    =  [680];
    r.mbarlabel   =  { '' 	['icacomp-' pnum(num,2)] 	't-survived' };
    r.mcbarpos    =  [-100  20  10  100];
    r.mroco       =  [NaN  NaN];
    r.mslicemm    =  [];
    r.saveas      =  ['F:\data8\ortoslice_tests\iccomps_' pnum(num,2)  '.png'];
    r.dosave      =1;
    r.saveres     =  [400];
    r.thresh      =  [        NaN        NaN
        NaN        NaN
        NaN        NaN  ];
    r.visible     =  [1  1  1];
    
    r.ce          =  [0.030002  -0.29  2.4];
    r.ce          =  'max';
    r.cursorwidth=0;
    r.hide=0;
    
    orthoslice(files,r);
    
end

% ==============================================
%%   
% ===============================================

 num=11
  files =  { 'F:\data8\ortoslice_tests\RS_AVGT.nii.gz'
        ['F:\data8\ortoslice_tests\icaAtlas.nii.gz,' num2str(num)   ]
        'F:\data8\ortoslice_tests\lev3_ICcomp0010__tstat1_signif.nii.gz' 
        };
    r=[];
    r.alpha       =  [1  0.5  1];
    r.blobthresh  =  [];
    r.cbarvisible =  [0  1  1];
    r.cblabel     =  '';
    r.ce          =  [0.030002  -0.29  2.4];
    r.clim        =  [0  1500
        6 15
        nan nan ];
    r.cmap        =  { 'gray' 	'YlOrRd' 	 };
    r.figwidth    =  [680];
    r.mbarlabel   =  { '' 	['icacomp-' pnum(num,2)] 	't-survived' };
    r.mcbarpos    =  [-100  20  10  100];
    r.mroco       =  [NaN  NaN];
    r.mslicemm    =  [];
    r.saveas      =  ['F:\data8\ortoslice_tests\iccomps_' pnum(num,2)  '.png'];

    r.saveres     =  [400];
    r.thresh      =  [        NaN        NaN
        NaN        NaN
        NaN        NaN  ];
    r.visible     =  [1  1  1];
    
    r.ce          =  [0.030002  -0.29  2.4];
%     r.ce          =  'max';
    r.dosave      =0;
    r.cursorwidth=1;
    r.hide=0;
    
    orthoslice(files,r);

    
    
    
%% ====================================================
files =  { 'F:\data8\ortoslice_tests\RS_AVGT.nii.gz'                           
%             'F:\data8\ortoslice_tests\icaAtlas.nii.gz,11'                      
            'F:\data8\ortoslice_tests\lev3_ICcomp0010__tstat1_signif.nii.gz' };
r=[];                                                                          
r.alpha       =  [1  0.5  1];                                                  
r.blobthresh  =  [];                                                           
r.cbarvisible =  [0  1  1];                                                    
r.cblabel     =  '';                                                           
r.ce          =  [0.030002  -0.29  2.4];  
r.ce='max';
r.clim        =  [          0       1500                                       
                                                        
                  4     4.3426  ];      %     6         15                                             
r.cmap        =  { 'gray' 		'coolFLIP' };% 'YlOrRd'                             
r.mbarlabel   =  { '' 	'icacomp-11' 	't-survived' };                           
r.mroco       =  [NaN  NaN];                                                   
r.mslicemm    =  [];                                                           
r.saveas      =  '';                                                           
r.thresh      =  [        NaN        NaN                                       
                  NaN        NaN                                               
                  NaN        NaN  ];                                           
r.visible     =  [1  1  1];                                                    
orthoslice(files,r);      


%% ====================================================
files =  { 'F:\data8\ortoslice_tests\RS_AVGT.nii.gz'                           
            'F:\data8\ortoslice_tests\icaAtlas.nii.gz,11'                      
            'F:\data8\ortoslice_tests\lev3_ICcomp0010__tstat1_signif.nii.gz' };
r=[];                                                                          
r.alpha       =  [1  0.5  1];                                                  
r.blobthresh  =  [];                                                           
r.cbarvisible =  [0  1  1];                                                    
r.cblabel     =  '';                                                           
r.ce          =  [0.030002  -0.29  2.4];  
r.ce='max';
r.clim        =  [          0       1500                                       
                          6         15                                      
                  4     4.3426  ];      %                                          
r.cmap        =  { 'gray' 	'YlOrRd'   	'coolFLIP' };%                           
r.mbarlabel   =  { '' 	'icacomp-11' 	't-survived' };                           
r.mroco       =  [NaN  NaN];                                                   
r.mslicemm    =  [];                                                           
r.saveas      =  '';                                                           
r.thresh      =  [        NaN        NaN                                       
                  NaN        NaN                                               
                  NaN        NaN  ];                                           
r.visible     =  [1  1  1];                                                    
orthoslice(files,r);      