function [d, dCI, g, gCI] = effectSize_dg(x, y, alpha, design)

% EFFECTSIZE_V4
%
% Cohen's d and Hedges' g for independent or paired data.
%
% INPUT
%   x       : regions x subjects, group/timepoint 1
%   y       : regions x subjects, group/timepoint 2
%   alpha   : significance level for CI (default = 0.05)
%   design  : 'between' or 'within' (default = 'between')
%
% OUTPUT
%   d       : Cohen's d
%             - between: pooled-SD Cohen's d
%             - within : paired-samples d_z
%
%   dCI     : CI for d, [lower upper]
%
%   g       : Hedges' g
%             - between: Hedges' g
%             - within : Hedges' g_z
%
%   gCI     : CI for g, [lower upper]
%
% NaNs are ignored.
%
% MATLAB R2020b
% Statistics and Machine Learning Toolbox required.

% ------------------------------------------------------------
% Defaults
% ------------------------------------------------------------

if nargin < 3 || isempty(alpha)
    alpha = 0.05;
end

if nargin < 4 || isempty(design)
    design = 'between';
end

design = lower(design);

if ~ismember(design, {'between','within'})
    error('design must be ''between'' or ''within''.');
end

% ------------------------------------------------------------
% Check dimensions
% ------------------------------------------------------------

if ~isequal(size(x), size(y))
    error('x and y must have identical dimensions.');
end

% ------------------------------------------------------------
% Initialize
% ------------------------------------------------------------

nRegions = size(x,1);

d   = nan(nRegions,1);
g   = nan(nRegions,1);
dCI = nan(nRegions,2);
gCI = nan(nRegions,2);

% ============================================================
% BETWEEN-SUBJECT DESIGN
% ============================================================

if strcmp(design,'between')

    % --------------------------------------------------------
    % Sample sizes
    % --------------------------------------------------------

    n1 = sum(~isnan(x), 2);
    n2 = sum(~isnan(y), 2);

    % --------------------------------------------------------
    % Means and SDs
    % --------------------------------------------------------

    m1 = mean(x, 2, 'omitnan');
    m2 = mean(y, 2, 'omitnan');

    s1 = std(x, 0, 2, 'omitnan');
    s2 = std(y, 0, 2, 'omitnan');

    % --------------------------------------------------------
    % Pooled SD
    % --------------------------------------------------------

    df = n1 + n2 - 2;

    sp = sqrt(((n1-1).*s1.^2 + ...
               (n2-1).*s2.^2) ./ df);

    % --------------------------------------------------------
    % Cohen's d
    % --------------------------------------------------------

    d = (m1 - m2) ./ sp;

    % --------------------------------------------------------
    % Hedges' correction
    % --------------------------------------------------------

    J = 1 - 3 ./ (4.*df - 1);

    g = J .* d;

    % --------------------------------------------------------
    % Valid rows
    % --------------------------------------------------------

    valid = isfinite(d) & ...
            isfinite(df) & ...
            df > 0 & ...
            n1 >= 2 & ...
            n2 >= 2 & ...
            isfinite(sp) & ...
            sp > 0;

    idx = find(valid);

    % --------------------------------------------------------
    % CI via noncentral t
    % --------------------------------------------------------

    for ii = 1:numel(idx)

        k = idx(ii);

        % Observed t corresponding to Cohen's d
        tk = d(k) * sqrt((n1(k)*n2(k)) / ...
                         (n1(k)+n2(k)));

        dfk = df(k);

        % ----------------------------------------------------
        % Lower NCP
        % ----------------------------------------------------

        fLow = @(ncp) ...
            nctcdf(tk, dfk, ncp) - (1-alpha/2);

        bound = 1;

        while fLow(-bound) * fLow(bound) > 0

            bound = bound * 2;

            if bound > 1e6
                error('Could not bracket lower NCP for region %d.',k);
            end

        end

        ncpLow = fzero(fLow,[-bound bound]);

        % ----------------------------------------------------
        % Upper NCP
        % ----------------------------------------------------

        fHigh = @(ncp) ...
            nctcdf(tk, dfk, ncp) - alpha/2;

        bound = 1;

        while fHigh(-bound) * fHigh(bound) > 0

            bound = bound * 2;

            if bound > 1e6
                error('Could not bracket upper NCP for region %d.',k);
            end

        end

        ncpHigh = fzero(fHigh,[-bound bound]);

        % ----------------------------------------------------
        % Convert NCP -> Cohen's d
        % ----------------------------------------------------

        scale = sqrt((n1(k)+n2(k)) / ...
                     (n1(k)*n2(k)));

        dCI(k,:) = [ncpLow ncpHigh] .* scale;

    end

    % Hedges' g CI
    gCI = dCI .* J;

% ============================================================
% WITHIN-SUBJECT / PAIRED DESIGN
% ============================================================

elseif strcmp(design,'within')

    % --------------------------------------------------------
    % Paired differences
    %
    % IMPORTANT:
    % x and y must have matching subjects in matching columns.
    % --------------------------------------------------------

    diffXY = x - y;

    % Number of complete pairs
    n = sum(~isnan(diffXY), 2);

    % --------------------------------------------------------
    % Mean and SD of paired differences
    % --------------------------------------------------------

    meanD = mean(diffXY, 2, 'omitnan');
    sdD   = std(diffXY, 0, 2, 'omitnan');

    % --------------------------------------------------------
    % Cohen's d_z
    %
    % d_z = mean difference / SD of differences
    % --------------------------------------------------------

    d = meanD ./ sdD;

    % --------------------------------------------------------
    % Degrees of freedom
    % --------------------------------------------------------

    df = n - 1;

    % --------------------------------------------------------
    % Hedges' correction
    % --------------------------------------------------------

    J = 1 - 3 ./ (4.*df - 1);

    g = J .* d;

    % --------------------------------------------------------
    % Valid rows
    % --------------------------------------------------------

    valid = isfinite(d) & ...
            isfinite(df) & ...
            df > 0 & ...
            n >= 2 & ...
            isfinite(sdD) & ...
            sdD > 0;

    idx = find(valid);

    % --------------------------------------------------------
    % CI via noncentral t
    %
    % For paired data:
    %
    %       t = d_z * sqrt(n)
    %
    % therefore:
    %
    %       d_z = NCP / sqrt(n)
    % --------------------------------------------------------

    for ii = 1:numel(idx)

        k = idx(ii);

        % Observed t
        tk = d(k) * sqrt(n(k));

        dfk = df(k);

        % ----------------------------------------------------
        % Lower NCP
        % ----------------------------------------------------

        fLow = @(ncp) ...
            nctcdf(tk, dfk, ncp) - (1-alpha/2);

        bound = 1;

        while fLow(-bound) * fLow(bound) > 0

            bound = bound * 2;

            if bound > 1e6
                error('Could not bracket lower NCP for region %d.',k);
            end

        end

        ncpLow = fzero(fLow,[-bound bound]);

        % ----------------------------------------------------
        % Upper NCP
        % ----------------------------------------------------

        fHigh = @(ncp) ...
            nctcdf(tk, dfk, ncp) - alpha/2;

        bound = 1;

        while fHigh(-bound) * fHigh(bound) > 0

            bound = bound * 2;

            if bound > 1e6
                error('Could not bracket upper NCP for region %d.',k);
            end

        end

        ncpHigh = fzero(fHigh,[-bound bound]);

        % ----------------------------------------------------
        % Convert NCP -> Cohen's d_z
        % ----------------------------------------------------

        scale = 1 / sqrt(n(k));

        dCI(k,:) = [ncpLow ncpHigh] .* scale;

    end

    % Hedges' g_z CI
    gCI = dCI .* J;

end

end