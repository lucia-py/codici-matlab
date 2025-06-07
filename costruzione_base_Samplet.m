clear all
close all
N = 16;             
x = randn(N,1);
q = 1;               

% Costruisco l’albero di cluster 
idx_tot = (1:N);
[T, h] = cluster_tree(idx_tot, q);

% Appiattisco i cluster e ottengo le matrici Q per ogni foglia o nodo interno
Q_cell = base_S(x, T, q);

%Q_cell(k) deve essere ortonormale per colonne
for k = 1:numel(Q_cell)
    Qk = Q_cell{k};
    diffNorm = norm(Qk.'*Qk - eye(size(Qk,2)), 'fro');
    fprintf("Cluster %2d (n = %2d): Q'*Q-I = %.2e\n", k, size(Qk,1), diffNorm);
end

%impilo le righe di Qk in B
B=zeros(N,N);
riga=1;

clusters=flatten_tree(T);
L=numel(clusters);

for k=L:-1:1
    idx=clusters{k};
    n=numel(idx);
    Qk=Q_cell{k};

    r_scaling=min(n,q+1);

    B(riga:(riga+r_scaling-1),idx) = Qk(:,1:r_scaling).';
    riga = riga + r_scaling;
end

%raccolgo le righe di samplet
for k = 1:L
    idx = clusters{k};
    n   = numel(idx);
    Qk  = Q_cell{k};
    
    r_scaling = min(n,q+1);
    r_detail  = n - r_scaling;
    
    if (r_detail > 0) && (r_scaling<n)
        % Impilo le righe (r_scaling+1):n di Qk
        %Qk: r_Detailxn
        B(riga:(riga+r_detail-1),idx) = Qk(:,(r_scaling+1):n).';
        riga = riga + r_detail;
    end
end

%controlli dimensionali
%assert(riga == N+1, 'Impossibile: il conteggio delle righe non coincide con N.');
fprintf('\n--- Verifica ortogonalità complessiva di B ---\n');
errF = norm(B' * B - eye(N), 'fro');
fprintf('||B * B^T - I_N||_F = %.2e\n\n', errF);

n_BASIS = 3;
x_dense=linspace(min(x),max(x),1000);
figure(1); clf; hold on;
for k = 1:n_BASIS
    yk_interp = interp1(x, B(k,:), x_dense, 'spline');
    plot(x_dense, yk_interp, 'LineWidth', 1.2);
end
hold off;
xlabel('x'); ylabel('ϕ_k(x)');
title(sprintf('Prime %d funzioni della base samplet (interpolata)', n_BASIS));

figure(2); hold on;
for k = 4:7%basi samplet B(4:),B(7:), visualizzo righe 4,5,6,7 di B
    yk = interp1(x, B(k,:), x_dense, 'spline');
    plot(x_dense, yk);
end
title('Funzioni samplet (detail)');
xlabel('x'); ylabel('ϕ_k(x)');
hold off;