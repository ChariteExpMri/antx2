
%previous filename: MyProgressMonitor
classdef TemplateProgressMonitor < matlab.net.http.ProgressMonitor
    properties
        ProgHandle
        Direction matlab.net.http.MessageType
        Value uint64
%         Value double
        NewDir matlab.net.http.MessageType = matlab.net.http.MessageType.Request
    end
    
    methods
        function obj = TemplateProgressMonitor
            obj.Interval = 0.1;
        end
        
        function done(obj)
            obj.closeit();
        end
        
        function delete(obj)
            obj.closeit();
        end
        
        function set.Direction(obj, dir)
            obj.Direction = dir;
            obj.changeDir();
        end
        
        function set.Value(obj, value)
            obj.Value = value;
            obj.update();
        end
    end
    
    methods % (Access = private)
        function update(obj,~)
          
            valmx=10e7;
          
            % called when Value is set
            import matlab.net.http.*
            if ~isempty(obj.Value)
                if isempty(obj.Max)
                    % no maximum means we don't know length, so message 
                    % changes on every call
                    value = 0;
                    if obj.Direction == MessageType.Request
                        msg = sprintf('Sent %d bytes...', obj.Value);
                    else
                        msg = sprintf('Received %d/%d bytes...', obj.Value,valmx);
                    end
                else
                    % maximum known, update proportional value
                    value = double(obj.Value)/double(obj.Max);
                    if obj.NewDir == MessageType.Request
                        % message changes only on change of direction
                        if obj.Direction == MessageType.Request
                            msg = 'Sending...';
                        else
                            msg = 'Receiving...';
                        end
                    end
                end
                
                global pardownload;
                msg0='[%d/%d] Received %05.2f/%05.2f MB (%d%%)    T: %s/%s   ';
                msg=sprintf([msg0 '                          '],0,0,   0,pardownload.bytes/1e6,0,'','');

                if isempty(obj.ProgHandle)
                    % if we don't have a progress bar, display it for first time
                    obj.ProgHandle = ...
                        waitbar(value, msg, 'CreateCancelBtn', ...
                            @(~,~)cancelAndClose(obj),'Name',pardownload.fileName);
                    obj.NewDir = MessageType.Response;
                    pardownload.tim0=tic;
                elseif obj.NewDir == MessageType.Request || isempty(obj.Max)
                    % on change of direction or if no maximum known, change message
                    
                    curMB=double(obj.Value);
                    iwaitbar=curMB/pardownload.bytes;
                    
                    secs=toc(pardownload.tim0);
                    TT=seconds(secs);
                    TT.Format = 'mm:ss';
                    TT=sprintf('%s',TT);
                    
                    AT=seconds(1/iwaitbar*secs); 
                    AT.Format = 'mm:ss';
                    AT=sprintf('%s',AT);
                    
                    
                    
                    %msg = sprintf('Received %d/%d bytes...', obj.Value,valmx);
                    %msg=sprintf('[%s] Received %2.2f/%2.2fMB...',pardownload.fileName, obj.Value/1e6,pardownload.bytes/1e6);
                    msg=sprintf(msg0,...
                        pardownload.idx  , length(pardownload.idxall)     ,...
                        curMB/1e6    , pardownload.bytes/1e6  , round(iwaitbar*100), ...
                        TT,AT);

                    waitbar(iwaitbar, obj.ProgHandle, msg);
                     
                   % waitbar(value, obj.ProgHandle, msg);
                    obj.NewDir = MessageType.Response;
                   %disp(curMB);
                   %disp([TT ' -- ' AT]);

                else
                    % no direction change else just update proportional value
                    waitbar(value, obj.ProgHandle);
                   
                end
            end
            
            function cancelAndClose(obj)
                % Call the required CancelFcn and then close our progress bar. 
                % This is called when user clicks cancel or closes the window.
                obj.CancelFcn();
                obj.closeit();
            end
        end
        
        function changeDir(obj,~)
            % Called when Direction is set or changed.  Leave the progress 
            % bar displayed.
            obj.NewDir = matlab.net.http.MessageType.Request;
        end
    end
    
    methods (Access=private)
        function closeit(obj)
            % Close the progress bar by deleting the handle so 
            % CloseRequestFcn isn't called, because waitbar calls 
            % cancelAndClose(), which would cause recursion.
            if ~isempty(obj.ProgHandle)
                delete(obj.ProgHandle);
                obj.ProgHandle = [];
            end
        end
    end
end