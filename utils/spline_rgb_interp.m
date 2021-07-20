function [imgout] = spline_rgb_interp(img)


    [m, n, ch]=size(img);
    M = 2*m;
    N = 2*n;
    imgout = zeros(M,N,ch);
    img1=zeros(M,N);
    img2=zeros(M,N);
    img3=zeros(M,N);
    img4=zeros(M,N);
    img1(1:4:M,1:4:N)=img(1:2:end,1:2:end,1);
    img1(1:4:M,2:4:N)=img(1:2:end,2:2:end,1);
    img1(2:4:M,2:4:N)=img(2:2:end,2:2:end,1);
    img1(2:4:M,1:4:N)=img(2:2:end,1:2:end,1);    
    img2(1:4:M,3:4:N)=img(1:2:end,1:2:end,2);
    img2(1:4:M,4:4:N)=img(1:2:end,2:2:end,2);
    img2(2:4:M,4:4:N)=img(2:2:end,2:2:end,2);
    img2(2:4:M,3:4:N)=img(2:2:end,1:2:end,2);
    img3(3:4:M,3:4:N)=img(1:2:end,1:2:end,3);
    img3(3:4:M,4:4:N)=img(1:2:end,2:2:end,3);
    img3(4:4:M,4:4:N)=img(2:2:end,2:2:end,3);
    img3(4:4:M,3:4:N)=img(2:2:end,1:2:end,3);
    img4(3:4:M,1:4:N)=img(1:2:end,1:2:end,4);
    img4(3:4:M,2:4:N)=img(1:2:end,2:2:end,4);
    img4(4:4:M,2:4:N)=img(2:2:end,2:2:end,4);
    img4(4:4:M,1:4:N)=img(2:2:end,1:2:end,4);

    m = M;
    n = N;
   
    x = zeros(1,n/2);
    x(1:2:end) = 1:4:n;
    x(2:2:end) = 2:4:n;
    c = zeros(1,m/2);
    c(1:2:end) = 1:4:m;
    c(2:2:end) = 2:4:m;
    y=img1(c,x);
    pp=csapi(x,y);
    img1(c,1:n-1)=fnval(pp,1:n-1);
    
    x1=c;
    y1=img1(c,1:n-1);
    y1=y1';
    pp=csapi(x1,y1);
    img1(1:m-1,1:n-1)=(fnval(pp,1:m-1))';
    img1(m-1,:) = img1(m-2,:);
    img1(m,:)=img1(m-1,:);
    img1(:,n-1) = img1(:,n-2);
    img1(:,n)=img1(:,n-1);

    x = zeros(1,n/2);
    x(1:2:end) = 3:4:n;
    x(2:2:end) = 4:4:n;
    c = zeros(1,m/2);
    c(1:2:end) = 1:4:m;
    c(2:2:end) = 2:4:m;
    y=img2(c,x);
    pp=csapi(x,y);
    img2(c,3:n)=fnval(pp,3:n);
    x1=c;
    y1=img2(c,3:n);
    y1=y1';
    pp=csapi(x1,y1);
    img2(1:m-1,3:n)=(fnval(pp,1:m-1))';
    img2(m-1,:)=img2(m-2,:);
    img2(m,:)=img2(m-1,:);
    img2(:,2)=img2(:,3);
    img2(:,1)=img2(:,2);

    x = zeros(1,n/2);
    x(1:2:end) = 3:4:n;
    x(2:2:end) = 4:4:n;
    c = zeros(1,m/2);
    c(1:2:end) = 3:4:m;
    c(2:2:end) = 4:4:m;
    y=img3(c,x);
    pp=csapi(x,y);
    img3(c,3:n)=fnval(pp,3:n);
    x1=c;
    y1=img3(c,3:n);
    y1=y1';
    pp=csapi(x1,y1);
    img3(3:m,3:n)=(fnval(pp,3:m))';
    img3(2,:)=img3(3,:);
    img3(1,:)=img3(2,:);
    img3(:,2)=img3(:,3);
    img3(:,1)=img3(:,2);

    x = zeros(1,n/2);
    x(1:2:end) = 1:4:n;
    x(2:2:end) = 2:4:n;
    c = zeros(1,m/2);
    c(1:2:end) = 3:4:m;
    c(2:2:end) = 4:4:m;
    y=img4(c,x);
    pp=csapi(x,y);
    img4(c,1:n-1)=fnval(pp,1:n-1);
    x1=c;
    y1=img4(c,1:n);
    y1=y1';
    pp=csapi(x1,y1);
    img4(3:m,1:n)=(fnval(pp,3:m))';
    img4(2,:)=img4(3,:);
    img4(1,:)=img4(2,:);
    img4(:,n-1)=img4(:,n-2);
    img4(:,n)=img4(:,n-1);
    %%
    img2(3:4:end,1:4:end) = img4(3:4:end,1:4:end);
    img2(3:4:end,2:4:end) = img4(3:4:end,2:4:end);
    img2(4:4:end,2:4:end) = img4(4:4:end,2:4:end);
    img2(4:4:end,1:4:end) = img4(4:4:end,1:4:end);
    img2(1:4:end,1:4:end) = (img2(1:4:end,1:4:end)+img4(1:4:end,1:4:end))./2;
    img2(1:4:end,2:4:end) = (img2(1:4:end,2:4:end)+img4(1:4:end,2:4:end))./2;
    img2(2:4:end,2:4:end) = (img2(2:4:end,2:4:end)+img4(2:4:end,2:4:end))./2;
    img2(2:4:end,1:4:end) = (img2(2:4:end,1:4:end)+img4(2:4:end,1:4:end))./2;
    
    img2(3:4:end,3:4:end) = (img2(3:4:end,3:4:end)+img4(3:4:end,3:4:end))./2;
    img2(3:4:end,4:4:end) = (img2(3:4:end,4:4:end)+img4(3:4:end,4:4:end))./2;
    img2(4:4:end,4:4:end) = (img2(4:4:end,4:4:end)+img4(4:4:end,4:4:end))./2;
    img2(4:4:end,3:4:end) = (img2(4:4:end,3:4:end)+img4(4:4:end,3:4:end))./2;
    img4 = img2;
    imgout(:,:,1) = img1;
    imgout(:,:,2) = img2;
    imgout(:,:,3) = img3;
    imgout(:,:,4) = img4;

end