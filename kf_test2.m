%% kalman filter
% write by Siberia Liuming
% dicksonliuming@gmail.com
% 2017/3/17

%% arguments initialization
clear; clc;

T = 100;    % times
D = 2;  % status dimension
q = 1;  % process noise covariance
r = 1;  % observe noise covariance
Q = sqrt(q) * eye(D);   % process noise
R = sqrt(r) * eye(D);   % observe noise
p = Q;  % status covariance

F = [1, 0.5; 0, 1];   % status transfer matrix
H = [1, 0; 0, 1];  % observe matrix
x0 = [0; 0]; % initial true status
xe = [10; 5];    % initial guess status

xout = zeros(D,T);  % store true status
zout = zeros(D,T);  % store true observe value
xestout = zeros(D,T);   % store estimate value
xout(:,1) = x0;   % initial for true status
zout(:,1) = H * x0 + sqrt(r) * randn;   % initial for observe

%% prepair for true status and observe
x = x0;
for t = 2:T
    x = F * x + sqrt(q) * randn;  % status update
    xout(:,t) = x;    % status store
    z = H * x + sqrt(r) * randn;  % observe update
    zout(:,t) = z;    % observe store
end

%% do kalman filter
x = xe;
xestout(:,1) = x;
for t = 2:T
    % predict status and covariance
    x = F * x;
    p = F * p * F' + Q;
    
    % cal kalman gain
    K = p * H' / (H * p * H' + R);
    
    % update status and covariance
    x = x + K * (zout(:,t) - H * x);
    p = (eye(D) - K * H) * p;
    
    % store x estimate value
    xestout(:,t) = x;
end

%% plot
t = 1:T;
plot(t, xout, '-.k', t, zout, '*k', t, xestout, '-.r');