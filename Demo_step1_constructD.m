clear; clc; close all; fclose all; warning off all
addpath(genpath('utils'));
addpath(genpath('train_dataset'));
addpath(genpath('test_dataset'));

%% arguments
num_patch   = 2000;     % number of patches to sample
overlap     = 4;
reg         = 0.0001;        % regularization
max_iter    = 200;
vanish      = 0.95;          % regularization vanishing factor
regstop     = inf;         % cancel regularization term starting with this iteration
iters_D       = 50;         % DL iterations 
iters_C       = 50;         % DL iterations
s           = 8;
dict_size   = 256;        % dictionary size
patch_size  = 4;          % image patch  size

%% GENERATE SIGNAL DATA
Y_pol  = [];
Y_rgb = [];
data_dir = 'train_dataset';
data = dir(fullfile(data_dir));
for i = 3 : size(data,1)
    fprintf('image_processing: %d... \n',i-2);
    dataName = data(i).name;
    
    data_0 = double(imread(strcat('train_dataset/', data(i).name, '/gt_0/',data(i).name, '.png')));
    data_45 = double(imread(strcat('train_dataset/', data(i).name, '/gt_45/',data(i).name, '.png')));
    data_90 = double(imread(strcat('train_dataset/', data(i).name, '/gt_90/',data(i).name, '.png')));
    data_135 = double(imread(strcat('train_dataset/', data(i).name, '/gt_135/',data(i).name, '.png')));
  

    data_tmp(:,:,1:3) = data_0;
    data_tmp(:,:,4:6) = data_45;
    data_tmp(:,:,7:9) = data_90;
    data_tmp(:,:,10:12) = data_135;

    data_sample = RPSR_overlap_im2col(data_tmp, patch_size, overlap);
    random_F = randperm(size(data_sample,2));
    Y_tmp = data_sample(:,random_F(1:num_patch));
    Y_rgb = [Y_rgb, Y_tmp];
    
    data_pol = zeros(size(data_0,1),size(data_0,2),4);
    data_pol(1:4:end,1:4:end,1) = data_0(1:4:end,1:4:end,1);
    data_pol(1:4:end,2:4:end,1) = data_0(1:4:end,2:4:end,1);
    data_pol(2:4:end,1:4:end,1) = data_0(2:4:end,1:4:end,1);
    data_pol(2:4:end,2:4:end,1) = data_0(2:4:end,2:4:end,1);
    data_pol(1:4:end,3:4:end,1) = data_0(1:4:end,3:4:end,2);
    data_pol(1:4:end,4:4:end,1) = data_0(1:4:end,4:4:end,2);
    data_pol(2:4:end,3:4:end,1) = data_0(2:4:end,3:4:end,2);
    data_pol(2:4:end,4:4:end,1) = data_0(2:4:end,4:4:end,2);
    data_pol(3:4:end,1:4:end,1) = data_0(3:4:end,1:4:end,2);
    data_pol(3:4:end,2:4:end,1) = data_0(3:4:end,2:4:end,2);
    data_pol(4:4:end,1:4:end,1) = data_0(4:4:end,1:4:end,2);
    data_pol(4:4:end,2:4:end,1) = data_0(4:4:end,2:4:end,2);
    data_pol(3:4:end,3:4:end,1) = data_0(3:4:end,3:4:end,3);
    data_pol(3:4:end,4:4:end,1) = data_0(3:4:end,4:4:end,3);
    data_pol(4:4:end,3:4:end,1) = data_0(4:4:end,3:4:end,3);
    data_pol(4:4:end,4:4:end,1) = data_0(4:4:end,4:4:end,3);
    
    data_pol(1:4:end,1:4:end,2) = data_45(1:4:end,1:4:end,1);
    data_pol(1:4:end,2:4:end,2) = data_45(1:4:end,2:4:end,1);
    data_pol(2:4:end,1:4:end,2) = data_45(2:4:end,1:4:end,1);
    data_pol(2:4:end,2:4:end,2) = data_45(2:4:end,2:4:end,1);
    data_pol(1:4:end,3:4:end,2) = data_45(1:4:end,3:4:end,2);
    data_pol(1:4:end,4:4:end,2) = data_45(1:4:end,4:4:end,2);
    data_pol(2:4:end,3:4:end,2) = data_45(2:4:end,3:4:end,2);
    data_pol(2:4:end,4:4:end,2) = data_45(2:4:end,4:4:end,2);
    data_pol(3:4:end,1:4:end,2) = data_45(3:4:end,1:4:end,2);
    data_pol(3:4:end,2:4:end,2) = data_45(3:4:end,2:4:end,2);
    data_pol(4:4:end,1:4:end,2) = data_45(4:4:end,1:4:end,2);
    data_pol(4:4:end,2:4:end,2) = data_45(4:4:end,2:4:end,2);
    data_pol(3:4:end,3:4:end,2) = data_45(3:4:end,3:4:end,3);
    data_pol(3:4:end,4:4:end,2) = data_45(3:4:end,4:4:end,3);
    data_pol(4:4:end,3:4:end,2) = data_45(4:4:end,3:4:end,3);
    data_pol(4:4:end,4:4:end,2) = data_45(4:4:end,4:4:end,3);
    
    data_pol(1:4:end,1:4:end,3) = data_90(1:4:end,1:4:end,1);
    data_pol(1:4:end,2:4:end,3) = data_90(1:4:end,2:4:end,1);
    data_pol(2:4:end,1:4:end,3) = data_90(2:4:end,1:4:end,1);
    data_pol(2:4:end,2:4:end,3) = data_90(2:4:end,2:4:end,1);
    data_pol(1:4:end,3:4:end,3) = data_90(1:4:end,3:4:end,2);
    data_pol(1:4:end,4:4:end,3) = data_90(1:4:end,4:4:end,2);
    data_pol(2:4:end,3:4:end,3) = data_90(2:4:end,3:4:end,2);
    data_pol(2:4:end,4:4:end,3) = data_90(2:4:end,4:4:end,2);
    data_pol(3:4:end,1:4:end,3) = data_90(3:4:end,1:4:end,2);
    data_pol(3:4:end,2:4:end,3) = data_90(3:4:end,2:4:end,2);
    data_pol(4:4:end,1:4:end,3) = data_90(4:4:end,1:4:end,2);
    data_pol(4:4:end,2:4:end,3) = data_90(4:4:end,2:4:end,2);
    data_pol(3:4:end,3:4:end,3) = data_90(3:4:end,3:4:end,3);
    data_pol(3:4:end,4:4:end,3) = data_90(3:4:end,4:4:end,3);
    data_pol(4:4:end,3:4:end,3) = data_90(4:4:end,3:4:end,3);
    data_pol(4:4:end,4:4:end,3) = data_90(4:4:end,4:4:end,3);
    
    data_pol(1:4:end,1:4:end,4) = data_135(1:4:end,1:4:end,1);
    data_pol(1:4:end,2:4:end,4) = data_135(1:4:end,2:4:end,1);
    data_pol(2:4:end,1:4:end,4) = data_135(2:4:end,1:4:end,1);
    data_pol(2:4:end,2:4:end,4) = data_135(2:4:end,2:4:end,1);
    data_pol(1:4:end,3:4:end,4) = data_135(1:4:end,3:4:end,2);
    data_pol(1:4:end,4:4:end,4) = data_135(1:4:end,4:4:end,2);
    data_pol(2:4:end,3:4:end,4) = data_135(2:4:end,3:4:end,2);
    data_pol(2:4:end,4:4:end,4) = data_135(2:4:end,4:4:end,2);
    data_pol(3:4:end,1:4:end,4) = data_135(3:4:end,1:4:end,2);
    data_pol(3:4:end,2:4:end,4) = data_135(3:4:end,2:4:end,2);
    data_pol(4:4:end,1:4:end,4) = data_135(4:4:end,1:4:end,2);
    data_pol(4:4:end,2:4:end,4) = data_135(4:4:end,2:4:end,2);
    data_pol(3:4:end,3:4:end,4) = data_135(3:4:end,3:4:end,3);
    data_pol(3:4:end,4:4:end,4) = data_135(3:4:end,4:4:end,3);
    data_pol(4:4:end,3:4:end,4) = data_135(4:4:end,3:4:end,3);
    data_pol(4:4:end,4:4:end,4) = data_135(4:4:end,4:4:end,3);

    data_sample = RPSR_overlap_im2col(data_pol, patch_size, overlap);
    random_F = randperm(size(data_sample,2));
    Y_tmp = data_sample(:,random_F(1:num_patch));
    Y_pol = [Y_pol, Y_tmp];
end


%% learn dictionary by using K-SVD
MM = patch_size; NN = sqrt(dict_size);      
V = sqrt(2 / MM)*cos((0:MM-1)'*(0:NN-1)*pi/MM/2); 
V(1,:) = V(1,:) / sqrt(2);
DCT=kron(V,V); 
DCT_DOFP = repmat(DCT,4,1);
DCT_all = repmat(DCT,12,1);

%K-SVD to calculate dictionary and sparse code based on ground truth dataset
[M, N] = size(Y_pol);
params = {'reg', reg, 'vanish', vanish, 'regstop', regstop};

[Df_Y_pol, X_Y_b, errs] = DL(Y_pol, DCT_DOFP, s, iters_D, params{:}); 
fprintf('result_error: %3.4f/n',sum(sum(abs(Df_Y_pol*X_Y_b - Y_pol)))/(M*N));

[Df_Y_rgb, Xf, errs] = DL(Y_rgb, DCT_all, s, iters_D, params{:}); 
fprintf('result_error: %3.4f/n',sum(sum(abs(Df_Y_rgb*Xf - Y_rgb)))/(M*N*3));


save dic_JCPD.mat Df_Y_pol Df_Y_rgb


