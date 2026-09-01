function [p, tObs] = permutation_ttest_within(x, y, nPerm, tail)

% PERMUTATION_TTEST_WITHIN
%
% Fast permutation test for paired / within-subject data.
%
% INPUT
%   x      : regions x animals, timepoint 1
%   y      : regions x animals, timepoint 2
%   nPerm  : number of permutations
%   tail   : 'both', 'left', or 'right'
%
% OUTPUT
%   p      : permutation p-values, one per region
%   tObs   : observed paired t-statistic
%
% NaNs are handled separately for each region.
%
% The permutation procedure randomly flips the sign of each
% subject's within-subject difference.
%
% Difference is defined as:
%
%       d = x - y
%
% Therefore:
%
%   'right' -> x > y
%   'left'  -> x < y
%   'both'  -> x ~= y
%
% Example:
%
%   [p,t] = permutation_ttest_within(x,y,5000,'both');


% ---------------------------------------------------------
% Check inputs
% ---------------------------------------------------------

if nargin < 3 || isempty(nPerm)
    nPerm = 5000;
end

if nargin < 4 || isempty(tail)
    tail = 'both';
end

tail = lower(tail);

if ~ismember(tail, {'both','left','right'})
    error('tail must be ''both'', ''left'', or ''right''.');
end

if ~isequal(size(x),size(y))
    error('x and y must have identical dimensions.');
end


% ---------------------------------------------------------
% Dimensions
% ---------------------------------------------------------

[nRegions,nSubjects] = size(x);


% ---------------------------------------------------------
% Within-subject differences
% ---------------------------------------------------------

d = x - y;


% ---------------------------------------------------------
% Observed paired t-statistic
% ---------------------------------------------------------

meanD = mean(d,2,'omitnan');
sdD   = std(d,0,2,'omitnan');

n = sum(~isnan(d),2);

tObs = meanD ./ (sdD ./ sqrt(n));

% Regions with insufficient data
invalid = (n < 2 | sdD == 0);

tObs(invalid) = NaN;


% ---------------------------------------------------------
% Permutation test
% ---------------------------------------------------------

countExtreme = zeros(nRegions,1);

% fprintf('Running %d permutations (%s-tailed)...\n', ...
%     nPerm,tail);

for k = 1:nPerm

    % -----------------------------------------------------
    % Randomly flip signs independently for each animal
    % -----------------------------------------------------

    signs = 2*(rand(1,nSubjects) > 0.5) - 1;

    dPerm = d .* signs;


    % -----------------------------------------------------
    % Paired t-statistic
    % -----------------------------------------------------

    meanPerm = mean(dPerm,2,'omitnan');
    sdPerm   = std(dPerm,0,2,'omitnan');

    tPerm = meanPerm ./ (sdPerm ./ sqrt(n));


    % -----------------------------------------------------
    % Tail-specific test
    % -----------------------------------------------------

    switch tail

        case 'both'
            extreme = abs(tPerm) >= abs(tObs);

        case 'right'
            extreme = tPerm >= tObs;

        case 'left'
            extreme = tPerm <= tObs;

    end

    % Don't count invalid regions
    extreme(invalid) = false;

    countExtreme = countExtreme + extreme;

end


% ---------------------------------------------------------
% Permutation p-values
% +1 correction prevents p = 0
% ---------------------------------------------------------

p = (countExtreme + 1) ./ (nPerm + 1);

p(invalid) = NaN;


% ---------------------------------------------------------
% Summary
% ---------------------------------------------------------

% fprintf('Finished.\n');
% fprintf('%d / %d regions have valid data.\n', ...
%     sum(~invalid),nRegions);
% 
% fprintf('%d / %d regions significant at p < 0.05.\n', ...
%     sum(p < 0.05),nRegions);

end