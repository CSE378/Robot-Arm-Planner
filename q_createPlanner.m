% Implement this function

function [Node, Edge] =  q_createPlanner(robotEnv, K)
% Inputs:
%   robotEnv: two-link arm environment, created using robotEnv = M_TwoLinkArm(obstacles).
%   K: the number of random points in the probabilistic roadmap. 
% Output:
%   Node: 2*K matrix for K nodes of the graph. Each row corresponds to a node, each node is a vector of theta1 and theta2.
%       That is: Node(i,:) = [theta1, theta2]
%   Edge: K*K adjacency matrix
%       Edge(i,j) =1 if Node i can be connected with Node j, and 0 otherwise.
%       Two graph nodes i and j can only be connected by an edge if the difference between the corresponding 
%       joint angles is smaller than pi/18. 


% Dummy code, modify as you wish
Node = rand(2, K);
Edge = randi([0, 1], [K, K]);

for i=1:K
    Node(:,i) = generateNode(robotEnv);
    disp(i);
end

% Create adjacency matrix
for i=1:K
    node_i = Node(:,i);
    for j=1:K
        node_j = Node(:,j);
        if (isConnected(node_i, node_j))
            Edge(i,j) = 1;
        else
            Edge(i,j) = 0;
        end
    end
end