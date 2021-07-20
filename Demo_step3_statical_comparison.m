clear; clc; close all; fclose all; warning off all
addpath(genpath('utils'));

method = {'SR_JCPD'};

average = fopen('result/results.txt','a+');
detail = fopen('result/detail.txt','a+');
fprintf(average,'%s %30s %40s %30s\n','method','psnr','color accuracy','ssim');
    
for index = 1:length(method)
    method_name = method{index};
    fprintf('processing: %s... \n',method_name);
    fprintf(detail,'---------------%s---------------\n', method_name);
    test_dir = ['result/' method_name];
    test = dir(fullfile(test_dir));
    file_num = (length(test)-2)/8;
    GT={file_num};
    Recon={file_num};
    index_GT=1;
    index_Recon=1;
    for i=1:length(test)
        name = test(i).name;
        if contains(name,'GT')
            GT{index_GT} = name;
            index_GT = index_GT+1;
        elseif contains(name,'Recon')
            Recon{index_Recon} = name;
            index_Recon = index_Recon+1;
        end 
    end

    
    peakpsnr = zeros(5,file_num+1);
    rgb_acc = zeros(5,file_num+1);
    peakssim = zeros(5,file_num+1);
    peakpsnr(1,1) = NaN;
    peakpsnr(2,1) = 0;
    peakpsnr(3,1) = 45;
    peakpsnr(4,1) = 90;
    peakpsnr(5,1) = 135;
    rgb_acc(1,1) = NaN;
    rgb_acc(2,1) = 0;
    rgb_acc(3,1) = 45;
    rgb_acc(4,1) = 90;
    rgb_acc(5,1) = 135;
    peakssim(1,1) = NaN;
    peakssim(2,1) = 0;
    peakssim(3,1) = 45;
    peakssim(4,1) = 90;
    peakssim(5,1) = 135;

    for k = 1:(length(test)-2)/8
        name = strsplit(test((k-1)*8+3).name,'-');
        name_string = name{1,1};
        
        fprintf('processing: %s.png... \n',name_string);
        peakpsnr(1, k+1) = str2num(name_string);
        rgb_acc(1, k+1) = str2num(name_string);
        peakssim(1, k+1) = str2num(name_string);
        dofp_gt_0 = double(imread(strcat([test_dir '/' name_string], '-GT_0.png')));
        dofp_gt_45 = double(imread(strcat([test_dir '/' name_string], '-GT_45.png')));
        dofp_gt_90 = double(imread(strcat([test_dir '/' name_string], '-GT_90.png')));
        dofp_gt_135 = double(imread(strcat([test_dir '/' name_string], '-GT_135.png')));

        recon0 = double(imread(strcat([test_dir '/' name_string], '-Recon_0.png')));
        recon45 = double(imread(strcat([test_dir '/' name_string], '-Recon_45.png')));
        recon90 = double(imread(strcat([test_dir '/' name_string], '-Recon_90.png')));
        recon135 = double(imread(strcat([test_dir '/' name_string], '-Recon_135.png')));

        peakpsnr(2, k+1) = psnr(dofp_gt_0/255, recon0/255);
        peakpsnr(3, k+1) = psnr(dofp_gt_45/255, recon45/255);
        peakpsnr(4, k+1) = psnr(dofp_gt_90/255, recon90/255);
        peakpsnr(5, k+1) = psnr(dofp_gt_135/255, recon135/255);

        rgb_acc(2, k+1) = color_accuracy(dofp_gt_0/255, recon0/255);
        rgb_acc(3, k+1) = color_accuracy(dofp_gt_45/255, recon45/255);
        rgb_acc(4, k+1) = color_accuracy(dofp_gt_90/255, recon90/255);
        rgb_acc(5, k+1) = color_accuracy(dofp_gt_135/255, recon135/255);

        peakssim(2, k+1) = ssim(dofp_gt_0/255, recon0/255);
        peakssim(3, k+1) = ssim(dofp_gt_45/255, recon45/255);
        peakssim(4, k+1) = ssim(dofp_gt_90/255, recon90/255);
        peakssim(5, k+1) = ssim(dofp_gt_135/255, recon135/255);
        
    end

    fprintf(detail,'----------------PSNR---------------\n');
    [b1 b2]=size(peakpsnr);
    for i=1:b1
        for j=1:b2
            fprintf(detail,'%10.3f',peakpsnr(i,j));
        end
        fprintf(detail,'\n');
    end
    
    fprintf(detail,'----------------SSIM---------------\n');
    [b1 b2]=size(rgb_acc);
    for i=1:b1
        for j=1:b2
            fprintf(detail,'%10.3f',peakssim(i,j));
        end
        fprintf(detail,'\n');
    end

    fprintf(detail,'----------------Color Accuracy---------------\n');
    [b1 b2]=size(peakssim);
    for i=1:b1
        for j=1:b2
            fprintf(detail,'%10.3f',rgb_acc(i,j));
        end
        fprintf(detail,'\n');
    end
    fprintf(detail,'\n');
    fprintf(detail,'\n');


    psnr_value = peakpsnr(2:end,2:end);
    aver_psnr = mean(psnr_value(:));
    ssim_value = peakssim(2:end,2:end);
    aver_ssim = mean(ssim_value(:));
    ca_value = rgb_acc(2:end,2:end);
    aver_rgb_acc = mean(ca_value(:));

    
    fprintf(average,'%s %30.3f %40.3f %30.3f\n',method_name,aver_psnr,aver_rgb_acc,aver_ssim);
end
fclose(average);
fclose(detail);


