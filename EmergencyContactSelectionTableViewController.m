//
//  EmergencyContactSelectionTableViewController.m
//  ImpactAlert
//
//  Created by sayra arely ysikawa on 20/01/15.
//  Copyright (c) 2015 ImpacAlert. All rights reserved.
//

#import "EmergencyContactSelectionTableViewController.h"
#import "FileManager.h"
#import <AddressBook/AddressBook.h>
#import "Contact.h"
#import "MainConfigurationAndEmergencyContactsContector.h"

@interface EmergencyContactSelectionTableViewController ()

@end

@implementation EmergencyContactSelectionTableViewController

BOOL threadFinished;
BOOL couldInit;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setAllowsMultipleSelection:YES];
    
    threadFinished = NO;
    couldInit = NO;
    [NSThread detachNewThreadSelector:@selector(initContactList) toTarget:self withObject:nil];
    
    [self initContactList];
    self.selectedContacts = [FileManager getEmergencyContacts];
    
    while(!threadFinished); //wait for the thread to finish
    
    if(!couldInit){
        self.contactList = [NSArray new];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"It seems you do not have any contact registered on your phone. Please add some and try again."
                                                        delegate:nil
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles:nil];
        
        [alert show];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)initContactList{
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef rawContacts = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nContacts = ABAddressBookGetPersonCount(addressBook);
    
    if(nContacts < 1){
        threadFinished = YES;
        return;
    }
    
    CFMutableArrayRef sortedContacts = CFArrayCreateMutableCopy(kCFAllocatorDefault,
                                                                 CFArrayGetCount(rawContacts),
                                                                 rawContacts);
    
    CFArraySortValues(sortedContacts,
                      CFRangeMake(0, nContacts),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      (void*) ABPersonGetSortOrdering());
    
    NSMutableArray *contacts = [[NSMutableArray alloc] initWithCapacity:nContacts];
    
    for(int i = 0; i < nContacts; i++){
        ABRecordRef ref = CFArrayGetValueAtIndex(sortedContacts, i);
        
        NSMutableString *name = [NSMutableString new];
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        NSString *middleName = (__bridge NSString *)ABRecordCopyValue(ref, kABPersonMiddleNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty);
        
        if(firstName && ![firstName isEqualToString:@""]){
            [name appendString:firstName];
        }
        
        if(middleName && ![middleName isEqualToString:@""]){
            [name appendString:middleName];
        }
        
        if(lastName && ![lastName isEqualToString:@""]){
            [name appendString:lastName];
        }
        
        [contacts addObject:[[Contact alloc]
            initWithName:name
            numbers:(__bridge NSArray*)ABMultiValueCopyArrayOfAllValues(ABRecordCopyValue(ref, kABPersonPhoneProperty))]];
    }
    
    self.contactList =  contacts;
    
    CFRelease(addressBook);
    CFRelease(rawContacts);
    CFRelease(sortedContacts);
    
    couldInit = YES;
    threadFinished = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.contactList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Contact *contact = (Contact *)[self.contactList objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText: contact.name];
    
    for(int i = 0; i < [self.selectedContacts count]; i++){
        Contact *contactSelected = [self.selectedContacts objectAtIndex:i];
        if([contactSelected.name isEqualToString:contact.name]){
            if(![contactSelected.phoneNumbers isEqual:contact.phoneNumbers]){
                contactSelected.phoneNumbers = contact.phoneNumbers;
            }
            [cell setSelected:YES];
            break;
        }
    }
    
    //[tableView indexPathForSelectedRow].row;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSArray *rows = [self.tableView indexPathsForSelectedRows];
    NSInteger count = [rows count];
    
    NSMutableArray *contactsSelected = [NSMutableArray new];
    
    for(int i = 0; i < count; i++){
        [contactsSelected addObject:[self.contactList objectAtIndex:((NSIndexPath *)[rows objectAtIndex:i]).row]];
    }
    
    [MainConfigurationAndEmergencyContactsContector setReturningFromEmergencyContacts:YES];
    [MainConfigurationAndEmergencyContactsContector setEmergencyContacts:contactsSelected];
}

@end
