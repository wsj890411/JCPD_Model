clear; clc; close all; fclose all; warning off all
addpath(genpath('utils'));

%% ARGUMENTS
arg.patch_size  = 4;         
arg.overlap     = 4;
arg.reg         = 0.1;        % regularization
arg.max_iter    = 200;
arg.vanish      = 0.95;          % regularization vanishing factor
arg.regstop     = inf;         % cancel regularization term starting with this iteration
arg.iters_D       = 50;         % DL iterations 
arg.iters_C       = 50;         % DL iterations
arg.s           = 8;
arg.dict_size   = 256;        % dictionary size
load('dic_JCPD.mat');
arg.Df_Y_pol = Df_Y_pol;
arg.Df_Y_rgb = Df_Y_rgb;
lambda_hub  = repmat(0.95, [12 1]); 
rho_hub     = repmat(0.05, [12 1]);  
delta = repmat(0.001, [12 1]);  
%% optimization 
mosaic = dir(fullfile('test_dataset'));
file_num = length(mosaic)-2;
peaksnr = zeros(4,file_num);
rgb_acc = zeros(4,file_num);
name = cell(4,file_num);
tol = 1e-4;  
chg = 0.5;
maxiter = 30;

for k = 3:length(mosaic)
    fprintf('image_processing: %d... \n',k-2);

    dofp_gt_0 = im2double(imread(strcat('test_dataset/', mosaic(k).name, '/gt_0/',mosaic(k).name, '.png')));
    dofp_gt_45 = im2double(imread(strcat('test_dataset/', mosaic(k).name, '/gt_45/',mosaic(k).name, '.png')));
    dofp_gt_90 = im2double(imread(strcat('test_dataset/', mosaic(k).name, '/gt_90/',mosaic(k).name, '.png')));
    dofp_gt_135 = im2double(imread(strcat('test_dataset/', mosaic(k).name, '/gt_135/',mosaic(k).name, '.png')));
    dofp = im2double( imread(strcat('test_dataset/', mosaic(k).name, '/net_input/',mosaic(k).name, '.png')));
        
    [rows,cols] = size(dofp);
    I = dofp(:);
    initialization = initial(dofp);
    [Mosaic_pol, Mosac_RGB] = Generate_MosicMatrix_v2(rows, cols);
    RP_k = initialization(:);
    RC_k = initialization(:);
    RP = reshape(RP_k,rows,cols,12);
    RC = reshape(RC_k,rows,cols,12);
    P = UpdateP(RP, arg);
    C = UpdateC(RC, arg);
    R = Update_total(I, P, C, rows, Mosaic_pol, Mosac_RGB);
    Results = reshape(R,rows,cols,12);
    
    mkdir('result/SR_JCPD/');
    imwrite(Results(:,:,1:3),strcat('result/SR_JCPD/', [mosaic(k).name '-' 'Recon_0.png']));
    imwrite(Results(:,:,4:6),strcat('result/SR_JCPD/',  [mosaic(k).name '-' 'Recon_45.png']));
    imwrite(Results(:,:,7:9),strcat('result/SR_JCPD/',  [mosaic(k).name '-' 'Recon_90.png']));
    imwrite(Results(:,:,10:12),strcat('result/SR_JCPD/',  [mosaic(k).name '-' 'Recon_135.png']));

    imwrite(dofp_gt_0,strcat('result/SR_JCPD/',  [mosaic(k).name '-' 'GT_0.png']));
    imwrite(dofp_gt_45,strcat('result/SR_JCPD/',  [mosaic(k).name '-' 'GT_45.png']));
    imwrite(dofp_gt_90,strcat('result/SR_JCPD/',  [mosaic(k).name '-' 'GT_90.png']));
    imwrite(dofp_gt_135,strcat('result/SR_JCPD/',  [mosaic(k).name '-' 'GT_135.png']));
    
end