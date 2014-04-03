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
    rows = 2;
    columns = 4;
    
}

#pragma mark -- Collection View Delegate methods
//section rows
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return rows;
}
//number of items columns
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return columns;
}
//cell
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     UserColletionViewCell* cell = (UserColletionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectionCellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor darkGrayColor];
    if (!zoomInMode) {
        cell.infoButton.hidden = YES;
        cell.editButton.hidden = YES;
    }
    else{
        cell.infoButton.hidden = NO;
        cell.editButton.hidden = NO;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    zoomInMode =! zoomInMode;
    if (zoomInMode)
    {
        self.myUserCollectionFlowLayoutView.itemSize = CGSizeMake(275, 483);
        rows = 8;
        columns = 1;
        
    }
    else
    {
        self.myUserCollectionFlowLayoutView.itemSize = CGSizeMake(68, 68);
        rows = 2;
        columns = 4;
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
