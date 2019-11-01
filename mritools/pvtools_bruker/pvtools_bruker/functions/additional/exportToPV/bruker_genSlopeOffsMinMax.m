function [VisuCore]=bruker_genSlopeOffsMinMax(VisuCoreWordType, data, VisuCoreDataSlope, VisuCoreDataOffs)
% [VisuCoreDataSlope, VisuCoreDataOffs, VisuCoreDataMin, VisuCoreDataMax]=bruker_genSlopeOffsMinMax(VisuCoreWordType, data, VisuCoreDataSlope, VisuCoreDataOffs)
% generates some important visu-parameters from a dataset, dependends on
% the target word-type.
% There are 2 modi:
%   - insert VisuCoreWordType, data, VisuCoreDataSlope=1 and VisuCoreDataOffs=0 -> will calculate all output
%     variables
%   - insert a different Slope or Offset -> will calculate only the VisuCoreDataMin,
%     VisuCoreDataMax based on data, VisuCoreDataSlope and VisuCoreDataOffs
%
% Note: VisuCoreWordType _32BIT_SGN_INT _16BIT_SGN_INT and _32BIT_FLOAT
%       and if you calculate all parameters, it will leave the zero-value by the zero-value, that means: 
%       it's possible that not the complete range is used.  
%
% IN: some Parameter of visu_pars, and the data-matrix with (dim1, dim2, dim3, dim4, NumberFrames)
% Out: some visu_pars parameter which are necessary for writing a PV-dataset 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2012
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: bruker_genSlopeOffsMinMax.m,v 1.1 2012/09/11 14:22:10 pfre Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch(VisuCoreWordType)
    case ('_32BIT_SGN_INT')
        allowed_min=-2147483648 +1;
        allowed_max= 2147483647 -1;
        keepimagezero=true;
        calcOffsetSlope=true;
    case ('_16BIT_SGN_INT')
        allowed_min=-32768 +1;
        allowed_max=32767 -1;
        keepimagezero=true;
        calcOffsetSlope=true;
    case ('_32BIT_FLOAT')
        allowed_min=-realmax('single') +1;
        allowed_max=realmax('single') -1;
        keepimagezero=true;
        calcOffsetSlope=false;
    case('_8BIT_UNSGN_INT')
        allowed_min=0 +1;
        allowed_max=255 -1;
        keepimagezero=false;
        calcOffsetSlope=true;
    otherwise
        error('Data-Format not correct specified!')
end

%% Read Mins and Maxs
dims=size(data);
if length(dims)<=5 && isreal(data)
    maxpos=zeros(size(data,5),1);
    maxneg=zeros(size(data,5),1);
    for i=1:size(data,5)
        maxpos(i)=max(max(max(max(max(data(:,:,:,:,i))))));
        maxneg(i)=min(min(min(min(min(data(:,:,:,:,i))))));
    end
elseif isreal(data)
    frameCount=prod(dims(5:end));
    maxpos=zeros(frameCount,1);
    maxneg=zeros(frameCount,1);
    dimlist=dims(5:end);
    
    % generate mapping-table1:
    dimmatrix_tmp=zeros(prod(dimlist),length(dimlist));
    for i1=1:prod(dimlist)
        modulus=mod(i1-1,dimlist(end));
        reminder=fix((i1-1)/dimlist(end));
        dimmatrix_tmp(i1,length(dimlist))=modulus+1;
        for i2=length(dimlist)-1:-1:1
            modulus=mod(reminder,dimlist(i2));
            reminder=fix(reminder/dimlist(i2));
            dimmatrix_tmp(i1,i2)=modulus+1;
        end      
    end
    % convert to 10 Dims:
    dimmatrix=ones(size(dimmatrix_tmp,1),10);
    dimmatrix(:,1:size(dimmatrix_tmp,2))=dimmatrix_tmp;
    clear dimmatrix_tmp;
    
    % generate mapping-table2:
    map=reshape(1:frameCount, dimlist);
    
    for i=1:size(dimmatrix,1)
        counter=map(dimmatrix(i,1), dimmatrix(i,2), dimmatrix(i,3), dimmatrix(i,4), dimmatrix(i,5), dimmatrix(i,6), dimmatrix(i,7), dimmatrix(i,8), dimmatrix(i,9), dimmatrix(i,10));
        maxpos(counter)=max(max(max(max(max(data(:,:,:,:,dimmatrix(i,1), dimmatrix(i,2), dimmatrix(i,3), dimmatrix(i,4), dimmatrix(i,5), dimmatrix(i,6), dimmatrix(i,7), dimmatrix(i,8), dimmatrix(i,9), dimmatrix(i,10)))))));
        maxneg(counter)=min(min(min(min(min(data(:,:,:,:,dimmatrix(i,1), dimmatrix(i,2), dimmatrix(i,3), dimmatrix(i,4), dimmatrix(i,5), dimmatrix(i,6), dimmatrix(i,7), dimmatrix(i,8), dimmatrix(i,9), dimmatrix(i,10)))))));
    end
   
elseif ~isreal(data)
    frameCount=prod(dims(5:end));
    maxpos=zeros(2*frameCount,1);
    maxneg=zeros(2*frameCount,1);
    dimlist=dims(5:end);
    
    % generate mapping-table1:
    dimmatrix_tmp=zeros(prod(dimlist),length(dimlist));
    for i1=1:prod(dimlist)
        modulus=mod(i1-1,dimlist(end));
        reminder=fix((i1-1)/dimlist(end));
        dimmatrix_tmp(i1,length(dimlist))=modulus+1;
        for i2=length(dimlist)-1:-1:1
            modulus=mod(reminder,dimlist(i2));
            reminder=fix(reminder/dimlist(i2));
            dimmatrix_tmp(i1,i2)=modulus+1;
        end      
    end
    % convert to 10 Dims:
    dimmatrix=ones(size(dimmatrix_tmp,1),10);
    dimmatrix(:,1:size(dimmatrix_tmp,2))=dimmatrix_tmp;
    clear dimmatrix_tmp;
    
    % generate mapping-table2:
    map=reshape(1:frameCount, [dimlist,1]);
    
    for i=1:size(dimmatrix,1)
        counter=map(dimmatrix(i,1), dimmatrix(i,2), dimmatrix(i,3), dimmatrix(i,4), dimmatrix(i,5), dimmatrix(i,6), dimmatrix(i,7), dimmatrix(i,8), dimmatrix(i,9), dimmatrix(i,10));
        maxpos(counter)=max(max(max(max(max(real(data(:,:,:,:,dimmatrix(i,1), dimmatrix(i,2), dimmatrix(i,3), dimmatrix(i,4), dimmatrix(i,5), dimmatrix(i,6), dimmatrix(i,7), dimmatrix(i,8), dimmatrix(i,9), dimmatrix(i,10))))))));
        maxneg(counter)=min(min(min(min(min(real(data(:,:,:,:,dimmatrix(i,1), dimmatrix(i,2), dimmatrix(i,3), dimmatrix(i,4), dimmatrix(i,5), dimmatrix(i,6), dimmatrix(i,7), dimmatrix(i,8), dimmatrix(i,9), dimmatrix(i,10))))))));
        maxpos(counter+frameCount)=max(max(max(max(max(imag(data(:,:,:,:,dimmatrix(i,1), dimmatrix(i,2), dimmatrix(i,3), dimmatrix(i,4), dimmatrix(i,5), dimmatrix(i,6), dimmatrix(i,7), dimmatrix(i,8), dimmatrix(i,9), dimmatrix(i,10))))))));
        maxneg(counter+frameCount)=min(min(min(min(min(imag(data(:,:,:,:,dimmatrix(i,1), dimmatrix(i,2), dimmatrix(i,3), dimmatrix(i,4), dimmatrix(i,5), dimmatrix(i,6), dimmatrix(i,7), dimmatrix(i,8), dimmatrix(i,9), dimmatrix(i,10))))))));
    end
end

%% Claculate slope and off
% later in write2dseq: discdata=(data-offset)/slope
if calcOffsetSlope
    if prod(VisuCoreDataSlope(:))==1 && sum(abs(VisuCoreDataOffs(:)))==0
        VisuCoreDataOffs=zeros(length(maxpos),1);
        VisuCoreDataSlope=zeros(length(maxpos),1);
        for i=1:length(maxpos)
            if keepimagezero
                slope_pos=maxpos(i)/allowed_max;
                slope_neg=maxneg(i)/allowed_min;
                VisuCoreDataSlope(i)=max([slope_pos, slope_neg]);
                % VisuCoreDataOffs=0; (still done)
            else
                VisuCoreDataSlope(i)=(maxpos(i)-maxneg(i))/(allowed_max-allowed_min);      
                VisuCoreDataOffs(i)=maxneg(i)-allowed_min*VisuCoreDataSlope(i);
            end
        end
    end
else
    VisuCoreDataOffs=zeros(length(maxpos),1);
    VisuCoreDataSlope=ones(length(maxpos),1);
end


%% Calculate VisuCoreDataMax and VisuCoreDataMin
VisuCoreDataMax=zeros(length(maxpos),1);
VisuCoreDataMin=zeros(length(maxpos),1);
for i=1:length(maxpos)
    VisuCoreDataMax(i)=(maxpos(i)-VisuCoreDataOffs(i))/VisuCoreDataSlope(i);
    VisuCoreDataMin(i)=(maxneg(i)-VisuCoreDataOffs(i))/VisuCoreDataSlope(i);
    if VisuCoreDataMax(i) > allowed_max+1
        warning('MATLAB:bruker_warning', 'Your dataslope and data of are cutting the values');
        VisuCoreDataMax=allowed_max+1;
    end
    if VisuCoreDataMin(i) < allowed_min-1
        warning('MATLAB:bruker_warning', 'Your dataslope and data of are cutting the values');
    end
end



%% Save variables to struct
VisuCore.VisuCoreDataSlope=VisuCoreDataSlope;
VisuCore.VisuCoreDataOffs=VisuCoreDataOffs;
VisuCore.VisuCoreDataMin=VisuCoreDataMin;
VisuCore.VisuCoreDataMax=VisuCoreDataMax;



end
