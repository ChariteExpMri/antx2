%% open matlabpool depending on Matlab-version
% no args: open max number of pools
% args1: 'close'  -->forces to close pools
%% EXAMPLES:
% createParallelpools;  % open parallel pool
% createParallelpools('close'); %close  parallel pool
% status=createParallelpools; %status of the pool (0)close, (1)open

function varargout=createParallelpools(arg1)


state=0;
if ~isempty(which('matlabpool')); %older versions
    vers=1;
end
if ~isempty(which('parpool')); %replaced in R2013b
    vers=2;
end


%% open pool
if exist('arg1')~=1
    if vers==1
        mpools=[4 3 2];
        for k=1:length(mpools)
            try;
                matlabpool(mpools(k));
                state=1;
                disp(sprintf('process with %d PARALLEL-CORES',mppols(k)));
                break
            end
        end
    end
    
    if vers==2
        poolinfo= (gcp('nocreate'));
        if  isempty(poolinfo)
            %local mpiexec disabled in version 2010a and newer
            versrelease=version('-release');
            if str2num(versrelease(1:end-1))>2010
                
                distcomp.feature('LocalUseMpiexec',false);
            end
            
            parpool
            state=1;
        else
%             disp('PTB already running...');
%             disp(poolinfo);
            state=1;
        end
    end
    
    varargout{1}=state;
    return
end

%% close pool
if exist('arg1')==1
    if strcmp(arg1,'close')
        if vers==1
            matlabpool close;
            state=0;
        elseif vers==2
            delete(gcp('nocreate'))
            state=0;
        end
    end
    
end


varargout{1}=state;