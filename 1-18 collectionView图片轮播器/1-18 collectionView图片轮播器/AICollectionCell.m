//
//  AICollectionCell.m
//  1-18 collectionView图片轮播器
//
//  Created by apple on 15-1-18.
//  Copyright (c) 2015年 Ai. All rights reserved.
//

#import "AICollectionCell.h"

@interface AICollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end
@implementation AICollectionCell
- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    self.iconView.image = [UIImage imageWithData:data];
}



@end
