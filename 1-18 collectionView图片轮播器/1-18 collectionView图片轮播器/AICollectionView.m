//
//  AICollectionView.m
//  1-18 collectionView图片轮播器
//
//  Created by apple on 15-1-18.
//  Copyright (c) 2015年 Ai. All rights reserved.
//
#import "AICollectionCell.h"
#import "AICollectionView.h"
@interface AICollectionView()
@property (nonatomic,strong) NSArray *imageURL;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionOutlet;
@property (nonatomic,strong) NSTimer *time;

@property (nonatomic,assign) NSUInteger page;
@end
@implementation AICollectionView

- (NSArray *)imageURL
{
    if (_imageURL == nil)
    {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 1; i < 11; i++)
        {
            NSString *urlName = [NSString stringWithFormat:@"%02d.jpg",i];
            NSURL *url = [[NSBundle mainBundle] URLForResource:urlName withExtension:nil] ;
            [tempArray addObject:url];
        }
        _imageURL = [tempArray copy];
    }
    return _imageURL;
}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.collectionOutlet.itemSize = [UIScreen mainScreen].bounds.size;
//    self.collectionOutlet.itemSize = self.view.frame.size;
//    self.collectionOutlet.minimumLineSpacing = 0;
//    self.collectionOutlet.minimumInteritemSpacing = 0;
//    
//    self.collectionView.pagingEnabled = YES;
//    self.collectionView.showsHorizontalScrollIndicator = NO;
//    self.collectionView.showsVerticalScrollIndicator = NO;
//    
//    // 开始显示的时候，将第一页放在中间显示，第0页在左，第2页在右
//    NSIndexPath *index = [NSIndexPath indexPathForItem:1 inSection:0];
//    [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:nil];
//    
//}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

//    self.collectionOutlet.itemSize = [UIScreen mainScreen].bounds.size;
//    
//    NSLog(@"screen %@",NSStringFromCGRect( [UIScreen mainScreen].bounds));
//        NSLog(@"view %@",NSStringFromCGRect( self.view.frame));
    
    self.collectionOutlet.itemSize = self.view.frame.size;
    self.collectionOutlet.minimumLineSpacing = 0;
    self.collectionOutlet.minimumInteritemSpacing = 0;
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    
    
    // 开始显示的时候，将第一页放在中间显示，第0页在左，第2页在右
    NSIndexPath *index = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    self.page = 0;
    
    [self addtime];
    
}

- (void)addtime
{
    self.time = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.time forMode:NSRunLoopCommonModes];
}
- (void)nextImage
{
    NSIndexPath *index = [[self.collectionView indexPathsForVisibleItems] lastObject];
//    NSLog(@"%d",index.item +1 );

    // 这样实现会导致最后一张图片飞快换到第一张
//    if (index.item == 9) {
//        index = [NSIndexPath indexPathForItem:1 inSection:0];
//        NSLog(@"----xiugaihou ------%ld",index.item +1 );
//    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index.item + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    // 上面collectionView的动画是0.25S，我们的操作一定要等动画结束后才能执行，所以延迟0.3S
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollViewDidEndDecelerating:self.collectionView];
    });
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageURL.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AICollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    NSInteger index = (self.page + indexPath.item -1 + self.imageURL.count) % self.imageURL.count;
    cell.imageURL = self.imageURL[index];
    return cell;
}
// 当停止拖拽时，会调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 将当前页数记录
    int offset = (scrollView.contentOffset.x / scrollView.bounds.size.width);
//    NSLog(@"%d",offset);
    
    self.page = (self.page + offset - 1 + self.imageURL.count) % self.imageURL.count;
    
    // 将中间的ImageView显示到屏幕上。
    NSIndexPath *index = [NSIndexPath indexPathForItem:1 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

}


@end
