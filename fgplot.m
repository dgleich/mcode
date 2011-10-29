function h=fgplot(A,xy,varargin)
% FGPLOT Fancy graph plot
%
% fgplot(A,xy) - basic fancy gplot 
% fgplot(A,xy,f) - fancy gplot with labeled points
%
% fgplot(A,xy,'key',value,'key',value,...)
% fgplot(A,xy,f,'key',value,'key',value,...)
% provide optional arguments
%   'Background' - The background plot color, default=0.83*[1,1,1].
%     use 'none' for white.
%   'LineWidth' - The graph edge linewidth, default=0.4
%   'Color' - The graph color, default=0.55*[1,1,1]
%   'Border'
%   'VertexSize'
%   '
%   

% David F. Gleich
% Sandia National Labs, 2011

% History
% -------
% :2011-05-17: Initial coding
% :2011-06-24: Added alpha blending
% :2011-10-22: Added options
% :2011-10-28: Added option for no alpha

p=inputParser;
p.addParamValue('Border',0.05,@isnumeric);
p.addParamValue('LineWidth',0.4,@isnumeric);
p.addParamValue('Alpha',0.1,@isnumeric);
p.addParamValue('Background',0.83*[1,1,1],@iscolor);
p.addParamValue('Color',0.55*[1,1,1],@iscolor);
p.addParamValue('MarkerSize',10,@isnumeric);
p.addParamValue('MarkerColor',[0.8,0,0],@iscolor);

p.parse(varargin{:});  
opts = p.Results;

% Generate the graph
rehold = ishold;

[lx,ly]=gplot(A,xy); 
%h=plot(lx,ly,'k-','LineWidth',graphlw);
if opts.Alpha < 1
    h = aplot(lx,ly,'plotcolor',opts.Color,'alpha',opts.Alpha);
    set(h,'LineWidth',opts.LineWidth);
else
    h = plot(lx,ly,'-','Color',opts.Color,'LineWidth',opts.LineWidth);
end


set(gcf,'Color',opts.Background);

hold on; 
  axis off; 
  axis square;
  if opts.Border>0
    add_border(xy, opts.Background, opts.Border);
  end
  if opts.MarkerSize>0
      hs=scatter(xy(:,1),xy(:,2),opts.MarkerSize);
      set(hs,'MarkerFaceColor',opts.MarkerColor);
      set(hs,'MarkerEdgeColor',opts.MarkerColor);
  end
if ~rehold, hold off; end

function add_border(xy,bkgcolor, s)
% add points to get 
xymin = min(xy);
xymax = max(xy);
xysize = xymax-xymin;
xy1 = xymin-s*xysize;
xy2 = xymax+s*xysize;
h = plot(xy1(1),xy1(2),'.'); set(h,'Color',bkgcolor);
h = plot(xy2(1),xy2(2),'.'); set(h,'Color',bkgcolor);

function rval=iscolor(x)
rval=true;
if numel(x)~=3
    rval=false;
    return
elseif any(x<0) || any(x>1)
    rval=false;
    return;
end