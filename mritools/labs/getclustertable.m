
function table=getclustertable(vol,mat,dim,tresh)
% get clustertable for statistical fMRI-volume
% usage type
% type [1]:  function table=getclustertable(vol,mat,dim,tresh)
% type [2]:  function table=getclustertable([Num Dis])  -->for SPM
% type [2]:  function table=getclustertable              -->for SPM default
%============================================================================
% TYPE [1]:              *** NON-SPM ***
% _____INPUT
% vol..    3d-volume
% mat..    use hdr.mat
% dim..    use dim.mat
% thresh.. 4 threshold values -->see below
% _____[4 threshold values]_________________');
% vector with 4 values  (separated with space) or use nans for specific default parameter, or viewer values if only the first ordered values have to be specified : [4 5 nan nan] equals[4 5]
% [1]HeightTResh                   'HT'              ...voxel with values above HT considered (MAgnitude threshold)
% [2]nvox/cluster                  'NVC'             ...nvoxels above NVC consideres as cluster (clutersize threshold)
% [3]NMaxima/Cluster    to report  'NMC'             ... number of maxima peaks within a cluster to report
% [4]distance between Clusters     'DC'              ...distance between neighbouring clusters [mm]
%     example: [4 10 4 5 ]    ;MEANING:statistical Threshold >=[4];each cluster must have >=[10] adjacent voxels; give me [4] peakLabebels for each cluster; clusters must be separated by at least[5]mm
%     example: [4 10 nan nan ];MEANING:same with SPM default settings [3]peaks per cluster, [8]mm cluster-separation
%     example: [4 10 ]        ;MEANING:same as previous example
%     example: [4 nan 4 5 ]   ;MEANING: as as 1st.example but report all clusters (no contraints regarding the size of cluster)
% _____OUTPUT
%   struct with table
% ____EXAMPLE
% getclustertable(vol,img.mat,img.dim,[.4 10]); %HT=4 , NVC=10, (NMC & DC are feault: NMC=3, DC=8)
% getclustertable(vol,img.mat,img.dim); %HT=min magnitude in volume , NVC=1, (NMC & DC are feault: NMC=3, DC=8)
% getclustertable(vol,img.mat,img.dim,[.4 10, 5 2]); %HT=4 , NVC=10, NMC=5 , DC=5
%============================================================================
% TYPE [2]:              *** SPM ***
% using SPM-data/struct
% function table=getclustertable             -->for SPM with defaults [# cluster] & [# cluster distance]
% function table=getclustertable([Num Dis])  -->for SPM
% ...args:
% Num    - number of maxima per cluster [3]
% Dis    - distance among clusters {mm} [8]


% [1]HeightTResh,[2]nvox/cluster,[3]NMaxima/Cluster,[4]distance between Clusters

% vol
% dim
% us.functionalImg.mat
% hdr.mat=us.functionalImg.mat;
% hdr.dim=us.functionalImg.dim;


% us=get(gcf,'userdata');
% dim=us.functionalImg.dim;
if exist('tresh')==0; tresh=[];end
if exist('vol')==0;   vol=[];end

if isempty(vol) |length(vol)==2 & isnumeric(vol)
    %     if strcmp(lower(vol),'spm')
    %         xSPM=evalin('base','xSPM');
    %         dim = xSPM.DIM;
    %         mat = xSPM.M;
    %         XYZ = xSPM.XYZ;
    %         XYZmm = xSPM.XYZmm;
    %         ts    = xSPM.Z(:);
    %     end


    xSPM=evalin('base','xSPM');
    if isempty(vol)
        k=spm_list( 'List' ,xSPM, findobj(0,'Tag','hReg'));
    else
        k=spm_list( 'List' ,xSPM, findobj(0,'Tag','hReg'),vol(1),vol(2));
    end
        
        iT     =find(strcmp(k.hdr(2,:),'T' ) & strcmp(k.hdr(1,:),'peak' ));
        ipuncor=find(strcmp(k.hdr(2,:),'p(unc)' ) & strcmp(k.hdr(1,:),'peak' ));
        ivox   =find(strcmp(k.hdr(2,:),'equivk' ) & strcmp(k.hdr(1,:),'cluster' ));



        nvox=k.dat(:,ivox);nvox=cellfun(@(x){ sprintf('[%5.0f]',x) },nvox);
        nvox=cellfun(@(x){regexprep(x,{'[' ']'},'')},nvox);

        T   =k.dat(:,[iT]);T=cellfun(@(x){ sprintf('%5.2f',x) },T);
        p  =k.dat(:,[ipuncor]); p=cellfun(@(x){ num2str(x)},p);

        xyz  =  k.dat(:,[end]);
        cords=round(cell2mat(cellfun(@(x){ x(:)'},xyz)));
        % cellfun(@(x){ sprintf('[%4.0f %4.0f %4.0f]',x) },xyz)

        addhead ={'N' 'T' 'p' };
        add     =[nvox T   p  ];

        try
            [labelx header labelcell]=pick_wrapper(cords, 'Noshow');
            showtable3([0 0 1 1],[...
                [  header(1:2)   addhead    header(3:end)        ];...
                [  labelx(:,1:2) add        labelx(:,3:end)      ],...
                ] ,'fontsize',8);
        end

        us=get(gcf,'userdata');
        us.SPMgrap=0;
        set(gcf,'userdata',us);


        % table= labs(cords,{'addcolpre',{'CL-idx' 'stats' 'NvxClust'} ...
        %         [sv.A(ix_surv)  sv.Z(ix_surv)    sm.nvox(sv.idx(ix_surv))  ]});




        return




    else %IMG-struct
        %from spm_read_vols (line: 53)
        [R,C,P]  = ndgrid(1:dim(1),1:dim(2),1:dim(3));
        RCP      = [R(:)';C(:)';P(:)'];
        XYZ   =RCP;
        clear R C P
        RCP(4,:) = 1;
        % XYZmm      = us.functionalImg.mat(1:3,:)*RCP;
        XYZmm      = mat(1:3,:)*RCP;
        % vol=us.functionalImg.imgdata;
        ts =vol(:)';

    end

    tr_magnitude  =0.1;
    tr_nvoxClust  =1;
    tr_npeakClust =3;
    tr_clustDist  =8;
    ist= [tr_magnitude tr_nvoxClust tr_npeakClust tr_clustDist];
    % is=find(ts>tr_magnitude);

    % tresh=input('select MAGNITUDE threshold (select a number or let it empty): ','s')
    % tresh=input('MAGNITUDE threshold and clustersize (2 values or empty (default), or nan): ','s')
    % tresh=input('4 values: [1]HeightTResh,[2]clustersize,[3]Npeaks/Cluster,[4]distance between clusters (2 values or empty (default), or nan): ','s')

    % disp('_____INPUTS_________________');
    % disp('press enter for default, otherwise specify...');
    % disp('4 values (separated with space) or use nans for specific default parameter, or viewer values if only the first ordered values have to be specified : [4 5 nan nan] equals[4 5] ');
    % disp('[1]HeightTResh,[2]nvox/cluster,[3]Npeaks/Cluster,[4]distance between Clusters');
    % disp('example: "4 10 4 5 ";MEANING:statistical Threshold >=[4];each cluster must have >=[10] adjacent voxels; give me [4] peakLabebels for each cluster; clusters must be separated by at least[5]mm '  );
    % disp('example: "4 10 nan nan ";MEANING:same with SPM default settings [3]peaks per cluster, [8]mm cluster-separation'  );
    % disp('example: "4 10 ";MEANING:same as previous example'  );
    % disp('example: "4 nan 4 5 ";MEANING: as as 1st.example but report all clusters (no contraints regarding the size of cluster)'  );
    % tresh=input('4 values: ' ,'s');


    if ~isempty(tresh)
        %     val=str2num(tresh);
        val= (tresh);

        soll=[tr_magnitude tr_nvoxClust tr_npeakClust tr_clustDist] ;
        %     val=[4 0 8 ]
        val(size(val,2)+1:size(soll,2))=nan;
        val(isnan(val))= soll(isnan(val));

        tr_magnitude   =val(1);
        tr_nvoxClust   =val(2);
        tr_npeakClust  =val(3);
        tr_clustDist   =val(4);

        ist= [tr_magnitude tr_nvoxClust tr_npeakClust tr_clustDist];
    end
    is=find(ts>=tr_magnitude);

    %% tester idx Values match with XYZ-VOLUME
    % % % % % if 0
    % % % % %     itest=252;
    % % % % %     ts(is(itest));
    % % % % %     % XYZ(:,is(itest))
    % % % % %     vol(XYZ(1,is(itest)),XYZ(2,is(itest)),XYZ(3,is(itest)));
    % % % % % end

    Z=ts(is);
    XYZsurv=XYZ(:,is);
    % hdr.mat=us.functionalImg.mat;
    % hdr.dim=us.functionalImg.dim;
    hdr.mat=mat;
    hdr.dim=dim;
    [sm]=pclustermaxima(Z,XYZsurv,hdr) ; %get MAX of clusters
    try
        [sv]=pclustermaximaContraint(sm.Z,sm.regnr,sm.XYZ,sm.hdr,tr_npeakClust,tr_clustDist);
    catch
        [sv]=pclustermaximaContraint(sm.Z,sm.regnr,sm.XYZ,sm.hdr,3,8);
        %  disp('use SPM-defaults for NpeaksPerCluster[3] and distance between clusters[8mm]-->there was an error in parameter specification');
    end
    %[sv]=pclustermaximaContraint(sm.Z,sm.regnr,sm.XYZ,sm.hdr,10,4);

    % hdr.mat=us.functionalImg.mat;
    % hdr.dim=us.functionalImg.dim;
    % [ st ]=pclustertreshIMG('Accuracies', ts, tr_magnitude,tr_nvoxClust, XYZ,hdr,1 )
    % [ st ]=pclustertreshIMG('Accuracies', ts, 3,30, XYZ,hdr,1 )
    %
    % [ st ]=pclustertreshIMG('Accuracies',Z, 0, 0, XYZsurv,hdr,1 )

    if 0
        %sm.Z
        %     [ st ]=pclustertreshIMG('Accuracies', sm.Z,70,30,c.XYZ,c.hdr,0 )
        a.hdr.mat=us.functionalImg.mat;
        a.hdr.dim=dim;
        [ st ]=pclustertreshIMG('Accuracies', ts, 70,40, XYZ,a.hdr,1 )

        %     acc3=acc2;
        %     acc3(acc3<50)=50;
        x.mask='D:\relapse_TWU\mask.nii'
        x.pa_out='D:\relapse_TWU\results'
        strct=spm_vol(x.mask);
        vol3=makevol( st.Z,  st.XYZ,  strct,nan);
        pwritevol2vol(fullfile(x.pa_out, 'acc_tr70_tr40voxClst'),vol3,strct,'acc_tr');

        Z=st.Z;
        XYZsurv=st.XYZ;
        hdr.mat=us.functionalImg.mat;
        hdr.dim=us.functionalImg.dim;
        [sm]=pclustermaxima(Z,XYZsurv,hdr) ; %get MAX of clusters
        [sv]=pclustermaximaContraint(sm.Z,sm.regnr,sm.XYZ,sm.hdr,3,8);


    end
    % if 0 % magnitude and clustersize treshold
    % end

    clustsize=sm.nvox(sv.idx);
    % if tr_nvoxClust==0
    %     labs(sv.XYZmm,{'addcolpre',{'CL-idx' 'stats' 'NvxClust'} ...
    %         [sv.A  sv.Z    sm.nvox(sv.idx)  ]});
    % else %cklustertreshold
    ix_surv=find(clustsize>=tr_nvoxClust) ;
    table= labs(sv.XYZmm(:,ix_surv),{'addcolpre',{'CL-idx' 'stats' 'NvxClust'} ...
        [sv.A(ix_surv)  sv.Z(ix_surv)    sm.nvox(sv.idx(ix_surv))  ]});

    %   labs(sv.XYZmm(:,ix_surv),{'addcolpre',{'CL-idx' 'stats' 'NvxClust'} ...
    %         [sv.A(ix_surv)  sv.Z(ix_surv)    sm.nvox(sv.idx(ix_surv))  ]});

    % end
    %ADDON
    % us=get(gcf,'userdata');
    % us.addlab=

    % [1]HeightTResh,[2]nvox/cluster,[3]Npeaks/Cluster,[4]distance between Clusters
    disp(['[1]HeightTResh:                '  num2str(ist(1))   ]);
    disp(['[2]nvox/cluster:               '  num2str(ist(2))   ]);
    disp(['[3]Nmaxima(Peaks)/Cluster:     '  num2str(ist(3))   ]);
    disp(['[4]distance between Clusters : '  num2str(ist(4))   ]);




    set(gcf,'tag','');
    % disp('params');
    % disp(num2str(ist));