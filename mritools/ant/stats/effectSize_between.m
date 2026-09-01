function [d, dCI, g, gCI] = effectSize_between_v3(x, y, alpha)
% EFFECTSIZE_BETWEEN
%
% Cohen's d and Hedges' g for independent two-sample data.
%
% INPUT
%   x      : regions x subjects, group 1
%   y      : regions x subjects, group 2
%   alpha  : significance level for CI (default = 0.05)
%
% OUTPUT
%   d      : Cohen's d
%   dCI    : 95% CI for d, [lower upper]
%   g      : Hedges' g
%   gCI    : 95% CI for g, [lower upper]
%
% NaNs are ignored within each row.
%
% Cohen's d uses the pooled SD.
% CIs are calculated by inversion of the noncentral t distribution.
%
% MATLAB R2020b
% Statistics and Machine Learning Toolbox required.

if nargin < 3
    alpha = 0.05;
end

% ------------------------------------------------------------
% Check dimensions
% ------------------------------------------------------------

if size(x,1) ~= size(y,1)
    error('x and y must have the same number of rows (regions).');
end

% ------------------------------------------------------------
% Sample sizes
% ------------------------------------------------------------

n1 = sum(~isnan(x), 2);
n2 = sum(~isnan(y), 2);

% ------------------------------------------------------------
% Means and SDs
% ------------------------------------------------------------

m1 = mean(x, 2, 'omitnan');
m2 = mean(y, 2, 'omitnan');

s1 = std(x, 0, 2, 'omitnan');
s2 = std(y, 0, 2, 'omitnan');

% ------------------------------------------------------------
% Degrees of freedom
% ------------------------------------------------------------

df = n1 + n2 - 2;

% ------------------------------------------------------------
% Pooled standard deviation
% ------------------------------------------------------------

sp = sqrt(((n1-1).*s1.^2 + (n2-1).*s2.^2) ./ df);

% ------------------------------------------------------------
% Cohen's d
% ------------------------------------------------------------

d = (m1 - m2) ./ sp;

% ------------------------------------------------------------
% Hedges' correction factor
%
% Exact correction:
% J = gamma(df/2) / (sqrt(df/2)*gamma((df-1)/2))
%
% Approximation below is extremely accurate for normal sample
% sizes and avoids numerical gamma problems.
% ------------------------------------------------------------

J = 1 - 3 ./ (4.*df - 1);

g = J .* d;

% ------------------------------------------------------------
% Initialize CIs
% ------------------------------------------------------------

dCI = nan(numel(d), 2);
gCI = nan(numel(g), 2);

% ------------------------------------------------------------
% Valid rows
% ------------------------------------------------------------

valid = isfinite(d) & ...
        isfinite(df) & ...
        df > 0 & ...
        n1 >= 2 & ...
        n2 >= 2 & ...
        isfinite(sp) & ...
        sp > 0;

idx = find(valid);

% ------------------------------------------------------------
% Noncentral-t confidence intervals
% ------------------------------------------------------------

for ii = 1:numel(idx)

    k = idx(ii);

    tk  = d(k) * sqrt((n1(k)*n2(k))/(n1(k)+n2(k)));
    dfk = df(k);

    % --------------------------------------------------------
    % Find lower NCP
    %
    % F(t | ncp_low) = 1-alpha/2
    % --------------------------------------------------------

    fLow = @(ncp) nctcdf(tk, dfk, ncp) - (1-alpha/2);

    % --------------------------------------------------------
    % Find upper NCP
    %
    % F(t | ncp_high) = alpha/2
    % --------------------------------------------------------

    fHigh = @(ncp) nctcdf(tk, dfk, ncp) - alpha/2;

    % --------------------------------------------------------
    % Automatically find brackets
    % --------------------------------------------------------

    bound = 1;

    while fLow(-bound) * fLow(bound) > 0
        bound = bound * 2;
        if bound > 1e6
            error('Could not bracket lower NCP for region %d.', k);
        end
    end

    ncpLow = fzero(fLow, [-bound bound]);

    bound = 1;

    while fHigh(-bound) * fHigh(bound) > 0
        bound = bound * 2;
        if bound > 1e6
            error('Could not bracket upper NCP for region %d.', k);
        end
    end

    ncpHigh = fzero(fHigh, [-bound bound]);

    % --------------------------------------------------------
    % Convert noncentrality parameter to Cohen's d
    % --------------------------------------------------------

    scale = sqrt((n1(k)+n2(k))/(n1(k)*n2(k)));

    dCI(k,:) = [ncpLow ncpHigh] .* scale;
end

% ------------------------------------------------------------
% Hedges' g CI
% ------------------------------------------------------------

gCI = dCI .* J;

end