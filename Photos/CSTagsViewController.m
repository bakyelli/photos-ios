//
//  CSTagsViewController.m
//  Photos
//
//  Created by Basar Akyelli on 1/31/14.
//  Copyright (c) 2014 Cameron Spickert. All rights reserved.
//

#import "CSTagsViewController.h"
#import "CSPhoto.h"
#import "CSTagsTableViewContentView.h"
#import "CSTagsTableViewCell.h"
#import "CSPhotoDetailViewController.h"

static NSString *const kCSTagCellIdentifier = @"CSTagCellIdentifier";
static NSString *const kCSPhotoCellIdentifier = @"CSPhotoCellIdentifier";


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
    [self.tableView setScrollsToTop:YES];
    [self.tableView setRowHeight:180];
    [self.tableView registerClass:[CSTagsTableViewCell class] forCellReuseIdentifier:kCSTagCellIdentifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPhotoDetailView:) name:@"showPhotoDetailView" object:nil];
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
}

- (void)setupBarButtons
{
    if([self navigationItem].leftBarButtonItem == nil){
        [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(dismissButtonPressed:)]];
    }
}

-(void)showPhotoDetailView:(NSNotification *)notification
{
    CSPhoto *photo = [notification object];
    
    CSPhotoDetailViewController *detailController = [[CSPhotoDetailViewController alloc] initWithPhoto:photo];
    [[self navigationController] pushViewController:detailController animated:YES];

    
}

#pragma mark -
#pragma mark Interface actions

- (void)dismissButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.uniqueTags count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *tag = self.uniqueTags[section];
    if([tag isEqualToString:@""])
    {
        return NSLocalizedString(@"[NO TAGS]", nil);
    }
    else
    {
        return tag;
    }
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSTagsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCSTagCellIdentifier];
    
    NSString *tag = self.uniqueTags[indexPath.section];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY tags == %@",tag];
    NSArray *filteredPhotos = [self.photos filteredArrayUsingPredicate:predicate];
    
    [cell showFilteredPhotos:filteredPhotos];
    
    return cell;
}


@end
