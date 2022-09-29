
% windows server session-ID/list, goto session-ID
%% show  table of sessions and the current session-ID
%  sessid()
%% swith WIN-server session to session-ID 18
% sessid(18);
% or
% sessid('goto',18);


function sessid(varargin)

if nargin==0
    %% ===============================================
    
%     [m m2]=system('query session');
    [m m2]=system('quser');
    m3=strsplit(m2,char(10))';
    ic=regexpi2(m3,'>');
    m4=strsplit(char(m3(ic)),' ')';
    i2=min(find(~cellfun( @isempty,cellfun(@(a){[ str2num(a)]},m4))));
    
    lin=repmat('=',[1 100]);
    disp(lin);
    disp(m2);
    disp(lin);
    % disp(['your session-ID: ' m4{i2}]);
    cprintf('*[1 0 1]',['your session-ID: ' m4{i2} '\n']);
    disp(lin);
end
if nargin==1 %change ID
    if isnumeric(varargin{1})
       system(['tscon ' num2str(varargin{1})  ' /v']); 
    end
elseif nargin==2 %change ID
    if strcmp(varargin{1},'goto') 
        system(['tscon ' num2str(varargin{2})  ' /v']);
    end
    
end




