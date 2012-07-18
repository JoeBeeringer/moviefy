//
//  RootController.m
//  MOVIEFY
//
//  Created by Maximilian Kreutzer on 18.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootController.h"

@implementation RootController
@synthesize tabBar;

-(void) viewDidLoad{
    [super viewDidLoad];
    
    
}
- (void)viewDidUnload {
    [self setTabBar:nil];
    [super viewDidUnload];
}
@end
