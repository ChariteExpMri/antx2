
function h=struct2list3(z, p,structname)

% ----------
if isempty(p)
   p=repmat({''},1,4 ) ;
end
% ----------
% hh=[hh; struct2list(z)];
zz=struct2list(z);
ph=repmat({' '},[size(zz,1) 1]);%{};
spa=[];
%% ==========[get all fieldnames]=====================================

% fnames=fieldnames(z)
fnames=p(:,1);
%% ===============================================
infox={};
fnames2={};%multiple lines per parameter/fname
for i=1:length(fnames)
    %is=regexpi2(zz,['^z.' fnames{i}  ]);
    is=regexpi2(zz,['^z.' fnames{i} '[=\s]' ]); %debug: end with '=' or blank

    if isempty(is)
        try
        fnames2{is,1}='';
        end
    else
        fnames2{is,1}=fnames{i};
    end
end
%% ===============================================

for i=1:length(fnames2)
    ix=find(cellfun('isempty',regexpi(p(:,1),['^' fnames2{i} '$']))==0);
    if ~isempty(ix) & length(ix)==1
        ph{i,1}=['     % % ' p{ix,3}];
    else
        ph{i,1}=['       '         ];
    end
    % = sep
    is=strfind(zz{i},'=');
    if ~isempty(is)
        spa(i,1)=is(1);
    else
        spa(i,1)=nan;
    end
end

% z0=zz;
spaceadd=nanmax(spa)-spa;
for i=1:length(fnames2)
    if ~isnan(spaceadd(i))
        zz{i,1}= [ regexprep(zz{i} ,'=',[repmat(' ',1,1+spaceadd(i)) '= '],'once')  ];
    end
end

%% multicell cell - shift row containing multicell list
inan=find(isnan(spaceadd));
dum=zz;
for i=1:length(inan)
    
    row= inan(i);
    ispa=min(cell2mat(regexpi(dum(row-1),'=' )));
    if ~isempty(ispa)
        ispa2=ispa;
    end
    ival=min(regexpi(dum{row},'\S'));
    
    %dum=zz;
    dum{row ,1}=[repmat(' ',[1 ispa2-ival+4]) dum{row}];
    
end
zz=dum;



sizx=size(char(zz),2);
zz=cellfun(@(a,b) {[a repmat(' ' ,1,sizx-size(a,2)) b ]}, zz,ph);

% REMOVE [inv]-fields
iinf=regexpi2(zz,'^[A-z].inf\d+\s{0,1000}=');
zz(iinf)=[];

% rename struct
zz=regexprep(zz,'^z.' ,[structname '.']);
h=[ zz];