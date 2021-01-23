
% lecture d'un fichier ATIS ('..._td.dat')
filename='carre_td.dat';
filepath='./';
serie = load_atis_data_2_le_retour(filename,filepath);
% serie.ts : tableau des temps (en micros)
% serie.x : coord en x
% serie.y : coord en y
% serie.p : polarit? (-1:OFF, 1:ON)
L = 3;
delta_t = 1;
eps = 10^6;
nombre_event = length(serie.ts);

img = zeros(max(serie.x),max(serie.y),nombre_event);
size_img = size(img);

%Pour chaque event
for i = 1:nombre_event
    %Parcours de l'image
    for elt_x = L+1:size_img(1) - (L+1)
        for elt_y = L+1:size_img(2) - (L+1)
            neighborhood_x = elt_x - L : elt_x + L;
            neighborhood_y = elt_y - L : elt_y + L;
            neighborhood_ts = serie.ts(i) - delta_t : serie.ts(i) + delta_t;
            %Zone d'interet
            neighborhood = img(neighborhood_x, neighborhood_y,neighborhood_ts);
        end
    end
end
figure,plot(serie.ts*10^-6);xlabel('numero event');ylabel('temps des events (s)')
% 
% % lecture d'un fichier DVS ('....aedat')
% filename='car1.aedat';
% filepath='./';
% serie = load_atis_data_2_le_retour(filename,filepath);
% % serie.ts : tableau des temps (en micros)
% % serie.x : coord en x
% % serie.y : coord en y
% % serie.p : polarit? (-1:OFF, 1:ON)
% 
% figure,plot(serie.ts*10^-6);xlabel('numero event');ylabel('temps des events (s)')