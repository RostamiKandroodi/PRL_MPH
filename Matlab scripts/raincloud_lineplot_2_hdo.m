%% works, part
% edited by Mojtaba Rostami Kandroodi 13 May 2019
function h = raincloud_lineplot_2_hdo(X, clz, rot, cthru,xticks)

Xsize = size(X);
X_old = X;
X = reshape(X,numel(X),1);
tmpclz = vertcat(clz{:}); 

if ~exist('cthru', 'var')
    cthru = 0;
end

if ~exist('xticks','var')
xticks = {1:length(X)};
end

% MarkerSize = 8;       % Rain Drop sizes
RandScale = -0.02;   % Rain drop jitters vertically

% calculate densities
for i = 1:length(X)
    [f{i}, xi{i}] = ksdensity(X{i});
%     [f{i}, xi{i}] = ksdensity(X{i},0:0.001:1);
end

% use density heights to determine spacing between plots
% spacing     = 1.4 * max(cellfun(@max,f));
spacing     = 1.8 * max(cellfun(@max,f));
% spacing     = 2 * max(cellfun(@max,f));

baselinetmp    = spacing .* (-0.5 + 1:Xsize(1));
baseline = repmat(baselinetmp,1,Xsize(2));

if Xsize(2)==2
    baselineDrops = [baselinetmp-spacing/16, baselinetmp+spacing/16];
else % pull apart the scatterplots a little bit, works for 2d plots
  baselineDrops = baseline;
end

% also determines width of 1-d scatter cloud (raindrops)
jitwidth    = spacing / 10;

nax = 1;
% plot density plots
for i = 1:length(X)
    ax(nax)                     = axes;
    h.a(i)                      = area(xi{i}, -f{i} + baseline(i), baseline(i));
    h.a(i).FaceColor            = tmpclz(i,:);
    if cthru
        h.a(i).FaceAlpha        = 1;
    end
    h.a(i).LineStyle            = 'none';
    h.a(i).BaseLine.LineStyle   = 'none';
    if i ~= 1
        axis off
    end
    % figure out orientation (horiz/vert)
    if rot
        view([90 -90]);
    else
        set(ax(nax), 'Ydir', 'reverse');
    end
    nax = nax + 1;
end

% raindrops
for i = 1:length(X)
%     nax                     = length(X) + i;
    npts                    = length(X{i});
    jit                     = -(jitwidth / 2) + (rand(1, npts) * jitwidth);
    ax(nax)                 = axes;
    tmp                     = repmat(baselineDrops(i) + (spacing / 5), 1, npts);
    vjit                    = RandScale * sign(X{i} - 0.5) .* rand(size(X{i})); % Vertival jit, good for discontinuous values
    h.s(i)                  = scatter(X{i} + vjit, tmp + jit);
%     h.s(i)                  = scatter(X{i}, tmp + jit);
    h.s(i).MarkerFaceColor  = tmpclz(i,:);
    h.s(i).MarkerEdgeColor  = 'k';
    h.s(i).MarkerEdgeAlpha  = 0;
    h.s(i).MarkerFaceAlpha  = 0.7;
    axis off
    % figure out orientation (horiz/vert)
    if rot
        view([90 -90]);
    else
        set( ax(nax), 'Ydir', 'reverse');
    end
    nax = nax + 1;
end

% condition means will determine big dots and line
mnz = cellfun(@mean, X_old);

% lines
for i=1:Xsize(2)
    baseline_tmp        = reshape(baseline, Xsize(1), Xsize(2));
    ax(nax)             = axes;
    h.ln                = plot(mnz(:,i), baseline_tmp(:,i));
    h.ln.Color          = mean(clz{i});
    h.ln.LineWidth      = 4;
    axis off
    % figure out orientation (horiz/vert)
    if rot
        view([90 -90]);
    else
        set( ax(nax), 'Ydir', 'reverse');
    end
    nax = nax + 1;
end

% 95% bootstrapped confidence intervals, as lines
for i = 1:length(X)
    ci(:,i) = bootci(1000,@mean,X{i});
    ax(nax)                 = axes;
    h.ci(i)                 = line([ci(i) ci(i)], [baseline(i) baseline(i)] );
    axis off
    if rot
        view([90 -90]);
    else
        set( ax(nax), 'Ydir', 'reverse');
    end
    nax = nax + 1;
end

% mean dots plus SEM
for i = 1:length(X)
    ax(nax)                 = axes;
    
    stdev = std(X{i}); 
    sem = stdev/sqrt(length(X{i}));
      h.l(i) = plot([mnz(i)-sem mnz(i)+sem],[baseline(i) baseline(i)],'k-','LineWidth',2);
   hold on
   h.m(i)                  = scatter(mnz(i), baseline(i), 100);
    h.m(i).MarkerFaceColor  = tmpclz(i,:);
    h.m(i).MarkerEdgeColor  = 'k';
    
    axis off   
    hold off
    % figure out orientation (horiz/vert)
    if rot
        view([90 -90]);
    else
        set( ax(nax), 'Ydir', 'reverse');
    end
    nax = nax+1;
end

limits = cell2mat(get(ax, 'YLim'));

% link all the axes together
linkaxes(ax);

% adjust size so everything is in the picture
% (note: this sometimes trims the top of the first density plot)
set(gca,'YLim',[min(limits(:,1)) baseline(end) + spacing / 2])

% replace meaningless values on X-axis with something more sensible
set(ax, 'YTick', baseline(1:Xsize(1)));
set(ax, 'YTickLabel', xticks);
box off

% % ci lines (in dev, doesn't work properly and I'm not even sure if it's
% % the thing I want).
% % 95% bootstrapped confidence intervals, as lines
% for i = 1:length(X)
%     ci(:,i) = bootci(1000,@mean,X{i});
% %     nax                     = 2 * length(X) + i;
% %     ax(nax)                 = axes;
%     h.ci(i)                 = line([ci(:,i)'], [baseline(i) baseline(i)] );
%     axis off
% end