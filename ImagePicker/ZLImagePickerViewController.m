//
//  ZLImagePickerViewController.m
//  ImagePicker
//
//  Created by foreveross－bj on 14-8-12.
//  Copyright (c) 2014年 foreveross－bj. All rights reserved.
//

#import "ZLImagePickerViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ZLImagePickerViewController ()
{
    UIActionSheet *actionSheet;
    UIImagePickerController *imagePicker;
    IBOutlet UIImageView *imageView;
}

@end

@implementation ZLImagePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)doPicker:(id)sender {
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"选取照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"拍照", nil];
    [actionSheet showInView:self.view];
}
- (IBAction)save:(id)sender {
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    if (buttonIndex == 1) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        imagePicker.showsCameraControls = YES;
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        imagePicker.mediaTypes = @[(NSString*)kUTTypeImage,(NSString*)kUTTypeMovie];
//        imagePicker.allowsEditing = YES;
//        imagePicker.showsCameraControls = YES;

        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doPicker:)];
    [imageView addGestureRecognizer:tapGesture];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获取照片的原图
    UIImage *original = [info objectForKey:UIImagePickerControllerOriginalImage];
    //获取图片裁剪后剩下的图
    UIImageView.image = original;
    
    UIImage *edit = [info objectForKey:UIImagePickerControllerEditedImage];
    //获取图片的url
    NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
    //获取图片的metadata数据信息
    NSLog(@"%@", url);
    NSDictionary* metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
    //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
    UIImageWriteToSavedPhotosAlbum(edit, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSLog(@"%@", data);
    imageView.image = original;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    
    NSLog(@"saved..");
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
