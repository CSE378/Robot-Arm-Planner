% Implement this function
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


% You can modify/delete the below dummy code
nStep = 40;
theta1s = pi*(0:nStep)/nStep;
theta2s = pi*(0:nStep)/nStep;