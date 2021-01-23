function vec = fit3Dcramer(x,y,z,avg_flag)
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
        AtA = A'*A;
        Atz = -A'*z;
        xx = AtA(1,1);
        xy = AtA(1,2);
        yy = AtA(2,2);
        xz = Atz(1);
        yz = Atz(2);
        D = xx*yy-xy*xy;
        a = -(yz*xy - xz*yy)/D;
        b = -(xy*xz - xx*xz)/D;
        % vec = pinv(AtA)*Atz
        c = -1;
        d = z_avg - a*x_avg - b*y_avg;
        vec = [a;b;c;d];

    end