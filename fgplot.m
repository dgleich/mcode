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
%   

% David F. Gleich
% Sandia National Labs, 2011

% History
% -------
% :2011-05-17: Initial coding

% TODO: Add options

graphlw = 0.4;
bkgcolor = 0.83*[1,1,1];
graphclr = 0.55*[1,1,1];
redclr = [0.8,0,0];

% Generate the graph
rehold = ishold;

[lx,ly]=gplot(A,xy); 
%h=plot(lx,ly,'k-','LineWidth',graphlw);
h = aplot(lx,ly,'plotcolor',graphclr);
set(h,'LineWidth',graphlw);

set(gcf,'Color',bkgcolor);
hold on; 
axis off; 

axis square;

add_border(xy, bkgcolor, 0.05);
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
