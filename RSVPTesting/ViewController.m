//
//  ViewController.m
//  RSVPTesting
//
//  Created by Chris Nowak on 6/16/16.
//  Copyright © 2016 Chris Nowak WORLD, LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flashLabel;
@property (weak, nonatomic) IBOutlet UIButton *readButton;
@property (strong, nonatomic) NSArray *sentences;
@property (strong, nonatomic) NSTimer *flashTimer;
@property NSInteger sentenceCounter;
@property NSInteger wordCounter;
@property (strong, nonatomic) NSDate *readingStartDate;
@property NSInteger flashCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.sentences = @[@[@"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD"],
                       @[@"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD"],
                       @[@"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD"],
                       @[@"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD"],
                       @[@"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD"],
                       @[@"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD"],
                       @[@"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD"],
                       @[@"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD"],
                       @[@"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD"],
                       @[@"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD", @"HELLO", @"WORLD"]
                       ];
    self.sentenceCounter = 0;
    self.wordCounter = 0;
    self.flashCount = 0;
}

#pragma mark - IBActions

-(IBAction)readButtonPressed:(UIButton *)sender {
    sender.hidden = YES;
    int speed = 1000; // words per minute
    NSTimeInterval timeBetweenFlashes = 1/(speed/60.0);
    self.readingStartDate = [NSDate date];
    self.flashTimer = [NSTimer scheduledTimerWithTimeInterval:timeBetweenFlashes target:self selector:@selector(flashText:) userInfo:nil repeats:YES];
}

#pragma mark - Custom Helper Methods

- (void)flashText:(NSTimer *)timer {
    self.flashCount++;
    if ([self canFlash]) {
        // if still flashing through a sentence
        if (self.wordCounter < [self.sentences[self.sentenceCounter] count]) {
            self.flashLabel.text = self.sentences[self.sentenceCounter][self.wordCounter];
            self.wordCounter++;
        }
        //if finished with a sentence, go to the next sentence and start at the first word
        else
        {
            self.sentenceCounter++;
            self.wordCounter = 0;
        }
    }
    else
    {
        [self.flashTimer invalidate];
        self.flashTimer = nil;
        self.readButton.hidden = NO;
        self.sentenceCounter = 0;
        self.wordCounter = 0;
        NSLog(@"FLASH COUNT: %ld", (long)self.flashCount);
        self.flashCount = 0;
        self.flashLabel.text = self.sentences[self.sentenceCounter][self.wordCounter];
        NSTimeInterval readingDuration = [[NSDate date] timeIntervalSinceDate:self.readingStartDate];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Finished" message:[NSString stringWithFormat:@"Text read in %f seconds", readingDuration] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (BOOL)canFlash {
    return self.sentenceCounter < self.sentences.count;
}

@end
