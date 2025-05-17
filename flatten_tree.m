function C = flatten_tree(T)
%T: albero cluster, ogni nodo ha due campi
%T.sx:sottoalbero sinistro
%T.dx: sottolaberoo destro
%idx: indici nel cluster corrente
    if ~isstruct(T)
        C = {T};
    else
        C = [flatten_tree(T.sx), ...
             flatten_tree(T.dx), ...
             {T.idx}];
    end
end

%funzione ricorsiva che mi riporta tutto a celle
%dopo la chiamta ho una lista di nodi
%quando in Base_S itero così non devo guardare la struttura gerachica