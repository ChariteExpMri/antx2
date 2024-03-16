
% make cell to text
% q2=cell2text({{'a' 'ab' 'c' } {'dd' 'ee' 'ff'} {'g' 'h' 'i'}})
% q2=cell2text({ magic(5)})
% q2=cell2text({{'a' 'ab' 'c' } magic(5)})
% q2=cell2text({ cellstr(ls)   cellstr(ls) })
function o=cell2text(c)

%% ===============================================











%% ===============================================
% ic=cellfun(@(a){[ ischar(a) ]} ,c )
% clear
% c={'aa' 'bb' 'c' 'd' ; 'e' 'f' 'g' 'h' };

% c={1:5  1  [1 2; 3 4] }

% c={ {'ee' 'www' [1:3] }  [1 2 3] 'w'}

% c={[1:3]}
% c={{'ww' 'sss' 'www' 12}'  [1]  1:4}
%
% c={'ww' 'sss' 'www'}


% c=num2cell(rand(1,3))


% Perform this operation and replace only the numberic values
d=c;
ic = cellfun(@ischar, d);
d(ic) = cellfun(@(a) ['''' a ''''],d(ic), 'UniformOutput', 0);

ic = cellfun(@isnumeric, d);
d(ic) = cellfun(@(a) [ mat2str(a)  ],d(ic), 'UniformOutput', 0);

ic = cellfun(@iscell, d);

% d(ic) =
% q=cellfun(@(a) ['{' a '}'],c(ic), 'UniformOutput', 0)
%% =============[char idential columns]==================================
% identical char
type_char=1000;
len=[];
len=[];
nchar=[];
err=0;
for i=1:size(d,1)
    for j=1:size(d,2)
        if ic(i,j)==1
            q=(cellfun(@(a) [ischar(a)  ],d{i,j}, 'UniformOutput', 0));
            type_char= min([type_char min(cell2mat(q)) ]);
            len=[len length(q)];
            nchar(i,j)=max((cellfun(@(a) [length(a)  ],d{i,j}, 'UniformOutput', 1)));
        else
            err=1;
        end
    end
end
sameLength=length(unique(len));
if isempty(sameLength); sameLength=0; end



if type_char==1 && sameLength==1  && min(size(d))==1 && err==0
    
    d2={};
    for i=1:length(d)
        d2(:,i)   =   cellfun(@(a) [ mat2str(a) repmat(' ' ,[1 nchar(i)-length(a) ])   ],d{i}, 'UniformOutput', 0);
    end
    %d2
    d3={};
    for i=1:size(d2,1)
        d3(end+1,:)={strjoin(d2(i,:),'  ')};
    end
    %d3
    d=d3;
else
    
    %% ======[mix]=========================================
    
    
    w=[];
    for j=1:size(ic,1)
        for i=1:size(ic,2)
            if ic(j,i)==1
                %w=d{ic(j,i)};
                w=d{j,i};
                w2={} ;
                
                u = cellfun(@ischar, w,'UniformOutput', 0)  ;
                u=cell2mat(u);
                q=cellfun(@(a) ['''' a ''''],w(u), 'UniformOutput', 0);
                %q=[ '{' strjoin(q,' ') '}']
                if size(u,2)==1
                    w2(u,1)=q  ;
                else
                    w2(u)=q;
                end
                
                
                u2 = cellfun(@isnumeric, w,'UniformOutput', 0);
                u2=cell2mat(u2);
                q = cellfun(@(a) [ mat2str(a)  ],w(u2), 'UniformOutput', 0);
                w2(u2)=q;
                
                if size(w2,1)==1
                    w3=['{' strjoin(w2,' ') '}'];
                    %d{ic(j,i)} =w3;
                    d{j,i} =w3;
                else
                    w3='{';
                    for k=1:size(w2,1)
                        if k==1
                            w3=[w3  ' ' strjoin(w2(k,:),' ')  ];
                            
                        else
                            w3=[w3 '  ' strjoin(w2(k,:),' ')  ] ;
                        end
                        if k<size(w2,1)  w3=[w3  char(10)  ]; end
                    end
                    w3=[w3 '    }'];
                    %d{ic(j,i)}=w3 ;
                    d{j,i} =w3;
                end
                
                
                
            end
        end
    end
end
%% ===============================================

% o=['{'  strjoin(d,' ')  '}'];
r='{';
for i=1:size(d,1)
    for j=1:size(d,2)
        if i==1 && j==1
            r= [r '' d{i,j}];
        elseif j==1
            r= [r ' ' d{i,j}];
        else
            r= [r ' , ' d{i,j}];
        end
        if size(d,1)>1
            % r=[r ';'];
            r=[r char(10)];
        end
    end
end
% r=cellfun(@(a) {[ ' ' r  ]},r);
r=[r  ' }' ];
o=r;
%% ===============================================

% disp('---out_____');
% disp(o);



%% ===============================================
return
c={'sss' 'ww' 'wq' 'qw'};

c={'aa' 'bb' 'c' 'd' ; 'e' 'f' 'g' 'h'};

v={};
for j=1:size(c,1)
    r='';
    for i=1:size(c,2)
        if ischar(c{j,i})
            r= [r ' '  '''' c{j,i}  ''''];
            
        end
    end
    v(end+1,:)={r};
end


disp('------------');
disp(v);
