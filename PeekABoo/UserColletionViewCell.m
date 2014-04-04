//
//  UserColletionViewCell.m
//  PeekABoo
//
//  Created by Charles Northup on 4/3/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "UserColletionViewCell.h"
#import "User.h"

@interface UserColletionViewCell()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL infoShown;
}



@end

@implementation UserColletionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)viewDidLoad{
    infoShown = NO;
}

- (IBAction)onInfoButtonPressed:(id)sender {
    
    infoShown =! infoShown;
    if (infoShown) {
        self.userInfoTableView.frame = CGRectMake(0, 244, self.userInfoTableView.frame.size.width, 239);
    }else{
        self.userInfoTableView.frame = CGRectMake(0, 483, self.userInfoTableView.frame.size.width, 0);
    }
    
}

#pragma mark -- 3 Table View Delegate Methods
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    [header.textLabel setAlpha:1.0];
    [header.textLabel setOpaque:NO];
}

//rows
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
//    if (section == 0) {
//        return 2;
//    }
//    else if(section == 1){
//        return 3;
//    }
//    else{
//        return 2;
//    }
}
//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OverlayInfoCellID"];
    

    return cell;
}
//header in section
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    
////    if (section == 0) {
////        
////        return @"Emails";
////    }
////    else if(section == 1){
////        
////        return @"PhoneNumbers";
////    }
////    else{
////        
////        return @"Address";
////    }
//}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    //return 3;
//}


@end
