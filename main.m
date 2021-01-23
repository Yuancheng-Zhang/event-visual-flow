clear all;clc;close all

%%% load event data
%events = load_atis_data_2_le_retour('multipattern1.dat','./');
events = load_atis_data_2_le_retour('Tmpdiff128-Cars.dat','./');
%events = load_atis_data_2_le_retour('carre_td.dat','./');

%%% plot all events
plot_mode = 0; % 0-only-negative-p; 1-only-positive-p; 2-both
plotAllEvents(events);

%%% pick a part of the data
events.ts = events.ts(1:200000);
events.x = events.x(1:200000);
events.y = events.y(1:200000);
events.p = events.p(1:200000);

%%% define parameters
L = 3;
delta_t = 1;
epsilon = 10e-6;
th1 = 10e-5;
th2 = 0.05;

%%% plane fitting and velocities calculation
%par = FlowPlaneFitPinv(events, th1, th2, L, delta_t, epsilon); % use Pinv
%par = FlowPlaneFitSVD(events, th1, th2, L, delta_t, epsilon); % use SVD