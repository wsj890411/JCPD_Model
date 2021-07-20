function [imgout] = spline_dofp_interp(img)

    [m, n, ch]=size(img);
    M = 2*m;
    N = 2*n;
    imgout = zeros(M,N,ch);
    img1=zeros(M,N);
    img2=zeros(M,N);
    img3=zeros(M,N);
    img4=zeros(M,N);
    img1(1:2:M,1:2:N)=img(:,:,1);
    img2(1:2:M,2:2:N)=img(:,:,2);
    img3(2:2:M,2:2:N)=img(:,:,3);
    img4(2:2:M,1:2:N)=img(:,:,4);
       

    m = M;
    n = N;

    x=1:2:n;
    y=img1(1:2:m,1:2:n);
    pp=csapi(x,y);
    img1(1:2:m,1:n-1)=fnval(pp,1:n-1);
    x1=1:2:m;
    y1=img1(1:2:m,1:n-1);
    y1=y1';
    pp=csapi(x1,y1);
    img1(1:m-1,1:n-1)=(fnval(pp,1:m-1))';
    img1(m,:)=img1(m-1,:);
    img1(:,n)=img1(:,n-1);

    x=2:2:n;
    y=img2(1:2:m,2:2:n);
    pp=csapi(x,y);
    img2(1:2:m,2:n)=fnval(pp,2:n);
    x1=1:2:m;
    y1=img2(1:2:m,2:n);
    y1=y1';
    pp=csapi(x1,y1);
    img2(1:m-1,2:n)=(fnval(pp,1:m-1))';
    img2(m,:)=img2(m-1,:);
    img2(:,1)=img2(:,2);

    x=2:2:n;
    y=img3(2:2:m,2:2:n);
    pp=csapi(x,y);
    img3(2:2:m,2:n)=fnval(pp,2:n);
    x1=2:2:m;
    y1=img3(2:2:m,2:n);
    y1=y1';
    pp=csapi(x1,y1);
    img3(2:m,2:n)=(fnval(pp,2:m))';
    img3(1,:)=img3(2,:);
    img3(:,1)=img3(:,2);

    x=1:2:n;
    y=img4(2:2:m,1:2:n);
    pp=csapi(x,y);
    img4(2:2:m,1:n-1)=fnval(pp,1:n-1);
    x1=2:2:m;
    y1=img4(2:2:m,1:n);
    y1=y1';
    pp=csapi(x1,y1);
    img4(2:m,1:n)=(fnval(pp,2:m))';
    img4(1,:)=img4(2,:);
    img4(:,n)=img4(:,n-1);
    %%
    imgout(:,:,1) = img1;
    imgout(:,:,2) = img2;
    imgout(:,:,3) = img3;
    imgout(:,:,4) = img4;
end