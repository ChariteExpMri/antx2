function numSelectedReceivers = bruker_getSelectedReceivers(Acqp)
% numSelectedReceivers = bruker_getSelectedReceivers(Acqp)
% out: Number of selected receivers (integer)
%
% in: the Acqp-struct of RawDataObject or readBrukerParamFile
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2012
% Bruker BioSpin MRI GmbH
% D-76275 Ettlingen, Germany
%
% All Rights Reserved
%
% $Id: bruker_getSelectedReceivers.m,v 1.1 2012/09/11 14:22:10 pfre Exp $
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    if strcmp(Acqp.ACQ_experiment_mode,'ParallelExperiment')
        if isfield(Acqp, 'GO_ReceiverSelect')
            if ischar(Acqp.GO_ReceiverSelect)
                numSelectedReceivers=0;
                for i=1:size(Acqp.GO_ReceiverSelect,1)
                    if strcmpi(Acqp.GO_ReceiverSelect(i,:), 'Yes');
                        numSelectedReceivers=numSelectedReceivers+1;
                    end
                end
            else
                numSelectedReceivers=sum(strcmp(Acqp.GO_ReceiverSelect,'Yes'));
            end
        elseif isfield(Acqp, 'ACQ_ReceiverSelect')
            if ischar(Acqp.ACQ_ReceiverSelect)
                numSelectedReceivers=0;
                for i=1:size(Acqp.ACQ_ReceiverSelect,1)
                    if strcmpi(Acqp.ACQ_ReceiverSelect(i,:), 'Yes');
                        numSelectedReceivers=numSelectedReceivers+1;
                    end
                end
            else
                numSelectedReceivers=sum(strcmp(Acqp.ACQ_ReceiverSelect,'Yes'));
            end
        else
            disp('No information about active channels available.');
            numSelectedReceivers=1;
            disp('The number of channels is set to 1 ! But at this point the only effect is a bad matrixsize.');
            disp('Later you can change the size yourself.');
        end
    else
        numSelectedReceivers=1;
    end