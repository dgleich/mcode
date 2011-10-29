function spy_labels(names,colnames)

if ~exist('colnames','var'), colnames=names; end

hdt = datacursormode;
% Declare a custom datatip update function to display state names
set(hdt,'UpdateFcn',{@shownames,names,colnames})

function output_txt = shownames(obj,event_obj,...
                      rownames,colnames)
% Display an observation's Y-data and label for a data tip
% obj          Currently not used (empty)
% event_obj    Handle to event object
% xydata       Entire data matrix
% labels       State names identifying matrix row
% output_txt   Datatip text (string or string cell array)
% This datacursor callback calculates a deviation from the
% expected value and displays it, Y, and a label taken
% from the cell array 'labels'; the data matrix is needed
% to determine the index of the x-value for looking up the
% label for that row. X values could be output, but are not.

pos = get(event_obj,'Position');
x = round(pos(1)); y = round(pos(2));
output_txt = {};
output_txt{end+1} = ['Row: ' rownames{y} ];
output_txt{end+1} = ['Col: ' colnames{x} ];

