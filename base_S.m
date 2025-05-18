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

for k=L:-1:1
    idx=clusters{k};
    n=numel(idx);

    if n<=q+1
        Sc=[Sc;I(idx,:)];
        Q_cell{k}=eye(n);
    else
        M=ones(q+1,n);
        xc=x(idx);
        
        for j=1:q
  %sostituisco la riga j con xc^j
  %---l'errore credo sia qui ma non lo trovo---sistemato forse
            M(j,:)=xc.^(j-1);
        end
        %disp(M);
        %disp(size(M));
    
    
  %---Qpol non è nxn nuovo ptoblema
  %ho spostato la end della if dopo [U,~]=qr(P) e sembra ok
    [Qpol,~]=qr(M');%Qpol è matrice nxn
    P=eye(n)-Qpol*Qpol';
    [U,~]=qr(P);
    

        if size(U,2)>q+2%se le colonne di U(n)...
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
    B=B(3:N+2,:);
elseif size(B,1)<N
    B=[B;zeros(N-size(b,1),N)];
end


%if isequal(B, eye(size(B)))
 %   disp('B è una matrice identità');
%else
 %   disp('B non è una matrice identità');
%end
end