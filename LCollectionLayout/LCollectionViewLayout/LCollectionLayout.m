//
//  LCollectionLayout.m
//  LCollectionLayout
//
//  Created by 俊杰  廖 on 2017/3/2.
//  Copyright © 2017年 俊杰  廖. All rights reserved.
//

#import "LCollectionLayout.h"

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height

@interface LCollectionLayout()
@property (nonatomic, assign) NSInteger colCount;
@property (nonatomic, assign) NSInteger colMargin;
@property (nonatomic, assign) NSInteger rolMargin;

@property (nonatomic, assign) CGFloat colWidth; //item的宽度
@property (nonatomic, strong) NSMutableArray *colsHeight; //每列的总高度
@end

@implementation LCollectionLayout

- (instancetype)initCollectionLayoutWithColCount:(NSInteger)colCount colMargin:(NSInteger)colMargin rolMargin:(NSInteger)rolMargin itemHeightBlock:(itemHeight)itemHeightBlock
{
    self = [super init];
    if (self) {
        self.colCount = colCount;
        self.rolMargin = rolMargin;
        self.colMargin = colMargin;
        self.heightBlock = itemHeightBlock;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.colWidth = (ScreenWidth - (self.colCount-1)*self.colMargin)/self.colCount;
    self.colsHeight = nil;
}

- (CGSize)collectionViewContentSize
{
    NSNumber *longest = self.colsHeight.firstObject;
    for (int i=0; i<self.colsHeight.count; ++i) {
        if (longest.floatValue < [self.colsHeight[i] floatValue]) {
            longest = self.colsHeight[i];
        }
    }
    return CGSizeMake(self.collectionView.frame.size.width, [longest floatValue]);;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSNumber *shortest = self.colsHeight.firstObject;
    NSInteger shortCol = 0;
    for (int i=0; i<self.colsHeight.count; ++i) {
        if (shortest.floatValue > [self.colsHeight[i] floatValue] ) {
            shortest = self.colsHeight[i];
            shortCol = i;
        }
    }
    CGFloat x = shortCol * (self.colWidth+self.colMargin);
    CGFloat y = shortest.floatValue + self.rolMargin;
    
    //获取item的高度
    CGFloat height = 0;
    if (self.heightBlock) {
        height = self.heightBlock(indexPath);
    }
    attr.frame = CGRectMake(x, y, self.colWidth, height);
    self.colsHeight[shortCol] = @(shortest.floatValue + height + self.rolMargin);
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attrArr = [NSMutableArray arrayWithCapacity:0];
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    for (int i=0; i<items; ++i) {
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [attrArr addObject:attr];
    }
    return attrArr;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (NSMutableArray *)colsHeight {
    if (!_colsHeight) {
        _colsHeight = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<self.colCount; ++i) {
            //这里初始化每列的高度
            [_colsHeight addObject:@(0)];
        }
    }
    return _colsHeight;
}


@end
