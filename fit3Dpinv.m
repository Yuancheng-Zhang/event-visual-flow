function vec = fit3Dpinv(x,y,z,avg_flag)
        if nargin < 4
            avg_flag = 0;
        end
        if size(x,1) == 1
            x = x';
            y = y';
            z = z';
        end
        if size(x,1) <3
            error('at least 3 points are needed');
        end
        x_avg = mean(x);
        y_avg = mean(y);
        z_avg = mean(z);
        if avg_flag == 1
            
            x = x - x_avg;
            
            y = y - y_avg;
            
            z = z - z_avg;
        end
        A = cat(2,x,y,ones(size(x,1),1));
        abc = -pinv(A)*z;
        vec = [abc(1);abc(2);1;abc(3)];
    end