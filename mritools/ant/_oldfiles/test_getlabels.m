



function [Stat, excvec] = test_getlabels(Compfile, hemisphere,type)



% function [Stat, excvec] = test_getlabels(idxLUT,homefolder, Compfile, hemisphere,type,network)

if 0
    
    Compfile={ ...
        fullfile(pwd, 'wmask_m01_test.nii')
        fullfile(pwd, 'wmask_m01_test - Kopie.nii')
        }
    [Stat, excvec] = test_getlabels(Compfile, 'Both',4)
    %     xx = load('gematlabt_labels.mat');
    % [table idxLUT] = buildtable(xx.matlab_results{1}.msg{1});
    %     homefolder=  'O:\matlabToolsFreiburg\allen\'
    %     Compfile={ ...
    %         fullfile(pwd, 'wmask_m01_test.nii')
    %         fullfile(pwd, 'wmask_m01_test - Kopie.nii')
    %         }
    %     hemisphere=   'Both'
    %     type= 4
    %     [Stat, excvec] = test_getlabels(idxLUT,homefolder, Compfile, hemisphere,type,network)
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
xx = load('gematlabt_labels.mat');
[table idxLUT] = buildtable(xx.matlab_results{1}.msg{1});
network= {};

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

%
% homefolder:     O:\matlabToolsFreiburg\allen\
% Compfile:  [1x54 char]    [1x62 char]
% hemisphere:   'Both'
% ,type: 4
% ,network: {}

if 0
    disp('paul hack:  BrAt_BrowseAtlas_fcn_paul ')
    % load atlas
    AVGT = nifti(fullfile(homefolder,'wAVGT.nii')); AVGT = double(AVGT.dat);
    ANOstruct = nifti(fullfile(homefolder,'wANO.nii')); ANO = double(ANOstruct.dat);
    FIBT = nifti(fullfile(homefolder,'wFIBT.nii')); FIBT = double(FIBT.dat);
end
%size:     165   230   135
%% •••••••••• hack   paul••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
[pathx s]=antpath
avg0=stradd(s.avg,'s',1);
ano0=stradd(s.ano,'s',1);
fib0  =stradd(s.fib,'s',1);

avg = nifti(avg0);
avg = double(avg.dat);

anostruct = nifti(ano0);
ano       = double(anostruct.dat);

fib = nifti(fib0);
fib       = double(fib.dat);

%size  164   212   158
%% replace
AVGT=avg;
ANO=ano;
ANOstruct=anostruct;
FIBT =fib;
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


COL = buildColLabeling(ANO,idxLUT);

%••••••••••••••••••••••• hack2  paul •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% if not(strcmp(Compfile,'nocomp'))
%     fprintf('Working on Volumes..')
%     actmap = BrAt_resliceActmap(Compfile,ANOstruct);
% end
for i=1:length(Compfile)
    [h,dum ]=rreslice2target(Compfile{1}, ano0, [], 0);
    actmap(:,:,:,i)=dum;
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% threshold of activation map intensity
threshold = 0.3;

%%%Relations from Set Theory: A = activation, L = atlas label
% type == 1 :  rankscore = |A cap L| / |A|
% type == 2 :  rankscore = |A cap L| / |L|
% type == 3 :  rankscore = |A cap L| / |A cup L|
% type == 4 :  rankscore = |A cap L|
% type = 2; % Sortierung

% volume of activation area weighted by t-value
weighted = true;
%weighted = false;

% size of region ranking
rN = 25;

% area coloring blending
calpha = 0.2;

%Hemisphere
if strcmp(hemisphere,'Left')==1
    ANO2 = ANO; ANO2(:,86:end,:) = 0;
    FIBT2 = FIBT; FIBT2(:,86:end,:) = 0;
elseif strcmp(hemisphere,'Right')==1
    ANO2 = ANO; ANO2(:,1:85,:) = 0;
    FIBT2 = FIBT; FIBT2(:,1:85,:) = 0;
else
    ANO2 = ANO; hemisphere = 'Both';
    FIBT2 = FIBT;
end
ANO2(isnan(ANO))=0;
FIBT2(isnan(ANO))=0;

% compute region sizes for annotations
idxLUT = BrAt_ComputeAreaSize(idxLUT,ANO2,FIBT2);

% flip and permute to get right anatomical view
perm = @(x) flipdim(permute(x(:,1:3:end,:,:),[3 1 2 4]),1);
AVGT = perm(AVGT);
COL = perm(COL);

% create lookup table
luts.info = idxLUT;
% compute statistics

if not(strcmp(Compfile,'nocomp'))
    Stat = cell(1,size(actmap,4));
    cc = 1;
    excvec = zeros(size(actmap,4),1);
    for k = 1:size(actmap,4)
        if k > 1 && size(Compfile,2)>1
            if strcmp(Compfile{k},Compfile{k-1})
                cc = cc+1;
                fileseps = strfind(Compfile{k},filesep);
                name_tmp = [Compfile{k}(fileseps(end)+1:end-4) num2str(cc)];
                Stat{k}.compname = name_tmp;
            else
                cc=1;
                fileseps = strfind(Compfile{k},filesep);
                name_tmp = [Compfile{k}(fileseps(end)+1:end-4)];
                Stat{k}.compname = name_tmp;
            end
        elseif size(Compfile,2)==1
            fileseps = strfind(Compfile{1},filesep);
            name_tmp = Compfile{1}(fileseps(end)+1:end-4);
            Stat{k}.compname = name_tmp;
        else
            fileseps = strfind(Compfile{k},filesep);
            name_tmp = Compfile{k}(fileseps(end)+1:end-4);
            Stat{k}.compname = name_tmp;
        end
        fprintf('%s \n',Stat{k}.compname)
        
        tmpVOL = squeeze(actmap(:,:,:,k));
        [Stat{k}.ANO, exclusion] = showRank(luts,ANO2,tmpVOL,threshold,rN,type,weighted,hemisphere,network);
        [Stat{k}.FIBT, dummy] = showRank(luts,FIBT2,tmpVOL,threshold,rN,type,weighted,hemisphere,network);
        fprintf('\n');
        excvec(k) = exclusion;
    end
end

[X, Y, Z] = ndgrid(1:size(AVGT,1),1:size(AVGT,2),1:size(AVGT,3));
luts.X = array2mosaic(X);
luts.Y = array2mosaic(Y);
luts.Z = array2mosaic(Z);
luts.ANO = perm(ANO);
luts.FIBT = perm(FIBT);

% show image if there is only one component
if size(actmap,4) == 1
    h = figure%(1001);
    back = COL*calpha+repmat(AVGT/max(AVGT(:)),[1 1 1 3])*(1-calpha);
    if not(strcmp(Compfile,'nocomp'))
        ovl(array2mosaic(back),array2mosaic(perm(actmap)),[threshold 1],'hot')
    else
        ovl(array2mosaic(back),'empty','empty','empty')
    end
    % set datacursor fcn
    dcm_obj = datacursormode(gcf);
    set(dcm_obj,'UpdateFcn',@(x,y) myupdatefcn(x,y,luts));
    BrAtwindow = gca;
    set(BrAtwindow,'Position',[0 0 1 1])
    datacursormode(h);
end

%•••• hack 4 paul ••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••


% abs(det(ANOstruct.mat(1:3,1:3)))
global at;
at=[]
% at.nvox=[...
%     [Stat{subj}.ANO.name(1:986)' num2cell(Stat{subj}.ANO.t4(1:986)') ]  ;
%     [Stat{subj}.FIBT.name(987:end)' num2cell(Stat{subj}.FIBT.t4(987:end)') ]...
%     ]

at.name=[Stat{1}.ANO.name(1:986)'  ;Stat{1}.FIBT.name(987:end)'];
at.nvox=at.name;
for j=1:length(Stat)  %j==SUBJECT
    at.nvox=[at.nvox       [num2cell(Stat{j}.ANO.t4(1:986)') ;  num2cell(Stat{j}.FIBT.t4(987:end)')         ]   ];
end
at.vol=[   at.name   num2cell(cell2mat(at.nvox(:,2:end))*abs(det(ANOstruct.mat(1:3,1:3)))) ];

xlswrite('TEST2.xls', at.vol,'vol');
xlswrite('TEST2.xls', at.nvox,'nvox');

%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
function [statistics, exclusion] = showRank(luts,ANO,actmap,threshold,rN,type,weighted,hemisphere,network)
statistics = {};
exclusion = [];
iio = find(actmap>=threshold);
% Number of Voxels of the Activation map (below threshold)
if weighted
    F = sparse(ANO(iio)+1,ones(length(iio),1),actmap(iio));
    sz_activation = sum(actmap(iio));
else
    F = sparse(ANO(iio)+1,ones(length(iio),1),ones(length(iio),1));
    sz_activation = length(iio);
end

% List of Region-Ids covered by the Activation map
idx = find(F>0);
% Number of Voxels with one ID
freq = F(idx);
idx = idx-1;
afreq = full(freq(idx>0));
idx = full(idx(idx>0));

if not(isempty(idx))
    szreg = [];
    n = 0;
    
    [common, ia, ib] = intersect([luts.info.id],idx);
    szreg(ib,1) = [luts.info(ia).voxsz];
    
    ll = 1:length(luts.info); [dummy, t1, t2] = intersect(ll,ia); ll(t1)=[];
    
    for k = ll
        [common, ia, ib] = intersect([luts.info(k).children],idx);
        if not(isempty(ib))
            idx = [idx; luts.info(k).id];
            afreq = [afreq; sum([afreq(ib)])];
            szreg = [szreg; luts.info(k).voxsz];
        end
    end
    
    ifreq = afreq./(sz_activation+szreg-afreq);
    relfreq = afreq./szreg;
    
    %Network identification
    if not(isempty(network))
        [~, ia, ib] = intersect(idx, network);
        idx = idx(ia);
        afreq = afreq(ia);
        relfreq = relfreq(ia);
        ifreq = ifreq(ia);
    end
    
    
    if type == 1, % absolute
        [~, ii] = sort(afreq,'descend');
    elseif type == 2, %relative Voxelnumbers
        [~, ii] = sort(relfreq,'descend');
    elseif type == 3, %intersecting Voxels only
        [~, ii] = sort(ifreq,'descend');
    elseif type == 4, % absolute Voxelnumbers
        [~, ii] = sort(afreq,'descend');
    end;
    
    idx = idx(ii);
    afreq = afreq(ii);
    relfreq = relfreq(ii);
    ifreq = ifreq(ii);
    
    for k = 1:size(luts.info,2)
        statistics.name(k) = {luts.info(k).name};
        statistics.depth(k) = length(luts.info(k).includes);
        j = find([luts.info(k).id]==idx);
        
        if not(isempty(j));
            statistics.t1(k) = 100*afreq(j)/sz_activation;
            statistics.t2(k) = relfreq(j)*100;
            statistics.t3(k) = ifreq(j)*100;
            statistics.t4(k) = afreq(j);
        else
            statistics.t1(k) = 0;
            statistics.t2(k) = 0;
            statistics.t3(k) = 0;
            statistics.t4(k) = 0;
        end
    end
    
    if not(isempty(idx))
        exclusion = 1;
        try
            fprintf('Rank  t1     t2     t3     t4        %s Hemisphere(s)\n',hemisphere{1});
        catch
            fprintf('Rank  t1     t2     t3     t4        %s Hemisphere(s)\n',hemisphere(1)); %hack3 paul
            
        end
        fprintf('-------------------------------------\n');
        if rN < length(idx)
            for j = 1:rN
                k = find([luts.info.id]==idx(j));
                fprintf('%.2i) %5.2f  %5.2f  %5.2f %5.2f   %s (depth %i)\n',j, statistics.t1(k), statistics.t2(k), statistics.t3(k), statistics.t4(k), statistics.name{k}, statistics.depth(k));
            end
        else
            for j = 1:length(idx)
                k = find([luts.info.id]==idx(j));
                fprintf('%.2i) %5.2f  %5.2f  %5.2f %5.2f   %s (depth %i)\n',j, statistics.t1(k), statistics.t2(k), statistics.t3(k), statistics.t4(k), statistics.name{k}, statistics.depth(k));
            end
        end
    else
        exclusion = 0;
    end
end


% Functions for the Figure
function txt = myupdatefcn(empt,event_obj,luts)
pos = get(event_obj,'Position');

R = [luts.X(pos(2),pos(1)) luts.Y(pos(2),pos(1)) luts.Z(pos(2),pos(1))];

idx = luts.ANO(R(1),R(2),R(3));
txt1 = genText(idx,luts,'ANO');
idx = luts.FIBT(R(1),R(2),R(3));
txt2 = genText(idx,luts,'FIBT');
txt = sprintf('%s\n%s',txt1,txt2);
function txt = genText(idx,luts,str)
k = find([luts.info.id]==idx);
if not(isempty(k)),
    txt = [luts.info(k).name ' (' num2str(luts.info(k).id) ')'];
else
    txt = ['unknown ' num2str(idx)];
end;
txt = [str ' ' txt];
function COL = buildColLabeling(ANO,idxLUT)
ANO(isnan(ANO)) = 0;
I = sparse([idxLUT.id]+1,ones(length(idxLUT),1),1:length(idxLUT));
for k = 1:length(idxLUT),
    col = sscanf(idxLUT(k).color_hex_triplet,'%x');
    cmap(k,1) = floor(col/256^2);
    cmap(k,2) = mod(floor(col/256),256);
    cmap(k,3) = mod(floor(col),256);
end;
cmap = [0 0 0 ; cmap]/255;
w = full(I(ANO+1));
COL = reshape(cmap(w+1,:),[size(ANO) 3]);




