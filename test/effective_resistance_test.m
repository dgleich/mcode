A = spones(delsq(numgrid('S',20)));
A = A-diag(diag(A));
%%
[S,Z] = effective_resistance_sketch(A);

%%
C = commute_times(A);
C = C/sum(sum(A));

%%
plot(nonzeros(C.*A),nonzeros(S),'.')

%%
P = effective_resistance_sketch(A);
[ei,ej,p] = find(triu(P,1));
n = size(A,1);
[ws,ids] = sample(p,ceil(10*n*log(n)));
S = sparse(ei(ids),ej(ids),1./ws,n,n);
S = (S + triu(S)');
