function [net,all_feat] = NN1(i,net,movie_feat,theta,w_movie,d,num_movie)

%NN_feat = [];
%for i = 1:num_movie
    outer_product = theta * movie_feat;
    row = [];
    for j= 1:d
        row = [row outer_product(j+(j-1)*(d))];
    end
    NN_feat = row;
%end
NN_feat = NN_feat';
net.trainParam.showWindow=0;
net = configure(net,NN_feat,w_movie');

set(0,'DefaultFigureWindowStyle','docked');
net = train(net,NN_feat,w_movie');
    
all_feat = net(NN_feat);

end