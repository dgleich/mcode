function h = aplot(x,y,varargin)
% aplot Alpha blending plots
%   'alpha', 0.2 % default
%   'plotcolor', [0 0 0] % default


opts.alpha = 0.2;
opts.plotcolor = [0 0 0];
optsu = struct(varargin{:});

% merge opts and optsu
for fn=fieldnames(opts)',if isfield(optsu,fn{1}),opts.(fn{1})=optsu.(fn{1});end,end

switch get(gca,'NextPlot')
    case 'replace'
        cla reset;
    case 'replacechildren'
        cla;
    case 'add'
end

set(gcf,'renderer','openGL')

x = x(:); y = y(:);
h = patch([x; NaN],[y; NaN],...
            [0,0,0],'EdgeAlpha',opts.alpha,'EdgeColor',opts.plotcolor,...
            'FaceColor',opts.plotcolor);