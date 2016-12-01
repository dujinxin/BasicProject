//
//  GuiderViewFlowLayout.m
//  GJieGo
//
//  Created by dujinxin on 16/5/13.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "GuiderViewFlowLayout.h"


@interface GuiderViewFlowLayout()

//用来保存所有item
@property(nonatomic,strong)NSMutableArray *attrArray;

//用来保存每列最大Y值
@property(nonatomic,strong)NSMutableDictionary *maxYDict;

@end

@implementation GuiderViewFlowLayout


#pragma mark -- 实现瀑布流功能方法

//当collectionView第一次要显示的时候会调用此方法来准备布局。
//当collectionView的布局发生变化时，也会来调用此方法。
//当刷新数据时，也会调用此方法。

//在这个方法中计算每一个cell的位置大小(frame)
- (void)prepareLayout{
    [super prepareLayout];
    
    //字典列值初始化   解决了 每次获取字典中最小值得问题。
    for(int i = 0;i<self.columnCount;i++){
        NSString *key = [NSString stringWithFormat:@"%f",(CGFloat)i];
        self.maxYDict[key] = [NSString stringWithFormat:@"%f",self.sectionInset.top];
    }
    
    //需要先移除数组中的数据
    [self.attrArray removeAllObjects];
    
    //遍历数据源数组
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    //需要自己调用
    for(int i = 0;i<count;i++){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrArray addObject:attrs];
    }
    
    
    //添加底部视图frame
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];    UICollectionViewLayoutAttributes *footer = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
    NSString *maxKey = [self maxColumn];
    footer.frame = CGRectMake(0, [self.maxYDict[maxKey] floatValue], self.collectionView.bounds.size.width, self.footerReferenceSize.height);
    [self.attrArray addObject:footer];
}

//设置collectionView的可滚动区域的大小。也就是内容大小
- (CGSize)collectionViewContentSize{
    // return [super collectionViewContentSize];
    //返回字典中最大Y值
    NSString *maxKey = [self maxColumn];
    // return CGSizeMake(0, [self.maxYDict[maxKey] floatValue]);
    return CGSizeMake(0, [self.maxYDict[maxKey] floatValue] + self.footerReferenceSize.height);
}

//返回每一个子控件(也就是cell)在collectionView的显示区域内的位置大小
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    // return [super layoutAttributesForElementsInRect:rect];
    return self.attrArray;
}

//返回某一个指定cell的属性  默认不会被调用  需要在 prepareLayout 方法中调用
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat contentWidth = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1) * self.minimumInteritemSpacing;
    
    CGFloat cellW = contentWidth / self.columnCount;
    
    //高度计算方法  假设:image高 * cellW / image宽  也就是求一个比例
    // Goods *goods = self.dataList[i];
    // CGFloat cellH = goods.height * cellW / goods.width;
    CGFloat cellH = [self.delegate waterFlow:self itemWidth:cellW cellIndexPath:indexPath];
    
    
    //X位置 计算方法
    //要求出当前cell是哪一列，然后加上间距和边距就可以了
    // CGFloat col = i % self.columnCount;
    CGFloat col = [[self minColumn] floatValue];
    CGFloat cellX = (cellW + self.minimumInteritemSpacing) * col + self.sectionInset.left;
    
    //Y位置 计算方法
    //需要知道 每一列的上一个Cell的最大Y值
    //解决方式：需要一个保存每列
    NSString *colStr = [NSString stringWithFormat:@"%f",col];
    NSString *maxY = self.maxYDict[colStr];
    CGFloat cellY = [maxY floatValue];
    
    //对每列的最大值Y重新赋值
    CGFloat nextMaxY = [maxY floatValue] + cellH + self.minimumLineSpacing;
    self.maxYDict[colStr] = [NSString stringWithFormat:@"%f",nextMaxY];
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attrs.frame = CGRectMake(cellX, cellY, cellW, cellH);
    NSLog(@"%@",attrs);
    return attrs;
    
}

#pragma mark -- 懒加载

- (NSMutableArray *)attrArray{
    if(_attrArray == nil){
        _attrArray = [NSMutableArray array];
    }
    return _attrArray;
}

- (NSMutableDictionary *)maxYDict{
    if(_maxYDict == nil){
        _maxYDict = [NSMutableDictionary dictionary];
    }
    return _maxYDict;
}

#pragma mark -- 求字典中的最大值 和 最小值的 key

//字典中的最大值
- (NSString *)maxColumn{
    __block NSString *maxKey = [NSString stringWithFormat:@"%f",0.0];
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        if([self.maxYDict[maxKey] floatValue] < [value floatValue]){
            maxKey = key;
        }
        // NSLog(@"%@ - %@",key,value);
    }];
    return maxKey;
}

//字典中的最小值
- (NSString *)minColumn{
    //为了严谨 ，要采用这种方式
    __block NSString *minKey = [NSString stringWithFormat:@"%f",0.0];
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        if([self.maxYDict[minKey] floatValue] > [value floatValue]){
            minKey = key;
        }
    }];
    return minKey;
}

@end
