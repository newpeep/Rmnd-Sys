% Runs CascadeLinUCB and returns Cumulative Regret, Cumulative Reward and Top K movies

function [regret,reward,A] = CascadeLinUCB_NN(variance,d,n,K,movie_features,W_test,A_star,theta_star,w_movie,num_movies)
%disp("called CascadeLinUCB_NN")
% Initialization
iM = eye(d);
B = zeros(d,1);
regret =zeros(n,1);
reward =zeros(n,1);
net=feedforwardnet;
num_movie=num_movies;
regret_sum_UCBNN=0;
A_totucb_nn=zeros(n,K)
for i = 1:n
   % Calculating UCB for each movie
   disp(i)
   iM = round(iM,10);
   theta_bar = (iM*B)/variance;
   U = zeros(size(movie_features,1),1);
   c = sqrt(d*log(1 + (n*K/d)) + 2*log(n*K)) + norm(theta_star);
   
   theta=theta_bar;
   
   %[net,all_features]=NN1(i,net,movie_features(u,:),theta,w_movie(i,:),d,num_movie);

   for u = 1:size(movie_features,1)
       [net,all_features]=NN1(i,net,movie_features(u,:),theta,w_movie(u,:),d,num_movie);
       temp = all_features + c*sqrt(movie_features(u,:)*iM*movie_features(u,:)');
       U(u) = min(temp,1);
   end
   
       
   % Recommending a list of K items 
   A = zeros(K,1);
   [~,A] = sort(U,'descend');
    A = A(1:K);
   A_totucb_nn(i,:)=A;


   % Getting feedback
   c_t = 10000;
   selected_user = randi([1 length(W_test)],1,1);
   for j = 1:K
       if W_test(selected_user,A(j)) == 1
         c_t = j;
         reward(i) = 1;
         break;
       end
   end
   
   % Calculating Regret 
    reg = 0;

    for j = 1:min(c_t,K)
       e = A(j);
       e_star = A_star(j);
       reg = reg + w_movie(e_star) - w_movie(e);
    end
    regret(i) = reg;
    regret_sum_UCBNN = regret_sum_UCBNN+reg;

%     Other way to find same regret as above    
%     rew = 1 - prod(1 - w_movie(A(1:min(c_t,K))));
%     rew_star =  1 - prod(1 - w_movie(A_star(1:min(c_t,K))));
%     regret(i) = rew_star - rew;


   % Updating Statistics
   for j = 1:min(c_t,K)
       e = A(j);
       iM = iM - ((iM*movie_features(e,:)'*movie_features(e,:)*iM)/((movie_features(e,:)*iM*movie_features(e,:)') + variance));
       if (j == c_t)
        B = B + movie_features(e,:)';
       end
   end
   
 aaa=1;  
 abso=1   
end


end