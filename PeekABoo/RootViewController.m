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
#import "InfoViewController.h"

@interface RootViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    BOOL zoomInMode;
    NSInteger rows;
    NSInteger columns;
    NSArray* usersArray;
    NSArray* photos;
    NSIndexPath* path;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *myUserCollectionView;
//@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *myUserCollectionFlowLayoutView;

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myUserCollectionFlowLayoutView.itemSize = CGSizeMake(68, 68);
    zoomInMode = NO;
    photos = @[[UIImage imageNamed:@"wave.jpg"], [UIImage imageNamed:@"steve.jpg"]];
    
    [self load];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (zoomInMode) {
        [self.myUserCollectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

-(void)load
{
    NSFetchRequest* request = [[NSFetchRequest alloc]initWithEntityName:@"User"];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    usersArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    BOOL isFirstRun = ![[NSUserDefaults standardUserDefaults]boolForKey:@"hasRunOnce"];
    
    // Will pull from Core Data
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
            user.personalEmail = currentUser[@"Personal Email"];
            user.cellNumber = currentUser[@"Cell Number"];
            user.homeAddress = currentUser[@"Home Address"];
            user.homeNumber = currentUser[@"Home Number"];
            user.photo = [self getPhotos:[NSURL URLWithString:currentUser[@"Photo"]]];
            user.workAddress = currentUser[@"Work Address"];
            user.workEmail = currentUser[@"Work Email"];
            user.workNumber = currentUser[@"Work Number"];
            user.blog = currentUser[@"Blog"];
            user.github = currentUser[@"Github"];
            NSLog(@"%@", user.name);
            [tempArray addObject:user];
        }
        usersArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(User* obj1, User* obj2) {
            NSString* name1 = obj1.name;
            NSString* name2 = obj2.name;
            if ([name1 compare:name2 options:NSCaseInsensitiveSearch] == NSOrderedAscending) {
                return NSOrderedAscending;
            }
            else if([name1 compare:name2 options:NSCaseInsensitiveSearch] == NSOrderedDescending){
                return NSOrderedDescending;
            }
            else{
                return NSOrderedSame;
            }
            
        }];
        [self.managedObjectContext save:nil];
    }
    NSLog(@"%lu", (unsigned long)usersArray.count);
    
}

#pragma mark -- Collection View Delegate methods
//section rows
//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
//number of items columns
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return usersArray.count;

}
//cell

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     UserColletionViewCell* cell = (UserColletionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"UserCollectionCellID" forIndexPath:indexPath];
    
    cell.userInfoTableView.userObject = usersArray[indexPath.row];
    cell.backgroundColor = [UIColor darkGrayColor];
    //cell.userImage.image = photos[indexPath.row];
    cell.userImage.image = cell.userInfoTableView.userObject.photo;
    if (!zoomInMode) {
        cell.infoButton.hidden = YES;
        cell.fakeEditButton.hidden = YES;
    }
    else{
        cell.infoButton.hidden = NO;
        cell.fakeEditButton.hidden = NO;

    }
    //cell.myTableView.frame = CGRectMake(0, 483, cell.myTableView.frame.size.width, 0);
    
    [cell.userInfoTableView reloadData];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    zoomInMode =! zoomInMode;
    if (zoomInMode)
    {
        
        self.myUserCollectionFlowLayoutView.itemSize = CGSizeMake(275, 483);
        CGFloat y = (indexPath.row * 489) - 66;
        CGPoint point = CGPointMake(0, y);
        [self.myUserCollectionView setContentOffset:point animated:YES];

    }
    else
    {
        self.myUserCollectionFlowLayoutView.itemSize = CGSizeMake(68, 68);
        UserColletionViewCell* cell = (UserColletionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        NSLog(@"%f", cell.frame.origin.y);
//        self.myUserCollectionFlowLayoutView.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    [self.myUserCollectionView reloadData];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    InfoViewController* ivc = segue.destinationViewController;
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        
    }
    else{
        UserColletionViewCell* cell = (UserColletionViewCell*)[[sender superview] superview];
        UICollectionView* collectionView = (UICollectionView*)[[[sender superview] superview] superview];
        NSIndexPath* indexPath = [collectionView indexPathForCell:cell];

        ivc.myUser = [usersArray objectAtIndex:indexPath.row];
        ivc.editMOC = self.managedObjectContext;
    }
    [UIView animateWithDuration:2.0 animations:^{
    }];
    
}

-(UIImage*) getPhotos:(NSURL*) url{
    
    NSData* data = [NSData dataWithContentsOfURL:url];
    UIImage* image = [UIImage imageWithData:data];
    return image;
}

@end
