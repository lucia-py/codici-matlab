%esempio utilizzo

x=randn(1,20);
q=3;
T=cluster_tree(1:length(x),q);
[Bs,Bc]=base_S(x,T,q);

n=2;%numero basi da plottare
figure(1)
for k=1:n
    plot(x,Bs(k,:));
end

dati=sin(2*pi*x);
coeff=Bs*dati(:);
ricostruzione=Bs'*coeff;

figure(2)
plot(x,dati,'o',x,ricostruzione,'x');
legend('originale','ricostruito');
