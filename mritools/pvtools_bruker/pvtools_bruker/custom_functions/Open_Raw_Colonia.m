clear all
fclose all
clc


[FileName,PathName] = uigetfile('*','Select 2dseq file');

% Variables definition
slope=NaN;
dim=NaN;
offset=NaN;


visu_pars={};
i=1;
fid=fopen([PathName,'Visu_pars']);
if fid~=-1
    buff=fgets(fid);
    while buff~=-1
        visu_pars{i}=buff;
        buff=fgetl(fid);
        i=i+1;
    end
    fclose(fid);
    
    indice_NFrame=strfind(visu_pars,'##$VisuCoreFrameCount');
    z=1;
    stop=logical([]);
    while isempty(stop)
        stop=isnan(indice_NFrame{z});
        z=z+1;
    end
    n_slice=str2double(cell2mat(regexp(cell2mat(visu_pars(z-1)),'\d','match')));
    
    
    %  Cerco nelle celle del file la stringa dove prendere i parametri di
    %  slope, mi restituisce 0 solo nella cella in cui si trova la stringa
    %  altrimenti la cella è vuota
    indiceVCDS=strfind(visu_pars,'##$VisuCoreDataSlope');
    %  Il ciclo mi restituisce l'indice della prima riga dalla quale prelevare
    %  i valori di slope, ovvero la riga seguente alla stringa cercata in
    %  precedenza
    j=1;
    stop=logical([]);
    while isempty(stop)
        stop=isnan(indiceVCDS{j});
        j=j+1;
    end
    %for k=j:ceil((j+n_slice/14))
    for k=j:ceil((j+n_slice/4)-1)
        slope=cat(2,slope,str2num(visu_pars{k}));
    end
    slope=slope(1,2:1:max(size(slope)));
    
    indiceVCDO=strfind(visu_pars,'##$VisuCoreDataOffs');
    jj=1;
    stop=logical([]);
    while isempty(stop)
        stop=isnan(indiceVCDO{jj});
        jj=jj+1;
    end
    %                 for kk=jj:(jj+n_slice/4-1)
    %                 offset=cat(2,slope,str2num(visu_pars{kk}));
    %                 end
    % Attenzione ai valori di offset se sono diversi da zero controllare se
    % sono su piu' righe perchè in questo caso prendo solo una riga !!!!!!!
    offset=cat(2,offset,str2num(visu_pars{jj}));
    offset=mean(offset(1,2:1:max(size(offset))));%faccio la media dei valori di offset, questi sono sepmre uguali a zero
    
    indiceVCS=strfind(visu_pars,'##$VisuCoreSize');
    jjj=1;
    stop=logical([]);
    while isempty(stop)
        stop=isnan(indiceVCS{jjj});
        jjj=jjj+1;
    end
    dim=cat(2,dim,str2num(visu_pars{jjj}));
    dim=dim(1,2:1:max(size(dim)));
    
end
% Codice dedicato all'apertura dei file 2dseq che crea una matrice 3D contenente le immagini del file
fid=fopen([PathName,FileName]);
%img=fread(fid,inf,'uint32');
img=fread(fid,inf,'uint16');
img=reshape(img,dim(:,1),dim(:,2),n_slice);
% Normalizzazione fetta per fetta secondo la relazione: y = slope * x + offset
for i=1:n_slice
    img2(:,:,i)=(img(:,:,i)*slope(:,i))+offset;
end