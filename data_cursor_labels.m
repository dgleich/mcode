function data_cursor_labels(x,y,names)

xydata = [x(:) y(:)];

hdt = datacursormode;
% Declare a custom datatip update function to display state names
set(hdt,'UpdateFcn',{@labeledtips,xydata,names})

function output_txt = labeledtips(obj,event_obj,...
                      xydata,labels)
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
x = pos(1); y = pos(2);
output_txt = {};
xset = find(xydata(:,1) == x);
yset = xset(xydata(xset,2) == y);
if length(yset) == 0
    output_txt{end+1} = 'no points';
else
    if length(yset) >5
        output_text{end+1} = ...
            sprintf('Truncted list of %i points to 5...\n', length(yset));
        yset = yset(1:5);
    end
    for i=yset(:)'
        output_txt{end+1} = labels{i};
    end
end
