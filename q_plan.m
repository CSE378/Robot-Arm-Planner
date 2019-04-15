% Impleme//;nt this function
function [theta1s, theta2s] = q_plan(Node, Edge, startXY, endXY)
% Inputs:
%   Node: 2*K matrix for K nodes of the graph. Each row corresponds to a node, each node is a vector of theta1 and theta2.
%       That is: Node(i,:) = [theta1, theta2]
%   Edge: K*K adjacency matrix
%       Edge(i,j) =1 if Node i can be connected with Node j, and 0 otherwise.
%       Two graph nodes i and j can only be connected by an edge if the difference between the corresponding 
%       joint angles is smaller than pi/18. 
%   startXY: start position for the tip of the robot's arm
%   endXY: desired target position for the tip of the robot's arm.
% Outputs:
%   theta1s, theta2s: two 1*m vectors for the joint angles that create a collision-free path between startXY and endXY.
%

% Get source and target
startIndex = findClosestNode(Node, startXY);
goalIndex = findClosestNode(Node, endXY);

G = graph(Edge);

path = shortestpath(G, startIndex, goalIndex);

[~, pathLength] = size(path);

theta1s = Inf(1, pathLength);
theta2s = Inf(2, pathLength);

for i=1:pathLength
    index = path(i);
    theta1 = Node(1, index);
    theta2 = Node(2, index);
    
    theta1s(i) = theta1;
    theta2s(i) = theta2;
end

% Crop array
for i=1:pathLength
    if theta1s(i) == Inf
        theta1s = theta1s(1:i-1);
        theta2s = theta2s(1:i-1);
    end
end