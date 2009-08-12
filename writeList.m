function writeList(filename, list)
% WRITELIST Writes a cell array to a file.
%
% writeList(filename, list)
%

fid = fopen(filename, 'wt');
fprintf(fid, '%s\n', list{:});
fclose(fid);

