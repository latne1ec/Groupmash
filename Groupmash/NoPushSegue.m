//
//  NoPushSegue.m
//  Yapster
//
//  Created by Evan Latner on 12/14/14.
//  Copyright (c) 2014 Level Labs. All rights reserved.
//

#import "NoPushSegue.h"

@implementation NoPushSegue

-(void) perform{
    
    UIViewController *vc = self.sourceViewController;
    [vc.navigationController pushViewController:self.destinationViewController animated:NO];
    
}


@end
