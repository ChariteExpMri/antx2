function [w hist]=printmatrix2(X,  dec, spacer, hist,title);


% [s h]=printmatrix2({subj lab dum },3,2,h,'Table-1199'); char(s) %dec=3; spacer=2; h=historystruct to append
% [s h]=printmatrix2({'' lab dum },3,2,h,'Table-1199');char(s)
% [s h]=printmatrix2({subj '' dum },3,2,h,'Table-1199');char(s)
if  exist('hist')~=1 ;     hist={''}; end
if  exist('dec')~=1 ;      dec=3; end
if  exist('spacer')~=1 ;   spacer=4; end
if  exist('title')~=1 ;   title='';else; title=['••• ' title ' •••'] ;end

if iscell(X)
    if size(X,2)==3
        down= X{1};
        labs= X{2};
        X= X{3};
        if isempty(down); down=repmat({' '},[size(X,1)             1] ),end
        if isempty(labs); labs=repmat({' '},[1            size(X,2) ] ), islabs=0;else; islabs=1; end
    else
        w=X;
        hist{end+1,1} =sprintf('\n');
        hist=[hist; w ];
        return

    end
end



[N,M]=size(X);
% try
ff = ceil(log10(max(max(abs(X)))))+dec+3;
% catch
%     ff=6;
%     X=char(X);
% end
e=[' ' labs(:)'];
e=[e; down num2cell(X)];
[N,M]=size(e);

for i=1:N
    d1='';
    for j=1:M
        if ischar(e{i,j})
            e{i,j} =[   sprintf(['%#',num2str(ff-dec-1), 's '],e{i,j}) ];
        else
            if round(e{i,j})==e{i,j}
                e{i,j} =[   sprintf(['%#',num2str(ff-dec-1), 'd '],e{i,j}) ];
            else
                e{i,j} =[   sprintf(['%#',num2str(ff),'.',num2str(dec),'f '],e{i,j}) ];
            end
        end
    end
end


for i=1:M;
    si=size(char(e(:,i)),2)+spacer;
    for j=1:N
        if length(e{j,i})~=si
            sic=(si-length(e{j,i}))/2 ;

            e{j,i}= [repmat(' ',[1  floor(sic)])    e{j,i}   repmat(' ',[1  ceil(sic)])  ];
        end
    end
end

s={};
for i=1:N
    d1='';
    for j=1:M
        d1=[d1 e{i,j}];
    end
    s{end+1,1} = d1;
end

rep1={repmat( '¯'  ,[1 size(s{1,:},2)])};
rep2={repmat( '_'  ,[1 size(s{1,:},2)])};
rep3={regexprep(s{1,:},'\S','¯')};

sizt=(size(s{1,:},2)-length(title))/2;
title2={    [repmat(' ',[1  floor(sizt)])    upper(title)  repmat(' ',[1  ceil(sizt)])  ]   };

if isempty(title); title2='' ;end
if islabs==1
    w=[rep2; title2 ; s(1,:);rep2 ;  ;s(2:end,:) ;rep1];
else
    w=[rep2; title2 ;rep2 ;  ;s(2:end,:) ;rep1];
end
% char(w)
% pwrite2file('mist4.txt',w)


hist{end+1,1} =sprintf('\n');
hist=[hist; w ];

% fprintf('\n');
% for i=1:N,
%     fprintf(['%#',num2str(ff),'.',num2str(dec),'f\t'],X(i,:));
%     fprintf('\n');
% end

