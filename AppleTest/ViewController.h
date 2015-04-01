//
//  ViewController.h
//  AppleTest
//
//  Created by Ryan Brandt on 1/24/15.
//  Copyright (c) 2015 Brandt Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextView *label;
@property (weak, nonatomic) IBOutlet UITextField *textGetter;



- (NSString*)convertArraytoString:(NSMutableArray*)list;
- (NSMutableArray*)subsets:(NSMutableArray*)list
                      size:(int)idx;
- (NSMutableArray*)permutations:(NSString*)input;
- (NSString*)insertCharAtIdx:(NSString*)string
                        char:(char)c
                         idx:(int)idx;
- (NSString*)convertNestedArraytoString:(NSMutableArray*)list;

- (IBAction)subsetsButton:(id)sender;
- (IBAction)permutationButton:(id)sender;
- (IBAction)instructions:(id)sender;
- (IBAction)changeButton:(id)sender;

@end

