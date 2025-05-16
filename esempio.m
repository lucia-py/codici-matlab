%esempio utilizzo

x=randn(1,20);
q=3;
T=cluster_tree(1:length(x),q);
[Bs,Bc]=base_S(x,T,q);

dati=sin(2*pi*x);
coeff=Bs*dati(:);
ricostruzione=Bs'*coeff;

plot(x,dati,'o',x,ricostruzione,'x');
legend('originale','ricostruito');
