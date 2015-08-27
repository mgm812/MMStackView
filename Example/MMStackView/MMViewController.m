//
//  MMViewController.m
//  MMStackView
//
//  Created by mmy on 08/27/2015.
//  Copyright (c) 2015 mmy. All rights reserved.
//

#import "MMViewController.h"
#import "MMStackView.h"
#import "MMStackCell.h"
#import "UIColor+CatColors.h"

@interface MMViewController ()<MMStackViewDataSource, MMStackViewDelegate>

@property (nonatomic, weak) MMStackView *   stackView;

@end

@implementation MMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    MMStackView *   stackView;
    stackView                   = [[MMStackView alloc] initWithFrame:self.view.bounds
                                                               style:MMStackViewStylePlain];
    stackView.backgroundColor   = [UIColor clearColor];
    stackView.dataSource        = self;
    stackView.delegate          = self;
    stackView.layer.borderWidth = 1;
    stackView.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:stackView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark CMBStackViewDataSource

- (NSInteger)numberOfCellsInStackView:(MMStackView *)stackView
{
    return 20;
}

- (MMStackCell *)stackView:(MMStackView *)stackView cellForRowAtIndex:(NSInteger)index
{
    MMStackCell *           cell;
    cell                    = [[MMStackCell alloc] initWithStyle:MMStackCellStyleDefault];
    cell.backgroundColor    = [UIColor getRandomColor];
    return cell;
}

#pragma mark -
#pragma mark CMBStackViewDelegate

- (void)stackView:(MMStackView *)stackView didSelectRowAtIndex:(NSInteger)index
{
    if (stackView.scrollEnabled) {
        [stackView transformOpenCardWithIndex:index];
    }
    else {
        [stackView transformCloseCardWithIndex:index];
    }
}

- (CGFloat)stackView:(MMStackView *)stackView heightForRowAtIndex:(NSInteger)index
{
    return 350;
}

@end
