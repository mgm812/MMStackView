//
//  MMStackCell.h
//  Pods
//
//  Created by mmy on 8/26/15.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MMStackCellStyle) {
    MMStackCellStyleDefault
};

@interface MMStackCell : UIView

- (instancetype)initWithStyle:(MMStackCellStyle)style;

@end
