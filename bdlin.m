%This is a program for a bundling problem
%It is a linear program

clear all;

tic

%%1. Define global variables


%%2. Set up parameter values
    %2.1 Distribution of skills
    nz = 2;
    ns = 2;
    nh = 2;
   
    %matrix of skills endowments (nsxnh)
    S = [3 1; 1 6]';
    %vector of mass of each type (nhx1)  
    %alpha = ones(nh,1)./nh;
    alpha = rand(nh,1);
    alpha = alpha./(sum(alpha));
    %matrix of skill prices (nsxnz)
    W = [2 1;0.5 3]';
    %"superstar parameter
    delta =1;
    
    %2.2 Choice variables: x is stacked in the following manner x = (x^1(1), ..., x^1(nz), x62(1), ..., x^nh(nz))

    nx = nh*nz;                   

%%3. Constructing the Matrices to use in the command fmincon

    %3.1 Objective function using obj.m function

    %3.2 Assign lower and upper bounds for x, probability measure or choice variables here

        UB=[];
        LB=zeros(nx,1);

    %3.3 Probability constraint, x is stacked as x = [pi(x,y, z1); pi(x,y, z2); ...]
        beq = ones(nh,1);
        Aeq = [kron(eye(nh), ones(1,nz))];
        
    %%4. Linear Programming

    %4.1 Form matrices
        b=[];
        A=[];
        
    %5. Objective function

        obj = -(kron(alpha', ones(1,nz))).*(vecrow(((S').^delta)*W));

        options=optimset('LargeScale', 'on', 'Simplex', 'off', 'Display','on','TolFun',10^-10,'MaxIter',100000,'TolX',10^-10);
        [x,fval,exitflag,output,lambda]=linprog(obj, A, b, Aeq, beq, LB, UB, [], options);
        exitflag
        Optimal = -fval

        %Recovering the results
        xp = find(x>0.25*10^-2);
toc
