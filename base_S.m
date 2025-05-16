function [base_samplet, base_scaling,Q_set]=base_S(x,T,q)
%x: insieme punti di partenza
%T: cluster tree costruito su x
%q: voglio q+1 momenti nulli

N=length(x);
base=eye(N);%matrice identità Ndim

base_samplet=[];
base_scaling=[];
Q_set=cell(length(T),1);

for i=length(T):-1:1%attraverso l'albero dalla radice alle foglie
    idx=T{i};%indici punti nel cluster
    cluster_size=length(idx);

    if cluster_size <= q+1
        base_scaling=[base_scaling;base(idx,:)];
        Q_set{i}=eye(cluster_size);

    else
        M=ones(cluster_size,q+1);
        x_centrato=x(idx)-mean(x(idx));

        for j=1:q
            M(:,j+1)=x_centrato.^j;
        end

        [Q_pol,~] = qr(M, 0);
        P=eye(cluster_size)-Q_pol*Q_pol';
        [U,~]=qr(P);

        if size(U,2)>q+1
            Q=[Q_pol,U(:,q+2:end)];
        else
            Q=Q_pol;
        end
        Q_set{i}=Q;
        base_samplet=[Q(:,q+2:end)'*base(idx,:);base_samplet];
    end
end
base_samplet=[base_scaling;base_samplet];
end
            
