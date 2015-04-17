clear all;
tic;
grc = linspace(0.,4,300); %consumption vector
grq =[1 4];%output vector
gra = linspace(0.,1.,300); %effort vector
nc= length(grc);nq=length(grq); na=length(gra);
%dimension of lottery vector per type
N=na*nq*nc; %=180,000

%production technology
P(2:2:na*nq) = gra;
P(1:2:na*nq-1) = 1-gra;

%tensorization/vectorization 
C = kron(ones(1,na*nq),grc);
Q = kron(kron(ones(1,na),grq),ones(1,nc));
A = kron(gra,ones(1,nc*nq));

%adding up to one for total probability
Aeq_1 =  ones(1,N);
beq_1 = 1;
%set utility offer
omega = 2.3; sig = .5; gam = 2;
Aeq_ut = C.^(1-sig)/(1-sig) - A.^gam;
beq_ut = omega;
%objective function
Obj = Q - C ;

Aeq_mn = zeros(na*nq,N);
beq_mn = zeros(na*nq,1);
index_mn = 0;

Aeq_mn =kron(eye(na*nq), ones(1,nc)) - kron(kron(eye(na), ones(nq,1)).*(P'*ones(1,na)), ones(1,nq*nc));
beq_mn = zeros(na*nq,1);

A_ineq = []; %A_part - participation constraint, A_icc - ICC
b_ineq = [];
Aeq = [Aeq_1;Aeq_ut;Aeq_mn;]; %Aeq_1 - adding up to one, Aeq_mn - mother nature constraints
beq = [beq_1;beq_ut;beq_mn;];
%if use linprog
options = optimset('Display','on','Diagnostics','on');
toc;
tic;
[x,fval,eflag,nn,la] = linprog(-Obj,A_ineq,b_ineq,Aeq,beq,zeros(N,1),ones(N,1),[],options);
toc;

Cp = C*x;
Qp = Q*x;
Ap = A*x;
[Qp Cp Ap Qp-Cp]
tic;
gam*Ap^(gam-1)
(grq(2)-grq(1))*Cp^(-sig)
Cp^(1-sig)/(1-sig)-Ap^gam
