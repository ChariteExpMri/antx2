function cfg = tbx_cfg_spmmouse
% Adapted GUI for SPM Segment, New Segment and VBM8 including modified
% choices for bias regularisation and affine registration options. Although
% computation is done by standard SPM functions and the defaults are
% changed in the global defaults variable, the cfg_menu GUIs can not 
% be altered in-place.
% No configurable defaults or paths will be adjusted here. This has to be
% done manually after SPM is started by calling spmmouse from MATLAB.

cfg      = cfg_choice;
cfg.tag  = 'animal';
cfg.name = 'Spatial processing (animals)';
cfg.help = {'This toolbox contains modified GUIs for SPM spatial processing of animal sized brains.'
    'SPM functions that are not listed in this toolbox can be used from the normal menu.'};

% SPM Segment
cpreproc = spm_cfg_preproc;
cpreproc = cfg_menu_replace(cpreproc, 'biasfwhm',{...                               
    '1mm cutoff', '2mm cutoff', '5mm cutoff', '10mm cutoff', '20mm cutoff',...
'30mm cutoff','40mm cutoff','50mm cutoff','60mm cutoff','70mm cutoff',...   
'80mm cutoff','90mm cutoff','100mm cutoff','110mm cutoff','120mm cutoff',...
'130mm cutoff','140mm cutoff','150mm cutoff','No correction'},...           
{1,2,5,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,Inf});            
cpreproc = cfg_menu_replace(cpreproc, 'regtype', ...
    {
    'No Affine Registration'
    'ICBM space template - European brains'
    'ICBM space template - East Asian brains'
    'Average sized template'
    'Animal template'
    'No regularisation'
    }', ...
    {
    ''
    'mni'
    'eastern'
    'subj'
    'animal'
    'none'
    }');
cfg.values = {cpreproc};

% try New Segment
% Note: New Segment does not (yet) have configurable defaults
if exist(fullfile(spm('dir'),'toolbox','Seg'),'dir')
    opwd = pwd;
    try
        cd(fullfile(spm('dir'),'toolbox','Seg'));
        cpreproc8 = tbx_cfg_preproc8;
        cpreproc8 = cfg_menu_replace(cpreproc8, 'biasfwhm',{...                               
            '1mm cutoff', '2mm cutoff', '5mm cutoff', '10mm cutoff', '20mm cutoff',...
            '30mm cutoff','40mm cutoff','50mm cutoff','60mm cutoff','70mm cutoff',...
            '80mm cutoff','90mm cutoff','100mm cutoff','110mm cutoff','120mm cutoff',...
            '130mm cutoff','140mm cutoff','150mm cutoff','No correction'},...
            {1,2,5,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,Inf});
        cpreproc8 = cfg_menu_replace(cpreproc8, 'affreg', ...
            {
            'No Affine Registration'
            'ICBM space template - European brains'
            'ICBM space template - East Asian brains'
            'Average sized template'
            'Animal template'
            'No regularisation'
            }', ...
            {
            ''
            'mni'
            'eastern'
            'subj'
            'animal'
            'none'
            }');
        cfg.values = [cfg.values {cpreproc8}];
    end
    cd(opwd);
end
% try VBM8 New Segment
if exist(fullfile(spm('dir'),'toolbox','vbm8'),'dir')
    opwd = pwd;
    try
        cd(fullfile(spm('dir'),'toolbox','Seg'));
        cvbm8 = tbx_cfg_vbm8;
        % Only want to copy estwrite branch
        tropts = cfg_tropts([], 0, inf, 0, inf, true);
        id     = list(cvbm8,cfg_findspec({{'tag','estwrite'}}),tropts);
        cvbm8  = subsref(cvbm8,id{1});
        cvbm8 = cfg_menu_replace(cvbm8, 'biasfwhm',{...                               
            '1mm cutoff', '2mm cutoff', '5mm cutoff', '10mm cutoff', '20mm cutoff',...
            '30mm cutoff','40mm cutoff','50mm cutoff','60mm cutoff','70mm cutoff',...
            '80mm cutoff','90mm cutoff','100mm cutoff','110mm cutoff','120mm cutoff',...
            '130mm cutoff','140mm cutoff','150mm cutoff','No correction'},...
            {1,2,5,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,Inf});
        cvbm8 = cfg_menu_replace(cvbm8, 'affreg', ...
            {
            'No Affine Registration'
            'ICBM space template - European brains'
            'ICBM space template - East Asian brains'
            'Average sized template'
            'Animal template'
            'No regularisation'
            }', ...
            {
            ''
            'mni'
            'eastern'
            'subj'
            'animal'
            'none'
            }');
        cfg.values = [cfg.values {cvbm8}];
    end
    cd(opwd);
end

function cfg = cfg_menu_replace(cfg, tag, labels, values)
tropts = cfg_tropts([], 0, inf, 0, inf, true);
id     = list(cfg,cfg_findspec({{'tag',tag}}),tropts);
citem  = subsref(cfg,id{1});
citem.labels = labels;
citem.values = values;
cfg = subsasgn(cfg, id{1}, citem);