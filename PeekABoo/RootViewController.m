//
//  RootViewController.m
//  PeekABoo
//
//  Created by Charles Northup on 4/3/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//  UserCollectionCellID (reuse ID for collectionview)
//  Table View reuse ID: TableViewCellID
//http://nees.oregonstate.edu/killer_wave/wave.jpg (Marion's photo)
//https://lh5.googleusercontent.com/-OE73C278Q00/AAAAAAAAAAI/AAAAAAAAAEY/Cvo6f_Kysog/photo.jpg (Steve's photo)

#import "RootViewController.h"
#import "UserColletionViewCell.h"
#import "User.h"

@interface RootViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    BOOL zoomInMode;
    NSInteger rows;
    NSInteger columns;
    NSArray* usersArray;
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
    photos = @[[UIImage imageNamed:@"wave.jpg"], [UIImage imageNamed:@"steve.jpg"]];
    [self load];
}

-(void)load
{
    NSFetchRequest* request = [[NSFetchRequest alloc]initWithEntityName:@"User"];
    usersArray = [self.managedObjectContext executeFetchRequest:request error:nil];

    
    //BOOL isFirstRun = ![[NSUserDefaults standardUserDefaults]boolForKey:@"hasRunOnce"];
    BOOL isFirstRun = YES;
    if (isFirstRun) {
        //userdefaults get written in coredata and stored
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [userdefaults setBool:YES forKey:@"hasRunOnce"];
        [userdefaults synchronize];
        NSURL* url = [[NSBundle mainBundle] URLForResource:@"users" withExtension:@"plist"];
        usersArray = [NSArray arrayWithContentsOfURL:url];
        NSMutableArray *tempArray = [NSMutableArray new];
        for (NSDictionary* currentUser in usersArray) {
            User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
            user.name = currentUser[@"Name"];
            user.personalEmail = currentUser[@"personalEmail"];
            NSLog(@"%@", user.name);
            [tempArray addObject:user];
        }
        usersArray = tempArray;
        [self.managedObjectContext save:nil];
    }
    NSLog(@"%lu", (unsigned long)usersArray.count);
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
    return usersArray.count;

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
