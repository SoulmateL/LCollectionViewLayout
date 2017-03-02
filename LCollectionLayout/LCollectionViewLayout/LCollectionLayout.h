//
//  LCollectionLayout.h
//  LCollectionLayout
//
//  Created by 俊杰  廖 on 2017/3/2.
//  Copyright © 2017年 俊杰  廖. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef CGFloat(^itemHeight)(NSIndexPath *indexPath);

@interface LCollectionLayout : UICollectionViewLayout
@property (nonatomic, strong) itemHeight heightBlock;

/**
 重写layout的初始化方法

 @param colCount 列数
 @param colMargin item左右间隔
 @param rolMargin item上下间隔
 @param itemHeightBlock 获取每个item高度的block
 @return nil
 */
- (instancetype)initCollectionLayoutWithColCount:(NSInteger)colCount colMargin:(NSInteger)colMargin rolMargin:(NSInteger)rolMargin itemHeightBlock:(itemHeight)itemHeightBlock;

/**
 完成布局前的初始工作
 */
- (void)prepareLayout;


/**
 collectionView的内容尺寸
 */
- (CGSize)collectionViewContentSize;

/**
 重新设置没得item的属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 获取指定范围的所有item的属性数组
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;

/**
 视图位置有新改变(发生移动)时调用,其若返回YES则重新布局
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;

@end
