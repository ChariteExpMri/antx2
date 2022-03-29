

%concatenate nested structs (issue with "catstruct")
% [k k2]=catstruct2(a,b)
% a & b are structs
% b-struct is the update of a-struct, i.e fields of a-struct are overwritten or newly created by fields of b-struct 
% [k]: output-struct
% [k2]: output-list (cell-array)
%% ==========[example]=====================================
%     a.a1='a1'
%     a.wa.arg1='arg1'
%     a.wa.arg2='arg2'
%     a.wa.arg3='arg3'
%     a.x.x.x.x1='klaus'
%     a.x.x.x.y1='klaus1'
% 
%     b.a1='a2'            %overwrites 'a1'
%     b.wa.arg2='arg20'    %overwrites 'arg2'
%     b.wa.arg3='arg30'    %overwrites 'arg3'
%     b.x.x.x.x1='peter'   %overwrites 'klaus1'
%     b.x.x.x.y2='peter1'  %will be a new field
%     [k k2]=catstruct2(a,b)
% 
%% ===============================================

function [k k2]=catstruct2(a,b)

% if 0
%     a.a1='a1'
%     a.wa.arg1='arg1'
%     a.wa.arg2='arg2'
%     a.wa.arg3='arg3'
%     a.x.x.x.x1='klaus'
%     a.x.x.x.y1='klaus1'
%     
%     b.a1='a2'            %overwrites 'a1'
%     b.wa.arg2='arg20'    %overwrites 'arg2'
%     b.wa.arg3='arg30'    %overwrites 'arg3'
%     b.x.x.x.x1='peter'   %overwrites 'klaus1'
%     b.x.x.x.y2='peter1'  %will be a new field
%     [k k2]=catstruct2(a,b)
% end


%% ===============================================
% clc
as=struct2list(a);
bs=struct2list(b);

as=regexprep(as,'^a\.','');
bs=regexprep(bs,'^b\.','');

av=regexprep(as,'=.*','');
bv=regexprep(bs,'=.*','');
av=regexprep(av,'\s+','');
bv=regexprep(bv,'\s+','');
%% ===============================================


% inonvar=regexpi2(av,'^''')
% ivar=setdiff(1:length(av),inonvar)
c=as;
for i=1:size(bv,1)
    is=find(strcmp(av,bv{i}));
    if ~isempty(is) %replace
        c{is}=bs{i};
    else %add
        c{end+1,1}=bs{i};
    end
end
%% =====equal sign==========================================
varc=[];
for i=1:length(c)
    ise=min(strfind(c{i},'='));
    iss=min(strfind(c{i},'%')); %comment sign
    iss2=min(strfind(c{i},' ')); %space before
    iss=min([iss iss2]);
    if ~isempty(ise)
        if isempty(iss) || ise<iss
           varc(i,1)=i; 
        end
    end
end
varc=(varc(find(varc)));
%% ===============================================
s=c;
s(varc)=cellfun(@(a){[ 'k.' a]} ,c(varc));
eval(strjoin(s,char(10)));

k2=struct2list(k);
%% ===============================================


