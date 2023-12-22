//
//  DemoActionCollectionViewCell.m
//  JtlyDemo
//
//  Created by WakeyWoo on 2019/12/4.
//  Copyright © 2019 JTLY. All rights reserved.
//

#import "JtlyDemoActionCollectionViewCell.h"

@interface JtlyDemoActionCollectionViewCell ()

@end
@implementation JtlyDemoActionCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [UILabel new];
        _titleLabel.frame = self.contentView.frame;
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _titleLabel.font = [UIFont systemFontOfSize:19.0];
        _titleLabel.backgroundColor = UIColor.greenColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)prepareForReuse
{
    [super prepareForReuse];
//    _titleLabel = [UILabel new];
//    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    _titleLabel.font = [UIFont systemFontOfSize:19.0];
//    _titleLabel.backgroundColor = UIColor.greenColor;
//    [self.contentView addSubview:_titleLabel];
    
}

@end
