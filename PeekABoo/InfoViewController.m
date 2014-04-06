//
//  InfoViewController.m
//  PeekABoo
//
//  Created by Charles Northup on 4/3/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "InfoViewController.h"
#import "MapViewController.h"
#import "PhotoViewController.h"
#import "WebViewController.h"


@interface InfoViewController ()<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
{
    BOOL editModeEnabled;
}
@property (weak, nonatomic) IBOutlet InfoTableView *myTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *myToolBar;
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property User* editedUser;
@property NSIndexPath* selectedRow;
@property NSURL* url;


@end

@implementation InfoViewController


- (void)viewDidLoad
{
    self.editedUser = self.myUser;
    [super viewDidLoad];
    editModeEnabled = NO;
    self.myTableView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -- 3 Table View Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 2;
//    }
//    else if(section == 1){
//        return 3;
//    }
//    else{
//        return 2;
//    }
    return 11;
}
//cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellID"];
    InfoTableView *tv = (InfoTableView *)tableView;
    tv.userObject = self.editedUser;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = tv.userObject.name;
            cell.detailTextLabel.text = @"Name";
            break;
        case 1:
            cell.textLabel.text = tv.userObject.workEmail;
            cell.detailTextLabel.text = @"Work Email";
            break;
        case 2:
            cell.textLabel.text = tv.userObject.personalEmail;
            cell.detailTextLabel.text = @"Personal Email";
            break;
        case 3:
            cell.textLabel.text = tv.userObject.workAddress;
            cell.detailTextLabel.text = @"Work Address";
            break;
        case 4:
            cell.textLabel.text = tv.userObject.homeAddress;
            cell.detailTextLabel.text = @"Home Address";
            break;
        case 5:
            cell.textLabel.text = tv.userObject.cellNumber;
            cell.detailTextLabel.text = @"Cell Number";
            break;
        case 6:
            cell.textLabel.text = tv.userObject.workNumber;
            cell.detailTextLabel.text = @"Work Number";
            break;
        case 7:
            cell.textLabel.text = tv.userObject.homeNumber;
            cell.detailTextLabel.text = @"Home Number";
            break;
        case 8:
            cell.textLabel.text = tv.userObject.github;
            cell.detailTextLabel.text = @"GitHub Username";
            break;
        case 9:
            cell.textLabel.text = tv.userObject.blog;
            cell.detailTextLabel.text = @"Blog";
            break;
        case 10:
            cell.textLabel.text = @"Photo";
            cell.detailTextLabel.text = @"";
            break;
            
        default:
            break;
    }
    
//    switch (indexPath.section) {
//        case 0:
//            switch (indexPath.row) {
//                case 0:
//                    cell.textLabel.text = tv.userObject.name;
//                    break;
//                    
//                default:
//                    break;
//            }
//            break;
//            
//        case 1:
//            switch (indexPath.row) {
//                case 0:
//                    cell.textLabel.text = tv.userObject.personalEmail;
//                    break;
//                    
//                default:
//                    break;
//            }
//            break;
//            
//        default:
//            break;
//    }
    
    
    
    return cell;
}
//header in section
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"Emails";
//    }
//    else if(section == 1){
//        return @"PhoneNumbers";
//    }
//    else{
//        return @"Address";
//    }
//}

//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 3;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];

    if (editModeEnabled) {
        if (indexPath.row != 10) {
            self.selectedRow = indexPath;
            self.myToolBar.hidden = NO;
            self.myToolBar.center = CGPointMake(cell.center.x, cell.center.y + 64);
            self.myTextField.text = cell.textLabel.text;
        }
        else{
            self.myToolBar.hidden = YES;

            [self performSegueWithIdentifier:@"PhotoSegue" sender:cell];
        }
        
    }
    else{
        if (indexPath.row == 3) {
            [self performSegueWithIdentifier:@"AddressSegue" sender:cell];
        }
        else if(indexPath.row == 4){
            [self performSegueWithIdentifier:@"AddressSegue" sender:cell];
        }
        else if (indexPath.row == 8){
            [self performSegueWithIdentifier:@"WebSegue" sender:cell];
            self.url = [NSURL URLWithString:[NSString stringWithFormat:@"https://github.com/%@", cell.textLabel.text]];

        }
        else if (indexPath.row == 9){
            [self performSegueWithIdentifier:@"WebSegue" sender:cell];
            self.url = [NSURL URLWithString:cell.textLabel.text];
        }
    }
}



- (IBAction)onSaveButtonPressed:(id)sender {
    
    
    self.editedUser = self.myUser;
    switch (self.selectedRow.row) {
        case 0:
            self.editedUser.name = self.myTextField.text;
            break;
        case 1:
            self.editedUser.workEmail = self.myTextField.text;
            break;
        case 2:
            self.editedUser.personalEmail = self.myTextField.text;
            break;
        case 3:
            self.editedUser.workAddress = self.myTextField.text;
            break;
        case 4:
            self.editedUser.homeAddress = self.myTextField.text;
            break;
        case 5:
            self.editedUser.cellNumber = self.myTextField.text;
            break;
        case 6:
            self.editedUser.workNumber = self.myTextField.text;
            break;
        case 7:
            self.editedUser.homeNumber = self.myTextField.text;
            break;
        case 8:
            self.editedUser.github = self.myTextField.text;
            break;
        case 9:
            self.editedUser.blog = self.myTextField.text;
            break;
            
            
        default:
            break;
    }
    [self.myTextField endEditing:YES];
    self.myToolBar.hidden = YES;
    self.myUser = self.editedUser;
    [self.myTableView reloadData];
    [self.editMOC save:nil];
}
#pragma mark -- NSFecthedResultsControllerDelegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.myTableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.myTableView endUpdates];
}

- (IBAction)onEditPressed:(UIBarButtonItem*) realEditButton
{
    editModeEnabled =! editModeEnabled;
    if (editModeEnabled) {
        [realEditButton setTitle:@"Done"];
    }
    else
    {
        self.myToolBar.hidden = YES;
        self.myUser = self.editedUser;
        [self.myTableView reloadData];
        [self.editMOC save:nil];
        [realEditButton setTitle:@"Edit"];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UITableViewCell* cell = (UITableViewCell*) sender;
    if ([segue.identifier isEqualToString:@"PhotoSegue"]) {
        PhotoViewController* pVC = segue.destinationViewController;
        pVC.photo = self.editedUser.photo;
    }
    else if ([segue.identifier isEqualToString:@"WebSegue"]){
        WebViewController* wVC = segue.destinationViewController;
        wVC.url = self.url;
        
    }
    else if ([segue.identifier isEqualToString:@"AddUserUnwind"]){
        self.myUser = self.editedUser;
        NSLog(@"%@", self.editedUser);
    }
    else{
    MapViewController* mVC = segue.destinationViewController;
    mVC.address = cell.textLabel.text;
    }
}

-(IBAction)addPhoto:(UIStoryboardSegue *)segue sender:(id)sender{
    PhotoViewController* pVC = segue.sourceViewController;
    self.editedUser.photo = pVC.photo;
    [self.editMOC save:nil];
    [self.myTableView reloadData];
}




@end
