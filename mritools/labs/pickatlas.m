
function tx=pickatlas(cordsMNI)
global Atlas
if length(Atlas) ==0;%isglobal(Atlas)

    pax=regexprep(which('pickatlas.m'),'pickatlas.m','');
    err=exist(fullfile(pax,'Atlas.mat'));
    if err==0
        LookUpFilePath='MNI_atlas_templates_from_wfu_pickatlas' ;%'MNI_atlas_templates'
        LookUpFileName='master_lookup.txt';
        ImageName='MNI_T1.nii';
        % [Atlas] = wfu_get_atlas_list(LookUpFilePath, LookUpFileName, ImageName)
        [Atlas] = get_atlas_list(LookUpFilePath, LookUpFileName, ImageName)
        save(fullfile(pax,'Atlas.mat'),'Atlas');
    else
        load(fullfile(pax,'Atlas.mat'))
    end
end

replacem={'Lobe' 'Lo'; 'Left' 'L'; 'Right' 'R'; 'Gyrus' 'Gyr';...
    'White Matter' 'WM';'Gray Matter' 'GM'; 'Occipital' 'Occip'; 'Frontal' 'Front';...
    'lateral' 'lat'; 'Temporal' 'Temp';...
    'posterior' 'post' ;'parietal' 'par' ;'region' 'reg';'medial' 'med';...
    'anterior' 'ant';'Superior' 'sup' ; 'Inferior' 'inf';...
    'Cerebro-Spinal Fluid' 'CSF'; 'inter-hemispheric' 'interHem' ; '_' '-';...
    'Brodmann area' 'BA';'Cerebrum' 'C.' ;'interHem' 'iHem'; 'Hemispheres' 'Hem.';...
    'Brainstem' 'BS.'};

Natlas=length(Atlas);
tx=repmat({''},[length(Atlas) 2]);
for atlasNo=1:Natlas;%8%length(Atlas)
    cordsCube =round( inv(  Atlas(atlasNo).Iheader.mat )*[cordsMNI(1) cordsMNI(2) cordsMNI(3) 1]');
    value=Atlas(atlasNo).Offset;
    sel_atlas=Atlas(atlasNo).Atlas;
    try
        value = value + sel_atlas(cordsCube(1), cordsCube(2), cordsCube(3));
    catch
        value=nan;
    end
    found = 0;

    for j=1 : length(Atlas(atlasNo).Region)
        for i =1 : length(Atlas(atlasNo).Region(j).SubregionValues)
            if ((Atlas(atlasNo).Region(j).SubregionValues(i)+Atlas(atlasNo).Offset) == value)
                found =1;
                break;
            end
        end
    end
    if found==1
        lab=deblank(Atlas(atlasNo).Region(j).SubregionNames(i));
    else
        lab={''};
    end
    lab=regexprep(lab,'brodmann area','BA');
    lab=regexprep(lab,replacem(:,1),replacem(:,2),'ignorecase');

    atlasname={Atlas(atlasNo).Name};
    atlasname=regexprep(atlasname,'brodmann area','BA');
    atlasname=regexprep(atlasname,'TD','');
    if isempty(lab); lab={' '};end
    tx(atlasNo,:)=[atlasname      lab] ;% {Atlas(9).Name   lab  }
end %atlasNo


