
function ovl( v1,v2, interpx, name2write,infos )

if ~exist('name2write','var')
    name2write='ztest';
end

num=length(dir([  name2write '*.txt']));
if isempty(num)
name=[  name2write '1' '.txt'] ;%'ztest1'
else
% name=['ztest' num2str(num+1)]
name=[  name2write num2str(num+1)  '.txt'] ;%'ztest1'
end




% gifoverlay('testsample_orient_s20150908_FK_C1M01_1_3_1.nii',...
%             'WAR1_pRWHS_0.6.1_Labels.nii',name,'-r300')

if ~exist('interpx');     interpx=1; end


gifoverlay(v1,...
           v2,name,'-r300',interpx)  ;      
delete('vv1.jpg');delete('vv2.jpg');


try
    %%     ##1
    %     job_id = spm_jobman('interactive',m)
    %%     ##2
    %     char(gencode(m)')
    %%     ##3
    % ha=findobj(0,'tag','module');
    % str=((get(ha,'string')))
    %%     ##4
    if exist('infos')
        if iscell(infos)
            str2=(gencode(infos)');
        else
            str2=infos;
        end
            % str2=regexprep(str,'       ','')
            %str2=char(regexprep(str,'          ','_'))
            pwrite2file([strrep(name,'.txt','') '.txt'],str2)
        end
    end
end