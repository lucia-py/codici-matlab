%esempio utilizzo

x=randn(1,30);
q=3;
T=cluster_tree(1:length(x),q);
[B,Q_cell]=base_S(x,T,q);

disp(size(B));%voglio 30
disp(norm(B*B'-eye(30),'fro'));%piccola

n=2;%numero basi da plottare
figure(1);  hold on
for k=1:n
    plot(x,B(k,:));
end
hold off

dati=sin(2*pi*x);
coeff=B*dati(:);
ricostruzione=B'*coeff;

figure(2)
plot(x,dati,'o',x,ricostruzione,'x');
legend('originale','ricostruito');
