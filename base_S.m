function Q_cell=base_S(x,T,q)
%x: vettore colonna con le coordinate dei punti
%T: clsuter tree
%q: numero vanishing moments

%Q_cell: cell di dimLx1 con L= numero cluster in T
%ogni Qcell(k) è una matrice quadrata

N=length(x);

clusters=flatten_tree(T);
L=numel(clusters);
Q_cell=cell(L,1);

for k=1:L
    idx=clusters{k};
    n=numel(idx);

    if n<=q+1
        Q_cell{k}=eye(n);
        continue;
%continue serve per saltare il resto del ciclo for e passare
%da k a k+1
    end
        M=zeros(q+1,n);
        xc=x(idx);%coordinate locali
    
        for j=1:(q+1)
 
            M(j,:)=xc.^(j-1);
        end
       
    [Qpol_full,R]=qr(M');
    Q_cell{k}=Qpol_full;
%i primi q+1 blocchi di Q_cell(k) sono scaling, gli ultimi samplet

end
end

       
