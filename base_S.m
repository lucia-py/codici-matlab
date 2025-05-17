function [B,Q_cell]=base_S(x,T,q)
%x: insieme punti di partenza
%T: cluster tree costruito su x
%q: numero momenti nulli
%h: altezza albero

N=length(x);
I=eye(N);
Sc=[];
Sa=[];

clusters=flatten_tree(T);
L=numel(clusters);
Q_cell=cell(L,1);
%Q_cell: contiene la matrice Q per ogni cluster(decomposizione QR di M per il clsuter corrente)
for k=L:-1:1
    idx=clusters{k};
    n=numel(idx);

    if n<=q+1
        Sc=[Sc;I(idx,:)];
        Q_cell{k}=eye(n);
    else
        M=ones(n,q+1);
        xc=x(idx)-mean(x(idx));
        for j=1:q
            M(:,j+1)=xc.^j;
        end

        [Qpol,~]=qr(M);%Qpol è matrice nxn
        P=eye(n)-Qpol*Qpol';
        [U,~]=qr(P);

        if size(U,2)>q+1%se le colonne di U(n)...
            Q=[Qpol,U(:,q+2:end)];
            Sa=[transpose(Q(:,q+2:end))*I(idx,:);Sa];
        else
            Q=Qpol;
        end
        Q_cell{k}=Q;
    end
end
%mi assicuro che B sia quadrata
B=[Sc;Sa];
if size(B,1)>N
    B=B(1:N,:);
elseif size(B,1)<N
    B=[B;zeros(N-size(b,1),N)];
end


if isequal(B, eye(size(B)))
    disp('B è una matrice identità');
else
    disp('B non è una matrice identità');
end

end
