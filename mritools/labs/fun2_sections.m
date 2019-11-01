function fun2_sections(s,e,dum)

if exist('dum')==0
    dum=[];
end
if isempty(dum)
    
    
    fig2=findobj(0,'tag','Interactive');
    h=findobj(fig2,'style','popupmenu');
    run([regexprep(which('labs.m'),'labs.m','') 'labs_config']);
    [pa fi ext]=fileparts(brain);
    if isempty(pa)
        file=which([fi ext]);
        if isempty(file)
            file=fullfile([regexprep(which('spm.m'),'spm.m',''),'canonical'],[fi ext]);
            if exist(file)~=2
                file   = spm_select(1,'image','select image for rendering on');
            end
        end
    else
        file=fullfile(pa,[fi ext]) ;
    end
    
    % fil='C:\Dokumente und Einstellungen\skoch\Desktop\tpm\results\avg152PD.nii'
    xSPM=evalin('base','xSPM');
    hReg=evalin('base','hReg');
    spm_sections(xSPM,hReg,file);
    
    fig3=findobj(0,'Tag','Graphics');
    ch=findobj(fig3,'type','image','tag','Transverse');
    for i=1:length(ch)
        ax =get(ch(i),'parent');
        r=get(ax,'ButtonDownFcn');
        if size(r,1)<2
            set(ax,'ButtonDownFcn',{@fun2_sections,r});
        end
    end
else
    
    feval(dum);
    showbrodmann;
    
end

