function T=cluster_tree(idx,q)
%idx: vettore indici 1:N

if length(idx) <= q+1
%se voglio samplet con q momenti nulli 
%mi servono almeno q+1 punti per cluster
    T={idx};
else
    m=floor(length(idx)/2);
    sx=idx(1:m);
    dx=idx(m+1:end);

    Ts=cluster_tree(sx,q);
    Td=cluster_tree(dx,q);

    T=[Ts,Td];
end
end

