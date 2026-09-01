function [p, q, h, tObs] = permutation_ttest_between(x, y, nPerm, alpha, tail)

% PERMUTATION_TTEST_FDR
%
% Permutation-based Welch two-sample t-test for multiple regions,
% followed by Benjamini-Hochberg FDR correction.
%
% NaNs are ignored within each group and region.
%
% INPUT
%   x      : regions x subjects, group 1
%   y      : regions x subjects, group 2
%   nPerm  : number of permutations (default = 5000)
%   alpha  : FDR significance level (default = 0.05)
%   tail   : alternative hypothesis:
%            'both'  -> mean(x) ~= mean(y)
%            'right' -> mean(x) > mean(y)
%            'left'  -> mean(x) < mean(y)
%            (default = 'both')
%
% OUTPUT
%   p      : permutation p-values
%   q      : FDR-adjusted p-values
%   h      : significance mask after FDR correction
%   tObs   : observed Welch t-statistic
%
% Example:
%
%   [p,q,h,t] = permutation_ttest_fdr(x,y,5000,0.05,'both');
%
%   [p,q,h,t] = permutation_ttest_fdr(x,y,5000,0.05,'right');
%
%   [p,q,h,t] = permutation_ttest_fdr(x,y,5000,0.05,'left');


% ---------------------------------------------------------
% Defaults
% ---------------------------------------------------------

if nargin < 3 || isempty(nPerm)
    nPerm = 5000;
end

if nargin < 4 || isempty(alpha)
    alpha = 0.05;
end

if nargin < 5 || isempty(tail)
    tail = 'both';
end

% Convert to lower case
tail = lower(tail);

% Check tail
if ~ismember(tail, {'both','left','right'})
    error('tail must be ''both'', ''left'', or ''right''.');
end


% ---------------------------------------------------------
% Check dimensions
% ---------------------------------------------------------

[nRegions, nX] = size(x);
[nRegionsY, nY] = size(y);

if nRegions ~= nRegionsY
    error('x and y must have the same number of regions.');
end


% ---------------------------------------------------------
% Pool data
% ---------------------------------------------------------

data = [x y];

nTotal = nX + nY;


% ---------------------------------------------------------
% Observed Welch t-statistic
% ---------------------------------------------------------

mx = mean(x,2,'omitnan');
my = mean(y,2,'omitnan');

vx = var(x,0,2,'omitnan');
vy = var(y,0,2,'omitnan');

nx = sum(~isnan(x),2);
ny = sum(~isnan(y),2);

tObs = (mx - my) ./ sqrt(vx./nx + vy./ny);

% Regions with insufficient data
invalid = (nx < 2 | ny < 2);

tObs(invalid) = NaN;


% ---------------------------------------------------------
% Permutation test
% ---------------------------------------------------------

countExtreme = zeros(nRegions,1);

% fprintf('Running %d permutations (%s-tailed)...\n',     nPerm, tail);

for k = 1:nPerm

    % Randomly permute animal labels
    idx = randperm(nTotal);

    % Permuted groups
    xPerm = data(:,idx(1:nX));
    yPerm = data(:,idx(nX+1:end));

    % Means
    mxPerm = mean(xPerm,2,'omitnan');
    myPerm = mean(yPerm,2,'omitnan');

    % Variances
    vxPerm = var(xPerm,0,2,'omitnan');
    vyPerm = var(yPerm,0,2,'omitnan');

    % Number of observations
    nxPerm = sum(~isnan(xPerm),2);
    nyPerm = sum(~isnan(yPerm),2);

    % Welch t-statistic
    tPerm = (mxPerm - myPerm) ./ ...
        sqrt(vxPerm./nxPerm + vyPerm./nyPerm);

    % Invalid regions
    tPerm(nxPerm < 2 | nyPerm < 2) = NaN;


    % -----------------------------------------------------
    % Tail-specific permutation test
    % -----------------------------------------------------

    switch tail

        case 'both'

            extreme = abs(tPerm) >= abs(tObs);

        case 'right'

            extreme = tPerm >= tObs;

        case 'left'

            extreme = tPerm <= tObs;

    end

    % Count extreme permutations
    countExtreme = countExtreme + extreme;

end


% ---------------------------------------------------------
% Permutation p-values
% +1 correction prevents p = 0
% ---------------------------------------------------------

p = (countExtreme + 1) ./ (nPerm + 1);

p(invalid) = NaN;


% ---------------------------------------------------------
% Benjamini-Hochberg FDR
% ---------------------------------------------------------

valid = ~isnan(p);

pValid = p(valid);

[pSorted, sortIdx] = sort(pValid);

m = length(pSorted);

qSorted = pSorted .* m ./ (1:m)';

% Enforce monotonicity
qSorted = flipud(cummin(flipud(qSorted)));

% Put q-values back into original region order
q = NaN(size(p));

tmp = NaN(size(pValid));

tmp(sortIdx) = min(qSorted,1);

q(valid) = tmp;


% ---------------------------------------------------------
% FDR significance
% ---------------------------------------------------------

h = false(nRegions,1);

h(valid) = q(valid) < alpha;


% ---------------------------------------------------------
% Summary
% ---------------------------------------------------------
% 
% fprintf('Finished.\n');
% fprintf('%d / %d regions significant after FDR (q < %.3f).\n', ...
%     sum(h), nRegions, alpha);

