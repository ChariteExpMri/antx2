

%% #ko [xgetparameter.m] obtain mask-based parameter from images (multi-masks & masks can be mulinary)
% mask-based paramters are:
%   'frequency'   'vol'     'mean'    'std'    'median'  'integrDens'  'min' 'max'
%   where 'frequency' and 'vol' is are the voxel-counts and volume of a specific mask
%   'mean','std','median', 'min' 'max' the paramters within the mask
%  'integrDens' is the integrated density within a mask (integrDens=mean *volume)
% #b MASK: #n you can use several masks/images, each with several sub-masks/(IDs), IDS across masks
% can be similar because either (a) a *.txt-label file is provided or if not (b) the label in the new
% excelFile is contructed by the maskName+ID within the respective mask
% #b ANIMAL_SELECTION: #n select animals from left ANTx-listbox before calling this function
% #b OUTPUT: #n The output is one EXCELFILE containing sheets for each paramter.
%            each column contains the data for one of the selected animals
% #m The output (excelfile) can be analyzed with MENU/STATISTIC/"label based statistic"
%
% #r -----------------------------------------------------------
% #r CURRENTLY ONY PROVIDED FOR IMAGES/MASKS IN STANDARD-SPACE
% #r -----------------------------------------------------------
%
% #lk  ___PARAMETER___
% file: the image in standard-space from which the paramters are extracted
% mask: one/several binary/multinary masks (NIFTI) which are applied on the "file"-image
% - mask(s) must be obtained either (a) template folder (b) another folder or (c) from the animal folder
%    --> path of mask selection via dialoge
%
%    - images and mask(s) must match in voxsize/FoW
%    - optional: If aside "mymask.nii"-image a textfile "mymask.txt" in the same folder exists, this
%      file will be read and those mask-labels will be used. If not found the labels are the ID's
%      found in the mask-file
%           ..example "msk_sab_parcellate.txt" (aside "msk_sab_parcellate.nii") contains the following text:
%                          1 L SAB_sup_post
%                          2 L SAB_sup_mid
%                          3 L SAB_sup_ant
%                          4 R SAB_sup_post
%                          5 R SAB_sup_mid
%                          6 R SAB_sup_ant
%                          7 L SAB_inf_post
%                          8 L SAB_inf_mid
%                          9 L SAB_inf_ant
%                         10 R SAB_inf_post
%                         11 R SAB_inf_post
%                         12 R SAB_inf_ant
%          ..these are the IDs & labels corresponfing to the mask "msk_sab_parcellate.nii"
% z.outputfolder: output-folder to write the excel-file
%
% #lk  ___BATCH___
%% EXAMPLE-1
% obtain parameter from mage 'x_flour19f_TR3.nii' for the three selected masks for all selected animals
% save in "result"-folder adding the prefix 'test' to the created excel-file-name containing the
% paramters (frequency/number of voxels, volumem, mean, SD, median, integrated density (vol*mean),
% min, max) for the selected animals
% % =====================================================
% z=[];
% z.file           = { 'x_flour19f_TR3.nii' };                                % % images used to extract paramters
% z.masks          = { 'F:\data4\flour_felix_roi\msk_hypothalamus.nii'        % % select one/several masks to apply on the image
%                      'F:\data4\flour_felix_roi\msk_sab_parcellate.nii'
%                      'F:\data4\flour_felix_roi\msk_wurm.nii' };
% z.outputfolder   = 'F:\data4\flour_felix_roi\results';                      % % output folder for resulting EXCEL-file
% z.filenamePrefix = 'test';                                                  % % <optional> enter filename prefix for resulting EXCEL-file
% z.addDate        = [0];                                                     % % <optional> at date to filename (suffix)
% z.addTime        = [0];                                                     % % <optional> at time to filename (suffix)
% xgetparameter(1,z);
% 
% 
% % =====================================================                                                                                                                
%% EXAMPLE-2                                                                                                                             
% extract parameter from image 'rc_rCBV.nii' using the mask 'EMS.nii' (mask contains two ROIs)
% Importent here: each animal folder contains an animal-specifc 'EMS.nii' and 'rc_rCBV.nii' file
%                (both in native space) 
% % =====================================================                                                                                                                
% z=[];                                                                                                                                                                    
% z.file               = { 'rc_rCBV.nii' };                                      % % images used to extract paramters                                                      
% z.masks              = { 'EMS.nii' };                                          % % select one/several masks to apply on the image                                        
% z.minTreshold        = [];                                                    % % minimum threshold image value                                                         
% z.minTresholdReplace = [NaN];                                                  % % values below "minTreshold" will be replaced by this value or removed if field is empty
% z.maxTreshold        = [];                                                     % % maximum threshold image value                                                         
% z.maxTresholdReplace = [];                                                     % % values above "maxTreshold" will be replaced by this value or removed if field is empty
% z.outputfolder       = 'H:\Daten-2\Imaging\AG_Hecht\ceAngio_2022\results';     % % output folder for resulting EXCEL-file                                                
% z.filenamePrefix     = '_test';                                                % % <optional> enter filename prefix for resulting EXCEL-file                             
% z.addDate            = [1];                                                    % % <optional> at date to filename (suffix)                                               
% z.addTime            = [1];                                                    % % <optional> at time to filename (suffix)                                               
% xgetparameter(1,z);


function [z varargout] = xgetparameter(showgui,x)
warning off;

if 0
    
end

%====================================================================================================

if exist('showgui')~=1;  showgui=1; end
if exist('x')~=1;        x=[]; end
if isempty(x); showgui=1; end
%====================================================================================================
global an

pa=antcb('getsubjects');
v=getuniquefiles(pa);
outdir=fullfile(fileparts(an.datpath),'results');

p={...
    
'file'      ''        'images used to extract paramters' ,  {@selectfile,v,'single'} ;%'mf'
'masks'      {}       'select one/several masks to apply on the image', {@selectfileMask,v,'multi'} % ,'mf' ...
'minTreshold'        []   'minimum threshold image value' {0:5}
'minTresholdReplace' nan  'values below "minTreshold" will be replaced by this value or removed if field is empty' {nan 0 []}
'maxTreshold'        []   'maximum threshold image value' {5:15}
'maxTresholdReplace' []   'values above "maxTreshold" will be replaced by this value or removed if field is empty' {5 10 []}


'inf2' '' '' ''
'inf3' '___ OUTPUT ___' '' ''
'outputfolder'        outdir 'output folder for resulting EXCEL-file '    'd'
'filenamePrefix'      ''        '<optional> enter filename prefix for resulting EXCEL-file' ''
'addDate'              0   '<optional> at date to filename (suffix)' 'b'
'addTime'              0   '<optional> at time to filename (suffix)' 'b'
%
%     'inf44'        '________________________________________________________________________________'    '' ''
%     'inf4'        '% READ-OUT PARAMETERS'      ' THESE PARAMETERS WILL BE GENERATED FROM EACH REGION '   ''
%     'frequency'    1     'frequency: number of voxels within an anatomical region'                            'b'
%     'percOverlapp' 1     'percent overlapp between mask and anatomical region'                                'b'
%     'volref'       1     'volume [qmm] of anatomical region (REFERENCE)'                                      'b'
%     'vol'          1     'volume [qmm] of (masked) anatomical region'                                         'b'
%     'volPercBrain' 1     'percent volume [percent] of anatomical region relative to brain volume'             'b'
%     'mean'         1     'mean of values (intensities) within anatomical region'                              'b'
%     'std'          1     'standard deviation of values (intensities) within anatomical region'                'b'
%     'median'       1     'median of values (intensities) within anatomical region'                            'b'
%     'min'          1     'min of values (intensities) within anatomical region'                               'b'
%     'max'          1     'max of values (intensities) within anatomical region'                               'b'
};


p=paramadd(p,x);%add/replace parameter



%% show GUI
if showgui==1
    hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
    [m z]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .6 .3 ],...
        'title',mfilename,'info',hlp);
    if isempty(m); return; end
    fn=fieldnames(z);
    z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
else
    z=param2struct(p);
end

disp('..read mask-based paramter from images..');
xmakebatch(z,p, mfilename); % ## BATCH

% ==============================================
%%   process
% ===============================================
if isempty(char(z.masks)); disp('no mask(s) selected');return; end

cprintf('*[0.7490 0.7490 0]',['extracting parameter by masks [xgetparameter.m]' '\n']);
%% ============[decide wether mask is in animal path]===================================
pam=fileparts(z.masks{1});
if isempty(pam) % no paths in the mask--->mask located in the animal path
    %% ########################################################################
    %%  mask located in the animal path  (no path in mask-name)
    %% ########################################################################
    
    
    mdir=antcb('getsubjects');
    [~,animals]=fileparts2(mdir);
    
    t={};
    err={};
    errIDX=[];
    for m=1:length(mdir)
        try
%             if 1 %check
%                 if m==2
%                   % keyboard
%                 end
%             end
            
            f1=fullfile(mdir{m},z.file{1} );
            [~,animal]=fileparts(mdir{m});
            
            %--------
            str=([' .. reading file from: ' num2str(m) '] ' animal ]);
            fprintf(str);
            pause(0.2);
            fprintf(repmat('\b',1,numel(str)));
            disp([  ' [' num2str(m) '] "' animal '"' ]);
            %% ===============[read readout-file]================================
            [hd d]=rgetnii(f1);
            d2=d(:);
            
            %% ===============================================
            %% [1] get masks
            %% ===============================================
            mc={};
            for i=1:length(z.masks)
                fmask=fullfile(mdir{m},z.masks{i});
                %try%if exist(fmask)==2
                    [~,maskname]=fileparts(fmask);
                    disp( ['  ..reading mask: "' maskname '.nii"']);
                    [ha a]=rgetnii(fmask);
                    
                    %check similarity of header
                    if (sum(abs(ha.mat(:)-hd.mat(:))))~=0
                        disp( ['  ..."' maskname '.nii" differences in mask-header ""...reslicing mask']);
                        [ha,a ]=rreslice2target(fmask, f1, [], []) ;
                    end
                    
                    a(isnan(a))=0;% remove nan;
                    uni=unique(a); uni(uni==0)=[];
                    
                    % check if label-file exist
                    flab=regexprep(fmask,'.nii$','.txt');
                    if exist(flab)==2
                        t=preadfile(flab); t=t.all;
                        ti=regexpi( t,'\d\s+','once'); ti=cell2mat(ti);
                        t2={};
                        for j=1:length(ti)
                            td={ str2num(t{j}(1:ti(j)))     regexprep(strtrim(t{j}(ti(j)+1:end)),{'\s+'},{'_'})  };
                            t2=[t2;td];
                        end
                    else
                        mnum=num2cell(uni) ;
                        t2=[mnum cellfun(@(a){[ maskname '_' num2str(a)]},  mnum)];
                    end
                    mc=[mc; {maskname ha a(:) uni t2}];
                %end
            end
            hmc={'maskname' 'nii-hdr' 'nii-dat'  'IDvec' 'table(id|label)' };
            
            %% ===============================================
            %% [2] get indices of masks
            %% ===============================================
            mc2={};
            for i=1:size(mc,1)
                md={};
                tab=mc{i,5};
                for j=1:length(mc{i,4})
                    ix=find(mc{i,3}== mc{i,4}(j) );
                    md{j,1}=mc{i}; %mask-name
                    
                    irow=find(cell2mat(tab(:,1)) == mc{i,4}(j) );
                    md{j,2}= tab{irow,1}; %table-ID
                    md{j,3}= tab{irow,2}; %table-label
                    
                    md{j,4}=ix; %indices
                end
                mc2=[mc2; md];
            end
            %% ===============================================
            %% [3] obtain parameter from image
            %% ===============================================
            for i=1:size(mc2,1)
                v=d2(mc2{i,4});
                v0=v;
                
                % ___minTreshold
                if ~isempty(z.minTreshold)
                    if ~isempty(z.minTresholdReplace)
                        v(find(v<z.minTreshold))=z.minTresholdReplace;
                    else
                        v(find(v<z.minTreshold))=[];
                        
                    end
                    if isempty(v); v=nan; end
                end
                v(isnan(v))=[];
                % ___maxTreshold
                if ~isempty(z.maxTreshold)
                    if ~isempty(z.maxTresholdReplace)
                        v(find(v>z.maxTreshold))=z.maxTresholdReplace;
                    else
                        v(find(v>z.maxTreshold))=[];
                        
                    end
                    if isempty(v); v=nan; end
                end
                v(isnan(v))=[];
                
                if isempty(v) || (length(v)==1 && isnan(v)==1)
                    v=0;
                    freq=0;
                    vol =0;
                else
                    freq =sum(~isnan(v)) ;% length(v);
                    vol  =abs(det(ha.mat(1:3,1:3)) *(freq));
                end
                
                % % ---MASK:frequency & volume ...should be similar when not thresholded
                freqMsk =sum(~isnan(v0)) ;% length(v);
                volMsk  =abs(det(ha.mat(1:3,1:3)) *(freqMsk));
                
                % % ---PARAMETER
                me   =mean(v);
                sd   =std(v);
                med  =median(v);
                %inde = vol.*me ; %integrated density
                inde = sum(v); % integrated density --new
                
                mi   =min(v);  if isempty(mi); mi=0; end
                ma   =max(v);  if isempty(ma); ma=0; end
                
                td= [ mc2{i,3} mc2{i,2}   ...
                    num2cell([freqMsk volMsk  freq vol me sd med inde    mi ma  ]) ];
                t(m,i,:)=td; %animal x mask x parameter
                % % ---
                
            end
        catch
            errIDX=[m]; %errorIndex
            errx=lasterr;
            errx=strjoin(strsplit2(errx,char(10)),'.. ');
            cprintf([1 0 1] ,[  strrep(errx,filesep,[filesep filesep]) '\n']);
            err=[err; {lasterr}];
            
            cprintf([.8 .5 0] ,['..problem with [' num2str(m) '] "' animal '"; mask: "'  maskname '.nii"' '\n']);
            disp(lasterr);
        end
    end % over animals
    
    
    
    validanimals=animals;
    if ~isempty(errIDX)
        try
            t(errIDX,:,:)=[]; %remove errornuous animal
        end
        validanimals(errIDX)=[];
    end
    % ==============================================
    %%  [4] RESHAPE CELL_CUBE
    % ===============================================
    t2=permute(t,[ 2 1 3]);
    rois=[t2(:,1,1) t2(:,1,2)];
    rois=cellfun(@(a,b){[ a '__ID_' num2str(b)]},  rois(:,1),rois(:,2));
    t3=t2(:,:,3:end);
    l3=(repmat([rois  ],[1 1 size(t3,3) ]));
    sheet={'frequencyMsk'   'volMsk'  'frequency'   'vol'     'mean'    'std'    'median'  'integrDens'  'min' 'max'    };
    t4=[l3 t3];
    
    %% ==============================================
    %%   prepare output
    %% ===============================================
    warning off;
    outdir=char(z.outputfolder);
    if isempty(outdir)
        outdir=fullfile(fileparts(an.datpath),'results');
    end
    mkdir(outdir);
    prefix=char(z.filenamePrefix);
    if ~isempty(prefix)
        prefix=[prefix '_'];
    end
    sdate='';
    if z.addDate==1
        sdate=['_' datestr(now,'dd_mmm_yy')];
    end
    stime='';
    if z.addDate==1
        stime=['_Time_' datestr(now,'HH_MM_SS')];
    end
    
    Fout=fullfile(outdir,['res_' prefix  'maskParameter' sdate stime '.xlsx']);
    disp(['..writing Excelfile: '  Fout ]);
    %% ==============================================
    %%   write info
    %% ===============================================    
    g={['# date: ' datestr(now)  ]};
    g{end+1,1}=['# FILE   :' z.file{1}];
    g{end+1,1}=['# MASK(S):' ];
    g=[g; z.masks(:) ];
    
    g{end+1,1}='# ANIMALS:';
    g=[g; validanimals(:) ];
    g{end+1,1}='# Missing ANIMALS:';
    if ~isempty(err)
        g=[g; animals(errIDX(:))];
        g{end+1,1}='# ERROR MESSAGE:';
        g=[g; errx];
    else
        g=[g;'-none-'];
    end
    pwrite2excel(Fout,{1 'info'}, {'INFO'},[],g);
    
    %% __write PARAMETER sheets__
    for i=1:size(t4,3)
        hs = ['Region' validanimals(:)' ];
        s  = t4(:,:,i);
        pwrite2excel(Fout,{i+1 sheet{i}}, hs,[],s);
    end
    showinfo2('Excel-file' ,Fout,[],[], [ '>> ' Fout ]);
    disp('Done!');
    % ==============================================
    %%
    % ===============================================
    
    
    
    
    
    
    

    
    % ==============================================
    %%
    % ===============================================
    
    
else
    %% ########################################################################
    %%  mask(s) from template- or "other"- folder
    %% ########################################################################
    
    %% [1] get masks ===============================================
    mc={};
    for i=1:length(z.masks)
        fmask=z.masks{i};
        [~,maskname]=fileparts(fmask);
        [ha a]=rgetnii(fmask);
        uni=unique(a); uni(uni==0)=[];
        
        flab=regexprep(fmask,'.nii$','.txt');
        if exist(flab)==2
            t=preadfile(flab); t=t.all;
            ti=regexpi( t,'\d\s+','once'); ti=cell2mat(ti);
            t2={};
            for j=1:length(ti)
                td={ str2num(t{j}(1:ti(j)))     regexprep(strtrim(t{j}(ti(j)+1:end)),{'\s+'},{'_'})  };
                t2=[t2;td];
            end
        else
            mnum=num2cell(uni) ;
            t2=[mnum cellfun(@(a){[ maskname '_' num2str(a)]},  mnum)];
        end
        mc=[mc; {maskname ha a(:) uni t2}];
        
        
    end
    hmc={'maskname' 'nii-hdr' 'nii-dat'  'IDvec' 'table(id|label)' };
    
    
    
    %% [2] get indices ===============================================
    mc2={};
    for i=1:size(mc,1)
        md={};
        tab=mc{i,5};
        for j=1:length(mc{i,4})
            ix=find(mc{i,3}== mc{i,4}(j) );
            md{j,1}=mc{i}; %mask-name
            
            irow=find(cell2mat(tab(:,1)) == mc{i,4}(j) );
            md{j,2}= tab{irow,1}; %table-ID
            md{j,3}= tab{irow,2}; %table-label
            
            md{j,4}=ix; %indices
        end
        mc2=[mc2; md];
    end
    
    
    
    %% [3] get images ===============================================
    
    
    mdir=antcb('getsubjects');
    [~,animals]=fileparts2(mdir);
    
    t={};
    err={};
    errIDX=[];
    for m=1:length(mdir)
        try
            f1=fullfile(mdir{m},x.file{1} );
            [~,animal]=fileparts(mdir{m});
            
            %--------
            str=([' .. reading file from: ' num2str(m) '] ' animal ]);
            fprintf(str);
            pause(0.2);
            fprintf(repmat('\b',1,numel(str)));
            %------------
            
            [ha a]=rgetnii(f1);
            a2=a(:);
            %checkSame_MAT
            mats=cell2mat(cellfun(@(a){[ a.mat(:)']},  mc(:,2)));
            mat_dif=abs(repmat(ha.mat(:)',[size(mats,1) 1])-mats);
            if sum(mat_dif(:))~=0
                error([ 'mismatching header-mats between mask(s) and image: ' mat_dif(:)   ]);
            end
            
            
            for i=1:size(mc2,1)
                v=a2(mc2{i,4});
                v0=v;
                
                % ___minTreshold
                if ~isempty(z.minTreshold)
                    if ~isempty(z.minTresholdReplace)
                        v(find(v<z.minTreshold))=z.minTresholdReplace;
                    else
                        v(find(v<z.minTreshold))=[];
                        
                    end
                    if isempty(v); v=nan; end
                end
                v(isnan(v))=[];
                % ___maxTreshold
                if ~isempty(z.maxTreshold)
                    if ~isempty(z.maxTresholdReplace)
                        v(find(v>z.maxTreshold))=z.maxTresholdReplace;
                    else
                        v(find(v>z.maxTreshold))=[];
                        
                    end
                    if isempty(v); v=nan; end
                end
                v(isnan(v))=[];
                
                if isempty(v) || (length(v)==1 && isnan(v)==1)
                    v=0;
                    freq=0;
                    vol =0;
                else
                    freq =sum(~isnan(v)) ;% length(v);
                    vol  =abs(det(ha.mat(1:3,1:3)) *(freq));
                end
                
                % % ---MASK:frequency & volume ...should be similar when not thresholded
                freqMsk =sum(~isnan(v0)) ;% length(v);
                volMsk  =abs(det(ha.mat(1:3,1:3)) *(freqMsk));
                
                % % ---PARAMETER
                me   =mean(v);
                sd   =std(v);
                med  =median(v);
                %inde = vol.*me ; %integrated density
                inde = sum(v); % integrated density --new
                
                mi   =min(v);  if isempty(mi); mi=0; end
                ma   =max(v);  if isempty(ma); ma=0; end
                
                td= [ mc2{i,3} mc2{i,2}   ...
                    num2cell([freqMsk volMsk  freq vol me sd med inde    mi ma  ]) ];
                t(m,i,:)=td; %animal x mask x parameter
                % % ---
                
            end
        catch
            errIDX=[m]; %errorIndex
            errx=lasterr;
            errx=strjoin(strsplit2(errx,char(10)),'.. ');
            cprintf([1 0 1] ,[  strrep(errx,filesep,[filesep filesep]) '\n']);
            err=[err; {lasterr}];
        end
    end
    
    validanimals=animals;
    if ~isempty(errIDX)
        t(errIDX,:,:)=[]; %remove errornuous animal
        validanimals(errIDX)=[];
    end
    %% =============RESHAPE CELL_CUBE ==================================
    
    t2=permute(t,[ 2 1 3]);
    rois=[t2(:,1,1) t2(:,1,2)];
    rois=cellfun(@(a,b){[ a '__ID_' num2str(b)]},  rois(:,1),rois(:,2));
    t3=t2(:,:,3:end);
    l3=(repmat([rois  ],[1 1 size(t3,3) ]));
    sheet={'frequencyMsk'   'volMsk'  'frequency'   'vol'     'mean'    'std'    'median'  'integrDens'  'min' 'max'    };
    t4=[l3 t3];
    
    
    
    
    % ==============================================
    %%   ======== [save] ==
    % ===============================================
    warning off;
    outdir=char(z.outputfolder);
    if isempty(outdir)
        outdir=fullfile(fileparts(an.datpath),'results');
    end
    mkdir(outdir);
    prefix=char(z.filenamePrefix);
    if ~isempty(prefix)
        prefix=[prefix '_'];
    end
    sdate='';
    if z.addDate==1
        sdate=['_' datestr(now,'dd_mmm_yy')];
    end
    stime='';
    if z.addDate==1
        stime=['_Time_' datestr(now,'HH_MM_SS')];
    end
    
    Fout=fullfile(outdir,['res_' prefix  'maskParameter' sdate stime '.xlsx']);
    disp(['..writing Excelfile: '  Fout ]);
    
    
    %% __write info__
    g={['# date: ' datestr(now)  ]};
    g{end+1,1}=['# FILE   :' z.file{1}];
    g{end+1,1}=['# MASK(S):' ];
    g=[g; z.masks(:) ];
    
    g{end+1,1}='# ANIMALS:';
    g=[g; validanimals(:) ];
    g{end+1,1}='# Missing ANIMALS:';
    if ~isempty(err)
        g=[g; animals(errIDX(:))];
        g{end+1,1}='# ERROR MESSAGE:';
        g=[g; errx];
    else
        g=[g;'-none-'];
    end
    
    pwrite2excel(Fout,{1 'info'}, {'INFO'},[],g);
    
    %% __write other sheets__
    for i=1:size(t4,3)
        hs = ['Region' validanimals(:)' ];
        s  = t4(:,:,i);
        pwrite2excel(Fout,{i+1 sheet{i}}, hs,[],s);
    end
    showinfo2('Excel-file' ,Fout,[],[], [ '>> ' Fout ]);
    disp('Done!');
    
    
    %   Columns 1 through 5
    %     'INFO'    'frequency'    'percOverlapp'    'vol'    'volref'
    %   Columns 6 through 10
    %     'volPercBrain'    'mean'    'std'    'median'    'min'
    %   Columns 11 through 12
    %     'max'    'atlas'
    
end








%% ===============================================%% ===============================================
%% ===============================================
%%
%% SUBS
%%
%% ==============================================
%% ===============================================%===================================================================================================



function v=getuniquefiles(pa)
%________________________________________________
%%  generate list of nifit-files within pa-path
%________________________________________________
% keyboard
% global an
% pa=antcb('getallsubjects'); %path
% pa=antcb('getsubjects'); %path
li={};
fi2={};
fifull={};
for i=1:length(pa)
    [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
    if ~isempty(char(files))
        if ischar(files); files=cellstr(files);   end;
        fis=strrep(files,[pa{i} filesep],'');
        fi2=[fi2; fis];
        fifull=[fifull; files];
    end
end
li=unique(fi2);
[li dum ncountid]=unique(fi2);
%% count files
ncount=zeros(size(li,1),1);
for i=1:size(li,1)
    ncount(i,1) =length(find(ncountid==i));
end
%% get properties spm_vol
fifull2=fifull(dum);
tb  = repmat({''},[size(fifull2,1)  ,4]);
tbh ={'Ndims' 'size' 'resolution' 'origin'} ;
for i=1:size(fifull2,1)
    ha=spm_vol(fifull2{i});
    ha0=ha;
    ha=ha(1);
    if length(ha0)==1
        tb{i,1}='3';
        tag='';
    else
        tb{i,1}='4' ;
        tag= length(ha0);
    end
    tb{i,2}=sprintf('%i ',[ha.dim tag]);
    tb{i,3}=sprintf('%2.2f ',diag(ha.mat(1:3,1:3))');
    tb{i,4}=sprintf('%2.2f ',ha.mat(1:3,4)')  ;
end
v.tb =[li cellstr(num2str(ncount)) tb];
v.tbh=[{'Unique-Files-In-Study', '#found'} tbh];

function he=selectfile(v,selectiontype)
% ==============================================
%% get file/masks
% ==============================================
he='';
h1=selector2(v.tb,v.tbh,...%'iswait',0,...
    'out','col-1','selection',selectiontype);
if ~isempty(h1)
    he=cellstr(h1);
end

function he=selectfileMask(v,selectiontype)
he='';
%% ==========[questiondialog]=====================================
opts.Interpreter = 'tex';
opts.Default = 'templates folder';
choice = questdlg({'\color{blue}Location of the mask(s)?\color{black}' ...
    '[templates folder]: .. located in the template folder', ...
    '[other folder]    : .. located in another folder', ...
    '[animal folder(s)]: .. located in the animal-folders (dat-structure)'}, ...
    'Select mask location',...
    'templates folder',...
    'other folder',...
    'animal folder(s)',...
    opts);
%% ===============================================

if isempty(choice); return; end



% 'animal folder(s)','templates folder','other folder','animal folder(s)');

if strcmp(choice, 'animal folder(s)')
    he='';
    h1=selector2(v.tb,v.tbh,...%'iswait',0,...
        'out','col-1','selection',selectiontype);
    if ~isempty(h1)
        he=cellstr(h1);
    end
    % elseif
    %     pat=fullfile(pwd,'templates');
    %     if exist(pat)~=7
    %         pat=pwd;
    %     end
    %     [fi pa]=uigetfile(fullfile(pat,'*.nii'),'select a maskfile from templates-folder');
    %     if isnumeric(fi); he=''; end
    %     he=cellstr(fullfile(pa,fi));
elseif strcmp(choice, 'other folder')   || strcmp(choice, 'templates folder')
    pat=fullfile(pwd,'templates');
    if strcmp(choice, 'other folder')
        pat=uigetdir(pat,'select the folder with the mask(s)');
    end
    v=getuniquefiles({pat});
    
    he='';
    h1=selector2(v.tb,v.tbh, 'out','col-1','selection','multi');
    if ~isempty(h1)
        h1=stradd(cellstr(h1),[pat filesep ],1)
        he=cellstr(h1);
    end
    
    
else
    he='';
end


