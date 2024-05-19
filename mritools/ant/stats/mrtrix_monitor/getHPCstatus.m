

function s=getHPCstatus(p,task,arg)

% p.HPC_hostname='s-sc-frontend2.charite.de'


%% ===============================================
% [4.1] get username and password
%     if ss==1
global mpw
if isfield(mpw,'login')==0 || isfield(mpw,'password')==0
    
    
    [p.login p.password] = logindlg('Title','HPC-cluster');
    mpw.login=p.login;
    mpw.password=p.password;
    if isempty(p.login) || isempty(p.password)
        
        
        return
    end
else
    p.login   = mpw.login;
    p.password= mpw.password;
end

if strcmp(task,'findfiles')
    if strcmp(arg(end),'*')==0
        arg=[arg '*'];
    end
    cmd=['ls ' arg] ;
    o='';
    o = ssh2_simple_command(p.HPC_hostname,p.login,p.password,cmd);
    %  uhelp(o,0,'name', 'current running processes');
    if ~isempty(o) %SUCCESS
        global mpw
        mpw.login =p.login;
        mpw.password=p.password;
    else
        clear global mpw
    end
    s.status=o;
end
 
if strcmp(task,'listfiles') || strcmp(task,'listfiles_time')
    if strcmp(task,'listfiles')
        cmd='ls -tl';%'squeue --me'   ;
    else
        cmd='ls -l';
    end
    o='';
    o = ssh2_simple_command(p.HPC_hostname,p.login,p.password,cmd);
    %  uhelp(o,0,'name', 'current running processes');
    if ~isempty(o) %SUCCESS
        global mpw
        mpw.login =p.login;
        mpw.password=p.password;
    else
        clear global mpw
    end
    s.status=o;
 end
%% ===============================================
if strcmp(task,'squeue --me')
    cmd='squeue --me'   ;
    o='';
    o = ssh2_simple_command(p.HPC_hostname,p.login,p.password,cmd);
    %  uhelp(o,0,'name', 'current running processes');
    if ~isempty(o) %SUCCESS
        global mpw
        mpw.login =p.login;
        mpw.password=p.password;
    else
        clear global mpw
    end
    s.status=o;
    
    %% ===============================================
    
    
    t={};
    for i=1:size(o,1)
        t(i,:)= strsplit(o{i,:});
    end
    ht=t(1,:);
    t =t(2:end,:);
    
    ir=find(strcmp(t(:,find(strcmp(ht,'ST'))),'R')); %running Processes
    s.isrunning=ir;
    if ~isempty(ir)
        c_id  =find(strcmp(ht,'JOBID'));
        c_name=find(strcmp(ht,'NAME'));
        
        fe=cellfun(@(a,b){[ a '.e' b ]},t(ir,c_name) ,t(ir,c_id));
        fo=cellfun(@(a,b){[ a '.o' b ]},t(ir,c_name) ,t(ir,c_id));
        
        t2=sortrows([fo,fe],1);
        s.files=t2;
    else
        s.files='';
       % s.files=s.status;
    end
    
    
    
    
    return
end

if ~isempty(strfind(task,'cat'))
    %% ===============================================
    % cmd= [ 'cat ' t2{1,2} ]
    cmd=task;
    %cmd='squeue --me'
    o = ssh2_simple_command(p.HPC_hostname,p.login,p.password,cmd);
    % uhelp(o,1,'name', 'current running processes')
    if ~isempty(o)
        o=regexprep(o,char(27),' ');
       s.msg=o;
    else
        s.msg='';
    end
    %% =============================================== 
end

if ~isempty(strfind(task,'getfilesize'))
    %% ===============================================
    % cmd= [ 'cat ' t2{1,2} ]
    cmd=['wc -c ' arg] ;
    %cmd='squeue --me'
    o = ssh2_simple_command(p.HPC_hostname,p.login,p.password,cmd);
    % uhelp(o,1,'name', 'current running processes')
    if ~isempty(o)
        o=regexprep(o,char(27),' ');
       s.msg=o;
    else
        s.msg='';
    end
    %% =============================================== 
end


if strcmp(task,'cmd')
    %% ===============================================
    % cmd= [ 'cat ' t2{1,2} ]
    cmd=arg ;
    %cmd='squeue --me'
    o = ssh2_simple_command(p.HPC_hostname,p.login,p.password,cmd);
    % uhelp(o,1,'name', 'current running processes')
    if ~isempty(o)
        o=regexprep(o,char(27),' ');
       s.msg=o;
    else
        s.msg='';
    end
    %% =============================================== 
end