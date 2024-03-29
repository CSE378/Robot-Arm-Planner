function [theta1, theta2] = q_inverseKinematic(robotEnv, desiredHandTipXY)
% Implement this function
% Inputs:
%   robotEnv: two-link arm environment, created using robotEnv = M_TwoLinkArm(obstacles).
%   desiredHandTipXY: a 2*1 vector for the desired X and Y positions of the tip of the robot's arm.
% Output:
%   theta1: the angle of the first joint
%   theta2: the angle of the second joint
%   If there is no feasible solution, theta1 and theta2 are []

X = desiredHandTipXY(1);
Y = desiredHandTipXY(2);

L1 = robotEnv.L1;
L2 = robotEnv.L2;

theta2 = acos((X^2 + Y^2 - L1^2 - L2^2)/(2*L1*L2));
theta1 = atan2(Y,X) - atan((L2*sin(theta2))/(L1 + L2*cos(theta2)));

% Check if outside reachability
dist = sqrt(X^2+Y^2);
radius = L1 + L2;

if (radius < dist) 
    theta2 = [];
    theta1 = [];
end

if (dist <= 10)
    theta2 = [];
    theta1 = [];
end