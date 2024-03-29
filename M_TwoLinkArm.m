classdef M_TwoLinkArm
% A robot environment with: a 2-link robotic arm + obstacles
% The base of the robotic arm is fixed. Each obstacle is a triangle, and there might multiple obstacles.
% This is for HW3 of Introduction to Robotics CSE 378, Spring 2019.
%
% By: Minh Hoai Nguyen (minhhoai@cs.stonybrook.edu)
% Created: 03-Apr-2018
% Last modified: 12-Apr-2019

    properties 
        L1 = 20;
        L2 = 10;
        obstacles = [];
    end
    
    methods        
        % obstacles: m*6 matrix for m obstacles
        %   obstacles(i,:) is the coordinates of the i^th triangular obstacle: X1, Y1, X2, Y2, X3, Y3
        function obj = M_TwoLinkArm(obstacles)
            obj.obstacles = obstacles;
        end
                                
        function [jointX, jointY, tipX, tipY] = forwardKinematic(obj, theta1, theta2)
            jointX = obj.L1*cos(theta1);
            jointY = obj.L1*sin(theta1);
            tipX = jointX + obj.L2*cos(theta1 + theta2);
            tipY = jointY + obj.L2*sin(theta1 + theta2);
        end
                
        function isFail = execute(obj, theta1s, theta2s, shldAnimate)
            if isempty(theta1s) || isempty(theta2s) || length(theta1s) ~= length(theta2s)
                fprintf('Fail: Empty plan or inconsistent\n');                
                isFail = true;
                return;
            end
                                
            % Check if the joint angles between two consecutive steps is too large
            if any(abs(diff(theta1s)) >= 9000000) || any(abs(diff(theta2s)) >= 9000000)
                fprint('Fail: the difference between joint angles of two consecutive steps should be < 10 deg\n');
                isFail = true;            
                return;
            end
            
            % Check for collision            
            isFail = false;
            nStep = length(theta1s);
            for i=1:nStep
                theta1 = theta1s(i);
                theta2 = theta2s(i);
                if shldAnimate
                    clf;
                    obj.show(theta1, theta2);
                    pause(0.1);
                end
                
                if obj.checkCollision(theta1, theta2)
                    fprintf('Fail: collision occurs\n');
                    isFail = true;
                    return;
                end
            end
            fprintf('Successfully executing the plan\n');
        end
        
        function collision = checkCollision(obj, theta1, theta2)
            nObstacle = size(obj.obstacles, 1);
            if nObstacle == 0
                collision = false;
            else                
                [jointX, jointY, tipX, tipY] = obj.forwardKinematic(theta1, theta2);
                bP = [0; 0];
                jP = [jointX; jointY];
                tP = [tipX; tipY];
                for j=1:nObstacle
                    obstacle = obj.obstacles(j,:);
                    P1 = obstacle([1;2])';
                    P2 = obstacle([3;4])';
                    P3 = obstacle([5;6])';
                    
                    if isIntersect(bP, jP, P1, P2) || isIntersect(bP, jP, P1, P3) || ...
                       isIntersect(bP, jP, P2, P3) || isIntersect(tP, jP, P1, P2) || ...
                       isIntersect(tP, jP, P1, P3) || isIntersect(tP, jP, P2, P3)
                   
                        collision = true;
                        break;
                    else
                        collision = false;
                    end
                end
            end
        end
        
                
        function animate(obj, theta1s, theta2s)
            for i=1:length(theta1s)                
                theta1 = theta1s(i);
                theta2 = theta2s(i);
                clf;
                obj.show(theta1, theta2);
                pause(0.1);                
            end            
        end
        
        function show(obj, theta1, theta2)
            baseX = 0;
            baseY = 0;
            [jointX, jointY, tipX, tipY] = obj.forwardKinematic(theta1, theta2);
                        
            for j=1:size(obj.obstacles, 1)
                obstacle = obj.obstacles(j,:);
                fill(obstacle([1,3,5]), obstacle([2,4,6]), [0.5, 0.5, 0.5]);
                hold on;
            end
            
            line([baseX, jointX], [baseY, jointY], 'LineWidth', 10, 'Color', 'b');
            line([jointX, tipX], [jointY, tipY], 'LineWidth', 10, 'Color', 'c');
            hold on;
            scatter([baseX, jointX, tipX], [baseY, jointY, tipY], 120, 'm', 'filled');
            axis equal;
            axis([-40, 40, -40, 40]);            
        end
    end
end


