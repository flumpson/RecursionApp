//
//  ViewController.m
//  AppleTest
//
//  Created by Ryan Brandt on 1/24/15.
//  Copyright (c) 2015 Brandt Studios. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textGetter.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

//Returns an NSmutableArray with all the subsets of the input list
//Parameters:input list
- (NSMutableArray*)subsets:(NSMutableArray*)list
                          size:(int)idx
{
    if(idx == 0){
        NSMutableArray *full = [[NSMutableArray alloc]init];
        NSMutableArray *empty = [[NSMutableArray alloc]init];
        [full addObject:[list objectAtIndex:0]];
        NSMutableArray *holder =[[NSMutableArray alloc]init];
        [holder addObject:empty];
        [holder addObject:full];
        return holder;
    }
    NSMutableArray *holder = [self subsets:list size:idx-1];
    NSUInteger length = [holder count];
    
    for (int i = 0; i<length; i++) {
        NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:[holder objectAtIndex:i] copyItems:YES];
        [temp addObject:[list objectAtIndex:idx]];
        [holder addObject:temp];
    }
    return holder;
}

//delegate method that allows for dismissal of the keyboard.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}



//Returns an NSmutableArray with all the permuations of the input string
//Parameters:input string
- (NSMutableArray*)permutations:(NSString*)input{
    NSMutableArray * perms = [[NSMutableArray alloc]init];
    
    if([input length] == 0){
        [perms addObject:@""];
        return perms;
    }
    char first = [input characterAtIndex:0];
    NSString * remainder = [input substringFromIndex:1];
    NSMutableArray * words = [self permutations:remainder];
    for (NSString *obj in words) {
        for (int i = 0; i<=[obj length]; i++) {
            NSString * temp = [self insertCharAtIdx:obj char:first idx:i];
            [perms addObject:temp];
        }
    }
    return perms;
    
}
//Helper method that inserts a char into a string at the specified index
//Returns an NSString
//Parameters:input string, input char, index int
- (NSString*)insertCharAtIdx:(NSString*)string
                        char:(char)c
                         idx:(int)idx{
    NSMutableString * new = [[NSMutableString alloc]initWithString:[string substringToIndex:idx]];
    NSString *temp = [NSString stringWithFormat:@"%c", c];
    [new appendString:temp];
    [new appendString:[string substringFromIndex:idx]];
     return new;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//IBAction that calls subset methods and displays the result on the label
- (IBAction)subsetsButton:(id)sender {
    NSString *text = self.textGetter.text;
    NSMutableArray* input= (NSMutableArray*)[text componentsSeparatedByString: @","];
    
    int count = (int)[input count];
    if(count>12){
        UIAlertView * view = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Input string is too long" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [view show];
        self.textGetter.text = @"";
        return;
    }
    NSLog(@"count of input %d",count);
    
    
    NSMutableArray *output = [self subsets:input size:count-1];
    
    self.label.text =[self convertNestedArraytoString:output];
//    NSLog(@"%@",self.label.text);
    [self.textGetter resignFirstResponder];

}


//IBAction that calls permutation methods and displays the result on the label
- (IBAction)permutationButton:(id)sender {
    NSString *text = self.textGetter.text;
    if([text length]>7){
        UIAlertView * view = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"Input string is too long" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [view show];
        self.textGetter.text = @"";
        return;
    }
    
    NSMutableArray * output = [self permutations:text];
    
    self.label.text = [self convertArraytoString:output];
    [self.textGetter resignFirstResponder];
}

//IBAction that returns the text field to the instructions
- (IBAction)instructions:(id)sender {
    self.label.text = @"Enter in text and press the buttons to calculate either the subsets or the permuations of the input, or the number of ways to make n cents given an unlimited number of quarters, dimes, nickels, and pennys. When using for subsets, use commas to indicate seperate elements.";
}

- (IBAction)changeButton:(id)sender {
    NSString* text = self.textGetter.text;
    
    int num = [text intValue];
    
    
    NSNumber* one = [[NSNumber alloc] initWithInt:25];
    NSNumber* two = [[NSNumber alloc] initWithInt:10];
    NSNumber* three = [[NSNumber alloc] initWithInt:5];
    NSNumber* four = [[NSNumber alloc] initWithInt:1];
    
    NSArray* denoms = [[NSArray alloc]initWithObjects:one,two,three,four, nil];
    
    int ways = [self makeChange:denoms amount:num index:0];
    
    NSLog(@"ways %d",ways);
    
    
    
}




- (int)makeChange:(NSArray*)denoms
                 amount:(int)n
                  index:(NSUInteger)idx{
    if([denoms count]-1<=idx){
        return 1;
    }
    NSNumber* denom = [denoms objectAtIndex:idx];
    int ways = 0;
    NSLog(@"%lu",(unsigned long)idx);
    for (int i = 0; i*denom.intValue<=n; i++) {
        int newAmount = n- i*denom.intValue;
        ways+= [self makeChange:denoms amount:newAmount index:idx+1];
//        NSLog(@"%d",newAmount);
    }
    return ways;
}

//Helper method that takes in an array and returns a string of its contents
//Returns an NSString
//Parameters:input list
-(NSString*)convertArraytoString:(NSMutableArray*)list{
    NSMutableString * holder = [[NSMutableString alloc]init];
    
    for (NSString* word in list) {
        [holder appendString:word];
        [holder appendString:@", "];
    }
    return (NSString*)holder;
}

//Helper method that takes in a nested array and returns a string of its contents
//Returns an NSString
//Parameters:input list
-(NSString*)convertNestedArraytoString:(NSMutableArray*)list{
    
    NSString * temp;
    NSMutableString * holder = [[NSMutableString alloc]init];
    int count = (int)[list count];
//    NSLog(@"%d",count);
    for (int i = 0; i<count; i++) {
        [holder appendString:@"("];
        for (id obj in [list objectAtIndex:i]){
//            NSLog(@"%@",obj);
            temp = [[NSString alloc] initWithString:(NSString*)obj];
            [holder appendString:temp];
            [holder appendString:@", "];
        }
        [holder appendString:@")"];
    }
    return (NSString*)holder;
}
@end
