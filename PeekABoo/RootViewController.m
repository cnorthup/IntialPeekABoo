//
//  RootViewController.m
//  PeekABoo
//
//  Created by Charles Northup on 4/3/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//  UserCollectionCellID (reuse ID for collectionview)
//  Table View reuse ID: TableViewCellID

#import "RootViewController.h"
#import "UserColletionViewCell.h"

@interface RootViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    BOOL zoomInMode;
    NSInteger rows;
    NSInteger columns;
    NSArray* users;
    NSArray* photos;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *myUserCollectionView;
//@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *myUserCollectionFlowLayoutView;

@end

@implementation RootViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myUserCollectionFlowLayoutView.itemSize = CGSizeMake(68, 68);
    zoomInMode = NO;
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"users" ofType:@"json"];
   // NSLog(@"%@", path);
   // NSURL* url = [NSURL URLWithString:path];
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"users" withExtension:@"plist"];
    users = [NSArray arrayWithContentsOfURL:url];
    for (NSDictionary* user in users) {
        NSDictionary* currentUser = user;
        NSLog(@"%@", currentUser);
    }
    photos = @[[UIImage imageNamed:@"steve.jpg"], [UIImage imageNamed:@"wave.jpg"]];
//    NSURLRequest* request = [NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSDictionary* users = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
//        NSDictionary* user1 = users[@"User1"];
//        NSLog(@"%@", user1);
//    }];
    
}

#pragma mark -- Collection View Delegate methods
//section rows
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//number of items columns
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return users.count;
}
//cell
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     UserColletionViewCell* cell = (UserColletionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectionCellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.userImage.image = photos[indexPath.row];
    if (!zoomInMode) {
        cell.infoButton.hidden = YES;
    }
    else{
        cell.infoButton.hidden = NO;
    }
    //cell.myTableView.frame = CGRectMake(0, 483, cell.myTableView.frame.size.width, 0);
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    zoomInMode =! zoomInMode;
    if (zoomInMode)
    {
        self.myUserCollectionFlowLayoutView.itemSize = CGSizeMake(275, 483);
        
    }
    else
    {
        self.myUserCollectionFlowLayoutView.itemSize = CGSizeMake(68, 68);
    }
    [self.myUserCollectionView reloadData];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
