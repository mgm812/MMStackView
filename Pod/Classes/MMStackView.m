//
//  MMStackView.m
//  Pods
//
//  Created by mmy on 8/26/15.
//
//

#import "MMStackView.h"
#import "MMStackCell.h"

#define kRevealHeight       54
#define kBottomRevealHeight 50

@interface MMStackView ()<UIGestureRecognizerDelegate>

@property (nonatomic)           NSInteger           numberOfCells;
@property (nonatomic)           NSInteger           numberOfCellsOfPerPage;
@property (nonatomic)           NSInteger           numberOfPages;
@property (nonatomic, strong)   NSMutableArray *    stackCells;
@property (nonatomic)           NSInteger           currentSelectedIndex;
@property (nonatomic, weak)     UIControl *         bottomStack;

@end

@implementation MMStackView

@dynamic delegate;

- (NSMutableArray *)stackCells {
    if (!_stackCells) {
        _stackCells = [NSMutableArray array];
    }
    return _stackCells;
}

- (instancetype)initWithFrame:(CGRect)frame style:(MMStackViewStyle)style {
    self    = [super initWithFrame:frame];
    if (self) {
        switch (style) {
            case MMStackViewStylePlain: {
                self.pagingEnabled                  = YES;
                self.showsHorizontalScrollIndicator = NO;
                self.showsVerticalScrollIndicator   = NO;
                self.scrollsToTop                   = NO;
                self.bounces                        = NO;
                [self performSelector:@selector(reloadData) withObject:nil afterDelay:0];
                break;
            }
            default:
                break;
        }
    }
    return self;
}

- (void)layoutSubviews {
//    dummy
}

- (void)reloadData {
    // 获取总cell个数
    self.numberOfCells  = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfCellsInStackView:)]) {
        self.numberOfCells  = [self.dataSource numberOfCellsInStackView:self];
    }
    // 计算每页cell个数
    self.numberOfCellsOfPerPage = floor(self.bounds.size.height / kRevealHeight);
    // 计算页数
    self.numberOfPages          = floor(self.numberOfCells / self.numberOfCellsOfPerPage) + 1;
    if (self.numberOfCells == 0) return;
    [self.stackCells removeAllObjects];
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger i = 0; i < self.numberOfCells; i++) {
        id stackCell;
        if ([self.dataSource respondsToSelector:@selector(stackView:cellForRowAtIndex:)]) {
            stackCell   = [self.dataSource stackView:self cellForRowAtIndex:i];
            [self.stackCells addObject:stackCell];
        }
        else {
            break;
        }
    }

    NSInteger i = 0;
    CGRect frame    = CGRectMake(0, 0, self.bounds.size.width, 0);
    for (MMStackCell * cell in self.stackCells) {
        NSInteger cellHeight    = 0;
        if ([self.delegate respondsToSelector:@selector(stackView:heightForRowAtIndex:)]) {
            cellHeight          = [self.delegate stackView:self heightForRowAtIndex:i];
        }
        frame.size.height       = cellHeight;
        frame.origin.y          = (kRevealHeight * [self rowIndexOfCurrentPageWithTotalIndex:i]
                                   + self.bounds.size.height * ([self currentPageWithTotalIndex:i] - 1));
        cell.frame              = frame;
        cell.tag                = i;
        [self addSubview:cell];
        UITapGestureRecognizer *    tapGesture;
        tapGesture                  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        tapGesture.delegate         = self;
        [cell addGestureRecognizer:tapGesture];
        i++;
    }
    
    self.contentSize    = CGSizeMake(self.bounds.size.width, self.bounds.size.height * self.numberOfPages);
}

- (NSInteger)rowIndexOfCurrentPageWithTotalIndex:(NSInteger)index {
    NSInteger humanIndex    = (index + 1) % self.numberOfCellsOfPerPage;
    if (humanIndex == 0) humanIndex = self.numberOfCellsOfPerPage;
    return humanIndex - 1;
}

- (NSInteger)currentPageWithTotalIndex:(NSInteger)index {
    NSInteger page      = (index +1) / self.numberOfCellsOfPerPage;
    NSInteger remainder = (index +1) % self.numberOfCellsOfPerPage;
    if (remainder != 0) {
        page += 1;
    }
    return page;
}

/**
 *  当前页的所有cells
 *
 *  @param index 总索引值
 *
 *  @return 返回当前页的所有cells
 */
- (NSArray *)cellsOfCurrentPageWithTotalIndex:(NSInteger)index {
    NSMutableArray * array              = [NSMutableArray array];
    NSInteger page                      = [self currentPageWithTotalIndex:index];
    NSInteger numberOfCellsOfLastPage   = self.numberOfCells % self.numberOfCellsOfPerPage;
    if (page * self.numberOfCellsOfPerPage > self.numberOfCells) {
        for (NSInteger i = 0; i < numberOfCellsOfLastPage; i++) {
            [array addObject:self.stackCells[self.numberOfCellsOfPerPage * (page - 1) + i]];
        }
    }
    else {
        for (NSInteger i = 0; i < self.numberOfCellsOfPerPage; i++) {
            [array addObject:self.stackCells[self.numberOfCellsOfPerPage * (page - 1) + i]];
        }
    }
    return [array copy];
}

- (void)transformOpenCardWithIndex:(NSInteger)index {
    if (!self.scrollEnabled) return;
    NSInteger page  = [self currentPageWithTotalIndex:index];
    NSArray * cells = [self cellsOfCurrentPageWithTotalIndex:index];
    [UIView animateWithDuration:0.3 animations:^{
        NSInteger currentPageIndex  = 0;
        NSInteger stackPageIndex    = 0;
        NSInteger stackRevealHeight = floor(kBottomRevealHeight / ([cells count] - 1));
        for (MMStackCell * cell in cells) {
            if (cell.tag == index) {
                cell.transform      = CGAffineTransformMakeTranslation(0, - kRevealHeight * currentPageIndex);
            }
            else {
                NSInteger startY    = (self.bounds.size.height
                                       - (cell.frame.origin.y - (page - 1) * self.bounds.size.height)
                                       - 50);
                cell.transform      = CGAffineTransformMakeTranslation(0, startY + stackRevealHeight * stackPageIndex);
                stackPageIndex++;
            }
            currentPageIndex++;
        }
    } completion:^(BOOL finished) {
        [self.bottomStack removeFromSuperview];
        self.scrollEnabled  = NO;
        // add bottom stack
        CGRect          frame;
        UIControl *     bottomStack;
        frame           =  CGRectMake(0,
                                      self.bounds.size.height * page - kBottomRevealHeight,
                                      self.bounds.size.width,
                                      kBottomRevealHeight);
        bottomStack     = [[UIControl alloc] initWithFrame:frame];
        [bottomStack addTarget:self
                        action:@selector(bottomStackAction:)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bottomStack];
        self.bottomStack    = bottomStack;
    }];
}

- (void)transformCloseCardWithIndex:(NSInteger)index {
    if (self.scrollEnabled) return;
    NSArray * cells = [self cellsOfCurrentPageWithTotalIndex:index];
    [UIView animateWithDuration:0.3 animations:^{
        for (MMStackCell * cell in cells) {
            cell.transform  = CGAffineTransformMakeTranslation(0, 0);
        }
    } completion:^(BOOL finished) {
        [self.bottomStack removeFromSuperview];
        self.bottomStack    = nil;
        self.scrollEnabled  = YES;
    }];
}

#pragma mark -
#pragma mark Target action

- (void)tapGestureAction:(UIGestureRecognizer *)sender {
    MMStackCell * cell = (MMStackCell *)sender.view;
    self.currentSelectedIndex   = cell.tag;
    if ([self.delegate respondsToSelector:@selector(stackView:didSelectRowAtIndex:)]) {
        [self.delegate stackView:self didSelectRowAtIndex:cell.tag];
    }
}

- (void)bottomStackAction:(UIControl *)sender {
    [self transformCloseCardWithIndex:self.currentSelectedIndex];
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

@end
