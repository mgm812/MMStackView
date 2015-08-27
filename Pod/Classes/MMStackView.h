//
//  MMStackView.h
//  Pods
//
//  Created by mmy on 8/26/15.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MMStackViewStyle) {
    MMStackViewStylePlain
};

@class MMStackCell, MMStackView;



@protocol MMStackViewDataSource <NSObject>

@required
- (NSInteger)numberOfCellsInStackView:(MMStackView *)stackView;
- (MMStackCell *)stackView:(MMStackView *)stackView cellForRowAtIndex:(NSInteger)index;

@end



@protocol MMStackViewDelegate <NSObject, UIScrollViewDelegate>

@optional
- (void)stackView:(MMStackView *)stackView didSelectRowAtIndex:(NSInteger)index;
- (CGFloat)stackView:(MMStackView *)stackView heightForRowAtIndex:(NSInteger)index;

@end



@interface MMStackView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame style:(MMStackViewStyle)style;

@property (nonatomic, weak)     id<MMStackViewDataSource>  dataSource;
@property (nonatomic, weak)     id<MMStackViewDelegate>    delegate;

- (void)reloadData;
- (void)transformOpenCardWithIndex:(NSInteger)index;
- (void)transformCloseCardWithIndex:(NSInteger)index;

@end
