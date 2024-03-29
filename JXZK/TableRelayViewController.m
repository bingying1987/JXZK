//
//  TableRelayViewController.m
//  JXZK
//
//  Created by mac on 13-4-22.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "TableRelayViewController.h"
#import "UIMySwitch.h"
#import "MySocket.h"
@interface TableRelayViewController ()

@end

@implementation TableRelayViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSArray*)RelayData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"StringTableView" ofType:@"plist"];
    NSData *plistData = [NSData dataWithContentsOfFile:path];
    NSString *error;
    NSPropertyListFormat format;
    NSArray* relayData = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    
    if (!relayData) {
        NSLog(@"Failed to read image names");
    }
    return relayData;
}

- (void)viewDidLoad
{
    _relayList = [self RelayData];
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bk.png"]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (!_relayList) {
        NSLog(@"numberOfSectionsInTableView : 0");
        return 0;
    }
    return [_relayList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (!_relayList) {
        NSLog(@"numberOfSectionsInTableView : 0");
        return 0;
    }
    
    if (section >= [_relayList count]) {
        NSLog(@"numberOfRowsInSection out of range : 0");
        return 0;
    }
    
    NSArray *tmp = [_relayList objectAtIndex:section];
    return [tmp count] - 1;
}

- (void)OpenCloseProjector:(UIMySwitch *)sender
{
    int itag = sender.tag;
    
    switch (itag) {
        case 0://投影机1//0xfe,0x08,0x01,0x02,0x00,i,0x00,0x00,0xff,0xff,0xfe
            {
                Byte buf[] = {0xfe,0x08,0x01,0x02,0x00,sender.on?0x01:0x02,0x00,0x00,0xff,0xff,0xfe};
                [[MySocket getInstance] sendto:buf length:sizeof(buf)];
            }
            break;
        case 1://投影机2
            {
                Byte buf[] = {0xfe,0x08,0x01,0x02,0x00,sender.on?0x03:0x04,0x00,0x00,0xff,0xff,0xfe};
                [[MySocket getInstance] sendto:buf length:sizeof(buf)];
            }
        default:
            break;
    }
    
    NSLog(@"Projector");
}

- (void)OpenCloseLight:(UIMySwitch *)sender
{
    int itag = sender.tag;
    
    switch (itag) {
        case 0://灯光回路1
        {
            Byte buf[] = {0xfe,0x08,0x01,0x02,0x00,sender.on?0x07:0x08,0x00,0x00,0xff,0xff,0xfe};
            [[MySocket getInstance] sendto:buf length:sizeof(buf)];
        }
            break;
        case 1://灯光回路2
        {
            Byte buf[] = {0xfe,0x08,0x01,0x02,0x00,sender.on?0x09:0x0A,0x00,0x00,0xff,0xff,0xfe};
            [[MySocket getInstance] sendto:buf length:sizeof(buf)];
        }
        default:
            break;
    }

    NSLog(@"Light");
}

- (void)OpenCloseFuseDevice:(UIMySwitch *)sender
{
    int itag = sender.tag;
    
    switch (itag) {
        case 0://融合器开关1
        {
            Byte buf[] = {0xfe,0x08,0x01,0x02,0x00,0x05,0x00,0x00,0xff,0xff,0xfe};
            [[MySocket getInstance] sendto:buf length:sizeof(buf)];
        }
            break;
        default:
            break;
    }
    NSLog(@"FuseDevice");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSArray *tmp = [_relayList objectAtIndex:section];
    NSString *cellName = [tmp objectAtIndex:row + 1];
    cell.textLabel.text = cellName;
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    
    UIMySwitch *switchView = [[UIMySwitch alloc] initWithFrame:CGRectZero];
    switchView.tag = [indexPath row];

    switch ([indexPath section]) {
        case 0://投影机开关
            [switchView addTarget:self action:@selector(OpenCloseProjector:) forControlEvents:UIControlEventValueChanged];
            cell.imageView.image = [UIImage imageNamed:@"projector.png"];
            break;
        case 1://灯光回路开关
            [switchView addTarget:self action:@selector(OpenCloseLight:) forControlEvents:UIControlEventValueChanged];
            cell.imageView.image = [UIImage imageNamed:@"light.png"];
            break;
        case 2://融合器开关
            [switchView addTarget:self action:@selector(OpenCloseFuseDevice:) forControlEvents:UIControlEventValueChanged];
            cell.imageView.image = [UIImage imageNamed:@"rhq.png"];
        default:
            break;
    }
    
    
    cell.accessoryView = switchView;
    
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
     NSArray *tmp = [_relayList objectAtIndex:section];
    return [tmp objectAtIndex:0];
    
}

/*
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
