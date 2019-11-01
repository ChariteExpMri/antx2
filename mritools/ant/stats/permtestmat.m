function [p] = permtest(x,y,nperm,method)
% for MATRICes, each column is another variable
%    w1=[rand(10,3)]
%    w2=rand(size(w1)); 
%    w2(1:3,1)=nan
%    w2(:,2)=w1(:,1)+5
%    permtestmat(w1,w2,1000,'approximate')
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
% Performes a simple permutation test of the difference in means.
% method:
%   - 'conservative': p-value is calculated by
%   (abs(nPerm)>=abs(testVal)+1)/(nPerm+1)
%
%   - 'exact': p-value is calculated by:
%        Phipson & Smyth 2010 Formula (1)
%
%   - 'approximate': p-value is calculated by:
%        Phipson & Smyth 2010 Formula (2)
%
%   - 'auto': depending on number of possible permutationes (<10000) exakt
%   or (>10000) approximate is used. (default)
%
% Generally 'auto' is a good solution. If speed is a concern, 'conservative'
% is the fastest. It gives conservative (i.e. slightly too large) p-values
% depending on the number of trials in the groups. Above 50 trials per
% group there should not be any difference anymore. See the paper for more
% information.
%
%
% Phipson & Smyth 2010:
% Permutation P-values Should Never Be Zero:Calculating Exact P-values When
% Permutations Are Randomly Drawn
%
% http://www.statsci.org/webguide/smyth/pubs/permp.pdf
% some code taken from the statmod R package (
% tested:
% p0=nan(1,10);
% for k = 1:1000;
%     p0(k)=permtest(rand(100,1),rand(50,1));
% end
% histogram(p0,30) %<- histogram is flat



if 0
    
   w1=[rand(10,3)]
   w2=rand(size(w1)); 
   w2(1:3,1)=nan
   w2(:,2)=w1(:,1)+5
%     permtestmat(w1,w2,1000,'approximate')
    
end
%••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••

if nargin<3 || isempty(nperm)
    nperm = 1000;
end
if nargin <4
    method = 'auto';
end

if ~any(strcmp(method,{'auto','approximate','conservative','exact'}))
    error('unknown method')
end
% x = x(:);
% y = y(:);

si1=size(x);
si2=size(y);
if find(si1==1)==1;     x=x'; end
if find(si2==1)==1;     y=y'; end

z = [x;y];


n1 = size(x,1);
n2 = size(y,1);

testValue = nanmean(x,1)-nanmean(y,1);
% testValue = testValue./nanstd([x; y],[],1);

%taken from "Andrei Bobrov' http://de.mathworks.com/matlabcentral/answers/155207-matrix-with-different-randperm-rows
[~, idx] = sort(rand(nperm,n1+n2),2);

permDist0=zeros(nperm,size(x,2));
for i=1:size(idx,1)
    x_p = z(idx(i,1:n1),:);
    y_p = z(idx(i,n1+1:end),:);
    permDist0(i,:) = nanmean(x_p,1) - nanmean(y_p,1);
%     permDist0(i,:) = permDist0(i,:)./nanstd([x_p; y_p],[],1);
end


%Phibson 2010 Permutation P-values should never be zero: calculating exact P - NCBI
testValue2=repmat(testValue,[nperm 1]);
b = sum(abs(permDist0)>=abs(testValue2),1);
p_t = (b+1)/(nperm+1);


if strcmp(method, 'conservative')
    p = p_t;
    return
end
% sometimes with large n1/n2 there is a warning that mt is inaccurate. In
% this case, the correction doesnt do much anyways.
warning off
mt = nchoosek(n1+n2,n1); %total number of possible permutations
warning on
if n1 == n2
    mt = mt/2; % not sure why this is but its in the R-Code
end



if strcmp(method,'auto')
    if mt<10000
        method = 'exact';
    else
        method = 'approximate';
    end
end

if strcmp(method,'approximate')
    tic
    p=zeros(size(x,2),1);
    for i=1:size(x,2)
        b2 =b(i);
        p_t2=p_t(i);
        fun = @(p_t2)binocdf(b2,nperm,p_t2);
        p(i) = p_t2 - integral(fun,0,0.5/(mt+1));
    end
    toc
    
elseif strcmp(method,'exact')
    pv = (1:mt)./mt;
     p=zeros(size(x,2),1);
    for i=1:size(x,2)
        b2=b(i);
        x2 = repmat(b2,1,mt);
        p(i) = sum(binocdf(x2,nperm,pv))/(mt+1);
    end
    
else
    warning('could not find chosen method')
end