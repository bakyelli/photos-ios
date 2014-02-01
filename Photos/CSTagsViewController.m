//
//  CSTagsViewController.m
//  Photos
//
//  Created by Basar Akyelli on 1/31/14.
//  Copyright (c) 2014 Cameron Spickert. All rights reserved.
//

#import "CSTagsViewController.h"
#import "CSPhoto.h"

static NSString *const kCSTagCellIdentifier = @"CSTagCellIdentifier";


@interface CSTagsViewController ()

@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableArray *uniqueTags;
@end

@implementation CSTagsViewController

- (id)initWithPhotos:(NSMutableArray *)photos
{
    self = [super init];
    
    if(self)
    {
        _photos = photos;
        [self prepareUniqueTags];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:kCSTagCellIdentifier];
    [self setTitle:@"Browse Photos by Tags"];
    [self setupBarButtons];
}

#pragma mark - 
#pragma mark View controller methods

- (void)prepareUniqueTags
{
    self.uniqueTags = [NSMutableArray new];
    
    for(CSPhoto *photo in self.photos)
    {
        for(NSString *tag in photo.tags)
        {
            if(![self.uniqueTags containsObject:tag] && [tag rangeOfString:@"="].location == NSNotFound)
            {
                [self.uniqueTags addObject:tag];
                
            }
        }
    }
    
    NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [self.uniqueTags sortUsingDescriptors:[NSArray arrayWithObject:lowestToHighest]];

    NSLog(@"%@", self.uniqueTags);
}

- (void)setupBarButtons
{
    if([self navigationItem].leftBarButtonItem == nil){
        [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(dismissButtonPressed:)]];
    }
}

#pragma mark -
#pragma mark Interface actions

- (void)dismissButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.uniqueTags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCSTagCellIdentifier forIndexPath:indexPath];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCSTagCellIdentifier];
    }
    cell.textLabel.text = self.uniqueTags[indexPath.row];
    
    return cell;
}

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
