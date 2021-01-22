% load data
events = load_atis_data_2_le_retour('multipattern1.dat','./')
%events = load_atis_data_2_le_retour('Tmpdiff128-Cars.dat','./')
%events = load_atis_data_2_le_retour('carre_td.dat','./')

data_folder = 'datafolder';
%mkdir(events.data_folder);

plot_mode = 2; % 0-negative; 1-positive; 2-both
plotAllEvents(events);