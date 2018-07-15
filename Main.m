msg_img=imread('msg.bmp');
figure;
imshow(msg_img,[]);
title('Original Message/Watermark');

% Using XOR for Encryption
key=imread('key.bmp');
key2=imread('key2.bmp');
msg_img=xor(msg_img,key);
msg_img=xor(msg_img,key2);


% Embedding the Watermark
msg_img=im2double(msg_img);
host_img=imread('host.png');
host_img = rgb2gray(host_img);
[cA cH cV cD]=dwt2(host_img,'db1');
[Uh Sh Vh]=svd(cD);
[Um Sm Vm]=svd(msg_img);
[w h]=size(Sm);
for i=1:w
   Sh(i,i)=0.3*Sm(i,i);      
end
cD=Uh*Sh*(Vh.');
host_img=idwt2(cA,cH,cV,cD,'db1');

% Altering the watermarked image
figure;
subplot(1,2,1);
imshow(host_img,[]);
title('Watermarked Image');
host_img = imrotate(host_img,20);
subplot(1,2,2);
imshow(host_img,[]);
title('Altered Watermarked Image');

%  Extracting the Watermark
[cA cH cV cD]=dwt2(host_img,'db1');
[Uh Sh Vh]=svd(cD);
[w h]=size(Um);
for i=1:w
   Sm(i,i)=Sh(i,i);
end
msg_img=Um*Sm*(Vm.');
msg_img=im2uint8(msg_img);


% Using XOR for Decryption
msg_img=xor(msg_img,key);
msg_img=xor(msg_img,key2);
figure;
imshow(msg_img,[]);
title('Altered Message/Watermark');