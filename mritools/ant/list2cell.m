


function c=list2cell(t,p)

% fn=fieldnames(x)
% t={}
% n=1;
% for i=1:length(fn)
%      xx=getfield(x,fn{i})
%    if ~isstruct(xx)
%        t{n,1}=fn{i}
%        t{n,2}=)=''
%        n=n+1
%    else
%
%
%    end
% end

% t=char(txt);
% t=m

eval(t);

sp=[1 strfind(t,char(10)) length(t)];
t2={};
for i=1:length(sp)-1
    dum=t(sp(i):sp(i+1));
    t2{end+1,1}=strrep(dum,char(10),'');
end

%% get fieldnames

t3={};
n=1;
space=0;
for i=1:size(t2,1)
    if isempty(t2{i})
        continue
    end
    if strfind(t2{i},'% ')==1 %commment
        if i>1
            if isempty(t2{i-1})
                space=1;
            else
                space=0;
            end
        end
        if space ==0
            t3(n,2) ={t2{i}(3:end)};
            n=n+1;
        else
            t3(n,2) ={t2{i}(1:end)};
            n=n+1;
        end
    else
        eq= (strfind(t2{i},'='));
        ec= (strfind(t2{i},'%'));
        if ~isempty(eq)
            if isempty(ec); ec=inf; end
            if eq(1)<ec
                t3(n,1)={t2{i}(1:eq(1)-1)};
                n=n+1;
            end
        end
    end
end


%% set variable
for i=1:size(t3,1)
      if ~isempty(t3{i,1} )
        eval(['dum=' t3{i,1} ';']);
  
        t3{i,2}=dum;
            t3{i,2}=dum;
      end
    
end

%% set coment-varname
empt=find(cellfun('isempty',t3(:,1)));
emptref=regexpi2(p(:,1),'inf\d');

for i=1:length(empt)
    id=regexpi2( regexprep(p(emptref,2),'\s','')  ,regexprep(t3{empt(i),2},'\s','')  );
    t3{empt(i),1}=p{emptref(id),1};
end



%% set comments (3rd colum)

for i=1:size(t3,1)
   id=regexpi2( regexprep(p(:,1),'^\s*x.',''),   regexprep(t3{i,1},'^\s*x.',''));
   if ~isempty(id)
    t3{i,3}=p{i,3};
     t3{i,4}=p{i,4};
   else
       t3{i,3}='';
     t3{i,4}='';  
   end
end


%% remove( x.)
fn=regexprep(t3(:,1),'^\s*x.','');
c=[fn t3(:,2:end)];




