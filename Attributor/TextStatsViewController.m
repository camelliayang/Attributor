//
//  TextStatsViewController.m
//  Attributor
//
//  Created by yanglu on 2/14/15.
//  Copyright (c) 2015 _Camellia_. All rights reserved.
//

#import "TextStatsViewController.h"

@interface TextStatsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *colorfulCharactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *outlinedCharactersLabel;

@end

@implementation TextStatsViewController
- (void)setTextToAnalyze:(NSAttributedString *)textToAnalyze
{
    _textToAnalyze = textToAnalyze;
    //If the window is nil, means the scene hasn't appeared. If not appeared, updateUI. Else the viewWillAppear will update UI.
    if (self.view.window) [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}
//The method below is a sample about how to do test. Need to move the start arrow in storyboard to this view and then test.
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.textToAnalyze = [[NSAttributedString alloc] initWithString:@"text" attributes:@{NSForegroundColorAttributeName: [UIColor greenColor], NSStrokeWidthAttributeName: @-3}];
//}

- (void)updateUI
{
    self.colorfulCharactersLabel.text = [NSString  stringWithFormat:@"%d colorful characters", [[self characterWithAttribute:NSForegroundColorAttributeName] length]];
    self.outlinedCharactersLabel.text = [NSString  stringWithFormat:@"%d outlined characters", [[self characterWithAttribute:NSStrokeWidthAttributeName] length]];
}

- (NSAttributedString *)characterWithAttribute: (NSString *)attributeName
{
    NSMutableAttributedString *characters = [[NSMutableAttributedString alloc] init];
    int index = 0;
    while (index < [self.textToAnalyze length]) {
        NSRange range;
        id value = [self.textToAnalyze attribute:attributeName atIndex:index effectiveRange:&range];
        //If the characters are set, the value will have things(bold/green/...).
        if (value) {
            [characters appendAttributedString:[self.textToAnalyze attributedSubstringFromRange:range]];
            index = range.location + range.length;
        }
        else {
            index++;
        }
    }
    return characters;
}


@end
