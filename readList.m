function list=readList(filename)
% readList reads a list of words in a file into a
% cell array.
%
%   list = readJMAT(filename)
%   filename - the name of the list file
%   list - the list of items in the file
%
%

list = textread(filename, '%s', 'delimiter', '\n','bufsize',16383);
