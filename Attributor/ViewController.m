//
//  ViewController.m
//  Attributor
//
//  Created by yanglu on 2/13/15.
//  Copyright (c) 2015 _Camellia_. All rights reserved.
//

#import "ViewController.h"
//It's fine to import Textxxxx.h here cuz it's part of the ViewController's view
#import "TextStatsViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UITextView *body;
@property (weak, nonatomic) IBOutlet UIButton *outlineButton;

@end

@implementation ViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //If it's wrong, the segue will not work.
    if ([segue.identifier isEqualToString:@"Analyze Text"]) {
        if ([segue.destinationViewController isKindOfClass:[TextStatsViewController class]]) {
            TextStatsViewController *tsvc = (TextStatsViewController *)segue.destinationViewController;
            
            tsvc.textToAnalyze = self.body.textStorage;
            //left: NSAttributedString. right: NSMutableAttributedString. It's ok to asign like this.
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //The last word of the comment above should be changed from nib to storyboard.
    
    //Because the outline button is a onetime changing, we want to make it show as the first time it comes out. So we write it here.
    
    //First init the title.
    //In this way the outline button will be outlined when first init it and will always like that.
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:self.outlineButton.currentTitle];
    [title setAttributes : @{NSStrokeWidthAttributeName : @3,
                             NSStrokeColorAttributeName : self.outlineButton.tintColor}
     //The first element of the range is location. Second is the length.
                    range:NSMakeRange(0, [title length])];
    [self.outlineButton setAttributedTitle: title forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //当你不在听的时候改变东西，然后再开始听，那些那会改变的东西是不会知道的。So we add this one below to sync up to make sure it currently out there.
    [self usePreferredFonts];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredFontsChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //Sometimes you want to add new features but you don't want to stop the radio when the view disappears.
    //So it's better here to specify the name.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name: UIContentSizeCategoryDidChangeNotification
                                                  object: nil];
    
}

- (void)preferredFontsChanged:(NSNotification *)notification
{
    [self usePreferredFonts];
}

- (void)usePreferredFonts
{
    self.body.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.headline.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

- (IBAction)changeBodySelectionToMatchBackgroundOfBtn:(UIButton *)sender {
    [self.body.textStorage addAttribute:NSForegroundColorAttributeName
                                  value:sender.backgroundColor
                                  range:self.body.selectedRange];
}
- (IBAction)changeOutline:(UIButton *)sender {
    [self.body.textStorage addAttributes:@{NSStrokeWidthAttributeName : @-3,//-3means it's been filled. If it's 3, it will not be filled but only outlined.
                                           NSStrokeColorAttributeName : [UIColor blackColor]}
                                   range:self.body.selectedRange];
}
- (IBAction)unoutlineSelected:(UIButton *)sender {
    [self.body.textStorage removeAttribute: NSStrokeWidthAttributeName
                                     range:self.body.selectedRange];
}



@end
