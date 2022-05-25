


% sub_atlaslabel2xls : write parameter to xls-file (subfunction of xgetlabels4)
% % fileout=sub_atlaslabel2xls(pp,z)
% pp:struct with paramters
% z: struct
%
% added: note for mask from templateFolder
% workaround: if xlfile not working
function fileout=sub_atlaslabel2xls(pp,z)


% ==============================================
%%   fixed fileName
% ===============================================

if isempty(char(z.fileNameOut))==0
    fileout=char(z.fileNameOut);
    [pa fi ext]=fileparts(fileout);
    if isempty(pa)
        resultsfolder=fullfile(fileparts(fileparts(fileparts(z.files{1}))),'results');
    else
        resultsfolder=pa;
    end
    filename=[fi '.xlsx'];
    fileout      =fullfile(resultsfolder, filename);
    if exist(fileout)==2
       try; delete(fileout); end 
    end
else
    fileout='';
    resultsfolder=fullfile(fileparts(fileparts(fileparts(z.files{1}))),'results');
    filename   = [  'labels_'  z.space  '_'  z.hemisphere  '_'  timestr(1) '.xlsx'];
    fileout      =fullfile(resultsfolder, filename);
end
warning off;
mkdir(resultsfolder);

%====================================================================================================
%% SAVE EXCELSHEET
%====================================================================================================

%fileout=fullfile(pwd,'test2.xls')
% disp(['GENERATING EXCELFILE ...']);
disp(['..creating XLSfile: ' fileout]);


%add info
v={};
try; v.files    =z.files; end
try; v.masks    =z.masks; end
try; v.atlas    =z.atlas; end
try; v.space    =z.space; end
try; v.hemisphere   =z.hemisphere; end
try; v.threshold    =z.threshold; end
try; v.frequency    =z.frequency; end
try; v.percOverlapp =z.percOverlapp; end
try; v.volref       =z.volref; end
try; v.vol          =z.vol; end
try; v.volPercBrain =z.volPercBrain; end
try; v.mean         =z.mean; end
try; v.std          =z.std; end
try; v.median       =z.median; end
try; v.min          =z.min; end
try; v.max          =z.max; end
try; v.patemp       =z.patemp; end
try; v.atlastype    =z.atlastype; end
try; v.atlaslabelsource     =z.atlaslabelsource; end


infox=struct2list(v);



infox(regexpi2(infox,'z.inf\d'))=[];
infox=[{['*** ATLAS LABELING: ' z.project   ' ***  ' ]}; infox ];

infox=[infox;{' '}];
infox=[infox;{'%NOTE: if (and only if) a mask from template folder is used, it is assumed that the mask (roi) is in standard space.'}];
infox=[infox;{'Hence, when using the same mask in native space, the mask file is warped to native space. Afterwards, the warped mask'}];
infox=[infox;{'% is used in combination with the native image file'}];

infox=[infox;{' '}];
% infox=[infox;{' '}];
% infox=[infox;{'_______________________________________'}];
infox=[infox;{  '###[ PARAMETER ]######################'}];
% infox=[infox;{'_______________________________________'}];


enter=char(10);
st={['[frequency]' enter...
    '  number of overlapping voxels of used mask and anatomical region' enter...
    '  is no mask is used the parameter refers to the number of voxels of each anat. region' enter] };
infox=[infox;st];

st={['[percOverlapp]' enter...
    '  percent of overlapping voxels of used mask and anatomical region' enter...
    '  if no mask is used this parameter should be 100% (relative to all voxels of each anat. region)' enter] };
infox=[infox;st];
st={['[VOL]' enter...
    ' volume [qmm] of each anatomical region:<<--THIS IS MASKDEPENDENT ' enter ...
    '  [1] no mask was used: than [VOL] and [VOLREF] should be identical' enter  ...
    '  [2] if a mask was used this volume represents the overlapping volume from mask and each anatomical region' enter...
    '  -note that VOL may differ between native space (mouse space) and standard space (reference/norm space)' enter] };
infox=[infox;st];
st={['[VOLREF]' enter...
    'volume [qmm] of the anatomical region of the reference brain, extracted from either mouse space or standard space: ' enter...
    '  The output depends on the hemispheric input parameter ("left","right" or "both").' enter...
    '  Thus, VOLREF of the anatomical regions refer to the volumes of the left or ' enter ...
    '  right hemisphere (brain) or the entire brain' enter...
    '  -note: VOLREF may between native space and standard space' enter] };
infox=[infox;st];

st={['[VOLPERCBRAIN]' enter...
    ' percent volume [qmm] of the (masked) anatomical region relative to to brain volume: ' enter...
    '  brain volume depends on the hemisphere-parameter (left,right,both) ' enter] };
infox=[infox;st];

st={['[mean][std][median][min][max]' enter...
    '  these are parameters were extracted from the overlapping voxels of the used mask and the anatomical region' enter...
    '  is no mask is used these parameter refers are derived from the voxels of each anat. region' enter] };
infox=[infox;st];
st={['***NOTE: all output parameters depend on the analysis-space (native or standard space), and the used hemisphere (left/right/both) ' enter...
    '   ' enter] };


% infox=[infox;{'_______________________________________'}];
% infox=[infox;{'______additional "Labels "   __________'}];
% infox=[infox;{'_______________________________________'}];
infox=[infox;{  '###[ additional "Labels" ]######################'}];


st={['[#brainvol]' enter...
    '  parameters given for the brain volume: ' enter...
    ' # The output parameters (frequency, percOverlapp, vol,mean etc.) refer to entire brain volume "" ' enter ...
    '   The output  is relative to the hemispheric input parameter ("left","right" or "both").' enter...
    '   Thus volref & percentoverlapp allways refer to the  selected "left","right" or "both" volume ' enter...
    ]};
infox=[infox;st];

st={['[#maskvol]' enter...
    '  parameters given for the mask volume (if a mask was used) or the thresholded volume (if threshold was set): ' enter...
    ' # The output parameters (frequency, percOverlapp, vol,mean etc.) refer to this mask volume "" ' enter ...
    '   The output  is relative to the hemispheric input parameter ("left","right" or "both").' enter...
    '   Thus volref & percentoverlapp allways refer to the  selected "left","right" or "both" volume ' enter...
    ]};
infox=[infox;st];

infox=[infox;{' '}];
infox=[infox; {['### END ' repmat('#',[1 150])]}];


% st={['[withinBrainMask]' enter...
%     '  input volume is masked by the Allen mouse brain mask (AVGtmask.nii or ix_AVGTmask.nii, depending on space): ' enter...
%     ' # The output parameters (frequency, percOverlapp, vol,mean etc.) refer to the punched-out input-volume "" ' enter ...
%     '   The output  is relative to the hemispheric input parameter ("left","right" or "both").' enter...
%     '   Thus volref & percentoverlapp allways refer to the  selected "left","right" or "both" - AllenMask volume ' enter...
%     ' # If an additional mask is used, this stamped out inputvolume is further stamped out by the mask,' enter...
%     '   thus, all output parameters refer to the volume located within the Allen mouse brain mask AND the inputMask ' enter...
%     ]};
% infox=[infox;st];
%
%
% %
% st={['[withinBrainMaskExtended]' enter...
%     '  # similar to [withinBrainMask]. The difference is that sometimes a lesion (masklesion)is slightly ' enter...
%     '    located outside the Allen mouse brain mask (in ~20 cases 1-5% volume outside the AVGtmask.nii ) ' enter ...
%     '    Here, the Brain mask is extended, see below' enter ...
%     '  # Possible Reasons: Combination of accuracy of mask delineation, transformation, ' enter...
%     '    mask-interpolation (next neighbour interp), accuracy of overlay between ANO.nii, AVGT.nii, threshold-level to generate AVGTmask.nii   ' enter...
%     '  # In this case the  Allen mouse brain mask  (AVGTmask.nii) is:   ' enter...
%     '     (a) extended (set union) by the input volume: ' enter...
%     '        -for this, the input volume must be binary:  '  enter...
%     '        -example:  input volume is a binary lesion mask --> volume of brainMask is extended by masklesion.nii '  enter...
%     '     (b) extended (set union) by the mask volume: which is given as additonal parameter' enter ...
%     '        -for this, the mask vulume must be binary:  '  enter...
%     '        -example: input volume "x_t2.nii" and the mask "masklesion.nii" --> volume of brainMask is extended by masklesion.nii  '  enter...
%     ' # If input volume is not binary and no further mask is used [withinBrainMaskExtended] and [withinBrainMask] should yield similar results ,' enter...
%     ' # NOTE: you have to decide whether [withinBrainMask] or [withinBrainMaskExtended] better suits to your data (see reasons) ,' enter...
%     ' # NOTE: the read out parameters for the Anatomical regions is independet from [withinBrainMask]/[withinBrainMaskExtended] and should be the same (i.e. anatomical regions are not! masked again by a brain mask! )  ,' enter...
%      ]};
% infox=[infox;st];
% st={['[withinVolume]' enter...
%     '  # here the reference is the entire input volume (bounding box) depending which   ' enter...
%     '    hemispheric input parameter ("left","right" or "both") has been selected'   ...
%     ]};
% infox=[infox;st];


%% ADD SMALL TABLE in INFO
% % % % % if 0
% % % % %     tb0=[];
% % % % %     tb0lab={};
% % % % %     if isfield(w,'vol_brain')
% % % % %         tb0(:,end+1)   =w.vol_brain;
% % % % %         tb0lab{1,end+1} =['vol_brain' ];
% % % % %     end
% % % % %     if ~isempty(Maskfile)
% % % % %         if isfield(w,'vol_maskinbrain')
% % % % %             tb0(:,end+1)=w.vol_maskinbrain;
% % % % %             tb0lab{1,end+1} =['vol_MaskinBrain' ];
% % % % %             
% % % % %         end
% % % % %         if isfield(w,'vol_maskpainted')
% % % % %             tb0(:,end+1)=w.vol_maskpainted;
% % % % %             tb0lab{1,end+1} =['vol_MaskPainted' ];
% % % % %         end
% % % % %     end
% % % % %     tb1=plog({},{w.id tb0lab tb0  }, 1,['# VOLUME ([qmm], hemisphere: '  char(z.hemisphere) ')'] ,'cr=1','s=1','d=3');
% % % % %     infox=[infox;tb1];
% % % % %     
% % % % % end




%=========================================================================
%
%        TABLE
%
%=========================================================================


pp.Elabel    =[z.atlasTB(:,1); pp.labadd];
pp.Eheader   =['region' pp.names];
pp.paramname = pp.tbh;

%=========================================================================
%
%        WRITE EXCEL-FILE
%
%=========================================================================



% % % if 0
% % %    %%% copy layout
% % %     if 1
% % %         copyfile(which('template_results_Allen.xls'),fileout,'f' ) ;
% % %     end
% % %     xlswrite(fileout, infox,  'INFO'   )  ;
% % %     for i=1:length(w.paramname)
% % %         tbx=[ [{''} w.id ] ;  [{''} w.idshort ]  ;[ w.labels  num2cell(squeeze(w.params(:,:,i)) )]];
% % %         xlswrite(fileout, tbx,  w.paramname{i}    )  ;
% % %     end
% % % end


% ==============================================
%%   check existence of excel-application
% ===============================================
% allenTemplateExcelFile = which('template_results_Allen.xls');
excelfileSource=z.atlaslabelsource;
if exist(excelfileSource)~=2
    keyboard
end
[~,sheets,infoXls]=xlsfinfo(excelfileSource);
if ~isempty(infoXls)
    isexcel=1;
else
    isexcel=0;
end

% ==============================================
%%   [1a] EXCEL EXISTS
% ===============================================



if isexcel==1  % EXCEL EXISTS
    %====================================================================================================
    %%  get colorized EXCELSHEET
    %====================================================================================================
    
    [~,~,ext1]=fileparts(excelfileSource);
    [pax,fix,ext2]=fileparts(fileout);
    fileout=fullfile(pax,[fix ext1]); %use format
    
    copyfile(excelfileSource,fileout,'f' ) ;
    
    [~,sheet0]=xlsfinfo(fileout);
    isheet=regexpi2(sheet0,'Atlas');
    [~,~,a]=xlsread(fileout,sheet0{isheet} );
    nanrow=cellfun(@(a) {num2str(a)}, a(:,1));
    ir=find(~strcmp(nanrow,'NaN'));
    nancol=cellfun(@(a) {num2str(a)}, a(1,:));
    ic=find(~strcmp(nancol,'NaN'));
    dummymat= repmat({''}, [max(ir) max(ic)]);
    
    xlswrite(fileout, dummymat, sheet0{isheet});
    atlasTable= a(1:max(ir),1:max(ic));  % later save this table
    
    sheets=pp.tbh;%'atlas';
    Excel = actxserver('excel.application');% Connect to Excel
    WB    = Excel.Workbooks.Open(fileout, 0, false);% Get Workbook object
    WS    = WB.Worksheets;% Get Worksheets object
    
    % copy template sheet
    sheets2=[sheets(:)' 'atlasTmp'];
    for j=1:length(sheets2)
        % WS.Item(1).Copy([],WS.Item(1)); %to copy after first sheet.
        WS.Item(1).Copy([],WS.Item(WS.count)); %
        WS.Item(WS.count).Name =sheets2{j};
        WS.Item(WS.count).Range('A1:E1').Interior.ColorIndex = 0  ;%  remove BG-color (NOFILL)
    end
    Excel.DisplayAlerts=false;
    %     try; invoke(get(WS,'Item','atlas'),'Delete'); end;%%delete  temp-sheet
    %     try; invoke(get(WS,'Item','Atlas'),'Delete'); end;%%delete  temp-sheet
    
    WS.Item(1).Name = 'INFO'; %RENAME TO INFO
    WS.Item(1).Range('A:E').Interior.ColorIndex = 0  ;%  remove BG-color (NOFILL)
    WS.Item(1).Range('A:E').Font.ColorIndex     = 1; % black color (could be white before): http://dmcritchie.mvps.org/excel/colors.htm
    
    WS.Item(length(sheets2)+1).Name = 'atlas'; % ADD ATLAS
    
    
    
    WB.Save();% Save
    WB.Close();
    Excel.Quit();% Quit Excel
    Excel.delete();%
    
    % add ATLAS-table
    [~,~,a]=xlsread(fileout,'atlas' );
    xlswrite(fileout, atlasTable, 'atlas');
    
    
    %====================================================================================================
    %%  write data to excelsheets
    %====================================================================================================
    xlswrite(fileout, infox,  'INFO'   )  ;
    try; xlsremovdefaultsheets(fileout); end ,%remove default excel-sheets
    for i=1:length(pp.paramname)
        tbx=[...
            pp.Eheader
            [pp.Elabel num2cell(squeeze(pp.tb(:,i,:)))]
            ];
        xlswrite(fileout, tbx,  pp.paramname{i}    )  ;
    end
    
    
    
else

    % ==============================================
    %%   [1b] EXCEL DOES NOT EXIST
    % ===============================================
    
    global an
    bkan5=an;
    clear an;
    
    %clear an ;% cler global here, because an as global  is destroyed using javaddoath
    %%  EXCEL not available
    try
        
        pa2excel=fullfile(fileparts(which('xlwrite.m')),'poi_library');
        javaaddpath(fullfile(pa2excel,'poi-3.8-20120326.jar'));
        javaaddpath(fullfile(pa2excel,'poi-ooxml-3.8-20120326.jar'));
        javaaddpath(fullfile(pa2excel,'poi-ooxml-schemas-3.8-20120326.jar'));
        javaaddpath(fullfile(pa2excel,'xmlbeans-2.3.0.jar'));
        javaaddpath(fullfile(pa2excel,'dom4j-1.6.1.jar'));
        javaaddpath(fullfile(pa2excel,'stax-api-1.0.1.jar'));
        xlwrite(fileout, infox,  'INFO'   )  ;
        for i=1:length(pp.paramname)
            tbx=[...
                pp.Eheader
                [pp.Elabel num2cell(squeeze(pp.tb(:,i,:)))]
                ];
            xlwrite(fileout, tbx,  pp.paramname{i}    )  ;
        end
        disp('..excel is not available..using package excelpackage from Alec de Zegher ');
    catch
        
        writetable(table(infox),fileout,'Sheet','INFO')
        for i=1:length(pp.paramname)
            tbx=[...
                pp.Eheader
                [pp.Elabel num2cell(squeeze(pp.tb(:,i,:)))]
                ];
            try
                T=cell2table(tbx(2:end,:),'VariableNames',tbx(1,:));
            catch
                %issue with VariableNames 'first character must be char')
                i_numeric=regexpi2(tbx(1,:),'^\d|_') ;%indicate if 1st letter is numeric or 'underscore'
                tbx(1,i_numeric)=cellfun(@(a){['s' a ]},tbx(1,i_numeric));
                T=cell2table(tbx(2:end,:),'VariableNames',tbx(1,:));
            end
            writetable(T,fileout,'Sheet',pp.paramname{i} );
        end
        % add SHEEET "atlas" WITH:  'Region'  'colHex'  'colRGB'  'ID'  'Children'
        try
            T=cell2table(z.atlasTB,'VariableNames',z.atlasTBH);
            writetable(T,fileout,'Sheet','atlas' );
        end
        disp('..excel is not available..using "writetable" ');
    end
    
    global an
    an=bkan5;
    
end



% ============================================================================================
%%   XLS-parameter settings (..EXCEL must exists)
% ============================================================================================

if isexcel==1
    
    % excel-letters
    let=cellstr(char(65:65+25)');
    lx=[let];
    for i=1:3
        lx=[lx ; cellfun(@(a){[ let{i} a ]},let)       ];
    end
    
    
    % ==============================================
    %%   autofit
    % ===============================================
    if 1
        [ ~,sheetsfit]=xlsfinfo(fileout);
        xlscols=[lx{1} ':' lx{size(pp.tb,3)+1}];
        xlsAutoFitCol(fileout,sheetsfit,xlscols);
    end
    
    % ==============================================
    %% some more xls-settings
    % ===============================================
    
    if  1
        
        
        e = actxserver('Excel.Application');
        e.Workbooks.Open(fileout); % Full path is necessary!
        
        % % % arrayfun(@(1) e.Workbooks.Sheets.Item.Name, 1:Workbooks.Sheets.Count, 'UniformOutput', false)
        % % % e.Worksheets.get('Item',x).Name
        % % % 1:e.Worksheets.Count
        
        sh=arrayfun(@(x)e.Worksheets.get('Item',x).Name,  [1:e.Worksheets.Count] ,'UniformOutput', false);
        colf = @(r,g,b) r*1+g*256+b*256^2;
        
        % c=[ 0.9529    0.8706    0.7333
        %     0.7569    0.8667    0.7765];
        
        c=[  0        0.8000    1.0000
            0.6784    0.9216    1.0000 ];
        
        c=c*255;
        c2=[colf(c(1,1),c(1,2),c(1,3))
            colf(c(2,1),c(2,2),c(2,3))];
        
        
        
        for i=2:length(sh)
            hh=sh{i};
            sheet1=e.Worksheets.get('Item', hh);
            sheet1.Activate;
            e.ActiveWindow.Zoom = 100;
            icol =size(pp.tb,3)+1  ; %sheet1.UsedRange.Columns.Count;
            irows=sheet1.UsedRange.Rows.Count;
            cells = e.ActiveSheet.Range([lx{1} '1:' lx{icol} '1']);
            set(cells.Font, 'Bold', true);
            set(cells.Interior,'Color', -4165632);
            for j=1:2: icol
                set(e.ActiveSheet.Range([lx{j}   num2str(1)]).Interior,'Color',c2(1,:))  ;
            end
            
            for j=2:2: icol
                set(e.ActiveSheet.Range([lx{j}   num2str(1)]).Interior,'Color',c2(2,:))  ;
            end
            
            
            if 0
                for j=2:2: icol
                    %         set(e.ActiveSheet.Range([lx{j} num2str(1)]).Interior,'Color',c2(2,:))  ;
                    set(e.ActiveSheet.Range([lx{j} '1' ':'  lx{j} num2str(irows)  ]).Interior,'Color',c2(2,:))  ;
                    %          e.Range('2:2').Select;
                    %          set(e.ActiveSheet.Range([lx{j} '1' ':'  lx{j} num2str(irows)  ]).Borders.Item('xlEdgeLeft'),'LineStyle',1);
                    %      set(e.ActiveSheet.Range(['c2'  ]).Borders.Item('xlEdgeLeft'),'LineStyle',1);
                    set(e.ActiveSheet.Range(['c5'  ]).Borders,'Linestyle',1)
                end
                
            end
            % ========================
            %     ihead=[lx{1} '1:' lx{icol} '1'];
            %     cells.Select;
            % %  Range('A10').Select
            % % e.ActiveWindow.FreezePanes = 1;
            % set(Sheets(sheet1).range('C10'),'FreezePanes',1)
            
            if 0 %FREEZE
                e.ActiveWindow.FreezePanes = 0;
                e.Range('2:2').Select;
                e.ActiveWindow.FreezePanes = 1;
            end
            
            e.Range('A3').Select;
            
            
            %
            % e.Range(ihead).Borders.Item('xlEdgeLeft').LineStyle = 1;
            % e.Range(ihead).Borders.Item('xlEdgeLeft').Weight = -4138;
            
            % ======================== Delete sheets
            % try    e.ActiveWorkbook.Worksheets.Item([sheetName '1']).Delete;end
            % try   e.ActiveWorkbook.Worksheets.Item([sheetName '2']).Delete;end
            % try   e.ActiveWorkbook.Worksheets.Item([sheetName '3']).Delete;end
            
        end%sheets
        
        e.ActiveWorkbook.Save;
        e.ActiveWorkbook.Close;
        e.Quit;
        e.delete;
        
    end
end% isexcel

%% end here

% % % % if 0
% % % %
% % % %     %====================================================================================================
% % % %     %%  colorize EXCELSHEET old
% % % %     %====================================================================================================
% % % %     disp('..colorize sheets');
% % % %     colorizeExcelsheet(fileout,  w.colorhex);
% % % % end

% disp('..DONE');


